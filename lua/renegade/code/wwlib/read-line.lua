-- Based on the functions within Code/wwlib/readline.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ReadLineClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ReadLineClass"


--#region Exported Enums
--#endregion


--#region Imports

    --- @type FileStrawClass
    local fileStrawClass = CNC.Import( "code/wwlib/file-straw.lua" )
--#endregion


--#region Imported Enums
--#endregion


--- @class ReadLineClass

local lineFeed = string.char( 0x0A )
local carriageReturn = string.char( 0x0D )

--- "Read a text line..."
--- @param file FileInstance | StrawInstance
--- @return string buffer
--- @return boolean didHitEof
function STATIC.ReadLine( file )
    -- ( file: FileInstance ): string, boolean
    if file.IsFile then
        local fileStraw = fileStrawClass.New( file --[[@as FileInstance]] )
        local buffer, didHitEof = STATIC.ReadLine( fileStraw )
        return buffer, didHitEof
    end

    -- ( file: StrawInstance ): string, boolean
    local straw = file --[[@as StrawInstance]]

    local buffer = ""
    while true do
        local readByteCount, char = straw:Get( 1 )
        if readByteCount ~= 1 then
            return buffer, true
        end

        if char == lineFeed then
            break
        end

        if char ~= carriageReturn then
            buffer = buffer .. char
        end
    end

    buffer = buffer:Trim()
    return buffer, false
end