-- Based on SoldierGameObjDef within Code/Combat/soldier.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SmartGameObjectDefinitionClass
local smartGameObjectDefinitionClass = CNC.Import( "code/combat/smart-game-object-definition.lua" )

--- @class SoldierGameObjectDefinitionClass : SmartGameObjectDefinitionClass
--- @field Instance SoldierGameObjectDefinitionInstance The metatable used by SoldierGameObjectDefinitionInstance
local STATIC = CNC.CreateExport( smartGameObjectDefinitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SoldierGameObjectDefinitionClass"

--- @class SoldierGameObjectDefinitionInstance : SmartGameObjectDefinitionInstance
--- @field Static SoldierGameObjectDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SoldierGameObjectDefinition : Renegade_SmartGameObjectDefinition" )
INSTANCE.Class = "SoldierGameObjectDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSoldierGameObjectDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SimpleDefinitionFactoryClass
	local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type DialogueClass
	local dialogueClass = CNC.Import( "code/combat/dialogue.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type SoldierGameObjectClass
	local soldierGameObjectClass = CNC.Import( "code/combat/soldier-game-object.lua" )
--#endregion

--#region Imported Enums

	local dialogEventsEnum = dialogueClass.DIALOG_EVENTS
	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Chunk IDs ]] do

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_DEF_PARENT       = enumBuilder:Set( 909991656 ),
        CHUNKID_DEF_VARIABLES    = enumBuilder:Next(),
        CHUNKID_DEF_DIALOG_ENTRY = enumBuilder:Next(),

        MICROCHUNKID_DEF_TURN_RATE                      = enumBuilder:Set( 1 ),
	    MICROCHUNKID_DEF_JUMP_VELOCITY                  = enumBuilder:Next(),
	    MICROCHUNKID_DEF_SKELETON_HEIGHT                = enumBuilder:Next(),
	    MICROCHUNKID_DEF_SKELETON_WIDTH                 = enumBuilder:Next(),
	    MICROCHUNKID_DEF_USE_INNATE_BEHAVIOR            = enumBuilder:Next(),
	    MICROCHUNKID_DEF_INNATE_AGGRESSIVENESS          = enumBuilder:Next(),
	    MICROCHUNKID_DEF_INNATE_TAKE_COVER_PROB         = enumBuilder:Next(),
	    XXXMICROCHUNKID_DEF_INNATE_ESCORT_ID            = enumBuilder:Next(),
	    XXXMICROCHUNKID_DEF_INNATE_ESCORT_RANGE         = enumBuilder:Next(),
	    MICROCHUNKID_DEF_FIRST_PERSON_HANDS             = enumBuilder:Next(),
	    XXXMICROCHUNKID_DEF_CORPSE_PERSIST_TIME         = enumBuilder:Next(),
	    MICROCHUNKID_DEF_USE_INNATE_CONVERSATIONS       = enumBuilder:Next(),
	    MICROCHUNKID_DEF_INNATE_IS_STATIONARY           = enumBuilder:Next(),
	    MICROCHUNKID_DEF_ORATOR_TYPE                    = enumBuilder:Next(),
	    MICROCHUNKID_DEF_HUMAN_ANIM_OVERRIDE_DEF_ID     = enumBuilder:Next(),
	    MICROCHUNKID_DEF_DEATH_SOUND_PRESET             = enumBuilder:Next(),
	    MICROCHUNKID_DEF_HUMAN_LOITER_COLLECTION_DEF_ID = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class SoldierGameObjectDefinitionClass
    --- @field _SoldierGameObjectDefinitionPersistFactory SimplePersistFactoryInstance<SoldierGameObjectDefinitionInstance>
    --- @field _SoldierGameObjectDefinitionDefinitionFactory SimpleDefinitionFactoryInstance<SoldierGameObjectDefinitionInstance>

    --- Creates a new SoldierGameObjectDefinitionInstance
    --- @return SoldierGameObjectDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SoldierGameObjectDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SoldierGameObjectDefinitionInstance, `false` otherwise
    function STATIC.IsSoldierGameObjectDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSoldierGameObjectDefinition and true or false
    end

    typecheck.RegisterType( "SoldierGameObjectDefinitionInstance", STATIC.IsSoldierGameObjectDefinition )

    function STATIC.StaticConstructor()
        STATIC._SoldierGameObjectDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CHUNKID_GAME_OBJECT_DEF_SOLDIER )
        STATIC._SoldierGameObjectDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, combatChunkIdClass.CLASSID_GAME_OBJECT_DEF_SOLDIER, "Soldier" )
    end
end


--- @class SoldierGameObjectDefinitionInstance
--- @field TurnRate number
--- @field JumpVelocity number
--- @field SkeletonHeight number
--- @field SkeletonWidth number
--- @field UseInnateBehavior boolean
--- @field InnateAggressiveness number
--- @field InnateTakeCoverProbability number
--- @field InnateIsStationary boolean
--- @field DialogList DialogueInstance[]
--- @field FirstPersonHands string
--- @field HumanAnimationOverrideDefinitionID integer
--- @field HumanLoiterCollectionDefinitionID integer
--- @field DeathSoundPresetID integer

function INSTANCE:Renegade_SoldierGameObjectDefinition()
    smartGameObjectDefinitionClass.Instance.Renegade_SmartGameObjectDefinition( self )

    self.DialogList = {}

    self.TurnRate = math.rad( 360.0 )
    self.JumpVelocity = 2
    self.SkeletonHeight = 0
    self.SkeletonWidth = 0
    self.UseInnateBehavior = true
    self.InnateAggressiveness = 0.5
    self.InnateTakeCoverProbability = 0.5
    self.InnateIsStationary = false
    self.HumanAnimationOverrideDefinitionID = 0
    self.HumanLoiterCollectionDefinitionID = 0
    self.DeathSoundPresetID = 0

    -- "We want soldiers to use innate conversations by default"
    self.AllowInnateConversations = true
end

--- @return integer
function INSTANCE:GetClassId()
    return combatChunkIdClass.CLASSID_GAME_OBJECT_DEF_SOLDIER
end

--- @param ply Player
--- @return PersistInstance
function INSTANCE:Create( ply )
    local object = soldierGameObjectClass.New()
    object:Init( self, ply )
    return object
end

--- @return boolean
function INSTANCE:Save( csave )
	typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:Load( cload )
    local dialogIndex = 1
    local ids = STATIC.ChunkIds

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.CHUNKID_DEF_PARENT then
            smartGameObjectDefinitionClass.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_DIALOG_ENTRY then
            if dialogIndex <= dialogEventsEnum.DIALOG_MAX then
                dialogIndex = dialogIndex + 1
                self.DialogList[dialogIndex] = dialogueClass.New()
                self.DialogList[dialogIndex]:Load( cload )
            end

        elseif chunkId == ids.CHUNKID_DEF_VARIABLES then
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_TURN_RATE,                      fundamentalDataTypeEnum.Float,   self, "TurnRate" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_JUMP_VELOCITY,                  fundamentalDataTypeEnum.Float,   self, "JumpVelocity" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SKELETON_HEIGHT,                fundamentalDataTypeEnum.Float,   self, "SkeletonHeight" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SKELETON_WIDTH,                 fundamentalDataTypeEnum.Float,   self, "SkeletonWidth" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_USE_INNATE_BEHAVIOR,            fundamentalDataTypeEnum.Boolean, self, "UseInnateBehavior" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_INNATE_AGGRESSIVENESS,          fundamentalDataTypeEnum.Float,   self, "InnateAggressiveness" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_INNATE_TAKE_COVER_PROB,         fundamentalDataTypeEnum.Float,   self, "InnateTakeCoverProbability" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_INNATE_IS_STATIONARY,           fundamentalDataTypeEnum.Boolean, self, "InnateIsStationary" )
            chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_FIRST_PERSON_HANDS, self, "FirstPersonHands" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ORATOR_TYPE,                    fundamentalDataTypeEnum.Int,     self, "OratorType" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_HUMAN_ANIM_OVERRIDE_DEF_ID,     fundamentalDataTypeEnum.Int,     self, "HumanAnimOverrideDefID" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_HUMAN_LOITER_COLLECTION_DEF_ID, fundamentalDataTypeEnum.Int,     self, "HumanLoiterCollectionDefID" )
            chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_DEATH_SOUND_PRESET,             fundamentalDataTypeEnum.Int,     self, "DeathSoundPresetID" )
        else
            section.Warn( self.Class, " - Load - Unrecognized SoldierDef chunkID (", chunkId, ")" )
        end

        cload:CloseChunk()
    end

    return true
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
    return STATIC._SoldierGameObjectDefinitionPersistFactory
end

--- @return DialogueInstance[]
function INSTANCE:GetDialogList()
	return self.DialogList
end
