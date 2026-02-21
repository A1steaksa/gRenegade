--- Manages translation strings within Garry's Mod for the Renegade HUD

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class TranslationLib
local LIB = CNC.CreateExport()
LIB.Class = "TranslationLib"

--#region Exported Enums

    --- @enum Language
    LIB.LANGUAGE = {
        English = 0,
    }
    local languageEnum = LIB.LANGUAGE
--#endregion

--- @type table<Language, table<string|integer, string>>
LIB.Strings = {}

--- Adds a language's variation of a piece of in-game text 
--- @param language Language
--- @param id string|integer
--- @param text string
function LIB.RegisterString( language, id, text )
    local languageTable = LIB.Strings[language]

    -- Make sure we have a table set up for this language
    if not languageTable then
        languageTable = {}
        LIB.Strings[language] = languageTable
    end

    languageTable[id] = text
end

--- Retrieves a language's version of a specific piece of in-game text
--- @param language Language
--- @param id string|integer
--- @return string? # The in-game text for this ID, or `nil` if no string has been registered for this combination of language and ID
function LIB.GetString( language, id )
    local languageTable = LIB.Strings[language]
    if not languageTable then return end
    return languageTable[id]
end


--[[ Manual String Registration ]] do
    -- Manually transcribed from strings.tdb inside of always.mix using Tiberium Technology's tdbedit.exe tool

    --[[ Pickups ]] do
        -- New objective "pickup"
        LIB.RegisterString( languageEnum.English, "IDS_Enc_Obj_Priority_0_Primary",   "Primary"   )
        LIB.RegisterString( languageEnum.English, "IDS_Enc_Obj_Priority_0_Secondary", "Secondary" )
        LIB.RegisterString( languageEnum.English, "IDS_Enc_Obj_Priority_0_Tertiary",  "Tertiary"  )

        -- Items/Upgrades
        LIB.RegisterString( languageEnum.English, "IDS_Power_up_DataDisc_01",    "Data Disc"        )
        LIB.RegisterString( languageEnum.English, "IDS_Power_up_SecurityCard",   "Security Card"    )
        LIB.RegisterString( languageEnum.English, "IDS_Power_up_Armor_00",       "Armor"            )
        LIB.RegisterString( languageEnum.English, "IDS_Power_up_Health_00",      "Health"           )
        LIB.RegisterString( languageEnum.English, "IDS_Power_up_Armor_Upgrade",  "Augmented Armor"  )
        LIB.RegisterString( languageEnum.English, "IDS_Power_up_Health_Upgrade", "Augmented Health" )
    end

    --[[ Objectives ]] do
        -- Strings for the Objective class in Code/Combat/objectives.cpp

        -- Objective type names
        LIB.RegisterString( languageEnum.English, "IDS_MENU_TEXT145",   "Primary"   )
        LIB.RegisterString( languageEnum.English, "IDS_MENU_TEXT113",   "Secondary" )
        LIB.RegisterString( languageEnum.English, "IDS_MENU_TERTIARY",  "Tertiary"  )
        LIB.RegisterString( languageEnum.English, "IDS_LOCALE_UNKNOWN", "Unknown"   )

        -- Objective status names
        LIB.RegisterString( languageEnum.English, "IDS_MENU_OBJ_ACCOMPLISHED", "Accomplished" )
        LIB.RegisterString( languageEnum.English, "IDS_MENU_OBJ_FAILED",       "Failed"       )
        LIB.RegisterString( languageEnum.English, "IDS_MENU_OBJ_HIDDEN",       "Hidden"       )
        LIB.RegisterString( languageEnum.English, "IDS_MENU_OBJ_PENDING",      "Pending"      )

        -- Objective update HUD messages
        LIB.RegisterString( languageEnum.English, "IDS_OBJ_NEW_OBJ",        "New %s mission objective\n%s\n"  )
        LIB.RegisterString( languageEnum.English, "IDS_OBJ_STATUS_CHANGED", "%s mission objective %s\n"       )
        LIB.RegisterString( languageEnum.English, "IDS_OBJ_CANCELLED",      "%s mission objective canceled\n" )
    end

    --[[ Radar ]] do

        LIB.RegisterString( languageEnum.English, "IDS_HUD_COMPASS_N",  "N"  )
        LIB.RegisterString( languageEnum.English, "IDS_HUD_COMPASS_NE", "NE" )
        LIB.RegisterString( languageEnum.English, "IDS_HUD_COMPASS_E",  "E"  )
        LIB.RegisterString( languageEnum.English, "IDS_HUD_COMPASS_SE", "SE" )
        LIB.RegisterString( languageEnum.English, "IDS_HUD_COMPASS_S",  "S"  )
        LIB.RegisterString( languageEnum.English, "IDS_HUD_COMPASS_SW", "SW" )
        LIB.RegisterString( languageEnum.English, "IDS_HUD_COMPASS_W",  "W"  )
        LIB.RegisterString( languageEnum.English, "IDS_HUD_COMPASS_NW", "NW" )
    end

    --[[ Multiplayer ]] do
        
        LIB.RegisterString( languageEnum.English, "IDS_MP_GAME_TYPE_SINGLE_PLAYER", "Single Player" )
        LIB.RegisterString( languageEnum.English, "IDS_MP_GAME_TYPE_CNC", "Command & Conquer" )
        LIB.RegisterString( languageEnum.English, "IDS_MP_GAME_TYPE_SINGLE_PLAYER", "Single Player" )

    end

end