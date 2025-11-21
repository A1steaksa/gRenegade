-- Based on OffsenseObjectClass within Code/Combat/damage.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class OffenseClass
--- @field instance OffenseInstance The metatable used by OffenseInstance
local STATIC = CNC.CreateExport()
local CLASS = "OffenseInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class OffenseInstance
--- @field Static OffenseClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Offense" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsOffense = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class OffenseClass

    --- Creates a new OffenseInstance
    --- @overload fun( damage: number, warhead: WarheadType?, owner: ArmedEntityInstance? ):OffenseInstance 
    --- @overload fun( base: OffenseInstance ):OffenseInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Offense", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) OffenseInstance, `false` otherwise
    function STATIC.IsOffense( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsOffense and true or false
    end

    typecheck.RegisterType( "OffenseInstance", STATIC.IsOffense )
end


--- @class OffenseInstance
--- @field private Damage number
--- @field private Warhead WarheadType
--- @field private Owner Entity

local DEFAULT_DAMAGE = 1.0

--[[ Constructors & Destructor ]] do

    --- Constructs a new OffenseInstance
    --- @overload fun( damage: number?, warhead: WarheadType?, owner: ArmedEntityInstance? ):OffenseInstance 
    --- @overload fun( base: OffenseInstance ):OffenseInstance
    function INSTANCE:Renegade_Offense( ... )
        local args = { ... }
        local argCount = select( "#", ... )
        typecheck.AssertArgCount( CLASS, argCount, { 1, 2, 3 } )

        local arg1 = args[1] --[[@as number|OffenseInstance|nil]] or DEFAULT_DAMAGE

        -- (base: OffenseInstance):OffenseInstance
        if typecheck.IsOfType( arg1, "OffenseInstance" ) then
            local base = arg1 --[[@as OffenseInstance]]
            self.Damage = base.Damage
            self.Warhead = base.Warhead
            self:SetOwner( base:GetOwner() )
            return
        end

        -- (damage: number?, warhead: WarheadType?, owner: ArmedEntityInstance?):OffenseInstance
        self.Damage = arg1 --[[@as number]]
        self.Warhead = args[2] --[[@as integer]] or 0
        self:SetOwner( args[3] --[[@as ArmedEntityInstance]] or NULL )
    end
end

--[[ Offensive Damage Rating (ODR) ]] do

    --- @param newDamage number
    function INSTANCE:SetDamage( newDamage )
        self.Damage = newDamage
    end

    --- @return number
    function INSTANCE:GetDamage()
        return self.Damage
    end
end

--[[ Warhead ]] do

    --- @param newWarhead WarheadType
    function INSTANCE:SetWarhead( newWarhead )
        self.Warhead = newWarhead
    end

    --- @return WarheadType
    function INSTANCE:GetWarhead()
        return self.Warhead
    end
end

--[[ Owner ]] do

    --- @param newOwner ArmedEntityInstance
    function INSTANCE:SetOwner( newOwner )
        self.Owner = newOwner --[[@as ScriptableEntityInstance]]
    end

    --- @return ArmedEntityInstance
    function INSTANCE:GetOwner()
        return self.Owner --[[@as ArmedEntityInstance]]
    end
end
