-- Based on the enums within Code/WWAudio/AudioSaveLoad.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class AudioSaveLoadIds
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AudioSaveLoadIds"

--#region Exported Enums
--#endregion

--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Chunk IDs ]] do

local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_STATIC_SCENE      = enumBuilder:Set( 0x10291220 ),
        CHUNKID_DYNAMIC_SCENE     = enumBuilder:Next(),
        CHUNKID_DYNAMIC_VARIABLES = enumBuilder:Next(),
    }

    STATIC.VarIds = {
        VARID_INCLUDE_FILE                  = enumBuilder:Set( 0x01 ),
        VARID_CAMERA_TM                     = enumBuilder:Next(),
        VARID_BACK_COLOR                    = enumBuilder:Next(),
        VARID_LOGICAL_LISTENER_GLOBAL_SCALE = enumBuilder:Next(),
        VARID_BACKGROUND_MUSIC_NAME         = enumBuilder:Next(),
    }
end