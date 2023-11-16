--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- Enemy2.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local display = require("display")

-- Module
local Enemy2 = {}

function Enemy2.new(playerCharacter)
    local Self = Character.new()
    Self.Projectile = Projectile.new()  

    -- Variables
    Self.MaxHealthPoints = 3
    Self.CurrentHealthPoints = Self.MaxHealthPoints
    Self.tag = "Enemy"
    Self.ScoreWorth = 100
    Self.playerCharacter = playerCharacter

    function Self:spawn()
        Self.shape = display.newCircle(0, 0, 15)
        Self.shape:setFillColor(0, 0, 1)
        Self.shape.x = display.contentWidth
        Self.shape.y = math.random(0, display.contentHeight)
    end

    function Self:move()
        if Self.playerCharacter and Self.playerCharacter.shape then
            local targetX = Self.playerCharacter.shape.x
            local targetY = Self.playerCharacter.shape.y
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
