local GameManager = require "src.game_manager"
local Layout = require "src.ui.layout"
local ExplorerOverlay = require "src.ui.explorer_overlay"

local mainFont, titleFont, hudFont

function love.load()
  love.graphics.setDefaultFilter("linear", "linear")

  hudFont = love.graphics.newFont(20)
  mainFont = love.graphics.newFont(26)
  titleFont = love.graphics.newFont(54)
  GameManager.init()
  ExplorerOverlay.init()
end

function love.update(dt)
  -- TODO: Updates
end

function love.draw()
  local w, h = Layout.getDimensions()

  love.graphics.clear(0.07, 0.04, 0.12)

  -- HUD
  love.graphics.setColor(0.12, 0.08, 0.20)
  love.graphics.rectangle("fill", 0, 0, w, 80)

  love.graphics.setColor(0.28, 0.18, 0.42)
  love.graphics.setLineWidth(2)
  love.graphics.line(0, 80, w, 80)

  love.graphics.setFont(hudFont)
  love.graphics.setColor(1, 0.84, 0)
  love.graphics.print("DEBT: $" ..
    -- string.format("%'d",
    GameManager.debtRemaining
    --)
    , 30, 25)

  love.graphics.setColor(0.2, 0.9, 0.4)
  love.graphics.print("CHIPS: " .. --
    --string.format("%'d",
    GameManager.playerChips
    --)
    , w / 2 - 100, 25)

  love.graphics.setColor(1, 0.2, 0.4)
  love.graphics.print("HEALTH: " .. GameManager.playerHealth .. "%", w - 220, 25)

  if GameManager.currentCollateral then
    love.graphics.setColor(0.15, 0.1, 0.25)
    love.graphics.rectangle("fill", 30, 95, w - 60, 40, 6, 6)
    love.graphics.setColor(0.2, 0.8, 1)
    local colInfo = string.format("LOCKED COLLATERAL: %s (%s) | MULTIPLIER: x%d",
      GameManager.currentCollateral.name,
      string.format("%.2f MB", GameManager.currentCollateral.size / (1024 * 1024)),
      GameManager.currentCollateral.multiplier
    )
    love.graphics.print(colInfo, 45, 104)
  end

  love.graphics.setFont(titleFont)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("BET!", 0, h * 0.35, w, "center")

  love.graphics.setFont(mainFont)
  if GameManager.state == "TUTORIAL" then
    love.graphics.setColor(0.85, 0.85, 0.9)
    love.graphics.printf("Press [SPACE] to Spin ($10 Bet)\nPress [E] to Open Collateral File Vault", 0, h * 0.52, w,
      "center")
  elseif GameManager.state == "EXPLORER" then
    love.graphics.setColor(0.6, 0.6, 0.7)
    love.graphics.printf("Browsing File Vault...", 0, h * 0.52, w, "center")
  end

  ExplorerOverlay.draw()
end

function love.keypressed(key)
  if ExplorerOverlay.visible then
    ExplorerOverlay.keypressed(key)
    return
  end
  if key == "escape" then
    love.event.quit()
  elseif key == "space" and GameManager.state == "TUTORIAL" then
    local won = math.random() > 0.40
    GameManager.resolveBet(won, 10)
  elseif key == "e" then
    GameManager.state = "EXPLORER"
    ExplorerOverlay.visible = true
    ExplorerOverlay.refresh()
  end
end
