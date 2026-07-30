-- Based on GameObjObserverClass within Code/Combat/gameobjobserver.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GameObjectObserverClass
--- @field Instance GameObjectObserverInstance The metatable used by GameObjectObserverInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "GameObjectObserverClass"
--- @class GameObjectObserverInstance
--- @field Static GameObjectObserverClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_GameObjectObserver" )
INSTANCE.Class = "GameObjectObserverInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsGameObjectObserver = true


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum PlaceholderName
    STATIC.PLACEHOLDER_NAME = {
        PLACEHOLDER = enumBuilder:Set( 0 ),
        PLACEHOLDER = enumBuilder:Next(),
    }
    local placeholderEnum = STATIC.PLACEHOLDER_NAME
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class GameObjectObserverClass

    --- Creates a new GameObjectObserverInstance
    --- @return GameObjectObserverInstance
    function STATIC.New()
        return robustclass.New( "Renegade_GameObjectObserver" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) GameObjectObserverInstance, `false` otherwise
    function STATIC.IsGameObjectObserver( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsGameObjectObserver and true or false
    end

    typecheck.RegisterType( "GameObjectObserverInstance", STATIC.IsGameObjectObserver )
end

--- @alias GameObjectInstance ScriptableGameObjectInstance

--- @class GameObjectObserverInstance
--- @field Id integer

--- Constructs a new GameObjectObserverInstance
--- @vararg any
function INSTANCE:Renegade_GameObjectObserver()
    self.Id = 0
end

--- @return string
function INSTANCE:GetName()
    typecheck.NotImplementedError()
end

--- @param id integer
function INSTANCE:SetId( id )
    self.Id = id
end

--- @return integer
function INSTANCE:getId()
    return self.Id
end

function INSTANCE:Attach( obj )
end

function INSTANCE:Detach( obj )
end

--[[ Event Functions ]] do
    -- "Event functions which will be called as events happen"

    --- @param obj GameObjectInstance
    function INSTANCE:Created( obj )
    end

    --- @param obj GameObjectInstance
    function INSTANCE:Destroyed( obj )
    end

    --- @param obj GameObjectInstance
    --- @param killer GameObjectInstance
    function INSTANCE:Killed( obj, killer )
    end

    --- @param obj GameObjectInstance
    --- @param damager GameObjectInstance
    --- @param amount number
    function INSTANCE:Damaged( obj, damager, amount )
    end

    --- @param obj GameObjectInstance
    --- @param type integer
    --- @param param integer
    --- @param sender GameObjectInstance
    function INSTANCE:Custom( obj, type, param, sender )
    end

    --- @param obj GameObjectInstance
    --- @param sound CombatSoundInstance
    function INSTANCE:SoundHeard( obj, sound )
    end

    --- @param obj GameObjectInstance
    --- @param enemy GameObjectInstance
    function INSTANCE:EnemySeen( obj, enemy )
    end

    --- @param obj GameObjectInstance
    --- @param actionId integer
    --- @param completeReason ActionCompleteReason
    function INSTANCE:ActionComplete( obj, actionId, completeReason )
    end

    --- @param obj GameObjectInstance
    --- @param timerId integer
    function INSTANCE:TimerExpired( obj, timerId )
    end

    --- @param obj GameObjectInstance
    --- @param animationName string
    function INSTANCE:AnimationComplete( obj, animationName )
    end

    --- @param obj GameObjectInstance
    --- @param poker GameObjectInstance
    function INSTANCE:Poked( obj, poker )
    end

    --- @param obj GameObjectInstance
    --- @param enterer GameObjectInstance
    function INSTANCE:Entered( obj, enterer )
    end

    --- @param obj GameObjectInstance
    --- @param exiter GameObjectInstance
    function INSTANCE:Exited( obj, exiter )
    end

end
