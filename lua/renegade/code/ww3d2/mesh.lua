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

	--- @type MeshClass
	local meshClass = CNC.Import( "code/ww3d2/mesh.lua" )

	--- @type VertexMaterialClass
	local vertexMaterialClass = CNC.Import( "code/ww3d2/vertex-material.lua" )

	--- @type AABoxClass
	local aABoxClass = CNC.Import( "code/wwmath/aabox.lua" )

	--- @type WW3dClass
	local wW3dClass = CNC.Import( "code/ww3d2/ww3d.lua" )

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )

	--- @type CollisionMathClass
	local collisionMathClass = CNC.Import( "code/wwmath/collision-math.lua" )

	--- @type UnitConversionLib
	local unitConversionLib = CNC.Import( "sh_unit-conversion.lua" )

	--- @type RenderInfoClass
	local renderInfoClass = CNC.Import( "code/ww3d2/render-info.lua" )

	--- @type ShaderClass
	local shaderClass = CNC.Import( "code/ww3d2/shader.lua" )
--#endregion

--#region Imported Enums

	local wW3dErrorTypeEnum = wW3dErrorTypes.WW3D_ERROR_TYPE
	local meshGeometryFlagsTypeEnum = meshGeometryClass.MESH_GEOMETRY_FLAGS_TYPE
	local overlapTypeEnum = collisionMathClass.OVERLAP_TYPE
	local renderInfoOverrideFlagsEnum = renderInfoClass.RENDER_INFO_OVERRIDE_FLAGS
	local srcBlendFuncEnum = shaderClass.SRC_BLEND_FUNC
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
        renderObjectClass.Instance.Renegade_RenderObject( self )

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


        self.Model = src.Model
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

--- @return MeshInstance
function INSTANCE:Clone()
    return meshClass.New( self )
end

function INSTANCE:ClassId()
    typecheck.NotImplementedError()
end

--- @return string?
function INSTANCE:GetName()
    return self.Model:GetName()
end

--- @param name string
function INSTANCE:SetName( name )
    self.Model:SetName( name )
end

--- @return integer "...the number of polys (tris) in this mesh"
function INSTANCE:GetNumPolys()
    if self.Model then
        local numPasses = self.Model:GetPassCount()
        assert( numPasses > 0, "Numpasses is too low: '" .. numPasses .. "'" )
        local polyCount = self.Model:GetPolygonCount()
        return numPasses * polyCount
    else
        return 0
    end
end

--- "Renders this mesh"
--- @param renderInfo RenderInfoInstance
--- @param transform VMatrix
--- @param bones VMatrix[]
function INSTANCE:Render( renderInfo, transform, bones)
    if self:IsNotHiddenAtAll() == false then
        return
    end

    -- "If static sort lists are enabled and this mesh has a sort level, put it on the list instead of rendering it."
    local sortLevel = self.Model:GetSortLevel()

    if wW3dClass.AreStaticSortListsEnabled() and sortLevel ~= w3dFileIds.SORT_LEVEL_NONE then
        wW3dClass.AddToStaticSortList( self, sortLevel )

        -- "Plug in lighting so that when this mesh gets later"
        self:SetLightingEnvironment( renderInfo.LightEnvironment )
    else

        -- "Plug in the lighting environment unless we arrived here as part of the static sorting system being flushed"
        if wW3dClass.AreStaticSortListsEnabled() then
            self:SetLightingEnvironment( renderInfo.LightEnvironment )
        end

        local frustum = renderInfo.Camera:GetFrustum()

        local isSkinned = tobool( self.Model:GetFlag( meshGeometryFlagsTypeEnum.SKIN ) )
        local isOnScreen = collisionMathClass.OverlapTest( frustum, self:GetBoundingBox() ) ~= overlapTypeEnum.OUTSIDE
        if( isSkinned or isOnScreen ) then
            local renderedSomething = false

            -- "If this mesh model has never been rendered, we need to generate the DX8 datastructures"
            if self.Model.SourceMesh == nil then
                self.Model:RegisterForRendering()
                self.Model:CreateSourceMesh()
                -- Omitted registering mesh type with TheDX8MeshRenderer
            end

            -- Look up the FVF container that this mesh is in
            -- Omitted FVF container lookup

            -- "
            -- Check if we should render the base passes.
            -- One special case here:
            -- If the mesh is translucent (alpha) and the base passes are disabled but we are rendering a shadow,
            -- we go ahead and render the base pass.
            -- This is an ugly way to get our tree shadows and other alpha textured shadows to work.
            -- "
            local renderBasePasses = ( bit.band( renderInfo:CurrentOverrideFlags(), renderInfoOverrideFlagsEnum.RINFO_OVERRIDE_ADDITIONAL_PASSES_ONLY ) == 0 )
            local isAlpha = (
                   self.Model:GetSingleShader():GetAlphaTest() == shaderClass.ALPHA_TEST.Enable
                or self.Model:GetSingleShader():GetSrcBlendFunc() == srcBlendFuncEnum.SrcAlpha
            )

            if (
                tobool( bit.band( renderInfo:CurrentOverrideFlags(), renderInfoOverrideFlagsEnum.RINFO_OVERRIDE_SHADOW_RENDERING ) )
                and ( isAlpha == true )
            ) then
                renderBasePasses = true
            end

            if renderBasePasses then
                -- "Link each polygon renderer for this mesh into the visible list"
                -- Omitted polygon renderers with the visible list

                if isSkinned then
                    self.Model:RenderSourceMesh( bones )
                else
                    self.Model:RenderSourceMesh( transform )
                end

                renderedSomething = true
            end

            -- "If the rendering context specifies procedural material passes, register them for rendering"
            for passNumber = 1, renderInfo:AdditionalPassCount() do
                local materialPass = renderInfo:PeekAdditionalPass( passNumber )

                if not self:IsTranslucent() or materialPass:IsEnabledOnTranslucentMeshes() then

                    -- "  
                    -- If the base pass for this mesh has been disabled, we have to make sure the procedural material pass
                    -- is rendered after everything else has rendered  
                    -- "
                    if tobool( bit.band( renderInfo:CurrentOverrideFlags(), renderInfoOverrideFlagsEnum.RINFO_OVERRIDE_ADDITIONAL_PASSES_ONLY  ) ) then
                        typecheck.NotImplementedError()
                    else
                        typecheck.NotImplementedError()
                    end

                    renderedSomething = true
                end
            end

            -- "If we have a decal mesh, link it into the mesh rendering system"
            if ( self.DecalMesh ~= nil ) and ( bit.band( renderInfo:CurrentOverrideFlags(), renderInfoOverrideFlagsEnum.RINFO_OVERRIDE_ADDITIONAL_PASSES_ONLY ) == 0 ) then
                typecheck.NotImplementedError()
            end
        end
    end
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

--- @param sphere SphereInstance
function INSTANCE:GetObjectSpaceBoundingSphere( sphere )
    if self.Model ~= nil then
        self.Model:GetBoundingSphere( sphere )
    else
        sphere.Center:SetUnpacked( 0, 0, 0 )
        sphere.Radius = 1.0
    end
end

--- "Returns the obj-space bounding box"
--- @param box AABoxInstance
function INSTANCE:GetObjectSpaceBoundingBox( box )
    if self.Model then
        self.Model:GetBoundingBox( box )
    else
        box:Init( Vector( 0, 0, 0 ), Vector( 1, 1, 1 ) )
    end
end

function INSTANCE:Scale()
    typecheck.NotImplementedError()
end

--- "Returns a pointer to the material info"
--- @return MaterialInfoInstance?
function INSTANCE:GetMaterialInfo()
    if self.Model then
        if self.Model.MaterialInfo then
            return self.Model.MaterialInfo
        end
    end
    return nil
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

--- "User access to the mesh model"
--- @return MeshModelInstance
function INSTANCE:GetModel()
    return self.Model
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

--- @param lightEnvironment LightEnvironmentInstance
function INSTANCE:SetLightingEnvironment( lightEnvironment )
    self.LightEnvironment = lightEnvironment
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
    self:GetObjectSpaceBoundingSphere( self.CachedBoundingSphere )

    self.CachedBoundingSphere.Center = self:GetTransform() * self.CachedBoundingSphere.Center

    -- "
    -- If we are camera-aligned or -oriented, we don't know which way we are facing at this point,
    -- so the box we return needs to contain the sphere.  Otherwise do the normal computation.
    -- "
    if self.Model:GetFlag( meshGeometryFlagsTypeEnum.ALIGNED ) or self.Model:GetFlag( meshGeometryFlagsTypeEnum.ORIENTED ) then
        self.CachedBoundingBox.Center = self.CachedBoundingSphere.Center
        self.CachedBoundingBox.Extent:SetUnpacked( self.CachedBoundingSphere.Radius, self.CachedBoundingSphere.Radius, self.CachedBoundingSphere.Radius )
    else
        self:GetObjectSpaceBoundingBox( self.CachedBoundingBox )
        self.CachedBoundingBox:Transform( self:GetTransform() )
    end

    self:ValidateCachedBoundingVolumes()
end

function INSTANCE:PeekFvfCategoryContainer()
    typecheck.NotImplementedError()
end

