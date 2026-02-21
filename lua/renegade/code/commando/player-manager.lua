-- Based on PlayerManager within Code/Commando/playermanager.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class PlayerManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "PlayerManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--- @class PlayerManagerClass

STATIC.PLAYER_ID_UNKNOWN = -99999
STATIC.MAX_PLAYERS = 255

