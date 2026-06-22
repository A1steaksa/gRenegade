-- Based on HumanAnimControlClass within Code/Combat/animcontrol.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type AnimationControlClass
local animationControlClass = CNC.Import( "code/combat/animation-control.lua" )

--- @class HumanAnimationControlClass : AnimationControlClass
--- @field Instance HumanAnimationControlInstance The metatable used by HumanAnimationControlInstance
local STATIC = CNC.CreateExport( animationControlClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HumanAnimationControlClass"

--- @class HumanAnimationControlInstance : AnimationControlInstance
--- @field Static HumanAnimationControlClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HumanAnimationControl : Renegade_AnimationControl" )
INSTANCE.Class = "HumanAnimationControlInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHumanAnimationControl = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HumanAnimationControlClass

    --- Creates a new HumanAnimationControlInstance
    --- @return HumanAnimationControlInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HumanAnimationControl" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HumanAnimationControlInstance, `false` otherwise
    function STATIC.IsHumanAnimationControl( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHumanAnimationControl and true or false
    end

    typecheck.RegisterType( "HumanAnimationControlInstance", STATIC.IsHumanAnimationControl )
end


--- @class HumanAnimationControlInstance
--- @field Channel1 any
--- @field Channel2 any
--- @field Channel2rAtio any
--- @field AnimationSpeedScale any
--- @field DataList any
--- @field AnimationCombo any
--- @field Skeleton any

function INSTANCE:Renegade_HumanAnimationControl()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_HumanAnimationControl()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:SetModel()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMode()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMode()
	typecheck.NotImplementedError()
end

function INSTANCE:IsComplete()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAnimationName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetProgress()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTargetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTargetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCurrentFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimationSpeedScale()
	typecheck.NotImplementedError()
end

function INSTANCE:Update()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetInformation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSkeleton()
	typecheck.NotImplementedError()
end

function INSTANCE:BuildSkeletonAnimationName()
	typecheck.NotImplementedError()
end
