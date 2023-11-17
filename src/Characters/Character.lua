--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
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

    function Self.shape:spawn()
        print("Module Character: spawn()")
    end

    function Self.shape:move()
        print("Module Character: move()")
    end

    function Self.shape:destroy()
        print("Module Character: destroy()")
    end

    function Self.shape:DealDamage(damage)
        Self.shape.CurrentHealthPoints = Self.shape.CurrentHealthPoints - damage
    end

    return Self
end

return Character