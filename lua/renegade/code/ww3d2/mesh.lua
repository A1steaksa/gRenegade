-- Based on MeshClass within Code/ww3d2/mesh.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type RenderObjectClass
local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

--- @class MeshClass : RenderObjectClass
--- @field Instance MeshInstance The metatable used by MeshInstance
local STATIC = CNC.CreateExport( renderObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MeshClass"

--- @class MeshInstance : RenderObjectInstance
--- @field Static MeshClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Mesh : Renegade_RenderObject" )
INSTANCE.Class = "MeshInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMesh = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MeshClass
    --- @field LegacyMeshesFogged any

    --- Creates a new MeshInstance
    --- @return MeshInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Mesh" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MeshInstance, `false` otherwise
    function STATIC.IsMesh( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMesh and true or false
    end

    typecheck.RegisterType( "MeshInstance", STATIC.IsMesh )
end


--- @class MeshInstance
--- @field Model any
--- @field DecalMesh any
--- @field LightEnvironment any
--- @field BaseVertexOffset any
--- @field NextVisibleSkin any
--- @field MeshDebugId any
--- @field IsDisabledByDebugger any
--- @field UserLighting any
--- @field PolygonRendererList any

function INSTANCE:Renegade_Mesh()
    typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_Mesh()
    typecheck.NotImplementedError()
end

function INSTANCE:Clone()
    typecheck.NotImplementedError()
end

function INSTANCE:ClassId()
    typecheck.NotImplementedError()
end

function INSTANCE:GetName()
    typecheck.NotImplementedError()
end

function INSTANCE:SetName()
    typecheck.NotImplementedError()
end

function INSTANCE:GetNumPolys()
    typecheck.NotImplementedError()
end

function INSTANCE:Render()
    typecheck.NotImplementedError()
end

function INSTANCE:RenderMaterialPass()
    typecheck.NotImplementedError()
end

function INSTANCE:SpecialRender()
    typecheck.NotImplementedError()
end

function INSTANCE:CastRay()
    typecheck.NotImplementedError()
end

function INSTANCE:CastAaBox()
    typecheck.NotImplementedError()
end

function INSTANCE:CastObBox()
    typecheck.NotImplementedError()
end

function INSTANCE:IntersectAaBox()
    typecheck.NotImplementedError()
end

function INSTANCE:IntersectObBox()
    typecheck.NotImplementedError()
end

function INSTANCE:GetObjectSpaceBoundingSphere()
    typecheck.NotImplementedError()
end

function INSTANCE:GetObjectSpaceBoundingBox()
    typecheck.NotImplementedError()
end

function INSTANCE:Scale()
    typecheck.NotImplementedError()
end

function INSTANCE:GetMaterialInfo()
    typecheck.NotImplementedError()
end

function INSTANCE:GetSortLevel()
    typecheck.NotImplementedError()
end

function INSTANCE:SetSortLevel()
    typecheck.NotImplementedError()
end

function INSTANCE:CreateDecal()
    typecheck.NotImplementedError()
end

function INSTANCE:DeleteDecal()
    typecheck.NotImplementedError()
end

function INSTANCE:Init()
    typecheck.NotImplementedError()
end

function INSTANCE:LoadW3d()
    typecheck.NotImplementedError()
end

function INSTANCE:GenerateCullingTree()
    typecheck.NotImplementedError()
end

function INSTANCE:GetModel()
    typecheck.NotImplementedError()
end

function INSTANCE:PeekModel()
    typecheck.NotImplementedError()
end

function INSTANCE:GetW3dFlags()
    typecheck.NotImplementedError()
end

function INSTANCE:GetUserText()
    typecheck.NotImplementedError()
end

function INSTANCE:Contains()
    typecheck.NotImplementedError()
end

function INSTANCE:ComposeDeformedVertexBuffer()
    typecheck.NotImplementedError()
end

function INSTANCE:GetDeformedVertices()
    typecheck.NotImplementedError()
end

function INSTANCE:SetLightingEnvironment()
    typecheck.NotImplementedError()
end

function INSTANCE:GetLightingEnvironment()
    typecheck.NotImplementedError()
end

function INSTANCE:SetNextVisibleSkin()
    typecheck.NotImplementedError()
end

function INSTANCE:PeekNextVisibleSkin()
    typecheck.NotImplementedError()
end

function INSTANCE:SetBaseVertexOffset()
    typecheck.NotImplementedError()
end

function INSTANCE:GetBaseVertexOffset()
    typecheck.NotImplementedError()
end

function INSTANCE:ReplaceTexture()
    typecheck.NotImplementedError()
end

function INSTANCE:ReplaceVertexMaterial()
    typecheck.NotImplementedError()
end

function INSTANCE:MakeUnique()
    typecheck.NotImplementedError()
end

function INSTANCE:GetDebugId()
    typecheck.NotImplementedError()
end

function INSTANCE:SetDebuggerDisable()
    typecheck.NotImplementedError()
end

function INSTANCE:IsDisabledByDebugger()
    typecheck.NotImplementedError()
end

function INSTANCE:InstallUserLightingArray()
    typecheck.NotImplementedError()
end

function INSTANCE:GetUserLightingArray()
    typecheck.NotImplementedError()
end

function INSTANCE:SaveUserLighting()
    typecheck.NotImplementedError()
end

function INSTANCE:LoadUserLighting()
    typecheck.NotImplementedError()
end

function INSTANCE:Free()
    typecheck.NotImplementedError()
end

function INSTANCE:AddDependenciesToList()
    typecheck.NotImplementedError()
end

function INSTANCE:UpdateCachedBoundingVolumes()
    typecheck.NotImplementedError()
end

function INSTANCE:PeekFvfCategoryContainer()
    typecheck.NotImplementedError()
end

function INSTANCE:()
    typecheck.NotImplementedError()
end

function INSTANCE:()
    typecheck.NotImplementedError()
end

function INSTANCE:()
    typecheck.NotImplementedError()
end

function INSTANCE:()
    typecheck.NotImplementedError()
end
