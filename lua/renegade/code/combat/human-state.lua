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
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HumanStateClass

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
--- @field StateLocked any
--- @field State any
--- @field StateTimer any
--- @field StateFlags any
--- @field SubState any
--- @field WeaponHoldStyle any
--- @field WeaponHoldTimer any
--- @field LoitersAllowed any
--- @field LoiterDelay any
--- @field AimingTilt any
--- @field AimingTurn any
--- @field HumanPhysics any
--- @field AnimationControl any
--- @field TurnVelocity any
--- @field LegRotation any
--- @field JumpTM any
--- @field RecoilTimer any
--- @field RecoilScale any
--- @field NoAnimationBlend any
--- @field WeaponFired any
--- @field HumanAnimationOverride any
--- @field HumanLoiterCollection any

function INSTANCE:Renegade_HumanState()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_HumanState()
	typecheck.NotImplementedError()
end

function INSTANCE:Init()
	typecheck.NotImplementedError()
end

function INSTANCE:Reset()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimationControl()
	typecheck.NotImplementedError()
end

function INSTANCE:SetHumanAnimationOverride()
	typecheck.NotImplementedError()
end

function INSTANCE:SetHumanLoiterCollection()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:SetState()
	typecheck.NotImplementedError()
end

function INSTANCE:GetState()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStateName()
	typecheck.NotImplementedError()
end

function INSTANCE:IsStateInterruptable()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSubState()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSubState()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSubStateAdjustable()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStateTimer()
	typecheck.NotImplementedError()
end

function INSTANCE:SetStateTimer()
	typecheck.NotImplementedError()
end

function INSTANCE:ToggleStateFlag()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStateFlag()
	typecheck.NotImplementedError()
end

function INSTANCE:DropWeapon()
	typecheck.NotImplementedError()
end

function INSTANCE:RaiseWeapon()
	typecheck.NotImplementedError()
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

function INSTANCE:SetTurnVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateWeapon()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateAiming()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateState()
	typecheck.NotImplementedError()
end

function INSTANCE:PostThink()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:IsLocked()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLegMode()
	typecheck.NotImplementedError()
end

function INSTANCE:GetOuchType()
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

function INSTANCE:UpdateRecoil()
	typecheck.NotImplementedError()
end

function INSTANCE:BeginJump()
	typecheck.NotImplementedError()
end

function INSTANCE:CompleteJump()
	typecheck.NotImplementedError()
end
