local AutoDestruct = require("src.engine.autodestruct")

local GameManager = {
  state = "TUTORIAL",
  playerChips = 500,
  debtRemaining = 50000,
  playerHealth = 100,
  currentCollateral = nil
}

-- Fixes the nil error in love.load()
function GameManager.init()
  GameManager.state = "TUTORIAL"
  GameManager.playerChips = 500
  GameManager.debtRemaining = 50000
  GameManager.playerHealth = 100
  GameManager.currentCollateral = nil
  print("[GAME_MANAGER]: Initialized successfully.")
end

-- Supports both object tables AND loose arguments from ExplorerOverlay
function GameManager.attachCollateral(pathOrTable, name, size, multiplier)
  if type(pathOrTable) == "table" then
    GameManager.currentCollateral = pathOrTable
  else
    GameManager.currentCollateral = {
      path = pathOrTable,
      relativePath = pathOrTable,
      name = name or "Unknown Asset",
      size = size or 0,
      multiplier = multiplier or 1,
      assetType = (name and name:match("%.lua$")) and "CODE" or "SPRITE"
    }
  end
  print("[GAME_MANAGER]: Attached collateral -> " .. GameManager.currentCollateral.name)
end

function GameManager.resolveBet(won, baseWager)
  local col = GameManager.currentCollateral
  local mult = col and col.multiplier or 1

  if won then
    local payout = baseWager * mult
    GameManager.playerChips = GameManager.playerChips + payout
    print("[GAME]: WIN! Earned $" .. payout)
  else
    GameManager.playerChips = math.max(0, GameManager.playerChips - baseWager)

    -- Autodestruct / Sacrifice attached game asset on loss
    if col then
      AutoDestruct.destroyAsset(col)
      print("[GAME]: LOSS! Asset sacrificed: " .. col.name)
      GameManager.currentCollateral = nil
    end
  end
end

return GameManager
