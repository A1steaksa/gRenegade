-- This is a library for registering and hotloading VGUI tool windows

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ToolsLib
local STATIC = CNC.CreateExport()
STATIC.Class = "ToolsLib"

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

if not CLIENT then return end

--- @class ToolsLib
--- @field OpenRegistered { [string]: fun( previousState: any ): HotloadableDFrame }
--- @field OpenFrames { [string]: HotloadableDFrame }

function STATIC.StaticConstructor()
    STATIC.RegisteredTools = {}
    STATIC.OpenFrames = {}

    --- @class HotloadableDFrame : DFrame
    --- @field ExportState fun( self: HotloadableDFrame ): any
    local PANEL = vgui.Register( "HotloadableDFrame", {}, "DFrame" )
    function PANEL:ExportState()
    end
end

--- @param consoleCommand string
--- @return boolean
function STATIC.IsToolOpen( consoleCommand )
    local openFrame = STATIC.OpenFrames[consoleCommand]
    return openFrame ~= nil and openFrame ~= NULL
end

--- @param consoleCommand string
function STATIC.RegisterTool( consoleCommand, openFunc )

    local isHotload = STATIC.IsToolOpen( consoleCommand )

    local previousState
    if isHotload then
        previousState = STATIC.CloseTool( consoleCommand )
    end

    concommand.Add( consoleCommand, function()
        STATIC.OpenTool( consoleCommand )
    end )

    STATIC.RegisteredTools[consoleCommand] = openFunc

    if isHotload then
        STATIC.OpenTool( consoleCommand, previousState )
    end
end

--- @param consoleCommand string
--- @return HotloadableDFrame
function STATIC.GetToolFrame( consoleCommand )
    return STATIC.OpenFrames[consoleCommand]
end

--- @param consoleCommand string
--- @param previousState any?
function STATIC.OpenTool( consoleCommand, previousState )
    local openFunc = STATIC.RegisteredTools[consoleCommand]

    if not isfunction( openFunc ) then
        section.Error( "Unable to open tool with concommand '", consoleCommand, "'" )
    end


    STATIC.OpenFrames[consoleCommand] = openFunc( previousState )
end

--- Retrieves a tool's export state before closing it
--- @param consoleCommand string
--- @return any # The exported previous state
function STATIC.CloseTool( consoleCommand )
    local oldFrame = STATIC.OpenFrames[consoleCommand]

    local previousState
    if IsValid( oldFrame ) then
        previousState = oldFrame:ExportState()
        oldFrame:Close()
    end

    return previousState
end