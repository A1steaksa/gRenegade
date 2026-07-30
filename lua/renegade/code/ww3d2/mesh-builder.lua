-- Based on MeshBuilderClass within Code/ww3d2/meshbuild.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MeshBuilderClass
--- @field Instance MeshBuilderInstance The metatable used by MeshBuilderInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MeshBuilderClass"

--- @class MeshBuilderInstance
--- @field Static MeshBuilderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MeshBuilder" )
INSTANCE.Class = "MeshBuilderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMeshBuilder = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MeshBuilderClass

    --- Creates a new MeshBuilderInstance
    --- @return MeshBuilderInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MeshBuilder" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MeshBuilderInstance, `false` otherwise
    function STATIC.IsMeshBuilder( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMeshBuilder and true or false
    end

    typecheck.RegisterType( "MeshBuilderInstance", STATIC.IsMeshBuilder )
end


--- @class MeshBuilderInstance
--- @field State any
--- @field PassCount any
--- @field FaceCount any
--- @field Faces any
--- @field InputVertCount any
--- @field VertCount any
--- @field Verts any
--- @field CurFace any
--- @field WorldInfo any
--- @field Stats any
--- @field PolyOrderPass any
--- @field PolyOrderStage any
--- @field AllocFaceCount any
--- @field AllocFaceGrowth any

STATIC.STATE_ACCEPTING_INPUT = 0 -- "Mesh builder is accepting input triangles"
STATIC.STATE_MESH_PROCESSED  = 1 -- "Mesh builder has processed the mesh"
STATIC.MAX_PASSES = 4 -- "Maximum number of material passes supported"
STATIC.MAX_STAGES = 2 -- "Maximum number of texture stages supported in a single pass"

function INSTANCE:Renegade_MeshBuilder()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_MeshBuilder()
	typecheck.NotImplementedError()
end

function INSTANCE:Reset()
	typecheck.NotImplementedError()
end

function INSTANCE:AddFace()
	typecheck.NotImplementedError()
end

function INSTANCE:BuildMesh()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPolygonOrderingChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPassCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVertexCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFaceCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVertex()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFace()
	typecheck.NotImplementedError()
end

function INSTANCE:ComputeBoundingBox()
	typecheck.NotImplementedError()
end

function INSTANCE:ComputeBoundingSphere()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekWorldInfo()
	typecheck.NotImplementedError()
end

function INSTANCE:SetWorldInfo()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMeshStats()
	typecheck.NotImplementedError()
end

function INSTANCE:Free()
	typecheck.NotImplementedError()
end

function INSTANCE:ComputeMeshStats()
	typecheck.NotImplementedError()
end

function INSTANCE:OptimizeMesh()
	typecheck.NotImplementedError()
end

function INSTANCE:StripOptimizeMesh()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveDegenerateFaces()
	typecheck.NotImplementedError()
end

function INSTANCE:ComputeFaceNormals()
	typecheck.NotImplementedError()
end

function INSTANCE:VerifyFaceNormals()
	typecheck.NotImplementedError()
end

function INSTANCE:ComputeVertexNormals()
	typecheck.NotImplementedError()
end

function INSTANCE:GrowFaceArray()
	typecheck.NotImplementedError()
end

function INSTANCE:SortVertices()
	typecheck.NotImplementedError()
end
