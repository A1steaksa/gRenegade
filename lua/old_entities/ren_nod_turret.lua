AddCSLuaFile()

--- @class Renegade
local CNC = CNC_RENEGADE


--#region Imports

    --- @type VehicleEntityClass
    local vehicleEntityClass = CNC.Import( "entities/ren_vehicle-entity/shared.lua" )
--#endregion


ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "NOD Turret"
ENT.Author = "A1steaksa"
ENT.Category = "C&C Renegade"
ENT.Spawnable = true

ENT.DefinitionName = "Nod_Turret"
ENT.Model = "models/cnc_renegade/vehicles/v_nod_turret.mdl"

function ENT:Initialize()
    if SERVER then
        self:SetModel( self.Model or "models/Gibs/HGIBS.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )

        self:SetUseType( SIMPLE_USE )

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end

        self:SetSaveValue( "m_takedamage", 2 ) -- 2 is DAMAGE_YES
    end

    -- self.RenClass = vehicleEntityclass.New()
    -- self.RenClass:SetConnectedEntity( self )
    -- self.RenClass:Init()
end

-- function ENT:OnRemove()
--     if self.RenClass then
--         self.RenClass:Shutdown()
--     end
-- end