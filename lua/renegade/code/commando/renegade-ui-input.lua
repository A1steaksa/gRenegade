-- Based on RenegadeUIInputClass within Code/Commando/renegadedialogmgr.cpp/h
-- Based also on WWUIInputClass within Code/wwui/wwuiinput.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class RenegadeUIInputClass
--- @field instance RenegadeUIInputInstance The metatable used by RenegadeUIInputInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "RenegadeUIInputClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class RenegadeUIInputInstance
--- @field Static RenegadeUIInputClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_RenegadeUIInput" )
INSTANCE.Class = "RenegadeUIInputInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.RenegadeUIInput = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class RenegadeUIInputClass

    --- Creates a new RenegadeUIInputInstance
    --- @return RenegadeUIInputInstance
    function STATIC.New()
        return robustclass.New( "Renegade_RenegadeUIInput" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) RenegadeUIInputInstance, `false` otherwise
    function STATIC.IsRenegadeUIInput( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsRenegadeUIInput and true or false
    end

    typecheck.RegisterType( "RenegadeUIInputInstance", STATIC.IsRenegadeUIInput )
end


--[[
    Note to maintainers:
    This class inherits from WWUIInputClass in the original code but that base class is only used in this class
    so I'm going to ignore it and just put that functionality here instead.
--]]

--- @class RenegadeUIInputInstance
--- @field MousePos Vector I don't think this variable actually does anything, but I'm including it in case I'm wrong

--- @return Vector
function INSTANCE:GetMousePos()
    local mouseX, mouseY = input.GetCursorPos()
    -- Omitted scroll wheel position
    self.MousePos = Vector( mouseX, mouseY, 0 )

    return self.MousePos
end

--- @param pos Vector
function INSTANCE:SetMousePos( pos )
    self.MousePos = pos
    input.SetCursorPos( pos.x, pos.y )
end

--- @param buttonId MOUSE
--- @return boolean
function INSTANCE:IsButtonDown( buttonId )
    local returnValue = false

    -- In the original code this is converting between a "VK" mouse button ID and a DirectInput BUTTON_MOUSE_* enum

    if buttonId == MOUSE_LEFT then
        returnValue = input.IsMouseDown( MOUSE_LEFT )
    elseif buttonId == MOUSE_MIDDLE then
        returnValue = input.IsMouseDown( MOUSE_MIDDLE )
    elseif buttonId == MOUSE_RIGHT then
        returnValue = input.IsMouseDown( MOUSE_RIGHT )
    end

    return returnValue
end

function INSTANCE:EnterMenuMode()
    typecheck.NotImplementedError()
end

function INSTANCE:ExitMenuMode()
    typecheck.NotImplementedError()
end

