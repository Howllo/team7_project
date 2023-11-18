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
local enemySpawner = nil

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

-- Spawn Enemy
local function spawnEnemy()
    if player == nil and kingBayonet ~= nil then timer.cancel(enemySpawner) return end

    local randomEnemy = math.random(1, 2)
    if randomEnemy == 1 then
        local enemy = Enemy1.new()
        enemy:spawn()
        table.insert(enemies, enemy)
    else
        local enemy = Enemy2.new(player.shape)
        enemy:spawn()
        table.insert(enemies, enemy)
    end
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
           enemySpawner = timer.performWithDelay( 2500, spawnEnemy, 0 )
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

        -- Create timer to spawn Enemy 1. 2,5 seconds.
        enemySpawner = timer.performWithDelay( 2500, spawnEnemy, 0 )

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