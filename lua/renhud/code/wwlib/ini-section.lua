-- Based on INISection within Code/wwlib/inisup.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class IniSectionClass
--- @field instance IniSectionInstance The metatable used by IniSectionInstance
local STATIC = CNC.CreateExport()
local CLASS = "IniSectionInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class IniSectionInstance
--- @field Static IniSectionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_IniSection" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsIniSection = true


--[[ Static Functions and Variables ]] do

    --- @class IniSectionClass

    --- Creates a new IniSectionInstance
    --- @param section string
    --- @return IniSectionInstance
    function STATIC.New( section )
        return robustclass.New( "Renegade_IniSection", section )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) IniSectionInstance, `false` otherwise
    function STATIC.IsIniSection( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsIniSection and true or false
    end

    typecheck.RegisterType( "IniSectionInstance", STATIC.IsIniSection )
end

--- "Each section (bracketed) is represented by an object of this type. All entries subordinate to this section are attached."
--- @class IniSectionInstance
--- @field Section string
--- @field EntryList table<string, IniEntryInstance> A map of entry names to IniEntryInstance

--- Constructs a new IniSectionInstance
    --- @param section string
function INSTANCE:Renegade_IniSection( section )
    self.Section = section
    self.EntryList = {}
end

--- "Finds a specified entry and returns pointer to it"
--- > "  
--- > This routine scans the supplied entry for the section specified.
--- > This is used for internal database maintenance.  
--- > "  
--- @param entry string "The entry to scan for."
--- @return IniEntryInstance? "Returns with a [reference] to the entry control structure if the entry was found.  Otherwise it returns [nil]"
function INSTANCE:FindEntry( entry )
    return self.EntryList[entry]
end
