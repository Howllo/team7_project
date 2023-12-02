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

function M.new()
    local Self = display.newSprite(bayonetGroup, sheet, sequenceData)
    Self.x = 32
    Self.y = 38

    -- Sprite placement animation hack.
    function M.frameRate()
        if isFinOut == true then 
            if currentFrame == 1 then
                currentFrame = 2
                Self:setFrame( currentFrame )
                Self.x = 32
                Self.y = 31
            elseif currentFrame == 2 then
                currentFrame = 3
                Self:setFrame( currentFrame )
                Self.x = 32
                Self.y = 25
                isFinOut = false
            end
        else
            if currentFrame == 3 then
                currentFrame = 2
                Self:setFrame( currentFrame )
                Self.x = 32
                Self.y = 31
            elseif currentFrame == 2 then
                currentFrame = 1
                Self:setFrame( currentFrame )
                Self.x = 32
                Self.y = 38
                isFinOut = true
            end
        end
    end
    return Self
end

-- return module
return M