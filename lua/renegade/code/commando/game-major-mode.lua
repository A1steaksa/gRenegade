-- Based on GameMajorModeClass within Code/Commando/gamemode.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type GameModeClass
local gameModeClass = CNC.Import( "code/commando/game-mode.lua" )

--- @class GameMajorModeClass : GameModeClass
--- @field instance GameMajorModeInstance The metatable used by GameMajorModeInstance
local STATIC = CNC.CreateExport( gameModeClass )
STATIC.Class = "GameMajorModeClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class GameMajorModeInstance : GameModeInstance
--- @field Static GameMajorModeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_GameMajorMode : Renegade_GameMode" )
INSTANCE.Class = "GameMajorModeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsGameMajorMode = true


--#region Imported Enums

    local gameModeStateEnum = STATIC.GAME_MODE_STATE
--#endregion


--[[ Static Functions and Variables ]] do

    --- "Only one Major Game mode can be active any any time"
    --- @class GameMajorModeClass

    STATIC.NumActiveMajorModes = 0

    --- Creates a new GameMajorModeInstance
    --- @return GameMajorModeInstance
    function STATIC.New()
        return robustclass.New( "Renegade_GameMajorMode" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) GameMajorModeInstance, `false` otherwise
    function STATIC.IsGameMajorMode( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsGameMajorMode and true or false
    end

    typecheck.RegisterType( "GameMajorModeInstance", STATIC.IsGameMajorMode )
end


--- @class GameMajorModeInstance

function INSTANCE:Renegade_GameMajorMode()
    gameModeClass.Instance.Renegade_GameMode( self )
end

-- "Make sure we only have 1 active majormode"
function INSTANCE:Activate()
    if self.State == gameModeStateEnum.GAME_MODE_INACTIVE then
        STATIC.NumActiveMajorModes = STATIC.NumActiveMajorModes + 1
        assert( STATIC.NumActiveMajorModes == 1 )
    end
    gameModeClass.Instance.Activate( self )
end


function INSTANCE:Deactivate()
    if not self:IsInactive() then
        STATIC.NumActiveMajorModes = STATIC.NumActiveMajorModes - 1
        assert( STATIC.NumActiveMajorModes == 0 )
    end
    gameModeClass.Instance.Deactivate( self )
end