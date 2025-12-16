-- Based on SmartGameObjDef within Code/Combat/smartgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type ArmedEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/armed-entity-def.lua" )

--- @class SmartEntityDefClass : ArmedEntityDefClass
local STATIC = CNC.CreateExport( PARENT )
local CLASS = "SmartEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class SmartEntityDefInstance : ArmedEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_SmartEntityDefClass : Renegade_ArmedEntityDefClass" )
INSTANCE.IsSmartEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--[[ Static Functions and Variables ]] do

    --- @class SmartEntityDefClass

    --- Creates a new SmartEntityDefClass
    --- @vararg any
    --- @return SmartEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_SmartEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SmartEntityDefInstance, `false` otherwise
    function STATIC.IsSmartEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSmartEntityDefClass and true or false
    end

    typecheck.RegisterType( "SmartEntityDefInstance", STATIC.IsSmartEntityDefClass )
end


--- @class SmartEntityDefInstance
--- @field SightRange number
--- @field SightArc number
--- @field ListenerScale number
--- @field IsStealthUnit boolean

--- Constructs a new SmartEntityDefInstance
function INSTANCE:Renegade_SmartEntityDefClass()
    self.SightRange = 0
    self.SightArc = math.rad( 0 )
    self.ListenerScale = 1
end
