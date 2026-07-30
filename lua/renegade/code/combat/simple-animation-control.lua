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

	--- @type BlendableAnimationChannelClass
	local blendableAnimationChannelClass = CNC.Import( "code/combat/blendable-animation-channel.lua" )
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
--- @field Channel BlendableAnimationChannelInstance

function INSTANCE:Renegade_SimpleAnimationControl()
    animationControlClass.Instance.Renegade_AnimationControl( self )

    self.Channel = blendableAnimationChannelClass.New()

    -- Empty in the original code
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

--- @param animation string|HAnimationInstance
--- @param blendTime number? [Default: `0.0`]
--- @param startFrame number? [Default: `0.0`]
function INSTANCE:SetAnimation( animation, blendTime, startFrame )
    if blendTime == nil then blendTime = 0.0 end
    if startFrame == nil then startFrame = 0.0 end

    self.Channel:SetAnimation( animation, blendTime, startFrame )
end

--- @param mode AnimationControlAnimationMode
--- @param frame number? [Default: -1]
function INSTANCE:SetMode( mode, frame )
    if frame == nil then frame = -1 end

	self.Channel:SetMode( mode, frame )
end

function INSTANCE:GetMode()
	typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:IsComplete()
    return self.Channel:IsComplete()
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

--- @param deltaTime number
function INSTANCE:Update( deltaTime )
    self.Channel:Update( deltaTime )

    -- "Setup the model for the current frame(s)"
    assert( self.Model ~= nil )

    self.Channel:UpdateModel( self.Model )
end
