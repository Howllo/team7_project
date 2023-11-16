-- Requirements
local display = require("display")
local native = require("native")
local ColorConversion = require("lib.ColorConversion")

-- Module
GameHUD = {}

function GameHUD.new(player, sceneGroup)
    local Self = {}
    
    -- Variables
    Self.Player = player
    Self.Score = 0

    -- Background
    local rect = display.newRect(sceneGroup, display.contentCenterX, 20, display.actualContentWidth, 90)
    rect:setFillColor(ColorConversion.HexToNorm("#708090"))

    -- Health Text
    local healthText = display.newText(sceneGroup, "Health: " .. Self.Player.CurrentHealthPoints .. "/" .. 
                            Self.Player.MaxHealthPoints, display.contentWidth - 40, 35, native.systemFont, 40)

    -- Score Text
    local scoreText = display.newText(sceneGroup, "Score: " .. Self.Score, 40, 35, native.systemFont, 40)

    function Self:UpdateHealthBar()
        healthText.text = "Health: " .. Self.Player.CurrentHealthPoints .. "/" .. Self.Player.MaxHealthPoints
    end

    function Self:UpdateScore(newScore)
        Self.Score = Self.Score + newScore
        scoreText.text = "Score: " .. Self.Score
        if string.len(scoreText.text) >= 11 then
            scoreText.x = scoreText.x + 50
        end
    end

    return Self
end

return GameHUD