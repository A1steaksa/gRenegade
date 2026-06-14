-- Based on DynamicPhysDefClass within Code/wwphys/dynamicphys.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PhysicsDefinitionClass
local physicsDefinitionClass = CNC.Import( "code/wwphys/physics-definition.lua" )

--- @class DynamicPhysicsDefinitionClass : PhysicsDefinitionClass
--- @field Instance DynamicPhysicsDefinitionInstance The metatable used by DynamicPhysicsDefinitionInstance
local STATIC = CNC.CreateExport( physicsDefinitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DynamicPhysicsDefinitionClass"

--- @class DynamicPhysicsDefinitionInstance : PhysicsDefinitionInstance
--- @field Static DynamicPhysicsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DynamicPhysicsDefinition : Renegade_PhysicsDefinition" )
INSTANCE.Class = "DynamicPhysicsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDynamicPhysicsDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type PhysicsDefinitionClass
	local physicsDefinitionClass = CNC.Import( "code/wwphys/physics-definition.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        DYNAMICPHYSDEF_CHUNK_PHYSDEF = enumBuilder:Set( 813001104 ), -- "parent class data."
    }
end

--[[ Static Functions and Variables ]] do

    --- "  
    --- This holds the description for a [DynamicPhysicsInstance].  
    --- Again, this class isn't concrete so it doesn't have factories...  
    --- "  
    --- @class DynamicPhysicsDefinitionClass

    --- Creates a new DynamicPhysicsDefinitionInstance
    --- @return DynamicPhysicsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DynamicPhysicsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DynamicPhysicsDefinitionInstance, `false` otherwise
    function STATIC.IsDynamicPhysicsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDynamicPhysicsDefinition and true or false
    end

    typecheck.RegisterType( "DynamicPhysicsDefinitionInstance", STATIC.IsDynamicPhysicsDefinition )
end


--- @class DynamicPhysicsDefinitionInstance

function INSTANCE:Renegade_DynamicPhysicsDefinition()
    -- Empty in the original code
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
        if cload:CurChunkId() == ids.DYNAMICPHYSDEF_CHUNK_PHYSDEF then
            physicsDefinitionClass.Instance.Load( self, cload )
        end

        cload:CloseChunk()
    end

    return true
end

--- "From [PhysicsDefinitionInstance]"
--- @return string
function INSTANCE:GetTypeName()
    return "DynamicPhysDef"
end

--- @param typeName string
--- @return boolean
function INSTANCE:IsType( typeName )
	if self:GetTypeName():lower() == typeName:lower() then
        return true
    else
        return physicsDefinitionClass.Instance.IsType( self, typeName )
    end
end

--- @return boolean, string?
function INSTANCE:IsValidConfig()
    local validity, message = physicsDefinitionClass.Instance.IsValidConfig( self )
    return validity, message
end
