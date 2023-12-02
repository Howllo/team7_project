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

-- Sequence Data
local sequenceData = {
    {name="body", start=1, count=1, loopCount = 0}
}

function M.new()
    local Self = display.newSprite(bayonet_sheet.GetBayonetGroup(), bayonet_sheet.GetSheet() , sequenceData )
 
    Self.x = 0
    Self.y = 0

    return Self
end

-- return module
return M