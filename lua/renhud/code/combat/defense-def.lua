-- Based on DefenseObjectDefClass within Code/Combat/damage.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DefenseDefClass
--- @field instance DefenseDefInstance The metatable used by DefenseDefInstance
local STATIC = CNC.CreateExport()
local CLASS = "DefenseDefInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class DefenseDefInstance
--- @field Static DefenseDefClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DefenseDef" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDefenseDef = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class DefenseDefClass

    --- Creates a new DefenseDefInstance
    --- @return DefenseDefInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DefenseDef")
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) DefenseDefInstance, `false` otherwise
    function STATIC.IsDefenseDef( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDefenseDef and true or false
    end

    typecheck.RegisterType( "DefenseDefInstance", STATIC.IsDefenseDef )
end

--- > "  
--- > This class is meant to be a component of a definition class for a game or physics
--- > object which contains a [Defense].  Use the associated macro to make all of
--- > the member variables editable in your class.  
--- > "
--- @class DefenseDefInstance
--- @field Health number
--- @field HealthMax number
--- @field Skin ArmorType
--- @field ShieldStrength number
--- @field ShieldStrengthMax number
--- @field ShieldType ArmorType
--- @field DamagePoints number
--- @field DeathPoints number

--- Constructs a new DefenseDefInstance
--- @vararg any
function INSTANCE:Renegade_DefenseDef()

    self.Health = 100.0
    self.HealthMax = 100.0
    self.Skin = 0
    self.ShieldStrength = 0
    self.ShieldStrengthMax = 0
    self.ShieldType = 0
    self.DamagePoints = 0
    self.DeathPoints = 0
end
