-- This file contains code to bridge the gap between Garry's Mod Entities and C&C Renegade's concept of Physical Game Objects 

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type CommonBridgeLib
local PARENT = CNC.Import( "bridges/sh_common.lua" )

--- @class PhysicalGameObjectsBridgeClass : CommonBridgeLib
local LIB = CNC.CreateExport( PARENT )


--- @param ent Entity
--- @return boolean
function LIB.IsPhysicalGameObject( ent )
    typecheck.AssertArgType( LIB.Class, 1, ent, "Entity" )
    -- TODO: Implement something here
    return true
end