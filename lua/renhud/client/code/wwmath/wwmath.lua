-- Based on WWMath within Code/WWMath/wwmath.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- The static components of WWMath
--- @class WWMathClass
local LIB = CNC.CreateExport()
local CLASS = "WWMath"
local isHotload = not table.IsEmpty( LIB )


LIB.EPSILON  = 0.0001
LIB.EPSILON2 = LIB.EPSILON * LIB.EPSILON
LIB.PI       = 3.141592654
LIB.SQRT2    = 1.414213562
LIB.SQRT3    = 1.732050808
LIB.OOSQRT2  = 0.707106781
LIB.OOSQRT3  = 0.577350269

--- @param val number
--- @param min number
--- @param max number
--- @return number
function LIB.Wrap( val, min, max )
    -- "Implemented as an if rather than a while, to long loops"

    if val >= max then val = val - (max-min) end
    if val < min then val = val + (max-min) end

    if val < min then val = min end
    if val > max then val = max end

    return val
end

--- "Inverse square root"
--- @param val number
function LIB.InvSqrt( val )
    return 1.0 / math.sqrt( val )
end

--- @param y number
--- @param x number
--- @return number
function LIB.Atan2( y, x )
    -- Convert -0 to 0
    if y == -y then y = 0 end
    if X == -x then X = 0 end

    -- Very small non-zero values might be causing problems 
    if math.IsNearlyEqual( y, 0, 0.01 ) then y = 0 end
    if math.IsNearlyEqual( x, 0, 0.01 ) then x = 0 end

    return math.atan2( y, x )
end