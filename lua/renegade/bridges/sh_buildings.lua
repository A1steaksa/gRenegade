-- This file contains code to bridge the gap between Garry's Mod Entities/map elements and C&C Renegade's concept of Buildings 

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type CommonBridgeLib
local PARENT = CNC.Import( "bridges/sh_common.lua" )

--- @class BuildingsBridgeClass : CommonBridgeLib
local LIB = CNC.CreateExport( PARENT )


--- Any Entity present as a key in this table is a building
--- @type table<Entity, boolean>
LIB.BuildingEntities = {}

--- Marks an Entity as either being or not being a building
--- @param ent Entity
--- @param isBuilding boolean
function LIB.SetIsBuilding( ent, isBuilding )
    typecheck.AssertArgType( LIB.Class, 1, ent, "Entity" )
    typecheck.AssertArgType( LIB.Class, 2, isBuilding, "boolean" )

    -- Swap nil for false-y values to remove non-buildings from the table for speed or something
    local value = ( isBuilding ) and true or nil

    LIB.BuildingEntities[ ent ] = value
end

--- @param ent Entity
--- @return boolean
function LIB.IsBuilding( ent )
    typecheck.AssertArgType( LIB.Class, 1, ent, "Entity" )

    -- Explicitly test the table value to ensure we return a boolean
    return LIB.BuildingEntities[ ent ] == true
end

--- @param ent Entity
--- @return boolean
function LIB.IsMct( ent )
    typecheck.AssertArgType( LIB.Class, 1, ent, "Entity" )
    -- TODO: Implement something here
    return false
end