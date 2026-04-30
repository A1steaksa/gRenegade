-- Based on PowerUpGameObjDef within Code/Combat/powerup.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SimpleGameObjectDefinitionClass
local simpleGameObjectDefinitionClass = CNC.Import( "code/combat/simple-game-object-definition.lua" )

--- @class PowerUpGameObjectDefinitionClass : SimpleGameObjectDefinitionClass
--- @field Instance PowerUpGameObjectDefinitionInstance The metatable used by PowerUpGameObjectDefinitionInstance
local STATIC = CNC.CreateExport( simpleGameObjectDefinitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PowerUpGameObjectDefinitionClass"

--- @class PowerUpGameObjectDefinitionInstance : SimpleGameObjectDefinitionInstance
--- @field Static PowerUpGameObjectDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PowerUpGameObjectDefinition : Renegade_SimpleGameObjectDefinition" )
INSTANCE.Class = "PowerUpGameObjectDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPowerUpGameObjectDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type SimplePersistFactoryClass
    local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

    --- @type SimpleDefinitionFactoryClass
    local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

    --- @type CombatChunkId
    local combatChunkId = CNC.Import( "code/combat/combat-chunk-id.lua" )

    --- @type PowerUpGameObjectClass
    local powerUpGameObjectClass = CNC.Import( "code/combat/power-up-game-object.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

    --- @type HudInfoClass
    local hudInfoClass = CNC.Import( "code/combat/hud-info.lua" )

    --- @type TranslateDbClass
    local translateDbClass = CNC.Import( "code/wwtranslatedb/translatedb.lua" )

    --- @type HudClass
    local hudClass = CNC.Import( "code/combat/hud.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion

--#region Imported Enums

    local powerUpStateEnum = powerUpGameObjectClass.STATE
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        DEFENSEOBJECTDEF_CHUNK_VARIABLES            = enumBuilder:Set( 7311607 ),

        DEFENSEOBJECTDEF_VARIABLE_HEALTH            = enumBuilder:Set( 0x00 ),
        DEFENSEOBJECTDEF_VARIABLE_HEALTHMAX         = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SKIN              = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTH    = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTHMAX = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SHIELDTYPE        = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_DAMAGE_POINTS     = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_DEATH_POINTS      = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class PowerUpGameObjectDefinitionClass

    --- Creates a new PowerUpGameObjectDefinitionInstance
    --- @return PowerUpGameObjectDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PowerUpGameObjectDefinition" )
    end

    function STATIC.StaticConstructor()
        STATIC.PowerUpGameObjectDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkId.CHUNKID_GAME_OBJECT_DEF_POWERUP )
        STATIC.PowerUpGameObjectDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, combatChunkId.CHUNKID_GAME_OBJECT_DEF_POWERUP, "PowerUp" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PowerUpGameObjectDefinitionInstance, `false` otherwise
    function STATIC.IsPowerUpGameObjectDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPowerUpGameObjectDefinition and true or false
    end

    typecheck.RegisterType( "PowerUpGameObjectDefinitionInstance", STATIC.IsPowerUpGameObjectDefinition )
end


--- @class PowerUpGameObjectDefinitionInstance
--- @field GrantShieldType integer
--- @field GrantShieldStrength number
--- @field GrantShieldStrengthMax number
--- @field GrantHealth number
--- @field GrantHealthMax number
--- @field GrantWeaponId integer
--- @field GrantWeapon boolean
--- @field GrantWeaponRounds integer
--- @field GrantWeaponClips boolean
--- @field Persistent boolean
--- @field GrantKey integer
--- @field AlwaysAllowGrant boolean
--- @field GrantSoundId integer
--- @field GrantAnimationName string
--- @field IdleSoundId integer
--- @field IdleAnimationName string

function INSTANCE:Renegade_PowerUpGameObjectDefinition()
    self.GrantShieldType        = 0
    self.GrantShieldStrength    = 0
    self.GrantShieldStrengthMax = 0
    self.GrantHealth            = 0
    self.GrantHealthMax         = 0
    self.GrantWeaponId          = 0
    self.GrantWeapon            = true
    self.GrantWeaponClips       = false
    self.GrantWeaponClips       = false
    self.GrantWeaponRounds      = 0
    self.Persistent             = false
    self.GrantKey               = 0
    self.GrantSoundId           = 0
    self.IdleSoundId            = 0
    self.AlwaysAllowGrant       = false
end

--- @return integer
function INSTANCE:GetClassId()
    return combatChunkId.CHUNKID_GAME_OBJECT_DEF_POWERUP
end

--- @param connectedEntity Entity
--- @return PersistInstance
function INSTANCE:Create( connectedEntity )
    local object = powerUpGameObjectClass.New()
    object:Init( self, connectedEntity )
    return object
end

--- @param csave ChunkSaveInstance
--- @return boolean
function INSTANCE:Save( csave )
    typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    typecheck.NotImplementedError()
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
    return STATIC.PowerUpGameObjectDefinitionPersistFactory
end

--- "Grant returns true if anything was granted that the grantee didn't already have"
--- @param object SmartGameObjectInstance
--- @param powerup PowerUpGameObjectInstance? (Optional)
--- @param hudDisplay boolean? [Default: true]
--- @return boolean
function INSTANCE:Grant( object, powerup, hudDisplay )
    hudDisplay = hudDisplay ~= nil and hudDisplay or true

    local noGrantMessage

    local granted = false

    assert( combatManagerClass.IAmServer() )

    local defense = object:GetDefenseObject()
    -- "Grant the shield"
    if self.GrantShieldType ~= 0 then
        if self.GrantShieldType > defense:GetShieldType() then
            defense:SetShieldType( self.GrantShieldType )
            granted = true
        else
            noGrantMessage = "IDS_M00DSGN_DSGN1015I1DSGN_TXT"
        end
    end

    if self.GrantShieldStrengthMax ~= 0 then
        local add = self.GrantShieldStrengthMax * object:GetDefinition():GetDefenseObjectDefinition().ShieldStrengthMax

        local difficulty = combatManagerClass.GetDifficultyLevel()
        if difficulty == 0 then
            add = add * 2.0
        elseif difficulty == 2 then
            add = add * 0.75
        end

        -- "Round up to next integer"
        add = math.floor( add + 0.95 )

        defense:SetShieldStrengthMax( defense:GetShieldStrengthMax() + add )
        granted = true

        if hudDisplay and object:GetConnectedEntity() == combatManagerClass.GetTheStar() then
            hudClass.AddShieldUpgradeGrant( add )
        end
    end

    if self.GrantShieldStrength ~= 0 then
        if defense:GetShieldStrength() < defense:GetShieldStrengthMax() then
            defense:AddShieldStrength( self.GrantShieldStrength )
            granted = true

            -- Omitted debug logging
        else
            noGrantMessage = "IDS_M00DSGN_DSGN1015I1DSGN_TXT"
        end
    end

    if granted and hudDisplay then
        if object:GetConnectedEntity() == combatManagerClass.GetTheStar() then
            if self.GrantShieldStrengthMax == 0 then
                hudClass.AddShieldGrant( self.GrantShieldStrength )
            end
        end
    end

    -- "Grant the Health"
    if self.GrantHealthMax ~= 0 then
        local add = self.GrantHealthMax * object:GetDefinition():GetDefenseObjectDefinition().HealthMax

        local difficulty = combatManagerClass.GetDifficultyLevel()
        if difficulty == 0 then
            add = add * 2.0
        elseif difficulty == 2 then
            add = add * 0.75
        end

        -- "Round up to next integer"
        add = math.floor( add + 0.95 )

        defense:SetHealthMax( defense:GetHealthMax() + add )
        granted = true

        if hudDisplay and object:GetConnectedEntity() == combatManagerClass.GetTheStar() then
            hudClass.AddHealthUpgradeGrant( add )
        end
    end

    if self.GrantHealth ~= 0 then
        if defense:GetHealth() < defense:GetHealthMax() then
            defense:AddHealth( self.GrantHealth )
            granted = true

            if object:GetConnectedEntity() == combatManagerClass.GetTheStar() and hudDisplay then
                if self.GrantHealthMax == 0 then
                    hudClass.AddHealthGrant( self.GrantHealth )
                end
            end

            -- Omitted debug logging
        else
            noGrantMessage = "IDS_M00DSGN_DSGN1014I1DSGN_TXT"
        end
    end

    -- "Grant the Weapon"
    if self.GrantWeaponId ~= 0 then
        -- TODO: implement weapon granting
    elseif self.GrantWeaponClips then
        -- TODO: implement weapon granting
    end

    -- "Grant the key"
    if self.GrantKey ~= 0 then
        local soldier = object:AsSoldierGameObject()
        if soldier and soldier:IsHumanControlled() then
            if not soldier:HasKey( self.GrantKey ) then
                soldier:GiveKey( self.GrantKey )
                granted = true
            end
        end
        -- Omitted debug logging

        if granted and hudDisplay and object:GetConnectedEntity() == combatManagerClass.GetTheStar() then
            hudClass.AddKeyGrant( self.GrantKey )
        end
    end

    if self.AlwaysAllowGrant then
        granted = true
    end

    if granted and powerup then
        powerup:SetState( powerUpStateEnum.STATE_GRANTING )

        -- "Reveal this object to the player"
        -- if combatManagerClass.GetTheStar() == object:GetConnectedEntity() then
        --     encyclopediaManagerClass.RevealObject( powerup )
        -- end
    end

    -- "Stats"
    -- if granted and object:GetPlayerData() then
    --     object:GetPlayerData():StatsAddPowerup()
    -- end

    if not granted and ( combatManagerClass.GetTheStar() == object:GetConnectedEntity() and noGrantMessage ) then
        hudInfoClass.SetHudHelpText( translateDbClass.GetString( noGrantMessage ), Color( 0, 255, 0 ) )
    end

    return granted
end

--- @return integer
function INSTANCE:GetGrantWeaponId()
    return self.GrantWeaponId
end
