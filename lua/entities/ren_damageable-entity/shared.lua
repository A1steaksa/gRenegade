-- Based on DamageableGameObj within Code/Combat/damageablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DamageableEntityClass
local STATIC = CNC.CreateExport()

--- @class DamageableEntityInstance : ScriptableEntityInstance
--- @field BaseClass ScriptableEntityInstance
local ENT = ENT --[[@as Entity]]


--#region Imports

    --- @type PlayerTypeClass
    local playerTypeClass = CNC.Import( "renhud/code/combat/player-type.lua" )

    --- @type ColorClass
    local colorClass = CNC.Import( "renhud/code/combat/colors.lua" )

    --- @type DamageableEntityDefClass
    local damageableEntityDefClass = CNC.Import( "renhud/code/combat/damageable-entity-def.lua" )
--#endregion


--#region Imported Enums

    local playerTypeEnum = playerTypeClass.PLAYER_TYPE_ENUM
--#endregion


--[[ Garry's Mod Entity Setup ]] do

    ENT.Base = "ren_scriptable-entity"
end

local BaseClass = baseclass.Get( ENT.Base ) --[[@as ScriptableEntityInstance]]

--- @class DamageableEntityInstance
--- @field Definition DamageableEntityDefInstance
--- @field DefenseEntity DefenseInstance
--- @field PlayerType PlayerTypeEnum
--- @field IsHealthBarDisplayed boolean

--[[ Constructor and Destructor ]] do

    function ENT:RenConstructor()
        BaseClass.RenConstructor( self )

        self.IsHealthBarDisplayed = true
        self:SetPlayerType( playerTypeEnum.Neutral )
    end

    --- Destructor
    function ENT:OnRemove()
        -- self:RemoveAllObservers()
    end
end

--[[ Definitions ]] do

    --- The Renegade Entity Init function
    --- @param definition DamageableEntityDefInstance
    function ENT:Init( definition )
        BaseClass.Init( self, definition )
        self:CopySettings( definition )
    end

    --- @param definition DamageableEntityDefInstance
    function ENT:CopySettings( definition )
        self:SetPlayerType( definition.DefaultPlayerType )
        -- self.DefenseEntity.Init( definition.DefenseEntityDef, self )
    end

    --- @param definition DamageableEntityDefInstance
    function ENT:ReInit( definition )
        local oldPlayerType = self.PlayerType

        -- "Re-initialize the base class"
        BaseClass.ReInit( self, definition )

        -- "Copy any internal settings from the definition"
        self:CopySettings( definition )

        self:SetPlayerType( oldPlayerType )
    end

    --- @return DamageableEntityDefInstance
    function ENT:GetDefinition()
        return BaseClass.GetDefinition( self ) --[[@as DamageableEntityDefInstance]]
    end
end


--- @return DefenseInstance
function ENT:GetDefenseEntity()
    return self.DefenseEntity
end

--- @param damager OffenseInstance
--- @param scale number? [Default: 1.0]
--- @param alternateSkin integer? [Default: -1]
function ENT:ApplyDamage( damager, scale, alternateSkin )
    if not scale then scale = 1.0 end
    if not alternateSkin then alternateSkin = -1 end

    local defenseEntity = self.DefenseEntity

    if defenseEntity:GetHealth() <= 0 then
        return
    end

    -- if self:IsDeletePending() then
    --     return
    -- end

    local oldHealth = defenseEntity:GetHealth()
    local oldShield = defenseEntity:GetShieldStrength()
    defenseEntity:ApplyDamage( damager, scale, alternateSkin )
    local newHealth = defenseEntity:GetHealth()
    local newShield = defenseEntity:GetShieldStrength()

    local diff = oldHealth + oldShield - newHealth - newShield

    -- "Notify the observers"
    local observerList = self:GetObservers()

    for index = 0, #observerList do
        observerList[index]:Damaged( self, damager:GetOwner(), diff )
    end

    if defenseEntity:GetHealth() <= 0 then
        -- "Notify the observers"
        for index = 0, #observerList do
            observerList[index]:Killed( self, damager:GetOwner() )
        end

        self:CompletelyDamaged( damager )
    end
end

--- @param damager OffenseInstance
function ENT:CompletelyDamaged( damager )
    -- Intentionally left empty
end

--[[ Information Settings ]] do

    --- @return IMaterial
    function ENT:GetInfoIconMaterial()
        return self:GetDefinition().InfoIconMaterial
    end

    --- @return integer
    function ENT:GetTranslatedNameId()
        return self:GetDefinition().TranslatedNameId
    end
end

--- @return boolean
function ENT:IsTargetable()
    return not self:GetDefinition().NotTargetable
end

--- @return boolean
function ENT:IsHealthBarDisplayed()
    return self.IsHealthBarDisplayed
end

--- @param state boolean
function ENT:SetIsHealthBarDisplayed( state )
    self.IsHealthBarDisplayed = state
end

--[[ Type Identification ]] do

    function ENT:AsDamageableEntity()
        return self
    end
end

--[[ Teams / Playertypes ]] do

    --- @return PlayerTypeEnum
    function ENT:GetPlayerType()
        return self.PlayerType
    end

    --- @param type PlayerTypeEnum
    function ENT:SetPlayerType( type )
        self.PlayerType = type
    end

    --- @return boolean
    function ENT:IsTeamPlayer()
        local playerType = self.PlayerType
        return playerType == playerTypeEnum.Nod or playerType == playerTypeEnum.GDI
    end

    --- @return Color
    function ENT:GetTeamColor()
        return colorClass.GetColorForTeam( self.PlayerType )
    end

    --- @param other DamageableEntityInstance
    --- @return boolean
    function ENT:IsTeammate( other )
        return (
            (
                other == self
            ) or (
                self:IsTeamPlayer() and
                self:GetPlayerType() == other:GetPlayerType()
            )
        )
    end

    --- @param other DamageableEntityInstance
    --- @return boolean
    function ENT:IsEnemy( other )
        return (
            (
                other ~= self
            ) and (
                playerTypeClass.PlayerTypesAreEnemies( self:GetPlayerType(), other:GetPlayerType() )
            )
        )
    end
end