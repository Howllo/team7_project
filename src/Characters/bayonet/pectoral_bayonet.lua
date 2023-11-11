--***********************************************************************************************
-- Tony Hardiman
-- Team Project
-- pectoral_bayonet.lua
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
local isFinOut = true

local sequenceData = {
    {name="fin", start=8, count=3, loopCount = 0}
}

-- Pectoral Fin
local pectoralFin = display.newSprite(bayonetGroup, sheet, sequenceData)
pectoralFin.x = 32
pectoralFin.y = 38

-- Sprite placement animation hack.
function M.frameRate()
    if isFinOut == true then 
        if currentFrame == 1 then
            currentFrame = 2
            pectoralFin:setFrame( currentFrame )
            pectoralFin.x = 32
            pectoralFin.y = 31
        elseif currentFrame == 2 then
            currentFrame = 3
            pectoralFin:setFrame( currentFrame )
            pectoralFin.x = 32
            pectoralFin.y = 25
            isFinOut = false
        end
    else
        if currentFrame == 3 then
            currentFrame = 2
            pectoralFin:setFrame( currentFrame )
            pectoralFin.x = 32
            pectoralFin.y = 31
        elseif currentFrame == 2 then
            currentFrame = 1
            pectoralFin:setFrame( currentFrame )
            pectoralFin.x = 32
            pectoralFin.y = 38
            isFinOut = true
        end
    end
end

-- return module
return M