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
local bayonetGroup = bayonet_sheet.GetBayonetGroup()
local currentFrame = 1
local isMouthOpen = false

-- Sequence Data
local sequenceData = {
    {name="mouth1", start=5, count=3, loopCount = 0}
}

-- Setup Mouth images
M.mouthSprite = display.newSprite(bayonetGroup, sheet, sequenceData)
M.mouthSprite.x = -41.7
M.mouthSprite.y = -3.4
M.mouthSprite:scale(1.05, 1.05)

-- Sprite placement animation hack.
function M.frameRate()
    if isMouthOpen == false then 
        if currentFrame == 1 then
            currentFrame = 2
            M.mouthSprite:setFrame( currentFrame )
            M.mouthSprite.x = -35.7
            M.mouthSprite.y = -3.4
        elseif currentFrame == 2 then
            currentFrame = 3
            M.mouthSprite:setFrame( currentFrame )
            M.mouthSprite.x = -33.5
            M.mouthSprite.y = -3.4
            isMouthOpen = true
        end
    else
        if currentFrame == 3 then
            currentFrame = 2
            M.mouthSprite:setFrame( currentFrame )
            M.mouthSprite.x = -35.7
            M.mouthSprite.y = -3.4
        elseif currentFrame == 2 then
            currentFrame = 1
            M.mouthSprite:setFrame( currentFrame )
            M.mouthSprite.x = -41.7
            M.mouthSprite.y = -3.4
            isMouthOpen = false
        end
    end
end

-- return module
return M