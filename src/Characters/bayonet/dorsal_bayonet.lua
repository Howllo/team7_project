--***********************************************************************************************
-- Tony Hardiman
-- Team Project
-- dorsal_bayonet.lua
--***********************************************************************************************

-- Requirements
local bayonet_sheet = require("src.bayonet.bayonet_sheet")
local display = require("display")

-- Module
local M = {}

-- Variables
local sheet = bayonet_sheet.GetSheet()
local bayonetGroup = bayonet_sheet.GetBayonetGroup()
local isOriginalRotation = true
local turningDegree = 25

local sequenceData = {
    {name="dorsal", start=14, count=1, loopCount = 0}
}

-- Create Dosral Fin
local dorsalFin = display.newSprite(bayonetGroup, sheet , sequenceData )
dorsalFin.x = 15
dorsalFin.y = -47

-- Sprite placement animation hack.
function M.rotateDorsalFin()
    if isOriginalRotation == true then 
        dorsalFin:rotate( turningDegree )
        isOriginalRotation = false
        dorsalFin.y = -40
    else
        dorsalFin:rotate( -turningDegree )
        isOriginalRotation = true
        dorsalFin.y = -47
    end
end

-- Event Listener for the Dorsal Animation
dorsalFin:addEventListener("tap", M.tapEventHandler)

-- return module
return M