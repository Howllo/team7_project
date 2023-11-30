--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- KingBayonet.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local timer = require("timer")
local SoundManager = require("src.scene.SoundManager")
local bayonet = require("src.Characters.bayonet.bayonet_sheet")
local mouth = nil
local caudal = nil
local pectoral = nil
local snout = nil
local dorsal = nil
local body = nil
local physics = require("physics")
local display = require("display")
local transition = require("transition")

-- Module
KingBayonet = {}

-- Constructor
--
-- @in_player - The player character.
--
-- @gameHUD - The game HUD.
function KingBayonet.new(in_player, gameHUD)
    local Self = Character.new(display.newRect( 0, 0, 200, 100 ))

    -- Variables
    Self.shape:setFillColor( 1, 1, 1, 0.01 )
    Self.shape.MaxHealthPoints = 30
    Self.shape.CurrentHealthPoints = 30
    Self.shape.tag = "Enemy"
    Self.shape.ScoreWorth = 10000
    Self.shape.BayonetGroup = bayonet.GetBayonetGroup()
    Self.shape.player = in_player
    Self.isDead = false
    Self.gameHUD = gameHUD
    Self.shape.phase = 0
    Self.Damage = 1

    -- Local Variables 
    local transitionFinish = true
    local isReloading = false
    local isShooting = false
    local maxShoots = 0
    local currentShoots = 0
    
   function Self:spawn()
        mouth = require("src.Characters.bayonet.mouth_bayonet")
        caudal = require("src.Characters.bayonet.caudal_bayonet")
        pectoral = require("src.Characters.bayonet.pectoral_bayonet")
        snout = require("src.Characters.bayonet.snout_bayonet")
        dorsal = require("src.Characters.bayonet.dorsal_bayonet")
        body = require("src.Characters.bayonet.body_bayonet")

        -- Set Collision
        Self.shape.x = body.body.x + 10
        Self.shape.y = body.body.y - 10

        -- Physics Two
        physics.addBody( Self.shape, "kinematic", {isSensor = false, categoryBits = 2, maskBits = 3} )
   end

    local function Helper()
        timer.performWithDelay( 1000, function()
            transitionFinish = true
        end, 1)
        if isShooting == false then
            isShooting = true
            Self:Ability()
        end
    end 

    function Self:move()
        if transitionFinish then 
            transitionFinish = false
            local timingMin = 0
            local timingMax = 0

            -- Three Different Phases
            if (Self.shape.CurrentHealthPoints/ 30) * 100 > 50 then
                timingMin = 1200
                timingMax = 1500
                Self.shape.phase = 1
            elseif (Self.shape.CurrentHealthPoints/ 30) * 100 > 10 and (Self.shape.CurrentHealthPoints/ 30) * 100 <= 50 then
                timingMin = 600
                timingMax = 800
                Self.shape.phase = 2
            elseif (Self.shape.CurrentHealthPoints/ 30) * 100 <= 10 then
                timingMin = 400
                timingMax = 600
                Self.shape.phase = 3
            end

            local locX = math.random(275, 1050)
            local locY = math.random(200, 610)
            transition.to(bayonetGroup, {time = math.random(timingMin, timingMax), x = locX, y = locY, onComplete= Helper })
        end
    end
 
    function Self:destroy()
        if Self.shape.player then
            Self.shape.player.shape.BayonetGroup = nil
        end
        
        bayonetGroup:removeSelf()
        display.remove( Self.shape )
        local bayonet = nil
        local mouth = nil
        local caudal = nil
        local pectoral = nil
        local snout = nil
        local dorsal = nil
        local body = nil
        Self.shape.MaxHealthPoints = nil
        Self.shape.CurrentHealthPoints = nil
        Self.shape.tag = nil
        Self.shape.ScoreWorth = nil
        Self.shape.BayonetGroup = nil
        Self.shape.player = nil
        Self.isDead = true
    end
 
    function Self.shape:DealDamage(damage)
        Self.shape.CurrentHealthPoints = Self.shape.CurrentHealthPoints - damage
        
        -- Damage Sound
        if damage > 0 then
            SoundManager:playSound("bayonetDamage", 4, 0.3, 0)
        end

        if Self.gameHUD then
            Self.gameHUD:UpdateBayonetHealthBar(Self.shape.CurrentHealthPoints)
        end
 
        if Self.shape.CurrentHealthPoints <= 0 then
            Self:destroy()
        end
    end
 
    local function onEnemyCollision(event)
        if event.phase == "began" then
            if event.other.tag == "Player" then
                event.other:DealDamage(4)
            end
        end
    end
    Self.shape:addEventListener("collision", onEnemyCollision)

    -- Activate Health Bar
    Self.shape:DealDamage(0)

    -- Update function
    local function update()
        if Self.shape then
            Self.shape.x = bayonetGroup.x
            Self.shape.y = bayonetGroup.y
        end
    end
    timer.performWithDelay( 20, update, 0)

    -- Combat Shooting
    local function finishReloading()
        isReloading = false
        isShooting = false
    end

    local function PhaseOne()
        if currentShoots >= maxShoots then
            isReloading = true
            currentShoots = 0
            timer.performWithDelay( 2000, finishReloading, 1)
        end
    end

    local function PhaseTwo()
        if currentShoots >= maxShoots then
            isReloading = true
            currentShoots = 0
            timer.performWithDelay( 3000, finishReloading, 1)
        end
    end

    local function PhaseThree()
        if currentShoots >= maxShoots then
            isReloading = true
            currentShoots = 0
            timer.performWithDelay( 5000, finishReloading, 1)
        end
    end

    function Self:Ability()
        if Self.isDead == true or Self.shape == nil or isReloading then return end

        if Self.shape.phase == 1 then
            maxShoots = 10
            timer.performWithDelay( 300, function ()
                Self:Fire()
                PhaseOne()
            end, maxShoots)
        elseif Self.shape.phase == 2 then
            maxShoots = 20
            timer.performWithDelay( 100, function ()
                Self:Fire()
                PhaseTwo()
            end, maxShoots)
        elseif Self.shape.phase == 3 then
            maxShoots = 30
            timer.performWithDelay( 10, function ()
                Self:Fire()
                PhaseThree()
            end, maxShoots)
        end
    end

    function Self:Fire()
        if Self.isDead == true or Self.shape == nil then return end

        currentShoots = currentShoots + 1
        SoundManager:playSound("bayonetShoot", 4, 0.1, 0)
        Projectile.new(Self.shape, {x = Self.shape.x - 140, y = Self.shape.y}, Self.Damage, -50, 0, 8)
    end

    return Self
end

return KingBayonet