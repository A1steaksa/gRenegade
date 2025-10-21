-- Based on ArmedGameObjDef within Code/Combat/armedgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type PhysicalEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/physical-entity-def.lua" )

--- @class ArmedEntityDefClass : PhysicalEntityDefClass
local STATIC = setmetatable( CNC.CreateExport(), { __index = PARENT } )
local CLASS = "ArmedEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class ArmedEntityDefInstance : PhysicalEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_ArmedEntityDefClass : Renegade_PhysicalEntityDefClass" )
INSTANCE.IsArmedEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--[[ Static Functions and Variables ]] do

    --- @class ArmedEntityDefClass

    --- Creates a new ArmedEntityDefClass
    --- @vararg any
    --- @return ArmedEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ArmedEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ArmedEntityDefInstance, `false` otherwise
    function STATIC.IsArmedEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsArmedEntityDefClass and true or false
    end

    typecheck.RegisterType( "ArmedEntityDefInstance", STATIC.IsArmedEntityDefClass )
end


--- @class ArmedEntityDefInstance
--- @field WeaponTiltRate number
--- @field WeaponTiltMin number
--- @field WeaponTiltMax number
--- @field WeaponTurnRate number
--- @field WeaponTurnMin number
--- @field WeaponTurnMax number
--- @field WeaponError number
--- @field WeaponDefId integer
--- @field SecondaryWeaponDefId integer
--- @field WeaponRounds integer

--- Constructs a new ArmedEntityDefInstance
function INSTANCE:Renegade_ArmedEntityDefClass()
    print( "Armed Entity Definition Constructor" )

    self.WeaponTiltRate = 1
    self.WeaponTiltMin = -10000.0
    self.WeaponTiltMax =  10000.0
    self.WeaponTurnRate = 1
    self.WeaponTurnMin = -10000.0
    self.WeaponTurnMax =  10000.0
    self.WeaponError = 0
    self.WeaponDefId = 0
    self.SecondaryWeaponDefId = 0
    self.WeaponRounds = -1
end
