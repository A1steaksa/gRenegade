-- Based on OffsenseObjectClass within Code/Combat/damage.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class OffenseObjectClass
--- @field instance OffenseObjectInstance The metatable used by OffenseObjectInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "OffenseObjectClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class OffenseObjectInstance
--- @field Static OffenseObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_OffenseObject" )
INSTANCE.Class = "OffenseObjectInstance"
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

    --- @class OffenseObjectClass

    --- Creates a new OffenseObjectInstance
    --- @overload fun( damage: number, warhead: WarheadType?, owner: ArmedGameObjectInstance? ):OffenseObjectInstance 
    --- @overload fun( base: OffenseObjectInstance ):OffenseObjectInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_OffenseObject", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) OffenseObjectInstance, `false` otherwise
    function STATIC.IsOffense( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsOffense and true or false
    end

    typecheck.RegisterType( "OffenseObjectInstance", STATIC.IsOffense )
end


--- @class OffenseObjectInstance
--- @field private Damage number
--- @field private Warhead WarheadType
--- @field private Owner Entity

local DEFAULT_DAMAGE = 1.0

--[[ Constructors & Destructor ]] do

    --- Constructs a new OffenseObjectInstance
    --- @overload fun( damage: number?, warhead: WarheadType?, owner: ArmedGameObjectInstance? ):OffenseObjectInstance 
    --- @overload fun( base: OffenseObjectInstance ):OffenseObjectInstance
    function INSTANCE:Renegade_OffenseObject( ... )
        local args = { ... }
        local argCount = select( "#", ... )
        typecheck.AssertArgCount( INSTANCE.Class, argCount, { 1, 2, 3 } )

        local arg1 = args[1] --[[@as number|OffenseObjectInstance|nil]] or DEFAULT_DAMAGE

        -- (base: OffenseObjectInstance):OffenseObjectInstance
        if typecheck.IsOfType( arg1, "OffenseObjectInstance" ) then
            local base = arg1 --[[@as OffenseObjectInstance]]
            self.Damage = base.Damage
            self.Warhead = base.Warhead
            self:SetOwner( base:GetOwner() )
            return
        end

        -- (damage: number?, warhead: WarheadType?, owner: ArmedGameObjectInstance?):OffenseObjectInstance
        self.Damage = arg1 --[[@as number]]
        self.Warhead = args[2] --[[@as integer]] or 0
        self:SetOwner( args[3] --[[@as ArmedGameObjectInstance]] or NULL )
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

    --- @param newOwner ArmedGameObjectInstance
    function INSTANCE:SetOwner( newOwner )
        self.Owner = newOwner --[[@as ScriptableGameObjectInstance]]
    end

    --- @return ArmedGameObjectInstance
    function INSTANCE:GetOwner()
        return self.Owner --[[@as ArmedGameObjectInstance]]
    end
end
