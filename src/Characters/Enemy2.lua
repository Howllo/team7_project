-- Requirements
local Character = require("src.Characters.Character")
local display = require("display")
local physics = require("physics")

-- Module
local Enemy2 = {}

function Enemy2.new(playerCharacter)
    local Self = Character.new(display.newCircle(0, 0, 15))
    
    -- Additional properties for initial direction
    Self.initialMoveX = 0
    Self.initialMoveY = 0

    function Self:spawn()
        -- Setup
        Self.shape:setFillColor(0, 0, 1)

        -- Modified position: Spawns the enemy off-screen to the right
        local offScreenOffset = 50 -- This can be adjusted as needed
        Self.shape.x = display.contentWidth + offScreenOffset
        Self.shape.y = math.random(150, display.contentHeight - 100)

        -- Calculate initial direction based on player's position at spawn time
        if playerCharacter then
            local offsetToLeft = 100 -- Adjust as needed
            local targetX = playerCharacter.x - offsetToLeft
            local targetY = playerCharacter.y
            Self.initialMoveX = (targetX - Self.shape.x) * 0.01
            Self.initialMoveY = (targetY - Self.shape.y) * 0.01
        end

        -- Variables
        Self.shape.MaxHealthPoints = 3
        Self.shape.CurrentHealthPoints = Self.shape.MaxHealthPoints
        Self.shape.tag = "Enemy"
        Self.shape.ScoreWorth = 100
        Self.shape.playerCharacter = playerCharacter

        -- Physics
        physics.addBody(Self.shape, "dynamic", {isSensor = true})
        Self.shape.gravityScale = 0
    end

    function Self:move()
        -- Use the initial direction for movement
        Self.shape.x = Self.shape.x + Self.initialMoveX
        Self.shape.y = Self.shape.y + Self.initialMoveY
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

return Enemy2
