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

function Enemy1.new()
    local Self = Character.new(display.newRect(0, 0, 30, 30))

    -- Setup
    function Self:spawn()
        Self.shape:setFillColor(1, 0, 0)
        Self.shape.x = display.contentWidth
        Self.shape.y = math.random(150, display.contentHeight - 100)

        -- Variables
        Self.shape.MaxHealthPoints = 2
        Self.shape.CurrentHealthPoints = Self.shape.MaxHealthPoints
        Self.shape.tag = "Enemy"
        Self.shape.ScoreWorth = 100

        -- Physics
        physics.addBody( Self.shape, "dynamic", {isSensor = true} )
        Self.shape.gravityScale = 0
    end

    function Self:move()
        if Self.shape then
            Self.shape.x = Self.shape.x - 5
        end
    end

    function Self:destroy()
        if Self.shape then
            Self.shape:removeSelf()
            Self.shape = nil
        end
    end

    local function onCollision(event)
        if event.phase == "began" then
            if event.other.tag == "Player" then
                event.other:DealDamage(Self.shape.CurrentHealthPoints)
                Self.shape.CurrentHealthPoints = -1
            end
        end
    end
    Self.shape:addEventListener("collision", onCollision)

    return Self
end

return Enemy1