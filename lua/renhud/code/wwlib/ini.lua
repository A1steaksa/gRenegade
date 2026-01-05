-- Based on INIClass within Code/wwlib/ini.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- "This is an INI database handler class. It handles a database with a disk format identical to the INI files commonly used by Windows."
--- @class IniClass
--- @field instance IniInstance The metatable used by IniInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "IniClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class IniInstance
--- @field Static IniClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Ini" )
INSTANCE.Class = "IniInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsIni = true


--#region Exported Enums

    --- @enum IntegerFormat
    STATIC.INTEGER_FORMAT = {
        PLAIN_DECIMAL      = 0,
        HEX_TRAILING_H     = 1,
        HEX_LEADING_DOLLAR = 2,
    }
    local integerFormatEnum = STATIC.INTEGER_FORMAT
--#endregion


--#region Imports

    --- @type IniEntryClass
    local iniEntryClass = CNC.Import( "renhud/code/wwlib/ini-entry.lua" )

    --- @type IniSectionClass
    local iniSectionClass = CNC.Import( "renhud/code/wwlib/ini-section.lua" )
--#endregion


--[[
Porting Notes:
* I'm re-writing the majority of this class's logic to use Lua tables instead of the CRC-based lookup they originally used.
* I'm also re-writing most, if not all, of the string parsing because they used C++ nonsense that doesn't work in Lua and
  I wouldn't really want to use their methods anyway given that they're gross and I hate them.
--]]

--[[ Static Functions and Variables ]] do

    --- @class IniClass
    --- @field private _KeepBlankEntries boolean "The flag used to control the blank entry loading behavior."

    --- Creates a new IniInstance
    --- @overload fun(): IniInstance
    --- @overload fun( file: File ): IniInstance
    --- @overload fun( filePath: string ): IniInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Ini", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) IniInstance, `false` otherwise
    function STATIC.IsIni( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsIni and true or false
    end

    typecheck.RegisterType( "IniInstance", STATIC.IsIni )

    --- > "  
    --- > This setting allows you to control the behavior of loading blank entries.
    --- > If you set this to true, a blank entry (ie. "foo=") will be loaded with
    --- > a value of " ". If set to false, blank entries will be ignored.
    --- > The default behavior is to ignore blank entries.
    --- > This is a static method, because in general this is an application-level
    --- > decision as opposed to a per-ini file decision.
    --- > "  
    --- @param shouldKeepBlanks boolean
    function STATIC.KeepBlankEntries( shouldKeepBlanks )
        STATIC._KeepBlankEntries = shouldKeepBlanks
    end


    --- "Strips comments of the specified text line."
    --- > "  
    --- > This routine will scan the string (text line) supplied and if any comment portions are
    --- > found, they will be trimmed off. Leading and trailing blanks are also removed.  
    --- > "  
    --- @param buffer string
    --- @return string
    function STATIC.StripComments( buffer )
        local commentStartIndex = ( buffer:find( ";" ) )
        if commentStartIndex ~= nil then
            buffer = buffer:sub( 1, commentStartIndex )
            buffer = buffer:Trim()
        end

        return buffer
    end
end

--- "This is an INI database handler class. It handles a database with a disk format identical to the INI files commonly used by Windows."
--- @class IniInstance
--- @field private Filename string "The name of the file we were loaded from (if applicable)."
--- @field private SectionList table<string,IniSectionInstance> A map of section names to IniSectionInstance

local MAX_LINE_LENGTH = 512

--- Constructs a new IniInstance
--- @overload fun()
--- @overload fun( file: File )
--- @overload fun( filePath: string )
function INSTANCE:Renegade_Ini( ... )
    local args = { ... }
    local argCount = select( "#", ... )

    typecheck.AssertArgCount( INSTANCE.Class, argCount, { 0, 1 } )

    -- ()
    if argCount == 0 then
        self.Filename = ""
        self:Initialize()
        return
    end

    if argCount == 1 then
        local arg1 = args[1]

        typecheck.AssertArgType( INSTANCE.Class, 1, arg1, { "string", "file" } )

        -- ( filePath: string )
        if typecheck.IsOfType( arg1, "string" ) then
            --- @cast arg1 string

            self.Filename = ""
            self:Initialize()

            local openFile = file.Open( arg1, "r", "THIRDPARTY" )
            if openFile then
                self:Load( arg1 )
            end

            return
        end

        -- ( openFile: File )
        if typecheck.IsOfType( arg1, "file" ) then
            --- @cast arg1 File

            self.Filename = ""
            self:Initialize()

            self:Load( arg1 )

            return
        end
    end
end

function INSTANCE:Initialize()
    self.SectionList = {}
    self.Filename = "<unknown>"
end

--[[ Fetch and Store INI Data ]] do

    --- Loosely determines if a given string is in the format: [section_title]
    --- @param line string The line to check
    --- @return boolean
    local function IsSectionHeader( line )
        local closingBracketIndex = ( line:find( "]" ) )
        return line:StartsWith( "[" ) and closingBracketIndex ~= nil
    end

    --- "Load INI data from the file specified."
    --- @overload fun( self: IniInstance, fileToLoad: File ): boolean
    --- @overload fun( self: IniInstance, filePath: string ): boolean
    function INSTANCE:Load( arg )
        typecheck.AssertArgType( INSTANCE.Class, 1, arg, { "file", "string" } )

        -- I'm combining the File and Straw implementations a bit as Garry's Mod has some overlap between them

        --- @type File
        local openFile

        -- ( file: File ): boolean
        if typecheck.IsOfType( arg, "file" ) then
            --- @cast arg File
            openFile = arg

        -- ( file: string ): boolean
        else
            --- @cast arg string
            self.Filename = arg
            openFile = file.Open( arg, "r", "THIRDPARTY" ) --[[@as File]]
        end

        --- @type string
        local buffer

        -- "Prescan until the first section is found."
        while not openFile:EndOfFile() do
            buffer = openFile:ReadLine()
            if openFile:EndOfFile() then return false end

            if IsSectionHeader( buffer ) then
                break
            end
        end

        while not openFile:EndOfFile() do
            -- "Fetch the section name."
            -- "Preserve it while the section's entries and being parsed."
            -- Omitted original logic
            local closingBracketIndex = ( buffer:find( "]" ) ) - 1
            local section = buffer:sub( 2, closingBracketIndex ):Trim()

            -- "Read in the entries of this section"
            while not openFile:EndOfFile() do
                -- "
                -- If this line is the start of another section, then bail out of the
                -- entry loop and let the outer section loop take care of it
                -- "
                buffer = openFile:ReadLine()
                if IsSectionHeader( buffer ) then
                    break
                end

                -- "Determine if this line is a comment or blank line.  Throw it out if it is."
                buffer = STATIC.StripComments( buffer )
                if buffer:len() == 0 or buffer:StartsWith( ";" ) or buffer:StartsWith( "=" ) then
                    continue
                end

                -- "The line isn't an obvious comment."
                -- "Make sure that there is the "=" character at an appropriate spot"
                local dividerIndex = ( buffer:find( "=" ) )
                if not dividerIndex then
                    continue
                end

                -- "
                -- Split the line into entry and value sections. Be sure to catch the
                -- "=foobar" and "foobar=" cases. "=foobar" lines are ignored, while 
                -- "foobar=" lines are might be stored as having " " as their value,
                -- depending on the value of [_KeepBlankEntries]
                -- "
                buffer = buffer:Trim()
                local splitBuffer = buffer:Split( "=" ) --[[ @as string[] ]]
                local entry = splitBuffer[1]
                local value = splitBuffer[2]

                if not value or value:len() == 0 then
                    if STATIC._KeepBlankEntries then
                        value = " "
                    else
                        continue
                    end
                end

                local storedSuccessfully = self:PutString( section, entry, value )
                if not storedSuccessfully then
                    return false
                end
            end
        end
    end

    --- @param file File | string
    --- @return integer
    function INSTANCE:Save( file )
        typecheck.NotImplementedError()
    end
end

--- @return string "Returns the name of the INI file (if available - \"\<unknown\>\" otherwise)"
function INSTANCE:GetFilename()
    return self.Filename
end

--- "Clears out a section (or all sections) of the INI data."
--- > "  
--- > This routine is used to clear out the section specified. If no section is specified,
--- > then the entire INI data is cleared out. Optionally, this routine can be used to clear
--- > out just an individual entry in the specified section.  
--- > "  
--- @param sectionName string? [Default: Clear all sections] ""...the section to clear out"
--- @param entryName string? [Default: Clear all entries in section(s)] "...optional entry specifier."
--- > "  
--- > If this parameter is specified,
--- > then only this specific entry (if found) will be cleared. Otherwise,
--- > the entire section specified will be cleared.  
--- > "   
--- @return boolean # Always returns `true`
function INSTANCE:Clear( sectionName, entryName )
    if not sectionName then
        self.SectionList = {}

        self.Filename = "<unknown>"
    else
        local section = self:FindSection( sectionName )
        if section then
            if entryName then
                -- Remove the specified entry
                section.EntryList[entryName] = nil
            else
                -- If no entry was specified, remove this entire section
                self.SectionList[sectionName] = nil
            end
        end
    end

    return true
end

--- @return boolean
function INSTANCE:IsLoaded()
    return table.IsEmpty( self.SectionList )
end

--- @return integer
function INSTANCE:Size()
    -- This function appears to not be implemented in the original game either.
    typecheck.NotImplementedError()
end

--- @param section string
---@param entry string
function INSTANCE:IsPresent( section, entry )
    if not entry then
        return ( self:FindSection( section ) ~= nil )
    end

    return ( self:FindEntry( section, entry ) ~= nil )
end

--- "Fetch the number of sections in the INI file..."
--- @return integer
function INSTANCE:SectionCount()
    return table.Count( self.SectionList )
end

--- "...verify if a specific section is present."
--- @param section string
--- @return boolean
function INSTANCE:SectionPresent( section )
    return self:FindSection( section ) ~= nil
end

--- "Fetches the number of entries in a specified section."
--- > "  
--- > This routine will examine the section specified and return with the number of entries associated with it.  
--- > "  
--- @param sectionName string "...the section that will be examined."  
--- @return integer "Returns with the number entries in the specified section." Returns `0` if the section does not exist.
function INSTANCE:EntryCount( sectionName )
    local section = self:FindSection( sectionName )
    if not section then return 0 end
    return table.Count( section.EntryList )
end

--- "Get the entry identifier name given ordinal number and section name."
--- > "  
--- > This will return the identifier name for the entry under the section specified. The
--- > ordinal number specified is used to determine which entry to retrieve. The entry
--- > identifier is the text that appears to the left of the "=" character.  
--- > "  
--- @param sectionName string
--- @param index integer
--- @return string?
function INSTANCE:GetEntry( sectionName, index )
    local section = self:FindSection( sectionName )
    if not section then return end

    -- There's a very slim chance that this works right
    for _, entry in pairs( section.EntryList ) do
        if index == 1 then return entry.Entry end
        index = index - 1
    end
end

--- "[Count] how many entries with the indicated prefix followed by a number exist in the section"
--- @param section string
--- @param entryPrefix string
--- @param startNumber integer? [Default: 0]
--- @param endNumber integer? [Default: -1]
function INSTANCE:EnumerateEntries( section, entryPrefix, startNumber, endNumber )
    -- Appears to be unused in the original game
    typecheck.NotImplementedError()
end

--[[ Getting Data ]] do
    -- "Get the various data types from the section and entry specified."

    function INSTANCE:GetPKey( fast )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    --- "Fetch a boolean value for the section and entry specified."
    --- > "  
    --- > This routine will search under the section specified, looking for a matching entry. If
    --- > one is found, the value is interpreted as a boolean value and then returned. In the case
    --- > of no matching entry, the default value will be returned instead. The boolean value
    --- > is interpreted using the standard boolean conventions. e.g., "Yes", "Y", "1", "True",
    --- > "T" are all consider to be a TRUE boolean value.  
    --- > "  
    --- @param sectionName string "The section to search under."
    --- @param entryName string "The entry to search for."
    --- @param defaultValue boolean? [Default: false] "The default value to use if no matching entry could be located."
    --- @return boolean "Returns with the boolean value of the specified section and entry. If no match then the default boolean value is returned."
    function INSTANCE:GetBool( sectionName, entryName, defaultValue )
        if not defaultValue then defaultValue = false end

        -- "Verify that the parameters are nominally correct."
        if not sectionName or not entryName then return defaultValue end

        local entry = self:FindEntry( sectionName, entryName )
        if not entry then return defaultValue end

        local value = entry.Value:Trim():upper()
        local firstChar = value:sub( 1, 1 ):upper()

        -- Truthy
        if firstChar == "Y" then return true end
        if firstChar == "T" then return true end
        if firstChar == "1" then return true end

        -- Falsey
        if firstChar == "N" then return false end
        if firstChar == "F" then return false end
        if firstChar == "0" then return false end

        return defaultValue
    end

    --- "Fetch a floating point number from the database."
    --- > "  
    --- > This routine will retrieve a floating point number from the database.  
    --- > "  
    --- @param sectionName string "The section name to find the entry under."
    --- @param entryName string "The entry name to fetch the float value from."
    --- @param defaultValue number? [Default: 0.0] "Return value to use if the section and entry could not be found."
    --- @return number "Returns with the float value from the section and entry specified. If not found, then the default value is returned."
    function INSTANCE:GetFloat( sectionName, entryName, defaultValue )
        -- "Verify that the parameters are nominally correct."
        if not defaultValue then defaultValue = 0.0 end
        if not sectionName or not entryName then return defaultValue end

        local entry = self:FindEntry( sectionName, entryName )
        if entry and entry.Value then
            return tonumber( entry.Value ) or defaultValue
        end
        return defaultValue
    end

    function INSTANCE:GetDouble( sectionName, entryName, defaultValue )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetHex( sectionName, entryName, defaultValue )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    --- "Fetch an integer entry from the specified section."
    --- > "  
    --- > This routine will fetch an integer value from the entry and section specified.  
    --- > If no entry could be found, then the default value will be returned instead.  
    --- > "  
    --- @param sectionName string "The section name to search under."
    --- @param entryName string "The entry name to search for."
    --- @param defaultValue integer? "The default value to use if the specified entry could not be found."
    --- @return integer # "Returns with the integer value specified in the INI database or else returns the drfault value."
    function INSTANCE:GetInt( sectionName, entryName, defaultValue )
        if not defaultValue then defaultValue = 0 end

        -- "Verify that the parameters are nominally correct."
        if not sectionName or not entryName then return defaultValue end

        local entry = self:FindEntry( sectionName, entryName )
        if not entry then return defaultValue end

        local value = entry.Value:Trim():lower()
        if not value then return defaultValue end

        if value:StartsWith( "$" ) then
            local isolatedValue = value:sub( 2 )
            local numberValue = tonumber( isolatedValue, 16 )
            if not numberValue then return defaultValue end
            return numberValue
        end

        if value:EndsWith( "h" ) then
            local isolatedValue = value:sub( 1, -2 )
            local numberValue = tonumber( isolatedValue, 16 )
            if not numberValue then return defaultValue end
            return numberValue
        end

        local numberValue = tonumber( value )
        return numberValue or defaultValue
    end

    --- "Fetch the value of a particular entry in a specified section."
    --- > "  
    --- > This will retrieve the entire text to the right of the "=" character. The text is
    --- > found by finding a matching entry in the section specified. If no matching entry could
    --- > be found, then the default value will be stored in the output string buffer.  
    --- > "
    --- @param sectionName string "...the section name to search under."
    --- @param entryName string "The entry identifier to search for."
    --- @param defaultValue string? "If no entry could be found, then this text will be returned."
    --- @return string # "...the retrieved string..."
    function INSTANCE:GetString( sectionName, entryName, defaultValue )
        if not defaultValue then defaultValue = "" end

        -- "Verify that the parameters are nominally legal"
        if not sectionName or not entryName then return defaultValue end

        local entry = self:FindEntry( sectionName, entryName )
        if not entry then return defaultValue end

        return entry.Value or defaultValue
    end

    --- @param sectionName string
    --- @param entryName string
    --- @param defaultValue string
    --- @return string
    function INSTANCE:GetWideString( sectionName, entryName, defaultValue )
        return self:GetString( sectionName, entryName, defaultValue )
    end

    function INSTANCE:GetListIndex( sectionName, entryName, defaultValue )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetAllocIntArray( sectionName, entryName, defaultValue )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetIntBitfield( sectionName, entryName, defaultValue )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetAllocString( sectionName, entryName, defaultValue )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetTextBlock( sectionName, entryName, defaultValue )
        -- Barely used in the original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetUUBlock( sectionName, entryName, defaultValue )
        -- Barely used in the original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetRect( sectionName, entryName, defaultValue )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetPoint( sectionName, entryName, defaultValue )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end
end

--[[ Putting Data ]] do
    -- "Put a data type to the section and entry specified."

    --- "Store a boolean value into the INI database."  
    --- > "  
    --- > Use this routine to place a boolean value into the INI database.  
    --- > The boolean value will be stored as "yes" or "no".  
    --- > "  
    --- @param sectionName string The section to place the entry and boolean value into.
    --- @param entryName string The entry identifier to tag to the boolean value.
    --- @param value boolean The boolean value to place into the database.
    --- @return boolean # Was the boolean value placed into the database?
    function INSTANCE:PutBool( sectionName, entryName, value )
        -- This is horrible and I hate it tremendously
        if value then
            return self:PutString( sectionName, entryName, "yes" )
        else
            return self:PutString( sectionName, entryName, "no" )
        end
    end

    --- "Store a floating point number to the database."
    --- > "  
    --- > This routine will store a flaoting point number to the section and entry of the database.  
    --- > "  
    --- @param section string The section to store the entry under.
    --- @param entry string The entry to store the floating point number to.
    --- @param number number The floating point number to store.
    --- @return boolean # Was the floating point number stored without error?
    function INSTANCE:PutFloat( sectionName, entryName, number )
        local buffer = tostring( number )
        return self:PutString( sectionName, entryName, buffer )
    end

    function INSTANCE:PutDouble( sectionName, entryName, value )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:PutHex( sectionName, entryName, value )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    --- "Stores a signed integer into the INI data base."
    --- > "
    --- > Use this routine to store an integer value into the section and entry specified.
    --- > "
    --- @param sectionName string "The identifier for the section that the entry will be placed in."
    --- @param entryName string "The entry identifier used for the integer number."
    --- @param value integer "The integer number to store in the database."
    --- @param format IntegerFormat "The format to store the integer. The format is generally only a cosmetic affect. The [GetInt] operation will interpret the value the same regardless of what format was used to store the integer."
    --- @return boolean "Was the number stored?"
    function INSTANCE:PutInt( sectionName, entryName, value, format )
        --- @type string
        local formattedValue

        if format == integerFormatEnum.HEX_TRAILING_H then
            formattedValue = string.format( "%Xh", value )

        elseif format == integerFormatEnum.HEX_LEADING_DOLLAR then
            formattedValue = string.format( "$%X", value )

        -- Format is either unknown or PLAIN_DECIMAL
        else
            formattedValue = string.format( "%d", value )
        end

        return self:PutString( sectionName, entryName, formattedValue )
    end

    function INSTANCE:PutPKey( sectionName, entryName, value )
        -- Not used in the original game
        typecheck.NotImplementedError()
    end

    --- "Output a string to the section and entry specified."
    --- > "  
    --- > This routine will put an arbitrary string to the section and entry specified.
    --- > Any previous matching entry will be replaced.  
    --- > "  
    --- @param sectionName string "The section identifier to place the string under."
    --- @param entryName string "The entry identifier to identify this string [placed under the section]"
    --- @param value string "...the string to assign to this entry."
    --- @return boolean "Was the entry assigned without error?"
    function INSTANCE:PutString( sectionName, entryName, value )
        if not sectionName or not entryName then return false end

        local section = self:FindSection( sectionName )

        if not section then
            section = iniSectionClass.New( sectionName )
            if not section then return false end
            self.SectionList[sectionName] = section
        end

        -- "Create and add the new entry"
        if value and value:len() > 0 then
            local entry = iniEntryClass.New( entryName, value )
            if not entry then return false end

            section.EntryList[entryName] = entry
        end

        return true
    end

    function INSTANCE:PutTextBlock( sectionName, entryName, value )
        typecheck.NotImplementedError()
    end

    function INSTANCE:PutUUBlock( sectionName, entryName, value )
        -- Barely used in original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:PutRect( sectionName, entryName, value )
        -- Not used in original game
        typecheck.NotImplementedError()
    end

    function INSTANCE:PutPoint( sectionName, entryName, value )
        -- Not used in original game
        typecheck.NotImplementedError()
    end

    --- @param sectionName string
    --- @param entryName string
    --- @param value string
    --- @return boolean
    function INSTANCE:PutWide_String( sectionName, entryName, value )
        return self:PutString( sectionName, entryName, value )
    end
end

--- "Access to the list of all sections within this INI file."
--- @return IniSectionInstance[]
function INSTANCE:GetSectionList()
    return self.SectionList
end

--[[ Section and Entry Finding ]] do
    -- "Utility routines to help find the appropriate section and entry objects."

    --- @param sectionName string
    --- @return IniSectionInstance?
    function INSTANCE:FindSection( sectionName )
        return self.SectionList[sectionName]
    end

    --- "Find specified entry within section."
    --- > "  
    --- > This support routine will find the specified entry in the specified section.
    --- > If found, a pointer to the entry control structure will be returned.  
    --- > "  
    --- @param sectionName string "...the section name to search under."
    --- @param entryName string "...the entry name to search for."
    --- @return IniEntryInstance? "If the entry was found, then... ...the entry control structure will be returned. Otherwise, [nil] will be returned."
    function INSTANCE:FindEntry( sectionName, entryName )
        local section = self:FindSection( sectionName )
        if not section then return end
        return section:FindEntry( entryName )
    end
end
