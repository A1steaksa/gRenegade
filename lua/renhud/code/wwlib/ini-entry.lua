-- Based on INIEntry within Code/wwlib/inisup.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class IniEntryClass
--- @field instance IniEntryInstance The metatable used by IniEntryInstance
local STATIC = CNC.CreateExport()
local CLASS = "IniEntryInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class IniEntryInstance
--- @field Static IniEntryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_IniEntry" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsIniEntry = true


--[[ Static Functions and Variables ]] do

    --- @class IniEntryClass

    --- Creates a new IniEntryInstance
    --- @param entry string?
    --- @param value string?
    --- @return IniEntryInstance
    --- @return IniEntryInstance
    function STATIC.New( entry, value )
        return robustclass.New( "Renegade_IniEntry", entry, value )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) IniEntryInstance, `false` otherwise
    function STATIC.IsIniEntry( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsIniEntry and true or false
    end

    typecheck.RegisterType( "IniEntryInstance", STATIC.IsIniEntry )
end

--- "The value entries for the INI file are stored as objects of this type."
--- "The entry identifier and value string are combined into this object."
--- @class IniEntryInstance
--- @field Entry string?
--- @field Value string?

--- Constructs a new IniEntryInstance
--- @param entry string?
--- @param value string?
function INSTANCE:Renegade_IniEntry( entry, value )
    self.Entry = entry
    self.Value = value
end