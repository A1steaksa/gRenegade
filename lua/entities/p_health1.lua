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

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )
--#endregion

--#region Imported Enums
--#endregion


function ENT:Initialize()
    if SERVER then
        self:SetModel( "models/props_junk/PopCan01a.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_NONE )
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:EnableGravity( false )
            phys:EnableMotion( false )
        end
    end

    self:ResetSequence( "idle" )

    if self.PowerUpGameObjectInstance == nil then
        local definitionId = 1665

        local definition = definitionManagerClass.FindDefinition( definitionId ) --[[@as PowerUpGameObjectDefinitionInstance]]
        if definition == nil then
            section.Error( "Unable to find definition ID ", definitionId, " for ", self )
            return
        end

        self.PowerUpGameObjectInstance = powerUpGameObjectClass.New()
        self.PowerUpGameObjectInstance:Init( definition, self )
    end
end

--- @param isFullUpdate boolean
function ENT:OnRemove( isFullUpdate )
    if isFullUpdate then return end

    robustclass.Delete( self.PowerUpGameObjectInstance )
end

function ENT:Think()

    -- This is hacky and bad and should be replaced with a proper looping animation solution ASAP
    if self:IsSequenceFinished() then
        self:ResetSequence( "idle" )
    end

    if SERVER then
        self:NextThink( CurTime() )
        return true
    end
end