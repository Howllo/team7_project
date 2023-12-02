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
local currentFrame = 1
local isTailOpen = true

local sequenceData = {
    {name="caudal", start=11, count=3, loopCount = 0}
}

function M.new()
    local Self = display.newSprite(bayonet_sheet.GetBayonetGroup(), sheet, sequenceData)
    Self.x = 97.5
    Self.y = -10.5

    -- Sprite placement animation hack.
    function Self.frameRate()
        if isTailOpen == true then 
            if currentFrame == 1 then
                currentFrame = 2
                Self:setFrame( currentFrame )
                Self.x = 104.4
                Self.y = -10.5
            elseif currentFrame == 2 then
                currentFrame = 3
                Self:setFrame( currentFrame )
                Self.x = 109.5
                Self.y = -10.5
                isTailOpen = false
            end
        else
            if currentFrame == 3 then
                currentFrame = 2
                Self:setFrame( currentFrame )
                Self.x = 104.4
                Self.y = -10.5
            elseif currentFrame == 2 then
                currentFrame = 1
                Self:setFrame( currentFrame )
                Self.x = 97.5
                Self.y = -10.5
                isTailOpen = true
            end
        end
    end

    return Self
end

-- return module
return M