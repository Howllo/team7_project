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

-- Module
KingBayonet = {}

-- Constructor
--
-- @in_player - The player character.
--
-- @gameHUD - The game HUD.
function KingBayonet.Spawn(in_player, gameHUD)
    local Self = Character.new(display.newRect( bayonet.GetBayonetGroup(), body.body.x + 10, body.body.y - 10, 200, 100 ))

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
    
    -- Physics Two
    physics.addBody( Self.shape, "kinematic", {isSensor = false, categoryBits = 2, maskBits = 3} )

    function Self:move()
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
            print("Deal damaage to player if close enough")
        end
    end
    Self.shape.collision = onEnemyCollision
    Self.shape:addEventListener("collision")

    -- Activate Health Bar
    Self.shape:DealDamage(0)

    return Self
end

return KingBayonet