--***********************************************************************************************
-- Tony Hardiman, Christian McDonald, Jack Hartwig, Robert Morgan
-- Team Project
-- Projectile.lua
--***********************************************************************************************

-- Requirements
local physics = require("physics")

--Module 
Projectile = {}

function Projectile.new()
    local Self = {}

    -- Variables
    Self.Damage = 0

    return Self
end

return Projectile