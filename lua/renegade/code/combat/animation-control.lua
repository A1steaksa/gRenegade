-- Based on AnimControlClass within Code/Combat/animcontrol.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class AnimationControlClass
--- @field Instance AnimationControlInstance The metatable used by AnimationControlInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AnimationControlClass"

--- @class AnimationControlInstance
--- @field Static AnimationControlClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AnimationControl" )
INSTANCE.Class = "AnimationControlInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAnimationControl = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class AnimationControlClass

    --- Creates a new AnimationControlInstance
    --- @return AnimationControlInstance
    function STATIC.New()
        return robustclass.New( "Renegade_AnimationControl" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AnimationControlInstance, `false` otherwise
    function STATIC.IsAnimationControl( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAnimationControl and true or false
    end

    typecheck.RegisterType( "AnimationControlInstance", STATIC.IsAnimationControl )
end


--- @class AnimationControlInstance
--- @field Model RenderObjectInstance?

function INSTANCE:Renegade_AnimationControl()
	self.Model = nil
end

function INSTANCE:_Renegade_AnimationControl()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
function INSTANCE:Load( cload )
	typecheck.NotImplementedError()
end

--- @param animationModel RenderObjectInstance?
function INSTANCE:SetModel( animationModel )
	self.Model = animationModel
end

--- @return RenderObjectInstance
function INSTANCE:PeekModel()
	return self.Model
end

--- @param animation string|HAnimationInstance|nil
--- @param blendTime number? [Default: `0.0`]
--- @param startFrame number? [Default: `0.0`]
function INSTANCE:SetAnimation( animation, blendTime, startFrame )
	typecheck.NotImplementedError()
end

--- @param mode AnimationControlAnimationMode
--- @param frame number? [Default: -1]
function INSTANCE:SetMode( mode, frame )
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

function INSTANCE:PeekAnimation()
	typecheck.NotImplementedError()
end

--- @param deltaTime number
function INSTANCE:Update( deltaTime )
	typecheck.NotImplementedError()
end
