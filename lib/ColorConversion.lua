--Module
local ColorConversion = {}

-- Converts a hex color to normalized RGB values.
function ColorConversion.HexToNorm(hex)
    local hex = hex:gsub("#","")
    local r = tonumber("0x"..hex:sub(1,2)) / 255
    local g = tonumber("0x"..hex:sub(3,4)) / 255
    local b = tonumber("0x"..hex:sub(5,6)) / 255
    return r, g, b
end

-- Converts a hex color to normalized RGBA values.
function ColorConversion.HexToNormAlpha(hex)
    local hex = hex:gsub("#","")
    local r = tonumber("0x"..hex:sub(1,2)) / 255
    local g = tonumber("0x"..hex:sub(3,4)) / 255
    local b = tonumber("0x"..hex:sub(5,6)) / 255
    local a = 1
    return r, g, b, a
end

return ColorConversion