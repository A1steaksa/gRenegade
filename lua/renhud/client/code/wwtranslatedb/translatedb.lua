-- Based on Code/wwtranslatedb/translatedb.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class TranslateDbClass
local STATIC = CNC.CreateExport()
local CLASS = "TranslateDb"
local isHotload = not table.IsEmpty( STATIC )


--#region Imports
    --- @type TranslationLib
    local translationLib = CNC.Import( "renhud/client/cl_translation.lua" )
--#endregion


--#region Imported Enums

    local languageEnum = translationLib.LANGUAGE
--#endregion


--- @param id string|integer The unique ID of the string to look up. 
function STATIC.GetString( id )
    return translationLib.GetString( languageEnum.English, id ) or "UNKNOWN STRING"
end