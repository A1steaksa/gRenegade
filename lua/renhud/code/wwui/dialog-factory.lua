-- Based on DialogFactoryClass and DialogFactoryBaseClass within Code/wwui/dialogfactory.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DialogFactoryClass
--- @field instance DialogFactoryInstance The metatable used by DialogFactoryInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "DialogFactoryClass"
local isHotload = not table.IsEmpty( STATIC )

--- Only included because this class exists in the original code
--- and I don't want to discard it entirely as worthless
--- @class DialogFactoryBaseInstance
--- @field DoDialog fun()

--- @class DialogFactoryInstance : DialogFactoryBaseInstance
--- @field Static DialogFactoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DialogFactory" )
INSTANCE.Class = "DialogFactoryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDialogFactory = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion

--[[
    Notes to maintainers:
    This class is a complete mess because the original code is short but confusing.
    It's either using a factory pattern with a base class for a good reason I don't understand
    or It's doing those things for no reason.  I do not know which.
    
    As far as I can tell, it SHOULD take DialogBaseClass as its class argument, but that doesn't
    exist anywhere in the original code for DialogFactory.
    I'm going to include DialogBaseClass as the type for the class argument and hope it works out.
--]]

--[[ Static Functions and Variables ]] do

    --- @class DialogFactoryClass

    --- The template data stored prior to instantiation
    --- @class DialogFactoryTemplateData
    --- @field Class any
    STATIC.TemplateData = {}

    --- Creates a new DialogFactoryInstance
    --- @param class DialogBaseClass
    --- @vararg any
    --- @return DialogFactoryInstance
    function STATIC.New( class )
        STATIC.TemplateData = {
            Class = class
        }

        return robustclass.New( "Renegade_DialogFactory" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DialogFactoryInstance, `false` otherwise
    function STATIC.IsDialogFactory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDialogFactory and true or false
    end

    typecheck.RegisterType( "DialogFactoryInstance", STATIC.IsDialogFactory )
end


--- @class DialogFactoryInstance
--- @field _Class DialogBaseClass

--- Constructs a new DialogFactoryInstance
--- @vararg any
function INSTANCE:Renegade_DialogFactory()
    self._Class = STATIC.TemplateData.Class
end

function INSTANCE:DoDialog()
-- Children of DialogBaseClass won't have constructor arguments but they will provide them when calling the DialogBaseClass constructor
---@diagnostic disable-next-line: missing-parameter
    local dialog = self._Class.New()
    dialog:StartDialog()
end
