-- Requirements
local display = require("display")
local native = require("native")

-- Module
GameHUD = {}

function GameHUD.new(player, sceneGroup)
    local Self = {}

    -- Variables
    Self.Player = player
    Self.Score = 0
    local healthText = display.newText(sceneGroup, "Health: " .. Self.Player.CurrentHealthPoints .. "/" .. Self.Player.MaxHealthPoints, display.contentWidth - 10, 45,
                        native.systemFont, 40)
    local scoreText = display.newText(sceneGroup, "Score: " .. Self.Score, 15, 45, native.systemFont, 40)

    function Self:UpdateHealthBar()
        healthText.text = "Health: " .. Self.Player.CurrentHealthPoints .. "/" .. Self.Player.MaxHealthPoints
    end

    function Self:UpdateScore(newScore)
        Self.Score = Self.Score + newScore
        scoreText.text = "Score: " .. Self.Score
    end

    return Self
end

return GameHUD