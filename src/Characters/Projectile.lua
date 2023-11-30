--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- Projectile.lua
--***********************************************************************************************

-- Requirements
local physics = require("physics")
local display = require("display")
local physics = require("physics")
local timer = require("timer")
local ColorConversion = require("lib.ColorConversion")
local damageNumber = require("src.user_interface.DamageNumbers")

--Module 
Projectile = {}

-- Constructor
--
-- @character - The character shape that fired the projectile.
--
-- @firePosition - The position the projectile will be fired from.
--
-- @damage - The amount of damage the projectile will deal.
--
-- @xForce - The amount of force the projectile will be fired with.
--
-- @yForce - The amount of force the projectile will be fired with.
--
-- @size - The size of the projectile.
function Projectile.new(character, firePosition, damage, xForce, yForce, size)
    if character == nil or firePosition == nil or firePosition.x == nil or firePosition. y == nil or 
            character == nil or damage == nil or xForce == nil or yForce == nil or size == nil then
        print("ERROR: Projectile.new() - Missing parameter.")
        print("Error Dump Character: " .. tostring(character))
        print("Error Dump Fire Position: " .. tostring(firePosition))
        print("Error Dump Fire Position X: " .. tostring(firePosition.x))
        print("Error Dump Fire Position Y: " .. tostring(firePosition.y))
        print("Error Dump Damage: " .. tostring(damage))
        print("Error Dump X Force: " .. tostring(xForce))
        print("Error Dump Y Force: " .. tostring(yForce))
        print("Error Dump Size: " .. tostring(size))
         return 
    end

    local Self = {}

    -- Variables
    local SelfDestroy = nil
    Self.shape = display.newCircle( firePosition.x, firePosition.y, size )
    Self.shape.char = character
    Self.shape:setFillColor( ColorConversion.HexToNorm("#2FF924") )
    Self.shape.Damage = damage
    Self.shape.xForce = xForce
    Self.shape.yForce = yForce
    Self.shape.tag = "Projectile"

    -- Physics
    physics.addBody( Self.shape, "dynamic", {isSensor = false})
    Self.shape:applyForce( Self.shape.xForce, Self.shape.yForce, Self.shape.char.x + 5, Self.shape.char.y)

    -- Self Destroy 
    function Self:destroy()
        timer.cancel( SelfDestroy )
        Self.shape.char = nil
        SelfDestroy = nil
        display.remove( Self.shape )
        Self = nil
    end

    -- Destroy if off screen
    local function localDestroy()
        if Self.shape == nil or Self.shape.x == nil then return end

        if (Self.shape.x > display.contentWidth + 150 or Self.shape.x < -10) or (Self.shape.y < - 10 or Self.shape.y > display.contentHeight) then
            Self:destroy()
        end
    end 
    SelfDestroy = timer.performWithDelay( 20, localDestroy, 0 )
 
    -- Collision
    local oppositeGroupCache = nil

    local function onProjectileCollision(event)
        if event.phase == "began" then
            if Self.shape.char.tag == "Player" and event.other.tag == "Enemy" then
                if event.other.CurrentHealthPoints - Self.shape.Damage <= 0 then
                    Self.shape.char.GameHUD:UpdateScore(event.other.ScoreWorth)
                end

                -- Due to a collision event happening it needs to be delay to next frame.
                timer.performWithDelay(1,
                function()
                    if Self == nil then return end
                    damageNumber:DamageNumber(Self.shape, Self.shape.Damage)

                    -- Deal Damage
                    event.other:DealDamage(Self.shape.Damage)
                    Self:destroy()
                 end, 1)
            elseif Self.shape.char.tag == "Enemy" and event.other.tag == "Player" then
                event.other:DealDamage(Self.shape.Damage)
                Self:destroy()
            end
        end
    end
    Self.shape:addEventListener("collision", onProjectileCollision)

    return Self
end

return Projectile