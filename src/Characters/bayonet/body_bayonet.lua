--***********************************************************************************************
-- Tony Hardiman
-- Team Project
-- dorsal_bayonet.lua
--***********************************************************************************************

-- Requirements
local bayonet_sheet = require("src.bayonet.bayonet_sheet")
local display = require("display")

-- Sequence Data
local sequenceData = {
    {name="body", start=1, count=1, loopCount = 0}
}

--Create Body
local body = display.newSprite(bayonet_sheet.GetBayonetGroup(), bayonet_sheet.GetSheet() , sequenceData )
body.x = 0
body.y = 0

-- return module
return M