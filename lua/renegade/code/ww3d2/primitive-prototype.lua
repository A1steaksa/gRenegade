-- Based on PrimitivePrototypeClass within Code/ww3d2/proto.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeClass
local prototypeClass = CNC.Import( "code/ww3d2/prototype.lua" )

--- @class PrimitivePrototypeClass : PrototypeClass
--- @field Instance PrimitivePrototypeInstance The metatable used by PrimitivePrototypeInstance
local STATIC = CNC.CreateExport( prototypeClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PrimitivePrototypeClass"

--- @class PrimitivePrototypeInstance : PrototypeInstance
--- @field Static PrimitivePrototypeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PrimitivePrototype : Renegade_Prototype" )
INSTANCE.Class = "PrimitivePrototypeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPrimitivePrototype = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PrimitivePrototypeClass

    --- Creates a new PrimitivePrototypeInstance
    --- @param prototype RenderObjectInstance
    --- @return PrimitivePrototypeInstance
    function STATIC.New( prototype )
        return robustclass.New( "Renegade_PrimitivePrototype", prototype )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PrimitivePrototypeInstance, `false` otherwise
    function STATIC.IsPrimitivePrototype( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPrimitivePrototype and true or false
    end

    typecheck.RegisterType( "PrimitivePrototypeInstance", STATIC.IsPrimitivePrototype )
end


--- @class PrimitivePrototypeInstance
--- @field Prototype RenderObjectInstance

--- @param prototype RenderObjectInstance
function INSTANCE:Renegade_PrimitivePrototype( prototype )
    self.Prototype = prototype
end

function INSTANCE:_Renegade_PrimitivePrototype()
    self.Prototype = nil
end

--- @return string
function INSTANCE:GetName()
    return self.Prototype:GetName()
end

--- @return integer
function INSTANCE:GetClassId()
    return self.Prototype:ClassId()
end

--- @return RenderObjectInstance
function INSTANCE:Create()
    return self.Prototype:Clone() --[[@as RenderObjectInstance]]
end
