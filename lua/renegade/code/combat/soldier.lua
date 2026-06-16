-- Based on SoldierGameObj within Code/Combat/soldier.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SmartGameObjectClass
local smartGameObjectClass = CNC.Import( "code/combat/smart-game-object.lua" );

--- @class SoldierGameObjectClass : SmartGameObjectClass
--- @field instance SoldierGameObjectInstance The metatable used by SoldierGameObjectInstance
local STATIC = CNC.CreateExport( smartGameObjectClass )
STATIC.Class = "SoldierGameObjectClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class SoldierGameObjectInstance : SmartGameObjectInstance
--- @field Static SoldierGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SoldierGameObject : Renegade_SmartGameObject" )
INSTANCE.Class = "SoldierGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSoldierGameObject = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class SoldierGameObjectClass

    --- Creates a new SoldierGameObjectInstance
    --- @return SoldierGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SoldierGameObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SoldierGameObjectInstance, `false` otherwise
    function STATIC.IsSoldierGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSoldierGameObject and true or false
    end

    typecheck.RegisterType( "SoldierGameObjectInstance", STATIC.IsSoldierGameObject )
end


--- @class SoldierGameObjectInstance

--- Constructs a new SoldierGameObjectInstance
function INSTANCE:Renegade_SoldierGameObject()
    smartGameObjectClass.Instance.Renegade_SmartGameObject( self )

    typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:IsDead()
    return false
end