-- This file contains code to bridge the gap between Garry's Mod Vectors and C&C Renegade's concept of Vector3 

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type CommonBridgeLib
local PARENT = CNC.Import( "renhud/client/bridges/common.lua" )

--- @class VectorBridgeClass : CommonBridgeLib
local LIB = CNC.CreateExport( PARENT )

--- Sets each component of a Vector to the minimum value for that component between itself and another Vector
--- @param toUpdate Vector
--- @param other Vector
function LIB.UpdateMin( toUpdate, other )
    if other.x < toUpdate.x then toUpdate.x = other.x end
    if other.y < toUpdate.y then toUpdate.y = other.y end
    if other.z < toUpdate.z then toUpdate.z = other.z end
end

--- Sets each component of a Vector to the maximum value for that component between itself and another Vector
--- @param toUpdate Vector
--- @param other Vector
function LIB.UpdateMax( toUpdate, other )
    if other.x > toUpdate.x then toUpdate.x = other.x end
    if other.y > toUpdate.y then toUpdate.y = other.y end
    if other.z > toUpdate.z then toUpdate.z = other.z end
end