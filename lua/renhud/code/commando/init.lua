-- Based on the functions within Code/Commando/init.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class InitClass
local STATIC = CNC.CreateExport()
STATIC.Class = "InitClass"
local isHotload = not table.IsEmpty( STATIC )

--#region Imports

    --- @type GameInitManagerClass
    local gameInitManagerClass = CNC.Import( "renhud/code/commando/game-init-manager.lua" )

    --- @type GameDataClass
    local gameDataClass = CNC.Import( "renhud/code/commando/game-data.lua" )

    --- @type GameModeManagerClass
    local gameModeManagerClass = CNC.Import( "renhud/code/commando/game-mode-manager.lua" )

    --- @type CombatGameModeClass
    local combatGameModeClass = CNC.Import( "renhud/code/commando/combat-game-mode.lua" )

    --- @type CampaignManagerClass
    local campaignManagerClass = CNC.Import( "renhud/code/commando/campaign.lua" )

    --- @type RenegadeDialogManagerClass
    local renegadeDialogManagerClass = CNC.Import( "renhud/code/commando/renegade-dialog-manager.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "renhud/code/combat/combat-manager.lua" )

    --- @type MainLoopClass
    local mainLoopClass = CNC.Import( "renhud/code/commando/main-loop.lua" )
--#endregion


--- @class InitClass


--- @return boolean
function STATIC.GameInit()
    -- Ensure GameInit only runs once
    if SERVER then
        hook.Remove( "InitPostEntity", "A1_Renegade_GameInit_Server" )
    else
        hook.Remove( "PreRender", "A1_Renegade_GameInit_Client" )
    end

    Section.Start( "Running Renegade GameInit" )

    -- "Set registry key to 1 for the duration of the init.  This way we know if the program crashed while the init."

    -- "Ensure our directory structure exists"

    -- "Initialize our debugging framework"

    -- "Setup Writing Factory"

    -- "Search for all mix files in the data directory"

    -- "Close the search handle"

    -- "Logging File Factory"

    -- "Let's seed the Random Generator, a little"

    -- "Thumbnail manager pre init will ensure that thumbnail database is up-to-date"

    -- "Create an instance of the sound library"

    -- "Install text callback"

    -- "Load the multiplayer settings"

    -- "Initialize WWMath"

    -- "Initialize the pathfind system"

    -- "Initialize WW3D"

    -- "Clear screen"

    -- "Load the strings table"

    -- "Initialize the input control system"

    -- "Initialize the skin selection framework"

    -- "Load the conversation database"

    -- "Check to make sure the code version matches the strings table version"

    -- "
    -- Note:  Due to interdependencies (yuck!) between these subsystems, here's the order they need to be initialized in:"
    --      - Physics Scene Class (via CombatManager::Scene_Init)
    --      - SystemSettings
    --      - RenegadeDialogMgrClass
    -- "

    -- combatManagerClass.SceneInit()

    renegadeDialogManagerClass.Initialize()

    -- networkClass.OnetimeInit()

    -- serverFpsClass.CreateInstance()

    -- playerManagerClass.OnetimeInit()
    -- teamManagerClass.OnetimeInit()
    gameDataClass.OnetimeInit()
    -- bandwidthGraphclass.OnetimeInit()

    -- netUtil.WsaInit()

    combatManagerClass.Init( CLIENT )

    campaignManagerClass.Init()

    -- "This order is also draw and think order"
    gameModeManagerClass.Add( combatGameModeClass.New() )

    -- gameModeManagerClass.Find( "Overlay3D" ):Activate()
    -- gameModeManagerClass.Find( "Overlay" ):Activate()
    -- gameModeManagerClass.Find( "Console" ):Activate()
    -- gameModeManagerClass.Find( "Menu" ):Activate()
    -- gameModeManagerClass.Find( "TextDisplay" ):Activate()

    -- "After TextDisplay is created, install the Display Handler"
    -- debugManagerClass.SetDisplayHandler( STATIC.TextDisplayHandler )

    -- "
    -- Load the accelerator table and hand it off to WWLIB
    -- Note:  Accelerator tables that are loaded from resources (like we are doing here)
    -- do not need to be manually freed.  Windows will cleanup for us when the process terminates.
    -- "

    -- "Initialize the encyclopedia logic"

    -- "NIC initialization"

    -- "Parse the server settings files if they will be used soon to make sure there are no errors"

    -- "If this is a post crash restart (or a FDS starting up) then just go straight into the game"

    -- "Send out Spy Usage Info off to Gamespy"

    Section.End()










    --[[ Artificial init ]] do

        -- Elements are not normally initialized here in the original code
        -- They are being initialized here temporarily while other parts of the codebase are worked on

        -- Make an amalgum of single player and skirmish
        local skirmishLoadMenuNumber = 96
        -- campaignManagerClass.SelectBackdropNumber( skirmishLoadMenuNumber )
        gameInitManagerClass.InitializeSP()

        gameInitManagerClass.StartGame( "my_map_name", -1, 0 )
    end










    hook.Run( "Renegade_PostGameInit" )

    return true
end
