-- Based on PointerRemapClass within Code/wwsaveload/pointerremap.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class PointerRemapClass
--- @field Instance PointerRemapInstance The metatable used by PointerRemapInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PointerRemapClass"

--- @class PointerRemapInstance
--- @field Static PointerRemapClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PointerRemap" )
INSTANCE.Class = "PointerRemapInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPointerRemap = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PointerRemapClass

    --- Creates a new PointerRemapInstance
    --- @return PointerRemapInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PointerRemap" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PointerRemapInstance, `false` otherwise
    function STATIC.IsPointerRemap( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPointerRemap and true or false
    end

    typecheck.RegisterType( "PointerRemapInstance", STATIC.IsPointerRemap )

	function STATIC.PtrPairCompareFunction()
		typecheck.NotImplementedError()
	end

	function STATIC.PtrRequestCompareFunction()
		typecheck.NotImplementedError()
	end
end

--- @class PointerRemapInstance
--- @field PointerMap {[integer]: table}

function INSTANCE:Renegade_PointerRemap()
    self.PointerMap = {}
end

function INSTANCE:_Renegade_PointerRemap()
    -- Empty in the original code
end

function INSTANCE:Reset()
    self.PointerMap = {}
end

function INSTANCE:Process()
	typecheck.NotImplementedError()
end

--- @param oldPointer integer
--- @param newPointer table
function INSTANCE:RegisterPointer( oldPointer, newPointer )
	self.PointerMap[oldPointer] = newPointer
end

--- @param oldPointer integer
--- @return table
function INSTANCE:RequestPointerRemap( oldPointer )
    local newPointer = self.PointerMap[oldPointer]
    if newPointer == nil then
        section.Error( "Unable to remap unregistered old pointer '", oldPointer, "'" )
    end
    --- @cast newPointer table
    return newPointer
end

function INSTANCE:RequestRefCountedPointerRemap()
	typecheck.NotImplementedError()
end

function INSTANCE:ProcessRequestTable()
	typecheck.NotImplementedError()
end
