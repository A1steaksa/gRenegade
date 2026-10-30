-- Based on PurchaseSettingsDefClass within Code/Combat/purchasesettings.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class PurchaseSettingsDefinitionClass : DefinitionClass
--- @field Instance PurchaseSettingsDefinitionInstance The metatable used by PurchaseSettingsDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PurchaseSettingsDefinitionClass"

--- @class PurchaseSettingsDefinitionInstance : DefinitionInstance
--- @field Static PurchaseSettingsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PurchaseSettingsDefinition : Renegade_Definition" )
INSTANCE.Class = "PurchaseSettingsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPurchaseSettingsDefinition = true

--#region Exported Enums

    --- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum PurchaseSettingsType
    STATIC.PURCHASE_SETTINGS_TYPE = {
        TYPE_CLASSES		 = enumBuilder:Set( 0 ),
		TYPE_VEHICLES		 = enumBuilder:Next(),
        TYPE_EQUIPMENT		 = enumBuilder:Next(),
        TYPE_SECRET_CLASSES	 = enumBuilder:Next(),
        TYPE_SECRET_VEHICLES = enumBuilder:Next(),
        TYPE_COUNT			 = enumBuilder:Next(),
    }
    local purchaseSettingsTypeEnum = STATIC.PURCHASE_SETTINGS_TYPE

	--- @enum PurchaseSettingsTeam
    STATIC.PURCHASE_SETTINGS_TEAM = {
        TEAM_GDI		= enumBuilder:Set( 0 ),
		TEAM_NOD		= enumBuilder:Next(),
        TEAM_MUTANT_GDI	= enumBuilder:Next(),
        TEAM_MUTANT_NOD	= enumBuilder:Next(),
        TEAM_COUNT		= enumBuilder:Next(),
    }
    local purchaseSettingsTeamEnum = STATIC.PURCHASE_SETTINGS_TEAM
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SimpleDefinitionFactoryClass
	local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type ClassUtils
	local classUtils = CNC.Import( "sh_class-utils.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type TranslateDbClass
	local translateDbClass = CNC.Import( "code/wwtranslatedb/translate-db.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Chunk IDs and Var IDs ]] do

	STATIC.ChunkIds = {
		CHUNKID_PARENT		= enumBuilder:Set( 0x08071203 ),
		CHUNKID_VARIABLES	= enumBuilder:Next()
	}

	STATIC.VarIds = {
		VARID_TEAM				= enumBuilder:Set( 1 ),
		VARID_TYPE				= enumBuilder:Next(),
		XXX_VARID_ROW			= enumBuilder:Next(),
		XXX_VARID_COL			= enumBuilder:Next(),
		VARID_COST				= enumBuilder:Next(),
		VARID_DEFINITION		= enumBuilder:Next(),
		VARID_TEXTURE_NAME		= enumBuilder:Next(),
		VARID_NAME				= enumBuilder:Next(),
		VARID_INDEX				= enumBuilder:Next(),
		VARID_ALT_INDEX			= enumBuilder:Next(),
		VARID_ALT_TEXTURE_NAME	= enumBuilder:Next(),
		VARID_ALT_DEFINITION	= enumBuilder:Next(),
	}

end

--[[ Static Functions and Variables ]] do

    --- @class PurchaseSettingsDefinitionClass
	--- @field DefinitionArray PurchaseSettingsDefinitionInstance[][]

	STATIC.ROWS = 4
	STATIC.COLS = 5
	STATIC.MAX_ALTERNATES = 3
	STATIC.MAX_ENTRIES = 10

    --- Creates a new PurchaseSettingsDefinitionInstance
    --- @return PurchaseSettingsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PurchaseSettingsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PurchaseSettingsDefinitionInstance, `false` otherwise
    function STATIC.IsPurchaseSettingsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPurchaseSettingsDefinition and true or false
    end

    typecheck.RegisterType( "PurchaseSettingsDefinitionInstance", STATIC.IsPurchaseSettingsDefinition )

	function STATIC.StaticConstructor()
		STATIC.PurchaseDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CHUNKID_GLOBAL_SETTINGS_DEF_PURCHASE )
		STATIC.PurchaseDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_PURCHASE, "Purchase Settings" )

		STATIC.DefinitionArray = {}
		for typeIndex = 1, purchaseSettingsTypeEnum.TYPE_COUNT do
			STATIC.DefinitionArray[typeIndex] = {}
		end
	end

	--- @param type PurchaseSettingsType
	--- @param team PurchaseSettingsTeam
	--- @return PurchaseSettingsDefinitionInstance?
	function STATIC.FindDefinition( type, team )
		local returnValue = STATIC.DefinitionArray[type][team]

		if returnValue == nil then
			-- "If the type is 'secret classes' try the base classes"
			if type == purchaseSettingsTypeEnum.TYPE_SECRET_CLASSES then
				type = purchaseSettingsTypeEnum.TYPE_CLASSES
			end

			if type == purchaseSettingsTypeEnum.TYPE_SECRET_VEHICLES then
				type = purchaseSettingsTypeEnum.TYPE_VEHICLES
			end

			-- "Return the 'base' definition if there was no definition for one of the mutant types"
			if team == purchaseSettingsTeamEnum.TEAM_MUTANT_GDI then
				returnValue = STATIC.DefinitionArray[type][purchaseSettingsTeamEnum.TEAM_GDI]
			elseif team == purchaseSettingsTeamEnum.TEAM_MUTANT_NOD then
				returnValue = STATIC.DefinitionArray[type][purchaseSettingsTeamEnum.TEAM_NOD]
			end
		end

		return returnValue
	end
end


--- @class PurchaseSettingsDefinitionInstance
--- @field Team PurchaseSettingsTeam
--- @field Type PurchaseSettingsType
--- @field CostList integer[]
--- @field DefinitionList integer[]
--- @field NameList integer[]
--- @field TextureList string[]
--- @field AlternateDefinitionList integer[][]
--- @field AlternateTextureList string[][]

function INSTANCE:Renegade_PurchaseSettingsDefinition()
	self.Team = purchaseSettingsTeamEnum.TEAM_GDI
	self.Type = purchaseSettingsTypeEnum.TYPE_CLASSES

	-- "Initialize the cost and definition lists"
	self.CostList				 = {}
	self.DefinitionList 		 = {}
	self.NameList 				 = {}
	self.AlternateDefinitionList = {}

	-- Omitted configuring editable system
end

function INSTANCE:_Renegade_PurchaseSettingsDefinition()
	-- "Remove this entry from the static array"
	if self.Type < purchaseSettingsTypeEnum.TYPE_COUNT and self.Team < purchaseSettingsTeamEnum.TEAM_COUNT then
		STATIC.DefinitionArray[self.Type][self.Team] = nil
	end
end

--- @return integer
function INSTANCE:GetClassId()
	return combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_TEAM_PURCHASE
end

--- @return PersistInstance
function INSTANCE:Create()
	assert( false )
	return nil
end

--- @param csave ChunkSaveInstance
--- @return boolean
function INSTANCE:Save( csave )
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
	while cload:OpenChunk() do
		local id = cload:CurChunkId()
		if id == STATIC.ChunkIds.CHUNKID_PARENT then
			definitionClass.Instance.Load( self, cload )
		elseif id == STATIC.ChunkIds.CHUNKID_VARIABLES then
			self:LoadVariables( cload )
		else
			section.Warn( "Unhandled chunk ID ", id )
		end

		cload:CloseChunk()
	end

	return true
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
	return STATIC.PurchaseDefinitionPersistFactory
end

--- @return PurchaseSettingsType
function INSTANCE:GetType()
	return self.Type
end

--- @return PurchaseSettingsTeam
function INSTANCE:GetTeam()
	return self.Team
end

--- @param index integer
--- @return string?
function INSTANCE:GetName( index )
	local returnValue

	-- "Return the translated string..."
	if index >= 0 and index < STATIC.MAX_ENTRIES and self.NameList[index] ~= 0 then
		returnValue = translateDbClass.GetString( self.NameList[index] )
	end

	return returnValue
end

--- @param index integer
--- @return integer
function INSTANCE:GetCost( index )
	return self.CostList[index]
end

--- @param index integer
--- @return integer
function INSTANCE:GetDefinition( index )
	return self.DefinitionList[index]
end

--- @param index integer
--- @return string
function INSTANCE:GetTexture( index )
	return self.TextureList[index]
end

--- @param index integer
--- @return string
function INSTANCE:GetEnlistedName( index )
	typecheck.NotImplementedError()
end

--- @param index integer
--- @return integer
function INSTANCE:GetEnlistedDefinition( index )
	return self.DefinitionList[index]
end

--- @param index integer
--- @return string
function INSTANCE:GetEnlistedTexture( index )
	return self.TextureList[index]
end

--- @param index integer
--- @param altIndex integer
function INSTANCE:GetAltDefinition( index, altIndex )
	return self.AlternateDefinitionList[index][altIndex]
end

--- @param index integer
--- @param altIndex integer
function INSTANCE:GetAltTexture( index, altIndex )
	return self.AlternateTextureList[index][altIndex]
end

--- @param cload ChunkLoadInstance
function INSTANCE:LoadVariables( cload )
	--- @type {EntryIndex: integer, AltIndex: integer}
	local indices = { EntryIndex = 0, AltIndex = 0 }

	local varIds = STATIC.VarIds

	while cload:OpenMicroChunk() do
		-- "Read the type and team information"
		chunkIOClass.ReadMicroChunk( cload, varIds.VARID_TEAM, fundamentalDataTypeEnum.Int, self, "Team" )
		chunkIOClass.ReadMicroChunk( cload, varIds.VARID_TYPE, fundamentalDataTypeEnum.Int, self, "Type" )

		-- "Read the current list entry"
		chunkIOClass.ReadMicroChunk( cload, varIds.VARID_INDEX, 	fundamentalDataTypeEnum.Int, indices, "EntryIndex" )
		chunkIOClass.ReadMicroChunk( cload, varIds.VARID_ALT_INDEX, fundamentalDataTypeEnum.Int, indices, "AltIndex" )

		local id = cload:CurMicroChunkId()

		if id == varIds.VARID_COST then
			if indices.EntryIndex >= 0 and indices.EntryIndex < STATIC.MAX_ENTRIES then
				chunkIOClass.LoadMicroChunk( cload, fundamentalDataTypeEnum.Int, self.CostList, indices.EntryIndex )
			end
		elseif id == varIds.VARID_DEFINITION then
			if indices.EntryIndex >= 0 and indices.EntryIndex < STATIC.MAX_ENTRIES then
				chunkIOClass.LoadMicroChunk( cload, fundamentalDataTypeEnum.Int, self.DefinitionList, indices.EntryIndex )
			end
		elseif id == varIds.VARID_NAME then
			if indices.EntryIndex >= 0 and indices.EntryIndex < STATIC.MAX_ENTRIES then
				chunkIOClass.LoadMicroChunk( cload, fundamentalDataTypeEnum.Int, self.TextureList, indices.EntryIndex )
			end
		elseif id == varIds.VARID_TEXTURE_NAME then
			if indices.EntryIndex >= 0 and indices.EntryIndex < STATIC.MAX_ENTRIES then
				chunkIOClass.LoadMicroChunkWWString( cload, self.TextureList, indices.EntryIndex )
			end
		elseif id == varIds.VARID_ALT_DEFINITION then
			if
				indices.EntryIndex >= 0 and indices.EntryIndex < STATIC.MAX_ENTRIES and
				indices.AltIndex >= 0 and indices.AltIndex < STATIC.MAX_ALTERNATES
			then
				chunkIOClass.LoadMicroChunk( cload, fundamentalDataTypeEnum.Int, self.AlternateDefinitionList[indices.EntryIndex], indices.AltIndex )
			end
		elseif id == varIds.VARID_ALT_TEXTURE_NAME then
			if
				indices.EntryIndex >= 0 and indices.EntryIndex < STATIC.MAX_ENTRIES and
				indices.AltIndex >= 0 and indices.AltIndex < STATIC.MAX_ALTERNATES
			then
				chunkIOClass.LoadMicroChunkWWString( cload, self.AlternateDefinitionList[indices.EntryIndex], indices.AltIndex )
			end
		else
			section.Warn( "Unhandled micro chunk ID ", id )
		end

		cload:CloseMicroChunk()
	end

	-- "Add this definition to the static array"
	if self.Type < purchaseSettingsTypeEnum.TYPE_COUNT and self.Team < purchaseSettingsTeamEnum.TEAM_COUNT then
		STATIC.DefinitionArray[self.Type][self.Team] = self
	end
end
