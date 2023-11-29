-- Requirements
local display = require("display")
local native = require("native")
local widget = require("widget")
local ColorConversion = require("lib.ColorConversion")

-- Module
GameHUD = {}

function GameHUD.new(player, in_sceneGroup)
    local Self = {}
    
    -- Variables
    Self.Player = player
    Self.Score = 0
    local sceneGroup = in_sceneGroup
    local textMove = false
    local textMove2 = false

    -- Background
    local rect = display.newRect(sceneGroup, display.contentCenterX, 20, display.actualContentWidth, 90)
    rect:setFillColor(ColorConversion.HexToNorm("#708090"))

    -- Health Text
    local healthText = display.newText(sceneGroup, "Health: " .. Self.Player.CurrentHealthPoints .. "/" .. 
                            Self.Player.MaxHealthPoints, display.contentWidth - 40, 35, native.systemFont, 40)

    -- Score Text
    local scoreText = display.newText(sceneGroup, "Score: " .. Self.Score, 40, 35, native.systemFont, 40)

    -- King Bayonet Health Bar
    local healthBar = nil
    local disableSlider = nil

    function Self:UpdateHealthBar()
        healthText.text = "Health: " .. Self.Player.CurrentHealthPoints .. "/" .. Self.Player.MaxHealthPoints
    end

    function Self:UpdateScore(newScore)
        Self.Score = Self.Score + newScore
        scoreText.text = "Score: " .. Self.Score
        if string.len(scoreText.text) >= 12 and textMove == false then
            scoreText.x = scoreText.x + 50
            textMove = true
        elseif string.len(scoreText.text) >= 11 and textMove2 == false then
            scoreText.x = scoreText.x + 20
            textMove2 = true
        end
    end

    function Self:UpdateBayonetHealthBar(health)
        if healthBar == nil then
            healthBar = widget.newSlider(
                {
                    x = display.contentCenterX,
                    y = 30,
                    width = 500,
                    height = 10,
                    value =  (health / 30) * 100,
                    isEnable = false,
                }
            )

            -- Prevent the player from messing with the bar.
            -- This is a hacky solution, but it works.
            -- By hiding the rect with a transparent color, and setting an listener that does nothing.
            disableSlider = display.newRect(display.contentCenterX, 30, 550, 40)
            disableSlider:setFillColor(1, 1, 1, 0.01)
            disableSlider:addEventListener("touch", function(event) return true end)
        elseif healthBar ~= nil then
            if health <= 0 and disableSlider then
                healthBar:removeSelf()
                healthBar = nil

                disableSlider:removeEventListener("touch", function(event) return true end)
                disableSlider:removeSelf()
                disableSlider = nil
                return
            end
            healthBar:setValue( (health / 30) * 100 )
        end
    end

    return Self
end

return GameHUD