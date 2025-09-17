-- Based on WWMath within Code/WWMath/wwmath.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- The static components of WWMath
--- @class WWMathClass
local STATIC = CNC.CreateExport()
local CLASS = "WWMath"
local isHotload = not table.IsEmpty( STATIC )


STATIC.EPSILON  = 0.0001
STATIC.EPSILON2 = STATIC.EPSILON * STATIC.EPSILON
STATIC.PI       = 3.141592654
STATIC.SQRT2    = 1.414213562
STATIC.SQRT3    = 1.732050808
STATIC.OOSQRT2  = 0.707106781
STATIC.OOSQRT3  = 0.577350269


--- Implemented as poorly as it was in the original code
--- @param val number
--- @param min number
--- @param max number
--- @return number
function STATIC.Wrap( val, min, max )
    -- "Implemented as an if rather than a while, to long loops"

    if val >= max then val = val - (max-min) end
    if val < min then val = val + (max-min) end

    if val < min then val = min end
    if val > max then val = max end

    return val
end