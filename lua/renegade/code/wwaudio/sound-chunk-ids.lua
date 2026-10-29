-- Based on the enums within Code/WWAudio/SoundChunkIDs.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SoundChunkIds
local STATIC = CNC.CreateExport()

--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type SaveLoadIds
	local saveLoadIds = CNC.Import( "code/wwsaveload/save-load-ids.lua" )

	--- @type DefinitionClassIds
	local definitionClassIds = CNC.Import( "code/wwsaveload/definition-class-ids.lua" )
--#endregion

--#region Exported Enums

    local enumBuilder = enumBuilderClass.New()

    --- "  
    --- These are the chunk IDs that serve as 'globally-unique' persist identifiers for all persist objects inside the editor.
    --- These are used when building the PersistFactoryClass's for definitions.
    --- "  
    --- @enum SoundChunkId
    STATIC.SOUND_CHUNK_ID = {
        CHUNKID_SOUND_DEF        = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_WWAUDIO_BEGIN ),
        CHUNKID_AUDIBLE_SOUND    = enumBuilder:Next(),
        CHUNKID_FILTERED_SOUND   = enumBuilder:Next(),
        CHUNKID_SOUND3D          = enumBuilder:Next(),
        CHUNKID_PSEUDO_SOUND3D   = enumBuilder:Next(),
        CHUNKID_STATIC_SAVELOAD  = enumBuilder:Next(),
        CHUNKID_DYNAMIC_SAVELOAD = enumBuilder:Next(),
        CHUNKID_LOGICALSOUND     = enumBuilder:Next(),
        CHUNKID_LOGICALLISTENER  = enumBuilder:Next(),
    }
--#endregion

--#region Imported Enums
--#endregion


--- @class SoundChunkIds

STATIC.CLASSID_SOUND_DEF = definitionClassIds.CLASS_ID.SOUND