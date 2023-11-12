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
local scene = composer.newScene()
local PlayerCharacter = require("src.Characters.PlayerCharacter")
local Background = require("src.user_interface.Background")
local KingBayonet = nil

-- Variables
local HUD = nil
local player = nil
local bg = nil
local kingBayonet = nil
local kingTimer = nil
local enemies = {} 

-- Spawn King Bayonet
local function spawnKingBayonet()
   KingBayonet = require("src.Characters.KingBayonet")
   kingBayonet = KingBayonet.new()
   kingBayonet:spawn()
end

-- Spawn Enemy 1
local function spawnEnemy1()
    local enemy = Enemy1.new()
    enemy:spawn()
    table.insert(enemies, enemy)
end

-- Spawn Enemy 2
local function spawnEnemy2()
    local enemy = Enemy2.new(player)
    enemy:spawn()
    table.insert(enemies, enemy)
end

-- Game Loop
local function gameLoop()
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy:move()

        if enemy.CurrentHealthPoints <= 0 or enemy.shape.x < 0 then
            enemy:destroy()
            table.remove(enemies, i)
        end
    end
end

function scene:create( event )
    local sceneGroup = self.view

    -- Create Player
    player = PlayerCharacter.new()

    -- Create HUD
    HUD = GameHUD.new(player, sceneGroup)
end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then

      -- Create timer to spawn King Bayonet. 2 minutes.
      kingTimer = timer.performWithDelay( 120000, spawnKingBayonet, 1 )

      -- Create timer to spawn Enemy 1. 5 seconds.
      timer.performWithDelay( 5000, spawnEnemy1, 0 )

      -- Create timer to spawn Enemy 2. 10 seconds.
      timer.performWithDelay( 10000, spawnEnemy2, 0 )

      -- Start the game loop
        Runtime:addEventListener("enterFrame", gameLoop)
    end
end

-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

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