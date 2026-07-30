-- Based on SimpleGameObjDef within Code/Combat/simplegameobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PhysicalGameObjectDefinitionClass
local physicalGameObjectDefinitionClass = CNC.Import( "code/combat/physical-game-object-definition.lua" )

--- @class SimpleGameObjectDefinitionClass : PhysicalGameObjectDefinitionClass
--- @field Instance SimpleGameObjectDefinitionInstance The metatable used by SimpleGameObjectDefinitionInstance
local STATIC = CNC.CreateExport( physicalGameObjectDefinitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SimpleGameObjectDefinitionClass"

--- @class SimpleGameObjectDefinitionInstance : PhysicalGameObjectDefinitionInstance
--- @field Static SimpleGameObjectDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SimpleGameObjectDefinition : Renegade_PhysicalGameObjectDefinition" )
INSTANCE.Class = "SimpleGameObjectDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSimpleGameObjectDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type PlayerTerminalClass
    local playerTerminalClass = CNC.Import( "code/combat/player-terminal.lua" )

    --- @type SimplePersistFactoryClass
    local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

    --- @type SimpleDefinitionFactoryClass
    local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

    --- @type CombatChunkIdClass
    local combatChunkId = CNC.Import( "code/combat/combat-chunk-id.lua" )

    --- @type SimpleGameObjectClass
    local simpleGameObjectClass = CNC.Import( "code/combat/simple-game-object.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    --- @type ChunkIOClass
    local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

    --- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

    local typeEnum = playerTerminalClass.TYPE
    local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class SimpleGameObjectDefinitionClass

    --- Creates a new SimpleGameObjectDefinitionInstance
    --- @return SimpleGameObjectDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SimpleGameObjectDefinition" )
    end

    function STATIC.StaticConstructor()
        STATIC.SimpleGameObjectDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkId.CHUNKID_GAME_OBJECT_DEF_SIMPLE )
        STATIC.SimpleGameObjectDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, combatChunkId.CLASSID_GAME_OBJECT_DEF_SIMPLE, "Simple" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SimpleGameObjectDefinitionInstance, `false` otherwise
    function STATIC.IsSimpleGameObjectDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSimpleGameObjectDefinition and true or false
    end

    typecheck.RegisterType( "SimpleGameObjectDefinitionInstance", STATIC.IsSimpleGameObjectDefinition )
end


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_DEF_PARENT    = enumBuilder:Set( 930991656 ),
        CHUNKID_DEF_VARIABLES = enumBuilder:Next(),

        MICROCHUNKID_DEF_IS_EDITOR_OBJECT = enumBuilder:Set( 1 ),
        MICROCHUNKID_DEF_IS_HIDDEN_OBJECT = enumBuilder:Next(),
        MICROCHUNKID_DEF_PLAYER_TERM_TYPE = enumBuilder:Next(),
    }
end


--- @class SimpleGameObjectDefinitionInstance
--- @field IsEditorObject boolean
--- @field IsHiddenObject boolean
--- @field PlayerTerminalType PlayerTerminalType

function INSTANCE:Renegade_SimpleGameObjectDefinition()
    physicalGameObjectDefinitionClass.Instance.Renegade_PhysicalGameObjectDefinition( self )

    self.IsEditorObject = false
    self.IsHiddenObject = false
    self.PlayerTerminalType = typeEnum.TYPE_NONE
end

--- @return integer
function INSTANCE:GetClassId()
    return combatChunkId.CLASSID_GAME_OBJECT_DEF_SIMPLE
end

--- @param connectedEntity Entity
--- @return PersistInstance
function INSTANCE:Create( connectedEntity )
    local object = simpleGameObjectClass.New()
    object:Init( self, connectedEntity )
    return object
end

--- @param csave ChunkSaveInstance
function INSTANCE:Save( csave )
    typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    local ids = STATIC.ChunkIds
    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.CHUNKID_DEF_PARENT then
            physicalGameObjectDefinitionClass.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_VARIABLES then
            while cload:OpenMicroChunk() do
                local didRead = (
                       chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_IS_EDITOR_OBJECT, fundamentalDataTypeEnum.Boolean, self, "IsEditorObject" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_IS_HIDDEN_OBJECT, fundamentalDataTypeEnum.Boolean, self, "IsHiddenObject" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_PLAYER_TERM_TYPE, fundamentalDataTypeEnum.Int,     self, "PlayerTerminalType" )
                )

                if not didRead then
                    section.Warn( "Unrecognized ", INSTANCE.Class, " Variable Chunk ID: ", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end

        else
            section.Warn( "Unrecognized SimpleDef Chunk ID: ", chunkId )
        end

        cload:CloseChunk()
    end

    return true
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
    return STATIC.SimpleGameObjectDefinitionPersistFactory
end


--[[ Accessors ]] do

    --- @return PlayerTerminalType
    function INSTANCE:GetPlayerTerminalType()
        return self.PlayerTerminalType
    end

    --- @return boolean
    function INSTANCE:GetIsEditorObject()
        return self.IsEditorObject
    end
end

