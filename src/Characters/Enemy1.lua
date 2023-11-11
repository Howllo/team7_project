--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- Enemy1.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")

-- Module
Enemy1 = {}

function Enemy1.new()
    local Self = Character.new()
    Self.Projectile = Projectile.new()

    -- Variables
    Self.MaxHealthPoints = 2
    Self.CurrentHealthPoints = Self.MaxHealthPoints
    Self.tag = "Player"

    function Self:move()
    end

    function Self:Spawn()
    end

    return Self
end

return Enemy1