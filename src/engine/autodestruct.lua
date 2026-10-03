local AutoDestruct = {
  corruptedFiles = {}
}

local fallbackImageData = love.image.newImageData(32, 32)
for x = 0, 31 do
  for y = 0, 31 do
    if (math.floor(x / 8) + math.floor(y / 8)) % 2 == 0 then
      fallbackImageData:setPixel(x, y, 1, 0, 0.5, 1)
    else
      fallbackImageData:setPixel(x, y, 0.05, 0.05, 0.05, 1)
    end
  end
end

AutoDestruct.fallbackTexture = love.graphics.newImage(fallbackImageData)

function AutoDestruct.destroyAsset(asset)
  AutoDestruct.corruptedFiles[asset.relativePath] = true

  if asset.assetType == "CODE" or asset.assetType == "DATA" then
    local fullPath = love.filesystem.getSaveDirectory() .. "/" .. asset.relativePath
    local file = io.open(asset.relativePath, "w")
    if file then
      file:write("-- [GLITCH_ERR]: THIS MODULE WAS GAMBLED AND LOST.\n")
      file:write("return { corrupted = true }\n")
      file:close()
    end
  else
    love.filesystem.remove(asset.relativePath)
  end
  print("[AUTODESTRUCT]: Successfully destroyed " .. asset.relativePath)
end

function AutoDestruct.getTexture(path)
  if AutoDestruct.corruptedFiles[path] or not love.filesystem.getInfo(path) then
    return AutoDestruct.fallbackTexture
  end
  return love.graphics.newImage(path)
end

return AutoDestruct
