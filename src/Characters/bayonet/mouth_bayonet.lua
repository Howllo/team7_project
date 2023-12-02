--***********************************************************************************************
-- Tony Hardiman
-- Team Project
-- mouth_bayonet.lua
--***********************************************************************************************

-- Requirements
local bayonet_sheet = require("src.Characters.bayonet.bayonet_sheet")
local display = require("display")
local timer = require("timer")

-- Module
local M = {}

-- Variables
local sheet = bayonet_sheet.GetSheet()

-- Sequence Data
local sequenceData = {
    {name="mouth1", start=5, count=3, loopCount = 0}
}

function M.new()
    -- Setup Mouth images
    local Self = display.newSprite(bayonet_sheet.GetBayonetGroup(), sheet, sequenceData)
    local currentFrame = 1
    local isMouthOpen = false

    Self.x = -41.7
    Self.y = -3.4
    Self:scale(1.05, 1.05)

    -- Sprite placement animation hack.
    function Self.frameRate()
        if isMouthOpen == false then 
            if currentFrame == 1 then
                currentFrame = 2
                Self:setFrame( currentFrame )
                Self.x = -35.7
                Self.y = -3.4
            elseif currentFrame == 2 then
                currentFrame = 3
                Self:setFrame( currentFrame )
                Self.x = -33.5
                Self.y = -3.4
                isMouthOpen = true
            end
        else
            if currentFrame == 3 then
                currentFrame = 2
                Self:setFrame( currentFrame )
                Self.x = -35.7
                Self.y = -3.4
            elseif currentFrame == 2 then
                currentFrame = 1
                Self:setFrame( currentFrame )
                Self.x = -41.7
                Self.y = -3.4
                isMouthOpen = false
            end
        end
    end

    return Self
end

-- return module
return M