-- Based on NullPrototypeClass within Code/ww3d2/nullrobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeClass
local prototypeClass = CNC.Import( "code/ww3d2/prototype.lua" )

--- @class NullPrototypeClass : PrototypeClass
--- @field Instance NullPrototypeInstance The metatable used by NullPrototypeInstance
local STATIC = CNC.CreateExport( prototypeClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "NullPrototypeClass"

--- @class NullPrototypeInstance : PrototypeInstance
--- @field Static NullPrototypeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_NullPrototype : Renegade_Prototype" )
INSTANCE.Class = "NullPrototypeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsNullPrototype = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type RenderObjectClass
	local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

	--- @type Null3dObjectClass
	local null3dObjectClass = CNC.Import( "code/ww3d2/null-3d-object.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class NullPrototypeClass

    --- Creates a new NullPrototypeInstance
    --- @param null W3dNullObjectStruct?
    --- @return NullPrototypeInstance
    function STATIC.New( null )
        return robustclass.New( "Renegade_NullPrototype", null )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) NullPrototypeInstance, `false` otherwise
    function STATIC.IsNullPrototype( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsNullPrototype and true or false
    end

    typecheck.RegisterType( "NullPrototypeInstance", STATIC.IsNullPrototype )
end


--- @class NullPrototypeInstance
--- @field protected Definition W3dNullObjectStruct

--- @param null W3dNullObjectStruct?
function INSTANCE:Renegade_NullPrototype( null )
    -- ()
    if null == nil then
        prototypeClass.Instance.Renegade_Prototype( self )

        -- "  
        -- Note that the other members of the definition are uninitialized..  
        -- So don't rely on them if the name is "NULL".  
        -- "  
        self.Definition = {}
        self.Definition.Name = "NULL"

    -- ( null: W3dNullObjectStruct )
    else
        prototypeClass.Instance.Renegade_Prototype( self )

        self.Definition = null
    end
end

--- @return string
function INSTANCE:GetName()
	return self.Definition.Name
end

--- @return integer
function INSTANCE:GetClassId()
    return renderObjectClass.RENDER_OBJECT_CLASS_ID.CLASSID_NULL
end

--- @param connectedEntity Entity
--- @return RenderObjectInstance
function INSTANCE:Create( connectedEntity )
	return null3dObjectClass.New( connectedEntity, self.Definition.Name )
end
