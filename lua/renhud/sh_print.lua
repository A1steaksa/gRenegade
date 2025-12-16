-- A library containing debug printing functionality

--- @class PrintLib
local LIB = {}
local CLASS = "PrintLib"
local isHotload = not table.IsEmpty( LIB )

Section = LIB

--- @class PrintLib
--- @field private SectionStack string[]
--- @field private IndentLevelString string The string that is repeated for each indentation level
--- @field private JustEndedSection boolean `true` when the last action taken by the library was to close a section
--- @field private SectionLabelFilter string When set, the library will ignore section and print statements until a section with this label is started
--- @field private IndentLineColor Color 
--- @field private DefaultMessageColor Color 
--- @field private WarningLabelColor Color
--- @field private WarningMessageColor Color
--- @field private ErrorLabelColor Color 
--- @field private ErrorMessageColor Color 
--- @field private IsEnabled boolean

--[[ Settings ]] do

    LIB.StartEnabled = false

    --- How many total characters (spaces and, optionally, indent lines) should be used for each level of indentation?
    LIB.IndentCharCount = 3

    --- When `true`, adds a `|` to each level of indentation to make it easier to see which elements are in the same level of indentation
    LIB.IncludeIndentLines = true
end


--[[ State ]] do

    LIB.SectionStack = {}
    LIB.JustEndedSection = false
    LIB.IsEnabled = LIB.StartEnabled
end


--[[ Colors ]] do

    --- The color of indentation indicator lines
    LIB.IndentLineColor     = Color( 125, 125, 125 )

    --- The default color of printed message text
    LIB.DefaultMessageColor = Color( 200, 200, 200 )

    --- The color of the "WARN" prefix on warning messages
    LIB.WarningLabelColor   = Color( 255, 255, 0 )

    --- The color of the message body on warning messages
    LIB.WarningMessageColor = Color( 200, 200, 100 )

    --- The color of the "ERORR" prefix on error messages
    LIB.ErrorLabelColor     = Color( 255, 0, 0 )

    --- The color of the message body on error messages
    LIB.ErrorMessageColor   = Color( 255, 100, 100 )
end


-- Errors are likely to prevent open sections from being closed properly so just reset the library's state
hook.Add( "OnLuaError", "A1_SectionLib_ResetSections", function()
    LIB.SectionStack = {}
    LIB.JustEndedSection = false
    LIB.SectionLabelFilter = nil
    LIB.IsEnabled = LIB.StartEnabled
end )

--- @param isEnabled boolean
function LIB.SetEnabled( isEnabled )
    LIB.IsEnabled = isEnabled
end

function LIB.Enable()
    LIB.IsEnabled = true
end

function LIB.Disable()
    LIB.IsEnabled = false
end

--- Prints the label and increases the indentation of all following prints
--- @param label string
function LIB.Start( label )
    if not LIB.IsEnabled then return end

    if LIB.SectionLabelFilter then
        local hasFilterPassed = #LIB.SectionStack ~= 0
        if not hasFilterPassed then
            -- This is a section we're filtering out
            if LIB.SectionLabelFilter ~= label then
                return
            end
        end
    end

    -- Include an empty line between the end of sections and further print statements
    if LIB.JustEndedSection then
        LIB.Print()
    end

    LIB.PrivatePrint( label )
    LIB.SectionStack[#LIB.SectionStack + 1] = label

    LIB.JustEndedSection = false
end

--- Prints a closing message and reduces the indentation of all following prints
--- @param closingMessage string?
function LIB.End( closingMessage )
    if not LIB.IsEnabled then return end

    if LIB.SectionLabelFilter then
        if #LIB.SectionStack == 0 then
            return
        end
    end

    local message
    if closingMessage then
        message = "Done - " .. tostring( message )
    else
        message = "Done."
    end

    LIB.SectionStack[#LIB.SectionStack] = nil
    LIB.PrivatePrint( message )

    LIB.JustEndedSection = true
end

--- Wraps a given function in a section
--- @param label any
--- @param func fun()
function LIB.Section( label, func )
    if not LIB.IsEnabled then return end

    LIB.Start( label )
    func()
    LIB.End()
end

--- Builds the string that is repeated for each level of indentation
function LIB.UpdateIndentLevelString()
    local indentLevelString
    if LIB.IncludeIndentLines then
        indentLevelString = "|" .. string.rep( " ", LIB.IndentCharCount - 1 )
    else
        indentLevelString = string.rep( " ", LIB.IndentCharCount )
    end

    LIB.IndentLevelString = indentLevelString
end

--- When set, all print and section statements are ignored until a section with this label is started
--- @param label string
function LIB.SetSectionFilter( label )
    LIB.SectionLabelFilter = label
end

--- Unblocks print and section statements
function LIB.ClearSectionFilter()
    LIB.SectionLabelFilter = nil
end

--- Sets how many total characters should be used to print each level of indentation.  
--- **Note:** This includes spaces and, if enabled, indent lines.
--- @param charCount integer
function LIB.SetIndentCharCount( charCount )
    LIB.IndentCharCount = charCount
    LIB.UpdateIndentLevelString()
end

--- Sets whether a vertical pipe (`|`) should be included in each layer of indentation.  
--- This can make it easier to keep track of which statements are at the same level of indentation.
--- @param shouldPrintIndentLines boolean
function LIB.SetIncludeIndentLines( shouldPrintIndentLines )
    LIB.IncludeIndentLines = ( shouldPrintIndentLines and true or false )
    LIB.UpdateIndentLevelString()
end

function LIB.Error( ... )
    Section.Print( LIB.ErrorLabelColor, "[ERROR] ", LIB.ErrorMessageColor, ... )
end

function LIB.Warn( ... )
    Section.Print( LIB.WarningLabelColor, "[WARNING] ", LIB.WarningMessageColor, ... )
end

--- @private
--- @vararg any
function LIB.PrivatePrint( ... )
    if not LIB.IndentLevelString then
        LIB.UpdateIndentLevelString()
    end

    -- Print the indentation
    MsgC( LIB.IndentLineColor, string.rep( LIB.IndentLevelString, #LIB.SectionStack ) )

    local currentColor = LIB.DefaultMessageColor

    for k, v in ipairs( {...} ) do
        if IsColor( v ) then
            currentColor = v
            continue
        end

        MsgC( currentColor, v )
    end

    Msg( "\n" )

    LIB.JustEndedSection = false
end

--- @vararg any
function LIB.Print( ... )
    if not LIB.IsEnabled then return end
    if LIB.SectionLabelFilter then
        if #LIB.SectionStack == 0 then
            return
        end
    end

    LIB.PrivatePrint( ... )
end

