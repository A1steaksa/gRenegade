-- Based on BaseGameObj within Code/Combat/basegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

--- @type NetworkObjectClass
local networkObjectClass = CNC.Import( "code/wwnet/network-object.lua" )

--- @class BaseGameObjectClass : PersistClass, NetworkObjectClass
--- @field Instance BaseGameObjectInstance The metatable used by BaseGameObjectInstance
local STATIC = CNC.CreateExport( persistClass, networkObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BaseGameObjectClass"
--- @class BaseGameObjectInstance : PersistInstance, NetworkObjectInstance
--- @field Static BaseGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BaseGameObject : Renegade_Persist, Renegade_NetworkObject" )
INSTANCE.Class = "BaseGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBaseGameObject = true


--#region Imports

    --- @type NetClassId
    local netClassId = CNC.Import( "code/combat/net-class-ids.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    --- @type GameObjectManagerClass
    local gameObjectManagerClass = CNC.Import( "code/combat/game-object-manager.lua" )
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES = enumBuilder:Set( 910991407 ),

        XXX_MICROCHUNKID_DESTROY_TYPE        = enumBuilder:Set( 1 ),
        MICROCHUNKID_DEFINITION_ID           = enumBuilder:Next(),
        MICROCHUNKID_INSTANCE_ID             = enumBuilder:Next(),
        MICROCHUNKID_IS_PENDING_DELETE       = enumBuilder:Next(),
        MICROCHUNKID_ENABLE_CINEMATIC_FREEZE = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class BaseGameObjectClass

    --- Creates a new BaseGameObjectInstance
    --- @return BaseGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_BaseGameObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BaseGameObjectInstance, `false` otherwise
    function STATIC.IsBaseGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBaseGameObject and true or false
    end

    typecheck.RegisterType( "BaseGameObjectInstance", STATIC.IsBaseGameObject )
end


--- @class BaseGameObjectInstance
--- @field ConnectedEntity Entity The Garry's Mod Entity that this Renegade Game Object represents
--- @field Definition BaseGameObjectDefinitionInstance "Member data"
--- @field _IsPostThinkAllowed boolean "This is used to prevent postthinking before a think call"
--- @field _EnableCinematicFreeze boolean "This keeps certain object alive during cinematic freeze"


--[[ Constructor and Destructor ]] do

    --- Constructs a new BaseGameObjectInstance
    function INSTANCE:Renegade_BaseGameObject()
        self.Definition = nil
        self._IsPostThinkAllowed = false
        self._EnableCinematicFreeze = true

        gameObjectManagerClass.Add( self )
        -- Omitted setting network creation bit as dirty
    end

    function INSTANCE:_delete()
        gameObjectManagerClass.Remove( self )
    end
end


--[[ Entity Connection ]] do

    --- @param entity Entity
    function INSTANCE:SetConnectedEntity( entity )
        self.ConnectedEntity = entity
    end

    --- @returns Entity
    function INSTANCE:GetConnectedEntity( entity )
        return self.ConnectedEntity
    end
end


--[[ Definitions ]] do

    --- @param definition BaseGameObjectDefinitionInstance
    function INSTANCE:Init( definition )
        self.Definition = definition
    end

    --- @return BaseGameObjectDefinitionInstance
    function INSTANCE:GetDefinition()
        return self.Definition
    end
end


--[[ Save / Load ]] do

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
end


--[[ Thinking ]] do

    function INSTANCE:Think()
        self._IsPostThinkAllowed = true
    end

    function INSTANCE:PostThink()
    end

    --- @return boolean
    function INSTANCE:IsPostThinkAllowed()
        return self._IsPostThinkAllowed
    end
end

--[[ ID ]] do

    --- @param id integer
    function INSTANCE:SetId( id )
        self:SetNetworkId( id )
    end

    --- @return integer
    function INSTANCE:GetId()
        return self:GetNetworkId()
    end
end


--- @return boolean
function INSTANCE:IsHibernating()
    return false
end


--[[ Type Identification ]] do

    --- @return PhysicalGameObjectInstance?
    function INSTANCE:AsPhysicalGameObject()
        return nil
    end

    --- @return VehicleGameObjectInstance?
    function INSTANCE:AsVehicleGameObject()
        return nil
    end

    --- @return SmartGameObjectInstance?
    function INSTANCE:AsSmartGameObject()
        return nil
    end

    --- @return ScriptableGameObjectInstance?
    function INSTANCE:AsScriptableGameObject()
        return nil
    end
end

--[[ Network Support ]] do

    function INSTANCE:GetNetworkClassId()
        return netClassId.NETCLASSID_GAMEOBJ
    end
end

--[[ Cinematic Freeze ]] do

    --- @param isCinematicFreezeEnabled boolean
    function INSTANCE:EnableCinematicFreeze( isCinematicFreezeEnabled )
        self._EnableCinematicFreeze = isCinematicFreezeEnabled
    end

    --- @return boolean
    function INSTANCE:IsCinematicFreezeEnabled()
        return self._EnableCinematicFreeze
    end
end
