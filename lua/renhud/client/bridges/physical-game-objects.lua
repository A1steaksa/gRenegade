-- This file contains code to bridge the gap between Garry's Mod Entities and C&C Renegade's concept of Physical Game Objects 

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type CommonBridgeLib
local PARENT = CNC.Import( "renhud/client/bridges/common.lua" )

--- @class PhysicalGameObjectsBridgeClass : CommonBridgeLib
local LIB = CNC.CreateExport( PARENT )


--#region Imports

    --- @type SharedCommon
    local sharedCommon = CNC.Import( "renhud/sh_common.lua" )
--#endregion


--- @param ent Entity
--- @return boolean
function LIB.IsPhysicalGameObject( ent )
    typecheck.AssertArgType( LIB.Class, 1, ent, sharedCommon.EntTypes )
    -- TODO: Implement something here
    return true
end