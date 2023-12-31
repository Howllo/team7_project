--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig
-- Team Project
-- Character.lua
--***********************************************************************************************

--Requirements
local display = require("display")

-- Module
Character = {}

function Character.new(shapeObject)
    local Self = {}

    -- Varaibles
    Self.shape = shapeObject
    Self.shape.MaxHealthPoints = 0
    Self.shape.CurrentHealthPoints = 0
    Self.shape.tag = ""

    function Self:spawn()
        print("Module Character: spawn()")
    end

    function Self:move()
        print("Module Character: move()")
    end

    function Self:destroy()
        print("Module Character: destroy()")
    end

    function Self.shape:DealDamage(damage)
        if Self.shape then
            local SoundManager = require("src.scene.SoundManager")
            SoundManager:playSound("enemyDamage", 4, 0.2, 0)
            Self.shape.CurrentHealthPoints = Self.shape.CurrentHealthPoints - damage
        end
    end

    return Self
end

return Character