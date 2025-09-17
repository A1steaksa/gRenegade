-- Based on Code/Combat/objectives.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

local STATIC

--[[ Class Setup ]] do

    --- The static components of ObjectiveManager
    --- @class ObjectiveManager
    STATIC = CNC.CreateExport()
end


--#region Enums

    --- @enum ObjectiveType
    STATIC.OBJECTIVE_TYPE = {
        PRIMARY    = 0,
        SECONDARY  = 1,
        TERTIARY   = 2
    }
    local objectiveType = STATIC.OBJECTIVE_TYPE

    --- @enum ObjectiveStatus
    STATIC.OBJECTIVE_STATUS = {
        IS_PENDING   = 0,
        ACCOMPLISHED = 1,
        FAILED       = 2,
        HIDDEN       = 3
    }
    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "renhud/client/code/combat/combat-manager.lua" )
    --- @type HudClass
    local hudClass = CNC.Import( "renhud/client/code/combat/hud.lua" )
--#endregion


        typecheck.NotImplementedError( CLASS )
        typecheck.NotImplementedError( CLASS )
        typecheck.NotImplementedError( CLASS )
        typecheck.NotImplementedError( CLASS )
        typecheck.NotImplementedError( CLASS )
end