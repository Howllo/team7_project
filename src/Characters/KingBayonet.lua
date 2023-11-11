--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- KingBayonet.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local Projectile = require("src.Characters.Projectile")
local bayonet = require("src.bayonet.bayonet_sheet")
local mouth = require("src.bayonet.mouth_bayonet")
local caudal = require("src.bayonet.caudal_bayonet")
local pectoral = require("src.bayonet.pectoral_bayonet")
local snout = require("src.bayonet.snout_bayonet")
local dorsal = require("src.bayonet.dorsal_bayonet")
local body = require("src.bayonet.body_bayonet")

-- Module
KingBayonet = {}

function KingBayonet.new()
    local Self = Character.new()
    Self.Projectile = Projectile.new()

    -- Variables
    Self.MaxHealthPoints = 30
    Self.CurrentHealthPoints = Self.MaxHealthPoints
    Self.tag = "Enemy"
    Self.ScoreWorth = 100000

    function Self:move()
    end

    function Self:spawn()
    end

    return Self
end

return KingBayonet