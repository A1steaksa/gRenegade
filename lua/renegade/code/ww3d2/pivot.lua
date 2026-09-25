-- Based on PivotClass within Code/ww3d2/pivot.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class PivotClass
--- @field Instance PivotInstance The metatable used by PivotInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PivotClass"

--- @class PivotInstance
--- @field Static PivotClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Pivot" )
INSTANCE.Class = "PivotInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPivot = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type Matrix3dClass
	local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PivotClass

    --- Creates a new PivotInstance
    --- @return PivotInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Pivot" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PivotInstance, `false` otherwise
    function STATIC.IsPivot( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPivot and true or false
    end

    typecheck.RegisterType( "PivotInstance", STATIC.IsPivot )
end

--- "Each node of the hierarchy tree is represented by a [PivotInstance]."
--- @class PivotInstance
--- @field Name string
--- @field Index integer
--- @field Parent PivotInstance
--- @field BaseTransform Matrix3dInstance "Base-pose transform (relative to parent)."
--- @field Transform Matrix3dInstance "Computed transform for this pivot"
--- @field IsVisible boolean "Result of the visibility channel"
--- @field IsCaptured boolean "When a pivot is 'captured' animation data is ignored and the user data is used to control the pivot."
--- @field CapTransform Matrix3dInstance
--- @field WorldSpaceTranslation boolean

--- "Constructor for PivotClass"
function INSTANCE:Renegade_Pivot()
    self.Index = 0
    self.Parent = nil
    self.BaseTransform = matrix3dClass.New( true )
    self.Transform = matrix3dClass.New( true )
    self.IsVisible = true
    self.IsCaptured = false
    self.CapTransform = matrix3dClass.New( true )
    self.WorldSpaceTranslation = false
end

function INSTANCE:_Renegade_Pivot()
    -- Empty in the original code
end

function INSTANCE:CaptureUpdate()
    if self.WorldSpaceTranslation then
        -- "The Translation of CapTransform is meant to be in world space, so remove before applying orientation"
        local capOrientation = matrix3dClass.New( self.CapTransform )
        capOrientation:SetTranslation( Vector( 0, 0, 0 ) )
        self.Transform = self.Transform * capOrientation
        -- "Now apply translation in world space"
        self.Transform:AdjustTranslation( self.CapTransform:GetTranslation() )
    else
        self.Transform = self.Transform * self.CapTransform
    end
end
