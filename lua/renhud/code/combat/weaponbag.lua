-- Based on WeaponBagClass within Code/Combat/weaponbag.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class WeaponBagClass
--- @field instance WeaponBagInstance The metatable used by WeaponBagInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "WeaponBagClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class WeaponBagInstance
--- @field Static WeaponBagClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_WeaponBag" )
INSTANCE.Class = "WeaponBagInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsWeaponBag = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion



--[[ Static Functions and Variables ]] do

    --- "WeaponBags manage collections of weapons"
    --- @class WeaponBagClass

    --- Creates a new WeaponBagInstance
    --- @param owner ArmedGameObjectInstance
    --- @return WeaponBagInstance
    function STATIC.New( owner )
        return robustclass.New( "Renegade_WeaponBag", owner )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) WeaponBagInstance, `false` otherwise
    function STATIC.IsWeaponBag( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsWeaponBag and true or false
    end

    typecheck.RegisterType( "WeaponBagInstance", STATIC.IsWeaponBag )
end


--- @class WeaponBagInstance
--- @field private Owner ArmedGameObjectInstance
--- @field private WeaponList table<integer,Weapon>
--- @field private WeaponIndex integer
--- @field private IsChanged boolean
--- @field private HudIsChanged boolean

--- Constructs a new WeaponBagInstance
--- @param owner ArmedGameObjectInstance
function INSTANCE:Renegade_WeaponBag( owner )
    self.Owner = owner
    self.WeaponIndix = 0
    self.IsChanged = true
    self.HudIsChanged = true

    self.WeaponList = {}
end


--- @param definition WeaponDefinitionInstance
--- @return Weapon?
function INSTANCE:FindWeapon( definition )
    if not IsValid( definition ) then
        return NULL
    end
 
end

