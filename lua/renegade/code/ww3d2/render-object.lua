-- Based on RenderObjClass within Code/ww3d2/rendobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

--- @class RenderObjectClass : PersistClass
--- @field Instance RenderObjectInstance The metatable used by RenderObjectInstance
local STATIC = CNC.CreateExport( persistClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "RenderObjectClass"

--- @class RenderObjectInstance : PersistInstance
--- @field Static RenderObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_RenderObject : Renegade_Persist" )
INSTANCE.Class = "RenderObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsRenderObject = true

--#region Exported Enums

    --- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- "  
    --- Note:  It is very important that these values NEVER CHANGE.  
    --- That means when adding a new class id, it should be added to the end of the enum.  
    --- "  
    --- @enum RenderObjectClassId
    STATIC.RENDER_OBJECT_CLASS_ID = {
        CLASSID_UNKNOWN	         = enumBuilder:Set( 0xFFFFFFFF ),
        CLASSID_MESH		     = enumBuilder:Set( 0 ),
        CLASSID_HMODEL           = enumBuilder:Next(),
        CLASSID_DISTLOD          = enumBuilder:Next(),
        CLASSID_PREDLODGROUP     = enumBuilder:Next(),
        CLASSID_TILEMAP          = enumBuilder:Next(),
        CLASSID_IMAGE3D          = enumBuilder:Next(), -- "Obsolete"
        CLASSID_LINE3D           = enumBuilder:Next(),
        CLASSID_BITMAP2D         = enumBuilder:Next(), -- "Obsolete"
        CLASSID_CAMERA           = enumBuilder:Next(),
        CLASSID_DYNAMESH         = enumBuilder:Next(),
        CLASSID_DYNASCREENMESH   = enumBuilder:Next(),
        CLASSID_TEXTDRAW         = enumBuilder:Next(),
        CLASSID_FOG              = enumBuilder:Next(),
        CLASSID_LAYERFOG	     = enumBuilder:Next(),
        CLASSID_LIGHT            = enumBuilder:Next(),
        CLASSID_PARTICLEEMITTER  = enumBuilder:Next(),
        CLASSID_PARTICLEBUFFER   = enumBuilder:Next(),
        CLASSID_SCREENPOINTGROUP = enumBuilder:Next(),
        CLASSID_VIEWPOINTGROUP   = enumBuilder:Next(),
        CLASSID_WORLDPOINTGROUP  = enumBuilder:Next(),
        CLASSID_TEXT2D           = enumBuilder:Next(),
        CLASSID_TEXT3D           = enumBuilder:Next(),
        CLASSID_NULL             = enumBuilder:Next(),
        CLASSID_COLLECTION       = enumBuilder:Next(),
        CLASSID_FLARE            = enumBuilder:Next(),
        CLASSID_HLOD             = enumBuilder:Next(),
        CLASSID_AABOX            = enumBuilder:Next(),
        CLASSID_OBBOX            = enumBuilder:Next(),
        CLASSID_SEGLINE          = enumBuilder:Next(),
        CLASSID_SPHERE           = enumBuilder:Next(),
        CLASSID_RING             = enumBuilder:Next(),
        CLASSID_BOUNDFOG         = enumBuilder:Next(),
        CLASSID_DAZZLE           = enumBuilder:Next(),
        CLASSID_SOUND            = enumBuilder:Next(),
        CLASSID_SEGLINETRAIL     = enumBuilder:Next(),
        CLASSID_LAND             = enumBuilder:Next(),
        CLASSID_RENEGADE_TERRAIN = enumBuilder:Next(),
        CLASSID_LAST	         = enumBuilder:Set( 0x0000FFFF )
    }
    local renderObjectClassIdEnum = STATIC.RENDER_OBJECT_CLASS_ID

--#endregion

--#region Imports

	--- @type SphereClass
	local sphereClass = CNC.Import( "code/wwmath/sphere.lua" )

	--- @type WW3dClass
	local wW3dClass = CNC.Import( "code/ww3d2/ww3d.lua" )

	--- @type AABoxClass
	local aABoxClass = CNC.Import( "code/wwmath/aabox.lua" )

	--- @type Matrix3dClass
	local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )

	--- @type CollisionTypeClass
	local collisionTypeClass = CNC.Import( "code/ww3d2/collision-types.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class RenderObjectClass
    --- @field AtMinLod any
    --- @field AtMaxLod any

    STATIC.COLLISION_TYPE_MASK 	    = 0x000000FF
    STATIC.IS_VISIBLE 				= 0x00000100
    STATIC.IS_NOT_HIDDEN 			= 0x00000200
    STATIC.IS_NOT_ANIMATION_HIDDEN  = 0x00000400
    STATIC.IS_FORCE_VISIBLE 		= 0x00000800
    STATIC.BOUNDING_VOLUMES_VALID 	= 0x00002000
    STATIC.IS_TRANSLUCENT 			= 0x00004000 -- "Is additive or alpha blended on any poly"
    STATIC.SUBOBJS_MATCH_LOD 		= 0x00010000 -- "Force sub-objects to have same LOD level"
    STATIC.SUBOBJ_TRANSFORMS_DIRTY  = 0x00020000 -- "My sub-objects need me to update their transform"
    STATIC.HAS_USER_LIGHTING 		= 0x00040000 -- "The user has installed a static lighting solve."

    STATIC.IS_REALLY_VISIBLE = bit.bor(
        STATIC.IS_VISIBLE,
        STATIC.IS_NOT_HIDDEN,
        STATIC.IS_NOT_ANIMATION_HIDDEN
    )

    STATIC.IS_NOT_HIDDEN_AT_ALL	= bit.bor(
        STATIC.IS_NOT_HIDDEN,
        STATIC.IS_NOT_ANIMATION_HIDDEN
    )

    STATIC.DEFAULT_BITS = bit.bor(
        collisionTypeClass.COLLISION_TYPE_ALL,
        STATIC.IS_NOT_HIDDEN,
        STATIC.IS_NOT_ANIMATION_HIDDEN
    )

    --- Creates a new RenderObjectInstance
    --- @param src RenderObjectInstance? Another RenderObjectInstance to copy
    --- @return RenderObjectInstance
    function STATIC.New( src )
        return robustclass.New( "Renegade_RenderObject", src )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) RenderObjectInstance, `false` otherwise
    function STATIC.IsRenderObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsRenderObject and true or false
    end

    typecheck.RegisterType( "RenderObjectInstance", STATIC.IsRenderObject )

    --- @param m Matrix3dInstance
    --- @return boolean
    function STATIC.CheckIsTransformIdentity( m )
        local row = m.Row
        return (
            row[1][1] == 1 and
            row[1][2] == 0 and
            row[1][3] == 0 and
            row[1][4] == 0 and

            row[2][1] == 0 and
            row[2][2] == 1 and
            row[2][3] == 0 and
            row[2][4] == 0 and

            row[3][1] == 0 and
            row[3][2] == 0 and
            row[3][3] == 1 and
            row[3][4] == 0
        )
    end
end


--- @class RenderObjectInstance
--- @field Bits integer
--- @field Transform Matrix3dInstance
--- @field CachedBoundingSphere SphereInstance
--- @field CachedBoundingBox AABoxInstance
--- @field NativeScreenSize number "The screen size at which the object was designed to be viewed (used in texture resizing)"
--- @field _IsTransformIdentity boolean
--- @field Scene SceneInstance
--- @field Container RenderObjectInstance
--- @field UserData any
--- @field SourceModelPath string The Source engine `.mdl` file 

--- Constructs a new RenderObjectInstance
--- @param src RenderObjectInstance? Another RenderObjectInstance to copy
function INSTANCE:Renegade_RenderObject( src )

    -- ( src: RenderObjectInstance )
    if src then
        persistClass.Instance.Renegade_Persist( self )

        self.Bits = src.Bits
        self.Transform = src.Transform
        self.NativeScreenSize = src.NativeScreenSize
        self.Scene = nil
        self.Container = nil
        self.UserData = nil
        self.CachedBoundingSphere = src.CachedBoundingSphere
        self.CachedBoundingBox = src.CachedBoundingBox
        self._IsTransformIdentity = src._IsTransformIdentity

        -- "
        -- Even though we're copying an object which might be in a scene
        -- this copy won't be so I'm clearning the scene pointer, same logic
        -- follows for things like the Container pointer.
        -- "

    -- ()
    else
        persistClass.Instance.Renegade_Persist( self )

        self.Bits = STATIC.DEFAULT_BITS
        self.Transform = matrix3dClass.New( true )
        self.NativeScreenSize = wW3dClass.GetDefaultNativeScreenSize()
        self.Scene = nil
        self.Container = nil
        self.UserData = nil
        self.CachedBoundingSphere = sphereClass.New( Vector( 0, 0, 0 ), 1.0 )
        self.CachedBoundingBox = aABoxClass.New( Vector( 0, 0, 0 ), Vector( 1, 1, 1 ) )
    end
end

function INSTANCE:_Renegade_RenderObject()
    typecheck.NotImplementedError()
end


--[[ Render Object Interface - Cloning and Identification ]] do

    function INSTANCE:Clone()
        typecheck.NotImplementedError()
    end

    --- @return integer
    function INSTANCE:ClassId()
        return STATIC.RENDER_OBJECT_CLASS_ID.CLASSID_UNKNOWN
    end

    --- @return string
    function INSTANCE:GetName()
        return "UNNAMED"
    end

    function INSTANCE:SetName()
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetBaseModelName()
        typecheck.NotImplementedError()
    end

    function INSTANCE:SetBaseModelName()
        typecheck.NotImplementedError()
    end

    --- @return integer
    function INSTANCE:GetNumPolys()
        return 0
    end
end


function INSTANCE:Render()
    typecheck.NotImplementedError()
end

function INSTANCE:SpecialRender()
    typecheck.NotImplementedError()
end

function INSTANCE:OnFrameUpdate()
    typecheck.NotImplementedError()
end

function INSTANCE:Restart()
    typecheck.NotImplementedError()
end

function INSTANCE:Add()
    typecheck.NotImplementedError()
end

function INSTANCE:Remove()
    typecheck.NotImplementedError()
end

function INSTANCE:GetScene()
    typecheck.NotImplementedError()
end

function INSTANCE:PeekScene()
    typecheck.NotImplementedError()
end

function INSTANCE:SetContainer()
    typecheck.NotImplementedError()
end


--[[ Render Object Interface - "Scene Graph" ]] do

    --- @return RenderObjectInstance
    function INSTANCE:GetContainer()
        return self.Container
    end

    --- "If the transform is dirty, this causes it to be re-ca"
    function INSTANCE:ValidateTransform()
        -- "Recurse up the tree to see if any of my parents are saying that their sub-object transforms are dirty"
        local container = self:GetContainer()
        local dirty = false
        if container then
            dirty = container:AreSubObjectTransformsDirty()

            while container:GetContainer() ~= nil do
                dirty = dirty or container:AreSubObjectTransformsDirty()
                container = container:GetContainer()
            end

            -- "If the transforms are dirty, update them"
            if dirty then
                container:UpdateSubObjectTransforms()
            end
        end

        if dirty then
            self._IsTransformIdentity = STATIC.CheckIsTransformIdentity( self.Transform )
        end
    end

    --- @param matrix Matrix3dInstance
    function INSTANCE:SetTransform( matrix )
        self.Transform = matrix
        self._IsTransformIdentity = STATIC.CheckIsTransformIdentity( matrix )
        self:InvalidateCachedBoundingVolumes()
    end

    --- @param newPos Vector
    function INSTANCE:SetPosition( newPos )
        self.Transform:SetTranslation( newPos )
        self._IsTransformIdentity = STATIC.CheckIsTransformIdentity( self.Transform )
        self:InvalidateCachedBoundingVolumes()
    end

    --- @return Matrix3dInstance transform, boolean isTransformIdentity
    function INSTANCE:GetTransform()
        self:ValidateTransform()
        return self.Transform, self._IsTransformIdentity
    end

    --- "Warning: Be sure to call this function only if the transform is known to be valid!"
    --- @return Matrix3dInstance transform, boolean isTransformIdentity
    function INSTANCE:GetTransformNoValidityCheck()
        return self.Transform, self._IsTransformIdentity
    end

    --- @return boolean
    function INSTANCE:IsTransformIdentity()
        self:ValidateTransform()
        return self._IsTransformIdentity
    end

    --- "Warning: Be sure to call this function only if the transform is known to be valid!"
    function INSTANCE:IsTransformIdentityNoValidityCheck()
        return self._IsTransformIdentity
    end

    --- @return Vector
    function INSTANCE:GetPosition()
        return self.Transform:GetTranslation()
    end

    -- "Re-evaluate the transforms [of] my sub-objects"  
    -- "  
    -- The default implementation is empty, derived classes which have sub-objects should
    -- implement it to update the transforms of their sub-objects  
    -- "  
    -- "This is public only so objects can recursively call this on their sub-objects"
    function INSTANCE:UpdateSubObjectTransforms()
    end
end

function INSTANCE:NotifyAdded()
    typecheck.NotImplementedError()
end

function INSTANCE:NotifyRemoved()
    typecheck.NotImplementedError()
end

function INSTANCE:GetNumSubObjects()
    typecheck.NotImplementedError()
end

--- @param index integer
--- @return RenderObjectInstance?
function INSTANCE:GetSubObject( index )
    return nil
end

function INSTANCE:AddSubObject()
    typecheck.NotImplementedError()
end

function INSTANCE:RemoveSubObject()
    typecheck.NotImplementedError()
end

--- @param name string
--- @return RenderObjectInstance
function INSTANCE:GetSubObjectByName( name )
    typecheck.NotImplementedError()
end

function INSTANCE:GetNumSubObjectsOnBone()
    typecheck.NotImplementedError()
end

function INSTANCE:GetSubObjectOnBone()
    typecheck.NotImplementedError()
end

function INSTANCE:GetSubObjectBoneIndex()
    typecheck.NotImplementedError()
end

function INSTANCE:AddSubObjectToBone()
    typecheck.NotImplementedError()
end

function INSTANCE:RemoveSubObjectsFromBone()
    typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
    typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
    typecheck.NotImplementedError()
end

function INSTANCE:PeekAnimation()
    typecheck.NotImplementedError()
end

function INSTANCE:GetNumBones()
    typecheck.NotImplementedError()
end

function INSTANCE:GetBoneName()
    typecheck.NotImplementedError()
end

function INSTANCE:GetBoneIndex()
    typecheck.NotImplementedError()
end

function INSTANCE:GetBoneTransform()
    typecheck.NotImplementedError()
end

function INSTANCE:CaptureBone()
    typecheck.NotImplementedError()
end

function INSTANCE:ReleaseBone()
    typecheck.NotImplementedError()
end

function INSTANCE:IsBoneCaptured()
    typecheck.NotImplementedError()
end

function INSTANCE:ControlBone()
    typecheck.NotImplementedError()
end

function INSTANCE:GetHTree()
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

function INSTANCE:Intersect()
    typecheck.NotImplementedError()
end

function INSTANCE:IntersectSphere()
    typecheck.NotImplementedError()
end

function INSTANCE:IntersectSphereQuick()
    typecheck.NotImplementedError()
end

function INSTANCE:GetBoundingSphere()
    if bit.band( self.Bits, STATIC.BOUNDING_VOLUMES_VALID ) ~= 1 then
        self:UpdateCachedBoundingVolumes()
    end
    return self.CachedBoundingSphere
end

--- @return AABoxInstance
function INSTANCE:GetBoundingBox()
    if bit.band( self.Bits, STATIC.BOUNDING_VOLUMES_VALID ) ~= 1 then
        self:UpdateCachedBoundingVolumes()
    end
    return self.CachedBoundingBox
end

--- "Default collision sphere"
--- @return SphereInstance
function INSTANCE:GetObjectSpaceBoundingSphere()
    return sphereClass.New(
        Vector( 0, 0, 0 ),
        1.0
    )
end

--- "Default collision box."
--- @return AABoxInstance
function INSTANCE:GetObjectSpaceBoundingBox()
    return aABoxClass.New(
        Vector( 0, 0, 0 ),
        Vector( 0, 0, 0 )
    )
end

function INSTANCE:UpdateObjectSpaceBoundingVolumes()
    typecheck.NotImplementedError()
end

function INSTANCE:PrepareLod()
    typecheck.NotImplementedError()
end

function INSTANCE:RecalculateStaticLodFactors()
    typecheck.NotImplementedError()
end

function INSTANCE:IncrementLod()
    typecheck.NotImplementedError()
end

function INSTANCE:DecrementLod()
    typecheck.NotImplementedError()
end

function INSTANCE:GetCost()
    typecheck.NotImplementedError()
end

function INSTANCE:GetValue()
    typecheck.NotImplementedError()
end

function INSTANCE:GetPostIncrementValue()
    typecheck.NotImplementedError()
end

function INSTANCE:SetLodLevel()
    typecheck.NotImplementedError()
end

function INSTANCE:GetLodLevel()
    typecheck.NotImplementedError()
end

function INSTANCE:GetLodCount()
    typecheck.NotImplementedError()
end

function INSTANCE:SetLodBias()
    typecheck.NotImplementedError()
end

function INSTANCE:CalculateCostValueArrays()
    typecheck.NotImplementedError()
end

function INSTANCE:GetCurrentLod()
    typecheck.NotImplementedError()
end

function INSTANCE:BuildDependencyList()
    typecheck.NotImplementedError()
end

function INSTANCE:BuildTextureList()
    typecheck.NotImplementedError()
end

function INSTANCE:CreateDecal()
    typecheck.NotImplementedError()
end

function INSTANCE:DeleteDecal()
    typecheck.NotImplementedError()
end

function INSTANCE:GetMaterialInfo()
    typecheck.NotImplementedError()
end

function INSTANCE:SetUserData()
    typecheck.NotImplementedError()
end

function INSTANCE:GetUserData()
    typecheck.NotImplementedError()
end

function INSTANCE:GetNumSnapPoints()
    typecheck.NotImplementedError()
end

function INSTANCE:GetSnapPoint()
    typecheck.NotImplementedError()
end

function INSTANCE:GetScreenSize()
    typecheck.NotImplementedError()
end

function INSTANCE:Scale()
    typecheck.NotImplementedError()
end

function INSTANCE:GetSortLevel()
    typecheck.NotImplementedError()
end

function INSTANCE:SetSortLevel()
    typecheck.NotImplementedError()
end

function INSTANCE:IsReallyVisible()
    typecheck.NotImplementedError()
end

function INSTANCE:IsNotHiddenAtAll()
    typecheck.NotImplementedError()
end

function INSTANCE:IsVisible()
    typecheck.NotImplementedError()
end

function INSTANCE:SetVisible()
    typecheck.NotImplementedError()
end

function INSTANCE:IsHidden()
    typecheck.NotImplementedError()
end

function INSTANCE:SetHidden()
    typecheck.NotImplementedError()
end

function INSTANCE:IsAnimationHidden()
    typecheck.NotImplementedError()
end

function INSTANCE:SetAnimationHidden()
    typecheck.NotImplementedError()
end

function INSTANCE:IsForceVisible()
    typecheck.NotImplementedError()
end

function INSTANCE:SetForceVisible()
    typecheck.NotImplementedError()
end

function INSTANCE:HasUserLighting()
    typecheck.NotImplementedError()
end

function INSTANCE:SetHasUserLighting()
    typecheck.NotImplementedError()
end

function INSTANCE:IsTranslucent()
    typecheck.NotImplementedError()
end

function INSTANCE:SetTranslucent()
    typecheck.NotImplementedError()
end

function INSTANCE:GetCollisionType()
    typecheck.NotImplementedError()
end

function INSTANCE:SetCollisionType()
    typecheck.NotImplementedError()
end

function INSTANCE:IsComplete()
    typecheck.NotImplementedError()
end

function INSTANCE:IsInScene()
    typecheck.NotImplementedError()
end

function INSTANCE:GetNativeScreenSize()
    typecheck.NotImplementedError()
end

function INSTANCE:SetNativeScreenSize()
    typecheck.NotImplementedError()
end

function INSTANCE:SetSubObjectsMatchLod()
    typecheck.NotImplementedError()
end

function INSTANCE:IsSubObjectsMatchLodEnabled()
    typecheck.NotImplementedError()
end

function INSTANCE:SetSubObjectTransformsDirty()
    typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:AreSubObjectTransformsDirty()
    return bit.band( self.Bits, STATIC.SUBOBJ_TRANSFORMS_DIRTY ) ~= 0
end

function INSTANCE:GetFactory()
    typecheck.NotImplementedError()
end

function INSTANCE:Save()
    typecheck.NotImplementedError()
end

function INSTANCE:Load()
    typecheck.NotImplementedError()
end

function INSTANCE:SaveUserLighting()
    typecheck.NotImplementedError()
end

function INSTANCE:LoadUserLighting()
    typecheck.NotImplementedError()
end

function INSTANCE:AddDependenciesToList()
    typecheck.NotImplementedError()
end

--- "default collision sphere."
function INSTANCE:UpdateCachedBoundingVolumes()
    self.CachedBoundingBox = self:GetObjectSpaceBoundingBox()
    self.CachedBoundingSphere = self:GetObjectSpaceBoundingSphere()

    local transform = self:GetTransform()
    self.CachedBoundingSphere.Center = transform * self.CachedBoundingSphere.Center
    self.CachedBoundingBox:Transform( transform )

    self:ValidateCachedBoundingVolumes()
end

function INSTANCE:UpdateSubObjectBits()
    typecheck.NotImplementedError()
end

function INSTANCE:BoundingVolumesValid()
    return bit.band( self.Bits, STATIC.BOUNDING_VOLUMES_VALID ) ~= 0
end

function INSTANCE:InvalidateCachedBoundingVolumes()
    self.Bits = bit.band( self.Bits, bit.bnot( STATIC.BOUNDING_VOLUMES_VALID ) )
end

function INSTANCE:ValidateCachedBoundingVolumes()
    self.Bits = bit.bor( self.Bits, STATIC.BOUNDING_VOLUMES_VALID )
end


function INSTANCE:SaveSubObjectUserLighting()
    typecheck.NotImplementedError()
end

function INSTANCE:LoadSubObjectUserLighting()
    typecheck.NotImplementedError()
end
