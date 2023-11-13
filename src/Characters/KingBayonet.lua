--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- KingBayonet.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
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

function KingBayonet.new()
    local Self = Character.new()

    -- Physics
    physics.start()
    physics.setGravity( 0, 0 )

    -- Variables
    Self.shape = display.newRect( bayonet.GetBayonetGroup(), body.body.x + 10, body.body.y - 10, 200, 100 )
    --Self.shape:setFillColor( 0, 0, 0, 0 )
    Self.shape.MaxHealthPoints = 1
    Self.shape.CurrentHealthPoints = Self.MaxHealthPoints
    Self.shape.tag = "Enemy"
    Self.shape.ScoreWorth = 100000
    bayonet.GetBayonetGroup().xScale = 1.5
    bayonet.GetBayonetGroup().yScale = 1.5

    -- Physics Two
    physics.addBody( Self.shape, "static", {isSensor = false} )

    function Self.shape:move()
    end

    function Self.shape:spawn()
    end

    function Self.shape:destroy()
        mouth = nil
        caudal = nil
        pectoral = nil
        snout = nil
        dorsal = nil
        body = nil
        bayonet = nil
    end

    function Self.shape:DealDamage(damage)
        Self.shape.CurrentHealthPoints = Self.shape.CurrentHealthPoints - damage
    end

    local function onEnemyCollision(event)
        if event.phase == "began" then
            print("Deal damaage to player if close enough")
        end
    end
    Self.shape.collision = onEnemyCollision
    Self.shape:addEventListener("collision")

    return Self
end

return KingBayonet