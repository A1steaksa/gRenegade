-- Based on HumanStateClass within Code/Combat/humanstate.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class HumanStateClass
--- @field Instance HumanStateInstance The metatable used by HumanStateInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HumanStateClass"

--- @class HumanStateInstance
--- @field Static HumanStateClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HumanState" )
INSTANCE.Class = "HumanStateInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHumanState = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type HumanAnimationControlClass
	local humanAnimationControlClass = CNC.Import( "code/combat/human-animation-control.lua" )

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

	--- @type WeaponClass
	local weaponClass = CNC.Import( "code/combat/weapon.lua" )
--#endregion

--#region Imported Enums

	local humanStateTypeEnum = humanAnimationControlClass.HUMAN_STATE_TYPE
	local weaponHoldStyleTypeEnum = weaponClass.WEAPON_HOLD_STYLE_TYPE
	local humanStateFlagsTypeEnum = humanAnimationControlClass.HUMAN_STATE_FLAGS_TYPE
	local humanSubStateTypeEnum = humanAnimationControlClass.HUMAN_SUB_STATE_TYPE
--#endregion


--[[ Chunk IDs ]] do

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES   	 = enumBuilder:Set( 915991207 ),
        XXX_CHUNKID_ANIM_CONTROL = enumBuilder:Next(),

        MICROCHUNKID_STATE             				= enumBuilder:Set( 1 ),
		MICROCHUNKID_SUB_STATE						= enumBuilder:Next(),
		MICROCHUNKID_STATE_LOCKED					= enumBuilder:Next(),
		MICROCHUNKID_WEAPON_HOLD_STYLE				= enumBuilder:Next(),
		XXXMICROCHUNKID_WEAPON_STATE				= enumBuilder:Next(),
		MICROCHUNKID_AIMING_TILT					= enumBuilder:Next(),
		MICROCHUNKID_AIMING_TURN					= enumBuilder:Next(),
		MICROCHUNKID_TURN_VELOCITY					= enumBuilder:Next(),
		MICROCHUNKID_PHYSOBJ						= enumBuilder:Next(),
		MICROCHUNKID_LOITER_DELAY					= enumBuilder:Next(),
		MICROCHUNKID_STATE_FLAGS					= enumBuilder:Next(),
		MICROCHUNKID_JUMP_TM						= enumBuilder:Next(),
		MICROCHUNKID_STATE_TIMER					= enumBuilder:Next(),
		MICROCHUNKID_LOITERS_ALLOWED				= enumBuilder:Next(),
		MICROCHUNKID_WEAPON_HOLD_TIMER				= enumBuilder:Next(),
		MICROCHUNKID_HUMAN_ANIM_OVERRIDE_DEF_ID		= enumBuilder:Next(),
		MICROCHUNKID_HUMAN_LOITER_COLLECTION_DEF_ID	= enumBuilder:Next()
    }
end


--[[ Static Functions and Variables ]] do

    --- @class HumanStateClass

	STATIC.CORPSE_PERSIST_TIME = 2.0

	STATIC.MOVING_THRESHOLD = 0.2
	STATIC.WALKING_THRESHOLD = 3.21

    --- Creates a new HumanStateInstance
    --- @return HumanStateInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HumanState" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HumanStateInstance, `false` otherwise
    function STATIC.IsHumanState( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHumanState and true or false
    end

    typecheck.RegisterType( "HumanStateInstance", STATIC.IsHumanState )

	function STATIC.SetPrecision()
		typecheck.NotImplementedError()
	end

	function STATIC.GetWoundAnimation()
		typecheck.NotImplementedError()
	end

	function STATIC.GetDeathAnimation()
		typecheck.NotImplementedError()
	end
end


--- @class HumanStateInstance
--- @field StateLocked boolean
--- @field State HumanStateType
--- @field StateTimer number
--- @field StateFlags integer
--- @field SubState integer
--- @field WeaponHoldStyle integer "How is he holding his weapon?"
--- @field WeaponHoldTimer number "How long until we lower the weapon?"
--- @field LoitersAllowed boolean
--- @field LoiterDelay number
--- @field AimingTilt number
--- @field AimingTurn number
--- @field HumanPhysics HumanPhysicsInstance? "Our local copy // Physical Object for Human"
--- @field AnimationControl HumanAnimationControlInstance "Our local copy // Animation Control for Human Model"
--- @field TurnVelocity number
--- @field LegRotation number
--- @field JumpTM Matrix3dInstance
--- @field RecoilTimer number "Remaining recoil time."
--- @field RecoilScale number "Scale factor on the recoil motion."
--- @field NoAnimationBlend boolean
--- @field WeaponFired boolean
--- @field HumanAnimationOverride HumanAnimationOverrideDefinitionInstance
--- @field HumanLoiterCollection HumanLoiterGlobalSettingsDefinitionInstance

function INSTANCE:Renegade_HumanState()
	self.State = humanStateTypeEnum.UPRIGHT
	self.StateFlags = 0
	self.StateTimer = 0
	self.SubState = 0
	self.StateLocked = false
	self.AnimationControl = nil
	self.WeaponHoldStyle = weaponHoldStyleTypeEnum.WEAPON_HOLD_STYLE_EMPTY_HANDS
	self.HumanPhysics = nil
	self.TurnVelocity = 0
	self.AimingTilt = 0
	self.AimingTurn = 0
	self.RecoilTimer = 0.0
	self.RecoilScale = 1.0
	self.LoiterDelay = 0
	self.LoitersAllowed = true
	self.LegRotation = 0
	self.WeaponHoldTimer = 0
	self.NoAnimationBlend = false
	self.HumanAnimationOverride = nil
	self.HumanLoiterCollection = nil
	self.WeaponFired = false
	self:ResetLoiterDelay()
end

function INSTANCE:_Renegade_HumanState()
	if self.HumanPhysics ~= nil then
		self.HumanPhysics = nil
	end
end

--- @param humanPhysics HumanPhysicsInstance?
function INSTANCE:Init( humanPhysics )
	self.HumanPhysics = humanPhysics
end

function INSTANCE:Reset()
	-- "Clear the sniping flag"
	if self:GetStateFlag( humanStateFlagsTypeEnum.SNIPING_FLAG ) then
		self:ToggleStateFlag( humanStateFlagsTypeEnum.SNIPING_FLAG )
	end
end

--- @param animationControl HumanAnimationControlInstance
function INSTANCE:SetAnimationControl( animationControl )
	self.AnimationControl = animationControl
	self.AnimationControl:SetModel( self.HumanPhysics:PeekModel() )
end

--- @param definitionId integer
function INSTANCE:SetHumanAnimationOverride( definitionId )
	self.HumanAnimationOverride = definitionManagerClass.FindDefinition( definitionId ) --[[@as HumanAnimationOverrideDefinitionInstance]]
end

--- @param definitionId integer
function INSTANCE:SetHumanLoiterCollection( definitionId )
	self.HumanLoiterCollection = definitionManagerClass.FindDefinition( definitionId ) --[[@as HumanLoiterGlobalSettingsDefinitionInstance]]
end

--- @param csave ChunkSaveInstance
--- @return boolean
function INSTANCE:Save( csave )
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
	typecheck.NotImplementedError()
end

--- @param state HumanStateType
--- @param subState integer? [Default: `0`]
function INSTANCE:SetState( state, subState )
	if subState == nil then subState = 0 end

	-- "Special case for death"
	if ( self.State == humanStateTypeEnum.DEATH ) or ( self.State == humanStateTypeEnum.DESTROY ) then
		if state ~= humanStateTypeEnum.DESTROY then
			return
		end
	end

	if self.State ~= humanStateTypeEnum.DEATH and state == humanStateTypeEnum.DEATH then
		self.StateLocked = false
	end

	-- Omitted E3 hack

	if self.State == state and self.SubState == subState then
		return
	end

	self.State = state
	self.SubState = subState
	self.StateTimer = 0

	if (
		state == humanStateTypeEnum.LADDER or
		state == humanStateTypeEnum.IN_VEHICLE or
		state == humanStateTypeEnum.TRANSITION or
		state == humanStateTypeEnum.TRANSITION_COMPLETE or
		state == humanStateTypeEnum.DEBUG_FLY
	) then
		self.HumanPhysics:EnableUserControl( true )
	else
		self.HumanPhysics:EnableUserControl( false )
	end

	if state == humanStateTypeEnum.IN_VEHICLE or state == humanStateTypeEnum.TRANSITION or state == humanStateTypeEnum.TRANSITION_COMPLETE then
		self.HumanPhysics:SetCollisionGroup( collisionGroupTypeEnum.BULLET_ONLY_COLLISION_GROUP )
		self.HumanPhysics:SetImmovable( true )
	elseif state == humanStateTypeEnum.DESTROY or state == humanStateTypeEnum.DEATH then
		self.HumanPhysics:SetCollisionGroup( collisionGroupTypeEnum.TERRAIN_ONLY_COLLISION_GROUP )
		self.HumanPhysics:SetImmovable( true )
	else
		self.HumanPhysics:SetCollisionGroup( collisionGroupTypeEnum.SOLDIER_COLLISION_GROUP )
		self.HumanPhysics:SetImmovable( false )
	end

	self:UpdateAnimation()
end

--- @return HumanStateType
function INSTANCE:GetState()
	return self.State
end

--- @return string
function INSTANCE:GetStateName()
	-- Replaced original function contents as they were crazy
	return table.KeyFromValue( humanStateTypeEnum, self.State )
end

--- @return boolean
function INSTANCE:IsStateInterruptable()
	local state = self.State
	return (
		   state == humanStateTypeEnum.UPRIGHT
		or state == humanStateTypeEnum.WOUNDED
		or state == humanStateTypeEnum.LAND
		or state == humanStateTypeEnum.LOITER
		or state == humanStateTypeEnum.ANIMATION
	)
end

--- @param subState HumanSubStateType
function INSTANCE:SetSubState( subState )
	if self:IsSubStateAdjustable() then
		if self.SubState ~= subState then
			self.SubState = subState
			self:UpdateAnimation()
		end
	else
		section.Warn( "Cant adjust state: '", self:GetStateName(), "'" )
	end
end

--- @return HumanSubStateType
function INSTANCE:GetSubState()
	return self.SubState
end

--- @return boolean
function INSTANCE:IsSubStateAdjustable()
	return ( self.State == humanStateTypeEnum.UPRIGHT ) or ( self.State == humanStateTypeEnum.LADDER )
end

--- @return number
function INSTANCE:GetStateTimer()
	return self.StateTimer
end

--- @param timer number
function INSTANCE:SetStateTimer( timer )
	self.StateTimer = timer
end

--- @param flag integer
function INSTANCE:ToggleStateFlag( flag )
	self.StateFlags = bit.bxor( self.StateFlags, flag )
end

--- @param flag HumanStateFlagsType
--- @return boolean
function INSTANCE:GetStateFlag( flag )
	return bit.band( self.StateFlags, flag ) ~= 0
end

function INSTANCE:DropWeapon()
	self.WeaponHoldTimer = 0.001
end

function INSTANCE:RaiseWeapon()
	self.WeaponHoldTimer = 10
end

function INSTANCE:StartTransitionAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:StartScriptedAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:StopScriptedAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:ForceAnimation()
	typecheck.NotImplementedError()
end

--- @param vel number
function INSTANCE:SetTurnVelocity( vel )
	self.TurnVelocity = vel
end

function INSTANCE:UpdateWeapon()
	typecheck.NotImplementedError()
end

--- @param tilt number
--- @param turn number
function INSTANCE:UpdateAiming( tilt, turn )
	if self.AimingTilt == tilt and self.AimingTurn == turn then
		return
	end

	self.AimingTilt = tilt
	self.AimingTurn = turn

	if not self.StateLocked then
		self:UpdateAnimation()
	end
end

function INSTANCE:UpdateState()
	local frameTime = FrameTime()

	self.StateTimer = self.StateTimer + frameTime

	if self.AnimationControl and self.AnimationControl:GetSkeleton() == "V" then
		self.LoitersAllowed = false
	end

	if self.State == humanStateTypeEnum.UPRIGHT and self.LoitersAllowed then

		-- "Don't loiter when crouched or moving"
		if self.SubState ~= 0 then
			self:ResetLoiterDelay()
		end

		self.LoiterDelay = self.LoiterDelay + frameTime

		-- Omitted loitering code here
	else
		self:ResetLoiterDelay()
	end

end

function INSTANCE:PostThink()
	-- "  
	-- Update [SubState] per movement
	-- do it for upright, land, ladder, airborne,
	-- "  
	if self:IsSubStateAdjustable() or self:IsStateInterruptable() then
		local frameTime = FrameTime()

		-- "Update the SubState"
		local newSubState = 0

		-- "Get our current move vector"
		local moveVector = self.HumanPhysics:GetAnimationMove()
		if frameTime > 0 then
			moveVector = moveVector / frameTime
		end

		moveVector = self.HumanPhysics:GetTransform():InverseRotateVector( moveVector )

		-- "When walking running diagonally, use forward/backward legs."
		-- "Unless you are crouched, then use straffe legs"
		local directionRatio = 0.75
		if self:GetStateFlag( humanStateFlagsTypeEnum.CROUCHED_FLAG ) then
			directionRatio = 2
		end

		-- "Convert to SubMode"
		if math.abs( moveVector[1] ) > directionRatio * math.abs( moveVector[2] ) then
			if moveVector[1] > STATIC.MOVING_THRESHOLD then
				newSubState = bit.bor( newSubState, humanSubStateTypeEnum.SUB_STATE_FORWARD )
			elseif moveVector[1] < -STATIC.MOVING_THRESHOLD then
				newSubState = bit.bor( newSubState, humanSubStateTypeEnum.SUB_STATE_BACKWARD )
			end
		else
			if moveVector[2] > STATIC.MOVING_THRESHOLD then
				newSubState = bit.bor( newSubState, humanSubStateTypeEnum.SUB_STATE_LEFT )
			elseif moveVector[2] <- STATIC.MOVING_THRESHOLD then
				newSubState = bit.bor( newSubState, humanSubStateTypeEnum.SUB_STATE_RIGHT )
			end
		end

		if newSubState == 0 then
			if moveVector[3] > STATIC.MOVING_THRESHOLD then
				newSubState = bit.bor( newSubState, humanSubStateTypeEnum.SUB_STATE_UP )
			elseif moveVector[3] < -STATIC.MOVING_THRESHOLD then
				newSubState = bit.bor( newSubState, humanSubStateTypeEnum.SUB_STATE_DOWN )
			end
		end

		if newSubState ~= 0 then
			if moveVector:Length() < STATIC.WALKING_THRESHOLD then
				newSubState = bit.bor( newSubState, humanSubStateTypeEnum.SUB_STATE_SLOW )
			end
		end

		-- "Get him out of WOUNDED, LAND, LOITER states if moving or shooting"
		if self:IsStateInterruptable() and self:GetState() ~= humanStateTypeEnum.UPRIGHT then
			if newSubState ~= 0 or self.WeaponFired then
				if self:GetState() == humanStateTypeEnum.LAND and self:GetSubState() == newSubState then
					-- "Don't interrupt lands for the same direction"
				else
					self:SetState( humanStateTypeEnum.UPRIGHT )
				end
			end
		end

		if self:IsSubStateAdjustable() then
			if newSubState ~= self:GetSubState() then
				self:SetSubState( newSubState --[[@as HumanSubStateType]] )
			end
		end

		-- "Scale animation speed"
		local idealSpeed = 0
		if not tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_SLOW     ) ) then
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_FORWARD  ) ) then idealSpeed = 5.5 end
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_BACKWARD ) ) then idealSpeed = 4.5 end
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_LEFT     ) ) then idealSpeed = 4.5 end
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_RIGHT    ) ) then idealSpeed = 5.5 end
		else
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_FORWARD  ) ) then idealSpeed = 1.6 end
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_BACKWARD ) ) then idealSpeed = 1.5 end
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_LEFT     ) ) then idealSpeed = 1.5 end
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_RIGHT    ) ) then idealSpeed = 1.6 end
		end

		if self.State == humanStateTypeEnum.LADDER then
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_UP   ) ) then idealSpeed = 0.15 end
			if tobool( bit.band( newSubState, humanSubStateTypeEnum.SUB_STATE_DOWN ) ) then idealSpeed = 0.15 end
		end

		-- "Turning is at speed 1"
		local turning = (
			tobool(
				bit.band(
					newSubState,
					bit.bor(
						humanSubStateTypeEnum.SUB_STATE_TURN_LEFT,
						humanSubStateTypeEnum.SUB_STATE_TURN_RIGHT
					)
				)
			) and not tobool(
				bit.band(
					newSubState,
					bit.bor(
						humanSubStateTypeEnum.SUB_STATE_FORWARD,
						humanSubStateTypeEnum.SUB_STATE_BACKWARD
					)
				)
			)
		)

		if not turning and idealSpeed ~= 0 then
			-- "Get [AnimationSpeedScale]"
			local velocity = self.HumanPhysics:GetAnimationMove()
			if frameTime > 0 then
				velocity = velocity / frameTime
			end
			local speed = math.Clamp( velocity:Length() / idealSpeed, 0.33, 3 )
			self.AnimationControl:SetAnimationSpeedScale( speed )
		else
			self.AnimationControl:SetAnimationSpeedScale( 1 )
		end
		self.HumanPhysics:ResetAnimationMove()
	end
end

--- "Weapons style, weapon action, recoil, blend, vehicle, mix/math, aiming tilt"
function INSTANCE:UpdateAnimation()

	-- "No updates for visceroids"
	if self.AnimationControl:GetSkeleton() == "V" then
		self.StateLocked = true
		return
	end

	if self.StateLocked then
		return
		-- "If you change your anim when locked, death state may clear a scripted anim"
	end

	local holdStyle = self.WeaponHoldStyle

	-- "Setup animation for state, substate, weapon, tilt, etc."
	if self.State == humanStateTypeEnum.UPRIGHT or self.State == humanStateTypeEnum.AIRBORNE then
		local subState = self.SubState
		-- "Determine leg style"
		local legStyle = humanAnimationLegStyle.LEG_STYLE_STAND
		if self.State == humanStateTypeEnum.AIRBORNE then
			legStyle = humanAnimationLegStyle.LEG_STYLE_JUMP_UP
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_LEFT ) ) 	then legStyle = humanAnimationLegStyle.LEG_STYLE_JUMP_LEFT end
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_RIGHT ) ) 	then legStyle = humanAnimationLegStyle.LEG_STYLE_JUMP_RIGHT end
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_FORWARD ) ) 	then legStyle = humanAnimationLegStyle.LEG_STYLE_JUMP_FORWARD end
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_BACKWARD ) ) then legStyle = humanAnimationLegStyle.LEG_STYLE_JUMP_BACKWARD end
		else
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_TURN_LEFT ) )  then legStyle = humanAnimationLegStyle.LEG_STYLE_TURN_LEFT end
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_TURN_RIGHT ) ) then legStyle = humanAnimationLegStyle.LEG_STYLE_TURN_RIGHT end
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_LEFT ) )       then legStyle = humanAnimationLegStyle.LEG_STYLE_RUN_LEFT end
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_RIGHT ) )      then legStyle = humanAnimationLegStyle.LEG_STYLE_RUN_RIGHT end
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_FORWARD ) )    then legStyle = humanAnimationLegStyle.LEG_STYLE_RUN_FORWARD end
			if tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_BACKWARD ) )   then legStyle = humanAnimationLegStyle.LEG_STYLE_RUN_BACKWARD end

			if self:GetStateFlag( humanStateFlagsType.CROUCHED_FLAG ) then
				-- "Tend to hold at chest when crouched"
				if (   ( holdStyle == weaponHoldStyleTypeEnum.WEAPON_HOLD_STYLE_HANDS_DOWN )
					or ( holdStyle == weaponHoldStyleTypeEnum.WEAPON_HOLD_STYLE_C4 )
					or ( holdStyle == weaponHoldStyleTypeEnum.WEAPON_HOLD_STYLE_BEACON )
				) then
					holdStyle = weaponHoldStyleTypeEnum.WEAPON_HOLD_STYLE_AT_CHEST
				end

				legStyle = legStyle + ( humanAnimationLegStyle.LEG_STYLE_CROUCH - humanAnimationLegStyle.LEG_STYLE_STAND )
			elseif tobool( bit.band( subState, humanSubStateTypeEnum.SUB_STATE_SLOW ) ) then
				if (    ( legStyle >= humanAnimationLegStyle.LEG_STYLE_RUN_FORWARD )
					and ( legStyle <= humanAnimationLegStyle.LEG_STYLE_RUN_RIGHT )
				) then
					legStyle = legStyle + ( humanAnimationLegStyle.LEG_STYLE_WALK_FORWARD - humanAnimationLegStyle.LEG_STYLE_RUN_FORWARD )
				end
			end
		end

		local legAnimationName = STATIC.LegAnimationNames[legStyle]
		local torsoAnimationName = STATIC.WeaponStyleNames[holdStyle]

		local singleAnimation = true

		local blendTime = 0.2
		if self.NoAnimationBlend then
			blendTime = 0
			self.NoAnimationBlend = false
		end

		if torsoAnimationName:sub( 2, 2 ) == "2" then
			-- "Let's try aiming"
			local animation1Name = Format( "S_A_HUMAN.H_A_%c1%s", "A" .. holdStyle, legAnimationName )
			local animation2Name = Format( "S_A_HUMAN.H_A_%c2%s", "A" .. holdStyle, legAnimationName )
			local animation3Name = Format( "S_A_HUMAN.H_A_%c3%s", "A" .. holdStyle, legAnimationName )

			-- "See if we have the tilting data"
			local animation = ww3dAssetManagerClass.GetInstance():GetHAnimation( animation3Name )
			if animation ~= nil then
				singleAnimation = false

				local tiltBlend = math.Clamp( ( self.AimingTilt / math.rad( 65 ) ), -1, 1 )
				local frame = self.AnimationControl:GetFrame() -- "Maintain the frame number for moving"
				if tiltBlend < 0 then
					self.AnimationControl:SetAnimation( animation1Name, animation2Name, 1 + tiltBlend, blendTime )
				else
					self.AnimationControl:SetAnimation( animation3Name, animation2Name, 1 - tiltBlend, blendTime )
				end

				self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_LOOP, frame )
			end
		end

		if singleAnimation then
			local animationName = Format( "S_A_HUMAN.H_A_%s%s", torsoAnimationName, legAnimationName )

			-- "Human Anim Override"
			if self.HumanAnimationOverride ~= nil then
				if holdStyle == weaponHoldStyleTypeEnum.WEAPON_HOLD_STYLE_EMPTY_HANDS then
					if legStyle == humanAnimationLegStyle.LEG_STYLE_RUN_FORWARD then
						animationName = self.HumanAnimationOverride.RunEmptyHands
					end

					if legStyle == humanAnimationLegStyle.LEG_STYLE_WALK_FORWARD then
						animationName = self.HumanAnimationOverride.WalkEmptyHands
					end
				end

				if holdStyle == weaponHoldStyleTypeEnum.WEAPON_HOLD_STYLE_AT_CHEST then
					if legStyle == humanAnimationLegStyle.LEG_STYLE_RUN_FORWARD then
						animationName = self.HumanAnimationOverride.RunAtChest
					end

					if legStyle == humanAnimationLegStyle.LEG_STYLE_WALK_FORWARD then
						animationName = self.HumanAnimationOverride.WalkAtChest
					end
				end

				if holdStyle == weaponHoldStyleTypeEnum.WEAPON_HOLD_STYLE_AT_HIP then
					if legStyle == humanAnimationLegStyle.LEG_STYLE_RUN_FORWARD then
						animationName = self.HumanAnimationOverride.RunAtHip
					end

					if legStyle == humanAnimationLegStyle.LEG_STYLE_WALK_FORWARD then
						animationName = self.HumanAnimationOverride.WalkAtHip
					end
				end
			end

			self.AnimationControl:SetAnimation( animationName, blendTime )
			self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_LOOP )
		end
	elseif self.State == humanStateTypeEnum.DIVE then
		local offset = math.floor( math.Rand( 0, 3 ) )
		if not gameTypeClass.IsSoloplay() then
			offset = 0
		end

		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_FORWARD  ) ) then offset = offset + 0 end
		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_BACKWARD ) ) then offset = offset + 2 end
		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_LEFT     ) ) then offset = offset + 4 end
		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_RIGHT    ) ) then offset = offset + 8 end

		local animationName = STATIC.DiveAnimations[offset + 1]
		self.AnimationControl:SetAnimation( animationName, 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_ONCE )
		self.StateLocked = true

	elseif self.State == humanStateTypeEnum.LAND then
		local direction = 0

		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_LEFT ) ) then
			direction = 3
		end

		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_RIGHT ) ) then
			direction = 4
		end

		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_FORWARD ) ) then
			direction = 1
		end

		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_BACKWARD ) ) then
			direction = 2
		end

		local animationName = Format( "S_A_HUMAN.H_A_A0L%d", direction )
		self.AnimationControl:SetAnimation( animationName, 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_ONCE )

	elseif self.State == humanStateTypeEnum.WOUNDED then
		self.AnimationControl:SetAnimation( STATIC.GetWoundAnimation( self.SubState ), 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_ONCE )
	elseif self.State == humanStateTypeEnum.DEATH then
		self.AnimationControl:SetAnimation( STATIC.GetDeathAnimation( self.SubState ), 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_ONCE )
	elseif self.State == humanStateTypeEnum.LADDER then
		local animationName = "S_A_HUMAN.H_A_412A"
		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_UP ) ) then
			animationName = "S_A_HUMAN.H_A_422A"
		end
		if tobool( bit.band( self.SubState, humanSubStateTypeEnum.SUB_STATE_DOWN ) ) then
			animationName = "S_A_HUMAN.H_A_432A"
		end

		self.AnimationControl:SetAnimation( animationName, 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_LOOP )
	elseif self.State == humanStateTypeEnum.ANIMATION then
	elseif self.State == humanStateTypeEnum.LOITER then
	elseif self.State == humanStateTypeEnum.DESTROY then
	elseif self.State == humanStateTypeEnum.TRANSITION then
	elseif self.State == humanStateTypeEnum.TRANSITION_COMPLETE then
	elseif self.State == humanStateTypeEnum.ON_FIRE then
		self.AnimationControl:SetAnimation( "S_A_HUMAN.H_A_FLMA", 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_LOOP )
	elseif self.State == humanStateTypeEnum.ON_CHEM then
		self.AnimationControl:SetAnimation( "S_A_HUMAN.h_a_6x01", 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_LOOP )
	elseif self.State == humanStateTypeEnum.ON_CNC_FIRE then
		self.AnimationControl:SetAnimation( "S_A_HUMAN.H_A_FLMA", 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_LOOP )
	elseif self.State == humanStateTypeEnum.ON_CNC_CHEM then
		self.AnimationControl:SetAnimation( "S_A_HUMAN.h_a_6x01", 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_LOOP )
	elseif self.State == humanStateTypeEnum.ON_ELECTRIC then
		self.AnimationControl:SetAnimation( "S_A_HUMAN.h_a_6x05", 0.2 )
		self.AnimationControl:SetMode( animationControlAnimationModeEnum.ANIM_MODE_LOOP )
	elseif self.State == humanStateTypeEnum.DEBUG_FLY then
	else
		section.Warn( "Uncoded human state: '", self.State, "'" )
		self.AnimationControl:SetAnimation( nil )
	end
end

--- @return boolean
function INSTANCE:IsLocked()
	return self.StateLocked
end

--- @return boolean
function INSTANCE:GetLegMode()
	return self.AnimationControl:GetProgress() > 0.5
end

--- @param direction Vector
--- @param collisionBoxName string
--- @return HumanOuchType
function INSTANCE:GetOuchType( direction, collisionBoxName )
	typecheck.NotImplementedError()
end

function INSTANCE:ResetLoiterDelay()
	self.LoiterDelay = math.Rand( 0, 6 ) - 3
end

--- @param allowed boolean
function INSTANCE:SetLoitersAllowed( allowed )
	self.LoitersAllowed = allowed
end

function INSTANCE:GetInformation()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateRecoil()
	typecheck.NotImplementedError()
end

function INSTANCE:BeginJump()
	typecheck.NotImplementedError()
end

function INSTANCE:CompleteJump()
	typecheck.NotImplementedError()
end
