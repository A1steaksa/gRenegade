AddCSLuaFile()

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class NodTurretInstance : VehicleEntityInstance
--- @field BaseClass VehicleEntityInstance
local ENT = ENT --[[@as VehicleEntityInstance]]


--#region Imports

    --- @type DefinitionManagerClass
    local definitionManagerClass = CNC.Import( "renhud/code/wwsaveload/definition-manager.lua" )

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
ENT.Definition = definitionManagerClass.FindNamedDefinition( "Nod_Turret" )

function ENT:TargetPlayer()
    local player = player.GetAll()[1]
    local pos = player:GetPos() + Vector( 0, 0, 32 )
    self:SetTargeting( pos, true )
end

function ENT:Draw()
    self:DrawModel()
    self:TargetPlayer()
end