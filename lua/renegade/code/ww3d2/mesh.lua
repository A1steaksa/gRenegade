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

	--- @type MeshGeometryClass
	local meshGeometryClass = CNC.Import( "code/ww3d2/mesh-geometry.lua" )

	--- @type SphereClass
	local sphereClass = CNC.Import( "code/wwmath/sphere.lua" )

	--- @type MeshModelClass
	local meshModelClass = CNC.Import( "code/ww3d2/mesh-model.lua" )

    --- @type WW3dErrorTypes
    local wW3dErrorTypes = CNC.Import( "code/ww3d2/w3d-errors.lua" )
--#endregion

--#region Imported Enums

	local flagsTypeEnum = meshGeometryClass.FLAGS_TYPE
    local wW3dErrorTypeEnum = wW3dErrorTypes.WW3D_ERROR_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MeshClass
    --- @field LegacyMeshesFogged any

    --- Creates a new MeshInstance
    --- @param src MeshInstance?
    --- @return MeshInstance
    function STATIC.New( src )
        return robustclass.New( "Renegade_Mesh", src )
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

--- "Render3DObject for rendering meshes"
--- @class MeshInstance
--- @field Model MeshModelInstance
--- @field DecalMesh DecalMeshInstance
--- @field LightEnvironment LightEnvironmentInstance
--- @field BaseVertexOffset integer
--- @field NextVisibleSkin MeshInstance
--- @field IsDisabledByDebugger boolean
--- @field UserLighting table
--- @field PolygonRendererList any

--- @param src MeshInstance?
function INSTANCE:Renegade_Mesh( src )
    --- ()
    if src == nil then
        self.Model = nil
        self.DecalMesh = nil
        self.LightEnvironment = nil
        self.BaseVertexOffset = 0
        self.NextVisibleSkin = nil
        self.IsDisabledByDebugger = false
        self.UserLighting = nil

    --- ( src: MeshInstance )
    else
        typecheck.AssertArgType( self.Class, 2, src, "MeshInstance" )

        renderObjectClass.Instance.Renegade_RenderObject( self, src )
        self.Model = nil
        self.DecalMesh = nil
        self.LightEnvironment = nil
        self.BaseVertexOffset = src.BaseVertexOffset
        self.NextVisibleSkin = nil
        self.IsDisabledByDebugger = false
        self.UserLighting = nil
    end
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

--- @return string
function INSTANCE:GetName()
    return self.Model:GetName()
end

--- @param name string
function INSTANCE:SetName( name )
    self.Model:SetName( name )
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

--- @return SphereInstance
function INSTANCE:GetObjectSpaceBoundingSphere()
    if self.Model ~= nil then
        return self.Model:GetBoundingSphere()
    else
        return sphereClass.New( Vector( 0, 0, 0 ), 1.0 )
    end
end

--- @return AABoxInstance
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

--- "Creates a mesh out of a mesh chunk in a .w3d file"
--- @param cload ChunkLoadInstance
--- @return integer
function INSTANCE:LoadW3d( cload )
    --- @type Vector, Vector
    local boxMin, boxMax

    --- "Make sure this mesh is 'empty'"
    self:Free()

    -- "Create empty MaterialInfo and Model"
    self.Model = meshModelClass.New()
    if self.Model == nil then
        section.Error( "MeshClass::Load - Failed to allocate model" )
        return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
    end

    -- "Create and read in the model..."
    if self.Model:LoadW3d( cload ) ~= wW3dErrorTypeEnum.WW3D_ERROR_OK then
        self:Free()
        return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
    end

    -- Omitted remainder of function

    return wW3dErrorTypeEnum.WW3D_ERROR_OK
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
    self.Model = nil
    self.DecalMesh = nil
    self.UserLighting = nil
end

function INSTANCE:AddDependenciesToList()
    typecheck.NotImplementedError()
end

function INSTANCE:UpdateCachedBoundingVolumes()
    self.CachedBoundingSphere = self:GetObjectSpaceBoundingSphere()

    self.CachedBoundingSphere.Center = self:GetTransform() * self.CachedBoundingSphere.Center

    -- "
    -- If we are camera-aligned or -oriented, we don't know which way we are facing at this point,
    -- so the box we return needs to contain the sphere.  Otherwise do the normal computation.
    -- "
    if self.Model:GetFlag( flagsTypeEnum.ALIGNED ) or self.Model:GetFlag( flagsTypeEnum.ORIENTED ) then
        self.CachedBoundingBox.Center = self.CachedBoundingSphere.Center
        self.CachedBoundingBox.Extent:SetUnpacked( self.CachedBoundingSphere.Radius, self.CachedBoundingSphere.Radius, self.CachedBoundingSphere.Radius )
    else
        self.CachedBoundingBox = self:GetObjectSpaceBoundingBox()
        self.CachedBoundingBox:Transform( self:GetTransform() )
    end

    self:ValidateCachedBoundingVolumes()
end

function INSTANCE:PeekFvfCategoryContainer()
    typecheck.NotImplementedError()
end

