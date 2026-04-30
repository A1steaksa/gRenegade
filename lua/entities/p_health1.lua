AddCSLuaFile()

--- @class Renegade
local CNC = CNC_RENEGADE

-- ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Box of bandages"
ENT.Category = "C&C Renegade"
ENT.Spawnable = true
ENT.AutomaticFrameAdvance = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type PowerUpGameObjectClass
    local powerUpGameObjectClass = CNC.Import( "code/combat/power-up-game-object.lua" )

    --- @type PowerUpGameObjectDefinitionClass
    local powerUpGameObjectDefinitionClass = CNC.Import( "code/combat/power-up-game-object-definition.lua" )
--#endregion

--#region Imported Enums
--#endregion


function ENT:Initialize()

    local definition = powerUpGameObjectDefinitionClass.New()
    definition.GrantHealth = 25
    definition.IdleAnimationName = "idle"
    definition.Name = "Box of bandages"

    self.PowerUpGameObjectInstance = powerUpGameObjectClass.New()
    self.PowerUpGameObjectInstance:Init( definition, self )

    if SERVER then
        self:SetModel( "models/cnc_renegade/powerups/p_health1.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_NONE )
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:EnableGravity( false )
            phys:EnableMotion( false )
            phys:Wake()
        end
    end

    self:ResetSequence( "idle" )
end

--- @param isFullUpdate boolean
function ENT:OnRemove( isFullUpdate )
    if isFullUpdate then return end

    robustclass.Delete( self.PowerUpGameObjectInstance )
end

function ENT:Think()

    if SERVER then
        self:NextThink( CurTime() )
        return true
    end
end