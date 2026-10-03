local FileScanner = require("src.ui.file_scanner")
local GameManager = require("src.game_manager")

local ExplorerOverlay = {
  visible = false,
  currentDir = "GAME ASSETS (SELF-DESTRUCT VAULT)",
  files = {},
  selectedIndex = 1,
  font = nil
}

function ExplorerOverlay.init()
  ExplorerOverlay.refresh()
  ExplorerOverlay.font = love.graphics.newFont(18)
end

function ExplorerOverlay.refresh()
  ExplorerOverlay.files = FileScanner.listGameAssets()
  ExplorerOverlay.selectedIndex = 1
end

function ExplorerOverlay.draw()
  if not ExplorerOverlay.visible then return end

  local w, h = love.graphics.getWidth(), love.graphics.getHeight()

  -- Dim background overlay
  love.graphics.setColor(0, 0, 0, 0.75)
  love.graphics.rectangle("fill", 0, 0, w, h)

  -- Window Frame
  local winW, winH = w * 0.7, h * 0.75
  local winX, winY = (w - winW) / 2, (h - winH) / 2

  -- Window Border & Header
  love.graphics.setColor(0.18, 0.12, 0.28)
  love.graphics.rectangle("fill", winX, winY, winW, winH, 8, 8)

  love.graphics.setColor(0.28, 0.18, 0.42)
  love.graphics.rectangle("fill", winX, winY, winW, 45, 8, 8)

  -- Title
  love.graphics.setFont(ExplorerOverlay.font)
  love.graphics.setColor(1, 0.84, 0)
  love.graphics.print("GAME ASSET VAULT - SELECT SACRIFICE", winX + 20, winY + 12)

  -- Path Bar
  love.graphics.setColor(0.1, 0.07, 0.15)
  love.graphics.rectangle("fill", winX + 15, winY + 55, winW - 30, 35)
  love.graphics.setColor(0.7, 0.7, 0.8)
  love.graphics.print("TARGET: " .. ExplorerOverlay.currentDir, winX + 25, winY + 62)

  -- File List
  local listY = winY + 100
  local itemHeight = 35
  local maxVisible = math.floor((winH - 160) / itemHeight)

  for i = 1, math.min(#ExplorerOverlay.files, maxVisible) do
    local file = ExplorerOverlay.files[i]
    local itemY = listY + (i - 1) * itemHeight

    -- Highlight selected item
    if i == ExplorerOverlay.selectedIndex then
      love.graphics.setColor(0.4, 0.2, 0.6, 0.8)
      love.graphics.rectangle("fill", winX + 15, itemY, winW - 30, itemHeight - 2)
    else
      love.graphics.setColor(0.14, 0.1, 0.2, 0.5)
      love.graphics.rectangle("fill", winX + 15, itemY, winW - 30, itemHeight - 2)
    end

    -- File Name + Type
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("[" .. file.assetType .. "] " .. file.name, winX + 25, itemY + 6)

    -- Size
    love.graphics.setColor(0.6, 0.8, 1)
    love.graphics.print(file.sizeMB, winX + winW - 220, itemY + 6)

    -- Multiplier Badge
    love.graphics.setColor(1, 0.84, 0)
    love.graphics.print("x" .. file.multiplier, winX + winW - 80, itemY + 6)
  end

  -- Controls Footer
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.print("[UP/DOWN] Navigate   |   [ENTER] Select Collateral   |   [ESC] Cancel", winX + 20,
    winY + winH - 35)
end

function ExplorerOverlay.keypressed(key)
  if not ExplorerOverlay.visible then return end

  if key == "up" then
    ExplorerOverlay.selectedIndex = math.max(1, ExplorerOverlay.selectedIndex - 1)
  elseif key == "down" then
    ExplorerOverlay.selectedIndex = math.min(#ExplorerOverlay.files, ExplorerOverlay.selectedIndex + 1)
  elseif key == "return" then
    local selected = ExplorerOverlay.files[ExplorerOverlay.selectedIndex]
    if selected then
      GameManager.attachCollateral(selected)
      ExplorerOverlay.visible = false
      GameManager.state = "TUTORIAL"
    end
  elseif key == "escape" then
    ExplorerOverlay.visible = false
    GameManager.state = "TUTORIAL"
  end
end

return ExplorerOverlay
