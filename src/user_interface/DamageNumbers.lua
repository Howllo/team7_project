-- Requirements
local physics = require("physics")
local display = require("display")
local native = require("native")
local timer = require("timer")


-- Module
Module = {}

function Module:DamageNumber(shape, damage, group)
    if shape == nil or shape.y == nil or damage == nil or group == nil then return end

    local damageNumber = display.newText( group, damage, shape.x, shape.y - 25, native.systemFont, 40 )
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