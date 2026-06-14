-- Based on the enums within Code/wwsaveload/saveloadids.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SaveLoadIds
local STATIC = CNC.CreateExport()

    --- "  
    --- Chunk ID Ranges
    --- Here are the ranges to use for SubSystem and PersistFactory chunk ID's
    --- and also the chunk ID's used by the save-load system itself.  
    --- If you are creating a new library that is going to take advantage of this
    --- system, create a new range for it here.  
    --- "  
    --- @enum ChunkId
    STATIC.CHUNK_ID = {
        SAVELOAD_BEGIN          = 0x00000100,
            SAVELOAD_DEFMGR     = 0x00000101,
            TWIDDLER            = 0x00000102,
        WW3D_BEGIN				= 0x00010000,
        WWPHYS_BEGIN			= 0x00020000,
        WWAUDIO_BEGIN			= 0x00030000,
        COMBAT_BEGIN			= 0x00040000,
        COMMANDO_EDITOR_BEGIN	= 0x00050000,
        PHYSTEST_BEGIN			= 0x00060000,
        COMMANDO_BEGIN			= 0x00070000,
        WWMATH_BEGIN			= 0x00080000,
        WWTRANSLATEDB_BEGIN		= 0x00090000
    }
--#endregion