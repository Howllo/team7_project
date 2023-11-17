--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- Enemy2.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local display = require("display")
local physics = require("physics")

-- Module
local Enemy2 = {}

function Enemy2.Spawn(playerCharacter)
    local Self = Character.new(display.newCircle(0, 0, 15))

    -- Setup
    Self.shape:setFillColor(0, 0, 1)
    Self.shape.x = display.contentWidth
    Self.shape.y = math.random(150, display.contentHeight - 100)

    -- Variables
    Self.shape.MaxHealthPoints = 3
    Self.shape.CurrentHealthPoints = Self.shape.MaxHealthPoints
    Self.shape.tag = "Enemy"
    Self.shape.ScoreWorth = 100
    Self.shape.playerCharacter = playerCharacter

    -- Physics
    physics.addBody( Self.shape, "kinematic", {isSensor = false} )

    function Self:move()
        if  Self.shape.playerCharacter then
            local targetX = Self.shape.playerCharacter.x
            local targetY = Self.shape.playerCharacter.y
            local moveX = (targetX - Self.shape.x) * 0.01
            local moveY = (targetY - Self.shape.y) * 0.01
            Self.shape.x = Self.shape.x + moveX
            Self.shape.y = Self.shape.y + moveY
        end
    end

    function Self:destroy()
        if Self.shape then
            Self.shape:removeSelf()
            Self.shape = nil
        end
    end

    return Self
end

return Enemy2
