-- Based on the functions within Code/Commando/mainloop.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class MainLoopClass
local STATIC = CNC.CreateExport()
STATIC.Class = "MainLoopClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums
--#endregion


--#region Imports

    --- @type DialogManagerClass
    local dialogManagerClass = CNC.Import( "renhud/code/wwui/dialog-manager.lua" )

    --- @type GameModeManagerClass
    local gameModeManagerClass = CNC.Import( "renhud/code/commando/game-mode-manager.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "renhud/code/combat/combat-manager.lua" )

    --- @type InitClass
    local initClass = CNC.Import( "renhud/code/commando/init.lua" )
--#endregion


--#region Imported Enums
--#endregion


--- @class MainLoopClass


function STATIC.GameMainLoopLoop()

    -- Omitting time manager update

    -- inputClass.Update()

    -- "Pathfind Evaluate"
    local combatCamera = combatManagerClass.GetCamera()
    if combatCamera then
        local cameraPos = combatCamera:GetPosition()
        -- Omitting pathfinding evaluation for now
    end

    -- gameModeManagerClass.Think()
    -- gameInitManagerClass.Think()

    dialogManagerClass.OnFrameUpdate()

    -- networkObjectManagerClass.Think()
    -- serverControlClass.Service()

    -- Omitted GameSpy think logic

    -- if not gameModeManagerClass.Find( "Combat" ):IsActive() then
    --     cNetworkClass.Update()
    -- end

    -- "Denzil - Embedded browser"
    -- if webBrowserClass.IsWebPageDisplayed() == false then
    -- gameModeManagerClass.Render()
    -- end

    -- if autoRestartClass.IsActiove() then
    --     autoRestartClass.Think()
    -- end

    -- consoleBoxClass.Think()

    -- if not consoleBoxClass.IsExclusive() then
    --     wWAudioClass.GetInstance():OnFrameUpdate( 0 )
    -- end

    -- messageLoopClass.WindowsMessageHandler()

    -- debugManagerClass.Update()

    -- Omitted sleeping between frames
end

-- This is the main entrypoint for Renegade and for the addon
function STATIC.GameMainLoop()
    if SERVER then
        hook.Add( "InitPostEntity", "A1_Renegade_GameInit_Server", initClass.GameInit )
    end

    if CLIENT then
        hook.Add( "HUDPaint", "A1_Renegade_GameInit_Client", initClass.GameInit )
    end
end

--- Called by InitClass after GameInit() has been called
--- This is split into a callback because GameInit is called via hook rather than directly
function STATIC.PostGameInit()
    hook.Add( "Think", "A1_Renegade_GameInit_Think", STATIC.GameMainLoopLoop )

    if CLIENT then
        hook.Add( "HUDPaint", "A1_Renegade_GameInit_HUDPaint", gameModeManagerClass.Render )
    end
end
hook.Add( "Renegade_PostGameInit", "A1_Renegade_PostGameInit", STATIC.PostGameInit )