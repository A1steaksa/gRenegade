-- Based on cGameData within Code/Combat/gamedata.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GameDataClass
--- @field instance GameDataInstance The metatable used by GameDataInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "GameDataClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class GameDataInstance
--- @field Static GameDataClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_GameData" )
INSTANCE.Class = "GameDataInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsGameData = true


--#region Exported Enums
--#endregion


--#region Imports

    --- @type Render2dClass
    local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )

    --- @type Render2dTextClass
    local render2dTextClass = CNC.Import( "code/ww3d2/render-2d-text.lua" )

    --- @type StyleManagerClass
    local styleManagerClass = CNC.Import( "code/wwui/style-manager.lua" )

    --- @type PlayerManagerClass
    local playerManagerClass = CNC.Import( "code/commando/player-manager.lua" )

    --- @type RadarManagerClass
    local radarManagerClass = CNC.Import( "code/combat/radar.lua" )
--#endregion


--#region Imported Enums
    local fontStyleEnum = styleManagerClass.FONT_STYLE
    local radarModeEnum = radarManagerClass.RADAR_MODE
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class GameDataClass
    --- @field TextRenderer Render2dTextInstance



    --- @type GameDataInstance
    STATIC._TheGameData = nil

    --- Creates a new GameDataInstance
    --- @return GameDataInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_GameData" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) GameDataInstance, `false` otherwise
    function STATIC.IsGameData( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsGameData and true or false
    end

    typecheck.RegisterType( "GameDataInstance", STATIC.IsGameData )

    function STATIC.OnetimeInit()
        if CLIENT then
            local font = styleManagerClass.PeekFont( fontStyleEnum.IngameTxt )
            STATIC.TextRenderer = render2dTextClass.New( font )
            -- Omitted setting render 2d text to monospaced
            STATIC.TextRenderer:SetClippingRect( render2dClass.GetScreenResolution() )
        end
    end

    function STATIC.OnetimeShutdown()
        typecheck.NotImplementedError()
    end

    --- @return GameDataInstance
    function STATIC.TheGame()
        return STATIC._TheGameData
    end
end


--- @class GameDataInstance
--- @field RadarMode RadarMode

--- Constructs a new GameDataInstance
function INSTANCE:Renegade_GameData()
    self.DoExeVersionsMatch    = true
    self.DoStringVersionsMatch = true
    self.DoMapsLoop            = true
    self.IsMapCycleOver        = false
    self.MapCycleIndex         = 0

    self.IsIntermission          = false
    self.IsDedicated             = false
    self.IsAutoRestart           = false
    self.IsFriendlyFirePermitted = false
    self.IsTeamChangingAllowed   = true
    self.IsPassworded            = false
    self.IsFreeWeapons           = false
    self.IsLaddered              = false
    self.IsClanGame              = false
    self.IsClientTrusted         = true
    self.RemixTeams              = false
    self.CanRepairBuildings      = true
    self.DriverIsAlwaysGunner    = true
    self.SpawnWeapons            = false

    self.WinnerId = -1
    self.MaxPlayers = 16
    self.TimeLimitMinutes = 0
    self.RadarMode = radarModeEnum.All
    self.IniFilename = ""
    self.Motd = ""

    -- Omitted several function calls and variables

    self.MvpCount = 0
end

function INSTANCE:OnGameBegin()
    typecheck.NotImplementedError()
end

function INSTANCE:OnGameEnd()
    typecheck.NotImplementedError()
end

function INSTANCE:Think()
    typecheck.NotImplementedError()
end

function INSTANCE:Render()
    -- self.ShowGameSettingsLimits()

    if STATIC.TextRenderer then
        STATIC.TextRenderer:Render()
    end
end

--- @param isReloaded boolean
function INSTANCE:ResetGame( isReloaded )
    typecheck.NotImplementedError()
end



--- "A convenience function"
--- @param genericNum integer
--- @param lowerBound integer
--- @param upperBound integer
--- @param key string
--- @return boolean `true` if the generic number was within the upper and lower bounds, `false` otherwise
function INSTANCE:SetGenericNum( genericNum, lowerBound, upperBound, key )
    -- This isn't very convenient at all
    if genericNum >= lowerBound and genericNum <= upperBound then
        self[key] = genericNum
        return true
    else
        return false
    end
end

--- @param newMax integer
--- @return boolean `true` if the value was set successfully, `false` otherwise
function INSTANCE:SetMaxPlayers( newMax )
    return self:SetGenericNum( newMax, 0, playerManagerClass.MAX_PLAYERS, "MaxPlayers" )
end

--- @param name string
function INSTANCE:SetMapName( name )
    self.MapName = name
end

--- @return RadarMode
function INSTANCE:GetRadarMode()
    return self.RadarMode
end