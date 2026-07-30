-- Based on the enums within Code/Commando/commandochunkids.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class CommandoChunkIds
local STATIC = CNC.CreateExport()

--#region Imports

    --- @type SaveLoadIds
    local saveLoadIds = CNC.Import( "code/wwsaveload/save-load-ids.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
    local builder = enumBuilderClass.New()
--#endregion

--#region Exported Enums

    --- "  
    --- Chunk ID Ranges
    --- Here are the ranges to use for SubSystem and PersistFactory chunk ID's
    --- and also the chunk ID's used by the save-load system itself.  
    --- If you are creating a new library that is going to take advantage of this
    --- system, create a new range for it here.  
    --- "  
    --- @enum CommandoChunkId
    STATIC.CHUNK_ID = {
        CHUNKID_COMMANDO                  = builder:Set( saveLoadIds.ChunkIds.CHUNKID_COMMANDO_BEGIN ),
        CHUNKID_COMMANDO_SOLDIER_OBSERVER = builder:Next()
    }
--#endregion
