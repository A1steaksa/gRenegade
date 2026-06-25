-- Based on HRawAnimClass within Code/ww3d2/hrawanim.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type HAnimationClass
local hAnimationClass = CNC.Import( "code/ww3d2/h-animation.lua" )

--- @class HRawAnimationClass : HAnimationClass
--- @field Instance HRawAnimationInstance The metatable used by HRawAnimationInstance
local STATIC = CNC.CreateExport( hAnimationClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HRawAnimationClass"

--- @class HRawAnimationInstance : HAnimationInstance
--- @field Static HRawAnimationClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HRawAnimation : Renegade_HAnimation" )
INSTANCE.Class = "HRawAnimationInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHRawAnimation = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HRawAnimationClass

    --- Creates a new HRawAnimationInstance
    --- @return HRawAnimationInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HRawAnimation" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HRawAnimationInstance, `false` otherwise
    function STATIC.IsHRawAnimation( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHRawAnimation and true or false
    end

    typecheck.RegisterType( "HRawAnimationInstance", STATIC.IsHRawAnimation )
end

--- @class NodeMotionStruct
--- @field X MotionChannelInstance
--- @field Y MotionChannelInstance
--- @field Z MotionChannelInstance
--- @field XR MotionChannelInstance
--- @field YR MotionChannelInstance
--- @field ZR MotionChannelInstance
--- @field Q MotionChannelInstance
--- @field Visibility BitChannelInstance

--- @class HRawAnimationInstance
--- @field Name string
--- @field HierarchyName string
--- @field NumFrames integer
--- @field NumNodes integer
--- @field FrameRate number
--- @field NodeMotion NodeMotionStruct

function INSTANCE:Renegade_HRawAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_HRawAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadW3d()
	typecheck.NotImplementedError()
end

function INSTANCE:GetName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetHName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumFrames()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFrameRate()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTotalTime()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTranslation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetOrientation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVisibility()
	typecheck.NotImplementedError()
end

function INSTANCE:IsNodeMotionPresent()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumPivots()
	typecheck.NotImplementedError()
end

function INSTANCE:HasXTranslation()
	typecheck.NotImplementedError()
end

function INSTANCE:HasYTranslation()
	typecheck.NotImplementedError()
end

function INSTANCE:HasZTranslation()
	typecheck.NotImplementedError()
end

function INSTANCE:HasRotation()
	typecheck.NotImplementedError()
end

function INSTANCE:HasVisibility()
	typecheck.NotImplementedError()
end

function INSTANCE:Free()
	typecheck.NotImplementedError()
end

function INSTANCE:ReadChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:AddChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:ReadBitChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:AddBitChannel()
	typecheck.NotImplementedError()
end
