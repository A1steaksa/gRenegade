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
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class SoldierGameObjectClass
		--- @field DisplayDebugBoxForGhostCollision any

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
--- @field DetonateC4 boolean
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
--- @field AiState SoldierAiStateInstance
--- @field SpeechAnimation DynamicSpeechAnimationInstance
--- @field GenerateIdleFacialAnimationTimer number
--- @field HeadModel RenderObjectInstance
--- @field EmotIconModel RenderObjectInstance
--- @field EmotIconTimer number
--- @field InFlyMode boolean
--- @field IsVisible boolean
--- @field LadderUpMask boolean
--- @field LadderDownMask boolean
--- @field ReloadingTilt number
--- @field WeaponChanged boolean
--- @field WaterWake PersistantSurfaceEmitterInstance
--- @field RenderObjectList RenderObjectInstance[]

function INSTANCE:Renegade_SoldierGameObject()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_SoldierGameObject()
	typecheck.NotImplementedError()
end

function INSTANCE:Init()
	typecheck.NotImplementedError()
end

function INSTANCE:CopySettings()
	typecheck.NotImplementedError()
end

function INSTANCE:ReInit()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDefinition()
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

function INSTANCE:GetFactory()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekHumanPhysics()
	typecheck.NotImplementedError()
end

function INSTANCE:Think()
	typecheck.NotImplementedError()
end

function INSTANCE:PostThink()
	typecheck.NotImplementedError()
end

function INSTANCE:SetControlOwner()
	typecheck.NotImplementedError()
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

function INSTANCE:AsSoldierGameObject()
	typecheck.NotImplementedError()
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

function INSTANCE:AdjustSkeleton()
	typecheck.NotImplementedError()
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
	typecheck.NotImplementedError()
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
