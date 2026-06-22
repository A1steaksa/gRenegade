-- Based on OBBoxRenderObjClass within Code/ww3d2/boxrobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type BoxRenderObjectClass
local boxRenderObjectClass = CNC.Import( "code/ww3d2/box-render-object.lua" )

--- @class OBBoxRenderObjectClass : BoxRenderObjectClass
--- @field Instance OBBoxRenderObjectInstance The metatable used by OBBoxRenderObjectInstance
local STATIC = CNC.CreateExport( boxRenderObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "OBBoxRenderObjectClass"

--- @class OBBoxRenderObjectInstance : BoxRenderObjectInstance
--- @field Static OBBoxRenderObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_OBBoxRenderObject : Renegade_BoxRenderObject" )
INSTANCE.Class = "OBBoxRenderObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsOBBoxRenderObject = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class OBBoxRenderObjectClass

    --- Creates a new OBBoxRenderObjectInstance
    --- @return OBBoxRenderObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_OBBoxRenderObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) OBBoxRenderObjectInstance, `false` otherwise
    function STATIC.IsOBBoxRenderObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsOBBoxRenderObject and true or false
    end

    typecheck.RegisterType( "OBBoxRenderObjectInstance", STATIC.IsOBBoxRenderObject )
end


--- @class OBBoxRenderObjectInstance
--- @field CachedBox any

function INSTANCE:Renegade_OBBoxRenderObject()
	typecheck.NotImplementedError()
end

function INSTANCE:Renegade_OBBoxRenderObject()
	typecheck.NotImplementedError()
end

function INSTANCE:Clone()
	typecheck.NotImplementedError()
end

function INSTANCE:ClassId()
	typecheck.NotImplementedError()
end

function INSTANCE:Render()
	typecheck.NotImplementedError()
end

function INSTANCE:SpecialRender()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:CastRay()
	typecheck.NotImplementedError()
end

function INSTANCE:CastAaBox()
	typecheck.NotImplementedError()
end

function INSTANCE:CastObBox()
	typecheck.NotImplementedError()
end

function INSTANCE:IntersectAaBox()
	typecheck.NotImplementedError()
end

function INSTANCE:IntersectObBox()
	typecheck.NotImplementedError()
end

function INSTANCE:GetObjectSpaceBoundingSphere()
	typecheck.NotImplementedError()
end

function INSTANCE:GetObjectSpaceBoundingBox()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBox()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateCachedBox()
	typecheck.NotImplementedError()
end
