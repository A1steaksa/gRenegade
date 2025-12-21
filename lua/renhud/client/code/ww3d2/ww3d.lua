-- Based on WW3D within Code/ww3d2/ww3d.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class W3dClass 
local STATIC = CNC.CreateExport()
STATIC.Class = "W3dClass"
local isHotload = not table.IsEmpty( STATIC )


--- @param isBiased boolean `true` if 2D rendering should be biased, `false` otherwise
function STATIC.SetScreenUvBias( isBiased )
    STATIC._IsScreenUvBiased = isBiased
end

--- @return boolean `true` if 2D rendering should be biased, `false` otherwise
function STATIC.IsScreenUvBiased()
    return STATIC._IsScreenUvBiased
end