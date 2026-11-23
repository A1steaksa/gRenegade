-- Based on TdbObjClass within Code/wwtranslatedb/translateobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

--- @class TdbObjectClass : PersistClass
--- @field Instance TdbObjectInstance The metatable used by TdbObjectInstance
local STATIC = CNC.CreateExport( persistClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TdbObjectClass"

--- @class TdbObjectInstance : PersistInstance
--- @field Static TdbObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_TdbObject : Renegade_Persist" )
INSTANCE.Class = "TdbObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsTdbObject = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type TranslateDbIdsClass
	local translateDbIdsClass = CNC.Import( "code/wwtranslatedb/translate-db-ids.lua" )

	--- @type TdbCategoryClass
	local tdbCategoryClass = CNC.Import( "code/wwtranslatedb/tdb-category.lua" )

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type TranslateDbClass
	local translateDbClass = CNC.Import( "code/wwtranslatedb/translate-db.lua" )

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

local enumBuilder = enumBuilderClass.New()

--[[ Chunk IDs ]] do

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES			= enumBuilder:Set( 0x06141108 ),
        CHUNKID_BASE_CLASS			= enumBuilder:Next(),
		CHUNKID_ENGLISH_STRING		= enumBuilder:Next(),
		CHUNKID_TRANSLATED_STRING	= enumBuilder:Next()
    }
end

--[[ Var IDs ]] do

    STATIC.VarIds = {
		VARID_ID				 = enumBuilder:Set( 0x01 ),
		VARID_ID_DESC			 = enumBuilder:Next(),
		VARID_STRING			 = enumBuilder:Next(),
		VARID_ENGLISH_STRING	 = enumBuilder:Next(),
		VARID_SOUND_ID			 = enumBuilder:Next(),
		VARID_ANIMATION_NAME	 = enumBuilder:Next(),
		VARID_CATEGORY_ID		 = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class TdbObjectClass

    --- Creates a new TdbObjectInstance
    --- @return TdbObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_TdbObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) TdbObjectInstance, `false` otherwise
    function STATIC.IsTdbObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsTdbObject and true or false
    end

    typecheck.RegisterType( "TdbObjectInstance", STATIC.IsTdbObject )

	function STATIC.StaticConstructor()
        STATIC.TranslateObjectPersistFactory = simplePersistFactoryClass.New( STATIC, translateDbIdsClass.ChunkIds.CHUNKID_TRANSLATE_OBJ )
    end
end


--- @class TdbObjectInstance
--- @field EnglishString string
--- @field IdDescription string
--- @field Id integer
--- @field SoundId integer
--- @field CategoryId integer
--- @field AnimationName string
--- @field TranslatedStrings string[]

function INSTANCE:Renegade_TdbObject()
	self.TranslatedStrings = {}

	self.Id = 0
	self.SoundId = -1
	self.CategoryId = tdbCategoryClass.CATEGORY_DEFAULT
end

function INSTANCE:_Renegade_TdbObject()
	-- Empty in the original code.
end


--[[ RTTI ]] do

	--- @return StringTwiddlerInstance?
	function INSTANCE:AsStringTwiddlerClass()
		return nil
	end
end


--[[ From PersistClass ]] do

	--- @return PersistFactoryInstance
	function INSTANCE:GetFactory()
		return STATIC.TranslateObjectPersistFactory
	end

	--- @param csave ChunkSaveInstance
	--- @return boolean
	function INSTANCE:Save( csave )
		typecheck.NotImplementedError()
	end

	--- @param cload ChunkLoadInstance
	--- @return boolean
	function INSTANCE:Load( cload )
		local ids = STATIC.ChunkIds

		while cload:OpenChunk() do
			chunkIOClass.ReadWWStringChunk( cload, ids.CHUNKID_ENGLISH_STRING, self, "EnglishString" )

			local id = cload:CurChunkId()
			if id == ids.CHUNKID_TRANSLATED_STRING then
				-- "Load the translated string from its chunk"
				local readByteCount, readBytes = cload:Read( cload:CurChunkLength() )
				assert( readBytes ~= nil )

				local decodedString = textUtils.DecodeUtf16( readBytes )

				-- "Add the translated string to our list"
				self.TranslatedStrings[#self.TranslatedStrings+1] = decodedString

			elseif id == ids.CHUNKID_BASE_CLASS then
				persistClass.Instance.Load( self, cload )
			elseif id == ids.CHUNKID_VARIABLES then
				self:LoadVariables( cload )
			end

			cload:CloseChunk()
		end

		return true
	end
end


--[[ Copy Methods ]] do

	--- @return TdbObjectInstance
	function INSTANCE:Clone()
		return STATIC.New( self )
	end
end


--[[ TranslateObject Specific ]] do

	--- @param languageId integer?
	--- @return string
	function INSTANCE:GetString( languageId )
		if languageId == nil then
			return self:GetString( translateDbClass.GetCurrentLanguage() )
		end

		-- "Default to english on error"
		if languageId > #self.TranslatedStrings then
			languageId = translateDbClass.LANGUAGE_ID.LANGID_ENGLISH
		end

		return self.TranslatedStrings[languageId + 1]
	end

	--- @return string
	function INSTANCE:GetEnglishString()
		return self.EnglishString
	end

	--- @return integer
	function INSTANCE:GetId()
		return self.Id
	end

	--- @return string
	function INSTANCE:GetIdDesc()
		return self.IdDescription
	end

	--- @return integer
	function INSTANCE:GetSoundId()
		return self.SoundId
	end

	--- @return string
	function INSTANCE:GetAnimationName()
		return self.AnimationName
	end

	--- @return integer
	function INSTANCE:GetCategoryId()
		return self.CategoryId
	end

	--- @param languageId integer
	--- @param str string
	function INSTANCE:SetString( languageId, str )
		self.TranslatedStrings[languageId + 1] = str

		-- "Keep a copy of the english string (if necessary)"
		if languageId == translateDbClass.LANGUAGE_ID.LANGID_ENGLISH then
			self.TranslatedStrings[languageId + 1] = self.EnglishString
		end
	end

	--- @param str string
	function INSTANCE:SetEnglishString( str )
		self.EnglishString = str

		self.TranslatedStrings[translateDbClass.LANGUAGE_ID.LANGID_ENGLISH] = str
	end

	--- @param id integer
	function INSTANCE:SetId( id )
		self.Id = id
	end

	--- @param description string
	function INSTANCE:SetIdDesc( description )
		self.IdDescription = description
	end

	--- @param name string
	function INSTANCE:SetAnimationName( name )
		self.AnimationName = name
	end

	--- @param id integer
	function INSTANCE:SetSoundId( id )
		self.SoundId = id
	end

	--- @param id integer
	function INSTANCE:SetCategoryId( id )
		self.CategoryId = id
	end
end


--[[ Informational ]] do

	--- @param languageId integer
	--- @return boolean
	function INSTANCE:ContainsTranslation( languageId )
		local returnValue = false

		-- "Simply check to see if the string contains any data"
		returnValue = self.TranslatedStrings[languageId + 1] ~= nil

		return returnValue
	end
end

--- @param csave ChunkSaveInstance
function INSTANCE:SaveVariables( csave )
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
function INSTANCE:LoadVariables( cload )
	local ids = STATIC.VarIds
	while cload:OpenMicroChunk() do
		chunkIOClass.ReadMicroChunk( cload,	ids.VARID_ID,			fundamentalDataTypeEnum.UInt32,	self, "Id" )
		chunkIOClass.ReadMicroChunk( cload,	ids.VARID_SOUND_ID,		fundamentalDataTypeEnum.UInt32,	self, "SoundId" )
		chunkIOClass.ReadMicroChunk( cload,	ids.VARID_CATEGORY_ID,	fundamentalDataTypeEnum.UInt32,	self, "CategoryId" )
		chunkIOClass.ReadMicroChunkWWString( cload, ids.VARID_ID_DESC,			self, "IdDescription" )
		chunkIOClass.ReadMicroChunkWWString( cload, ids.VARID_ENGLISH_STRING,	self, "EnglishString" )
		chunkIOClass.ReadMicroChunkWWString( cload, ids.VARID_ANIMATION_NAME,	self, "AnimationName" )

		chunkIOClass.ReadMicroChunkWWString( cload, ids.VARID_STRING, self.TranslatedStrings, #self.TranslatedStrings + 1 )

		cload:CloseMicroChunk()
	end
end
