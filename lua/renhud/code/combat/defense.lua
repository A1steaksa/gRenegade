-- Based on DefenseObjectClass within Code/Combat/damage.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DefenseClass
--- @field instance DefenseInstance The metatable used by DefenseInstance
local STATIC = CNC.CreateExport()
local CLASS = "DefenseInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class DefenseInstance
--- @field Static DefenseClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Defense" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDefense = true


--#region Exported Enums
--#endregion


--#region Imports

    --- @type GameTypeClass
    local gameTypeClass = CNC.Import( "renhud/client/code/combat/game-type.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "renhud/code/combat/combat-manager.lua" )
--#endregion


--#region Imported Enums
--#endregion


--- @alias ArmorType integer
--- @alias WarheadType integer

--[[ Static Functions and Variables ]] do

    --- @class DefenseClass

    --- Creates a new DefenseInstance
    --- @param health number? [Default: DEFAULT_HEALTH]
    --- @param skin number? [Default: 0]
    function STATIC.New( health, skin )
        return robustclass.New( "Renegade_Defense", health, skin )
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) DefenseInstance, `false` otherwise
    function STATIC.IsDefense( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDefense and true or false
    end

    typecheck.RegisterType( "DefenseInstance", STATIC.IsDefense )
end


--- @class DefenseInstance
--- @field Skin ArmorType
--- @field ShieldStrength number
--- @field ShieldStrengthMax number
--- @field ShieldType ArmorType
--- @field DamagePoints number
--- @field DeathPoints number
--- @field CanEntityDie boolean
--- @field Owner ScriptableEntityInstance

local DEFAULT_HEALTH          = 100.0
local MAX_MAX_HEALTH          = 2000
local MAX_MAX_SHIELD_STRENGTH = 2000
local PUNISH_DELAY            = 60

--[[ Constructors & Destructor ]] do

    --- Constructs a new DefenseInstance
    --- @param health number? [Default: DEFAULT_HEALTH]
    --- @param skin number? [Default: 0]
    function INSTANCE:Renegade_Defense( health, skin )
        if not health then health = DEFAULT_HEALTH end
        if not skin then skin = 0 end

        self.Skin = skin

        -- Only relevant for non-Player Entities
        self.ShieldStrength = 0
        self.ShieldStrengthMax = 0

        self.ShieldType = 0
        self.CanEntityDie = true
    end
end

--- "[DefenseEntities] now have a pointer to their corresponding [Entity]
--- to report damage and scoring to the PlayerData"
--- @param def DefenseDefInstance
--- @param owner DamageableEntityInstance
function INSTANCE:Init( def, owner )

    self:SetHealthMax( def.HealthMax )
    self:SetHealth( def.Health )

    self:SetShieldStrengthMax( def.ShieldStrengthMax )
    self:SetShieldStrength( def.ShieldStrength )

    self.Skin              = def.Skin
    self.ShieldType        = def.ShieldType
    self.DamagePoints      = def.DamagePoints
    self.DeathPoints       = def.DeathPoints

    self:SetOwner( owner )
end

--[[ Owner ]] do

    --- @param owner DamageableEntityInstance
    function INSTANCE:SetOwner( owner )
        self.Owner = owner
    end

    --- @return DamageableEntityInstance
    function INSTANCE:GetOwner()
        return self.Owner --[[@as DamageableEntityInstance]]
    end
end

--[[ Skin ]] do

    --- @param skin ArmorType
    function INSTANCE:SetSkin( skin )
        self.Skin = skin
    end

    --- @return ArmorType
    function INSTANCE:GetSkin()
        return self.Skin
    end
end

--[[ Health ]] do

    -- Source Entities have a health system built-in, so we use that directly
    -- instead of creating our own on top of that and then syncronizing them.

    --- @param newHealth number
    function INSTANCE:SetHealth( newHealth )
        local owner = self.Owner
        if not IsValid( owner ) then return end
        local clampedHealth = math.Clamp( newHealth, 0, owner:GetMaxHealth() )
        owner:SetHealth( clampedHealth )
    end

    --- @param healthToAdd number
    function INSTANCE:AddHealth( healthToAdd )
        local owner = self.Owner
        if not IsValid( owner ) then return end
        local clampedHealth = math.Clamp( owner:Health() + healthToAdd, 0, owner:GetMaxHealth() )
        self:SetHealth( clampedHealth )
    end

    --- @return number
    function INSTANCE:GetHealth()
        local owner = self.Owner
        if not IsValid( owner ) then return 0 end
        return owner:Health()
    end

    --- @param newHealthMax number
    function INSTANCE:SetHealthMax( newHealthMax )
        local owner = self.Owner
        if not IsValid( owner ) then return end
        local clampedHealthMax = math.Clamp( newHealthMax, 0, MAX_MAX_HEALTH )
        owner:SetMaxHealth( clampedHealthMax )
    end

    --- @return number
    function INSTANCE:GetHealthMax()
        local owner = self.Owner
        if not IsValid( owner ) then return 0 end
        return owner:GetMaxHealth()
    end
end

--[[ Shield ]] do

    -- Only Players have an armor system built-in that we should use when possible.
    -- For non-player Entities, we'll need to add our own armor/shield system.

    --- @param newShieldStrength number
    function INSTANCE:SetShieldStrength( newShieldStrength )
        local owner = self.Owner
        if not IsValid( owner ) then return end

        if owner:IsPlayer() then
            --- @cast owner Player
            owner:SetArmor( newShieldStrength )
            return
        end

        self.ShieldStrength = math.Clamp( newShieldStrength, 0, self.ShieldStrengthMax )
    end

    --- @param strengthToAdd number
    function INSTANCE:AddShieldStrength( strengthToAdd )
        local owner = self.Owner
        if not IsValid( owner ) then return end

        local shieldStrength
        local shieldStrengthMax

        if owner:IsPlayer() then
            --- @cast owner Player
            shieldStrength = owner:Armor()
            shieldStrengthMax = owner:GetMaxArmor()
        else
            shieldStrength = self.ShieldStrength
            shieldStrengthMax = self.ShieldStrengthMax
        end

        self:SetShieldStrength( math.Clamp( shieldStrength + strengthToAdd, 0, shieldStrengthMax ) )
    end

    --- @return number
    function INSTANCE:GetShieldStrength()
        local owner = self.Owner
        if not IsValid( owner ) then return 0 end

        if owner:IsPlayer() then
            --- @cast owner Player
            return owner:Armor()
        end

        return self.ShieldStrength
    end

    --- @param newShieldStrengthMax number
    function INSTANCE:SetShieldStrengthMax( newShieldStrengthMax )
        local owner = self.Owner
        if not IsValid( owner ) then return end

        local clampedShieldStrengthMax = math.Clamp( newShieldStrengthMax, 0, MAX_MAX_SHIELD_STRENGTH )

        if owner:IsPlayer() then
            --- @cast owner Player
            owner:SetMaxArmor( clampedShieldStrengthMax )
        else
            self.ShieldStrengthMax = clampedShieldStrengthMax
        end
    end

    --- @return number
    function INSTANCE:GetShieldStrengthMax()
        local owner = self.Owner
        if not IsValid( owner ) then return 0 end

        if owner:IsPlayer() then
            --- @cast owner Player
            return owner:GetMaxArmor()
        end

        return self.ShieldStrengthMax
    end

    --- @param newShieldType ArmorType
    function INSTANCE:SetShieldType( newShieldType )
        self.ShieldType = newShieldType
    end

    --- @return ArmorType
    function INSTANCE:GetShieldType()
        return self.ShieldType
    end
end

--[[ Apply Damage ]] do

    --- @param offense OffenseInstance
    --- @param scale number? [Default: 1.0]
    --- @param alternateSkin integer? [Default: -1]
    --- @return number
    function INSTANCE:ApplyDamage( offense, scale, alternateSkin )
        if not scale then scale = 1.0 end
        if not alternateSkin then alternateSkin = -1 end

        -- Omitted original ApplyDamage logic

        if SERVER then
            return self:DoDamage( offense, scale, alternateSkin )
        else
            return self:GetHealth()
        end
    end

    --- @param offense OffenseInstance
    --- @param scale number? [Default: 1.0]
    --- @param alternateSkin integer? [Default: -1]
    --- @return number
    function INSTANCE:DoDamage( offense, scale, alternateSkin )
        if not scale then scale = 1.0 end
        if not alternateSkin then alternateSkin = -1 end

        -- Omitted damager and damagee IDs

        local damage = offense:GetDamage() * scale

        -- "Scale damage by difficulty if star is applying"
        if gameTypeClass.IsMission() and offense:GetOwner() == combatManagerClass:GetTheStar() then
            local difficulty = combatManagerClass:GetDifficultyLevel()
            if difficulty == 0 then damage = damage * 2.0 end
            if difficulty == 1 then damage = damage * 1.333 end
            if difficulty == 2 then damage = damage * 1.0 end
        end

        local shieldDamage = 0

        local damageScale = 1
        local shieldDamageScale = 1
        if alternateSkin ~= -1 then
            damageScale = armorWarheadManagerClass:GetDamageMultiplier( alternateSkin, offense:GetWarhead() )
            shieldDamageScale = 0
        else
            local warhead = offense:GetWarhead()
            damageScale = armorWarheadManagerClass:GetDamageMultiplier( self.Skin, warhead )
            shieldDamageScale = armorWarheadMAnagerClass:GetDamageMultiplier( self.ShieldType, warhead )
        end

        -- "Check for punish = no more damage"
        

    end
end

