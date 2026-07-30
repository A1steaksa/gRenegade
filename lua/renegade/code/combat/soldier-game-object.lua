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
--#endregion

--#region Imported Enums

	local specialDamageTypeEnum = armorWarheadManagerClass.SPECIAL_DAMAGE_TYPE
	local soldierAiStateEnum = actionParamsStructClass.SOLDIER_AI_STATE
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class SoldierGameObjectClass
	--- @field DisplayDebugBoxForGhostCollision boolean
	--- @field SoldierGameObjectPersistFactory SimplePersistFactoryInstance

	STATIC.DisplayDebugBoxForGhostCollision = false

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

		section.Warn( "Soldier Static Constructor Ran!" )

		STATIC.SoldierGameObjectPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CHUNKID_GAME_OBJECT_SOLDIER )
	end

	function STATIC.SayDynamicDialogue()
		typecheck.NotImplementedError()
	end

	function STATIC.EnableGhostCollisionDebugDisplay()
		typecheck.NotImplementedError()
	end

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
--- @field FacingObject GameObjectInstance
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
	self.WeaponAnimControl = nil
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
	self.SpeechAnim = nil
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
	self.HumanState:Init( INSTANCE.PeekHumanPhysics( self ) )
	-- "Must set the anim control after the phys object"
	self.HumanState:SetAnimationControl( INSTANCE.GetAnimationControl( self ) --[[@as HumanAnimationControlInstance]] )

	if INSTANCE.GetDefinition( self ).HumanAnimationOverrideDefinitionID ~= 0 then
		self.HumanState:SetHumanAnimationOverride( INSTANCE.GetDefinition( self ).HumanAnimationOverrideDefinitionID )
	end

	if INSTANCE.GetDefinition( self ).HumanLoiterCollectionDefinitionID ~= 0 then
		self.HumanState:SetHumanLoiterCollection( INSTANCE.GetDefinition( self ).HumanLoiterCollectionDefinitionID )
	end

	INSTANCE.AdjustSkeleton( self, definition.SkeletonHeight, definition.SkeletonWidth )

end

--- @param definition SoldierGameObjectDefinitionInstance
function INSTANCE:ReInit( definition )
	typecheck.NotImplementedError()
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
	section.Print( "Spaghetto: '", INSTANCE.PeekPhysicalObject( self ), "'" )

	return INSTANCE.PeekPhysicalObject( self ):AsHumanPhysics()
end

function INSTANCE:Think()
	typecheck.NotImplementedError()
end

function INSTANCE:PostThink()
	typecheck.NotImplementedError()
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

function INSTANCE:GetBullseyePosition()
	typecheck.NotImplementedError()
end

function INSTANCE:IsTurreted()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTargeting()
	typecheck.NotImplementedError()
end

function INSTANCE:GetWeaponHeight()
	typecheck.NotImplementedError()
end

function INSTANCE:GetWeaponLength()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMuzzle()
	typecheck.NotImplementedError()
end

function INSTANCE:DetonateC4()
	typecheck.NotImplementedError()
end

function INSTANCE:SetWeaponModel()
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
	typecheck.NotImplementedError()
end

function INSTANCE:ExitLadder()
	typecheck.NotImplementedError()
end

function INSTANCE:EnterLadder()
	typecheck.NotImplementedError()
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

function INSTANCE:IsDead()
	typecheck.NotImplementedError()
end

function INSTANCE:IsDestroyed()
	typecheck.NotImplementedError()
end

function INSTANCE:IsUpright()
	typecheck.NotImplementedError()
end

function INSTANCE:IsWounded()
	typecheck.NotImplementedError()
end

function INSTANCE:InTransition()
	typecheck.NotImplementedError()
end

function INSTANCE:IsAirborne()
	typecheck.NotImplementedError()
end

function INSTANCE:IsCrouched()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSniping()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSlow()
	typecheck.NotImplementedError()
end

function INSTANCE:IsOnLadder()
	typecheck.NotImplementedError()
end

function INSTANCE:IsStateLocked()
	typecheck.NotImplementedError()
end

function INSTANCE:IsInVehicle()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetLoiterDelay()
	typecheck.NotImplementedError()
end

function INSTANCE:SetLoitersAllowed()
	typecheck.NotImplementedError()
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

function INSTANCE:GetVehicle()
	typecheck.NotImplementedError()
end

function INSTANCE:GetProfileVehicle()
	typecheck.NotImplementedError()
end

function INSTANCE:UseLadderView()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAnimationName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStateName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetHumanState()
	typecheck.NotImplementedError()
end

function INSTANCE:SetModel()
	typecheck.NotImplementedError()
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

function INSTANCE:LookAt()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateLookAt()
	typecheck.NotImplementedError()
end

function INSTANCE:CancelLookAt()
	typecheck.NotImplementedError()
end

function INSTANCE:LookRandom()
	typecheck.NotImplementedError()
end

function INSTANCE:IsLooking()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLookTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:LockFacing()
	typecheck.NotImplementedError()
end

function INSTANCE:InnateEnable()
	typecheck.NotImplementedError()
end

function INSTANCE:InnateDisable()
	typecheck.NotImplementedError()
end

function INSTANCE:IsInnateEnabled()
	typecheck.NotImplementedError()
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

function INSTANCE:EnableGhostCollision()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSoldierBlocked()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSafeToDisableGhostCollision()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFacialAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetEmotIcon()
	typecheck.NotImplementedError()
end

function INSTANCE:GetInnateController()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAiState()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAiState()
	typecheck.NotImplementedError()
end

function INSTANCE:SetInnateObserver()
	typecheck.NotImplementedError()
end

function INSTANCE:GetInnateObserver()
	typecheck.NotImplementedError()
end

function INSTANCE:ClearInnateObserver()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFirstPersonHandsModelName()
	typecheck.NotImplementedError()
end

function INSTANCE:PerturbPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetKeyRing()
	typecheck.NotImplementedError()
end

function INSTANCE:GiveKey()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveKey()
	typecheck.NotImplementedError()
end

function INSTANCE:HasKey()
	typecheck.NotImplementedError()
end

function INSTANCE:WantsPowerups()
	return INSTANCE.IsHumanControlled( self )
end

function INSTANCE:AllowSpecialDamageStateLock()
	typecheck.NotImplementedError()
end

function INSTANCE:IsVisible()
	typecheck.NotImplementedError()
end

function INSTANCE:SetIsVisible()
	typecheck.NotImplementedError()
end

function INSTANCE:IsTargetable()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStealthFadeDistance()
	typecheck.NotImplementedError()
end

function INSTANCE:GetState()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSubState()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateLockedFacing()
	typecheck.NotImplementedError()
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

function INSTANCE:GetOuchType()
	typecheck.NotImplementedError()
end

function INSTANCE:InternalSetTargeting()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSpecialDamageMode()
	typecheck.NotImplementedError()
end

function INSTANCE:HandleHeadLook()
	typecheck.NotImplementedError()
end

function INSTANCE:AddRenderObject()
	typecheck.NotImplementedError()
end

function INSTANCE:FindRenderObject()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetRenderObjs()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateHealingEffect()
	typecheck.NotImplementedError()
end

function INSTANCE:Check()
	typecheck.NotImplementedError()
end
