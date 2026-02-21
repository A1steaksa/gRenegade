-- Based on SoldierGameObj within Code/Combat/soldier.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SmartGameObjectClass
local PARENT = CNC.Import( "code/combat/smart-entity.lua" );

--- @class SoldierGameObjectClass : SmartGameObjectClass
--- @field instance SoldierGameObjectInstance The metatable used by SoldierGameObjectInstance
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "SoldierGameObjectClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class SoldierGameObjectInstance : SmartGameObjectInstance
--- @field Static SoldierGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SoldierEntity : Renegade_SmartEntity" )
INSTANCE.Class = "SoldierGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSoldierEntity = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class SoldierGameObjectClass

    --- Creates a new SoldierGameObjectInstance
    --- @vararg any
    --- @return SoldierGameObjectInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_SoldierEntity", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SoldierGameObjectInstance, `false` otherwise
    function STATIC.IsSoldierEntity( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSoldierEntity and true or false
    end

    typecheck.RegisterType( "SoldierGameObjectInstance", STATIC.IsSoldierEntity )
end


--- @class SoldierGameObjectInstance

--- Constructs a new SoldierGameObjectInstance
--- @vararg any
function INSTANCE:Renegade_SoldierEntity( ... )
    local args = { ... }
    local argCount = select( "#", ... )

    
end

--- @return boolean
function INSTANCE:IsDead()
    return false
end