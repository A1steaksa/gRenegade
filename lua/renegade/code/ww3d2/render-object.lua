-- Based on RenderObjClass within Code/ww3d2/rendobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class RenderObjectClass
--- @field instance RenderObjectInstance The metatable used by RenderObjectInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "RenderObjectClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class RenderObjectInstance
--- @field Static RenderObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_RenderObject" )
INSTANCE.Class = "RenderObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsRenderObject = true


--#region Exported Enums
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
    local collisionTypesClass = CNC.Import( "code/ww3d2/collision-types.lua" )
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class RenderObjectClass

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
        collisionTypesClass.COLLISION_TYPE_ALL,
        STATIC.IS_NOT_HIDDEN,
        STATIC.IS_NOT_ANIMATION_HIDDEN
    )

    --- Creates a new RenderObjectInstance
    --- @vararg any
    --- @return RenderObjectInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_RenderObject", ... )
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

--- Constructs a new RenderObjectInstance
--- @param src RenderObjectInstance? Another RenderObjectInstance to copy
function INSTANCE:Renegade_RenderObject( src )

    -- ( src: RenderObjectInstance )
    if src then
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


    --- @param m Matrix3dInstance
    function INSTANCE:SetTransform( m )
        self.Transform = m
        self._IsTransformIdentity = STATIC.CheckIsTransformIdentity( m )
        self:InvalidateCachedBoundingVolumes()
    end

    --- @param v Vector
    function INSTANCE:SetPosition( v )
        self.Transform:SetTranslation( v )
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

--[[ Render Object Interface - Attributes, Options, Properties, etc. ]] do

    function INSTANCE:AreSubObjectTransformsDirty()
        return bit.band( self.Bits, STATIC.SUBOBJ_TRANSFORMS_DIRTY ) ~= 0
    end
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


