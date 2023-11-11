--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- KingBayonet.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local Projectile = require("src.Characters.Projectile")
local bayonet = require("src.Characters.bayonet.bayonet_sheet")
local mouth = require("src.Characters.bayonet.mouth_bayonet")
local caudal = require("src.Characters.bayonet.caudal_bayonet")
local pectoral = require("src.Characters.bayonet.pectoral_bayonet")
local snout = require("src.Characters.bayonet.snout_bayonet")
local dorsal = require("src.Characters.bayonet.dorsal_bayonet")
local body = require("src.Characters.bayonet.body_bayonet")

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