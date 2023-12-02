--***********************************************************************************************
-- Tony Hardiman
-- Team Project
-- snout_bayonet.lua
--***********************************************************************************************

-- Requirements
local bayonet_sheet = require("src.Characters.bayonet.bayonet_sheet")
local display = require("display")

-- Module
local M = {}

-- Variables
local sheet = bayonet_sheet.GetSheet()
local currentFrame = 1
local isLightOff = true

local sequenceData = {
    {name="snout", start=2, count=3, loopCount = 0}
}

function M.new()
    local Self = display.newSprite(bayonetGroup, sheet, sequenceData)
    Self.x = -87
    Self.y = -3

    -- Sprite placement animation hack.
    function M.frameRate()
        if isLightOff == true then 
            if currentFrame == 1 then
                currentFrame = 2
                Self:setFrame( currentFrame )
                Self.x = -88
                Self.y = -3
            elseif currentFrame == 2 then
                currentFrame = 3
                Self:setFrame( currentFrame )
                Self.x = -88.1
                Self.y = -3
                isLightOff = false
            end
        else
            if currentFrame == 3 then
                currentFrame = 2
                Self:setFrame( currentFrame )
                Self.x = -88
                Self.y = -3
            elseif currentFrame == 2 then
                currentFrame = 1
                Self:setFrame( currentFrame )
                Self.x = -87
                Self.y = -3
                isLightOff = true
            end
        end
    end

    return Self
end

-- return module
return M