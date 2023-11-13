--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- GameScene.lua
--***********************************************************************************************

-- Requirements
local composer = require( "composer" )
local timer = require("timer")
local GameHUD = require("src.user_interface.GameHUD")
local PlayerCharacter = require("src.Characters.PlayerCharacter")
local Background = require("src.user_interface.Background")
local physics = require("physics")
local DebugLines = nil
local KingBayonet = nil

-- Variables
physics.start()
local scene = composer.newScene()
local HUD = nil
local player = nil
local bg = nil
local kingBayonet = nil
local kingTimer = nil
 
-- Spawn King Bayonet
local function spawnKingBayonet()
   KingBayonet = require("src.Characters.KingBayonet")
   kingBayonet = KingBayonet.new()
   kingBayonet.shape:spawn()
end
 
function scene:create( event )
   local sceneGroup = self.view

   -- Create Player
   player = PlayerCharacter.new()

   -- Create HUD
   HUD = GameHUD.new(player.shape, sceneGroup)

   -- Set HUD for player
   player.shape:SetHUD(HUD)

   -- Test
   spawnKingBayonet()
   local shape = display.newRect( 0, 0, 100, 100 )
   physics.addBody( shape, "static", {isSensor = false} )
   shape.x = display.contentCenterX
   shape.y = display.contentCenterY
   shape.tag = "Enemy"
   shape.ScoreWorth = 100000
   shape.CurrentHealthPoints = 1

end
 
-- "scene:show()"
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
   elseif ( phase == "did" ) then
      -- Create timer to spawn King Bayonet. 2 minutes.
      kingTimer = timer.performWithDelay( 120000, spawnKingBayonet, 1 )
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      
      -- Cancel spawner timer.
      timer.cancel(kingTimer)
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