-- Based on PhysDefClass within Code/wwphys/phys.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class PhysicsDefinitionClass : DefinitionClass
--- @field Instance PhysicsDefinitionInstance The metatable used by PhysicsDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicsDefinitionClass"

--- @class PhysicsDefinitionInstance : DefinitionInstance
--- @field Static PhysicsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PhysicsDefinition : Renegade_Definition" )
INSTANCE.Class = "PhysicsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysicsDefinition = true


--#region Exported Enums
--#endregion

--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion


--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        PHYSDEF_CHUNK_DEFINITION = enumBuilder:Set( 0x055ffe07 ), -- "Parent class data."
        PHYSDEF_CHUNK_VARIABLES  = enumBuilder:Next(),            -- "Simple variables"

        PHYSDEF_VARIABLE_FLAGS     = enumBuilder:Set( 0 ),
        PHYSDEF_VARIABLE_MODELNAME = enumBuilder:Next(),
        PHYSDEF_VARIABLE_ISPRELIT  = enumBuilder:Next()
    }
end


--[[ Static Functions and Variables ]] do

    --- @class PhysicsDefinitionClass

    --- Creates a new PhysicsDefinitionInstance
    --- @return PhysicsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PhysicsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicsDefinitionInstance, `false` otherwise
    function STATIC.IsPhysicsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicsDefinition and true or false
    end

    typecheck.RegisterType( "PhysicsDefinitionInstance", STATIC.IsPhysicsDefinition )
end

-- "  
-- This holds the description for a [PhysicsClass].  
-- Since [PhysicsClass]'s aren't concrete, this definition class isn't either  
-- and thus has no persist factory (required by PersistClass)  
-- or create method (required by DefinitionClass)  
-- "  
--- @class PhysicsDefinitionInstance
--- @field ModelName string
--- @field IsPreLit boolean


function INSTANCE:Renegade_PhysicsDefinition()
    definitionClass.Instance.Renegade_Definition( self )

    self.ModelName = nil
    self.IsPreLit = false
end


--[[ From PersistClass ]] do

    function INSTANCE:Save()
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:Load( cload )
        local ids = STATIC.ChunkIds

        while cload:OpenChunk() do
            local chunkId = cload:CurChunkId()
            if chunkId == ids.PHYSDEF_CHUNK_DEFINITION then
                definitionClass.Instance.Load( self, cload )

            elseif chunkId == ids.PHYSDEF_CHUNK_VARIABLES then
                while cload:OpenMicroChunk() do
                    local didRead = (
                           chunkIOClass.ObseleteMicroChunk( ids.PHYSDEF_VARIABLE_FLAGS )
                        or chunkIOClass.ReadMicroChunkWWString( cload, ids.PHYSDEF_VARIABLE_MODELNAME, self, "ModelName" )
                        or chunkIOClass.ReadMicroChunk( cload, ids.PHYSDEF_VARIABLE_ISPRELIT, fundamentalDataTypeEnum.Boolean, self, "IsPreLit" )
                    )

                    if not didRead then
                        section.Warn( "Unhandled ", INSTANCE.Class, " Micro Chunk ID: ", cload:CurMicroChunkId() )
                    end

                    cload:CloseMicroChunk()
                end
            else
                section.Warn( "Unhandled ", INSTANCE.Class, " Chunk ID: ", chunkId )
            end

            cload:CloseChunk()
        end

        return true
    end
end


--[[ PhysDef Type Filtering Mechanism ]] do

    --- "PhysDef type filtering mechanism"
    --- @return string
    function INSTANCE:GetTypeName()
        return "PhysDef"
    end

    --- @param typeName string
    --- @return boolean
    function INSTANCE:IsType( typeName )
        if self:GetTypeName():lower() == typeName:lower() then
            return true
        else
            return false
        end
    end
end


--[[ Validation Methods ]] do

    --- @return boolean, string?
    function INSTANCE:IsValidConfig()
        if self.ModelName:len() == 0 then
            return false, "ModelName is invalid!"
        end

        return true
    end
end


--[[ Accessors ]] do

    function INSTANCE:GetModelName()
        return self.ModelName
    end

    function INSTANCE:GetIsPreLit()
        return self.IsPreLit
    end
end
