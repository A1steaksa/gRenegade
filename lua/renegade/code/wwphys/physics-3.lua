-- Based on Phys3Class within Code/wwphys/phys3.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type MoveablePhysicsClass
local moveablePhysicsClass = CNC.Import( "code/wwphys/moveable-physics.lua" )

--- @class Physics3Class : MoveablePhysicsClass
--- @field Instance Physics3Instance The metatable used by Physics3Instance
local STATIC = CNC.CreateExport( moveablePhysicsClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "Physics3Class"

--- @class Physics3Instance : MoveablePhysicsInstance
--- @field Static Physics3Class The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Physics3 : Renegade_MoveablePhysics" )
INSTANCE.Class = "Physics3Instance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysics3 = true

--#region Exported Enums

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	local enumBuilder = enumBuilderClass.New()

	--- @enum MoveModeType
	STATIC.MOVE_MODE_TYPE = {
		USER_OVERRIDE  = enumBuilder:Set( 0 ),
		BALLISTIC_MOVE = enumBuilder:Next(),
		SLIDE_MOVE	   = enumBuilder:Next(),
		NORMAL_MOVE	   = enumBuilder:Next(),
		COLLIDE_MOVE   = enumBuilder:Next(),
	}
	local moveModeTypeEnum = STATIC.MOVE_MODE_TYPE

--#endregion

--#region Imports

	--- @type AABoxClass
	local aABoxClass = CNC.Import( "code/wwmath/aabox.lua" )

	--- @type GroundStateClass
	local groundStateClass = CNC.Import( "code/wwphys/ground-state-struct.lua" )

	--- @type RenderObjectClass
	local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

	--- @type Matrix3dClass
	local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )

	--- @type InfoEntityLib
	local infoEntityLib = CNC.Import( "sh_info-entity.lua" )
--#endregion

--#region Imported Enums

	local renderObjectClassIdEnum = renderObjectClass.RENDER_OBJECT_CLASS_ID
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class Physics3Class
	--- @field CorrectionTime number "Network correction handling constants"
	--- @field AllowableError number
	--- @field PopError number

	--- "The distance an object will "step up" over an obstacle"
    STATIC.DEFAULT_STEP_HEIGHT = 0.25

    -- "The distance an object will "step up" over an obstacle"
    STATIC.DEFAULT_STEP_HEIGHT = 0.25

    -- "Steepest angle the character can walk up"
    STATIC.DEFAULT_SLIDE_ANGLE = math.rad( 45.0 )

    STATIC.DEFAULT_NORMALIZED_SPEED = 10.0

    -- "On ground if within this distance"
    STATIC.GROUND_DISTANCE = 0.1

    -- "Stop at this distance from ground"
    STATIC.GROUND_EPSILON = STATIC.GROUND_DISTANCE / 5.0

    -- "Stop at this distance from walls/slides"
    STATIC.WALL_EPSILON = 0.5

    -- "Only try to step if we could move this distance"
    STATIC.MIN_STEP_MOVE = 0.25

    -- "Only step if moving at an angle close to the x-y plane"
    STATIC.MAX_STEP_MOVE_ANGLE_TAN = 1.0

    --[[ Debug Vector colors ]] do

        -- "Color for the velocity debug vector"
        STATIC.VELOCITY_COLOR = Color( 255, 0, 0 )

        -- "Color for contact vectors"
        STATIC.CONTACT_COLOR  = Color( 0.25 * 255, 0.7 * 255, 0.2 * 255 )

        STATIC.GROUND_COLOR   = Color( 0, 255, 255 )
    end

    --- Creates a new Physics3Instance
    --- @return Physics3Instance
    function STATIC.New()
        return robustclass.New( "Renegade_Physics3" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) Physics3Instance, `false` otherwise
    function STATIC.IsPhysics3( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysics3 and true or false
    end

    typecheck.RegisterType( "Physics3Instance", STATIC.IsPhysics3 )

	function STATIC.SetCorrectionTime()
		typecheck.NotImplementedError()
	end

	function STATIC.SetAllowableError()
		typecheck.NotImplementedError()
	end

	function STATIC.SetPopError()
		typecheck.NotImplementedError()
	end

	function STATIC.GetCorrectionTime()
		typecheck.NotImplementedError()
	end

	function STATIC.GetAllowableError()
		typecheck.NotImplementedError()
	end

	function STATIC.GetPopError()
		typecheck.NotImplementedError()
	end
end


--- @class Physics3Instance
--- @field CollisionBox AABoxInstance "Object space collision box"
--- @field OnGround boolean "Flag indicates whether object is resting on something"
--- @field InCollision boolean "This object is already participating in a collision"
--- @field HeadingChanged boolean "If the heading changes, transform will be updated on next timestep"
--- @field GroundSurface integer "Surface type id of the ground we're standing on."
--- @field State StateStruct "State vector"
--- @field Heading number "Heading, a move of 1,0,0 will move in this direction."
--- @field NormalizedSpeed number "Speed to move when controller is 1.0"
--- @field SlideAngle number "Slope angle at which this object slides off"
--- @field SlideNormalZ number "cos(SlideAngle)"
--- @field SlideAngleTan number "tan(SlideAngle)"
--- @field StepHeight number Step [size] that this object will hop over
--- @field MoveMode MoveModeType "Current movement mode"
--- @field GroundObject PhysicsInstance "Object that we are standing on"
--- @field GroundState GroundStateInstance? "Info on the surface we're standing on (if any)"
--- @field AnimationMove Vector "How far this object moved for animation purposes"
--- @field History Physics3HistoryInstance "History of our state for smarter network updating"
--- @field LatencyError Vector "Remaining latency error"
--- @field LastKnownPosition Vector "Last position received from server"
--- @field LastKnownVelocity Vector "Last velocity received from server"

function INSTANCE:Renegade_Physics3()
	self.GroundState = groundStateClass.New()

	self.CollisionBox = aABoxClass.New()
	self.CollisionBox.Center:SetUnpacked( 0, 0, 1 )
	self.CollisionBox.Extent:SetUnpacked( 1, 1, 1 )
	self.OnGround = false
	self.InCollision = false
	self.HeadingChanged = false
	self.GroundSurface = 0
	self.Heading = 0.0
	self.NormalizedSpeed = STATIC.DEFAULT_NORMALIZED_SPEED
	self.SlideAngle = STATIC.DEFAULT_SLIDE_ANGLE
	self.SlideNormalZ = math.cos( self.SlideAngle )
	self.SlideAngleTan = math.tan( self.SlideAngle )
	self.StepHeight = STATIC.DEFAULT_STEP_HEIGHT
	self.MoveMode = moveModeTypeEnum.NORMAL_MOVE
    self.GroundObject = nil
    self.AnimationMove = Vector( 0, 0, 0 )
    self.History = nil
    self.LatencyError = Vector( 0, 0, 0 )
    self.LastKnownPosition = Vector( 0, 0, 0 )
    self.LastKnownVelocity = Vector( 0, 0, 0 )
    self:InvalidateGroundState()
end

function INSTANCE:_Renegade_Physics3()
	typecheck.NotImplementedError()
end

function INSTANCE:AsPhysics3class()
	typecheck.NotImplementedError()
end

--- @param definition Physics3DefinitionInstance
--- @param connectedEntity Entity
function INSTANCE:Init( definition, connectedEntity )
	moveablePhysicsClass.Instance.Init( self, definition, connectedEntity )

	self.CollisionBox.Center:SetUnpacked( 0, 0, 1 )
	self.CollisionBox.Extent:SetUnpacked( 1, 1, 1 )
	self.OnGround = false
	self.InCollision = false
	self.GroundSurface = 0
	self.Heading = 0.0
	self.NormalizedSpeed = definition.NormalizedSpeed
	self.SlideAngle = definition.SlideAngle
	self.SlideNormalZ = math.cos( self.SlideAngle )
	self.SlideAngleTan = math.tan( self.SlideAngle )
	self.StepHeight = definition.StepHeight
	self.MoveMode = moveModeTypeEnum.NORMAL_MOVE
    self.GroundObject = nil
    self.AnimationMove = Vector( 0, 0, 0 )
    self.LatencyError = Vector( 0, 0, 0 )
    self.LastKnownPosition = Vector( 0, 0, 0 )
    self.LastKnownVelocity = Vector( 0, 0, 0 )

	self:UpdateCachedModelParameters()
	self:InvalidateGroundState()
end

function INSTANCE:GetBoundingBox()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCollisionBox()
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

function INSTANCE:IntersectionTest()
	typecheck.NotImplementedError()
end

function INSTANCE:IntersectionTest()
	typecheck.NotImplementedError()
end

--- @param model RenderObjectInstance
function INSTANCE:SetModel( model )
	-- "Let the base class have the model"
	moveablePhysicsClass.Instance.SetModel( self, model )

	-- "Update any member that depend on the model"
	self:UpdateCachedModelParameters()

	-- "Update our culling box"
	-- Omitted updating culling box
	-- self:UpdateCullBox()
end

function INSTANCE:GetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:ApplyImpulse()
	typecheck.NotImplementedError()
end

function INSTANCE:Timestep()
	typecheck.NotImplementedError()
end

function INSTANCE:IsInContact()
	typecheck.NotImplementedError()
end

function INSTANCE:SetInContact()
	typecheck.NotImplementedError()
end

function INSTANCE:GetContactSurfaceType()
	typecheck.NotImplementedError()
end

function INSTANCE:InvalidateGroundState()
    self.GroundState.IsDirty = true
end

function INSTANCE:PeekGroundObject()
	typecheck.NotImplementedError()
end

function INSTANCE:AssertStateValid()
	typecheck.NotImplementedError()
end

function INSTANCE:CanTeleport()
	typecheck.NotImplementedError()
end

function INSTANCE:CanTeleportAndStand()
	typecheck.NotImplementedError()
end

function INSTANCE:FindTeleportLocation()
	typecheck.NotImplementedError()
end

function INSTANCE:CanMoveTo()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:SetHeading()
	typecheck.NotImplementedError()
end

function INSTANCE:GetHeading()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSlideAngle()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSlideAngle()
	typecheck.NotImplementedError()
end

function INSTANCE:SetNormalizedSpeed()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNormalizedSpeed()
	typecheck.NotImplementedError()
end

function INSTANCE:AddAnimationMove()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAnimationMove()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetAnimationMove()
	typecheck.NotImplementedError()
end

function INSTANCE:GetShadowBlobBox()
	typecheck.NotImplementedError()
end

function INSTANCE:Push()
	typecheck.NotImplementedError()
end

function INSTANCE:Collide()
	typecheck.NotImplementedError()
end

function INSTANCE:NetworkStateUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:NetworkLatencyStateUpdate()
	typecheck.NotImplementedError()
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

function INSTANCE:OnPostLoad()
	typecheck.NotImplementedError()
end

function INSTANCE:GetGroundState()
	typecheck.NotImplementedError()
end

function INSTANCE:CheckGround()
	typecheck.NotImplementedError()
end

function INSTANCE:UserMove()
	typecheck.NotImplementedError()
end

function INSTANCE:BallisticMove()
	typecheck.NotImplementedError()
end

function INSTANCE:SlideMove()
	typecheck.NotImplementedError()
end

function INSTANCE:NormalMove()
	typecheck.NotImplementedError()
end

function INSTANCE:CollideMove()
	typecheck.NotImplementedError()
end

function INSTANCE:ApplyMove()
	typecheck.NotImplementedError()
end

function INSTANCE:SnapToGround()
	typecheck.NotImplementedError()
end

function INSTANCE:ClipMove()
	typecheck.NotImplementedError()
end

function INSTANCE:AttachToGroundObject()
	typecheck.NotImplementedError()
end

--- "Caches some data related to the model"
function INSTANCE:UpdateCachedModelParameters()
	--- "If we don't have a model yet, just return"
	if self.Model == nil then
		return
	else
		-- Omitted using the "WORLDBOX" sub object as a bounding box
		local boundingBox = infoEntityLib.GetEntityLocalBoundingBox( self:GetConnectedEntity() )

		if boundingBox then
			local oldTransform = self.Model:GetTransform()
			self.Model:SetTransform( matrix3dClass.New( true ) )

			self.CollisionBox = boundingBox
			self.Model:SetTransform( oldTransform )
		end
	end
end

function INSTANCE:UpdateTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:ComputeWsCollisionBox()
	typecheck.NotImplementedError()
end

function INSTANCE:DebugVerifyPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:NetworkTeleportCorrection()
	typecheck.NotImplementedError()
end
