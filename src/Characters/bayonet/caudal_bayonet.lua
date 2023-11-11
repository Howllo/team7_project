--***********************************************************************************************
-- Tony Hardiman
-- Team Project
-- cadual_bayonet.lua
--***********************************************************************************************

-- Requirements
local bayonet_sheet = require("src.Characters.bayonet.bayonet_sheet")
local display = require("display")

-- Module
local M = {}

-- Variables
local sheet = bayonet_sheet.GetSheet()
local bayonetGroup = bayonet_sheet.GetBayonetGroup()
local currentFrame = 1
local isTailOpen = true

local sequenceData = {
    {name="caudal", start=11, count=3, loopCount = 0}
}

-- Caudal Fin
local caudalFin = display.newSprite(bayonetGroup, sheet, sequenceData)
caudalFin.x = 97.5
caudalFin.y = -10.5

-- Sprite placement animation hack.
function M.frameRate()
    if isTailOpen == true then 
        if currentFrame == 1 then
            currentFrame = 2
            caudalFin:setFrame( currentFrame )
            caudalFin.x = 104.4
            caudalFin.y = -10.5
        elseif currentFrame == 2 then
            currentFrame = 3
            caudalFin:setFrame( currentFrame )
            caudalFin.x = 109.5
            caudalFin.y = -10.5
            isTailOpen = false
        end
    else
        if currentFrame == 3 then
            currentFrame = 2
            caudalFin:setFrame( currentFrame )
            caudalFin.x = 104.4
            caudalFin.y = -10.5
        elseif currentFrame == 2 then
            currentFrame = 1
            caudalFin:setFrame( currentFrame )
            caudalFin.x = 97.5
            caudalFin.y = -10.5
            isTailOpen = true
        end
    end
end

-- return module
return M