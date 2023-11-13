--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- PlayerCharacter.lua
--***********************************************************************************************

-- Requirements
local Character = require("src.Characters.Character")
local Projectile = require("src.Characters.Projectile")
local PlayerMovementShoot = require("src.Characters.PlayerMovementShoot")
local display = require("display")
local physics = require("physics")

-- Module
PlayerCharacter = {}

function PlayerCharacter.new()
    local Self = Character.new()

    -- Physics
    physics.start()
    physics.setGravity( 0, 0 )

    -- Variables
    Self.shape = display.newCircle( 200, display.contentCenterY, 50 )
    Self.shape.MaxHealthPoints = 5
    Self.shape.GameHUD = nil
    Self.shape.CurrentHealthPoints = Self.shape.MaxHealthPoints
    Self.shape.tag = "Player"

    -- Movement
    local PlayerMovementShoot = PlayerMovementShoot.new(Self)

    function Self.shape:destroy()
        print("PlayerCharacter:destroy()")
    end

    function Self.shape:DealDamage(damage)
        Self.shape.CurrentHealthPoints = Self.shape.CurrentHealthPoints - damage
        Self.shape.GameHUD:updateHealthBar()
    end

    function Self.shape:Fire()
        Projectile.new(Self, 1, 25, 15)
    end

    -- Set Game HUD for updating
    function Self.shape:SetHUD(in_Hud)
        Self.shape.GameHUD = in_Hud
    end

    return Self
end

return PlayerCharacter