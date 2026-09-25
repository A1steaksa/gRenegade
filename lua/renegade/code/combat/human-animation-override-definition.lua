-- Based on HumanAnimOverrideDef within Code/Combat/globalsettings.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class HumanAnimationOverrideDefinitionClass : DefinitionClass
--- @field Instance HumanAnimationOverrideDefinitionInstance The metatable used by HumanAnimationOverrideDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HumanAnimationOverrideDefinitionClass"

--- @class HumanAnimationOverrideDefinitionInstance : DefinitionInstance
--- @field Static HumanAnimationOverrideDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HumanAnimationOverrideDefinition : Renegade_Definition" )
INSTANCE.Class = "HumanAnimationOverrideDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHumanAnimationOverrideDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SimpleDefinitionFactoryClass
	local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion

--#region Imported Enums
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_HAO_DEF_PARENT    = enumBuilder:Set( 726011912 ),
        CHUNKID_HAO_DEF_VARIABLES = enumBuilder:Next(),

        MICROCHUNKID_HAO_DEF_RUN_EMPTY_HANDS  = enumBuilder:Set( 1 ),
        MICROCHUNKID_HAO_DEF_WALK_EMPTY_HANDS = enumBuilder:Next(),
        MICROCHUNKID_HAO_DEF_RUN_AT_CHEST     = enumBuilder:Next(),
        MICROCHUNKID_HAO_DEF_WALK_AT_CHEST    = enumBuilder:Next(),
        MICROCHUNKID_HAO_DEF_RUN_AT_HIP       = enumBuilder:Next(),
        MICROCHUNKID_HAO_DEF_WALK_AT_HIP      = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class HumanAnimationOverrideDefinitionClass

    --- Creates a new HumanAnimationOverrideDefinitionInstance
    --- @return HumanAnimationOverrideDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HumanAnimationOverrideDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HumanAnimationOverrideDefinitionInstance, `false` otherwise
    function STATIC.IsHumanAnimationOverrideDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHumanAnimationOverrideDefinition and true or false
    end

    typecheck.RegisterType( "HumanAnimationOverrideDefinitionInstance", STATIC.IsHumanAnimationOverrideDefinition )

    function STATIC.StaticConstructor()
        STATIC.HumanAnimationOverrideDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CHUNKID_GLOBAL_SETTINGS_DEF_HUMAN_ANIM_OVERRIDE )
        STATIC.HumanAnimationOverrideDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_HUMAN_ANIM_OVERRIDE, "HUMAN_ANIM_OVERRIDE" )
    end
end


--- @class HumanAnimationOverrideDefinitionInstance
--- @field RunEmptyHands string
--- @field WalkEmptyHands string
--- @field RunAtChest string
--- @field WalkAtChest string
--- @field RunAtHip string
--- @field WalkAtHip string

function INSTANCE:Renegade_HumanAnimationOverrideDefinition()
    definitionClass.Instance.Renegade_Definition( self )

    -- Empty in the original code
end

--- @return integer
function INSTANCE:GetClassId()
    return combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_HUMAN_ANIM_OVERRIDE
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
    return STATIC.HumanAnimationOverrideDefinitionPersistFactory
end
