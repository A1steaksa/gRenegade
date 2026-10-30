-- Based on TeamPurchaseSettingsDefClass within Code/Combat/teampurchasesettings.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class TeamPurchaseSettingsDefinitionClass : DefinitionClass
--- @field Instance TeamPurchaseSettingsDefinitionInstance The metatable used by TeamPurchaseSettingsDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TeamPurchaseSettingsDefinitionClass"

--- @class TeamPurchaseSettingsDefinitionInstance : DefinitionInstance
--- @field Static TeamPurchaseSettingsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_TeamPurchaseSettingsDefinition : Renegade_Definition" )
INSTANCE.Class = "TeamPurchaseSettingsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsTeamPurchaseSettingsDefinition = true

--#region Exported Enums

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

	--- @enum TeamPurchaseSettingsTeam
	STATIC.TEAM_PURCHASE_SETTINGS_TEAM = {
		TEAM_GDI   = enumBuilder:Set( 0 ),
		TEAM_NOD   = enumBuilder:Next(),
		TEAM_COUNT = enumBuilder:Next()
	}
	local teamPurchaseSettingsTeamEnum = STATIC.TEAM_PURCHASE_SETTINGS_TEAM
--#endregion

--#region Imports

	--- @type TranslateDbClass
	local translateDbClass = CNC.Import( "code/wwtranslatedb/translate-db.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SimpleDefinitionFactoryClass
	local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Chunk IDs and Var IDs ]] do

	STATIC.ChunkIds = {
		CHUNKID_PARENT	  = enumBuilder:Set( 0x10231215 ),
		CHUNKID_VARIABLES = enumBuilder:Next()
	}

	STATIC.VarIds = {
		VARID_TEAM					= enumBuilder:Set( 1 ),
		VARID_DEFINITION			= enumBuilder:Next(),
		VARID_TEXTURE_NAME			= enumBuilder:Next(),
		VARID_NAME					= enumBuilder:Next(),
		VARID_INDEX					= enumBuilder:Next(),
		VARID_BEACON_DEFINITION		= enumBuilder:Next(),
		VARID_BEACON_NAME			= enumBuilder:Next(),
		VARID_BEACON_TEXTURE_NAME	= enumBuilder:Next(),
		VARID_BEACON_COST			= enumBuilder:Next(),
		VARID_SUPPLY_NAME			= enumBuilder:Next(),
		VARID_SUPPLY_TEXTURE_NAME	= enumBuilder:Next(),
	}

end

--[[ Static Functions and Variables ]] do

    --- @class TeamPurchaseSettingsDefinitionClass
	--- @field DefinitionArray TeamPurchaseSettingsDefinitionInstance[]

	STATIC.MAX_ENTRIES = 4

    --- Creates a new TeamPurchaseSettingsDefinitionInstance
    --- @return TeamPurchaseSettingsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_TeamPurchaseSettingsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) TeamPurchaseSettingsDefinitionInstance, `false` otherwise
    function STATIC.IsTeamPurchaseSettingsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsTeamPurchaseSettingsDefinition and true or false
    end

    typecheck.RegisterType( "TeamPurchaseSettingsDefinitionInstance", STATIC.IsTeamPurchaseSettingsDefinition )

	function STATIC.StaticConstructor()
		STATIC.TeamPurchaseDefinitionPersistFactory		= simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CHUNKID_GLOBAL_SETTINGS_DEF_TEAM_PURCHASE )
		STATIC.TeamPurchaseDefinitionDefinitionFactory	= simpleDefinitionFactoryClass.New( STATIC, combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_TEAM_PURCHASE, "Team Purchase Settings" )

		STATIC.DefinitionArray = {}
	end

	--- @param team TeamPurchaseSettingsDefinitionInstance?
	function STATIC.GetDefinition( team )
		return STATIC.DefinitionArray[team]
	end
end


--- @class TeamPurchaseSettingsDefinitionInstance
--- @field Team TeamPurchaseSettingsTeam
--- @field DefinitionList integer[]
--- @field NameList integer[]
--- @field TextureList string[]
--- @field BeaconCost integer
--- @field BeaconDefinitionId integer
--- @field BeaconNameId integer
--- @field BeaconTextureName string
--- @field SupplyNameId integer
--- @field SupplyTextureName string

function INSTANCE:Renegade_TeamPurchaseSettingsDefinition()
	definitionClass.Instance.Renegade_Definition( self )

	self.Team = teamPurchaseSettingsTeamEnum.TEAM_GDI
	self.BeaconNameId = 0
	self.BeaconDefinitionId = 0
	self.BeaconCost = 0
	self.SupplyNameId = 0

	-- "Initialize the lists"
	self.DefinitionList = {}
	self.NameList = {}
end

function INSTANCE:_Renegade_TeamPurchaseSettingsDefinition()
	definitionClass.Instance._Renegade_Definition( self )

	-- "Remove this entry from the static array"
	if self.Team < teamPurchaseSettingsTeamEnum.TEAM_COUNT then
		STATIC.DefinitionArray[self.Team] = nil
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
		elseif id == STATIC.ChunkIds.CHUNKID_VARIABLESHUNKID_VARIABLES then
			self:LoadVariables( cload )
		else
			section.Print( "Unhandled chunk ID ", id )
		end

		cload:CloseChunk()
	end

	return true
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
	return STATIC.TeamPurchaseDefinitionPersistFactory
end

--- @return TeamPurchaseSettingsTeam
function INSTANCE:GetTeam()
	return self.Team
end

--- @return string?
function INSTANCE:GetEnlistedName( index )
	local returnValue

	-- "Return the translated string..."
	if index >= 0 and index < STATIC.MAX_ENTRIES and self.NameList[index] ~= nil then
		returnValue = translateDbClass.GetString( self.NameList[index] )
	end

	return returnValue
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

--- @return string?
function INSTANCE:GetBeaconName()
	return translateDbClass.GetString( self.BeaconNameId )
end

--- @return integer
function INSTANCE:GetBeaconCost()
	return self.BeaconCost
end

--- @return integer
function INSTANCE:GetBeaconDefinition()
	return self.BeaconDefinitionId
end

--- @return string
function INSTANCE:GetBeaconTexture()
	return self.BeaconTextureName
end

--- @return string?
function INSTANCE:GetSupplyName()
	return translateDbClass.GetString( self.SupplyNameId )
end

--- @return string
function INSTANCE:GetSupplyTexture()
	return self.SupplyTextureName
end

--- @param cload ChunkLoadInstance
function INSTANCE:LoadVariables( cload )
	--- @type { EntryIndex: integer }
	local indices = { EntryIndex = 0 }

	while cload:OpenMicroChunk() do
		-- "Read the type and team information"
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_TEAM, fundamentalDataTypeEnum.Int, self, "Team" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_BEACON_DEFINITION, fundamentalDataTypeEnum.Int, self, "BeaconDefinitionId" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_BEACON_NAME, fundamentalDataTypeEnum.Int, self, "BeaconNameId" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_BEACON_COST, fundamentalDataTypeEnum.Int, self, "BeaconCost" )
		chunkIOClass.ReadMicroChunkWWString( cload, STATIC.VarIds.VARID_TEXTURE_NAME, self, "BeaconTextureName" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_SUPPLY_NAME, fundamentalDataTypeEnum.Int, self, "SupplyNameId" )
		chunkIOClass.ReadMicroChunkWWString( cload, STATIC.VarIds.VARID_SUPPLY_TEXTURE_NAME, self, "SupplyTextureName" )

		-- "Read the current list entry"
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_INDEX, fundamentalDataTypeEnum.Int, indices, "EntryIndex" )

		local id = cload:CurMicroChunkId()

		if id == STATIC.VarIds.VARID_DEFINITION then
			if indices.EntryIndex >= 0 and indices.EntryIndex < STATIC.MAX_ENTRIES then
				chunkIOClass.LoadMicroChunk( cload, fundamentalDataTypeEnum.Int, self.DefinitionList, indices.EntryIndex )
			end
		elseif id == STATIC.VarIds.VARID_NAME then
			if indices.EntryIndex >= 0 and indices.EntryIndex < STATIC.MAX_ENTRIES then
				chunkIOClass.LoadMicroChunk( cload, fundamentalDataTypeEnum.Int, self.NameList, indices.EntryIndex )
			end
		elseif STATIC.VarIds.VARID_TEXTURE_NAME then
			if indices.EntryIndex >= 0 and indices.EntryIndex < STATIC.MAX_ENTRIES then
				chunkIOClass.LoadMicroChunkWWString( cload, self.TextureList, indices.EntryIndex )
			end
		else
			section.Warn( "Unhandled micro chunk ", id )
		end

		cload:CloseMicroChunk()
	end

	-- "Add this definition to the static array"
	if self.Team < teamPurchaseSettingsTeamEnum.TEAM_COUNT then
		STATIC.DefinitionArray[self.Team] = self
	end
end
