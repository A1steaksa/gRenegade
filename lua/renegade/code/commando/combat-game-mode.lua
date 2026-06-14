-- Based on CombatGameModeClass within Code/Commando/combatgmode.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type GameMajorModeClass
local PARENT = CNC.Import( "code/commando/game-major-mode.lua" )

--- @class CombatGameModeClass : GameMajorModeClass
--- @field instance CombatGameModeInstance The metatable used by CombatGameModeInstance
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "CombatGameModeClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class CombatGameModeInstance : GameMajorModeInstance
--- @field Static CombatGameModeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_CombatGameMode : Renegade_GameMajorMode" )
INSTANCE.Class = "CombatGameModeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsCombatGameMode = true


--#region Exported Enums
--#endregion


--#region Imports

    --- @type GameModeClass
    local gameModeClass = CNC.Import( "code/commando/game-mode.lua" )

    --- @type GameTypeClass
    local gameTypeClass = CNC.Import( "code/combat/game-type.lua" )

    --- @type GameModeManagerClass
    local gameModeManagerClass = CNC.Import( "code/commando/game-mode-manager.lua" )

    --- @type LoadingScreenClass
    local loadingScreenClass = CNC.Import( "code/commando/loading-screen.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

    --- @type GameDataClass
    local gameDataClass = CNC.Import( "code/commando/game-data.lua" )

    --- @type RadarManagerClass
    local radarManagerClass = CNC.Import( "code/combat/radar.lua" )

    --- @type RenegadeDialogManagerClass
    local renegadeDialogManagerClass = CNC.Import( "code/commando/renegade-dialog-manager.lua" )

    --- @type WW3dClass
    local wW3dClass = CNC.Import( "code/ww3d2/ww3d.lua" )

    --- @type NetworkObjectManagerClass
    local networkObjectManagerClass = CNC.Import( "code/wwnet/network-object-manager.lua" )

    --- @type SaveLoadSystemClass
    local saveLoadSystemClass = CNC.Import( "code/wwsaveload/save-load.lua" )
--#endregion


--#region Imported Enums

    local gameModeStateEnum = gameModeClass.GAME_MODE_STATE
    local locationEnum = renegadeDialogManagerClass.LOCATION
--#endregion


--[[ Static Functions and Variables ]] do

    --- "Game Mode to do the main combat mode"
    --- @class CombatGameModeClass
    --- @field BackgroundMusic AudibleSoundInstance

    --- @type boolean
    STATIC.IsHudShown = true

    STATIC.ForceGod = false
    STATIC.ForceGodPending = true
    STATIC.DefaultToFirstPerson = true
    STATIC.PendingCampaignContinue = false
    STATIC.GIsLoading = false

    --- Creates a new CombatGameModeInstance
    --- @vararg any
    --- @return CombatGameModeInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_CombatGameMode", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) CombatGameModeInstance, `false` otherwise
    function STATIC.IsCombatGameMode( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsCombatGameMode and true or false
    end

    typecheck.RegisterType( "CombatGameModeInstance", STATIC.IsCombatGameMode )

    --- @param location Location
    function STATIC.CombatToMenu( location )
        -- "Remember: Combat and Menu are not mutually exclusive."
        -- "Therefore this function may be called when menu is already active."
        if not gameModeManagerClass.Find( "Menu" ):IsActive() then
            -- "Do not suspect Combat in Multiplayer game!"
            if gameTypeClass.IsSoloplay() then
                -- "Suspend Combat Mode"
                gameModeManagerClass.Find( "Combat" ):Suspend()
            end

            if gameTypeClass.IsMission() then
                renegadeDialogManagerClass.GotoLocation( location )
            else
                renegadeDialogManagerClass.GotoLocation( locationEnum.LOC_CNC_REFERENCE )
            end
        end
    end

    function STATIC.QuickSave()
        typecheck.NotImplementedError()
    end

    function STATIC.ToggleMultiHud()
        typecheck.NotImplementedError()
    end

    --- @private
    function STATIC.LoadRegistryKeys()
        typecheck.NotImplementedError()
    end

    --- @private
    function STATIC.SaveRegistryKeys()
        typecheck.NotImplementedError()
    end

    --- @private
    function STATIC.PostLoadIdUniquenessCheck()
        typecheck.NotImplementedError()
    end

    --- @private
    function STATIC.PostLoadDynamicObjectFiltering()
        typecheck.NotImplementedError()
    end

    --- @private
    function STATIC.ComputeWorldSize()
        typecheck.NotImplementedError()
    end

    --- @private
    function STATIC.SpawnPointValidation()
        typecheck.NotImplementedError()
    end
end


--- @class CombatGameModeInstance

--- "The name of this mode"
--- @return string
function INSTANCE:Name()
    return "Combat"
end

-- "Called when the mode is activated"
function INSTANCE:Init()
    if not gameTypeClass.IsMission() then
        -- multiHudClass.Init()
    end

    self.PendingCampaignContinue = false

    -- "Initialize the radio command display window"
    -- radioCommandDisplayClass.Initialize()

    -- "Notify combat about the state of the CameraLockedToTurret user option."
    -- vehicleGameObjectClass.SetCameraLockedToTurret( userOpotions.CameraLockedToTurret:Get() )
end

-- "Called when the mode is deactivated"
function INSTANCE:Shutdown()
    typecheck.NotImplementedError()
end

-- "Called each time through the main loop to think when non-inactive"
function INSTANCE:Think()
    typecheck.NotImplementedError()
end

-- "Called each time through the main loop to draw when non-inactive"
function INSTANCE:Render()
    if not self:IsActive() then
        return
    end

    if CLIENT then
        -- "In multi-play, only render the combatmanager when we have a valid camera and the menu is not active"
        local menuActive = false
        local menuMode = gameModeManagerClass.Find( "Menu" ) -- "Activate the main menu"
        if menuMode and menuMode:GetState() == gameModeEnum.GAME_MODE_ACTIVE then
            menuActive = true
        end

        local camera = combatManagerClass.GetCamera()
        if camera and camera:IsValid() and menuActive == false then
            combatManagerClass.Render()
        end
    end

    -- multiHudClass.Render()
    -- bandwidthGraphClass.Render()
    -- playerManagerClass.Render()
    -- teamManagerClass.Render()
    gameDataClass.TheGame():Render()
    -- radioCommandDisplayClass.Render()
end

-- "Activates the mode"
function INSTANCE:Resume()
    typecheck.NotImplementedError()
end

-- "Deactivates the mode (don't shutdown until safe)"
function INSTANCE:Suspend()
    typecheck.NotImplementedError()
end

function INSTANCE:LoadLevel()
    -- HACK HACK - Temporary fix while the combat gamemode is not initialized as it is in the original code
    combatManagerClass.SetLoadProgress( 0 )
    local loadingScreen -- "Try moving this to very start of loading"
    
    
    
    
    
    -- if CLIENT then
    --     loadingScreen = loadingScreenClass.New()
    --     loadingScreen:Render( true )
    -- end





    -- "Hack load reg for default first person.  Is dont again later."
    -- self:LoadRegistryKeys()

    -- "Flush out current level
    -- levelManagerClass.ReleaseLevel()

    if not SERVER then
        -- wW3dClass.InvalidateTextures()
        -- assetStatusClass.PeekInstance():EnableLoadOnDemandReporting( false )
    end

    self.PendingCampaignContinue = false
    STATIC.GIsLoading = true

    --- "
    --- Stop the network layer from processing packets.  This is needed in case a packet import or export accesses the datasafe
    --- from the main thread while the loader thread is loading stuff into the datasafe.  This won't shut off packet acks so no-one
    --- will be disconnected as a result of this.
    --- "
    -- if networkClass.PServerConnection ~= nil then
    --     networkClass.PServerConnection:AllowPacketProcessing( false )
    -- end

    -- if not gameTypeClass.IsSoloplay() and networkClass.PClientConnection ~= nil then
    --     networkClass.PClientConnection:AllowExtraTimeoutForLoading()
    -- end

    combatManagerClass.PreLoadLevel( SERVER and false or true )

    -- systemSettingsClass.ApplyAll()

    -- combatManagerClass.SetCombatMiscHandler( STATIC.GameMiscHandler )

    local mapName = gameDataClass.TheGame():GetMapName()

    local preloadAssets = true

    -- networkObjectManagerClass.SetIsLevelLoading( true )

    -- textureLoaderClass.SuspendTextureLoad()

    combatManagerClass.LoadLevelThreaded( mapName, preloadAssets )

    -- while not combatManagerClass.IsLoadLevelComplete() do
    --     loadingScreen:Render( true )
    -- end


    --[[ Post Load Processing ]] do
        -- loadingScreen:Render( true )
        -- saveLoadSystemClass.PostLoadProcessing( gameTypeClass.IsSoloplay() and nil or networkClass.Update )
        -- networkObjectManagerClass.SetIsLevelLoading( false )
    end

    --[[ Post Load Level ]] do
        -- loadingScreen:Render( true )
        combatManagerClass.PostLoadLevel()
    end





    -- Lots of this function is still missing





    --[[ Radar Init ]] if CLIENT then
        -- "Init the radar after the game is loaded (so we have the global settings)"    
        -- loadingScreen:Render( true )
        radarManagerClass.Init()
        radarManagerClass.SetRadarMode( gameDataClass.TheGame():GetRadarMode() )
    end

end

function INSTANCE:CoreShutdown()
    typecheck.NotImplementedError()
end

function INSTANCE:CoreRestart()
    typecheck.NotImplementedError()
end

--- @private
function INSTANCE:CombatKeyboard()
    typecheck.NotImplementedError()
end

