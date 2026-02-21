-- Based on BaseGameObj within Code/Combat/basegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local PARENT = CNC.Import( "code/wwsaveload/persist.lua" )

--- @class BaseGameObjectClass : PersistClass
--- @field Instance BaseGameObjectInstance The metatable used by BaseGameObjectInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BaseGameObjectClass"
--- @class BaseGameObjectInstance : PersistInstance
--- @field Static BaseGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BaseGameObject : Renegade_Persist" )
INSTANCE.Class = "BaseGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBaseGameObject = true


--#region Imports
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--#region Imported Enums
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
    --- @vararg any
    --- @return BaseGameObjectInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_BaseGameObject", ... )
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
--- @field IsPostThinkAllowed boolean "This is used to prevent postthinking before a think call"
--- @field EnableCinematicFreeze boolean "This keeps certain object alive during cinematic freeze"

--- Constructs a new BaseGameObjectInstance
--- @vararg any
function INSTANCE:Renegade_BaseGameObject( ... )
    local args = { ... }
    local argCount = select( "#", ... )

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