-- Based on StaticAudioSaveLoadClass within Code/WWAudio/AudioSaveLoad.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SaveLoadSubSystemClass
local saveLoadSubSystemClass = CNC.Import( "code/wwsaveload/save-load-sub-system.lua" )

--- @class StaticAudioSaveLoadClass : SaveLoadSubSystemClass
--- @field Instance StaticAudioSaveLoadInstance The metatable used by StaticAudioSaveLoadInstance
local STATIC = CNC.CreateExport( saveLoadSubSystemClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "StaticAudioSaveLoadClass"

--- @class StaticAudioSaveLoadInstance : SaveLoadSubSystemInstance
--- @field Static StaticAudioSaveLoadClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_StaticAudioSaveLoad : Renegade_SaveLoadSubSystem" )
INSTANCE.Class = "StaticAudioSaveLoadInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsStaticAudioSaveLoad = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SoundChunkIds
	local soundChunkIds = CNC.Import( "code/wwaudio/sound-chunk-ids.lua" )

	--- @type AudioSaveLoadIds
	local audioSaveLoadIds = CNC.Import( "code/wwaudio/audio-save-load-ids.lua" )

	--- @type WWAudioClass
	local wWAudioClass = CNC.Import( "code/wwaudio/ww-audio.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class StaticAudioSaveLoadClass

    --- Creates a new StaticAudioSaveLoadInstance
    --- @return StaticAudioSaveLoadInstance
    function STATIC.New()
        return robustclass.New( "Renegade_StaticAudioSaveLoad" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) StaticAudioSaveLoadInstance, `false` otherwise
    function STATIC.IsStaticAudioSaveLoad( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsStaticAudioSaveLoad and true or false
    end

    typecheck.RegisterType( "StaticAudioSaveLoadInstance", STATIC.IsStaticAudioSaveLoad )

    function STATIC.StaticConstructor()
        STATIC.StaticAudioSaveLoadSubsystem = STATIC.New()
    end
end


--- @class StaticAudioSaveLoadInstance

function INSTANCE:Renegade_StaticAudioSaveLoad()
    saveLoadSubSystemClass.Instance.Renegade_SaveLoadSubSystem( self )

	-- Eempty in the original code
end

function INSTANCE:_Renegade_StaticAudioSaveLoad()
    saveLoadSubSystemClass.Instance._Renegade_SaveLoadSubSystem( self )

	-- Eempty in the original code
end

--- "From SaveLoadSubSystemClass"
--- @return integer
function INSTANCE:ChunkId()
	return soundChunkIds.SOUND_CHUNK_ID.CHUNKID_STATIC_SAVELOAD
end

--- @return boolean
function INSTANCE:ContainsData()
    return true
end

--- @param csave ChunkSaveInstance
--- @return boolean
function INSTANCE:Save( csave )
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    local returnValue = true

    while cload:OpenChunk() do
        -- "Load the static scene information"
        if cload:CurChunkId() == audioSaveLoadIds.ChunkIds.CHUNKID_STATIC_SCENE then
            local scene = wWAudioClass.GetInstance():GetSoundScene()
            if scene ~= nil then
                scene:LoadStatic( cload )
            end
        end
        cload:CloseChunk()
    end

    return returnValue
end

--- @return string
function INSTANCE:Name()
	return "StaticAudioSaveLoadClass"
end
