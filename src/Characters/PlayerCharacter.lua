--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- PlayerCharacter.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local Projectile = require("src.Characters.Projectile")

-- Module
PlayerCharacter = {}

function PlayerCharacter.new()
    local Self = Character.new()

    -- Variables
    Self.MaxHealthPoints = 5
    Self.CurrentHealthPoints = Self.MaxHealthPoints
    Self.tag = "Player"

    function Self:move()
        print("PlayerCharacter:move()")
    end

    function Self:spawn()
        print("PlayerCharacter:spawn()")
    end

    function Self:destroy()
        print("PlayerCharacter:destroy()")
    end

    return Self
end

return PlayerCharacter