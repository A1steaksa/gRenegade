-- Based on SimpleGameObj within Code/Combat/simplegameobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PhysicalGameObjectClass
local physicalGameObjectClass = CNC.Import( "code/combat/physical-game-object.lua" )

--- @class SimpleGameObjectClass : PhysicalGameObjectClass
--- @field Instance SimpleGameObjectInstance The metatable used by SimpleGameObjectInstance
local STATIC = CNC.CreateExport( physicalGameObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SimpleGameObjectClass"

--- @class SimpleGameObjectInstance : PhysicalGameObjectInstance
--- @field Static SimpleGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SimpleGameObject : Renegade_PhysicalGameObject" )
INSTANCE.Class = "SimpleGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSimpleGameObject = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type BaseGameObjectClass
    local baseGameObjectClass = CNC.Import( "code/combat/base-game-object.lua" )

    --- @type SimplePersistFactoryClass
    local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

    --- @type CombatChunkId
    local combatChunkId = CNC.Import( "code/combat/combat-chunk-id.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class SimpleGameObjectClass
    --- @field SimpleGameObjectPersistFactory SimplePersistFactoryInstance

    --- Creates a new SimpleGameObjectInstance
    --- @return SimpleGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SimpleGameObject" )
    end

    function STATIC.StaticConstructor()
        STATIC.SimpleGameObjectPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkId.CHUNKID_GAME_OBJECT_SIMPLE )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SimpleGameObjectInstance, `false` otherwise
    function STATIC.IsSimpleGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSimpleGameObject and true or false
    end

    typecheck.RegisterType( "SimpleGameObjectInstance", STATIC.IsSimpleGameObject )
end


--- @class SimpleGameObjectInstance

function INSTANCE:Renegade_SimpleGameObject()
    -- self:SetAppPacketType( appPacketTypeEnum.APPPACKETTYPE_SIMPLE )
end

function INSTANCE:_Renegade_SimpleGameObject()
    -- Empty in the original code
end


--[[ Definitions ]] do

    --- @param definition SimpleGameObjectDefinitionInstance?
    --- @param connectedEntity Entity
    function INSTANCE:Init( definition, connectedEntity )
        if not definition then
            definition = self:GetDefinition()
        end

        physicalGameObjectClass.Instance.Init( self, definition, connectedEntity )
    end

    --- @return SimpleGameObjectDefinitionInstance
    function INSTANCE:GetDefinition()
        return baseGameObjectClass.Instance:GetDefinition() --[[@as SimpleGameObjectDefinitionInstance]]
    end
end


--[[ RITTI ]] do

    --- @return SimpleGameObjectInstance
    function INSTANCE:AsSimpleGameObject()
        return self
    end
end


function INSTANCE:IsHiddenObject()
    return self:GetDefinition().IsHiddenObject
end


--[[ Save/Load/Construction Factory ]] do

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
        return STATIC.SimpleGameObjectPersistFactory
    end

    function INSTANCE:OnPostLoad()
        physicalGameObjectClass.Instance.OnPostLoad( self )

        -- "  
        -- NOTE: the [OnPostLoad] function is only run when loading a level in the engine
        -- so we can put game-specific behavior into this function without messing up the
        -- level editor.  
        -- "  
        if self:GetDefinition().IsEditorObject then
            -- "Switch to a NULL model"
            self:PeekPhysicalObject():SetModelByName( "" )
            -- "And clear [AnimationControl]"
            if self:GetAnimationControl() then
                self:GetAnimationControl():SetModel( self:PeekModel() )
            end
        end

        if self:IsHiddenObject() then
            self:GetConnectedEntity():SetNoDraw( true )
        end
    end
end


--[[ Network Support ]] do

    function INSTANCE:IsAlwaysDirty()
        return false
    end
end
