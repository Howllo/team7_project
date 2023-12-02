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

function M.new()
    local Self = display.newSprite(bayonetGroup, sheet, sequenceData)
    Self.x = 15
    Self.y = -47

    -- Sprite placement animation hack.
    function Self.frameRate()
        if isOriginalRotation == true then 
            M.dorsalFin.rotation = M.dorsalFin.rotation + turningDegree
            if M.dorsalFin.rotation >= 25 then
                isOriginalRotation = false
            end
        else
            M.dorsalFin.rotation = M.dorsalFin.rotation - turningDegree
            if M.dorsalFin.rotation <= -25 then
                isOriginalRotation = true
            end
        end
    end

    return Self
end

-- return module
return M