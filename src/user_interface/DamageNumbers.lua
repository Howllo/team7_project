-- Requirements
local physics = require("physics")
local display = require("display")
local native = require("native")
local timer = require("timer")

-- Module
Module = {}

-- Static Method
--
-- @Shape - Object that the bullet will launch the damage number from.
--
-- @damage - The amount of damage the projectile will deal.
--
-- @oppositeGroup - The group that projectile will attach to.
function Module:DamageNumber(shape, damage, group)
    if shape == nil or shape.x == nil or shape.y == nil or damage == nil then
        print("Error: DamageNumber failed to generate.")
        print("Error Dump: " .. tostring(shape))
        print("Error Dump: damage: " .. tostring(damage))
        print("Error Dump: shape.x: " .. tostring(shape.x))
        print("Error Dump: shape.y: " .. tostring(shape.y))
        return
    end

    local damageNumber = nil
    if group ~= nil then
        damageNumber = display.newText( group, damage, shape.x, shape.y - 25, native.systemFont, 40 )
    else
        damageNumber = display.newText( damage, shape.x, shape.y - 25, native.systemFont, 40 )
    end
    damageNumber:setFillColor( 1, 1, 1, 1)

    -- Physics
    physics.addBody( damageNumber, "dynamic", {isSensor = true, radius = 10} )

    -- Apply Force 
    damageNumber:applyForce( math.random(1.0, 2.0), -math.random(1.0, 2.0), damageNumber.x, damageNumber.y ) 

    -- Self Destroy
    timer.performWithDelay( 1000,
    function ()
        if damageNumber ~= nil then
            display.remove(damageNumber)
            damageNumber = nil
        end
    end, 1 )
end

return Module