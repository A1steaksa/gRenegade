-- Based on GameObjObserverTimerClass within Code/Combat/scriptablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GameObjectObserverTimerClass
--- @field Instance GameObjectObserverTimerInstance The metatable used by GameObjectObserverTimerInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "GameObjectObserverTimerClass"
--- @class GameObjectObserverTimerInstance
--- @field Static GameObjectObserverTimerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_GameObjectObserverTimer" )
INSTANCE.Class = "GameObjectObserverTimerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsGameObjectObserverTimer = true



--#region Imports
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--#region Imported Enums
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_TIMER_VARIABLES = enumBuilder:Set( 922991755 ),
        CHUNKID_TIMER_SENDER    = enumBuilder:Next(),

        MICROCHUNKID_REMAINING_TIME = enumBuilder:Set( 1 ),
        MICROCHUNKID_TIMER_ID       = enumBuilder:Next(),
        MICROCHUNKID_OBSERVER_ID    = enumBuilder:Next(),
        MICROCHUNKID_TYPE           = enumBuilder:Next(),
        MICROCHUNKID_PARAM          = enumBuilder:Next(),
    }
end



--[[ Static Functions and Variables ]] do

    --- @class GameObjectObserverTimerClass

    --- Creates a new GameObjectObserverTimerInstance
    --- @param observerId integer? [Default: 0]
    --- @param time number? [Default:0]
    --- @param timerId integer? [Default: 0]
    --- @return GameObjectObserverTimerInstance
    function STATIC.New( observerId, time, timerId )
        return robustclass.New( "Renegade_GameObjectObserverTimer", observerId, time, timerId )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) GameObjectObserverTimerInstance, `false` otherwise
    function STATIC.IsGameObjectObserverTimer( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsGameObjectObserverTimer and true or false
    end

    typecheck.RegisterType( "GameObjectObserverTimerInstance", STATIC.IsGameObjectObserverTimer )
end


--- @class GameObjectObserverTimerInstance
--- @field ObserverId integer
--- @field RemainingTime number
--- @field TimerId integer

--- Constructs a new GameObjectObserverTimerInstance
--- @param observerId integer? [Default: 0]
--- @param time number? [Default:0]
--- @param timerId integer? [Default: 0]
function INSTANCE:Renegade_GameObjectObserverTimer( observerId, time, timerId )
    self.ObserverId    = observerId or 0
    self.RemainingTime = time       or 0
    self.TimerId       = timerId    or 0
end


--[[ Save / Load ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:Load( cload )
        typecheck.NotImplementedError()
    end
end

--- @return boolean
function INSTANCE:Update()
    self.RemainingTime = self.RemainingTime - FrameTime()
    return self.RemainingTime <= 0
end

--- @return boolean
function INSTANCE:Expired()
    return self.RemainingTime <= 0
end