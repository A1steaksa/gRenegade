-- Based on DialogParserClass within Code/wwui/dialogparser.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DialogParserClass
local STATIC = CNC.CreateExport()
STATIC.Class = "DialogParserClass"
local isHotload = not table.IsEmpty( STATIC )

--#region Exported Enums

     --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum ControlType
    STATIC.CONTROL_TYPE = {
        Button             = enumBuilder:Set( 0x0080 ),
        Edit               = enumBuilder:Next(),
        Static             = enumBuilder:Next(),
        ListBox            = enumBuilder:Next(),
        ScrollBar          = enumBuilder:Next(),
        ComboBox           = enumBuilder:Next(),
        Slider             = enumBuilder:Next(),
        ListControl        = enumBuilder:Next(),
        Tab                = enumBuilder:Next(),
        Map                = enumBuilder:Next(),
        Viewer             = enumBuilder:Next(),
        Hotkey             = enumBuilder:Next(),
        ShortcutBar        = enumBuilder:Next(),
        MerchandiseControl = enumBuilder:Next(),
        TreeControl        = enumBuilder:Next(),
        ProgressBar        = enumBuilder:Next(),
        HealthBar          = enumBuilder:Next(),
    }
    local controlTypeEnum = STATIC.CONTROL_TYPE
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion

--[[
    Note to maintainers:
    The parsing logic here is going to necessarily differ quite a lot from the original C++
--]]

--- @class DialogParserClass

STATIC.ResourceFilePath = "renegade/game.res"

local function SkipDialogField( )
end

--- @param resourceId integer
--- @return integer dialogWidth, integer dialogHeight, string dialogTitle, ControlDefinitionInstance[] controlList
function STATIC.ParseTemplate( resourceId )
    -- "Load the resource file"
    local resource = file.Open( STATIC.ResourceFilePath, "rb", "THIRDPARTY" )
    if not resource then
        Section.Error( "Unable to open resource file: ", STATIC.ResourceFilePath )
    end

    local resourceBuffer = resource:Read()
    if not resourceBuffer or string.len( resourceBuffer ) == 0 then
        Section.Error( "Resource file appears to be empty: ", STATIC.ResourceFilePath )
    end

    -- "The first few bytes of the resource buffer are the DLGTEMPLATE structure"
    local dialogTemplate = 


end

concommand.Add( "ren_test", function()
    STATIC.ParseTemplate( 128 )
end )