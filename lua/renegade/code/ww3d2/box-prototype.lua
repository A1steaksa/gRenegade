-- Based on BoxPrototypeClass within Code/ww3d2/boxrobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeClass
local prototypeClass = CNC.Import( "code/ww3d2/prototype.lua" )

--- @class BoxPrototypeClass : PrototypeClass
--- @field Instance BoxPrototypeInstance The metatable used by BoxPrototypeInstance
local STATIC = CNC.CreateExport( prototypeClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BoxPrototypeClass"

--- @class BoxPrototypeInstance : PrototypeInstance
--- @field Static BoxPrototypeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BoxPrototype : Renegade_Prototype" )
INSTANCE.Class = "BoxPrototypeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBoxPrototype = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type RenderObjectClass
	local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )

	--- @type AABoxRenderObjectClass
	local aABoxRenderObjectClass = CNC.Import( "code/ww3d2/aa-box-render-object.lua" )

	--- @type OBBoxRenderObjectClass
	local oBBoxRenderObjectClass = CNC.Import( "code/ww3d2/ob-box-render-object.lua" )
--#endregion

--#region Imported Enums

	local renderObjectClassIdEnum = renderObjectClass.RENDER_OBJECT_CLASS_ID
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class BoxPrototypeClass

    --- Creates a new BoxPrototypeInstance
    --- @param box W3dBoxStruct
    --- @return BoxPrototypeInstance
    function STATIC.New( box )
        return robustclass.New( "Renegade_BoxPrototype", box )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BoxPrototypeInstance, `false` otherwise
    function STATIC.IsBoxPrototype( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBoxPrototype and true or false
    end

    typecheck.RegisterType( "BoxPrototypeInstance", STATIC.IsBoxPrototype )
end


--- @class BoxPrototypeInstance
--- @field Definition W3dBoxStruct

--- @param box W3dBoxStruct
function INSTANCE:Renegade_BoxPrototype( box )
    prototypeClass.Instance.Renegade_Prototype( self )

    self.Definition = box
end

--- @return string
function INSTANCE:GetName()
    return self.Definition.Name
end

--- @return integer
function INSTANCE:GetClassId()
    if bit.band( self.Definition.Attributes, w3dFileIds.W3D_BOX_ATTRIBUTE_ORIENTED ) == 1 then
        return renderObjectClassIdEnum.CLASSID_OBBOX
    else
        return renderObjectClassIdEnum.CLASSID_AABOX
    end
end

--- @return RenderObjectInstance
function INSTANCE:Create()
    if bit.band( self.Definition.Attributes, w3dFileIds.W3D_BOX_ATTRIBUTE_ORIENTED ) == 1 then
        return oBBoxRenderObjectClass.New( self.Definition )
    else
        return aABoxRenderObjectClass.New( self.Definition )
    end
end
