-- Based on DamageableGameObjDef within Code/Combat/damageablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type ScriptableEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/scriptable-entity-def.lua" )

--- @class DamageableEntityDefClass : ScriptableEntityDefClass
local STATIC = CNC.CreateExport( PARENT )
local CLASS = "DamageableEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class DamageableEntityDefInstance: ScriptableEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_DamageableEntityDefClass : Renegade_ScriptableEntityDefClass" )
INSTANCE.IsDamageableEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--#region Imports

    --- @type PlayerType
    local playerType = CNC.Import( "renhud/code/combat/player-type.lua" )
--#endregion


--#region Imported Enums

    local playerTypeEnum = playerType.PLAYER_TYPE_ENUM
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class DamageableEntityDefClass

    --- Creates a new DamageableEntityDefClass
    --- @vararg any
    --- @return DamageableEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_DamageableEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DamageableEntityDefInstance, `false` otherwise
    function STATIC.IsDamageableEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDamageableEntityDefClass and true or false
    end

    typecheck.RegisterType( "DamageableEntityDefInstance", STATIC.IsDamageableEntityDefClass )
end


--- @class DamageableEntityDefInstance
--- @field DefenseEntityDef DefenseDefClass
--- @field InfoIconMaterial IMaterial
--- @field TranslatedNameId integer
--- @field EncyclopediaType EncyclopediaTypeEnum
--- @field EncyclopediaId integer
--- @field NotTargetable boolean
--- @field DefaultPlayerType integer

--- Constructs a new DamageableEntityDefInstance
function INSTANCE:Renegade_DamageableEntityDefClass()
    self.TranslatedNameId = 0
    -- self.EncyclopediaType = encyclopediaTypeEnum.Unknown
    self.EncyclopediaId = 0
    self.NotTargetable = false
    self.DefaultPlayerType = playerTypeEnum.Neutral
end

--- @return boolean wasValid, string? errorMessage
function INSTANCE:IsValidConfig()
    typecheck.NotImplementedError()
end

--- @return integer
function INSTANCE:GetNameId()
    return self.TranslatedNameId
end

--[[ Encyclopedia Information ]] do

    --- @return EncyclopediaType
    function INSTANCE:GetEncyclopediaType()
        return self.EncyclopediaType
    end

    --- @return integer
    function INSTANCE:GetEncyclopediaId()
        return self.EncyclopediaId
    end
end

--[[ Icon Information ]] do

    --- @return IMaterial
    function INSTANCE:GetIconMaterial()
        return self.InfoIconMaterial
    end
end

--- @return integer
function INSTANCE:GetTranslatedNameId()
    return self.TranslatedNameId
end

--- @return DefenseDefClass
function INSTANCE:GetDefenseEntityDef()
    return self.DefenseEntityDef
end

--[[ Accessors (Added as needed) ]] do

    --- @return PlayerTypeEnum
    function INSTANCE:GetDefaultPlayerType()
        return self.DefaultPlayerType
    end
end