-- Based on AnimChannelClass within Code/Combat/animcontrol.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class AnimationChannelClass
--- @field Instance AnimationChannelInstance The metatable used by AnimationChannelInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AnimationChannelClass"

--- @class AnimationChannelInstance
--- @field Static AnimationChannelClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AnimationChannel" )
INSTANCE.Class = "AnimationChannelInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAnimationChannel = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class AnimationChannelClass

    --- Creates a new AnimationChannelInstance
    --- @return AnimationChannelInstance
    function STATIC.New()
        return robustclass.New( "Renegade_AnimationChannel" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AnimationChannelInstance, `false` otherwise
    function STATIC.IsAnimationChannel( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAnimationChannel and true or false
    end

    typecheck.RegisterType( "AnimationChannelInstance", STATIC.IsAnimationChannel )
end


--- @class AnimationChannelInstance
--- @field Animation any
--- @field Frame any
--- @field NumFrames any
--- @field TargetFrame any
--- @field Mode any

function INSTANCE:Renegade_AnimationChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_AnimationChannel()
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

function INSTANCE:PeekAnimation()
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

function INSTANCE:SetFrame()
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

function INSTANCE:Update()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAnimationData()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateModel()
	typecheck.NotImplementedError()
end
