-- Based on TranslateDbClass within Code/wwtranslatedb/translatedb.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SaveLoadSubSystemClass
local saveLoadSubSystemClass = CNC.Import( "code/wwsaveload/save-load-sub-system.lua" )

--- @class TranslateDbClass : SaveLoadSubSystemClass
--- @field Instance TranslateDbInstance The metatable used by TranslateDbInstance
local STATIC = CNC.CreateExport( saveLoadSubSystemClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TranslateDbClass"

--- @class TranslateDbInstance : SaveLoadSubSystemInstance
--- @field Static TranslateDbClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_TranslateDb : Renegade_SaveLoadSubSystem" )
INSTANCE.Class = "TranslateDbInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsTranslateDb = true

--#region Exported Enums
	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	local enumBuilder = enumBuilderClass.New()

	--- @enum LANGUAGE_ID
	STATIC.LANGUAGE_ID = {
		LANGID_ENGLISH	= enumBuilder:Set( 0 ),
		LANGID_FRENCH	= enumBuilder:Next(),
		LANGID_GERMAN	= enumBuilder:Next(),
		LANGID_SPANISH	= enumBuilder:Next(),
		LANGID_CHINESE	= enumBuilder:Next(),
		LANGID_JAPANESE	= enumBuilder:Next(),
		LANGID_KOREAN	= enumBuilder:Next(),
	}
	local languageIdEnum = STATIC.LANGUAGE_ID

	--- @enum FILTER_OPT
	STATIC.FILTER_OPT = {
		FILTER_DISABLED 	= enumBuilder:Set( 0 ),
		FILTER_IF_EQuAL 	= enumBuilder:Next(),
		FILTER_IF_NOT_EQUAL = enumBuilder:Next(),
	}
	local filterOptEnum = STATIC.FILTER_OPT
--#endregion

--#region Imports

	--- @type TranslateDbIdsClass
	local translateDbIdsClass = CNC.Import( "code/wwtranslatedb/translate-db-ids.lua" )

	--- @type SaveLoadSystemClass
	local saveLoadSystemClass = CNC.Import( "code/wwsaveload/save-load.lua" )

	--- @type TdbCategoryClass
	local tdbCategoryClass = CNC.Import( "code/wwtranslatedb/tdb-category.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion


--[[ Chunk IDs ]] do

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES	= enumBuilder:Set( 0x07141200 ),
        CHUNKID_OBJECTS		= enumBuilder:Next(),
		CHUNKID_CATEGORIES	= enumBuilder:Next()
    }
end


--[[ Var IDs ]] do

    STATIC.VarIds = {
        VARID_VERSION_NUMBER	= enumBuilder:Set( 0x01 ),
        VARID_LANGUAGE_ID		= enumBuilder:Next()
    }
end


--[[ Static Functions and Variables ]] do

	--- @class TranslateDbClass
	--- @field ObjectList TdbObjectInstance[]
	--- @field ObjectHash any
	--- @field CategoryList TdbCategoryInstance[]
	--- @field VersionNumber integer
	--- @field LanguageId LANGUAGE_ID
	--- @field IsSingleLanguageExport any
	--- @field CategoryExportFilter any
	--- @field FilterType FILTER_OPT
	--- @field FilterCategoryId integer

	STATIC.ID_MIN = 1000
	STATIC.ID_MAX = 999999

    --- Creates a new TranslateDbInstance
    --- @return TranslateDbInstance
    function STATIC.New()
        return robustclass.New( "Renegade_TranslateDb" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) TranslateDbInstance, `false` otherwise
    function STATIC.IsTranslateDb( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsTranslateDb and true or false
    end

    typecheck.RegisterType( "TranslateDbInstance", STATIC.IsTranslateDb )

	local STRING_NOT_FOUND = "TDBERR"
	local ENGLISH_STRING_NOT_FOUND = "TDBERR"

	--- "Static Member Initialization"
	function STATIC.StaticConstructor()
		STATIC.ObjectList = {}
		STATIC.ObjectHash = {}
		STATIC.CategoryList = {}

		STATIC.VersionNumber = 100
		STATIC.LanguageId = languageIdEnum.LANGID_ENGLISH
		STATIC.IsSingleLanguageExport = false
		STATIC.FilterType = filterOptEnum.FILTER_DISABLED
		STATIC.FilterCategoryId = 0xFFFFFFFF

		STATIC.TheTranslateDb = STATIC.New()
	end

	function STATIC.Initialize()
		-- Omitted setting object list growth step
  	end

	function STATIC.Shutdown()
		STATIC.FreeObjects()
		STATIC.FreeCategories()
	end

	--- @return integer
	function STATIC.GetVersionNumber()
		return STATIC.VersionNumber
	end

	function STATIC.UpdateVersion()
		STATIC.VersionNumber = STATIC.VersionNumber + 1
	end

	--- @return boolean
	function STATIC.IsLoaded()
		return STATIC.ObjectList ~= nil and #STATIC.ObjectList > 0
	end

	function STATIC.ImportStrings()
		typecheck.NotImplementedError()
	end

	function STATIC.ImportCHeader()
		-- This funtion appears to never be used
		typecheck.NotImplementedError()
	end

	function STATIC.ExportCHeader()
		typecheck.NotImplementedError()
	end

	function STATIC.ExportTable()
		typecheck.NotImplementedError()
	end

	--- @param id integer|string
	--- @return string?
	function STATIC.GetString( id )
		-- ( id: integer ): string?
		if isnumber( id ) then
			--- @cast id number

			-- "ID of 0 (zero) is a special case NULL string."
			if id == 0 then
				return nil
			end

			-- "Check to make sure the database is loaded"
			assert( STATIC.IsLoaded() )

			-- "Calculate which index this ID refers to"
			local index = ( id - STATIC.ID_MIN )

			-- "Check to see if the requested ID is in the range of loaded string objects."
			assert( index >= 0 and index <= #STATIC.ObjectList )

			-- "Get the translation object"
			local translationObject = STATIC.ObjectList[index]
			assert( translationObject ~= nil )

			-- "Get the string from the object and return it to the caller"
			return translationObject:GetString() or STRING_NOT_FOUND

		-- ( id: string ): string?
		else
			--- @cast id string

			local str = STRING_NOT_FOUND

			-- "Lookup the object based on its ID"
			local translateObject = STATIC.FindObject( id )
			if translateObject ~= nil then

				-- "Get the string from the object and return it to the caller"
				str = translateObject:GetString()
				section.Print( "Found object for id '", id, "': '", str, "'" )
			else
				section.Print( "Couldn't find object for id '", id, "'" )
			end

			return str
		end
	end

	--- @param id integer|string
	--- @return TdbObjectInstance?
	function STATIC.FindObject( id )
		if isnumber( id ) then
			return STATIC.ObjectList[id --[[@as integer]]]
		else
			return STATIC.ObjectHash[(id --[[@as string]]):lower()]
		end
	end

	function STATIC.GetEnglishString()
		typecheck.NotImplementedError()
	end

	--- @param newObject TdbObjectInstance
	--- @return boolean
	function STATIC.AddObject( newObject )
		local returnValue = false

		assert( newObject ~= nil )
		if newObject ~= nil then

			-- "Try to find an unused ID for the object (if necessary)"
			if newObject:GetId() < STATIC.ID_MIN then
				newObject:SetId( STATIC.FindUniqueId() )
			end

			-- "Determine where in the list this object should be inserted"
			local newId = newObject:GetId()
			local objectIndex = newId - STATIC.ID_MIN

			-- "Add the object to our list"
			STATIC.ObjectList[objectIndex] = newObject

			-- "Insert object to the hash table as well"
			STATIC.ObjectHash[newObject:GetIdDesc():lower()] = newObject

			returnValue = true
		end

		return returnValue
	end

	function STATIC.RemoveObject()
		typecheck.NotImplementedError()
	end

	function STATIC.RemoveAll()
		STATIC.FreeObjects()
	end

	--- @return integer
	function STATIC.GetObjectCount()
		return #STATIC.ObjectList
	end

	--- @param index integer
	--- @return TdbObjectInstance?
	function STATIC.GetObject( index )
		local object

		object = STATIC.ObjectList[index]

		return object
	end

	--- @param categoryId integer
	function STATIC.GetFirstObject( categoryId )
		typecheck.NotImplementedError()
	end

	--- @param categoryId integer
	--- @param currentObject TdbObjectInstance
	function STATIC.GetNextObject( categoryId, currentObject )
		typecheck.NotImplementedError()
	end

	--- @return integer
	function STATIC.GetCategoryCount()
		return #STATIC.CategoryList
	end

	--- @param index integer
	--- @return TdbCategoryInstance?
	function STATIC.GetCategory( index )
		return STATIC.CategoryList[index]
	end


	--- @overload fun( id: integer ): TdbCategoryInstance?
	--- @overload fun( name: string ): TdbCategoryInstance?
	function STATIC.FindCategory( id )
		if isstring( id ) then
			local name = id:lower()

			--- "Loop over all the categories until we've found a matching name"
			for index = 1, #STATIC.CategoryList do
				if STATIC.CategoryList[index]:GetName():lower() == name then
					return STATIC.CategoryList[index]
				end
			end
		else
			--- @cast id integer

			-- "Loop over all the categories until we've found a matching ID"
			for index = 1, #STATIC.CategoryList do
				if STATIC.CategoryList[index]:GetId() == id then
					return STATIC.CategoryList[index]
				end
			end
		end
	end

	--- @overload fun( newCategory: TdbCategoryInstance, assignId: boolean ): boolean
	--- @overload fun( name: string ): TdbCategoryInstance
	function STATIC.AddCategory( newCategory, assignId )
		if isstring( newCategory ) then
			local name = newCategory --[[@as string]]

			-- "Create the new category"
			local category = tdbCategoryClass.New()
			category:SetName( name )

			-- "Add the category to our list and return a pointer to the caller"
			STATIC.AddCategory( category )
			return category

		else
			--- @cast newCategory TdbCategoryInstance

			local returnValue = false

			assert( newCategory ~= nil )
			if newCategory ~= nil then
				-- "Assign this category an ID (if necessary)"
				if assignId and newCategory:GetId() == 0 then
					local newId = 1
					for index = 1, #STATIC.CategoryList do
						local currentId = STATIC.CategoryList[index]:GetId()
						newId = math.max( currentId + 1, newId )
					end
					newCategory:SetId( newId )
				end

				section.Print( "Adding category '", newCategory:GetName(), "'" )

				-- "Add the new category to our list"
				STATIC.CategoryList[#STATIC.CategoryList+1] = newCategory
				returnValue = true
			end

			return returnValue
		end
	end

	function STATIC.RemoveCategory()
		typecheck.NotImplementedError()
	end


	--[[ Language Support ]] do

		--- @param languageId LANGUAGE_ID
		function STATIC.SetCurrentLanguage( languageId )
			STATIC.LanguageId = languageId
		end

		--- @return integer
		function STATIC.GetCurrentLanguage()
			return STATIC.LanguageId
		end
	end

	--- @return boolean
	function STATIC.IsSingleLanguageExportEnabled()
		return STATIC.IsSingleLanguageExport
	end

	--- @param onOff boolean
	function STATIC.EnableSingleLanguageExport( onOff )
		STATIC.IsSingleLanguageExport = onOff
	end

	--- @param filter any
	--- @param categoryId any
	function STATIC.SetExportFilter( filter, categoryId )
		typecheck.NotImplementedError()
	end

	function STATIC.ValidateData()
		if #STATIC.CategoryList == 0 then
			-- "Create the default category"
			local category = tdbCategoryClass.New()
			category:SetName( "Default" )
			STATIC.CategoryList[#STATIC.CategoryList+1] = category
		end
	end

	function STATIC.FreeObjects()
		STATIC.ObjectList = {}
		STATIC.ObjectHash = {}
	end

	function STATIC.FreeCategories()
		STATIC.CategoryList = {}
	end

	--- @return integer
	function STATIC.FindUniqueId()
		local newId = STATIC.ID_MIN + #STATIC.ObjectList

		-- "Return the 'id' of the first empty slot in the list"
		for index = 1, #STATIC.ObjectList do
			if STATIC.ObjectList[index] == nil then
				newId = STATIC.ID_MIN + index
				break
			end
		end

		return newId
	end
end


--- @class TranslateDbInstance

function INSTANCE:Renegade_TranslateDb()
	saveLoadSubSystemClass.Instance.Renegade_SaveLoadSubSystem( self )
end

function INSTANCE:_Renegade_TranslateDb()
	-- Empty in the original code.
end

--- @return integer
function INSTANCE:ChunkId()
	return translateDbIdsClass.ChunkIds.CHUNKID_TRANSLATE_DB
end

--- @return string
function INSTANCE:Name()
	return "TranslateDbClass"
end

--- @return boolean
function INSTANCE:ContainsData()
	return true
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
function INSTANCE:Load( cload )
	STATIC.FreeObjects()
	STATIC.FreeCategories()

	local ids = STATIC.ChunkIds

	local returnValue = true

	while cload:OpenChunk() do
		local id = cload:CurChunkId()

		-- "Load all the presets from this chunk"
		if id == ids.CHUNKID_VARIABLES then
			returnValue = returnValue and self:LoadVariables( cload )
		elseif id == ids.CHUNKID_OBJECTS then
			returnValue = returnValue and self:LoadObjects( cload )
		elseif id == ids.CHUNKID_CATEGORIES then
			returnValue = returnValue and self:LoadCategories( cload )
		end

		cload:CloseChunk()
	end

	STATIC.ValidateData()
	return returnValue
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:LoadVariables( cload )
	local returnValue = true

	local ids = STATIC.VarIds

	while cload:OpenMicroChunk() do
		chunkIOClass.ReadMicroChunk( cload, ids.VARID_VERSION_NUMBER, fundamentalDataTypeEnum.UInt32, self, "VersionNumber" )
		chunkIOClass.ReadMicroChunk( cload, ids.VARID_LANGUAGE_ID, fundamentalDataTypeEnum.UInt32, self, "LanguageId" )

		cload:CloseMicroChunk()
	end

	return returnValue
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:LoadObjects( cload )
	local returnValue = true

	while cload:OpenChunk() do
		-- "Load this object from the chunk (if possible)"
		local factory = saveLoadSystemClass.FindPersistFactory( cload:CurChunkId() )
		if factory ~= nil then
			local translateObject = factory:Load( cload ) --[[@as TdbObjectInstance]]
			if translateObject ~= nil then
				STATIC.AddObject( translateObject )
			end
		end

		cload:CloseChunk()
	end

	return returnValue
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:LoadCategories( cload )
	local returnValue = true

	while cload:OpenChunk() do
		-- "Load this object from the chunk (if possible)"
		local factory = saveLoadSystemClass.FindPersistFactory( cload:CurChunkId() )
		if factory ~= nil then
			local category = factory:Load( cload ) --[[@as TdbCategoryInstance]]
			if category ~= nil then
				STATIC.AddCategory( category, false )
			end
		end

		cload:CloseChunk()
	end

	return returnValue
end
