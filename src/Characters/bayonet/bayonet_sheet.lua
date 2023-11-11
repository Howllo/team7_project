--***********************************************************************************************
-- Tony Hardiman
-- Assignment 2
-- bayonet_sheet.lua
--***********************************************************************************************

-- Requirements
local graphics = require("graphics")
local display = require("display")

-- Module
local M ={}

local opt = 
{
    frames = {
        { x = 0, y = 0, width = 205, height = 90},      -- 1. Main Body
        { x = 204, y = 25, width = 24, height = 24},    -- 2. Snout 1
        { x = 224, y = 25, width = 24, height = 24},    -- 3. Snout 2
        { x = 245, y = 25, width = 24, height = 24},    -- 4. Snout 3
        { x = 272, y = 15, width = 65, height = 40},    -- 5. Mouth 1
        { x = 341, y = 15, width = 65, height = 40},    -- 6. Mouth 2
        { x = 406, y = 15, width = 65, height = 40},    -- 7. Mouth 3
        { x = 19, y = 80, width = 60, height = 100},    -- 8. Pectoral Fin 1
        { x = 75, y = 80, width = 60, height = 100},    -- 9. Pectoral Fin 2
        { x = 139, y = 80, width = 60, height = 100},   -- 10. Pectoral Fin 3
        { x = 196, y = 70, width = 65, height = 100},   -- 11. Cadual Fin 1
        { x = 260, y = 70, width = 65, height = 100},   -- 12. Cadual Fin 2
        { x = 329, y = 70, width = 65, height = 100},   -- 13. Cadual Fin 3
        { x = 402, y = 70, width = 60, height = 100},   -- 14. Dorsal Fin
    }
}

--#region Animation and Sprite

-- Create new sprite sheet
local sheet = graphics.newImageSheet( "data/KingBayonet.png", opt );

-- Create Group
local bayonetGroup = display.newGroup()

-- Set bayonet position to middle.
bayonetGroup.x = display.contentWidth / 2
bayonetGroup.y = display.contentHeight / 2

-- Create last X and Y positon variables.
local lastX = bayonetGroup.x;
local lastY = bayonetGroup.y;

function M.GetSheet()
    return sheet
end

function M.GetBayonetGroup()
    return bayonetGroup
end

-- Get the last transition position of the bayonet on X axis.
function M.GetLastX()
    return lastX
end

-- Get the last transition position of the bayonet on Y axis.
function M.GetLastY()
    return lastY
end

-- Set the last transition position of the bayonet on X axis.
function M.SetLastX(x)
    lastX = x
end

-- Set the last transition position of the bayonet on Y axis.
function M.SetLastY(y)
    lastY = y
end

return M