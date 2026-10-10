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

    --- @enum ActionCompleteReason
    STATIC.ACTION_COMPLETE_REASON = {
        ACTION_COMPLETE_NORMAL                = enumBuilder:Set( 0 ),
        ACTION_COMPLETE_LOW_PRIORITY          = enumBuilder:Next(),
        ACTION_COMPLETE_PATH_BAD_START        = enumBuilder:Next(),
        ACTION_COMPLETE_PATH_BAD_DEST         = enumBuilder:Next(),
        ACTION_COMPLETE_MOVE_NO_PROGRESS_MADE = enumBuilder:Next(),
        ACTION_COMPLETE_ATTACK_OUT_OF_RANGE   = enumBuilder:Next(),

        -- Conversation support
        ACTION_COMPLETE_CONVERSATION_ENDED          = enumBuilder:Next(),
        ACTION_COMPLETE_CONVERSATION_INTERRUPTED    = enumBuilder:Next(),
        ACTION_COMPLETE_CONVERSATION_UNABLE_TO_INIT = enumBuilder:Next(),

        MOVEMENT_COMPLETE_ARRIVED = enumBuilder:Next(), -- TEMP
    }
    local actionCompleteReasonEnum = STATIC.ACTION_COMPLETE_REASON

    --- @enum CustomEvent
    STATIC.CUSTOM_EVENT = {
        CUSTOM_EVENT_SYSTEM_FIRST             = enumBuilder:Set( 1000000000 ),
        CUSTOM_EVENT_SOUND_ENDED              = enumBuilder:Next(),
        CUSTOM_EVENT_BUILDING_POWER_CHANGED   = enumBuilder:Next(),
        CUSTOM_EVENT_DOCK_BACKING_IN          = enumBuilder:Next(),
        CUSTOM_EVENT_CINEMATIC_SET_FIRST_SLOT = enumBuilder:Next(),
        CUSTOM_EVENT_CINEMATIC_SET_LAST_SLOT  = enumBuilder:Offset( 20 ),
        CUSTOM_EVENT_POWERUP_GRANTED          = enumBuilder:Next(),
        CUSTOM_EVENT_BUILDING_DAMAGED         = enumBuilder:Next(),
        CUSTOM_EVENT_BUILDING_REPAIRED        = enumBuilder:Next(),
        CUSTOM_EVENT_VEHICLE_ENTERED          = enumBuilder:Next(),
        CUSTOM_EVENT_VEHICLE_EXITED           = enumBuilder:Next(),
        CUSTOM_EVENT_ATTACK_ARRIVED           = enumBuilder:Next(),

        CUSTOM_EVENT_CONVERSATION_BEGAN          = enumBuilder:Next(),
        CUSTOM_EVENT_CONVERSATION_REMARK_STARTED = enumBuilder:Next(),
        CUSTOM_EVENT_CONVERSATION_REMARK_ENDED   = enumBuilder:Next(),

        CUSTOM_EVENT_LADDER_OCCUPIED = enumBuilder:Next(),
        CUSTOM_EVENT_FALLING_DAMAGE  = enumBuilder:Next()
    }
    local customEventEnum = STATIC.CUSTOM_EVENT
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
