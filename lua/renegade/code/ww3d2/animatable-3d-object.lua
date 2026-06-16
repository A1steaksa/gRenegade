-- Based on Animatable3dObjectClass within Code/ww3d2/animobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type CompositeRenderObjectClass
local compositeRenderObjectClass = CNC.Import( "code/ww3d2/composite-render-object.lua" )

--- @class Animatable3dObjectClass : CompositeRenderObjectClass
--- @field Instance Animatable3dObjectInstance The metatable used by Animatable3dObjectInstance
local STATIC = CNC.CreateExport( compositeRenderObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "Animatable3dObjectClass"

--- @class Animatable3dObjectInstance : CompositeRenderObjectInstance
--- @field Static Animatable3dObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Animatable3dObject : Renegade_CompositeRenderObject" )
INSTANCE.Class = "Animatable3dObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAnimatable3dObject = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class Animatable3dObjectClass

    --- Creates a new Animatable3dObjectInstance
    --- @return Animatable3dObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Animatable3dObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) Animatable3dObjectInstance, `false` otherwise
    function STATIC.IsAnimatable3dObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAnimatable3dObject and true or false
    end

    typecheck.RegisterType( "Animatable3dObjectInstance", STATIC.IsAnimatable3dObject )
end


--- @class Animatable3dObjectInstance
--- @field IsTreeValid boolean
--- @field HTree any
--- @field CurMotionMode any

--- @param src Animatable3dObjectInstance?
--- @overload fun( self:Animatable3dObjectInstance, hTreeName: string )
function INSTANCE:Renegade_Animatable3dObject( src )
	typecheck.AssertArgType( self.Class, 1, src, { "string", "Animatable3dObjectInstance" } )

	-- ( hTreeName: string )
	if isstring( src ) then
		compositeRenderObjectClass.Instance.Renegade_CompositeRenderObject( self )

		typecheck.NotImplementedError()

	-- ( src: Animatable3dObjectInstance )
	else
		compositeRenderObjectClass.Instance.Renegade_CompositeRenderObject( self, src )

		self.IsTreeValid = false
		self.CurMotionMode = motionModeEnum.BASE_POSE
		self.HTree = nil

		typecheck.NotImplementedError()
	end
end

function INSTANCE:_Renegade_Animatable3dObject()
	typecheck.NotImplementedError()
end

function INSTANCE:Render()
	typecheck.NotImplementedError()
end

function INSTANCE:SpecialRender()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:IsAnimationComplete()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumBones()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBoneName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBoneIndex()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBoneTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:CaptureBone()
	typecheck.NotImplementedError()
end

function INSTANCE:ReleaseBone()
	typecheck.NotImplementedError()
end

function INSTANCE:IsBoneCaptured()
	typecheck.NotImplementedError()
end

function INSTANCE:ControlBone()
	typecheck.NotImplementedError()
end

function INSTANCE:GetHTree()
	typecheck.NotImplementedError()
end

function INSTANCE:SimpleEvaluateBone()
	typecheck.NotImplementedError()
end

function INSTANCE:SetHTree()
	typecheck.NotImplementedError()
end

function INSTANCE:ComputeCurrentFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateSubObjectTransforms()
	typecheck.NotImplementedError()
end

function INSTANCE:BaseUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:AnimationUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:BlendUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:ComboUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:IsHierarchyValid()
	typecheck.NotImplementedError()
end

function INSTANCE:SetHierarchyValid()
	typecheck.NotImplementedError()
end

function INSTANCE:SingleAnimationProgress()
	typecheck.NotImplementedError()
end

function INSTANCE:Release()
	typecheck.NotImplementedError()
end
