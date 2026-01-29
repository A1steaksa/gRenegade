-- Based on cGameDataSinglePlayer within Code/Commando/gdsingleplayer.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type GameDataClass
local PARENT = CNC.Import( "renhud/code/commando/game-data.lua" )

--- @class GameDataSinglePlayerClass : GameDataClass
--- @field instance GameDataSinglePlayerInstance The metatable used by GameDataSinglePlayerInstance
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "GameDataSinglePlayerClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class GameDataSinglePlayerInstance : GameDataInstance
--- @field Static GameDataSinglePlayerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_GameDataSinglePlayer : Renegade_GameData" )
INSTANCE.Class = "GameDataSinglePlayerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsGameDataSinglePlayer = true


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum GameDataGameType
    STATIC.GAME_DATA_GAME_TYPE = {
        SinglePlayer = enumBuilder:Set( 0 ),
        Skirmish     = enumBuilder:Next(),
        Cnc          = enumBuilder:Next()
    }
    local gameDataGameTypeEnum = STATIC.GAME_DATA_GAME_TYPE
--#endregion


--#region Imports

    --- @type PlayerTypeClass
    local playerTypeClass = CNC.Import( "renhud/code/combat/player-type.lua" )

    --- @type TranslateDbClass
    local translationDbClass = CNC.Import( "renhud/code/wwtranslatedb/translatedb.lua" )
--#endregion


--#region Imported Enums

    local playerTypeEnum = playerTypeClass.PLAYER_TYPE_ENUM
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class GameDataSinglePlayerClass

    --- Creates a new GameDataSinglePlayerInstance
    --- @return GameDataSinglePlayerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_GameDataSinglePlayer" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) GameDataSinglePlayerInstance, `false` otherwise
    function STATIC.IsGameDataSinglePlayer( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsGameDataSinglePlayer and true or false
    end

    typecheck.RegisterType( "GameDataSinglePlayerInstance", STATIC.IsGameDataSinglePlayer )

    --- @return string
    function STATIC.GetStaticGameName()
        return translationDbClass.GetString( "IDS_MP_GAME_TYPE_SINGLE_PLAYER" )
    end
end


--- @class GameDataSinglePlayerInstance

--- Constructs a new GameDataSinglePlayerInstance
function INSTANCE:Renegade_GameDataSinglePlayer()
    self.IsFriendlyFirePermitted = true
    self.IsTeamChangingAllowed = false
    self.SpawnWeapons = true

    self:SetMaxPlayers( 1 )
end

--- @return boolean
function INSTANCE:IsSinglePlayer()
    return true
end

--- @return GameDataSinglePlayerInstance
function INSTANCE:AsSinglePlayer()
    return self
end

--- @return string
function INSTANCE:GetGameName()
    return STATIC.GetStaticGameName()
end

--- @return GameDataGameType
function INSTANCE:GetGameType()
    return gameDataGameTypeEnum.SinglePlayer
end

--- @return boolean
function INSTANCE:IsLimited()
    return true
end

--- @param player Player
--- @param teamChoice integer
--- @param isGrunt boolean
--- @return PlayerTypeEnum
function INSTANCE:ChoosePlayerType( player, teamChoice, isGrunt )
    return isGrunt and playerTypeEnum.Nod or playerTypeEnum.GDI
end

--- @return boolean
function INSTANCE:RememberInventory()
    return true
end
