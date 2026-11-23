-- Based on GlobalSettingsDef within Code/Combat/globalsettings.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class GlobalSettingsDefinitionClass : DefinitionClass
--- @field Instance GlobalSettingsDefinitionInstance The metatable used by GlobalSettingsDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "GlobalSettingsDefinitionClass"

--- @class GlobalSettingsDefinitionInstance : DefinitionInstance
--- @field Static GlobalSettingsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_GlobalSettingsDefinition : Renegade_Definition" )
INSTANCE.Class = "GlobalSettingsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsGlobalSettingsDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SimpleDefinitionFactoryClass
	local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Chunk IDs ]] do

	local enumBuilder = enumBuilderClass.New()

	STATIC.ChunkIds = {
		CHUNKID_DEF_PARENT									= enumBuilder:Set( 803001812 ),
		CHUNKID_DEF_VARIABLES								= enumBuilder:Next(),

		MICROCHUNKID_DEF_XXX								= enumBuilder:Set( 1 ),
		MICROCHUNKID_DEF_DEATH_SOUND						= enumBuilder:Next(),
		MICROCHUNKID_DEF_EVA_MO_SOUND						= enumBuilder:Next(),
		MICROCHUNKID_DEF_MAX_CONV_DIST						= enumBuilder:Next(),
		MICROCHUNKID_DEF_MAX_COMBAT_CONV_DIST				= enumBuilder:Next(),
		MICROCHUNKID_DEF_SOLDIER_WALK_SPEED					= enumBuilder:Next(),
		MICROCHUNKID_DEF_SOLDIER_CROUCH_SPEED				= enumBuilder:Next(),
		MICROCHUNKID_DEF_FALLING_DAMAGE_MIN_DISTANCE		= enumBuilder:Next(),
		MICROCHUNKID_DEF_FALLING_DAMAGE_MAX_DISTANCE		= enumBuilder:Next(),
		MICROCHUNKID_DEF_FALLING_DAMAGE_WARHEAD				= enumBuilder:Next(),
		
		MICROCHUNKID_DEF_PURCHASE_GDI_CHARS_TEXTURE			= enumBuilder:Next(),
		MICROCHUNKID_DEF_PURCHASE_GDI_VEHICLES_TEXTURE		= enumBuilder:Next(),
		MICROCHUNKID_DEF_PURCHASE_GDI_EQUIP_TEXTURE			= enumBuilder:Next(),
		XXXMICROCHUNKID_DEF_PURCHASE_ADV_EQUIP_TEXTURE		= enumBuilder:Next(),

		MICROCHUNKID_DEF_PURCHASE_NOD_CHARS_TEXTURE			= enumBuilder:Next(),
		MICROCHUNKID_DEF_PURCHASE_NOD_VEHICLES_TEXTURE		= enumBuilder:Next(),
		MICROCHUNKID_DEF_PURCHASE_NOD_EQUIP_TEXTURE			= enumBuilder:Next(),

		MICROCHUNKID_DEF_PURCHASE_GDI_MUT_CHARS_TEXTURE		= enumBuilder:Next(),
		MICROCHUNKID_DEF_PURCHASE_GDI_MUT_VEHICLES_TEXTURE	= enumBuilder:Next(),
		MICROCHUNKID_DEF_PURCHASE_GDI_MUT_EQUIP_TEXTURE		= enumBuilder:Next(),

		MICROCHUNKID_DEF_PURCHASE_NOD_MUT_CHARS_TEXTURE		= enumBuilder:Next(),
		MICROCHUNKID_DEF_PURCHASE_NOD_MUT_VEHICLES_TEXTURE	= enumBuilder:Next(),
		MICROCHUNKID_DEF_PURCHASE_NOD_MUT_EQUIP_TEXTURE		= enumBuilder:Next(),

		MICROCHUNKID_DEF_ENCY_EVENT_STRING_ID 				= enumBuilder:Next(),
		MICROCHUNKID_DEF_HELP_TXT_SOUND		  				= enumBuilder:Next(),

		MICROCHUNKID_DEF_STEALTH_DISTANCE_HUMAN				= enumBuilder:Next(),
		MICROCHUNKID_DEF_STEALTH_DISTANCE_VEHICLE			= enumBuilder:Next(),
		MICROCHUNKID_DEF_MP_STEALTH_DISTANCE_HUMAN			= enumBuilder:Next(),
		MICROCHUNKID_DEF_MP_STEALTH_DISTANCE_VEHICLE		= enumBuilder:Next(),
	}
end

--[[ Static Functions and Variables ]] do

    --- @class GlobalSettingsDefinitionClass
	--- @field GlobalSettings GlobalSettingsDefinitionInstance

    --- Creates a new GlobalSettingsDefinitionInstance
    --- @return GlobalSettingsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_GlobalSettingsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) GlobalSettingsDefinitionInstance, `false` otherwise
    function STATIC.IsGlobalSettingsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsGlobalSettingsDefinition and true or false
    end

    typecheck.RegisterType( "GlobalSettingsDefinitionInstance", STATIC.IsGlobalSettingsDefinition )

	function STATIC.StaticConstructor()
		STATIC.GlobalSettingsDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_GENERAL )
		STATIC.GlobalSettingsDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_GENERAL, "General" )

		STATIC.GlobalSettings = STATIC.New()
	end

	--- @return GlobalSettingsDefinitionInstance
	function STATIC.GetGlobalSettings()
		return STATIC.GlobalSettings
	end
end


--- @class GlobalSettingsDefinitionInstance
--- @field DeathSoundId integer
--- @field EvaObjectivesSoundId integer
--- @field HudHelpTextSoundId integer
--- @field MaxConversationDistance number
--- @field MaxCombatConversationDistance number
--- @field SoldierWalkSpeed number
--- @field SoldierCrouchSpeed number
--- @field FallingDamageMinDistance number
--- @field FallingDamageMaxDistance number
--- @field PurchaseGdiCharactersTexture string
--- @field PurchaseGdiVehiclesTexture string
--- @field PurchaseGdiEquipmentTexture string
--- @field PurchaseNodCharactersTexture string
--- @field PurchaseNodVehiclesTexture string
--- @field PurchaseNodEquipmentTexture string
--- @field PurchaseGdiMutantCharactersTexture string
--- @field PurchaseGdiMutantVehiclesTexture string
--- @field PurchaseGdiMutantEquipmentTexture string
--- @field PurchaseNodMutantCharactersTexture string
--- @field PurchaseNodMutantVehiclesTexture string
--- @field PurchaseNodMutantEquipmentTexture string
--- @field EncyclopediaEventStringId integer
--- @field FallingDamageWarhead integer
--- @field StealthDistanceHuman number
--- @field StealthDistanceVehicle number
--- @field MpStealthDistanceHuman number
--- @field MpStealthDistanceVehicle number

function INSTANCE:Renegade_GlobalSettingsDefinition()
	self.DeathSoundId = 0
	self.EvaObjectivesSoundId = 0
	self.HudHelpTextSoundId = 0
	self.MaxConversationDistance = 10.0
	self.MaxCombatConversationDistance = 10.0
	self.SoldierWalkSpeed = 0.25
	self.SoldierCrouchSpeed = 0.25
	self.EncyclopediaEventStringId = 0
	self.FallingDamageMinDistance = 5
	self.FallingDamageMaxDistance = 20
	self.FallingDamageWarhead = 15 -- "Default to Earth"
	self.StealthDistanceHuman = 15.0
	self.StealthDistanceVehicle = 25.0
	self.MpStealthDistanceHuman = 15.0
	self.MpStealthDistanceVehicle = 25.0

	STATIC.GlobalSettings = self
end

function INSTANCE:_Renegade_GlobalSettingsDefinition()
	STATIC.GlobalSettings = nil
end

--- @return integer
function INSTANCE:GetClassId()
	return combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_GENERAL
end

function INSTANCE:Create()
	assert( false )
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
		local id = cload:CurChunkId()

		if id == ids.CHUNKID_DEF_PARENT then
			definitionClass.Instance.Load( self, cload )

		elseif id == ids.CHUNKID_DEF_VARIABLES then
			while cload:OpenMicroChunk() do
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_DEATH_SOUND, 					fundamentalDataTypeEnum.Int, 	self, "DeathSoundId"                  )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_DEATH_SOUND,					fundamentalDataTypeEnum.Int, 	self, "DeathSoundId"                  )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_EVA_MO_SOUND,					fundamentalDataTypeEnum.Int, 	self, "EvaObjectivesSoundId"          )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_HELP_TXT_SOUND,				fundamentalDataTypeEnum.Int, 	self, "HudHelpTextSoundId"            )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_MAX_CONV_DIST,					fundamentalDataTypeEnum.Float, 	self, "MaxConversationDistance"       )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_MAX_COMBAT_CONV_DIST,			fundamentalDataTypeEnum.Float, 	self, "MaxCombatConversationDistance" )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SOLDIER_WALK_SPEED,			fundamentalDataTypeEnum.Float, 	self, "SoldierWalkSpeed" 	          )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SOLDIER_CROUCH_SPEED,			fundamentalDataTypeEnum.Float, 	self, "SoldierCrouchSpeed"            )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_FALLING_DAMAGE_MIN_DISTANCE,	fundamentalDataTypeEnum.Float, 	self, "FallingDamageMinDistance"      )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_FALLING_DAMAGE_MAX_DISTANCE,	fundamentalDataTypeEnum.Float, 	self, "FallingDamageMaxDistance"      )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_FALLING_DAMAGE_WARHEAD,		fundamentalDataTypeEnum.Int, 	self, "FallingDamageWarhead" 	      )
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ENCY_EVENT_STRING_ID,			fundamentalDataTypeEnum.Int, 	self, "EncyclopediaEventStringId"     )

				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_GDI_CHARS_TEXTURE, 	self, "PurchaseGdiCharactersTexture" )
				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_GDI_VEHICLES_TEXTURE, self, "PurchaseGdiVehiclesTexture" 	 )
				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_GDI_EQUIP_TEXTURE, 	self, "PurchaseGdiEquipmentTexture"  )

				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_NOD_CHARS_TEXTURE, 	self, "PurchaseNodCharactersTexture" )
				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_NOD_VEHICLES_TEXTURE, self, "PurchaseNodVehiclesTexture" 	 )
				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_NOD_EQUIP_TEXTURE, 	self, "PurchaseNodEquipmentTexture"  )

				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_GDI_MUT_CHARS_TEXTURE, 	self, "PurchaseGdiMutantCharactersTexture" 	)
				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_GDI_MUT_VEHICLES_TEXTURE, self, "PurchaseGdiMutantVehiclesTexture" 	)
				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_GDI_MUT_EQUIP_TEXTURE, 	self, "PurchaseGdiMutantEquipmentTexture" 	)

				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_NOD_MUT_CHARS_TEXTURE, 	self, "PurchaseNodMutantCharactersTexture" 	)
				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_NOD_MUT_VEHICLES_TEXTURE, self, "PurchaseNodMutantVehiclesTexture" 	)
				chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_PURCHASE_NOD_MUT_EQUIP_TEXTURE, 	self, "PurchaseNodMutantEquipmentTexture" 	)

				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_STEALTH_DISTANCE_HUMAN, 		fundamentalDataTypeEnum.Float, self, "StealthDistanceHuman" 	)
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_STEALTH_DISTANCE_VEHICLE, 		fundamentalDataTypeEnum.Float, self, "StealthDistanceVehicle" 	)
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_MP_STEALTH_DISTANCE_HUMAN, 	fundamentalDataTypeEnum.Float, self, "MpStealthDistanceHuman" 	)
				chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_MP_STEALTH_DISTANCE_VEHICLE, 	fundamentalDataTypeEnum.Float, self, "MpStealthDistanceVehicle" )

				cload:CloseMicroChunk()
			end
		else
			section.Warn( "Unhandled Chunk ID: ", id )
		end

		cload:CloseChunk()
	end

	return true
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
	return STATIC.GlobalSettingsDefinitionPersistFactory
end

--- @return integer
function INSTANCE:GetDeathSoundId()
	return self.DeathSoundId
end

--- @return integer
function INSTANCE:GetEvaObjectivesSoundId()
	return self.EvaObjectivesSoundId
end

--- @return integer
function INSTANCE:GetHudHelpTextSoundId()
	return self.HudHelpTextSoundId
end

--- @return number
function INSTANCE:GetConversationDistance()
	return self.MaxConversationDistance
end

--- @return number
function INSTANCE:GetCombatConversationDistance()
	return self.MaxCombatConversationDistance
end

--- @return number
function INSTANCE:GetSoldierWalkSpeed()
	return self.SoldierWalkSpeed
end

--- @return number
function INSTANCE:GetSoldierCrouchSpeed()
	return self.SoldierCrouchSpeed
end

--- @return number
function INSTANCE:GetFallingDamageMinDistance()
	return self.FallingDamageMinDistance
end

--- @return number
function INSTANCE:GetFallingDamageMaxDistance()
	return self.FallingDamageMaxDistance
end

--- @return integer
function INSTANCE:GetFallingDamageWarhead()
	return self.FallingDamageWarhead
end

--- @return string
function INSTANCE:GetPurchaseGdiCharactersTexture()
	return self.PurchaseGdiCharactersTexture
end

--- @return string
function INSTANCE:GetPurchaseGdiVehiclesTexture()
	return self.PurchaseGdiVehiclesTexture
end

--- @return string
function INSTANCE:GetPurchaseGdiEquipmentTexture()
	return self.PurchaseGdiEquipmentTexture
end

--- @return string
function INSTANCE:GetPurchaseNodCharactersTexture()
	return self.PurchaseNodCharactersTexture
end

--- @return string
function INSTANCE:GetPurchaseNodVehiclesTexture()
	return self.PurchaseNodVehiclesTexture
end

--- @return string
function INSTANCE:GetPurchaseNodEquipmentTexture()
	return self.PurchaseNodEquipmentTexture
end

--- @return string
function INSTANCE:GetPurchaseNodMutantCharactersTexture()
	return self.PurchaseNodMutantCharactersTexture
end

--- @return string
function INSTANCE:GetPurchaseNodMutantVehiclesTexture()
	return self.PurchaseNodMutantVehiclesTexture
end

--- @return string
function INSTANCE:GetPurchaseNodMutantEquipmentTexture()
	return self.PurchaseNodMutantEquipmentTexture
end

--- @return string
function INSTANCE:GetPurchaseGdiMutantCharactersTexture()
	return self.PurchaseGdiMutantCharactersTexture
end

--- @return string
function INSTANCE:GetPurchaseGdiMutantVehiclesTexture()
	return self.PurchaseGdiMutantVehiclesTexture
end

--- @return string
function INSTANCE:GetPurchaseGdiMutantEquipmentTexture()
	return self.PurchaseGdiMutantEquipmentTexture
end

--- @return integer
function INSTANCE:GetEncyclopediaEventStringId()
	return self.EncyclopediaEventStringId
end

--- @return number
function INSTANCE:GetStealthDistanceHuman()
	return self.StealthDistanceHuman
end

--- @return number
function INSTANCE:GetStealthDistanceVehicle()
	return self.StealthDistanceVehicle
end

--- @return number
function INSTANCE:GetMpStealthDistanceHuman()
	return self.MpStealthDistanceHuman
end

--- @return number
function INSTANCE:GetMpStealthDistanceVehicle()
	return self.MpStealthDistanceVehicle
end
