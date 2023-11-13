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

--Create Body
M.body = display.newSprite(bayonet_sheet.GetBayonetGroup(), bayonet_sheet.GetSheet() , sequenceData )
M.body.x = 0
M.body.y = 0

-- return module
return M