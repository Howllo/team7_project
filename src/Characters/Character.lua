--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- Character.lua
--***********************************************************************************************

--Requirements
local display = require("display")

-- Module
Character = {}

function Character.new()
    local Self = {}

    -- Varaibles
    Self.MaxHealthPoints = 0
    Self.CurrentHealthPoints = 0
    Self.tag = ""
    Self.shape = display.newRect(0, 0, 0, 0)

    function Self:spawn()
        print("Module Character: spawn()")
    end

    function Self:move()
        print("Module Character: move()")
    end

    function Self:DealDamage(damage)
        Self.CurrentHealthPoints = Self.CurrentHealthPoints - damage
    end

    return Self
end

return Character