--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig
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

    -- Create Group
    Self.bayonetGroup = bayonet.GetBayonetGroup()

    -- Variables
    Self.shape:setFillColor( 1, 1, 1, 0.01 )
    Self.shape.MaxHealthPoints = 30
    Self.shape.CurrentHealthPoints = 30
    Self.shape.tag = "Enemy"
    Self.shape.ScoreWorth = 10000
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
    local reloadTimer = nil
    local shootTimer = nil

    -- Create Body Part
    local bodyM = nil
    local dorsalM = nil
    local snoutM = nil
    local pectoralM = nil
    local caudalM = nil
    local mouthM = nil
    
   function Self:spawn()
        -- Requirements
        mouth = require("src.Characters.bayonet.mouth_bayonet")
        caudal = require("src.Characters.bayonet.caudal_bayonet")
        pectoral = require("src.Characters.bayonet.pectoral_bayonet")
        snout = require("src.Characters.bayonet.snout_bayonet")
        dorsal = require("src.Characters.bayonet.dorsal_bayonet")
        body = require("src.Characters.bayonet.body_bayonet")

        -- Create Body Parts
        bodyM = body.new()
        dorsalM = dorsal.new()
        snoutM = snout.new()
        pectoralM = pectoral.new()
        caudalM = caudal.new()
        mouthM = mouth.new()
        
        -- Set Collision
        Self.shape.x = bodyM.x + 10
        Self.shape.y = bodyM.y - 10

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
        if Self.isDead == true or Self.shape == nil then return end

        if transitionFinish then 
            transitionFinish = false
            local timingMin = 0
            local timingMax = 0

            -- Three Different Phases
            if Self.shape.CurrentHealthPoints then
                if (Self.shape.CurrentHealthPoints/ 30) * 100 > 50 then
                    timingMin = 1200
                    timingMax = 1500
                    Self.shape.phase = 1
                elseif (Self.shape.CurrentHealthPoints/ 30) * 100 > 15 and (Self.shape.CurrentHealthPoints/ 30) * 100 <= 50 then
                    timingMin = 600
                    timingMax = 800
                    Self.shape.phase = 2
                elseif (Self.shape.CurrentHealthPoints/ 30) * 100 <= 15 then
                    timingMin = 400
                    timingMax = 600
                    Self.shape.phase = 3
                end
            end

            local locX = math.random(275, 1050)
            local locY = math.random(200, 610)
            transition.to(Self.bayonetGroup, {time = math.random(timingMin, timingMax), x = locX, y = locY, onComplete= Helper })
        end
    end
 
    function Self:destroy()
        KingBayonet.isDead = true
        
        transition.to(Self.bayonetGroup, {time = 0, x = display.contentCenterY + 500, y = display.contentCenterY - 100, onComplete= Helper })

        timer.performWithDelay( 5, function()
            if reloadTimer then
                timer.cancel(reloadTimer)
            end
    
            if shootTimer then
                timer.cancel(shootTimer)
            end
            
            if bodyM then
                bodyM:removeSelf()
                bodyM = nil
            end
    
            if dorsalM then
                dorsalM:removeSelf()
                dorsalM = nil
            end
    
            if snoutM then
                snoutM:removeSelf()
                snoutM = nil
            end
    
            if pectoralM then
                pectoralM:removeSelf()
                pectoralM = nil
            end
    
            if caudalM then
                caudalM:removeSelf()
                caudalM = nil
            end
    
            if mouthM then
                mouthM:removeSelf()
                mouthM = nil
            end

            Self.shape:removeSelf()
        end, 1)
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
        if Self.shape and Self.bayonetGroup then
            Self.shape.x = Self.bayonetGroup.x
            Self.shape.y = Self.bayonetGroup.y
        end
    end
    timer.performWithDelay( 20, update, 0)

    -- Combat Shooting
    local function finishReloading()
        isReloading = false
        isShooting = false
    end

    local function Phasing(timing)
        if Self.isDead == true or Self.shape == nil then return end
        if currentShoots >= maxShoots then
            isReloading = true
            currentShoots = 0
            reloadTimer = timer.performWithDelay( timing, finishReloading, 1 )
        end
    end

    function Self:Ability()
        if Self.isDead == true or Self.shape == nil or isReloading then return end

        if Self.shape.phase == 1 then
            maxShoots = 10
            shootTimer = timer.performWithDelay( 300, function ()
                Self:Fire()
                Phasing(2000)
            end, maxShoots)
        elseif Self.shape.phase == 2 then
            maxShoots = 20
            shootTimer = timer.performWithDelay( 100, function ()
                Self:Fire()
                Phasing(3000)
            end, maxShoots)
        elseif Self.shape.phase == 3 then
            maxShoots = 30
            shootTimer = timer.performWithDelay( 10, function ()
                Self:Fire()
                Phasing(5000)
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