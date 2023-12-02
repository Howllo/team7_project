-- Requirements
local display = require("display")
local native = require("native")
local widget = require("widget")
local ColorConversion = require("lib.ColorConversion")
local ColConv = require("lib.ColorConversion")
local composer = require("composer")
local SoundManager = require("src.scene.SoundManager")

-- Module
GameHUD = {}

function GameHUD.new(player, in_sceneGroup, scene)
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

    -- Background
    local background = display.newRect(sceneGroup, display.contentCenterX, 30, 2000, 2000)
    background:setFillColor(0, 0, 0, 0.3)
    background.isVisible = false

    -- King Bayonet Health Bar
    local healthBar = nil
    local disableSlider = nil

    local function HandleButtonEvent(event)
        if ( "ended" == event.phase ) then
            SoundManager:stopAudioChannel(3, true, 600)
            SoundManager:stopAudioChannel(11, true, 600)
            SoundManager:playSound("gameOverUI", 3, 0.4, 0)

            background.isVisible = false

            composer.gotoScene("src.scene.TitleScreen", {effect = "fade", time = 1000})
        end
    end

    --exit/main menu button
    local exitButton = widget.newButton(
        {
            label = "GAME OVER",
            emboss = false,
            shape = "roundedRect",
            x = display.contentCenterX,
            y = display.contentCenterY,
            width = 225,
            height = 100,
            cornerRadius = 15,
            fontSize = 30,
            fillColor = { default={ ColConv.HexToNormAlpha("#FFFFFF")}, over={ ColConv.HexToNormAlpha("#57828F") } },
            onEvent = HandleButtonEvent
        }
    )
    sceneGroup:insert(exitButton)
    exitButton.isVisible = false

    function Self:UpdateHealthBar()
        healthText.text = "Health: " .. Self.Player.CurrentHealthPoints .. "/" .. Self.Player.MaxHealthPoints
        if Self.Player.CurrentHealthPoints <= 0 then
            SoundManager:playSound("gameOver", 4, 0.4, 0)
            SoundManager:stopAudioChannel(10, true, 500)
            SoundManager:playSound("gameOverMenu", 3, 0.7, -1, 500)

            exitButton:setLabel("GAME OVER")
            exitButton.isVisible = true
            background.isVisible = true
        end
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
                
                -- Exit Button
                exitButton:setLabel("CONGRATS")
                exitButton.isVisible = true

                return
            end
            healthBar:setValue( (health / 30) * 100 )
        end
    end

    function Self:Reset()
        Self.Score = 0
        scoreText.text = "Score: " .. Self.Score
        healthText.text = "Health: " .. 5 .. "/" .. 5
        
        if string.len(scoreText.text) >= 12 and textMove == false then
            scoreText.x = scoreText.x - 50
            textMove = true
        elseif string.len(scoreText.text) >= 11 and textMove2 == false then
            scoreText.x = scoreText.x - 20
            textMove2 = true
        end
        scoreText.text = "Score: " .. Self.Score
        textMove = false
        textMove2 = false
    end

    function Self:SetPlayer(player)
        Self.Player = player
    end

    function Self:GetGameOverButton()
        return exitButton
    end

    return Self
end

return GameHUD