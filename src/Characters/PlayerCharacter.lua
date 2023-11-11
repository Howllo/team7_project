--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- PlayerCharacter.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local Projectile = require("src.Projectiles.Projectile")

-- Module
PlayerCharacter = {}

function PlayerCharacter.new()
    local Self = Character.new()

    -- Variables
    Self.Projectile = Projectile.new()
    Self.MaxHealthPoints = 5
    Self.CurrentHealthPoints = Self.MaxHealthPoints
    Self.tag = "Player"

    return Self
end

return PlayerCharacter