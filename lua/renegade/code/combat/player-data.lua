-- Based on PlayerDataClass within Code/Combat/playerdata.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class PlayerDataClass
--- @field Instance PlayerDataInstance The metatable used by PlayerDataInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PlayerDataClass"

--- @class PlayerDataInstance
--- @field Static PlayerDataClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PlayerData" )
INSTANCE.Class = "PlayerDataInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPlayerData = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type CombatManagerClass
	local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

	--- @type HudClass
	local hudClass = CNC.Import( "code/combat/hud.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PlayerDataClass

    --- Creates a new PlayerDataInstance
    --- @return PlayerDataInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PlayerData" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PlayerDataInstance, `false` otherwise
    function STATIC.IsPlayerData( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPlayerData and true or false
    end

    typecheck.RegisterType( "PlayerDataInstance", STATIC.IsPlayerData )
end


--- "
--- This class maintains the score and statistics for human player.     
--- It is intended that the Commando code will derive a custom version, 
--- and install it into each Human Player controlled SoldierGameObj.    
--- When the SoldierGameObj dies, a new one should be created and the   
--- same PlayerDataClass should be plugged into the new SoldierGameObj  
--- It is the creators responsibility to save and restore these classes,
--- and to re-install into the GameObjs after load.                     
--- "
--- @class PlayerDataInstance
--- @field Score number
--- @field Money number
--- @field GameObject GameObjectInstance?
--- @field PunishTimer number
--- @field StatTimeInGame number
--- @field StatTimeInSession number
--- @field StatEnemiesKilled integer
--- @field StatAlliesKilled integer
--- @field StatShotsFired integer
--- @field StatHeadShots integer
--- @field StatTorsoShots integer
--- @field StatArmShots integer
--- @field StatLegShots integer
--- @field StatCrotchShots integer
--- @field StatFinalHealth number
--- @field StatPowerups integer
--- @field StatVehiclesDestroyed integer
--- @field StatTimeInVehicles number
--- @field StatKillsFromVehicles integer
--- @field StatSquishes integer
--- @field StatCreditsGranted number
--- @field StatBuildingsDestroyed integer
--- @field StatHeadHits integer
--- @field StatTorsoHits integer
--- @field StatArmHits integer
--- @field StatLegHits integer
--- @field StatCrotchHits integer
--- @field StatLastWeaponIndex integer
--- @field StatWeaponIdFired integer[]
--- @field StatWeaponFireCount integer[]

function INSTANCE:Renegade_PlayerData()
	self.Score = 0
	self.Money = 0
	self.PunishTimer = 0

	self:StatsReset()
end

function INSTANCE:_Renegade_PlayerData()
	if self:GetGameObject() then
		self:GetGameObject():SetPlayerData( nil )
	end
end

function INSTANCE:ResetPlayer()
	self:StatsReset()
	self:SetScore( 0 )
	self:SetMoney( 0 )
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

--- @param soldier SmartGameObjectInstance?
function INSTANCE:SetGameObject( soldier )
	self.GameObject = soldier
end

--- @return SmartGameObjectInstance
function INSTANCE:GetGameObject()
	return self.GameObject --[[@as SmartGameObjectInstance]]
end


--[[ Score Access ]] do

	--- @return number
	function INSTANCE:GetScore()
		return self.Score
	end

	--- @param score number
	function INSTANCE:SetScore( score )
		self.Score = score
	end

	--- @param add number
	function INSTANCE:IncrementScore( add )
		if not combatManagerClass.IsGameplayPermitted() then
			return
		end

		-- Omitted warnings for large increments

		self.Score = self.Score + add

		-- "TSS101001 - let's try giving 1 credit per point"
		if add > 0 then
			self:IncrementMoney( add )
		end
	end
end


--[[ Money Access ]] do

	--- @return number
	function INSTANCE:GetMoney()
		return self.Money
	end

	--- @param money number
	function INSTANCE:SetMoney( money )
		self.Money = money
	end

	--- @param add number
	function INSTANCE:IncrementMoney( add )
		if add > 0 and not combatManagerClass.IsGameplayPermitted() then
			return
		end

		self.Money = self.Money + add

		if add > 0 then
			self:StatsAddCreditGrant( add )
		end
	end

	--- @param cost integer
	--- @return boolean
	function INSTANCE:PurchaseItem( cost )
		local returnValue = false

		if cost >= 0 then
			-- "Check to ensure the player has enough cash"
			if self.Money >= cost then
				-- "Use [IncrementMoney] so that dirty is set."
				self:IncrementMoney( -1 * cost )

				returnValue = true
			end
		end

		return returnValue
	end
end


--- @param points number
--- @param victim DamageableGameObjectInstance
function INSTANCE:ApplyDamagePoints( points, victim )
	self:IncrementScore( points )

	-- "If this is the star's PlayerData, display the points on the HUD"
	if combatManagerClass.GetTheStar() and combatManagerClass.GetTheStar():GetPlayerData() == self then
		hudClass.DisplayPoints( points )
	end
end

--- @param points number
--- @param victim DamageableGameObjectInstance
function INSTANCE:ApplyDeathPoints( points, victim )
	self:IncrementScore( points )

	-- "If this is the star's PlayerData, display the points on the HUD"
	if self:GetGameObject() == combatManagerClass.GetTheStar() and combatManagerClass.GetTheStar() ~= nil then
		hudClass.DisplayPoints( points )
	end
end

function INSTANCE:ImportOccasional()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportOccasional()
	typecheck.NotImplementedError()
end

function INSTANCE:StatsReset()
	self.StatTimeInGame			= 0
	self.StatTimeInSession		= 0
	self.StatEnemiesKilled		= 0
	self.StatAlliesKilled		= 0
	self.StatShotsFired			= 0
	self.StatHeadShots			= 0
	self.StatTorsoShots			= 0
	self.StatArmShots			= 0
	self.StatLegShots			= 0
	self.StatCrotchShots		= 0
	self.StatFinalHealth		= 0
	self.StatPowerups			= 0
	self.StatVehiclesDestroyed	= 0
	self.StatTimeInVehicles		= 0
	self.StatKillsFromVehicles	= 0
	self.StatSquishes			= 0
	self.StatCreditsGranted		= 0
	self.StatBuildingsDestroyed	= 0
	self.StatHeadHits			= 0
	self.StatTorsoHits			= 0
	self.StatArmHits			= 0
	self.StatLegHits			= 0
	self.StatCrotchHits			= 0

	self.StatLastWeaponIndex = -1
	self.StatWeaponIdFired   = {}
	self.StatWeaponFireCount = {}
end

--- @param time number
function INSTANCE:StatsAddGameTime( time )
	self.StatTimeInGame = self.StatTimeInGame + time
	self.StatTimeInSession = self.StatTimeInSession + time
end

function INSTANCE:StatsAddEnemyKilled()
	self.StatEnemiesKilled = self.StatEnemiesKilled + 1
end

function INSTANCE:StatsAddAllyKilled()
	self.StatAlliesKilled = self.StatAlliesKilled + 1
end

function INSTANCE:StatsAddShotFired()
	self.StatShotsFired = self.StatShotsFired + 1
end

function INSTANCE:StatsAddHeadShot()
	self.StatHeadShots = self.StatHeadShots + 1
end

function INSTANCE:StatsAddTorsoShot()
	self.StatTorsoShots = self.StatTorsoShots + 1
end

function INSTANCE:StatsAddArmShot()
	self.StatArmShots = self.StatArmShots + 1
end

function INSTANCE:StatsAddLegShot()
	self.StatLegShots = self.StatLegShots + 1
end

function INSTANCE:StatsAddCrotchShot()
	self.StatCrotchShots = self.StatCrotchShots + 1
end

--- @param health number
function INSTANCE:StatsSetFinalHealth( health )
	self.StatFinalHealth = health
end

function INSTANCE:StatsAddPowerup()
	self.StatPowerups = self.StatPowerups + 1
end

function INSTANCE:StatsAddVehicleDestroyed()
	self.StatVehiclesDestroyed = self.StatVehiclesDestroyed + 1
end

--- @param time number
function INSTANCE:StatsAddVehicleTime( time )
	self.StatTimeInVehicles = self.StatTimeInVehicles + time
end

function INSTANCE:StatsAddKillFromVehicle()
	self.StatKillsFromVehicles = self.StatKillsFromVehicles + 1
end

function INSTANCE:StatsAddSquish()
	self.StatSquishes = self.StatSquishes + 1
end

--- @param grant number
function INSTANCE:StatsAddCreditGrant( grant )
	self.StatCreditsGranted = self.StatCreditsGranted + grant
end

function INSTANCE:StatsAddBuildingDestroyed()
	self.StatBuildingsDestroyed = self.StatBuildingsDestroyed + 1
end

function INSTANCE:StatsAddHeadHit()
	self.StatHeadHits = self.StatHeadHits + 1
end

function INSTANCE:StatsAddTorsoHit()
	self.StatTorsoHits = self.StatTorsoHits + 1
end

function INSTANCE:StatsAddArmHit()
	self.StatArmHits = self.StatArmHits + 1
end

function INSTANCE:StatsAddLegHit()
	self.StatLegHits = self.StatLegHits + 1
end

function INSTANCE:StatsAddCrotchHit()
	self.StatCrotchHits = self.StatCrotchHits + 1
end

--- @param weaponId integer
function INSTANCE:StatsAddWeaponFired( weaponId )
	-- "Check for using same weapon as last time"
	if self.StatLastWeaponIndex >= 1 and self.StatWeaponIdFired[self.StatLastWeaponIndex] == weaponId then
		self.StatWeaponFireCount[self.StatLastWeaponIndex] = self.StatWeaponFireCount[self.StatLastWeaponIndex] + 1
		return
	end

	-- "See if we already have this weapon"
	for i = 1, #self.StatWeaponIdFired do
		if self.StatWeaponIdFired[i] == weaponId then
			self.StatLastWeaponIndex = i
			self.StatWeaponFireCount[self.StatLastWeaponIndex] = self.StatWeaponFireCount[self.StatLastWeaponIndex] + 1
			return
		end
	end

	-- "Add this new weapon"
	self.StatLastWeaponIndex = #self.StatWeaponIdFired + 1
	self.StatWeaponIdFired[#self.StatWeaponIdFired + 1] = weaponId
	self.StatWeaponFireCount[#self.StatWeaponFireCount + 1] = 1
end

--- @return number
function INSTANCE:GetGameTime()
	return self.StatTimeInGame
end

--- "Note: This is per-session, it is not saved or loaded!"
--- @return number
function INSTANCE:GetSessionTime()
	return self.StatTimeInSession
end

--- @return integer
function INSTANCE:GetEnemiesKilled()
	return self.StatEnemiesKilled
end

--- @return integer
function INSTANCE:GetAlliesKilled()
	return self.StatAlliesKilled
end

--- @return integer
function INSTANCE:GetShotsFired()
	return self.StatShotsFired
end

--- @return integer
function INSTANCE:GetHeadShots()
	return self.StatHeadShots
end

--- @return integer
function INSTANCE:GetTorsoShots()
	return self.StatTorsoShots
end

--- @return integer
function INSTANCE:GetArmShots()
	return self.StatArmShots
end

--- @return integer
function INSTANCE:GetLegShots()
	return self.StatLegShots
end

--- @return integer
function INSTANCE:GetCrotchShots()
	return self.StatCrotchShots
end

--- @return integer
function INSTANCE:GetFinalHealth()
	return self.StatFinalHealth
end

--- @return integer
function INSTANCE:GetPowerupsCollected()
	return self.StatPowerups
end

--- @return integer
function INSTANCE:GetVehicliesDestroyed()
	return self.StatVehiclesDestroyed
end

--- @return number
function INSTANCE:GetVehicleTime()
	return self.StatTimeInVehicles
end

--- @return integer
function INSTANCE:GetKillsFromVehicle()
	return self.StatKillsFromVehicles
end

--- @return integer
function INSTANCE:GetSquishes()
	return self.StatSquishes
end

--- @return integer
function INSTANCE:GetCreditGrant()
	return self.StatCreditsGranted
end

--- @return integer
function INSTANCE:GetBuildingDestroyed()
	return self.StatBuildingsDestroyed
end

--- @return integer
function INSTANCE:GetHeadHit()
	return self.StatHeadHits
end

--- @return integer
function INSTANCE:GetTorsoHit()
	return self.StatTorsoHits
end

--- @return integer
function INSTANCE:GetArmHit()
	return self.StatArmHits
end

--- @return integer
function INSTANCE:GetLegHit()
	return self.StatLegHits
end

--- @return integer
function INSTANCE:GetCrotchHit()
	return self.StatCrotchHits
end

--- @return integer
function INSTANCE:GetWeaponFiredCount()
	return #self.StatWeaponIdFired
end

--- @param index integer
--- @return boolean wasWeaponFound
--- @return integer? weaponId
--- @return integer? firedCount
function INSTANCE:GetWeaponFired( index )
	if index >= 1 and index < #self.StatWeaponIdFired then
		local weaponId = self.StatWeaponIdFired[index]
		local firedCount = self.StatWeaponFireCount[index]
		return true, weaponId, firedCount
	end

	return false
end

--- @return number
function INSTANCE:GetPunishTimer()
	return self.PunishTimer
end

--- @param amount number
function INSTANCE:IncrementPunishTimer( amount )
	self.PunishTimer = self.PunishTimer + amount
end
