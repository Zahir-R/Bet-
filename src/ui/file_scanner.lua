-- src/ui/file_scanner.lua
local FileScanner = {}

function FileScanner.listGameAssets()
  local items = {}
  local scanFolders = { "assets/images", "assets/audio", "assets/fonts", "src/data", "src/ui" }

  for _, folder in ipairs(scanFolders) do
    local files = love.filesystem.getDirectoryItems(folder)
    if files then
      for _, filename in ipairs(files) do
        local relativePath = folder .. "/" .. filename
        local info = love.filesystem.getInfo(relativePath)

        if info and info.type == "file" then
          local assetType = "DATA"
          if filename:match("%.png$") or filename:match("%.jpg$") then
            assetType = "SPRITE"
          elseif filename:match("%.ogg$") or filename:match("%.wav$") then
            assetType = "AUDIO"
          elseif filename:match("%.lua$") or filename:match("%.json$") then
            assetType = "CODE"
          end

          table.insert(items, {
            name = filename,
            folder = folder,
            path = relativePath,
            relativePath = relativePath,
            assetType = assetType,
            size = info.size or 1024,
            sizeMB = string.format("%.1f KB", (info.size or 1024) / 1024),
            multiplier = FileScanner.calculateMultiplier(info.size or 1024, assetType)
          })
        end
      end
    end
  end

  return items
end

function FileScanner.calculateMultiplier(bytes, assetType)
  local base = (assetType == "CODE") and 20 or (assetType == "AUDIO" and 10 or 5)
  return base + math.floor(bytes / 2048)
end

return FileScanner
