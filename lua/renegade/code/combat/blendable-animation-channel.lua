-- Based on BlendableAnimChannelClass within Code/Combat/animcontrol.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class BlendableAnimationChannelClass
--- @field Instance BlendableAnimationChannelInstance The metatable used by BlendableAnimationChannelInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BlendableAnimationChannelClass"

--- @class BlendableAnimationChannelInstance
--- @field Static BlendableAnimationChannelClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BlendableAnimationChannel" )
INSTANCE.Class = "BlendableAnimationChannelInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBlendableAnimationChannel = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class BlendableAnimationChannelClass

    --- Creates a new BlendableAnimationChannelInstance
    --- @return BlendableAnimationChannelInstance
    function STATIC.New()
        return robustclass.New( "Renegade_BlendableAnimationChannel" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BlendableAnimationChannelInstance, `false` otherwise
    function STATIC.IsBlendableAnimationChannel( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBlendableAnimationChannel and true or false
    end

    typecheck.RegisterType( "BlendableAnimationChannelInstance", STATIC.IsBlendableAnimationChannel )
end


--- @class BlendableAnimationChannelInstance
--- @field NewChannel any
--- @field OldChannel any
--- @field BlendTimer any
--- @field BlendTotal any

function INSTANCE:Renegade_BlendableAnimationChannel()
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

function INSTANCE:PeekAnimation()
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

function INSTANCE:GetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetProgress()
	typecheck.NotImplementedError()
end
