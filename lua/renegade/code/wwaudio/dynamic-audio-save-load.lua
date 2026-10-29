-- Based on DynamicAudioSaveLoadClass within Code/WWAudio/AudioSaveLoad.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SaveLoadSubSystemClass
local saveLoadSubSystemClass = CNC.Import( "code/wwsaveload/save-load-sub-system.lua" )

--- @class DynamicAudioSaveLoadClass : SaveLoadSubSystemClass
--- @field Instance DynamicAudioSaveLoadInstance The metatable used by DynamicAudioSaveLoadInstance
local STATIC = CNC.CreateExport( saveLoadSubSystemClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DynamicAudioSaveLoadClass"

--- @class DynamicAudioSaveLoadInstance : SaveLoadSubSystemInstance
--- @field Static DynamicAudioSaveLoadClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DynamicAudioSaveLoad : Renegade_SaveLoadSubSystem" )
INSTANCE.Class = "DynamicAudioSaveLoadInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDynamicAudioSaveLoad = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SoundChunkIds
	local soundChunkIds = CNC.Import( "code/wwaudio/sound-chunk-ids.lua" )

	--- @type AudioSaveLoadIds
	local audioSaveLoadIds = CNC.Import( "code/wwaudio/audio-save-load-ids.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type LogicalListenerClass
	local logicalListenerClass = CNC.Import( "code/wwaudio/logical-listener.lua" )

	--- @type WWAudioClass
	local wWAudioClass = CNC.Import( "code/wwaudio/ww-audio.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class DynamicAudioSaveLoadClass

    --- Creates a new DynamicAudioSaveLoadInstance
    --- @return DynamicAudioSaveLoadInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DynamicAudioSaveLoad" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DynamicAudioSaveLoadInstance, `false` otherwise
    function STATIC.IsDynamicAudioSaveLoad( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDynamicAudioSaveLoad and true or false
    end

    typecheck.RegisterType( "DynamicAudioSaveLoadInstance", STATIC.IsDynamicAudioSaveLoad )

    function STATIC.StaticConstructor()
        STATIC.DynamicAudioSaveLoadSubsystem = STATIC.New()
    end
end


--- @class DynamicAudioSaveLoadInstance

function INSTANCE:Renegade_DynamicAudioSaveLoad()
    saveLoadSubSystemClass.Instance.Renegade_SaveLoadSubSystem( self )

    -- Eempty in the original code
end

function INSTANCE:_Renegade_DynamicAudioSaveLoad()
    saveLoadSubSystemClass.Instance._Renegade_SaveLoadSubSystem( self )

	-- Eempty in the original code
end

--- "From SaveLoadSubSystemClass"
--- @return integer
function INSTANCE:ChunkId()
	return soundChunkIds.SOUND_CHUNK_ID.CHUNKID_DYNAMIC_SAVELOAD
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
        local id = cload:CurChunkId()

        if id == audioSaveLoadIds.ChunkIds.CHUNKID_DYNAMIC_VARIABLES then
            -- "Read all the variables from their micro-chunks"
            while cload:OpenMicroChunk() do
                local microChunkId = cload:CurMicroChunkId()

                -- "Load the global scale for logical listeners"
                if microChunkId == audioSaveLoadIds.VarIds.VARID_LOGICAL_LISTENER_GLOBAL_SCALE then
                    local varTable = { GlobalScale = 1.0 }
                    chunkIOClass.LoadMicroChunk( cload, fundamentalDataTypeEnum.Float, varTable, "GlobalScale" )
                    logicalListenerClass.SetGlobalScale( varTable.GlobalScale )

                -- "Load the background music name"
                elseif microChunkId == audioSaveLoadIds.VarIds.VARID_BACKGROUND_MUSIC_NAME then
                    local varTable = {}
                    chunkIOClass.LoadMicroChunkWWString( cload, varTable, "FileName" )
                    wWAudioClass.GetInstance():SetBackgroundMusic( varTable.FileName )
                end

                cload:CloseMicroChunk()
            end

        -- "Load the static scene information"
        elseif id == audioSaveLoadIds.ChunkIds.CHUNKID_DYNAMIC_SCENE then
            local scene = wWAudioClass.GetInstance():GetSoundScene()
            if scene ~= nil then
                scene:LoadDynamic( cload )
            end
        end

        cload:CloseChunk()
    end

    return returnValue
end

--- @return string
function INSTANCE:Name()
	return "DynamicAudioSaveLoadClass"
end
