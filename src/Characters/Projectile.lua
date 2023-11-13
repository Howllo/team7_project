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
function Projectile.new(character, damage, xForce, size, oppositeGroup)
    local Self = {}

    -- Physics
    physics.start()
    physics.setGravity( 0, 0 )

    -- Variables
    local SelfDestroy = nil
    Self.shape = nil
    if oppositeGroup == character.shape.BayonetGroup then
        Self.shape = display.newCircle( oppositeGroup, character.shape.x - 525, character.shape.y - 315, size )
    else
        Self.shape = display.newCircle( oppositeGroup, character.shape.x + 50, character.shape.y, size )
    end

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

    local function localDestroy()
        Self:destroy()
    end 
    SelfDestroy = timer.performWithDelay( 1500, localDestroy, 1 )
 
    local function onProjectileCollision(self, event)
        print("Projectile: onProjectileCollision()")
        if event.phase == "began" then
            if Self.shape.char.tag == "Player" and event.other.tag == "Enemy" then
                if event.other.CurrentHealthPoints - Self.shape.Damage <= 0 then
                    Self.shape.char.GameHUD:UpdateScore(event.other.ScoreWorth)
                end

                event.other:DealDamage(Self.shape.Damage)
                Self:destroy()
            elseif Self.shape.char.tag == "Enemy" and event.other.tag == "Player" then
                event.other:DealDamage(Self.shape.Damage)
                Self:destroy()
            end
        end
    end
    Self.shape.collision = onProjectileCollision
    Self.shape:addEventListener("collision")

    return Self
end

return Projectile