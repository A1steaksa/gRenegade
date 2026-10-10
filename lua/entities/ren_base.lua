AddCSLuaFile()

--- @class Renegade
local CNC = CNC_RENEGADE
ENT.PrintName = "Base Renegade Entity"
ENT.Base = "base_anim"
ENT.Category = "C&C Renegade"
ENT.Spawnable = false
ENT.AutomaticFrameAdvance = true

ENT.DefinitionId = -1


--#region Exported Enums
--#endregion

--#region Imports

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

	--- @type RenderInfoClass
	local renderInfoClass = CNC.Import( "code/ww3d2/render-info.lua" )

	--- @type CombatManagerClass
	local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

	--- @type GameObjectManagerClass
	local gameObjectManagerClass = CNC.Import( "code/combat/game-object-manager.lua" )
--#endregion

--#region Imported Enums
--#endregion

function ENT:Initialize()
    if SERVER then
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_NONE )
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:EnableGravity( false )
            phys:EnableMotion( false )
        end
    end

    if self.PowerUpGameObjectInstance == nil then
        local definition = definitionManagerClass.FindDefinition( self.DefinitionId ) --[[@as PhysicalGameObjectDefinitionInstance]]
        if definition == nil then
            section.Error( "Unable to find definition ID ", self.DefinitionId, " for ", self )
            return
        end

        self.GameObjectInstance = definition:Create( self ) --[[@as PhysicalGameObjectInstance]]
        self.RenderInfo = renderInfoClass.New( combatManagerClass.GetCamera() )
        self.RenegadeModel = self.GameObjectInstance:PeekModel()
    end
end

--- @param isFullUpdate boolean
function ENT:OnRemove( isFullUpdate )
    if isFullUpdate then return end

    gameObjectManagerClass.Remove( self.GameObjectInstance )
    robustclass.Delete( self.GameObjectInstance )
end

function ENT:Draw()
    if self.RenegadeModel == nil then return end

    self.RenegadeModel:Render( self.RenderInfo )
end