--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- PlayerMovementShoot.lua
--***********************************************************************************************

--Requirements
local ColorConversion = require("lib.ColorConversion")
local display = require("display")
local timer = require("timer")

-- Module
PlayerMovementShoot = {}

function PlayerMovementShoot.new(playerCharacter)
    local Self = {}

    -- Variables
    local playerShape = playerCharacter.shape
    local projectileShootTime = nil
    local group = display.newGroup()
    local touch = 0
    local playerMovementRect = display.newRoundedRect( group, 30, 360, 150, 450, 30 )
    playerMovementRect:setFillColor(ColorConversion.HexToNormA("#D3D3D3", 0.7))

    -- Cancels Shooting after 300ms
    local function stopShooting()
        timer.cancel(projectileShootTime)
        touch = 0
    end

    -- Movement and Shooting Handler
    local function MovementHandler(event)
        if event.phase == "began" then
            playerShape.y = event.y
        elseif event.phase == "moved" then
            playerShape.y = event.y
        elseif event.phase == "ended" then
            touch = touch + 1
            projectileShootTime = timer.performWithDelay(300, stopShooting, 1)
            if touch == 2 then
                playerShape:Fire()
                touch = 0
                timer.cancel(projectileShootTime)
            end
        end
    end

    -- Event For Movement
    playerMovementRect:addEventListener("touch", MovementHandler)

    return Self
end

return PlayerMovementShoot