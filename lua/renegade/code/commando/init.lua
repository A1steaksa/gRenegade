-- Based on the functions within Code/Commando/init.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class InitClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "InitClass"

--#region Imports

    --- @type GameInitManagerClass
    local gameInitManagerClass = CNC.Import( "code/commando/game-init-manager.lua" )

    --- @type GameDataClass
    local gameDataClass = CNC.Import( "code/commando/game-data.lua" )

    --- @type GameModeManagerClass
    local gameModeManagerClass = CNC.Import( "code/commando/game-mode-manager.lua" )

    --- @type CombatGameModeClass
    local combatGameModeClass = CNC.Import( "code/commando/combat-game-mode.lua" )

    --- @type CampaignManagerClass
    local campaignManagerClass = CNC.Import( "code/commando/campaign.lua" )

    --- @type RenegadeDialogManagerClass
    local renegadeDialogManagerClass = CNC.Import( "code/commando/renegade-dialog-manager.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

    --- @type MainLoopClass
    local mainLoopClass = CNC.Import( "code/commando/main-loop.lua" )

    --- @type FileFactoryClass
    local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

    --- @type MixFileFactoryClass
    local mixFileFactoryClass = CNC.Import( "code/wwlib/mix-file-factory.lua" )

    --- @type SimpleFileFactoryClass
    local simpleFileFactoryClass = CNC.Import( "code/wwlib/simple-file-factory.lua" )

    --- @type FileFactoryListClass
    local fileFactoryListClass = CNC.Import( "code/combat/file-factory-list.lua" )
--#endregion

--#region Imported Enums
--#endregion


--- @class InitClass
--- @field RenegadeWritingFileFactory SimpleFileFactoryInstance
--- @field RenegadeBaseFileFactory SimpleFileFactoryInstance
--- @field AlwaysMixFileFactory MixFileFactoryInstance
--- @field RenegadeFileFactory FileFactoryListInstance
--- @field AudioFileFactory StrippingFileFactoryInstance
--- @field LoggingFileFactory LoggingFileFactoryInstance


-- "This defines the subdirectory where the game will load all data from"
local DATA_SUBDIRECTORY   = "data/";
local SAVE_SUBDIRECTORY   = "data/save/";
local CONFIG_SUBDIRECTORY = "data/config/";
local MOVIES_SUBDIRECTORY = "data/movies/";

local STRINGS_FILENAME = "strings.tdb"
local CONV_DB_FILENAME = "conv10.cdb"

function STATIC.StaticConstructor()
    STATIC.RenegadeWritingFileFactory = simpleFileFactoryClass.New()
    STATIC.RenegadeBaseFileFactory = simpleFileFactoryClass.New()
    STATIC.RenegadeFileFactory = fileFactoryListClass.New()
end

--- @return boolean
function STATIC.GameInit()
    -- Ensure we don't initialize more than once
    if SERVER then
        hook.Remove( "InitPostEntity", "A1_Renegade_GameInit_Server" )
    else
        hook.Remove( "HUDPaint", "A1_Renegade_GameInit_Client" )
    end

    section.Start( "Running Renegade GameInit" )

    -- "Set registry key to 1 for the duration of the init.  This way we know if the program crashed while the init."

    -- "Ensure our directory structure exists"

    -- "Initialize our debugging framework"

    -- "Setup Writing Factory"
    STATIC.RenegadeWritingFileFactory:SetSubDirectory( DATA_SUBDIRECTORY )
    STATIC.TheWritingFileFactory = STATIC.RenegadeWritingFileFactory

    STATIC.RenegadeBaseFileFactory:SetSubDirectory( DATA_SUBDIRECTORY )
    STATIC.RenegadeBaseFileFactory:AppendSubDirectory( SAVE_SUBDIRECTORY )
    STATIC.RenegadeBaseFileFactory:AppendSubDirectory( CONFIG_SUBDIRECTORY )

    fileFactoryClass.TheSimpleFileFactory:SetSubDirectory( DATA_SUBDIRECTORY )
    fileFactoryClass.TheSimpleFileFactory:AppendSubDirectory( SAVE_SUBDIRECTORY )
    fileFactoryClass.TheSimpleFileFactory:AppendSubDirectory( CONFIG_SUBDIRECTORY )

    fileFactoryClass.TheSimpleFileFactory:SetStripPath( true )

    STATIC.RenegadeFileFactory:AddFileFactory( STATIC.RenegadeBaseFileFactory, "" )
    STATIC.RenegadeFileFactory:AddFileFactory(
        mixFileFactoryClass.New(
            "always2.dat.txt",
            STATIC.RenegadeBaseFileFactory
        ),
        "always2.dat.txt"
    )

    STATIC.RenegadeFileFactory:AddFileFactory(
        mixFileFactoryClass.New(
            "always.dbs.txt",
            STATIC.RenegadeBaseFileFactory
        ),
        "always.dbs.txt"
    )

    STATIC.RenegadeFileFactory:AddFileFactory(
        mixFileFactoryClass.New(
            "always.dat.txt",
            STATIC.RenegadeBaseFileFactory
        ),
        "always.dat.txt"
    )

    -- "Search for all mix files in the data directory"
    local mixFiles = file.Find( "data/renegade/data/*.mix.txt", "THIRDPARTY" )
    for _, fileName in ipairs( mixFiles) do
        -- "Add this mix file to our mix file factory list"
        STATIC.RenegadeFileFactory:AddFileFactory(
            mixFileFactoryClass.New(
                fileName,
                STATIC.RenegadeBaseFileFactory
            ),
            fileName
        )
    end

    fileFactoryClass.TheFileFactory = STATIC.RenegadeFileFactory

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

    section.End()










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
