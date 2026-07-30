-- Based on AggregatePrototypeClass within Code/ww3d2/agg_def.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeClass
local prototypeClass = CNC.Import( "code/ww3d2/prototype.lua" )

--- @class AggregatePrototypeClass : PrototypeClass
--- @field Instance AggregatePrototypeInstance The metatable used by AggregatePrototypeInstance
local STATIC = CNC.CreateExport( prototypeClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AggregatePrototypeClass"

--- @class AggregatePrototypeInstance : PrototypeInstance
--- @field Static AggregatePrototypeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AggregatePrototype : Renegade_Prototype" )
INSTANCE.Class = "AggregatePrototypeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAggregatePrototype = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class AggregatePrototypeClass

    --- Creates a new AggregatePrototypeInstance
    --- @param definition AggregateDefinitionInstance
    --- @return AggregatePrototypeInstance
    function STATIC.New( definition )
        return robustclass.New( "Renegade_AggregatePrototype", definition )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AggregatePrototypeInstance, `false` otherwise
    function STATIC.IsAggregatePrototype( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAggregatePrototype and true or false
    end

    typecheck.RegisterType( "AggregatePrototypeInstance", STATIC.IsAggregatePrototype )
end


--- @class AggregatePrototypeInstance
--- @field Definition AggregateDefinitionInstance

--- @param definition AggregateDefinitionInstance
function INSTANCE:Renegade_AggregatePrototype( definition )
	self.Definition = definition
end

function INSTANCE:_Renegade_AggregatePrototype()
    self.Definition = nil
end

--- @return string
function INSTANCE:GetName()
    return self.Definition:GetName()
end

--- @return integer
function INSTANCE:GetClassId()
    return self.Definition:ClassId()
end

--- @return RenderObjectInstance
function INSTANCE:Create()
    return self.Definition:Create()
end

--- @return AggregateDefinitionInstance
function INSTANCE:GetDefinition()
    return self.Definition
end

--- @param definition AggregateDefinitionInstance
function INSTANCE:SetDefinition( definition )
	self.Definition = definition
end
