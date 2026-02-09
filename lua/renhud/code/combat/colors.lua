-- Based on colors within Code/Combat/colors.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ColorClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )

--#region Imports

    --- @type PlayerTypeClass
    local playerType = CNC.Import( "code/combat/player-type.lua" )
--#endregion


--#region Imported Enums

    local playerTypeEnum = playerType.PLAYER_TYPE_ENUM
--#endregion


--- @class ColorClass
--- @field TeamColors table<PlayerTypeEnum, Color>
-- --- @field TextColors table<integer, Color>

STATIC.TeamColors = {
    [playerTypeEnum.Nod]        = Color( 255,   0,   0 ),
    [playerTypeEnum.GDI]        = Color( 255, 204,   0 ),
    [playerTypeEnum.Neutral]    = Color( 204, 204, 204 ),
    [playerTypeEnum.Renegade]   = Color( 255, 255, 255 )
}

-- STATIC.TextColors = {
--     COLOR_PUBLIC_TEXT    = Vector3( 1.0f, 1.0f, 1.0f );
--     COLOR_PRIVATE_TEXT	= Vector3( 0.0f, 0.0f, 1.0f );
--     COLOR_PAGED_TEXT     = Vector3( 0.0f, 1.0f, 1.0f );
--     COLOR_INVITE_TEXT    = Vector3( 1.0f, 0.0f, 1.0f );
--     COLOR_CONSOLE_TEXT	= Vector3( 1.0f, 1.0f, 1.0f );
-- }

--- @param team PlayerTypeEnum
function STATIC.GetColorForTeam( team )
    --- TODO: Tie this into a team API of some kind 
    return STATIC.TeamColors[ team ]
end