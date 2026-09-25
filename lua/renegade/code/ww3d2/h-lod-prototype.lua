-- Based on HLodPrototypeClass within Code/ww3d2/hlod.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeClass
local prototypeClass = CNC.Import( "code/ww3d2/prototype.lua" )

--- @class HLodPrototypeClass : PrototypeClass
--- @field Instance HLodPrototypeInstance The metatable used by HLodPrototypeInstance
local STATIC = CNC.CreateExport( prototypeClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HLodPrototypeClass"

--- @class HLodPrototypeInstance : PrototypeInstance
--- @field Static HLodPrototypeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HLodPrototype : Renegade_Prototype" )
INSTANCE.Class = "HLodPrototypeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHLodPrototype = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type RenderObjectClass
	local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

	--- @type HLodClass
	local hLodClass = CNC.Import( "code/ww3d2/h-lod.lua" )
--#endregion

--#region Imported Enums

	local renderObjectClassIdEnum = renderObjectClass.RENDER_OBJECT_CLASS_ID
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HLodPrototypeClass

    --- Creates a new HLodPrototypeInstance
    --- @param definition HLodDefinitionInstance
    --- @return HLodPrototypeInstance
    function STATIC.New( definition )
        return robustclass.New( "Renegade_HLodPrototype", definition )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HLodPrototypeInstance, `false` otherwise
    function STATIC.IsHLodPrototype( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHLodPrototype and true or false
    end

    typecheck.RegisterType( "HLodPrototypeInstance", STATIC.IsHLodPrototype )
end


--- @class HLodPrototypeInstance
--- @field Definition any

--- @param definition HLodDefinitionInstance
function INSTANCE:Renegade_HLodPrototype( definition )
    prototypeClass.Instance.Renegade_Prototype( self )

    self.Definition = definition
end

function INSTANCE:_Renegade_HLodPrototype()
    self.Definition = nil
end

--- @return string
function INSTANCE:GetName()
    return self.Definition:GetName()
end

--- @return RenderObjectClassId
function INSTANCE:GetClassId()
    return renderObjectClassIdEnum.CLASSID_HLOD
end

--- @return RenderObjectInstance
function INSTANCE:Create()
    local hlod = hLodClass.New( self.Definition )
    return hlod
end

--- @return HLodDefinitionInstance
function INSTANCE:GetDefinition()
	return self.Definition
end
