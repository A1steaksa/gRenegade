-- Based on DamageableGameObj within Code/Combat/damageablegameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ScriptableGameObjectClass
local scriptableGameObjectClass = CNC.Import( "code/combat/scriptable-game-object.lua" )

--- @class DamageableGameObjectClass : ScriptableGameObjectClass
--- @field Instance DamageableGameObjectInstance The metatable used by DamageableGameObjectInstance
local STATIC = CNC.CreateExport( scriptableGameObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DamageableGameObjectClass"
--- @class DamageableGameObjectInstance : ScriptableGameObjectInstance
--- @field Static DamageableGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DamageableGameObject : Renegade_ScriptableGameObject" )
INSTANCE.Class = "DamageableGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDamageableGameObject = true


--#region Imports


    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    --- @type PlayerTypeClass
    local playerTypeClass = CNC.Import( "code/combat/player-type.lua" )

    --- @type BaseGameObjectClass
    local baseGameObjectClass = CNC.Import( "code/combat/base-game-object.lua" )

    --- @type NetworkObjectClass
    local networkObjectClass = CNC.Import( "code/wwnet/network-object.lua" )

    --- @type ColorClass
    local colorClass = CNC.Import( "code/combat/colors.lua" )

--#endregion


--#region Imported Enums


    local playerTypeEnum = playerTypeClass.PLAYER_TYPE_ENUM
    local dirtyBitEnum = networkObjectClass.DIRTY_BIT

--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_PARENT        = enumBuilder:Set( 207011212 ),
        CHUNKID_DEFENSEOBJECT = enumBuilder:Next(),
        CHUNKID_VARIABLES     = enumBuilder:Next(),

        MICROCHUNKID_PLAYER_TYPE             = enumBuilder:Set( 1 ),
        MICROCHUNKID_IS_HEALTH_BAR_DISPLAYED = enumBuilder:Next()
    }
end


--[[ Static Functions and Variables ]] do

    --- @class DamageableGameObjectClass

    --- Creates a new DamageableGameObjectInstance
    --- @return DamageableGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DamageableGameObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DamageableGameObjectInstance, `false` otherwise
    function STATIC.IsDamageableGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDamageableGameObject and true or false
    end

    typecheck.RegisterType( "DamageableGameObjectInstance", STATIC.IsDamageableGameObject )
end


--- @class DamageableGameObjectInstance
--- @field DefenseObject DefenseObjectInstance
--- @field PlayerType PlayerTypeEnum
--- @field _IsHealthBarDisplayed boolean


--[[ Constructor and Destructor ]] do

    --- Constructs a new DamageableGameObjectInstance
    function INSTANCE:Renegade_DamageableGameObject()
        self._IsHealthBarDisplayed = true
        self:SetPlayerType( playerTypeEnum.Neutral )
    end

    function INSTANCE:_delete()
        self:RemoveAllObservers()
    end
end


--[[ Definitions ]] do

    --- @param definition DamageableGameObjectDefinitionInstance
    function INSTANCE:Init( definition )
        scriptableGameObjectClass.Instance.Init( self, definition )
        self:CopySettings( definition )
    end

    --- @param definition DamageableGameObjectDefinitionInstance    
    function INSTANCE:CopySettings( definition )
        self:SetPlayerType( definition.DefaultPlayerType )
        self.DefenseObject:Init( definition.DefenseObjectDefinition, self )
    end

    --- @param definition DamageableGameObjectDefinitionInstance    
    function INSTANCE:ReInit( definition )
        local oldPlayerType = self.PlayerType

        -- "Re-initialize the base class"
        scriptableGameObjectClass.Instance.ReInit( self, definition )

        -- "Copy any internal settings from the definition"
        self:CopySettings( definition )

        self:SetPlayerType( oldPlayerType )
    end

    --- @return DamageableGameObjectDefinitionInstance    
    function INSTANCE:GetDefinition()
        return baseGameObjectClass.Instance.GetDefinition( self ) --[[@as DamageableGameObjectDefinitionInstance]]
    end
end


--[[ Save / Load ]] do

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
end


--- @return DefenseObjectInstance
function INSTANCE:GetDefenseObject()
    return self.DefenseObject
end

--- @param damager OffenseObjectInstance
--- @param scale number? [Default: 1.0]
--- @param alternateSkin integer [Default: -1]
function INSTANCE:ApplyDamage( damager, scale, alternateSkin )
    scale = scale or 1.0
    alternateSkin = alternateSkin or -1

    local defenseObject = self.DefenseObject

    if defenseObject:GetHealth() <= 0 then
        return
    end

    if self:IsDeletePending() then
        return
    end

    local oldHealth = defenseObject:GetHealth()
    local oldShield = defenseObject:GetShieldStrength()
    defenseObject:ApplyDamage( damager, scale, alternateSkin )
    local newHealth = defenseObject:GetHealth()
    local newShield = defenseObject:GetShieldStrength()

    local diff = oldHealth + oldShield - newHealth - newShield

    -- "Notify the observers"
    local observerList = self:GetObservers()

    for index = 1, #observerList do
        observerList[index]:Damaged( self, damager:GetOwner() --[[@as ArmedGameObjectInstance]], diff )
    end

    if defenseObject:GetHealth() <= 0 then
        -- "Notify the observers"
        for index = 1, #observerList do
            observerList[index]:Killed( self, damager:GetOwner() --[[@as ArmedGameObjectInstance]] )
        end

        self:CompletelyDamaged( damager )
    end
end

--- @param damager OffenseObjectInstance
function INSTANCE:CompletelyDamaged( damager )
    -- Empty in the original code
end


--[[ Information Settings ]] do

    --- Originally `Get_Info_Icon_Texture_Filename`
    --- @return IMaterial
    function INSTANCE:GetInfoIconMaterial()
        return self:GetDefinition().InfoIconMaterial
    end

    --- @return integer
    function INSTANCE:GetTranslatedNameId()
        return self:GetDefinition().TranslatedNameId
    end

    --- @return boolean
    function INSTANCE:IsTargetable()
        return not self:GetDefinition().NotTargetable
    end

    --- @return boolean
    function INSTANCE:IsHealthBarDisplayed()
        return self._IsHealthBarDisplayed
    end

    --- @param isHealthBarDisplayed boolean
    function INSTANCE:SetIsHealthBarDisplayed( isHealthBarDisplayed )
        self._IsHealthBarDisplayed = isHealthBarDisplayed
    end
end


--- @return DamageableGameObjectInstance
function INSTANCE:AsDamageableGameObject()
    return self
end


--[[ Teams / Playertypes ]] do

    --- @return PlayerTypeEnum
    function INSTANCE:GetPlayerType()
        return self.PlayerType
    end

    --- @param playerType PlayerTypeEnum
    function INSTANCE:SetPlayerType( playerType )
        self.PlayerType = playerType

        self:SetObjectDirtyBit( dirtyBitEnum.BIT_RARE, true )
    end

    --- @return boolean
    function INSTANCE:IsTeamPlayer()
        local playerType = self.PlayerType
        return playerType == playerTypeEnum.Nod or playerType == playerTypeEnum.GDI
    end

    --- @return Color
    function INSTANCE:GetTeamColor()
        return colorClass.GetColorForTeam( self.PlayerType )
    end

    --- @param damageableGameObject DamageableGameObjectInstance
    --- @return boolean
    function INSTANCE:IsTeammate( damageableGameObject )
        return (
            damageableGameObject == self
            or (
                self:IsTeamPlayer()
                and self:GetPlayerType() == damageableGameObject:GetPlayerType()
            )
        )
    end

    --- @param damageableGameObject DamageableGameObjectInstance
    --- @return boolean
    function INSTANCE:IsEnemy( damageableGameObject )
        return (
            damageableGameObject ~= self
            and playerTypeClass.PlayerTypesAreEnemies(
                self:GetPlayerType(),
                damageableGameObject:GetPlayerType()
            )
        )
    end
end


--[[ Network Support ]] do

    --- @param packet string
    function INSTANCE:ImportOccasional( packet )
        typecheck.NotImplementedError()
    end

    --- @param packet string
    function INSTANCE:ExportOccasional( packet )
        typecheck.NotImplementedError()
    end
end
