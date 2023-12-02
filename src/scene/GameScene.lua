--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig
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
local SoundManager = require("src.scene.SoundManager")
local KingBayonet = nil

-- Variables
local scene = composer.newScene()
local HUD = nil
local player = nil
local kingBayonet = nil
local kingTimer = nil
local enemies = {}
local enemySpawner = nil
local gameOver = false

-- Enemy Controls
local enemySpawnTimer = 2500
local bayonetSpawnTimer = 120000

-- Spawn King Bayonet
local function spawnKingBayonet()
    if gameOver then return end

    KingBayonet = require("src.Characters.KingBayonet")
    kingBayonet = KingBayonet.new(player,  HUD)
    kingBayonet:spawn()

    -- Stop spawner timer.
    timer.cancel(enemySpawner)

    -- Change Music
    SoundManager:stopAudioChannel(10, true, 500)
    timer.performWithDelay( 600, function() SoundManager:playSound("bayonetOST", 11, 0.7, -1, 1000) end, 1 )

    -- Destroy all enemies
    if #enemies > 0 then
        for i = #enemies, 1, -1 do
            local enemy = enemies[i]
            enemy:destroy()
            table.remove(enemies, i)
        end
    end
end

-- Spawn Enemy
local function spawnEnemy()
    if player == nil or KingBayonet or gameOver then timer.cancel(enemySpawner) return end

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
    -- Game Over
    if player then
        if player.shape.CurrentHealthPoints <= 0 then
            gameOver = true

            -- Destroy Player
            player:destroy()
            player = nil
        
            -- Destroy King Bayonet
            if kingBayonet then
                kingBayonet:destroy()
                kingBayonet = nil
                KingBayonet = nil
            end

            -- Destroy all enemies
            if #enemies > 0 then
                for i = #enemies, 1, -1 do
                    local enemy = enemies[i]
                    enemy:destroy()
                    table.remove(enemies, i)
                end
            end

            -- Stop from progressing
            return
        end
     end

    -- Update background
    scene.background:move(1, 0.5)

    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy:move()

        if enemy.shape.CurrentHealthPoints <= 0 or enemy.shape.x < -100 then
            enemy:destroy()
            table.remove(enemies, i)
        end
    end

    if kingBayonet then
        if kingBayonet.isDead == true then
            KingBayonet = nil
            kingBayonet = nil
            enemySpawner = timer.performWithDelay( enemySpawnTimer, spawnEnemy, 0 )

            -- Change Music
            SoundManager:stopAudioChannel(11, true, 500)
            SoundManager:playSound("ingameOST", 10, 0.7, -1, 1000)
            audio.setVolume( 0.7, {channel = 10} )
        end

        if kingBayonet then
            kingBayonet:move()
        end
     end
end

-- "scene:create()"
function scene:create( event )
    local sceneGroup = self.view

    -- Physics 
    physics.start()

    -- Create Background
    local background = Background.new()
    sceneGroup:insert(background)

    -- Create Player
    player = PlayerCharacter.Spawn(sceneGroup)

    -- Create HUD
    HUD = GameHUD.new(player.shape, sceneGroup)

    -- Set HUD for player
    player:SetHUD(HUD)

    -- Store background in the scene for later access
    self.background = background
end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Physics
        physics.start()

        -- Reset Game Over
        if HUD then
            HUD:GetGameOverButton().isVisible = false
        end
    elseif ( phase == "did" ) then

        -- Create Player
        if player == nil then
            player = PlayerCharacter.Spawn(sceneGroup)

            if HUD == nil then
                HUD = GameHUD.new(player.shape, sceneGroup)
            else 
                HUD:SetPlayer(player.shape)
                HUD:Reset()
            end

            -- Set HUD for player
            player:SetHUD(HUD)
        end

        -- Create timer to spawn King Bayonet. 2 minutes.
        kingTimer = timer.performWithDelay( bayonetSpawnTimer, spawnKingBayonet, 1 )

        -- Create timer to spawn Enemy 1. 2,5 seconds.
        enemySpawner = timer.performWithDelay( enemySpawnTimer, spawnEnemy, 0 )

        -- Start the game loop
        Runtime:addEventListener("enterFrame", gameLoop)

        -- Play Ingame Music
        SoundManager:playSound("ingameOST", 10, 0.7, -1, 1000)
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

        -- Cancel spawner timer.
        timer.cancel(enemySpawner)

        -- Destroy Player
        if player then
            if HUD then
                HUD:SetPlayer(nil)
            end

            player:destroy()
            player = nil
        end

        -- Destroy King Bayonet
        if kingBayonet then
            kingBayonet:destroy()
            kingBayonet = nil
            KingBayonet = nil
        end

        -- Destroy all enemies
        if #enemies > 0 then
            for i = #enemies, 1, -1 do
                local enemy = enemies[i]
                enemy:destroy()
                table.remove(enemies, i)
            end
        end

        -- Stop the game loop
        Runtime:removeEventListener("enterFrame", gameLoop)

        -- Stop Ingame Music
        SoundManager:stopAudioChannel(10, true, 600)
    elseif ( phase == "did" ) then

        -- Reset PlayerCharacter
        if player then
            player:Reset()
        end

        -- Reset HUD
        if HUD then
            HUD:Reset()
        end
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