--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- GameScene.lua
--***********************************************************************************************

-- Requirements
local composer = require( "composer" )
local timer = require("timer")
local GameHUD = require("src.user_interface.GameHUD")
local Enemy1 = require("src.Characters.Enemy1")
local Enemy2 = require("src.Characters.Enemy2")
local PlayerCharacter = require("src.Characters.PlayerCharacter")
local Background = require("src.user_interface.Background")
local physics = require("physics")
local KingBayonet = nil

-- Variables
local scene = composer.newScene()
local HUD = nil
local player = nil
local kingBayonet = nil
local kingTimer = nil
local enemies = {}

-- Spawn King Bayonet
local function spawnKingBayonet()
   KingBayonet = require("src.Characters.KingBayonet")
   kingBayonet = KingBayonet.Spawn(player,  HUD)

   -- Set player's bayonet group. 
   -- This is used for projectile collision detection.
   if player ~= nil and kingBayonet ~= nil then
      player.shape:AssignBayonetGroup(kingBayonet.shape.BayonetGroup)
   end
end

-- Spawn Enemy 1
local function spawnEnemy1()
    local enemy = Enemy1.Spawn()
    table.insert(enemies, enemy)
end

-- Spawn Enemy 2
local function spawnEnemy2()
    if player == nil then
        print("Error: player is nil")
        return
    end

    local enemy = Enemy2.Spawn(player.shape)
    table.insert(enemies, enemy)
end

-- Game Loop
local function gameLoop()
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy:move()

        if enemy.shape.CurrentHealthPoints <= 0 or enemy.shape.x < -100 then
            enemy:destroy()
            table.remove(enemies, i)
        end
    end

    if kingBayonet ~= nil then
        kingBayonet:move()
  
        if kingBayonet.isDead == true then
           KingBayonet = nil
           kingBayonet = nil
        end
     end
end

function scene:create( event )
    local sceneGroup = self.view

    -- Physics 
    physics.start()

    -- Create Player
    player = PlayerCharacter.Spawn()

    -- Create HUD
    HUD = GameHUD.new(player.shape, sceneGroup)

    -- Set HUD for player
    player:SetHUD(HUD)
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Physics
        physics.start()
    elseif ( phase == "did" ) then
        -- Create timer to spawn King Bayonet. 2 minutes.
        kingTimer = timer.performWithDelay( 120000, spawnKingBayonet, 1 )

        if kingBayonet == nil then 
            -- Create timer to spawn Enemy 1. 5 seconds.
            timer.performWithDelay( 5000, spawnEnemy1, 0 )

            -- Create timer to spawn Enemy 2. 10 seconds.
            timer.performWithDelay( 10000, spawnEnemy2, 0 )
        end

        -- Start the game loop
        Runtime:addEventListener("enterFrame", gameLoop)
    end
end

-- "scene:hide()"
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Physics
        physics.stop()
    
        -- Cancel spawner timer.
        timer.cancel(kingTimer)

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