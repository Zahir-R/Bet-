local Vault = {}

local ENCRYPTION_KEY = "LOVE_GAMBLING"

function Vault.getVaultPath()
  local dir = love.filesystem.getSaveDirectory() .. "/.vault"
  love.filesystem.createDirectory(".vault")
  return dir
end

function Vault.cipher(data, key)
  local result = {}
  local keyLen = #key
  for i = 1, #data do
    local byte = string.byte(data, i)
    local keyByte = string.byte(key, ((i - 1) % keyLen) + 1)
    table.insert(result, string.char(bit.bxor(byte, keyByte)))
  end
  return table.concat(result)
end

function Vault.lockFile(originalPath, fileName)
  local inFile = io.open(originalPath, "rb")
  if not inFile then return false, "Cannot read file" end

  local content = inFile:read("*all")
  inFile:close()

  local encryptedData = Vault.cipher(content, ENCRYPTION_KEY)
  local fileId = os.time() .. "_" .. math.random(1000, 9999)
  local vaultDirPath = Vault.getVaultPath()
  local targetDataPath = vaultDirPath .. "/" .. fileId .. ".dat"
  local targetMetaPath = vaultDirPath .. "/" .. fileId .. ".meta"

  local outFile = io.open(targetDataPath, "wb")
  if not outFile then return false, "Cannot write to vault" end

  outFile:write(encryptedData)
  outFile:close()

  local metaFile = io.open(targetMetaPath, "w")
  if metaFile then
    metaFile:write(originalPath .. "\n" .. fileName)
    metaFile:close()
  end

  os.remove(originalPath)
  return true, fileId
end

function Vault.restoreFile(fileId)
  local vaultDirPath = Vault.getVaultPath()
  local targetDataPath = vaultDirPath .. "/" .. fileId .. ".dat"
  local targetMetaPath = vaultDirPath .. "/" .. fileId .. ".meta"

  local metaFile = io.open(targetMetaPath, "r")
  if not metaFile then return false, "Metadata missing" end
  local originalPath = metaFile:read("*line")
  metaFile:close()

  local inFile = io.open(targetDataPath, "rb")
  if not inFile then return false, "Vault file unreadable" end
  local encryptedContent = inFile:read("*all")
  inFile:close()

  local decryptedData = Vault.cipher(encryptedContent, ENCRYPTION_KEY)

  local outFile = io.open(originalPath, "wb")
  if not outFile then return false, "Destination path invalid or restricted" end
  outFile:write(decryptedData)
  outFile:close()

  os.remove(targetDataPath)
  os.remove(targetMetaPath)

  return true, originalPath
end

return Vault
