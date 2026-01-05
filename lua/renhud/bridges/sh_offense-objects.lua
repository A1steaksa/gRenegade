-- This file contains code to bridge the gap between Garry's Mod Entities/map elements and C&C Renegade's concept of OffenseObjects 

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type CommonBridgeLib
local PARENT = CNC.Import( "renhud/bridges/sh_common.lua" )

--- @class OffenseObjectsBridge : CommonBridgeLib
local LIB = CNC.CreateExport( PARENT )


--- @param ent Entity
    --- @return boolean
    function LIB.IsOffenseObject( ent )
        -- TODO: Implement something here
        return true
    end