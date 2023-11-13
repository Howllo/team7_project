--***********************************************************************************************
-- Tony Hardiman
-- Team Project
-- dorsal_bayonet.lua
--***********************************************************************************************

-- Requirements
local bayonet_sheet = require("src.Characters.bayonet.bayonet_sheet")
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
M.dorsalFin = display.newSprite(bayonetGroup, sheet , sequenceData )
M.dorsalFin.x = 15
M.dorsalFin.y = -47

-- Sprite placement animation hack.
function M.rotateDorsalFin()
    if isOriginalRotation == true then 
        M.dorsalFin:rotate( turningDegree )
        isOriginalRotation = false
        M.dorsalFin.y = -40
    else
        M.dorsalFin:rotate( -turningDegree )
        isOriginalRotation = true
        M.dorsalFin.y = -47
    end
end

-- return module
return M