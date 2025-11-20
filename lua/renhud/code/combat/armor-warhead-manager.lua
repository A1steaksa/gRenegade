-- Based on ArmorWarheadManager within Code/Combat/damage.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ArmorWarheadManagerClass
local STATIC = CNC.CreateExport()
local CLASS = "ArmorWarheadManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums

    --- @enum SpecialDamageType
    STATIC.SPECIAL_DAMAGE_TYPE = {
        NONE        = 0,
        FIRE        = 1,
        CHEM        = 2,
        ELECTRIC    = 3,
        CNC_FIRE    = 4,
        CNC_CHEM    = 5,
        SUPER_FIRE  = 6
    }
    local specialDamageTypeEnum = STATIC.SPECIAL_DAMAGE_TYPE
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--- @class ArmorWarheadManagerClass
--- @field private Multipliers number
--- @field private Absorbsion number


--[[ Build ]] do

    function STATIC.Init()
        typecheck.NotImplementedError()
    end

    function STATIC.Shutdown()
        typecheck.NotImplementedError()
    end
end

--- @param armor ArmorType
--- @return boolean
function STATIC.IsArmorSoft( armor )
    typecheck.NotImplementedError()
end

--[[ Type Additions/Access ]] do

    --- @return integer
    function STATIC.GetNumArmorTypes()
        typecheck.NotImplementedError()
    end

    --- @param name string
    --- @return ArmorType
    function STATIC.GetArmorType( name )
        typecheck.NotImplementedError()
    end

    --- @param type ArmorType
    --- @return string
    function STATIC.GetArmorName( type )
        typecheck.NotImplementedError()
    end

    --- @return integer
    function STATIC.GetNumWarheadTypes()
        typecheck.NotImplementedError()
    end

    --- @param name string
    --- @return WarheadType
    function STATIC.GetWarheadType( name )
        typecheck.NotImplementedError()
    end

    --- @param type WarheadType
    --- @return string
    function STATIC.GetWarheadName( type )
        typecheck.NotImplementedError()
    end
end

-- Omitted Save ID functions

--[[ Damage Multiplier Settings ]] do

    --- @param armor ArmorType
    --- @param warhead WarheadType
    --- @return number
    function STATIC.GetDamageMultiplier( armor, warhead )
        typecheck.NotImplementedError()
    end
end

--[[ Shield Absorbsion Settings ]] do

    --- @param armor ArmorType
    --- @param warhead WarheadType
    --- @return number
    function STATIC.GetShieldAbsorbsion( armor, warhead )
        typecheck.NotImplementedError()
    end
end

--- @param type WarheadType
--- @return SpecialDamageType
function STATIC.GetSpecialDamageType( type )
    typecheck.NotImplementedError()
end

--- @param type WarheadType
--- @return number
function STATIC.GetSpecialDamageProbability( type )
    typecheck.NotImplementedError()
end

--- @param type SpecialDamageType
--- @return WarheadType
function STATIC.GetSpecialDamageWarhead( type )
    typecheck.NotImplementedError()
end

--- @param type SpecialDamageType
--- @return number
function STATIC.GetSpecialDamageDuration( type )
    typecheck.NotImplementedError()
end

--- @param type SpecialDamageType
--- @return number
function STATIC.GetSpecialDamageScale( type )
    typecheck.NotImplementedError()
end

--- @param type SpecialDamageType
--- @return string
function STATIC.GetSpecialDamageExplosion( type )
    typecheck.NotImplementedError()
end

--- @param type SpecialDamageType
--- @return number
function STATIC.GetVisceroidProbability( type )
    typecheck.NotImplementedError()
end

--- @param type SpecialDamageType
--- @param skin ArmorType
--- @return boolean
function STATIC.IsSkinImpervious( type, skin )
    typecheck.NotImplementedError()
end