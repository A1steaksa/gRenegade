-- Based on TranslateDbClass within Code/wwtranslatedb/translatedb.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SaveLoadSubSystemClass
local saveLoadSubSystemClass = CNC.Import( "code/wwsaveload/save-load-sub-system.lua" )

--- @class TranslateDbClass : SaveLoadSubSystemClass
--- @field Instance TranslateDBInstance The metatable used by TranslateDBInstance
local STATIC = CNC.CreateExport( saveLoadSubSystemClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TranslateDbClass"

--- @class TranslateDBInstance : SaveLoadSubSystemInstance
--- @field Static TranslateDbClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_TranslateDB : Renegade_SaveLoadSubSystem" )
INSTANCE.Class = "TranslateDBInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsTranslateDB = true

--#region Exported Enums
	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	local enumBuilder = enumBuilderClass.New()

	

--#endregion

--#region Imports


--#endregion

--#region Imported Enums
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES	= enumBuilder:Set( 0x07141200 ),
        CHUNKID_OBJECTS		= enumBuilder:Next(),
		CHUNKID_CATEGORIES	= enumBuilder:Next()
    }
end

--[[ Var IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.VarIds = {
        VARID_VERSION_NUMBER	= enumBuilder:Set( 0x01 ),
        VARID_LANGUAGE_ID		= enumBuilder:Next()
    }
end

--[[ Static Functions and Variables ]] do

  --- @class TranslateDbClass
  --- @field ObjectList any
  --- @field ObjectHash any
  --- @field CategoryList any
  --- @field VersionNumber any
  --- @field LanguageId any
  --- @field IsSingleLanguageExport any
  --- @field CategoryExportFilter any
  --- @field FilterType any
  --- @field FilterCategoryId any

    --- Creates a new TranslateDBInstance
    --- @return TranslateDBInstance
    function STATIC.New()
        return robustclass.New( "Renegade_TranslateDB" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) TranslateDBInstance, `false` otherwise
    function STATIC.IsTranslateDB( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsTranslateDB and true or false
    end

    typecheck.RegisterType( "TranslateDBInstance", STATIC.IsTranslateDB )

	local STRING_NOT_FOUND = "TDBERR"
	local ENGLISH_STRING_NOT_FOUND = "TDBERR"

	function STATIC.Initialize()
    	typecheck.NotImplementedError()
  	end

	function STATIC.Shutdown()
		typecheck.NotImplementedError()
	end

	function STATIC.GetVersionNumber()
		typecheck.NotImplementedError()
	end

	function STATIC.UpdateVersion()
		typecheck.NotImplementedError()
	end

	function STATIC.IsLoaded()
		typecheck.NotImplementedError()
	end

	function STATIC.ImportStrings()
		typecheck.NotImplementedError()
	end

	function STATIC.ImportCHeader()
		typecheck.NotImplementedError()
	end

	function STATIC.ExportCHeader()
		typecheck.NotImplementedError()
	end

	function STATIC.ExportTable()
		typecheck.NotImplementedError()
	end

	--- @param id integer
	--- @return string?
	function STATIC.GetString( id )
		-- "ID of 0 (zero) is a special case NULL string."
		if id == 0 then
			return nil
		end

		local string = STRING_NOT_FOUND
	end

	function STATIC.GetEnglishString()
		typecheck.NotImplementedError()
	end

	function STATIC.AddObject()
		typecheck.NotImplementedError()
	end

	function STATIC.RemoveObject()
		typecheck.NotImplementedError()
	end

	function STATIC.RemoveAll()
		typecheck.NotImplementedError()
	end

	function STATIC.GetObjectCount()
		typecheck.NotImplementedError()
	end

	function STATIC.GetObject()
		typecheck.NotImplementedError()
	end

	function STATIC.GetFirstObject()
		typecheck.NotImplementedError()
	end

	function STATIC.GetNextObject()
		typecheck.NotImplementedError()
	end

	function STATIC.GetCategoryCount()
		typecheck.NotImplementedError()
	end

	function STATIC.GetCategory()
		typecheck.NotImplementedError()
	end

	function STATIC.FindCategory()
		typecheck.NotImplementedError()
	end

	function STATIC.AddCategory()
		typecheck.NotImplementedError()
	end

	function STATIC.RemoveCategory()
		typecheck.NotImplementedError()
	end

	function STATIC.SetCurrentLanguage()
		typecheck.NotImplementedError()
	end

	function STATIC.GetCurrentLanguage()
		typecheck.NotImplementedError()
	end

	function STATIC.IsSingleLanguageExportEnabled()
		typecheck.NotImplementedError()
	end

	function STATIC.EnableSingleLanguageExport()
		typecheck.NotImplementedError()
	end

	function STATIC.SetExportFilter()
		typecheck.NotImplementedError()
	end

	function STATIC.ValidateData()
		typecheck.NotImplementedError()
	end

	function STATIC.FreeObjects()
		typecheck.NotImplementedError()
	end

	function STATIC.FreeCategories()
		typecheck.NotImplementedError()
	end

	function STATIC.FindUniqueId()
		typecheck.NotImplementedError()
	end
end


--- @class TranslateDBInstance

function INSTANCE:Renegade_TranslateDB()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_TranslateDB()
	typecheck.NotImplementedError()
end

function INSTANCE:ChunkId()
	typecheck.NotImplementedError()
end

function INSTANCE:Name()
	typecheck.NotImplementedError()
end

function INSTANCE:FindObject()
	typecheck.NotImplementedError()
end

function INSTANCE:ContainsData()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadVariables()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadObjects()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadCategories()
	typecheck.NotImplementedError()
end
