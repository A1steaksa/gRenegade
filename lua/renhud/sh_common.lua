-- Provides shared resources common to both the server and the client

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SharedCommon
local LIB = CNC.CreateExport()
LIB.Class = "SharedCommon"

--- The various `type()` results that constitute an Entity
--- @type string[]
LIB.EntTypes = {
    "Entity",
    "NPC",
    "Player",
    "Weapon",
    "Vehicle",
    "Nextbot"
}