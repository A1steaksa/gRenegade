-- Based on the enum within Code/wwtranslatedb/translatedbids.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class TranslateDbIdsClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TranslateDbIdsClass"

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SaveLoadIds
	local saveLoadIds = CNC.Import( "code/wwsaveload/save-load-ids.lua" )

    --- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion

--#region Imported Enums
--#endregion

--- @class TranslateDbIdsClass

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_TRANSLATE_DB	= enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_WWTRANSLATEDB_BEGIN ),
        CHUNKID_TRANSLATE_OBJ	= enumBuilder:Next(),
		CHUNKID_TDBCATEGORY	    = enumBuilder:Next(),
        CHUNKID_STRING_TWIDDLER = enumBuilder:Next(),
    }
end