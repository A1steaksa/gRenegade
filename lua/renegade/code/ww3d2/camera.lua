-- Based on CameraClass within Code/ww3d2/camera.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type RenderObjectClass
local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

--- @class CameraClass : RenderObjectClass
--- @field instance CameraInstance The metatable used by CameraInstance
local STATIC = CNC.CreateExport( renderObjectClass )
STATIC.Class = "CameraClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class CameraInstance : RenderObjectInstance
--- @field Static CameraClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Camera : Renegade_RenderObject" )
INSTANCE.Class = "CameraInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsCamera = true


--#region Imports

    --- @type OBBoxClass
    local oBBoxClass = CNC.Import( "code/wwmath/obbox.lua" )

    --- @type CollisionMathClass
    local collisionMathClass = CNC.Import( "code/wwmath/collision-math.lua" )

    --- @type ViewportClass
    local viewportClass = CNC.Import( "code/ww3d2/viewport.lua" )

    --- @type FrustumClass
    local frustumClass = CNC.Import( "code/wwmath/frustum.lua" )

    --- @type Matrix3dClass
    local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )

    --- @type WWMathClass
    local wWMathClass = CNC.Import( "code/wwmath/wwmath.lua" )

    --- @type Matrix4Class
    local matrix4Class = CNC.Import( "code/wwmath/matrix4.lua" )

    --- @type CameraBridgeClass
    local cameraBridge = CNC.Import( "bridges/sh_camera.lua" )
--#endregion


--#region Enums

    --- @enum ProjectionResultType
    STATIC.PROJECTION_RESULT_TYPE = {
        INSIDE_FRUSTUM    = 0,
        OUTSIDE_FRUSTUM   = 1,
        OUTSIDE_NEAR_CLIP = 2,
        OUTSIDE_FAR_CLIP  = 3,
    }
    local projectionResultType = STATIC.PROJECTION_RESULT_TYPE

    --- @enum ProjectionType
    STATIC.PROJECTION_TYPE = {
        PERSPECTIVE = 0,
        ORTHO       = 1,
    }
    local projectionType = STATIC.PROJECTION_TYPE
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class CameraClass

    --- Creates a new CameraInstance
    --- @overload fun(): CameraInstance
    --- @overload fun( src: CameraInstance ): CameraInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Camera", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) CameraInstance, `false` otherwise
    function STATIC.IsCamera( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsCamera and true or false
    end

    typecheck.RegisterType( "CameraInstance", STATIC.IsCamera )
end


--- @class CameraInstance
--- @field Projection ProjectionType "Projection type, orthographic or perspective"
--- @field Viewport ViewportInstance "Pixel viewport to render into"
--- @field ViewPlane ViewportInstance "Corners of a slice through the frustum at z=1.0"
--- @field AspectRatio number "Aspect ratio of the camera, width / height"
--- @field ZNear number "Near clip plane distance"
--- @field ZFar number "Far clip plane distance"
--- @field ZBufferMin number "Smallest value we'll write into the z-Buffer (usually 0)"
--- @field ZBufferMax number "Largest value we'll write into the z-buffer (usually 1)"
--- @field FrustumValid boolean
--- @field Frustum FrustumInstance "World-space frustum and clip planes"
--- @field NearClipBBox OBBoxInstance "OBBox which bounds the near clip plane"
--- @field ProjectionTransform Matrix4Instance
--- @field CameraInverseTransform Matrix3dInstance


--- Constructs a new CameraInstance
--- @param src CameraInstance?
function INSTANCE:Renegade_Camera( src )

    -- ( src: CameraInstance )
    if src ~= nil then
        renderObjectClass.Instance.Renegade_RenderObject( self, src )

        self.Projection             = src.Projection
        self.Viewport               = src.Viewport
        self.ViewPlane              = src.ViewPlane
        self.ZNear                  = src.ZNear
        self.ZFar                   = src.ZFar
        self.FrustumValid           = src.FrustumValid
        self.Frustum                = src.Frustum
        self.NearClipBBox           = src.NearClipBBox
        self.ProjectionTransform    = src.ProjectionTransform
        self.CameraInverseTransform = src.CameraInverseTransform
        self.AspectRatio            = src.AspectRatio

        -- "Just being paraniod in case any parent class doesn't completely copy the entire state..."
        self.FrustumValid = false

    -- ()
    else
        renderObjectClass.Instance.Renegade_RenderObject( self )

        self.Projection = projectionType.PERSPECTIVE
        self.Viewport = viewportClass.New( Vector( 0, 0 ), Vector( 1, 1 ) ) -- "Pixel viewport to render into"
        self.AspectRatio = 4.0/3.0
        self.ZNear = 1.0 -- "Near clip plane distance"
        self.ZFar = 1000.0 -- "Far clip plane distance"
        self.ZBufferMin = 0.0 -- "Smallest value we'll write into the z-buffer"
        self.ZBufferMax = 1.0 -- "Largest value we'll write into the z-buffer"
        self.FrustumValid = false

        self.Frustum = frustumClass.New()
        self.ProjectionTransform = matrix4Class.New()
        self.ViewPlane = viewportClass.New()
        self.NearClipBBox = oBBoxClass.New()

        self:SetTransform( matrix3dClass.New( true ) )
        self:SetViewPlane( math.rad( 50.0 ) )
    end
end

function INSTANCE:DebugDraw()
    self.Frustum:DebugDraw()
end

--- @param box AABoxInstance
--- @return boolean
function INSTANCE:CullBox( box )
    -- If the box is outside of our frustum, it should be culled
    return collisionMathClass.OverlapTest( self:GetFrustum(), box ) == collisionMathClass.OVERLAP_TYPE.OUTSIDE
end

--- @return FrustumInstance
function INSTANCE:GetFrustum()
    self:UpdateFrustum()

    return self.Frustum
end

--[[ Render Object Interface - Scene Graph ]] do
    -- "Cameras cache their frustum description, this is invalidated whenever the transform/position is changed"

    --- @param m Matrix3dInstance
    function INSTANCE:SetTransform( m )
        renderObjectClass.Instance.SetTransform( self, m )
        self.FrustumValid = false
    end

    --- @param v Vector
    function INSTANCE:SetPosition( v )
        renderObjectClass.Instance.SetPosition( self, v )
        self.FrustumValid = false
    end
end


--- Originally part of RenderObjClass in Code/ww3d2/rendobj.h/cpp
--- Camera extends RenderObjClass but I don't feel like porting that right now
--- @return Matrix3dInstance
function INSTANCE:GetTransform()
    local viewSetup = cameraBridge.GetViewSetup() --[[@as ViewSetup]]

    local viewAng = viewSetup.angles

    local matrix = matrix3dClass.New( false )
    local row = matrix.Row
    local row1, row2, row3 = row[1], row[2], row[3]

    row1.x, row1.y, row1.z =  0,  0, -1
    row2.x, row2.y, row2.z = -1,  0,  0
    row3.x, row3.y, row3.z =  0,  1,  0

    row1.w = viewSetup.origin.x
    row2.w = viewSetup.origin.y
    row3.w = viewSetup.origin.z

    -- Rotate the camera's matrix, adjusting the Source angles to match Renegade's coordinate space
    matrix:RotateY( math.rad(  viewAng.yaw   ) )
    matrix:RotateX( math.rad( -viewAng.pitch ) )
    matrix:RotateZ( math.rad( -viewAng.roll  ) )

    return matrix
end

--- "Get the corners of the current view plane"
--- @return Vector viewPlaneMin, Vector viewPlaneMax
function INSTANCE:GetViewPlane()
    return self.ViewPlane.Min, self.ViewPlane.Max
end

--- @overload fun( self: CameraInstance, min: Vector, max: Vector ): nil
--- @overload fun( self: CameraInstance, horizontalFov: number, verticalFov: number? ): nil
function INSTANCE:SetViewPlane( ... )
    local args = { ... }
    local argCount = select( "#", ... )
    typecheck.AssertArgCount( INSTANCE.Class, argCount, { 1, 2 } )
    typecheck.AssertArgType( INSTANCE.Class, 1, args[1], { "vector", "number" } )

    -- ( min: Vector, max: Vector )
    if isvector( args[1] ) then
        typecheck.AssertArgType( INSTANCE.Class, 2, args[2], "vector" )

        local vMin = args[1] --[[@as Vector]]
        local vMax = args[2] --[[@as Vector]]

        self.ViewPlane.Min = vMin
        self.ViewPlane.Max = vMax
        self.AspectRatio = ( vMax.x - vMin.x ) / ( vMax.y - vMin.y )
        self.FrustumValid = false

    -- ( horizontalFov: number, verticalFov: number )
    end

    if isnumber( args[1] ) and isnumber( args[2] ) then
        typecheck.AssertArgType( INSTANCE.Class, 1, args[1], "number" )

        local horizontalFov = args[1] --[[@as number]]
        local verticalFov   = args[2] --[[@as number]]

        local widthHalf = math.tan( horizontalFov / 2 )
        local heightHalf = 0

        if verticalFov == -1 then
            heightHalf = ( 1 / self.AspectRatio ) * widthHalf -- "Use the aspect ratio"
        else
            heightHalf = math.tan( verticalFov / 2 )
            self.AspectRatio = widthHalf / heightHalf -- "Or, initialize the aspect ratio"
        end

        self.ViewPlane.Min:SetUnpacked( -widthHalf, -heightHalf, 0 )
        self.ViewPlane.Max:SetUnpacked( widthHalf, heightHalf, 0 )

        self.FrustumValid = false
    end
end

--- "Sets the aspect ratio of the camera"
--- @param widthToHeight number
function INSTANCE:SetAspectRatio( widthToHeight )
    self.AspectRatio = widthToHeight
    self.ViewPlane.Min.y = self.ViewPlane.Min.x / self.AspectRatio
    self.ViewPlane.Max.y = self.ViewPlane.Max.x / self.AspectRatio
    self.FrustumValid = false
end

--- @param camPoint Vector
--- @return Vector
--- @return ProjectionResultType
function INSTANCE:ProjectCameraSpacePoint( camPoint )
    self:UpdateFrustum()

    local projectedPoint = Vector()

    -- If the camPoint is behind the near clipping plane, just return (0,0,0)
    if camPoint.z > -self.ZNear + wWMathClass.EPSILON then
        projectedPoint:SetUnpacked( 0, 0, 0 )
        return projectedPoint, projectionResultType.OUTSIDE_NEAR_CLIP
    end

    local viewPoint = self.ProjectionTransform * camPoint

    local oow = 1 / viewPoint.w
    projectedPoint.x = viewPoint.x * oow
    projectedPoint.y = viewPoint.y * oow
    projectedPoint.z = viewPoint.z * oow

    if projectedPoint.z > 1 then
        return projectedPoint, projectionResultType.OUTSIDE_FAR_CLIP
    end

    local isXOutOfFrustum = projectedPoint.x < -1 or projectedPoint.x > 1
    local isYOutOfFrustum = projectedPoint.y < -1 or projectedPoint.y > 1
    if isXOutOfFrustum or isYOutOfFrustum then
        return projectedPoint, projectionResultType.OUTSIDE_FRUSTUM
    end

    return projectedPoint, projectionResultType.INSIDE_FRUSTUM
end

---@param zNear number
---@param zFar number
function INSTANCE:SetClipPlanes( zNear, zFar )
    self.FrustumValid = false
    self.ZNear = zNear
    self.ZFar = zFar
end

--- @return number nearPlaneDistance, number farPlaneDistance
function INSTANCE:GetClipPlanes()
    return self.ZNear, self.ZFar
end

--- @protected
function INSTANCE:UpdateFrustum()
    if self.FrustumValid then
        return
    end

    local cameraMatrix = self:GetTransform()
    local viewportMin, viewportMax = self:GetViewPlane() -- "Normalized view plane at a depth of 1"
    local zNearDistance, zFarDistance = self:GetClipPlanes()

    -- "Forward is negative Z in our viewspace coordinate system"
    local zNear = -zNearDistance
    local zFar = -zFarDistance

    -- "Update the frustum"
    self.FrustumValid = true
    self.Frustum:Init( cameraMatrix, viewportMin, viewportMax, zNear, zFar )

    -- "Update the OBB around the near clip rectangle"
    local nearOBBox = self.NearClipBBox
    nearOBBox.Center = cameraMatrix * Vector( 0, 0, zNear )
    nearOBBox.Extent.x = ( viewportMax.x - viewportMin.x ) * ( -zNear ) * 0.5
    nearOBBox.Extent.y = ( viewportMax.y - viewportMin.y ) * ( -zNear ) * 0.5
    nearOBBox.Extent.z = 0.01
    nearOBBox.Basis:Set( cameraMatrix )

    -- "Update the inverse camera matrix"
    self.CameraInverseTransform = self:GetTransform():GetInverse()

    -- "Update the projection matrix"
    if self.Projection == projectionType.PERSPECTIVE then
        -- local horizontalFov = math.rad( viewSetup.fov )
        -- local verticalFov = 2 * math.atan( math.tan( horizontalFov / 2 ) / viewSetup.aspect )

        self.ProjectionTransform:InitPerspective(
			viewportMin.x * zNearDistance,
			viewportMax.x * zNearDistance,
			viewportMin.y * zNearDistance,
			viewportMax.y * zNearDistance,
			zNearDistance,
			zFarDistance
        )
    else
        self.ProjectionTransform:InitOrthographic(
            viewportMin.x,
            viewportMax.x,
            viewportMin.y,
            viewportMax.x,
            zNearDistance,
            zFarDistance
        )
    end
end