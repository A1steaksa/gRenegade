-- Based on HAnimComboDataClass within Code/ww3d2/hanim.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class HAnimationComboDataClass
--- @field Instance HAnimationComboDataInstance The metatable used by HAnimationComboDataInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HAnimationComboDataClass"

--- @class HAnimationComboDataInstance
--- @field Static HAnimationComboDataClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HAnimationComboData" )
INSTANCE.Class = "HAnimationComboDataInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHAnimationComboData = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type HAnimationClass
	local hAnimationClass = CNC.Import( "code/ww3d2/h-animation.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HAnimationComboDataClass

    --- Creates a new HAnimationComboDataInstance
    --- @return HAnimationComboDataInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HAnimationComboData" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HAnimationComboDataInstance, `false` otherwise
    function STATIC.IsHAnimationComboData( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHAnimationComboData and true or false
    end

    typecheck.RegisterType( "HAnimationComboDataInstance", STATIC.IsHAnimationComboData )
end


--- "  
--- The HAnimComboDataClass is used by the new HAnimComboClass to allow for a mix of shared/unshared data
--- which will allow us to have the anim combo refer to data whereever we wish to put it.  
--- "  
--- @class HAnimationComboDataInstance
--- @field HAnimation HAnimationInstance
--- @field Frame number
--- @field PreviousFrame number
--- @field Weight number
--- @field PivotMap PivotMapInstance
--- @field Shared boolean

--- @param shared boolean? [Default: `false`]
--- @overload fun( src: HAnimationComboDataInstance )
function INSTANCE:Renegade_HAnimationComboData( shared )
	if shared == nil then shared = false end

	-- ( shared: boolean? )
	if typecheck.IsOfType( shared, "boolean" ) then

		self.Shared = shared
		self.HAnimation = hAnimationClass.New()
		self.PivotMap = pivotMapClass.New( 0 )
		self.Frame = 0
		self.PreviousFrame = 0
		self.Weight = 1

		return
	end

	-- ( src: HAnimationComboDataInstance )
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_HAnimationComboData()
	typecheck.NotImplementedError()
end

function INSTANCE:Copy()
	typecheck.NotImplementedError()
end

function INSTANCE:Clear()
	typecheck.NotImplementedError()
end

function INSTANCE:SetHAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:GiveHAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPrevFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:SetWeight()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPivotMap()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekHAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetHAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPrevFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetWeight()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekPivotMap()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPivotMap()
	typecheck.NotImplementedError()
end

function INSTANCE:IsShared()
	typecheck.NotImplementedError()
end

function INSTANCE:BuildActivePivotMap()
	typecheck.NotImplementedError()
end
