--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- Enemy1.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local display = require("display")
local physics = require("physics")

-- Module
local Enemy1 = {}

function Enemy1.Spawn()
    local Self = Character.new(display.newRect(0, 0, 30, 30))

    -- Setup
    Self.shape:setFillColor(1, 0, 0)
    Self.shape.x = display.contentWidth
    Self.shape.y = math.random(150, display.contentHeight - 100)

    -- Variables
    Self.shape.MaxHealthPoints = 2
    Self.shape.CurrentHealthPoints = Self.shape.MaxHealthPoints
    Self.shape.tag = "Enemy"
    Self.shape.ScoreWorth = 100

    -- Physics
    physics.addBody( Self.shape, "kinematic", {isSensor = false} )

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
