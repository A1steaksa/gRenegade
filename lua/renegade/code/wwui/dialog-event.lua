-- Based on DialogEvent within Code/wwui/dialogbase.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class DialogEventClass
--- @field Instance DialogEventInstance The metatable used by DialogEventInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DialogEventClass"

--- @class DialogEventInstance
--- @field Static DialogEventClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DialogEvent" )
INSTANCE.Class = "DialogEventInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDialogEvent = true

--#region Exported Enums
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum DialogEventID
    STATIC.DIALOG_EVENT_ID = {
        STARTED     = enumBuilder:Set( 1 ),
        DESTROYED   = enumBuilder:Next(),
        ACTIVATED   = enumBuilder:Next(),
        DEACTIVATED = enumBuilder:Next(),
    }
    local dialogEventIdEnum = STATIC.DIALOG_EVENT_ID
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class DialogEventClass

    --- Creates a new DialogEventInstance
    --- @param event DialogEventID
    --- @param dialog DialogBaseInstance
    --- @return DialogEventInstance
    function STATIC.New( event, dialog )
        return robustclass.New( "Renegade_DialogEvent", event, dialog )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DialogEventInstance, `false` otherwise
    function STATIC.IsDialogEvent( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDialogEvent and true or false
    end

    typecheck.RegisterType( "DialogEventInstance", STATIC.IsDialogEvent )
end


--- @class DialogEventInstance
--- @field Event DialogEventID
--- @field Dialog DialogBaseInstance

--- @return DialogEventID
function INSTANCE:GetEventID()
    return self.Event
end

--- @param event DialogEventID
--- @param dialog DialogBaseInstance
function INSTANCE:Renegade_DialogEvent( event, dialog )
    self.Event = event
    self.Dialog = dialog

    -- Note: Added Dialog field because I do not understand how TypedEventPtr<DialogEvent, DialogBaseClass>( dialog ) works
end
