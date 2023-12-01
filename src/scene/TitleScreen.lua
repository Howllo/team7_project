--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig
-- Team Project
-- TitleScreen.lua
--***********************************************************************************************

-- Requirements
local startUI = require("src.user_interface.start")
local composer = require( "composer" )
local SoundManager = require("src.scene.SoundManager")
local display =require("display")
local Background = require("src.user_interface.Background")
local scene = composer.newScene()

-- Global Variable
local start = nil
local bg = nil

-- Game Loop
local function gameLoop()
   -- Update background
   scene.background:move(1,0.5)
end

function scene:create( event )
   local sceneGroup = self.view
 
   -- Create Background
   local background = Background.new()
   sceneGroup:insert(background)
   local backG = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
   backG:setFillColor( 0, 0, 0, 0.3)

   -- Create Start UI
   start = startUI.new()
   if start ~= nil then
      sceneGroup:insert(start:GetGroup())
   end

   self.background = background
end
 
-- "scene:show()"
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then

      -- Play Packground Music
      SoundManager:playSound("mainMenuOST", 3, 0.8, -1)

      -- Start the game loop
      Runtime:addEventListener("enterFrame", gameLoop)
   elseif ( phase == "did" ) then
   end
end
 
-- "scene:hide()"
function scene:hide( event )
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Stop Background Music
      SoundManager:stopAudioChannel(3, true, 600)

      -- Stop the game loop
      Runtime:removeEventListener("enterFrame", gameLoop)
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