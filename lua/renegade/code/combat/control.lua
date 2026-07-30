-- Based on ControlClass within Code/Combat/control.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ControlClass
--- @field Instance ControlInstance The metatable used by ControlInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ControlClass"

--- @class ControlInstance
--- @field Static ControlClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Control" )
INSTANCE.Class = "ControlInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsControl = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ControlClass

    --- Creates a new ControlInstance
    --- @return ControlInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Control" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ControlInstance, `false` otherwise
    function STATIC.IsControl( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsControl and true or false
    end

    typecheck.RegisterType( "ControlInstance", STATIC.IsControl )

	function STATIC.SetPrecision()
		typecheck.NotImplementedError()
	end
end


--- @class ControlInstance
--- @field OneTimeBooleanBits any
--- @field PendingOneTimeBooleanBits any
--- @field ContinuousBooleanBits any
--- @field PendingContinuousBooleanBits any
--- @field ] any

function INSTANCE:Renegade_Control()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_Control()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:ClearControl()
	typecheck.NotImplementedError()
end

function INSTANCE:ClearBoolean()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBoolean()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBoolean()
	typecheck.NotImplementedError()
end

function INSTANCE:ClearOneTimeBoolean()
	typecheck.NotImplementedError()
end

function INSTANCE:GetOneTimeBooleanBits()
	typecheck.NotImplementedError()
end

function INSTANCE:GetContinuousBooleanBits()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnalog()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAnalog()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportCs()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportCs()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportSc()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportSc()
	typecheck.NotImplementedError()
end
