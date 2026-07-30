-- Based on HAnimComboClass within Code/ww3d2/hanim.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class HAnimationComboClass
--- @field Instance HAnimationComboInstance The metatable used by HAnimationComboInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HAnimationComboClass"

--- @class HAnimationComboInstance
--- @field Static HAnimationComboClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HAnimationCombo" )
INSTANCE.Class = "HAnimationComboInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHAnimationCombo = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type HAnimationComboDataClass
	local hAnimationComboDataClass = CNC.Import( "code/ww3d2/h-animation-combo-data.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HAnimationComboClass

    --- Creates a new HAnimationComboInstance
	--- @param animationCount integer?
    --- @return HAnimationComboInstance
    function STATIC.New( animationCount )
        return robustclass.New( "Renegade_HAnimationCombo", animationCount )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HAnimationComboInstance, `false` otherwise
    function STATIC.IsHAnimationCombo( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHAnimationCombo and true or false
    end

    typecheck.RegisterType( "HAnimationComboInstance", STATIC.IsHAnimationCombo )
end


--- @class HAnimationComboInstance
--- @field HAnimationComboData any

--- @param animationCount integer?
function INSTANCE:Renegade_HAnimationCombo( animationCount )
	-- ()
	if animationCount == nil then
		return
	end

	-- ( animationCount: integer )
	typecheck.AssertArgType( INSTANCE.Class, 1, animationCount, "number" )

	self.HAnimationComboData = {}
	for i = 1, animationCount do
		self.HAnimationComboData[i] = hAnimationComboDataClass.New()
	end
end

function INSTANCE:_Renegade_HAnimationCombo()
	typecheck.NotImplementedError()
end

function INSTANCE:Clear()
	typecheck.NotImplementedError()
end

function INSTANCE:Reset()
	typecheck.NotImplementedError()
end

function INSTANCE:NormalizeWeights()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumAnims()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMotion()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMotion()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekMotion()
	typecheck.NotImplementedError()
end

function INSTANCE:SetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPrevFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPrevFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:SetWeight()
	typecheck.NotImplementedError()
end

function INSTANCE:GetWeight()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPivotWeightMap()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPivotWeightMap()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekPivotWeightMap()
	typecheck.NotImplementedError()
end

function INSTANCE:AppendAnimationComboData()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveAnimationComboData()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekAnimationComboData()
	typecheck.NotImplementedError()
end
