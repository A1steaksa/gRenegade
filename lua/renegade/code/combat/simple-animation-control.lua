-- Based on SimpleAnimControlClass within Code/Combat/animcontrol.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type AnimationControlClass
local animationControlClass = CNC.Import( "code/combat/animation-control.lua" )

--- @class SimpleAnimationControlClass : AnimationControlClass
--- @field Instance SimpleAnimationControlInstance The metatable used by SimpleAnimationControlInstance
local STATIC = CNC.CreateExport( animationControlClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SimpleAnimationControlClass"

--- @class SimpleAnimationControlInstance : AnimationControlInstance
--- @field Static SimpleAnimationControlClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SimpleAnimationControl : Renegade_AnimationControl" )
INSTANCE.Class = "SimpleAnimationControlInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSimpleAnimationControl = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class SimpleAnimationControlClass

    --- Creates a new SimpleAnimationControlInstance
    --- @return SimpleAnimationControlInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SimpleAnimationControl" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SimpleAnimationControlInstance, `false` otherwise
    function STATIC.IsSimpleAnimationControl( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSimpleAnimationControl and true or false
    end

    typecheck.RegisterType( "SimpleAnimationControlInstance", STATIC.IsSimpleAnimationControl )
end


--- @class SimpleAnimationControlInstance
--- @field Channel any

function INSTANCE:Renegade_SimpleAnimationControl()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_SimpleAnimationControl()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
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

function INSTANCE:SetTargetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTargetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCurrentFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:Update()
	typecheck.NotImplementedError()
end
