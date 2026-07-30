-- Based on cGameData within Code/Commando/gamedata.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class GameDataClass
--- @field Instance GameDataInstance The metatable used by GameDataInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "GameDataClass"

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
    --- @field IniSectionName any
    --- @field LimitsXPos any
    --- @field MaxTimeLimit any
    --- @field TextRenderer Render2dTextInstance
    --- @field HostedGameNumber any
    --- @field IsManualRestart any
    --- @field IsManualExit any
    --- @field WinText any
    --- @field _ThegameData GameDataInstance

    --- Creates a new GameDataInstance
    --- @return GameDataInstance
    function STATIC.New()
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

	--- @return GameDataInstance
	function STATIC.TheGame()
		return STATIC._TheGameData
	end

	function STATIC.OnetimeShutdown()
		typecheck.NotImplementedError()
	end

	function STATIC.CreateGameOfType()
		typecheck.NotImplementedError()
	end

	function STATIC.SetHostedGameNumber()
		typecheck.NotImplementedError()
	end

	function STATIC.IncrementHostedGameNumber()
		typecheck.NotImplementedError()
	end

	function STATIC.GetHostedGameNumber()
		typecheck.NotImplementedError()
	end

	function STATIC.IsManualRestart()
		typecheck.NotImplementedError()
	end

	function STATIC.SetManualRestart()
		typecheck.NotImplementedError()
	end

	function STATIC.IsManualExit()
		typecheck.NotImplementedError()
	end

	function STATIC.SetManualExit()
		typecheck.NotImplementedError()
	end

	function STATIC.SetWinText()
		typecheck.NotImplementedError()
	end

	function STATIC.GetWinText()
		typecheck.NotImplementedError()
	end

	function STATIC.GetMissionNumberFromMapName()
		typecheck.NotImplementedError()
	end
end


--- @class GameDataInstance
--- @field IsIntermission any
--- @field IsDedicated any
--- @field IsAutoRestart any
--- @field IsFriendlyFirePermitted any
--- @field IsTeamChangingAllowed any
--- @field IsPassworded any
--- @field IsFreeWeapons any
--- @field IsLaddered any
--- @field IsClanGame any
--- @field IsClientTrusted any
--- @field RemixTeams any
--- @field CanRepairBuildings any
--- @field DriverIsAlwaysGunner any
--- @field SpawnWeapons any
--- @field DoMapsLoop any
--- @field IsMapCycleOver any
--- @field MapCycleIndex any
--- @field GameTitle any
--- @field Motd any
--- @field Password any
--- @field MapName any
--- @field ModName any
--- @field MapCycle any
--- @field Owner any
--- @field BottomText any
--- @field OldBottomText any
--- @field SettingsDescription any
--- @field MaxPlayers any
--- @field TimeLimitMinutes any
--- @field IntermissionTimeSeconds any
--- @field VersionNumber any
--- @field DoExeVersionsMatch any
--- @field DoStringVersionsMatch any
--- @field IpAddress any
--- @field Port any
--- @field IniFilename any
--- @field RadarMode any
--- @field LastServerConfigModTime any
--- @field CurrentPlayers any
--- @field IntermissionTimeRemaining any
--- @field TimeRemainingSeconds any
--- @field MaximumWorldDistance any
--- @field MinQualifyingTimeMinutes any
--- @field WinnerId any
--- @field WinType any
--- @field GameStartTime any
--- @field GameStartTimeMs any
--- @field FrameCount any
--- @field MvpName any
--- @field MvpCount any
--- @field GameDurationS any
--- @field IsQuickMatchServer any
--- @field ClanSlots any

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

function INSTANCE:_Renegade_GameData()
	typecheck.NotImplementedError()
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

function INSTANCE:SwapTeamSides()
	typecheck.NotImplementedError()
end

function INSTANCE:RemixTeamSides()
	typecheck.NotImplementedError()
end

function INSTANCE:RebalanceTeamSides()
	typecheck.NotImplementedError()
end

function INSTANCE:AddBottomText()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTimeLimitText()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDedicatedServerLabel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetGameplayNotPermittedLabel()
	typecheck.NotImplementedError()
end

function INSTANCE:SetGameTitle()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMotd()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPassword()
	typecheck.NotImplementedError()
end

--- @param name string
function INSTANCE:SetMapName( name )
    self.MapName = name
end

function INSTANCE:SetModName()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMapCycle()
	typecheck.NotImplementedError()
end

function INSTANCE:SetOwner()
	typecheck.NotImplementedError()
end

--- @param newMax integer
--- @return boolean `true` if the value was set successfully, `false` otherwise
function INSTANCE:SetMaxPlayers( newMax )
    return self:SetGenericNum( newMax, 0, playerManagerClass.MAX_PLAYERS, "MaxPlayers" )
end

function INSTANCE:SetTimeLimitMinutes()
	typecheck.NotImplementedError()
end

function INSTANCE:SetRadarMode()
	typecheck.NotImplementedError()
end

function INSTANCE:SetIntermissionTimeSeconds()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVersionNumber()
	typecheck.NotImplementedError()
end

function INSTANCE:SetCurrentPlayers()
	typecheck.NotImplementedError()
end

function INSTANCE:SetIpAddress()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPort()
	typecheck.NotImplementedError()
end

function INSTANCE:SetQuickMatchServer()
	typecheck.NotImplementedError()
end

function INSTANCE:IsQuickMatchServer()
	typecheck.NotImplementedError()
end

function INSTANCE:SetClan()
	typecheck.NotImplementedError()
end

function INSTANCE:GetClan()
	typecheck.NotImplementedError()
end

function INSTANCE:ClearClans()
	typecheck.NotImplementedError()
end

function INSTANCE:FindFreeClanSlot()
	typecheck.NotImplementedError()
end

function INSTANCE:IsClanCompeting()
	typecheck.NotImplementedError()
end

function INSTANCE:IsClanGameOpen()
	typecheck.NotImplementedError()
end

function INSTANCE:GetGameTitle()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMotd()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPassword()
	typecheck.NotImplementedError()
end

function INSTANCE:GetModName()
	typecheck.NotImplementedError()
end

--- @return string
function INSTANCE:GetMapName()
	return self.MapName
end

function INSTANCE:GetMapCycle()
	typecheck.NotImplementedError()
end

function INSTANCE:DoesMapExist()
	typecheck.NotImplementedError()
end

function INSTANCE:GetOwner()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaxPlayers()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTimeLimitMinutes()
	typecheck.NotImplementedError()
end

function INSTANCE:GetIntermissionTimeSeconds()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVersionNumber()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCurrentPlayers()
	typecheck.NotImplementedError()
end

function INSTANCE:GetIpAddress()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPort()
	typecheck.NotImplementedError()
end

--- @return RadarMode
function INSTANCE:GetRadarMode()
    return self.RadarMode
end

function INSTANCE:GetGameName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetGameType()
	typecheck.NotImplementedError()
end

function INSTANCE:GetGameTypeName()
	typecheck.NotImplementedError()
end

function INSTANCE:ChoosePlayerType()
	typecheck.NotImplementedError()
end

function INSTANCE:IsTimeLimit()
	typecheck.NotImplementedError()
end

function INSTANCE:RotateMap()
	typecheck.NotImplementedError()
end

function INSTANCE:ClearMapCycle()
	typecheck.NotImplementedError()
end

function INSTANCE:SetIpAndPort()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadFromServerConfig()
	typecheck.NotImplementedError()
end

function INSTANCE:SaveToServerConfig()
	typecheck.NotImplementedError()
end

function INSTANCE:IsEditableTeaming()
	typecheck.NotImplementedError()
end

function INSTANCE:IsEditableClanGame()
	typecheck.NotImplementedError()
end

function INSTANCE:IsEditableFriendlyFire()
	typecheck.NotImplementedError()
end

function INSTANCE:SoldierAdded()
	typecheck.NotImplementedError()
end

function INSTANCE:ShowGameSettingsLimits()
	typecheck.NotImplementedError()
end

function INSTANCE:DoExeVersionsMatch()
	typecheck.NotImplementedError()
end

function INSTANCE:DoStringVersionsMatch()
	typecheck.NotImplementedError()
end

function INSTANCE:IsMapCycleOver()
	typecheck.NotImplementedError()
end

function INSTANCE:SetIsMapCycleOver()
	typecheck.NotImplementedError()
end

function INSTANCE:DoMapsLoop()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDoMapsLoop()
	typecheck.NotImplementedError()
end

function INSTANCE:IsMapValid()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSinglePlayer()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSkirmish()
	typecheck.NotImplementedError()
end

function INSTANCE:IsCnc()
	typecheck.NotImplementedError()
end

function INSTANCE:AsSinglePlayer()
	typecheck.NotImplementedError()
end

function INSTANCE:AsSkirmish()
	typecheck.NotImplementedError()
end

function INSTANCE:AsCnc()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMinPlayers()
	typecheck.NotImplementedError()
end

function INSTANCE:ChooseAvailableTeam()
	typecheck.NotImplementedError()
end

function INSTANCE:ChooseSmallestTeam()
	typecheck.NotImplementedError()
end

function INSTANCE:IsGameOver()
	typecheck.NotImplementedError()
end

function INSTANCE:GameOverProcessing()
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

function INSTANCE:IsLimited()
	typecheck.NotImplementedError()
end

function INSTANCE:IsValidSettings()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportTier1Data()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportTier1Data()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportTier2Data()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportTier2Data()
	typecheck.NotImplementedError()
end

function INSTANCE:BeginIntermission()
	typecheck.NotImplementedError()
end

function INSTANCE:GetIntermissionTimeRemaining()
	typecheck.NotImplementedError()
end

function INSTANCE:SetIntermissionTimeRemaining()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaximumWorldDistance()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMaximumWorldDistance()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFrameCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetGameStartTime()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDurationSeconds()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMinQualifyingTimeMinutes()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMinQualifyingTimeMinutes()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTeamWord()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTimeRemainingSeconds()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetTimeRemainingSeconds()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTimeRemainingSeconds()
	typecheck.NotImplementedError()
end

function INSTANCE:IsValidPlayerType()
	typecheck.NotImplementedError()
end

function INSTANCE:SetIniFilename()
	typecheck.NotImplementedError()
end

function INSTANCE:GetIniFilename()
	typecheck.NotImplementedError()
end

function INSTANCE:IsGameplayPermitted()
	typecheck.NotImplementedError()
end

function INSTANCE:RememberInventory()
	typecheck.NotImplementedError()
end

function INSTANCE:SetWinnerId()
	typecheck.NotImplementedError()
end

function INSTANCE:GetWinnerId()
	typecheck.NotImplementedError()
end

function INSTANCE:FilterSpawners()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMvpName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMvpName()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMvpCount()
	typecheck.NotImplementedError()
end

function INSTANCE:IncrementMvpCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMvpCount()
	typecheck.NotImplementedError()
end

function INSTANCE:SetWinType()
	typecheck.NotImplementedError()
end

function INSTANCE:GetWinType()
	typecheck.NotImplementedError()
end

function INSTANCE:SetGameDurationS()
	typecheck.NotImplementedError()
end

function INSTANCE:GetGameDurationS()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDescription()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSettingsDescription()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSettingsDescription()
	typecheck.NotImplementedError()
end

function INSTANCE:ReceiveSignal()
	typecheck.NotImplementedError()
end

function INSTANCE:HasConfigFileChanged()
	typecheck.NotImplementedError()
end

function INSTANCE:GetConfigFileModTime()
	typecheck.NotImplementedError()
end
