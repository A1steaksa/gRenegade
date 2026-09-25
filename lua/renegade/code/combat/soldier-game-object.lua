-- Based on SoldierGameObj within Code/Combat/soldier.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SmartGameObjectClass
local smartGameObjectClass = CNC.Import( "code/combat/smart-game-object.lua" )

--- @class SoldierGameObjectClass : SmartGameObjectClass
--- @field Instance SoldierGameObjectInstance The metatable used by SoldierGameObjectInstance
local STATIC = CNC.CreateExport( smartGameObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SoldierGameObjectClass"

--- @class SoldierGameObjectInstance : SmartGameObjectInstance
--- @field Static SoldierGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SoldierGameObject : Renegade_SmartGameObject" )
INSTANCE.Class = "SoldierGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSoldierGameObject = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ArmorWarheadManagerClass
	local armorWarheadManagerClass = CNC.Import( "code/combat/armor-warhead-manager.lua" )

	--- @type HumanAnimationControlClass
	local humanAnimationControlClass = CNC.Import( "code/combat/human-animation-control.lua" )

	--- @type ActionParamsStructClass
	local actionParamsStructClass = CNC.Import( "code/combat/action-params-struct.lua" )

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type GameObjectManagerClass
	local gameObjectManagerClass = CNC.Import( "code/combat/game-object-manager.lua" )

	--- @type Ww3dAssetManagerClass
	local ww3dAssetManagerClass = CNC.Import( "code/ww3d2/ww3d-asset-manager.lua" )

	--- @type HTreeClass
	local hTreeClass = CNC.Import( "code/ww3d2/h-tree.lua" )

	--- @type HumanStateClass
	local humanStateClass = CNC.Import( "code/combat/human-state.lua" )

	--- @type CombatManagerClass
	local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

	--- @type UnitCoordinationZoneManagerClass
	local unitCoordinationZoneManagerClass = CNC.Import( "code/combat/unit-coordination-zone-manager.lua" )

	--- @type PhysicalGameObjectClass
	local physicalGameObjectClass = CNC.Import( "code/combat/physical-game-object.lua" )

	--- @type SoldierObserverClass
	local soldierObserverClass = CNC.Import( "code/combat/soldier-observer.lua" )

	--- @type UnitConversionLib
	local unitConversionLib = CNC.Import( "sh_unit-conversion.lua" )

	--- @type HudClass
	local hudClass = CNC.Import( "code/combat/hud.lua" )

	--- @type NetworkObjectClass
	local networkObjectClass = CNC.Import( "code/wwnet/network-object.lua" )

	--- @type WWMathClass
	local wWMathClass = CNC.Import( "code/wwmath/wwmath.lua" )

	--- @type Matrix3dClass
	local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )

	--- @type ControlClass
	local controlClass = CNC.Import( "code/combat/control.lua" )
--#endregion

--#region Imported Enums

	local specialDamageTypeEnum = armorWarheadManagerClass.SPECIAL_DAMAGE_TYPE
	local soldierAiStateEnum = actionParamsStructClass.SOLDIER_AI_STATE
	local collisionGroupTypeEnum = physicalGameObjectClass.COLLISION_GROUP_TYPE
	local humanStateTypeEnum = humanStateClass.HUMAN_STATE_TYPE
	local humanStateFlagsTypeEnum = humanStateClass.HUMAN_STATE_FLAGS_TYPE
	local humanSubStateTypeEnum = humanStateClass.HUMAN_SUB_STATE_TYPE
	local dirtyBitEnum = networkObjectClass.DIRTY_BIT
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class SoldierGameObjectClass
	--- @field DisplayDebugBoxForGhostCollision boolean
	--- @field SoldierGameObjectPersistFactory SimplePersistFactoryInstance
	--- @field ShakeDelay number
	--- @field CryDelay number
	--- @field HeadBone integer
	--- @field NeckBone integer

	STATIC.DisplayDebugBoxForGhostCollision = false

	STATIC.ShakeDelay = 0
	STATIC.CryDelay = 0

	STATIC.HeadBone = -1
	STATIC.NeckBone = -1

	STATIC.TILT_DOWN_SPEED = 4.0

	STATIC.HEAD_TURN_RATE = math.rad( 360 ) / 2
	STATIC.HEAD_TILT_RATE = math.rad( 180 ) / 2

	STATIC.HEAD_TURN_LIMIT = 70
	STATIC.HEAD_TILT_LIMIT = 20

    --- Creates a new SoldierGameObjectInstance
    --- @return SoldierGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SoldierGameObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SoldierGameObjectInstance, `false` otherwise
    function STATIC.IsSoldierGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSoldierGameObject and true or false
    end

    typecheck.RegisterType( "SoldierGameObjectInstance", STATIC.IsSoldierGameObject )

	function STATIC.StaticConstructor()
		STATIC.SoldierGameObjectPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CHUNKID_GAME_OBJECT_SOLDIER )
	end

	function STATIC.SayDynamicDialogue()
		typecheck.NotImplementedError()
	end

	--- @param onOff boolean
	function STATIC.EnableGhostCollisionDebugDisplay( onOff )
		STATIC.DisplayDebugBoxForGhostCollision = onOff
	end

	--- @return boolean
	function STATIC.IsGhostCollisionDebugDisplayEnabled()
		typecheck.NotImplementedError()
	end
end


--- @class SoldierGameObjectInstance
--- @field WeaponRenderModel RenderObjectInstance
--- @field BackWeaponRenderModel RenderObjectInstance
--- @field BackFlagRenderModel RenderObjectInstance
--- @field WeaponAnimationControl AnimationControlInstance
--- @field _DetonateC4 boolean
--- @field TransitionCompletionData TransitionCompletionDataStruct
--- @field AnimationName string
--- @field Vehicle VehicleGameObjectInstance
--- @field HumanState HumanStateInstance
--- @field LegFacing number
--- @field SyncLegs boolean
--- @field LastLegMode boolean
--- @field KeyRing integer
--- @field IsUsingGhostCollision boolean
--- @field DialogList DialogueInstance[]
--- @field CurrentSpeech AudibleSoundInstance
--- @field HeadLookDuration number
--- @field HeadRotation Vector
--- @field HeadLookTarget Vector
--- @field HeadLookAngle Vector
--- @field HeadLookAngleTimer number
--- @field SpecialDamageMode SpecialDamageType
--- @field SpecialDamageTimer number
--- @field SpecialDamageDamager GameObjectInstance
--- @field SpecialDamageEffect TransitionEffectInstance
--- @field HealingEffect TransitionEffectInstance
--- @field FacingObject GameObjectInstance?
--- @field FacingAllowBodyTurn boolean
--- @field InnateEnableBits integer
--- @field InnateObserver SoldierObserverInstance
--- @field AiState SoldierAiState
--- @field SpeechAnimation DynamicSpeechAnimationInstance
--- @field GenerateIdleFacialAnimationTimer number
--- @field HeadModel RenderObjectInstance
--- @field EmotIconModel RenderObjectInstance
--- @field EmotIconTimer number
--- @field InFlyMode boolean
--- @field _IsVisible boolean
--- @field LadderUpMask boolean
--- @field LadderDownMask boolean
--- @field ReloadingTilt number
--- @field WeaponChanged boolean
--- @field WaterWake PersistantSurfaceEmitterInstance
--- @field RenderObjectList RenderObjectInstance[]

function INSTANCE:Renegade_SoldierGameObject()
	smartGameObjectClass.Instance.Renegade_SmartGameObject( self )

	self.HumanState = humanStateClass.New()

	self.WeaponRenderModel = nil
	self.BackWeaponRenderModel = nil
	self.BackFlagRenderModel = nil
	self.WeaponAnimationControl = nil
	self.TransitionCompletionData = nil
	self.Vehicle = nil
	self.LegFacing = 0
	self.SyncLegs = false
	self.LastLegMode = false
	self.HeadLookDuration = 0
	self.HeadRotation = Vector( 0, 0, 0 )
	self.HeadLookTarget = Vector( 0, 0, 0 )
	self.HeadLookAngle = Vector( 0, 0, 0 )
	self.HeadLookAngleTimer = 0
	self.InnateEnableBits = 0xFFFFFFFF
	self.InnateObserver = nil
	self.SpecialDamageMode = specialDamageTypeEnum.NONE
	self.SpecialDamageTimer = 0
	self.GenerateIdleFacialAnimTimer = 0
	self.KeyRing = 0
	self.InFlyMode = false
	self._IsVisible = true
	self.CurrentSpeech = nil
	self.AiState = soldierAiStateEnum.AI_STATE_IDLE
	self.SpeechAnimation = nil
	self.HeadModel = nil
	self.EmotIconModel = nil
	self.EmotIconTimer = 0
	self.LadderUpMask = false
	self.LadderDownMask = false
	self.SpecialDamageEffect = nil
	self.HealingEffect = nil
	self.ReloadingTilt = 0
	self.WaterWake = nil
	self.WeaponChanged = false

	-- "All humans need a [HumanAnimationControlInstance]"
	INSTANCE.SetAnimationControl( self, humanAnimationControlClass.New() )
	-- INSTANCE.SetAppPacketType( self, appPacketTypeEnum.APPPACKETTYPE_SOLDIER )

	-- "Create a water wake object"
	-- self.WaterWake = surfaceEffectsManagerClass.CreatePersistantEmitter()
	-- Omitted creating water wake object
end

function INSTANCE:_Renegade_SoldierGameObject()
	typecheck.NotImplementedError()
end

--- @param definition SoldierGameObjectDefinitionInstance?
--- @param connectedEntity Entity
function INSTANCE:Init( definition, connectedEntity )
	-- ()
	if definition == nil then
		INSTANCE.ReInit( self, INSTANCE.GetDefinition( self ) )
		return
	end

	-- ( definition: SoldierGameObjectDefinitionInstance )
	smartGameObjectClass.Instance.Init( self, definition, connectedEntity )
	INSTANCE.CopySettings( self, definition )
end

--- @param definition SoldierGameObjectDefinitionInstance
function INSTANCE:CopySettings( definition )
	self.HumanState:Init( self:PeekHumanPhysics() )
	-- "Must set the anim control after the phys object"
	self.HumanState:SetAnimationControl( INSTANCE.GetAnimationControl( self ) --[[@as HumanAnimationControlInstance]] )

	if INSTANCE.GetDefinition( self ).HumanAnimationOverrideDefinitionID ~= 0 then
		self.HumanState:SetHumanAnimationOverride( INSTANCE.GetDefinition( self ).HumanAnimationOverrideDefinitionID )
	end

	if INSTANCE.GetDefinition( self ).HumanLoiterCollectionDefinitionID ~= 0 then
		self.HumanState:SetHumanLoiterCollection( INSTANCE.GetDefinition( self ).HumanLoiterCollectionDefinitionID )
	end

	INSTANCE.AdjustSkeleton( self, definition.SkeletonHeight, definition.SkeletonWidth )

	-- "All characters force their heads and hands to use the same LOD level as their body."
	local model = self:PeekHumanPhysics():PeekModel()
	if model ~= nil then
		model:SetSubObjectsMatchLod( true )
	end

	if (
		self.InnateObserver == nil
		and INSTANCE.GetDefinition( self ).UseInnateBehavior
		and INSTANCE.IsControlledByMe( self ) == false
	) then
		self.InnateObserver = soldierObserverClass.New()
		INSTANCE.InsertObserver( self, self.InnateObserver )
	end
end

--- @param definition SoldierGameObjectDefinitionInstance
function INSTANCE:ReInit( definition )

	if self == combatManagerClass.GetTheStar() then
		hudClass.ForceWeaponChartUpdate()
		-- weaponViewClass.Reset()
	end

	-- "Remove the object from the world (just to be safe)"
	-- combatManagerClass.TheScene():RemoveObject( self:PeekPhysicalObject() )

	-- "Reset the weapon model"
	-- self:SetWeaponModel( nil )

	if self.BackWeaponRenderModel ~= nil then
		typecheck.NotImplementedError()
	end

	if self.BackFlagRenderModel ~= nil then
		typecheck.NotImplementedError()
	end

	if self.WeaponAnimationControl ~= nil then
		self.WeaponAnimationControl = nil
	end

	-- "Re-initialize the base class"
	smartGameObjectClass.Instance.ReInit( self, definition )

	-- "Free some of the data we will be re-initializing"
	self.HeadModel = nil
	self.SpeechAnimation = nil
	self.CurrentSpeech = nil

	self.HumanState:Reset()

	-- "Copy any internal settings from the definition"
	self:CopySettings( definition )

	-- "'Dirty' the object for networking"
	self:SetObjectDirtyBit( dirtyBitEnum.BIT_RARE, true )

	-- "When class changes, update for new weapon"
	if self == combatManagerClass.GetTheStar() then
		hudClass.Reset()
	end
end

--- @return SoldierGameObjectDefinitionInstance
function INSTANCE:GetDefinition()
	return self.Definition --[[@as SoldierGameObjectDefinitionInstance]]
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

--- @return SimplePersistFactoryInstance
function INSTANCE:GetFactory()
	return STATIC.SoldierGameObjectPersistFactory
end

--- @return HumanPhysicsInstance?
function INSTANCE:PeekHumanPhysics()
	return self:PeekPhysicalObject():AsHumanPhysics()
end

function INSTANCE:Think()
	do
		if self == combatManagerClass.GetTheStar() then
			local frameSeconds = FrameTime()
			STATIC.ShakeDelay = STATIC.ShakeDelay - frameSeconds
			STATIC.CryDelay = STATIC.CryDelay - frameSeconds
		end

		-- "  
		-- Simply check to see if this soldier has entered a coordination zone (which bound
		-- the entrances/exits of ladders and elevators).  If so, then disable collision
		-- between them and all other soldiers.
		-- "  
		local position
		--[[ Coordination Zone ]] do
			position = self:GetPosition()
			if unitCoordinationZoneManagerClass.IsUnitInZone( position ) then
				INSTANCE.EnableGhostCollision( self, true )
			elseif INSTANCE.IsSafeToDisableGhostCollision( self, position ) then
				INSTANCE.EnableGhostCollision( self, false )
			end
		end

		-- "Display a debug box to show the ghosted collision as necessary"
		-- Omitted code here

		-- "Stats"
		-- Omitted code here

		-- "Update the soldier's facing"
		do
			INSTANCE.UpdateLockedFacing( self )
		end

		-- "[HandleLegs] moved form [ApplyControl] because clients don't run it for server objects"
		do
			-- Omitted handling legs
			-- INSTANCE.HandleLegs( self )
		end
	end

	do
		-- "Perform smart object thinking (apply controls)"
		smartGameObjectClass.Instance.Think( self )
	end

	do
		if combatManagerClass.IAmServer() then
			-- "Handle C4 in a special way.  When C4 is fired, the human plays a crouching animation, and starts a c4 placement timer."
			-- Omitted C4 handling
		end

		if self:GetState() ~= humanStateTypeEnum.IN_VEHICLE then
			-- Omitted weapon code here

			self.HumanState:UpdateState()

			-- Omitted C4 code here
		end
		
	end
end

function INSTANCE:PostThink()
	if self:GetState() == humanStateTypeEnum.IN_VEHICLE then
		smartGameObjectClass.Instance.PostThink( self )
		return
	end

	--[[ Soldier PostThink ]] do

		self.HumanState:PostThink()

		local updateWeapon = false
		if self.WeaponChanged then
			self.WeaponChanged = false
			self:UpdateBackGun()
			updateWeapon = true
		end

		if ( self:GetWeapon() ~= nil ) and ( self:GetWeapon():IsModelUpdateNeeded() ) then
			updateWeapon = true
			self:GetWeapon():ResetModelUpdate() -- "Reset model updated needed"
		end

		if updateWeapon then
			if self:GetWeapon() ~= nil then
				self:SetWeaponModel( self:GetWeapon():GetModelName() )
			else
				self:SetWeaponModel( nil )
			end
		end

		if self.WeaponAnimationControl then
			self.WeaponAnimationControl:Update( FrameTime() ) -- "Update the animation control"
		end

		self:HandleHeadLook()

		if self:GetWeapon() ~= nil and self:GetState() == humanStateTypeEnum.ON_FIRE then
			self:GetWeapon():SetPrimaryTriggered( false )
			self:GetWeapon():SetSecondaryTriggered( false )
		end
	end

	smartGameObjectClass.Instance.PostThink( self )

	self:UpdateHealingEffect()
end

--- @param controlOwner integer
function INSTANCE:SetControlOwner( controlOwner )
	if INSTANCE.IsHumanControlled( self ) then
		gameObjectManagerClass.RemoveStar( self )
	end
	smartGameObjectClass.Instance.SetControlOwner( self, controlOwner )
	if INSTANCE.IsHumanControlled( self ) then
		gameObjectManagerClass.AddStar( self )
	end
end

function INSTANCE:GenerateControl()
	typecheck.NotImplementedError()
end

function INSTANCE:ApplyControl()
	typecheck.NotImplementedError()
end

function INSTANCE:ApplyDamage()
	typecheck.NotImplementedError()
end

function INSTANCE:ApplyDamageExtended()
	typecheck.NotImplementedError()
end

function INSTANCE:CompletelyDamaged()
	typecheck.NotImplementedError()
end

function INSTANCE:CollisionOccurred()
	typecheck.NotImplementedError()
end

--- @return Vector
function INSTANCE:GetBullseyePosition()
	if self:GetVehicle() ~= nil then
		return self:GetVehicle():GetBullseyePosition()
	end

	local pos = self:GetPosition()
	if self:IsCrouched() then
		pos.z = pos.z + 0.5 * unitConversionLib.MetersToSource
	else
		pos.z = pos.z + self:GetBullseyeOffsetZ()
	end
	return pos
end

function INSTANCE:IsTurreted()
	typecheck.NotImplementedError()
end

--- @param targetPos Vector
--- @param doTilt boolean
--- @return boolean
function INSTANCE:SetTargeting( targetPos, doTilt )
	local returnValue = false

	-- "Don't do the targetting if we are locked on an object"
	if self.FacingObject == nil then
		returnValue = self:InternalSetTargeting( targetPos, doTilt )
	end

	return returnValue
end

--- @return number
function INSTANCE:GetWeaponHeight()
	local height = 1.62 -- "Set to be at about eye level"
	if self:IsCrouched() then
		height = height - 0.56
	end
	return height -- "Verticle offset, move to weapon"
end

--- @return number
function INSTANCE:GetWeaponLength()
	return 0.8 -- "Forward offset, move to weapon"
end

--- @param index integer
--- @return Matrix3dInstance
function INSTANCE:GetMuzzle( index )
	local muzzle = matrix3dClass.New( true )
	if self.WeaponRenderModel ~= nil then
		local trueMuzzle = self.WeaponRenderModel:GetBoneTransform( "muzzlea0" )
		local muzzlePos = trueMuzzle:GetTranslation()
		muzzle:LookAt( muzzlePos, self:GetTargetingPos(), 0 )

		if not self:IsHumanControlled() then
			-- "If the bullet is not close to going down the muzzle, force it to be"
			local toTarget = muzzle:GetXVector()
			local downMuzzle = trueMuzzle:GetXVector()
			local cos = toTarget:Dot( downMuzzle )
			if cos < math.cos( math.rad( 20 ) ) then
				muzzle = trueMuzzle
			end
		end
	end
	return muzzle
end

function INSTANCE:DetonateC4()
	typecheck.NotImplementedError()
end

--- @param modelName string?
function INSTANCE:SetWeaponModel( modelName )
	if self.WeaponRenderModel ~= nil then -- "Remove old gun model"
		if self:PeekModel() ~= nil then
			self:PeekModel():RemoveSubObject( self.WeaponRenderModel ) -- "Clean the bone"
		end
	end

	typecheck.NotImplementedError()
end

function INSTANCE:SetWeaponAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:StartTransitionAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBlendedAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:HandleLegs()
	local doSteps = false

	if self:IsOnLadder() then
		doSteps = ( self.Control:GetAnalog( controlClass.ANALOG_CONTROL.ANALOG_MOVE_FORWARD ) ~= 0.0 )
	else
		doSteps = (
			self.Control:GetAnalog( controlClass.ANALOG_CONTROL.ANALOG_MOVE_FORWARD ) ~= 0.0
			or
			self.Control:GetAnalog( controlClass.ANALOG_CONTROL.ANALOG_MOVE_LEFT ) ~= 0.0
		)
	end

	-- "Footsteps"
	typecheck.NotImplementedError()
end

function INSTANCE:ExitLadder()
	self.HumanState:SetState( humanStateTypeEnum.UPRIGHT )
end

--- @param top boolean
function INSTANCE:EnterLadder( top )
	self.HumanState:SetState( humanStateTypeEnum.LADDER )

	if self:IsHumanControlled() then
		if top then
			self.LadderUpMask = true
		else
			self.LadderDownMask = true
		end
	end
end

function INSTANCE:ImportStateCs()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportStateCs()
	typecheck.NotImplementedError()
end

function INSTANCE:InterpretScPositionData()
	typecheck.NotImplementedError()
end

function INSTANCE:InterpretScStateData()
	typecheck.NotImplementedError()
end

function INSTANCE:TallyVisVisibleSoldiers()
	typecheck.NotImplementedError()
end

function INSTANCE:IsInElevator()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportCreation()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportCreation()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportRare()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportRare()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportOccasional()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportOccasional()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportFrequent()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportFrequent()
	typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:IsDead()
	return self:GetState() == humanStateTypeEnum.DEATH
end

--- @return boolean
function INSTANCE:IsDestroyed()
	return self:GetState() == humanStateTypeEnum.DESTROY
end

--- @return boolean
function INSTANCE:IsUpright()
	return self:GetState() == humanStateTypeEnum.UPRIGHT
end

--- @return boolean
function INSTANCE:IsWounded()
	return self:GetState() == humanStateTypeEnum.WOUNDED
end

--- @return boolean
function INSTANCE:InTransition()
	return self:GetState() == humanStateTypeEnum.TRANSITION
end

--- @return boolean
function INSTANCE:IsAirborne()
	return self:GetState() == humanStateTypeEnum.AIRBORNE
end

--- @return boolean
function INSTANCE:IsCrouched()
	return self.HumanState:GetStateFlag( humanStateFlagsTypeEnum.CROUCHED_FLAG )
end

--- @return boolean
function INSTANCE:IsSniping()
	return self.HumanState:GetStateFlag( humanStateFlagsTypeEnum.SNIPING_FLAG )
end

--- @return boolean
function INSTANCE:IsSlow()
	return bit.band( self:GetSubState(), humanSubStateTypeEnum.SUB_STATE_SLOW  ) ~= 0
end

--- @return boolean
function INSTANCE:IsOnLadder()
	return self:GetState() == humanStateTypeEnum.LADDER
end

--- @return boolean
function INSTANCE:IsStateLocked()
	return self.HumanState:IsLocked()
end

--- @return boolean
function INSTANCE:IsInVehicle()
	return self:GetState() == humanStateTypeEnum.IN_VEHICLE
end

function INSTANCE:ResetLoiterDelay()
	self.HumanState:ResetLoiterDelay()
end

--- @param allowed boolean
function INSTANCE:SetLoitersAllowed( allowed )
	self.HumanState:SetLoitersAllowed( allowed )
end

function INSTANCE:GetInformation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDescription()
	typecheck.NotImplementedError()
end

function INSTANCE:ToggleFlyMode()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaxSpeed()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMaxSpeed()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTurnRate()
	typecheck.NotImplementedError()
end

function INSTANCE:EnterVehicle()
	typecheck.NotImplementedError()
end

function INSTANCE:ExitVehicle()
	typecheck.NotImplementedError()
end

function INSTANCE:ExitDestroyedVehicle()
	typecheck.NotImplementedError()
end

function INSTANCE:IsPermittedToEnterVehicle()
	typecheck.NotImplementedError()
end

--- @return VehicleGameObjectInstance
function INSTANCE:GetVehicle()
	return self.Vehicle
end

function INSTANCE:GetProfileVehicle()
	typecheck.NotImplementedError()
end

function INSTANCE:UseLadderView()
	typecheck.NotImplementedError()
end

--- @return string
function INSTANCE:GetAnimationName()
	return self.AnimationName
end

--- @return string
function INSTANCE:GetStateName()
	return self.HumanState:GetStateName()
end

--- @return HumanStateInstance
function INSTANCE:GetHumanState()
	return self.HumanState
end

--- @param modelName string
function INSTANCE:SetModel( modelName )
	self:PeekPhysicalObject():SetModelByName( modelName )
	-- "Must set thje anim control after the phys object"
	self.HumanState:SetAnimationControl( self:GetAnimationControl() --[[@as HumanAnimationControlInstance]] )
end

--- @return SoldierGameObjectInstance
function INSTANCE:AsSoldierGameObject()
	return self
end

function INSTANCE:GetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:GiveAllWeapons()
	typecheck.NotImplementedError()
end

function INSTANCE:CanSee()
	typecheck.NotImplementedError()
end

--- @param height number
--- @param width number
function INSTANCE:AdjustSkeleton( height, width )
	-- "Only adjust male skeletons"
	local renderObject = INSTANCE.PeekModel( self ) --[[@as Animatable3dObjectInstance]]
	if not renderObject or not renderObject:GetHTree() or renderObject:GetHTree():GetName():sub( 3, 3 ) ~= "A" then
		return
	end

	local treeBase, treeTall, treeWide

	if treeBase == nil then
		treeBase = ww3dAssetManagerClass.GetInstance():GetHTree( "s_a_human" )
		treeTall = ww3dAssetManagerClass.GetInstance():GetHTree( "s_a_tall" )
		treeWide = ww3dAssetManagerClass.GetInstance():GetHTree( "s_a_wide" )
	end

	if ( treeBase ~= nil ) and ( treeTall ~= nil ) and ( treeWide ~= nil ) then
		local tree = hTreeClass.CreateInterpolated( treeBase, treeTall, treeWide, height, width )
		if tree then
			renderObject:SetHTree( tree )
		end
	end
end


--[[ Head Looking ]] do

	--- @param pos Vector
	--- @param time number
	function INSTANCE:LookAt( pos, time )
		self.HeadLookTarget = pos
		self.HeadLookDuration = time
		self.HeadLookAngle = Vector( 0, 0, 0 )
	end

	--- @param pos Vector
	function INSTANCE:UpdateLookAt( pos )
		self.HeadLookTarget = pos
	end

	function INSTANCE:CancelLookAt()
		self.HeadLookDuration = 0.001
	end

	--- @param time number
	function INSTANCE:LookRandom( time )
		if time == 0 and self.HeadLookDuration ~= 0 then
			self.HeadLookDuration = 0.0001 -- "Maybe done next time..."
		else
			self.HeadLookDuration = time
		end
		self.HeadLookAngleTimer = 0
		self.HeadLookAngle = Vector( 1, 1, 1 )
	end

	--- @return boolean
	function INSTANCE:IsLooking()
		return ( self.HeadLookDuration > 0 )
	end

	--- @return Matrix3dInstance
	function INSTANCE:GetLookTransform()
		if STATIC.HeadBone ~= -1 then
			-- "Convert from CS head convention back to normal"
			local transformationMatrix = self:PeekModel():GetBoneTransform( STATIC.HeadBone )
			transformationMatrix:RotateZ( math.rad( 90 ) )
			transformationMatrix:RotateX( math.rad( 90 ) )
			return transformationMatrix
		end
		return self:GetTransform()
	end
end


--[[ Head and Facing ]] do

	--- @param gameObject PhysicalGameObjectInstance?
	--- @param turnBody boolean
	function INSTANCE:LockFacing( gameObject, turnBody )
		self.FacingObject = gameObject
		self.FacingAllowBodyTurn = turnBody

		-- "Stop facing if there's nothing to look at"
		if gameObject == nil then
			INSTANCE.CancelLookAt( self )
		end
	end
end


--[[ Innate Disabling ]] do

	--- @param bits integer? [Default: 0xFFFFFFFF]
	function INSTANCE:InnateEnable( bits )
		if bits == nil then bits = 0xFFFFFFFF end

		self.InnateEnableBits = bit.bor( self.InnateEnableBits, bits )
	end

	--- @param bits integer? [Default: 0xFFFFFFFF]
	function INSTANCE:InnateDisable( bits )
		if bits == nil then bits = 0xFFFFFFFF end

		self.InnateEnableBits = bit.band( self.InnateEnableBits, bits )
	end

	--- @param bits integer? [Default: 0xFFFFFFFF]
	function INSTANCE:IsInnateEnabled( bits )
		if bits == nil then bits = 0xFFFFFFFF end

		return bit.band( self.InnateEnableBits, bits ) ~= 0
	end
end


function INSTANCE:SayDialogue()
	typecheck.NotImplementedError()
end

function INSTANCE:StopCurrentSpeech()
	typecheck.NotImplementedError()
end

function INSTANCE:FindHeadModel()
	typecheck.NotImplementedError()
end

function INSTANCE:PrepareSpeechFramework()
	typecheck.NotImplementedError()
end

--[[ "Ghost" Support ]] do
	-- "  
	-- 'Ghosts' are soldier's who have their collision turned off so they can walk through other soldiers
	-- "  

	--- @param onOff boolean
	function INSTANCE:EnableGhostCollision( onOff )
		local physicalObject = self:PeekPhysicalObject()
		if physicalObject == nil then
			return
		end

		local isUsingGhostCollision = physicalObject:GetCollisionGroup() == collisionGroupTypeEnum.SOLDIER_GHOST_COLLISION_GROUP
		if onOff == isUsingGhostCollision then
			return
		end

		-- "Change the collision group as necessary"
		if onOff then
			physicalObject:SetCollisionGroup( collisionGroupTypeEnum.SOLDIER_GHOST_COLLISION_GROUP )
		else
			physicalObject:SetCollisionGroup( collisionGroupTypeEnum.SOLDIER_COLLISION_GROUP )
		end
	end

	function INSTANCE:IsSoldierBlocked()
		typecheck.NotImplementedError()
	end

	--- @param currentPos Vector
	function INSTANCE:IsSafeToDisableGhostCollision( currentPos )
		local personalSpaceBoxSize = Vector( 1.5, 1.5, 1 ) * unitConversionLib.MetersToSource
		local humanHalfHeight = 1.0 * unitConversionLib.MetersToSource

		-- "Build a box that represents the 'personal' space around the soldier"
		local boxPos = currentPos + Vector( 0, 0, humanHalfHeight )
		-- local box = aABoxClass.New( boxPos, personalSpaceBoxSize )

		-- Omitting most of this function as it relies on the physics scene system and
		-- I don't currently know if I want to implement that or work around it.
		-- For now, I'm going to try to do a hacky little replacement
		local traceResult = util.TraceHull( {
			start  = boxPos,
			endpos = boxPos,
			mins   = -personalSpaceBoxSize / 2,
			maxs   =  personalSpaceBoxSize / 2,
			filter = self:GetConnectedEntity()
		} )
		return traceResult.Hit
	end
end

--- @return DynamicSpeechAnimationInstance
function INSTANCE:GetFacialAnimation()
	return self.SpeechAnimation
end

function INSTANCE:SetEmotIcon()
	typecheck.NotImplementedError()
end

function INSTANCE:GetInnateController()
	typecheck.NotImplementedError()
end

--- @return SoldierAiState
function INSTANCE:GetAiState()
	return self.AiState
end

function INSTANCE:SetAiState()
	typecheck.NotImplementedError()
end

--- @param observer SoldierObserverInstance
function INSTANCE:SetInnateObserver( observer )
	self.InnateObserver = observer
end

--- @return SoldierObserverInstance
function INSTANCE:GetInnateObserver()
	return self.InnateObserver
end

function INSTANCE:ClearInnateObserver()
	self.InnateObserver = nil
end

--- @return string
function INSTANCE:GetFirstPersonHandsModelName()
	return self:GetDefinition().FirstPersonHands
end

--- @param maxPerturb number? [Default: 5]
function INSTANCE:PerturbPosition( maxPerturb )
	if maxPerturb == nil then maxPerturb = 5 end

	typecheck.NotImplementedError()
end

function INSTANCE:GetKeyRing()
	return self.KeyRing
end

--- @param keyNumber integer
function INSTANCE:GiveKey( keyNumber )
	self.KeyRing = bit.bor( self.KeyRing, bit.lshift( 1, keyNumber ) )
end

--- @param keyNumber integer
function INSTANCE:RemoveKey( keyNumber )
	self.KeyRing = bit.band( self.KeyRing, bit.bnot( bit.lshift( 1, keyNumber ) ) )
end

--- @param keyNumber integer
--- @return boolean
function INSTANCE:HasKey( keyNumber )
	return bit.band( bit.lshift( 1, keyNumber ), self.KeyRing ) ~= 0
end

function INSTANCE:WantsPowerups()
	return self:IsHumanControlled()
end

--- @return boolean
function INSTANCE:AllowSpecialDamageStateLock()
	return ( self:IsHumanControlled() == false )
end

--- @return boolean
function INSTANCE:IsVisible()
	return self._IsVisible
end

--- @param visible boolean
function INSTANCE:SetIsVisible( visible )
	self._IsVisible = visible
end

function INSTANCE:IsTargetable()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStealthFadeDistance()
	typecheck.NotImplementedError()
end

--- @return HumanStateType
function INSTANCE:GetState()
	return self.HumanState:GetState()
end

--- @return integer
function INSTANCE:GetSubState()
	return self.HumanState:GetSubState()
end

function INSTANCE:UpdateLockedFacing()
	if self.FacingObject ~= nil then
		-- "Get the position of the object we're 'looking' at."
		local pos = self.FacingObject:GetPosition()

		-- "If the object is a soldier, then look at his head"
		if self.FacingObject:AsPhysicalGameObject():AsSoldierGameObject() ~= nil then
			local SOLDIER_HEIGHT = 1.7
			pos.z = pos.z + SOLDIER_HEIGHT
		end

		-- "Look at the object"
		self:LookAt( pos, 100.0 )

		-- "If we can turn to face the object, do so..."
		if self.FacingAllowBodyTurn then
			self:InternalSetTargeting( pos, false )
		end
	end
end

function INSTANCE:UpdateBackGun()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBackWeaponModel()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBackFlagModel()
	typecheck.NotImplementedError()
end

--- @param direction Vector
--- @param collisionBoxName string
--- @return integer
function INSTANCE:GetOuchType( direction, collisionBoxName )
	return self.HumanState:GetOuchType( direction, collisionBoxName )
end

--- @param targetPos Vector
--- @param doTilt boolean
--- @return boolean
function INSTANCE:InternalSetTargeting( targetPos, doTilt )
	-- Omitted skeleton slider demo

	smartGameObjectClass.Instance.SetTargeting( self, targetPos )

	if (   self:GetState() == humanStateTypeEnum.DEATH
		or self:GetState() == humanStateTypeEnum.DESTROY
		or self:GetState() == humanStateTypeEnum.TRANSITION
		or self:GetState() == humanStateTypeEnum.LADDER
	) then
		return false
	end

	if self:GetState() == humanStateTypeEnum.IN_VEHICLE then
		if self.Vehicle ~= nil then
			if self.Vehicle:GetDriverIsGunner() then
				if self.Vehicle:GetDriver() == self then
					self.Vehicle:SetTargeting( targetPos )
				end
			else
				if self.Vehicle:GetDriver() == self and self.Vehicle:GetGunner() == nil then
					self.Vehicle:SetTargeting( targetPos )
				elseif self.Vehicle:GetGunner() == self then
					self.Vehicle:SetTargeting( targetPos )
				end
			end
		end
		return false
	end

	local muzzlePos = self:GetPosition()
	muzzlePos.z = muzzlePos.z + self:GetWeaponHeight()
	local relativeTargetPos = targetPos - muzzlePos

	-- "Set Tilt"
	local distance = relativeTargetPos:Length()
	local tilt = 0
	if tobool( distance ) and doTilt then
		tilt = math.asin( relativeTargetPos.z / distance )
	end

	local isComplete = true

	-- "Set Facing"
	local currentFacing = self:PeekHumanPhysics():GetHeading()
	local facing = wWMathClass.Atan2( relativeTargetPos.y, relativeTargetPos.x )
	local facingDifference = facing - currentFacing
	if math.abs( facingDifference ) > 0.01 then
		facingDifference = wWMathClass.Wrap( facingDifference, math.rad( -180.0 ), math.rad( 180.0 ) )

		local change = facingDifference
		if not self:IsHumanControlled() then
			typecheck.NotImplementedError()
		end

		-- "Human players don't use turn anims"
		if not self:IsHumanControlled() then
			-- "Play the leg turning anim"
			self.HumanState:SetTurnVelocity( change )
		end

		-- "Are we facing?"
		isComplete = ( change == facingDifference )

		facing = currentFacing + change
		facing = wWMathClass.Wrap( facing, math.rad( -180 ), math.rad( 180 ) )
		self:PeekHumanPhysics():SetHeading( facing )
	end

	if self:IsHumanControlled() and self:GetState() ~= humanStateTypeEnum.IN_VEHICLE then
		local direction = -1
		if self:GetWeapon() and self:GetWeapon():IsReloading() then
			direction = 1
		end

		self.ReloadingTilt = self.ReloadingTilt + direction * FrameTime() * STATIC.TILT_DOWN_SPEED
		self.ReloadingTilt = math.Clamp( self.ReloadingTilt, 0, 1 )

		if self.ReloadingTilt > 0 then
			tilt = Lerp( tilt, math.rad( -90 ), self.ReloadingTilt )
		end
	end

	self.HumanState:UpdateAiming( tilt, 0 ) -- "No turn"

	return isComplete
end

function INSTANCE:SetSpecialDamageMode()
	typecheck.NotImplementedError()
end

function INSTANCE:HandleHeadLook()
	if self:PeekModel():GetHTree() == nil then
		return
	end

	-- "Get the head bone"
	if STATIC.HeadBone == -1 or STATIC.NeckBone == -1 then
		STATIC.HeadBone = self:PeekModel():GetBoneIndex( "C HEAD" )
		STATIC.NeckBone = self:PeekModel():GetBoneIndex( "C NECK" )
		assert( STATIC.HeadBone ~= -1 )
		assert( STATIC.NeckBone ~= -1 )
	end

	if self.HeadLookDuration > 0 then
		local frameTime = FrameTime()
		self.HeadLookDuration = self.HeadLookDuration - frameTime

		-- "Should we be returning to look ahead?"
		local returning = self.HeadLookDuration < 0

		local desiredHeadRotation = Vector( 0, 0, 0 )
		if not returning then
			if self.HeadLookAngle:Length() > 0.001 then
				self.HeadLookAngleTimer = self.HeadLookAngleTimer - frameTime
				if self.HeadLookAngleTimer < 0 then
					self.HeadLookAngle = Vector(
						math.Rand( -STATIC.HEAD_TURN_LIMIT, STATIC.HEAD_TURN_LIMIT ),
						math.Rand( -STATIC.HEAD_TILT_LIMIT, STATIC.HEAD_TILT_LIMIT ),
						0
					)
				end
				self.HeadLookAngleTimer = math.Rand( 2, 5 )
			else
				-- "Get the transform that has been used to modify the head bone..."
				local hTree = self:PeekModel():GetHTree()
				assert( hTree ~= nil )

				local boneControlTransformationMatrix = hTree:GetBoneControl( STATIC.HeadBone )

				-- "Get the inverse of the head-bone transform"
				local inverseBoneControlTransformationMatrix = boneControlTransformationMatrix:GetOrthogonalInverse()

				-- "Get the head to world and neck to world transforms"
				local currentHead = self:PeekModel():GetBoneTransform( STATIC.HeadBone )
				local currentNeck = self:PeekModel():GetBoneTransform( STATIC.NeckBone )

				-- "Strip off the control transform from last frame"
				currentHead = currentHead * inverseBoneControlTransformationMatrix

				-- "Get the world to neck transform"
				local worldToNeckTransformationMatrix = currentNeck:GetOrthogonalInverse()

				-- "Build a head to neck transform"
				local headToNeckTransformationMatrix = worldToNeckTransformationMatrix * currentHead

				-- "Get the target relative to the head"
				local relativeHeadTarget = matrix3dClass.InverseTransformVector( currentHead, self.HeadLookTarget )

				-- "
				-- Determine the 'twist' and lookup/down angles.
				-- Note: Currently in the head bone coordinate system, the X axis is the same
				-- as the Z axis in object space, the Y axis is the same as the X axis in object space,
				-- and the Z axis is the same as the Y axis in object space.
				-- "
				desiredHeadRotation.x = wWMathClass.Atan2( relativeHeadTarget.z, relativeHeadTarget.y )
				desiredHeadRotation.z = -math.asin( relativeHeadTarget.x / relativeHeadTarget:Length() )
				desiredHeadRotation.y = 0

				-- "
				-- Determine how far to allow the character to turn and tilt his/her head.
				-- These boundaries are based on the "absolute" amount the person can turn
				-- their head, this has to take into consideration the amount that the current
				-- animation is turning the head and the amount we need to turn to look at the target.
				-- "
				local tempVector = headToNeckTransformationMatrix:GetYVector()
				local currentRotationX = math.atan2( tempVector.z, tempVector.y )
				local currentRotationZ = math.atan2( tempVector.x, tempVector.y )

				local minTwist = -STATIC.HEAD_TURN_LIMIT - currentRotationX
				local maxTwist =  STATIC.HEAD_TURN_LIMIT - currentRotationX

				local minTilt = -STATIC.HEAD_TILT_LIMIT - currentRotationZ
				local maxTilt =  STATIC.HEAD_TILT_LIMIT - currentRotationZ

				-- "Clamp the rotations"
				desiredHeadRotation.x = math.Clamp( desiredHeadRotation.x, minTwist, maxTwist )
				desiredHeadRotation.z = math.Clamp( desiredHeadRotation.z, minTilt, maxTilt )
			end
		end

		local maxTurn = STATIC.HEAD_TURN_RATE * frameTime
		local maxTilt = STATIC.HEAD_TILT_RATE * frameTime
		self.HeadRotation.x = self.HeadRotation.x + math.Clamp( desiredHeadRotation.x - self.HeadRotation.x, -maxTurn, maxTurn )
		self.HeadRotation.z = self.HeadRotation.z + math.Clamp( desiredHeadRotation.z - self.HeadRotation.z, -maxTilt, maxTilt )

		local head = matrix3dClass.New( true )
		head:RotateX( self.HeadRotation.x )
		head:RotateZ( self.HeadRotation.z )
		if not self:PeekModel():IsBoneCaptured( STATIC.HeadBone ) then
			self:PeekModel():CaptureBone( STATIC.HeadBone )
		end
		assert( self:PeekModel():IsBoneCaptured( STATIC.HeadBone ) )
		if self:PeekModel():IsBoneCaptured( STATIC.HeadBone ) then
			self:PeekModel():ControlBone( STATIC.HeadBone, head )
		end

		self.HeadRotation.z = 0
		if returning and self.HeadRotation:Length() > 0.001 then
			self.HeadLookDuration = 0.0001 -- "Maybe done next time..."
		end
	end
end

--- @param obj RenderObjectInstance
function INSTANCE:AddRenderObject( obj )
	table.insert( self.RenderObjectList, obj )
end

--- @param name string
--- @return RenderObjectInstance?
function INSTANCE:FindRenderObject( name )
	for _, v in pairs( self.RenderObjectList ) do
		if v:GetName() == name then
			return v
		end
	end
end

function INSTANCE:ResetRenderObjects()
	self.RenderObjectList = {}
end

function INSTANCE:UpdateHealingEffect()
	if self.HealingEffect ~= nil then
		if
			self.HealingEffect:GetTargetParameter() >= 0.49 and
			self.HealingEffect:GetParameter() >= 0.49
		then
			self.HealingEffect:SetTargetParameter( 0 )
		end

		if
			self.HealingEffect:GetTargetParameter() == 0 and
			self.HealingEffect:GetParameter() == 0
		then
			self:PeekHumanPhysics():RemoveEffectFromMe( self.HealingEffect )
		end
	end
end

function INSTANCE:Check()
	typecheck.NotImplementedError()
end
