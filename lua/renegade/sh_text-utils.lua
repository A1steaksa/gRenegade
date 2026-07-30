--- @class Renegade
local CNC = CNC_RENEGADE

--- @class TextUtils
local LIB = CNC.CreateExport()
LIB.Class = "TextUtils"

--- Finds the start index of the first occurrance of a substring (needle) within a string (haystack) 
--- @param haystack string
--- @param needle string
--- @return integer?
function LIB.IndexOf( haystack, needle )
    if haystack == nil or needle == nil then return end

    return haystack:find( needle, nil, true )
end

--- Finds the start index of the last occurrance of a substring (needle) within a string (haystack) 
-- Simply horrible that this needs to be implemented manually like this  
-- Credit: https://stackoverflow.com/questions/20459943/find-the-last-index-of-a-character-in-a-string
--- @param haystack string
--- @param needle string
--- @return integer?
function LIB.LastIndexOf( haystack, needle )
    if haystack == nil or needle == nil then return end

    local found = haystack:reverse():find( needle:reverse(), nil, true )
    if found then
        return haystack:len() - needle:len() - found + 2
    else
        return found
    end
end

--- Converts a byte string into a printable hex string
--- @param byteString string
--- @return string
function LIB.Hex( byteString )
    local byteStrings = {}
    for byteIndex = 1, string.len( byteString ) do
        local extractedByteString = string.byte( byteString, byteIndex, byteIndex )
        local byteNumber = tonumber( extractedByteString )

        local hexByteString = string.format( "%02X", byteNumber )

        byteStrings[#byteStrings + 1] = hexByteString
    end

    return table.concat( byteStrings, " " )
end
Hex = LIB.Hex

--- Converts a byte string into a printable binary string
--- @param byteString string
--- @return string
function LIB.Binary( byteString )
    local outputBinaryString = ""
    for i = 1, #byteString do
        local char = string.byte( byteString, i, i )

        local byteBinaryString = ""
        for j = 0, 7 do
            byteBinaryString = ( char % 2 ) .. byteBinaryString

            char = math.floor( char / 2 )
        end

        outputBinaryString = string.Trim( outputBinaryString .. " " .. byteBinaryString )
    end

    return outputBinaryString
end
Binary = LIB.Binary