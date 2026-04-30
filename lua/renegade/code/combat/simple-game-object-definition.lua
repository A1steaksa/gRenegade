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

    --- @type CombatChunkId
    local combatChunkId = CNC.Import( "code/combat/combat-chunk-id.lua" )

    --- @type SimpleGameObjectClass
    local simpleGameObjectClass = CNC.Import( "code/combat/simple-game-object.lua" )
--#endregion

--#region Imported Enums

    local typeEnum = playerTerminalClass.TYPE
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


--- @class SimpleGameObjectDefinitionInstance
--- @field IsEditorObject boolean
--- @field IsHiddenObject boolean
--- @field PlayerTerminalType Type

function INSTANCE:Renegade_SimpleGameObjectDefinition()
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
function INSTANCE:Load( cload )
    typecheck.NotImplementedError()
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
    return STATIC.SimpleGameObjectDefinitionPersistFactory
end


--[[ Accessors ]] do

    --- @return Type
    function INSTANCE:GetPlayerTerminalType()
        return self.PlayerTerminalType
    end

    --- @return boolean
    function INSTANCE:GetIsEditorObject()
        return self.IsEditorObject
    end
end

