AddCSLuaFile()

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class NodTurretInstance : VehicleEntityInstance
--- @field BaseClass VehicleEntityInstance
local ENT = ENT --[[@as VehicleEntityInstance]]


--#region Imports

    --- @type VehicleEntityClass
    local vehicleEntityClass = CNC.Import( "entities/ren_vehicle-entity/shared.lua" )

    --- @type VehicleEntityDefClass
    local vehicleEntityDefClass = CNC.Import( "renhud/code/combat/vehicle-entity-def.lua" )

    --- @type RadarManagerClass
    local radarManagerClass = CNC.Import( "renhud/client/code/combat/radar.lua" )
--#endregion


--#region Imported Enums

    local vehicleTypeEnum = vehicleEntityClass.VEHICLE_TYPE
    local radarShapeTypeEnum = radarManagerClass.BLIP_SHAPE_TYPE
--#endregion


ENT.Type = "anim"
ENT.Base = "ren_vehicle-entity"
ENT.PrintName = "NOD Turret"
ENT.Author = "A1steaksa"
ENT.Category = "C&C Renegade"
ENT.Spawnable = true

ENT.Model = "models/cnc_renegade/vehicles/v_nod_turret.mdl"

local def = vehicleEntityDefClass.New()
ENT.StartingDefinition = def

def.BullseyeOffsetZ = 1
def.RadarBlipType = radarShapeTypeEnum.Stationary
def.Animation = ""
def.DefaultHibernationEnable = true
def.AllowInnateConversations = false
def.UseCreationEffect = false

def.WeaponTiltRate = math.rad( 57.300 )
def.WeaponTiltMin = -20.750
def.WeaponTiltMax = 45.750
def.WeaponTurnRate = math.rad( 30.000 )
def.WeaponTurnMin = -572957.750
def.WeaponTurnMax = 572957.750
def.WeaponError = 50.000
def.WeaponRounds = -1

def.SightRange = 80.000
def.SightArc = 360.000
def.ListenerScale = 1

def.IsStealthUnit = false

def.TypeName = ""
def.Fire0Anim = ""
def.Fire1Anim = ""
def.Profile = ""
def.TurnRadius = 0
def.SquishVelocity = 5
def.Aim2d = true
def.Type = vehicleTypeEnum.Turret
def.OccupantsVisible = true
def.EngineSoundMaxPitchFactor = 2
-- Omitted Engine Sounds
def.SightDownMuzzle = true
def.VehicleNameId = -1
def.NumSeats = 0
def.GdiDamageReportId = -1
def.NodDamageReportId = -1
def.GdiDestroyReportId = -1
def.NodDestroyReportId = -1

function ENT:TargetPlayer()
    local player = player.GetAll()[1]
    local pos = player:GetPos() + Vector( 0, 0, 32 )
    self:SetTargeting( pos, true )
end

function ENT:Draw()
    self:DrawModel()
    self:TargetPlayer()
end