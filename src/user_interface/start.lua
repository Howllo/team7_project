--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, 
-- Team Project
-- start.lua
--***********************************************************************************************

--Requirements
local widget = require("widget")
local display = require("display")
local ColConv = require("lib.ColorConversion")
local native = require("native")
local composer = require("composer")
local SoundManager = require("src.scene.SoundManager")

--Module
local Start = {}

function Start.new()
    local Self = {}

    local function HandleButtonEvent(event)
        if ( "ended" == event.phase ) then
            SoundManager:playSound("gameStart", 1, 0.8, 0)
            composer.gotoScene("src.scene.GameScene", {effect = "fade", time = 1000})
        end
    end

--#region Variables
    local group = display.newGroup()

    -- Credits
    local creditGroup = display.newGroup()
    local credits = display.newText(creditGroup, "Create By: ", display.contentCenterX, display.contentCenterY - 230, native.systemFont, 75)
    local t_Credit = display.newText(creditGroup, "Tony Hardiman", display.contentCenterX, display.contentCenterY - 150, native.systemFont, 50)
    local c_Credit = display.newText(creditGroup, "Christian McDonald", display.contentCenterX, display.contentCenterY - 90, native.systemFont, 50)
    local j_Credit = display.newText(creditGroup, "Jack Hartwig", display.contentCenterX, display.contentCenterY - 35, native.systemFont, 50)
    group:insert(creditGroup)

    -- Start Button
    local startButton = widget.newButton(
        {
            label = "Touch to Start",
            emboss = false,
            shape = "roundedRect",
            width = 225,
            height = 100,
            cornerRadius = 15,
            fontSize = 30,
            fillColor = { default={ ColConv.HexToNormAlpha("#FFFFFF")}, over={ ColConv.HexToNormAlpha("#57828F") } },
            labelColor = {default={0, 0, 0, 1}, over= {0, 0, 0, 1}},
            onEvent = HandleButtonEvent
        }
    )
    group:insert(startButton)
    startButton.x = display.contentCenterX
    startButton.y = display.contentCenterY + 200
--#endregion


    function Self:GetGroup()
        return group
    end

    return Self
end


return Start