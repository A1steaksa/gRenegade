-- Based on MoveablePhysDefClass within Code/wwphys/movephys.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DynamicPhysicsDefinitionClass
local dynamicPhysicsDefinitionClass = CNC.Import( "code/wwphys/dynamic-physics-definition.lua" )

--- @class MoveablePhysicsDefinitionClass : DynamicPhysicsDefinitionClass
--- @field Instance MoveablePhysicsDefinitionInstance The metatable used by MoveablePhysicsDefinitionInstance
local STATIC = CNC.CreateExport( dynamicPhysicsDefinitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MoveablePhysicsDefinitionClass"

--- @class MoveablePhysicsDefinitionInstance : DynamicPhysicsDefinitionInstance
--- @field Static MoveablePhysicsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MoveablePhysicsDefinition : Renegade_DynamicPhysicsDefinition" )
INSTANCE.Class = "MoveablePhysicsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMoveablePhysicsDefinition = true

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum CinematicCollisionMode
    STATIC.CINEMATIC_COLLISION = {
        CINEMATIC_COLLISION_NONE = enumBuilder:Set( 0 ),
        CINEMATIC_COLLISION_STOP = enumBuilder:Next(),
        CINEMATIC_COLLISION_PUSH = enumBuilder:Next(),
        CINEMATIC_COLLISION_KILL = enumBuilder:Next()
    }
    local cinematicCollisionModeEnum = STATIC.CINEMATIC_COLLISION
--#endregion

--#region Imports

	--- @type PhysicsDefinitionClass
	local physicsDefinitionClass = CNC.Import( "code/wwphys/physics-definition.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Chunk IDs ]] do

    STATIC.ChunkIds = {
        MOVEABLEPHYSDEF_CHUNK_PHYSDEF        = enumBuilder:Set( 0x04486000 ), -- "obsolete parent class"
        MOVEABLEPHYSDEF_CHUNK_VARIABLES      = enumBuilder:Next(),
        MOVEABLEPHYSDEF_CHUNK_DYNAMICPHYSDEF = enumBuilder:Next(), -- "current parent class"

        MOVEABLEPHYSDEF_VARIABLE_MASS                   = enumBuilder:Set( 0x00 ),
        MOVEABLEPHYSDEF_VARIABLE_GRAVSCALE              = enumBuilder:Next(),
        MOVEABLEPHYSDEF_VARIABLE_ELASTICITY             = enumBuilder:Next(),
        MOVEABLEPHYSDEF_VARIABLE_CINEMATICCOLLISIONMODE = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class MoveablePhysicsDefinitionClass

    --- Creates a new MoveablePhysicsDefinitionInstance
    --- @return MoveablePhysicsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MoveablePhysicsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MoveablePhysicsDefinitionInstance, `false` otherwise
    function STATIC.IsMoveablePhysicsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMoveablePhysicsDefinition and true or false
    end

    typecheck.RegisterType( "MoveablePhysicsDefinitionInstance", STATIC.IsMoveablePhysicsDefinition )
end


--- @class MoveablePhysicsDefinitionInstance
--- @field Mass number
--- @field GravityScale number
--- @field Elasticity number
--- @field CinematicCollisionMode CinematicCollisionMode

function INSTANCE:Renegade_MoveablePhysicsDefinition()
    self.Mass = 1.0
    self.GravityScale = 1.0
    self.Elasticity = 0.1
    self.CinematicCollisionMode = cinematicCollisionModeEnum.CINEMATIC_COLLISION_PUSH
end

--[[ From [PhysicsDefinitionClass] ]] do

    --- @return string
    function INSTANCE:GetTypeName()
        return "MoveablePhysDef"
    end

    --- @param typeName string
    --- @return boolean
    function INSTANCE:IsType( typeName )
        if self:GetTypeName():lower() == typeName:lower() then
            return true
        else
            return dynamicPhysicsDefinitionClass.Instance.IsType( self, typeName )
        end
    end
end

--[[ From [PersistInstance] ]] do

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
            local chunkId = cload:CurChunkId()

            if chunkId == ids.MOVEABLEPHYSDEF_CHUNK_PHYSDEF then
                physicsDefinitionClass.Instance.Load( self, cload )

            elseif chunkId == ids.MOVEABLEPHYSDEF_CHUNK_DYNAMICPHYSDEF then
                dynamicPhysicsDefinitionClass.Instance.Load( self, cload )

            elseif chunkId == ids.MOVEABLEPHYSDEF_CHUNK_VARIABLES then
                while cload:OpenMicroChunk() do
                    local didRead = (
                           chunkIOClass.ReadMicroChunk( cload, ids.MOVEABLEPHYSDEF_VARIABLE_MASS,                   fundamentalDataTypeEnum.Float, self, "Mass" )
                        or chunkIOClass.ReadMicroChunk( cload, ids.MOVEABLEPHYSDEF_VARIABLE_GRAVSCALE,              fundamentalDataTypeEnum.Float, self, "GravityScale" )
                        or chunkIOClass.ReadMicroChunk( cload, ids.MOVEABLEPHYSDEF_VARIABLE_ELASTICITY,             fundamentalDataTypeEnum.Float, self, "Elasticity" )
                        or chunkIOClass.ReadMicroChunk( cload, ids.MOVEABLEPHYSDEF_VARIABLE_CINEMATICCOLLISIONMODE, fundamentalDataTypeEnum.Int,   self, "CinematicCollisionMode" )
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


--[[ In-Game Editing (DEBUGGING/TESTING ONLY) ]] do

    --- @return number
    function INSTANCE:GetMass()
        return self.Mass
    end

    --- @return number
    function INSTANCE:GetGravScale()
        return self.GravityScale
    end

    --- @param newMass number
    function INSTANCE:SetMass( newMass )
        self.Mass = newMass
    end

    --- @param newGravityScale number
    function INSTANCE:SetGravScale( newGravityScale )
        self.GravityScale = newGravityScale
    end
end

