-- Based on RenegadeDialogMgrClass within Code/Commando/renegadedialogmgr.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class RenegadeDialogManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "RenegadeDialogManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum Location
    STATIC.LOCATION = {
        LOC_MAIN_MENU           = enumBuilder:Set( 0 ),
        LOC_INTERNET_MAIN       = enumBuilder:Next(),
        LOC_INTERNET_GAME_LIST  = enumBuilder:Next(),
        LOC_LAN_MAIN            = enumBuilder:Next(),
        LOC_ENCYCLOPEDIA        = enumBuilder:Next(),
        LOC_OBJECTIVES          = enumBuilder:Next(),
        LOC_MAP                 = enumBuilder:Next(),
        LOC_CNC_REFERENCE       = enumBuilder:Next(),
        LOC_LOAD_GAME           = enumBuilder:Next(),
        LOC_IN_GAME_HELP        = enumBuilder:Next(),
        LOC_GAMESPY_MAIN        = enumBuilder:Next(),
        LOC_SPLASH_IN           = enumBuilder:Next(),
        LOC_SPLASH_OUT          = enumBuilder:Next(),
    }
    local locationEnum = STATIC.LOCATION
--#endregion


--#region Imports

    --- @type RenegadeUIInputClass
    local renegadeUIInputClass = CNC.Import( "renhud/code/commando/renegade-ui-input.lua" )

    --- @type DialogManagerClass
    local dialogManagerClass = CNC.Import( "renhud/code/wwui/dialog-manager.lua" )

    --- @type DialogBaseClass
    local dialogBaseClass = CNC.Import( "renhud/code/wwui/dialog-base.lua" )

    --- @type DialogResourceClass
    local dialogResourcesClass = CNC.Import( "renhud/code/commando/dialog-resource.lua" )

    --- @type DialogFactoryClass
    local dialogFactoryClass = CNC.Import( "renhud/code/wwui/dialog-factory.lua" )

--#endregion


--#region Imported Enums
--#endregion


--- @class RenegadeDialogManagerClass
--- @field TheWWUIInput RenegadeUIInputInstance

--- @type DialogFactoryInstance[]
STATIC.FactoryArray = {
    nil, --dialogFactoryClass.New( startSPGameDialogClass ),
    nil,
    nil,
    nil, --dialogFactoryClass.New( optionsMenuClass ),
    nil, --dialogFactoryClass.New( difficultyMenuClass ),
    nil, -- "IDC_MENU_START_TUTORIAL_BUTTON"
    nil, --dialogFactoryClass.New( loadSPGameMenuClass ),
    nil, -- "IDC_MENU_DIFFCULTY01_BUTTON"
    nil, -- "IDC_MENU_DIFFCULTY02_BUTTON"
    nil, -- "IDC_MENU_DIFFCULTY04_BUTTON"
    nil, -- "IDC_MENU_DIFFCULTY04_BUTTON"
    nil, --dialogFactoryClass.New( controlsMenuClass ),
    nil, --dialogFactoryClass.New( characterOptionsMenuClass ),
    nil, --dialogFactoryClass.New( cheatOptionsMenuClass ),
    nil, --dialogFactoryClass.New( techOptionsMenuClass ),
    nil, --dialogFactoryClass.New( movieOptionsMenuClass ),
    nil, --dialogFactoryClass.New( previewOptionsMenuClass ),
    nil, --dialogFactoryClass.New( creditsMenuClass ),
    nil, --dialogFactoryClass.New( quitVerificationDialogClass ),
    nil, --dialogFactoryClass.New( evaEncyclopediaMenuClass ),
    nil, --dialogFactoryClass.New( mainMenuDialogClass ),
    nil, --dialogFactoryClass.New( saveGameMenuClass ),
    nil, --dialogFactoryClass.New( mPLanMenuClass ),
    nil,
    nil,
    nil, --dialogFactoryClass.New( mPJoinMenuClass ),
    nil,
    nil, --dialogFactoryClass.New( multiplayOptionsMenuClass ),
    nil,
    nil, --dialogFactoryClass.New( mPWolMainMenuClass ),
    nil, --dialogFactoryClass.New( m PLanGameListMenuClass ),
    nil, -- "IDC_MENU_MP_LAN_JOIN_BUTTON"
    nil, -- "IDC_MENU_MP_LAN_START_BUTTON"
}

--[[ Initialization ]] do

    function STATIC.Initialize()
        local styleManagerIni = "data/renegade/always_dat/stylemgr.ini.txt"
        STATIC.TheWWUIInput = renegadeUIInputClass.New()

        -- "Simple-pass thru to the WWUI dialog [manager] system"
        if CLIENT then
            dialogBaseClass.SetDefaultCommandHandler( STATIC.DefaultOnCommand )
            dialogManagerClass.Initialize( styleManagerIni )
        end

        dialogManagerClass.InstallInput( STATIC.TheWWUIInput )
    end

    function STATIC.Shutdown()
        typecheck.NotImplementedError()
    end
end

--- @param dialog DialogBaseInstance
--- @param controlId integer
--- @param messageId integer
--- @param param any
function STATIC.DefaultOnCommand( dialog, controlId, messageId, param )
    typecheck.NotImplementedError()
end

--[[ Dialog Creation ]] do

    --- @param buttonId integer
    function STATIC.DoDialogByButtonId( buttonId )
        -- "Start the dialog"
        STATIC.FactoryArray[buttonId - dialogResourcesClass.DIALOG_LINK_FIRST]:DoDialog()
    end

    --- @param dialogResourceId integer
    function STATIC.DoSimpleDialog( dialogResourceId )
        typecheck.NotImplementedError()
    end
end

--[[ Menu Traversal Acccess ]] do

    --- @param location Location
    function STATIC.GotoLocation( location )
        typecheck.NotImplementedError()
    end
end
