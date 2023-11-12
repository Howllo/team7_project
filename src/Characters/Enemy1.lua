--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- Enemy1.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local display = require("display")

-- Module
local Enemy1 = {}

function Enemy1.new()
    local Self = Character.new()
    Self.Projectile = Projectile.new()  

    -- Variables
    Self.MaxHealthPoints = 2
    Self.CurrentHealthPoints = Self.MaxHealthPoints
    Self.tag = "Enemy"
    Self.ScoreWorth = 100

    function Self:spawn()
        Self.shape = display.newRect(0, 0, 30, 30)
        Self.shape:setFillColor(1, 0, 0)
        Self.shape.x = display.contentWidth
        Self.shape.y = math.random(0, display.contentHeight)
    end

    function Self:move()
        Self.shape.x = Self.shape.x - 5
    end

    function Self:destroy()
        if Self.shape then
            Self.shape:removeSelf()
            Self.shape = nil
        end
    end

    return Self
end

return Enemy1
