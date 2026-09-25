-- This file contains code to bridge the gap between Garry's Mod Entities/map elements and C&C Renegade's concept of DefenseObjects 

--- @class Renegade
local CNC = CNC_RENEGADE

--- Parent class
--- @type CommonBridgeLib
local PARENT = CNC.Import( "bridges/sh_common.lua" )

--- @class DefenseObjectsBridge : CommonBridgeLib
local LIB = CNC.CreateExport( PARENT )

--- @param ent Entity
--- @return boolean
function LIB.IsDefenseObject( ent )
    typecheck.AssertArgType( LIB.Class, 1, ent, "Entity" )
    -- TODO: Implement something here
    return true
end

--- @param ent Entity
--- @return number
function LIB.GetHealthMax( ent )
    typecheck.AssertArgType( LIB.Class, 1, ent, "Entity" )
    return ent:GetMaxHealth()
end

--- @param ent Entity
--- @return number
function LIB.GetShieldStrengthMax( ent )
    typecheck.AssertArgType( LIB.Class, 1, ent, "Entity" )

    if typecheck.IsOfType( ent, "Player" ) then
        --- @cast ent Player
        return ent:GetMaxArmor()
    end

    return 0
end

--- @param ent Entity
--- @return number
function LIB.GetHealth( ent )
    typecheck.AssertArgType( LIB.Class, 1, ent, "Entity" )
    return ent:Health()
end

--- @param ent Entity
--- @return number
function LIB.GetShieldStrength( ent )
    typecheck.AssertArgType( LIB.Class, 1, ent, "Entity" )
    if typecheck.IsOfType( ent, "Player" ) then
        --- @cast ent Player
        return ent:Armor()
    end

    return 0
end