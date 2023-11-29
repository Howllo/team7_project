--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- KingBayonet.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local timer = require("timer")
local bayonet = require("src.Characters.bayonet.bayonet_sheet")
local mouth = require("src.Characters.bayonet.mouth_bayonet")
local caudal = require("src.Characters.bayonet.caudal_bayonet")
local pectoral = require("src.Characters.bayonet.pectoral_bayonet")
local snout = require("src.Characters.bayonet.snout_bayonet")
local dorsal = require("src.Characters.bayonet.dorsal_bayonet")
local body = require("src.Characters.bayonet.body_bayonet")
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
function KingBayonet.Spawn(in_player, gameHUD)
    local Self = Character.new(display.newRect( body.body.x + 10, body.body.y - 10, 200, 100 ))

    -- Physics
    physics.start()

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
 
    -- Local
    local transitionFinish = true
    local transitionTiming = { time90Min = 1200, time90Max = 1500, time50Min = 800, time50Max = 1000, time10Min = 400, time10Max = 600}
    
    -- Physics Two
    physics.addBody( Self.shape, "kinematic", {isSensor = false, categoryBits = 2, maskBits = 3} )

    local function Helper()
        timer.performWithDelay( 1000, function() 
            transitionFinish = true
        end, 1)
        Self:Ability()
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

    -- Calculate Velocity
    local function calVelocity(angle, speed)
        local xVelocity = math.cos(math.rad(angle)) * speed
        local yVelocity = math.sin(math.rad(angle)) * speed
        return xVelocity, yVelocity
    end
    function Self:Ability()
        if Self.shape.phase == 1 then
            Self:Fire(calVelocity(180, 30))
        elseif Self.shape.phase == 2 then
            Self:Fire(calVelocity(150, 30))
            Self:Fire(calVelocity(180, 30))
            Self:Fire(calVelocity(210, 30))
        elseif Self.shape.phase == 3 then
            Self:Fire(calVelocity(150, 15))
            Self:Fire(calVelocity(180, 15))
            Self:Fire(calVelocity(210, 15))

            timer.performWithDelay( 500, function() 
                Self:Fire(calVelocity(180, 15))
            end, 1)
        end
    end

    function Self:Fire(xVelocity, yVelocity)
        Projectile.new(Self.shape, {x = Self.shape.x - 100, y = Self.shape.y},Self.Damage, xVelocity, yVelocity, 8)
    end

    return Self
end

return KingBayonet