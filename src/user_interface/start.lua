--Requirements
local widget = require("widget")
local display = require("display")
local ColConv = require("lib.ColorConversion")
local native = require("native")

--Module
local Start = {}

function Start.new()
    local Self = {}

    local function HandleButtonEvent(event)
        if ( "ended" == event.phase ) then
            print( "Button was pressed and released" )
        end
    end

--#region Variables
    local group = display.newGroup()
    
    -- Background
    local background = display.newRect( group , display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
    background:setFillColor(ColConv.HexToNorm("#FF5733"))

    -- Credits
    local creditGroup = display.newGroup()
    local credits = display.newText(creditGroup, "Create By: ", display.contentCenterX, display.contentCenterY - 230, native.systemFont, 75)
    local t_Credit = display.newText(creditGroup, "Tony Hardiman", display.contentCenterX, display.contentCenterY - 150, native.systemFont, 50)
    local c_Credit = display.newText(creditGroup, "Christian McDonald", display.contentCenterX, display.contentCenterY - 90, native.systemFont, 50)
    local j_Credit = display.newText(creditGroup, "Jack Hartwig", display.contentCenterX, display.contentCenterY - 35, native.systemFont, 50)
    local r_Credit = display.newText(creditGroup, "Robert Morgan", display.contentCenterX, display.contentCenterY + 20, native.systemFont, 50)
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
            fillColor = { default={ ColConv.HexToNormAlpha("#ABD6E6")}, over={ ColConv.HexToNormAlpha("#57828F") } },
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