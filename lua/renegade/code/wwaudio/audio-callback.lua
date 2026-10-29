-- Based on AudioCallbackClass within Code/WWAudio/AudioEvents.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class AudioCallbackClass
--- @field Instance AudioCallbackInstance The metatable used by AudioCallbackInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AudioCallbackClass"

--- @class AudioCallbackInstance
--- @field Static AudioCallbackClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AudioCallback" )
INSTANCE.Class = "AudioCallbackInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAudioCallback = true

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum AudioCallbackEvent
    STATIC.AUDIO_CALLBACK_EVENT = {
        EVENT_NONE          = 0x0000,
        EVENT_SOUND_STARTED = 0x0001,
        EVENT_SOUND_ENDED   = 0x0002,
        EVENT_LOGICAL_HEARD = 0x0004
    }
    local audioCallbackEventEnum = STATIC.AUDIO_CALLBACK_EVENT

--#endregion

--#region Imports

--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class AudioCallbackClass

    --- Creates a new AudioCallbackInstance
    --- @return AudioCallbackInstance
    function STATIC.New()
        return robustclass.New( "Renegade_AudioCallback" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AudioCallbackInstance, `false` otherwise
    function STATIC.IsAudioCallback( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAudioCallback and true or false
    end

    typecheck.RegisterType( "AudioCallbackInstance", STATIC.IsAudioCallback )
end


--- @class AudioCallbackInstance
--- @field SoundList SoundSceneObjectInstance[]

function INSTANCE:Renegade_AudioCallback()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_AudioCallback()
	typecheck.NotImplementedError()
end

--- @param soundObject SoundSceneObjectInstance
function INSTANCE:OnSoundStarted( soundObject )
	-- Empty in the original code
end

--- @param soundObject SoundSceneObjectInstance
function INSTANCE:OnSoundEnded( soundObject )
	-- Empty in the original code
end

--- @param listener LogicalListenerInstance
--- @param soundObject SoundSceneObjectInstance
function INSTANCE:OnLogicalHeard( listener, soundObject )
	-- Empty in the original code
end

function INSTANCE:OnRegistered()
	typecheck.NotImplementedError()
end

function INSTANCE:OnUnRegistered()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveAllCallbacks()
	typecheck.NotImplementedError()
end
