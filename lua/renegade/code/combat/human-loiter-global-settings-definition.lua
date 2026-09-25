-- Based on HumanLoiterGlobalSettingsDef within Code/Combat/globalsettings.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class HumanLoiterGlobalSettingsDefinitionClass : DefinitionClass
--- @field Instance HumanLoiterGlobalSettingsDefinitionInstance The metatable used by HumanLoiterGlobalSettingsDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HumanLoiterGlobalSettingsDefinitionClass"

--- @class HumanLoiterGlobalSettingsDefinitionInstance : DefinitionInstance
--- @field Static HumanLoiterGlobalSettingsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HumanLoiterGlobalSettingsDefinition : Renegade_Definition" )
INSTANCE.Class = "HumanLoiterGlobalSettingsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHumanLoiterGlobalSettingsDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SimpleDefinitionFactoryClass
	local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )
--#endregion

--#region Imported Enums
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_HL_DEF_PARENT    = enumBuilder:Set( 803001812 ),
        CHUNKID_HL_DEF_VARIABLES = enumBuilder:Next(),

        MICROCHUNKID_HL_DEF_ACTIVATION_DELAY       = enumBuilder:Set( 1 ),
        MICROCHUNKID_HL_DEF_LOITER_FREQUENCY       = enumBuilder:Next(),
        MICROCHUNKID_HL_DEF_LOITER_ANIM_LIST_ENTRY = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class HumanLoiterGlobalSettingsDefinitionClass
	--- @field DefaultLoiters HumanLoiterGlobalSettingsDefinitionInstance
	--- @field WeaponLoiters HumanLoiterGlobalSettingsDefinitionInstance
	--- @field WeaponlessLoiters HumanLoiterGlobalSettingsDefinitionInstance

    --- Creates a new HumanLoiterGlobalSettingsDefinitionInstance
    --- @return HumanLoiterGlobalSettingsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HumanLoiterGlobalSettingsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HumanLoiterGlobalSettingsDefinitionInstance, `false` otherwise
    function STATIC.IsHumanLoiterGlobalSettingsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHumanLoiterGlobalSettingsDefinition and true or false
    end

    typecheck.RegisterType( "HumanLoiterGlobalSettingsDefinitionInstance", STATIC.IsHumanLoiterGlobalSettingsDefinition )

	function STATIC.StaticConstructor()
        STATIC.HumanLoiterGlobalSettingsDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CHUNKID_GLOBAL_SETTINGS_DEF_HUMAN_LOITER )
        STATIC.HumanLoiterGlobalSettingsDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_HUMAN_LOITER, "HumanLoiter" )
    end

	--- @return HumanLoiterGlobalSettingsDefinitionInstance
	function STATIC.GetDefaultLoiters()
		if STATIC.DefaultLoiters == nil then
			STATIC.DefaultLoiters = definitionManagerClass.FindTypedDefinition( "Loiter", combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_HUMAN_LOITER ) --[[@as HumanLoiterGlobalSettingsDefinitionInstance]]
		end
		if STATIC.DefaultLoiters == nil then
			section.Error( "Failed to load Default Loiter" )
		end
		return STATIC.DefaultLoiters
	end

	--- @return HumanLoiterGlobalSettingsDefinitionInstance
	function STATIC.GetWeaponLoiters()
		if STATIC.WeaponLoiters == nil then
			STATIC.WeaponLoiters = definitionManagerClass.FindTypedDefinition( "Weapon Loiters", combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_HUMAN_LOITER ) --[[@as HumanLoiterGlobalSettingsDefinitionInstance]]
		end
		if STATIC.WeaponLoiters == nil then
			section.Error( "Failed to Weapons Loiter" )
		end
		return STATIC.WeaponLoiters
	end

	--- @return HumanLoiterGlobalSettingsDefinitionInstance
	function STATIC.GetWeaponlessLoiters()
		if STATIC.WeaponlessLoiters == nil then
			STATIC.WeaponlessLoiters = definitionManagerClass.FindTypedDefinition( "Weaponless Loiters", combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_HUMAN_LOITER ) --[[@as HumanLoiterGlobalSettingsDefinitionInstance]]
		end
		if STATIC.WeaponlessLoiters == nil then
			section.Error( "Failed to load weaponless Loiter" )
		end
		return STATIC.WeaponlessLoiters
	end
end


--- @class HumanLoiterGlobalSettingsDefinitionInstance
--- @field ActivationDelay number
--- @field LoiterFrequency number
--- @field LoiterAnimationList string[]

function INSTANCE:Renegade_HumanLoiterGlobalSettingsDefinition()
	definitionClass.Instance.Renegade_Definition( self )

	self.ActivationDelay = 20
	self.LoiterFrequency = 10
end

function INSTANCE:_Renegade_HumanLoiterGlobalSettingsDefinition()
	if self == STATIC.DefaultLoiters then
		STATIC.DefaultLoiters = nil
	end

	if self == STATIC.WeaponLoiters then
		STATIC.WeaponLoiters = nil
	end

	if self == STATIC.WeaponlessLoiters then
		STATIC.WeaponlessLoiters = nil
	end
end

--- @return integer
function INSTANCE:GetClassId()
	return combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_HUMAN_LOITER
end

--- @return PersistInstance
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
	typecheck.NotImplementedError()
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
	return STATIC.HumanLoiterGlobalSettingsDefinitionPersistFactory
end

--- @return number
function INSTANCE:GetActivationDelay()
	return self.ActivationDelay
end

--- @return string
function INSTANCE:PickAnimation()
	if #self.LoiterAnimationList == 0 then
		return ""
	end
	return self.LoiterAnimationList[ math.random(1, #self.LoiterAnimationList ) ]
end
