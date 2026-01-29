-- Based on GameInitMgrClass within Code/Commando/gameinitmgr.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GameInitManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "GameInitManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum ModeEnum
    STATIC.MODE = {
        Unknown  = enumBuilder:Set( 0 ),
        SP       = enumBuilder:Next(),
        Skirmish = enumBuilder:Next(),
        Lan      = enumBuilder:Next(),
        Wol      = enumBuilder:Next(),
    }
    local modeEnum = STATIC.MODE

--#endregion


--#region Imports

    --- @type GameDataSinglePlayerClass
    local gameDataSinglePlayerClass = CNC.Import( "renhud/code/commando/game-data-single-player.lua" )

    --- @type GameDataClass
    local gameDataClass = CNC.Import( "renhud/code/commando/game-data.lua" )

    --- @type GameModeManagerClass
    local gameModeManagerClass = CNC.Import( "renhud/code/commando/game-mode-manager.lua" )
--#endregion


--#region Imported Enums
--#endregion


--- @class GameInitManagerClass
--- @field IsClientRequired boolean
--- @field IsServerRequired boolean
--- @field RestoreSfx boolean
--- @field RestoreMusic boolean
--- @field Mode ModeEnum
--- @field WolReturnDialog Location
--- @field NeedsGameExit boolean
--- @field NeedsGameExitAll boolean 

--[[ Level Init ]] do

    --- @param mapName string
    --- @param teamChoice integer
    --- @param clanId integer
    function STATIC.StartGame( mapName, teamChoice, clanId )
        -- "NOTE: Multi-player does not need this fix because it does not sound page swap."
        -- Omitted sound effect fix

        local combat = gameModeManagerClass.Find( "Combat" )
        if not combat then
            Section.Error( "Failed to find Combat gamemode" )
        end
        --- @cast combat CombatGameModeInstance

        -- "Kill off any old suspended game"
        if combat:IsSuspended() then
            STATIC.EndGame()
            gameModeManagerClass.SafelyDeactivate()
        end

        -- "Set the map name"
        gameDataClass.TheGame():SetMapName( mapName )

        -- Omitted code here

        -- "Deactivate the menu system"
        -- gameModeManagerClass.Find( "Menu" ):Deactivate()

        -- "Active the combat system"
        combat:Activate()

        -- "Load the level"
        combat:LoadLevel()

        -- Omitted more code here
    end


    function STATIC.EndGame()
        typecheck.NotImplementedError()
    end


    function STATIC.ContinueGame()
        typecheck.NotImplementedError()
    end


    function STATIC.DisplayEndGameMenu()
    typecheck.NotImplementedError()
    end


    --- @return boolean
    function STATIC.IsGameInProgress()
        typecheck.NotImplementedError()
    end
end


--[[ Client/Server Control ]] do

    --- @param isRequired boolean
    function STATIC.SetIsClientRequired( isRequired )
        STATIC.IsClientRequired = isRequired
    end

    --- @param isRequired boolean
    function STATIC.SetIsServerRequired( isRequired )
        STATIC.IsServerRequired = isRequired
    end
end

--[[ Interface Type Init ]] do

    -- "LAN = Local Area Network"
    -- "WOL = Westwood Online"
    -- "SP = Single Player"

    function STATIC.InitializeLan()
        typecheck.NotImplementedError()
    end

    function STATIC.InitializeWol()
        typecheck.NotImplementedError()
    end

    function STATIC.InitializeSP()
        if STATIC.Mode ~= modeEnum.Unknown then
            -- STATIC.Shutdown()
        end

        -- Omitting lots of stuff here

        gameDataClass._TheGameData = gameDataSinglePlayerClass.New()

        -- Omitting more stuff here

    end

    function STATIC.InitializeSkirmish()
        typecheck.NotImplementedError()
    end

    --- @return boolean
    function STATIC.IsLanInitialized()
        return STATIC.Mode == modeEnum.Lan
    end

    --- @return boolean
    function STATIC.IsWolInitialized()
        return STATIC.Mode == modeEnum.Wol
    end

    --- @return boolean
    function STATIC.IsSPInitialized()
        return STATIC.Mode == modeEnum.SP
    end

    --- @return boolean
    function STATIC.IsSkirmishInitialized()
        return STATIC.Mode == modeEnum.Skirmish
    end

    function STATIC.Shutdown()
        typecheck.NotImplementedError()
    end

    function STATIC.ShutdownLan()
        typecheck.NotImplementedError()
    end

    function STATIC.ShutdownWol()
        typecheck.NotImplementedError()
    end

    function STATIC.ShutdownSP()
        typecheck.NotImplementedError()
    end

    function STATIC.ShutdownSkirmish()
        typecheck.NotImplementedError()
    end
end

function STATIC.EndClientServer()
    typecheck.NotImplementedError()
end

-- "Thinking support (for safely triggering game ends)"
function STATIC.Think()
    typecheck.NotImplementedError()
end

--- @param needsExit boolean
function STATIC.SetNeedsGameExit( needsExit )
    STATIC.NeedsGameExit = needsExit
end

--- @param needsExit boolean
function STATIC.SetNeedsGameExitAll( needsExit )
    STATIC.NeedsGameExitAll = needsExit
end

--- "WOL specific"
--- @param location Location
function STATIC.SetWolReturnDialog( location )
    STATIC.WolReturnDialog = location
end

--- @private
function STATIC.StartClientServer()
    typecheck.NotImplementedError()
end

--- @param teamChoice integer
--- @param clanId integer
function STATIC.TransmitPlayerData( teamChoice, clanId )
    typecheck.NotImplementedError()
end