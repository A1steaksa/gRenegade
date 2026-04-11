-- Based on CombatPhysObserverClass within Code/Combat/combatphysobserver.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PhysicsObserverClass
local physicsObserverClass = CNC.Import( "code/wwphys/physics-observer.lua" )

--- @class CombatPhysicsObserverClass : PhysicsObserverClass
--- @field Instance CombatPhysicsObserverInstance The metatable used by CombatPhysicsObserverInstance
local STATIC = CNC.CreateExport( physicsObserverClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "CombatPhysicsObserverClass"

--- @class CombatPhysicsObserverInstance : PhysicsObserverInstance
--- @field Static CombatPhysicsObserverClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_CombatPhysicsObserver" )
INSTANCE.Class = "CombatPhysicsObserverInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsCombatPhysicsObserver = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class CombatPhysicsObserverClass

    --- Creates a new CombatPhysicsObserverInstance
    --- @return CombatPhysicsObserverInstance
    function STATIC.New()
        return robustclass.New( "Renegade_CombatPhysicsObserver" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) CombatPhysicsObserverInstance, `false` otherwise
    function STATIC.IsCombatPhysicsObserver( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsCombatPhysicsObserver and true or false
    end

    typecheck.RegisterType( "CombatPhysicsObserverInstance", STATIC.IsCombatPhysicsObserver )
end


--- @class CombatPhysicsObserverInstance

--- @return DamageableGameObjectInstance?
function INSTANCE:AsDamageableGameObject()
    return nil
end

--- @return PhysicalGameObjectInstance?
function INSTANCE:AsPhysicalGameObject()
    return nil
end

--- @return BuildingGameObjectInstance?
function INSTANCE:AsBuildingGameObject()
    return nil
end
