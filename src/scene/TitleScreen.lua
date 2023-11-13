--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- TitleScreen.lua
--***********************************************************************************************

-- Requirements
local startUI = require("src.user_interface.start")
local composer = require( "composer" )
local display =require("display")
local scene = composer.newScene()

-- Global Variable
local start = nil
local bg = nil

function scene:create( event )
   local sceneGroup = self.view
 
   -- Background
   bg = display.newImage(sceneGroup, "data/farback.png", display.contentCenterX, display.contentCenterY)

   -- Create Start UI
   start = startUI.new()
   if start ~= nil then
      sceneGroup:insert(start:GetGroup())
   end
end
 
-- "scene:show()"
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
   elseif ( phase == "did" ) then
   end
end
 
-- "scene:hide()"
function scene:hide( event )
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
   elseif ( phase == "did" ) then
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
   local sceneGroup = self.view
end
 
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene