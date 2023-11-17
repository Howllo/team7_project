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
-- @charaacter - The character that fired the projectile.
--
-- @damage - The amount of damage the projectile will deal.
--
-- @xForce - The amount of force the projectile will be fired with.
--
-- @size - The size of the projectile.
--
-- @oppositeGroup - The group at which the projectile will be fired at.
function Projectile.new(character, damage, xForce, size, oppositeGroup)
    if character == nil then return end

    local Self = {}

    -- Variables
    local SelfDestroy = nil
    Self.shape = nil
    
    if oppositeGroup == character.shape.BayonetGroup and oppositeGroup ~= nil then
        Self.shape = display.newCircle( oppositeGroup, character.shape.x - 525, character.shape.y - 315, size )
    else
        Self.shape = display.newCircle(character.shape.x + 50, character.shape.y, size )
    end

    -- Setup
    Self.shape.char = character.shape
    Self.shape:setFillColor( ColorConversion.HexToNorm("#2FF924") )
    Self.shape.Damage = damage
    Self.shape.xForce = xForce
    Self.shape.tag = "Projectile"

    -- Physics
    physics.addBody( Self.shape, "dynamic", {isSensor = false})
    Self.shape:applyForce( Self.shape.xForce, 0, Self.shape.char.x + 5, Self.shape.char.y)

    -- Self Destroy 
    function Self:destroy()
        timer.cancel( SelfDestroy )
        Self.shape.char = nil
        SelfDestroy = nil
        Self.shape:removeSelf()
        Self = nil
    end

    -- Destroy if off screen
    local function localDestroy()
        if Self.shape == nil then return end

        if Self.shape.x > display.contentWidth + 150 then
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

                -- Damage Numbers
                oppositeGroupCache = oppositeGroup

                -- Due to a collision event happening it needs to be delay to next frame.
                timer.performWithDelay(1,
                function() 
                    damageNumber:DamageNumber(Self.shape, Self.shape.Damage, oppositeGroupCache)
                    oppositeGroupCache = nil
                    Self:destroy()
                 end, 1)

                -- Deal Damage
                event.other:DealDamage(Self.shape.Damage)
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