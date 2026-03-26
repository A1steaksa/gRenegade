-- Based on PhysClass within Code/wwphys/phys.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

-- Omitted CullableClass and MultiListObjectClass parents

--- @class PhysicsClass : PersistClass
--- @field Instance PhysicsInstance The metatable used by PhysicsInstance
local STATIC = CNC.CreateExport( persistClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicsClass"
--- @class PhysicsInstance : PersistInstance
--- @field Static PhysicsClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Physics : Renegade_Persist" )
INSTANCE.Class = "PhysicsInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysics = true


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum PlaceholderName
    STATIC.PLACEHOLDER_NAME = {
        PLACEHOLDER = enumBuilder:Set( 0 ),
        PLACEHOLDER = enumBuilder:Next(),
    }
    local placeholderEnum = STATIC.PLACEHOLDER_NAME
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_PLACEHOLDER = enumBuilder:Set( 0 ),
        CHUNKID_PLACEHOLDER = enumBuilder:Next(),
    }
end



--[[ Static Functions and Variables ]] do

    --- "This is the base class for all objects in the physics system."
    --- @class PhysicsClass

    --- Creates a new PhysicsInstance
    --- @return PhysicsInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Physics" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicsInstance, `false` otherwise
    function STATIC.IsPhysics( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysics and true or false
    end

    typecheck.RegisterType( "PhysicsInstance", STATIC.IsPhysics )
end


--- @class PhysicsInstance

--- Constructs a new PhysicsInstance
function INSTANCE:Renegade_Physics()
    typecheck.NotImplementedError()
end

function INSTANCE:_delete()
    typecheck.NotImplementedError()
end

--- @param definition PhysicsDefinitionInstance
function INSTANCE:Init( definition )
    typecheck.NotImplementedError()
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
