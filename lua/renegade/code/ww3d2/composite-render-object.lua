-- Based on CompositeRenderObjClass within Code/ww3d2/composite.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type RenderObjectClass
local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

--- @class CompositeRenderObjectClass : RenderObjectClass
--- @field Instance CompositeRenderObjectInstance The metatable used by CompositeRenderObjectInstance
local STATIC = CNC.CreateExport( renderObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "CompositeRenderObjectClass"

--- @class CompositeRenderObjectInstance : RenderObjectInstance
--- @field Static CompositeRenderObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_CompositeRenderObject : Renegade_RenderObject" )
INSTANCE.Class = "CompositeRenderObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsCompositeRenderObject = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class CompositeRenderObjectClass

    --- Creates a new CompositeRenderObjectInstance
	--- @param other CompositeRenderObjectInstance?
    --- @return CompositeRenderObjectInstance
    function STATIC.New( other )
        return robustclass.New( "Renegade_CompositeRenderObject", other )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) CompositeRenderObjectInstance, `false` otherwise
    function STATIC.IsCompositeRenderObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsCompositeRenderObject and true or false
    end

    typecheck.RegisterType( "CompositeRenderObjectInstance", STATIC.IsCompositeRenderObject )
end


--- @class CompositeRenderObjectInstance
--- @field Name any
--- @field BaseModelName any
--- @field ObjectSphere any
--- @field ObjectBox any

--- @param other CompositeRenderObjectInstance?
function INSTANCE:Renegade_CompositeRenderObject( other )
	-- ()
	if other == nil then
		renderObjectClass.Instance.Renegade_RenderObject( self )
		return
	end

	-- ( other: CompositeRenderObjectInstance )
	typecheck.AssertArgType( self.Class, 1, other, "CompositeRenderObjectInstance" )

	renderObjectClass.Instance.Renegade_RenderObject( self )

	self:SetName( other:GetName() )
	self:SetBaseModelName( other:GetBaseModelName() )
end

function INSTANCE:_Renegade_CompositeRenderObject()
	typecheck.NotImplementedError()
end

function INSTANCE:Restart()
	typecheck.NotImplementedError()
end

function INSTANCE:GetName()
	typecheck.NotImplementedError()
end

function INSTANCE:SetName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBaseModelName()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBaseModelName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumPolys()
	typecheck.NotImplementedError()
end

function INSTANCE:NotifyAdded()
	typecheck.NotImplementedError()
end

function INSTANCE:NotifyRemoved()
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

function INSTANCE:CreateDecal()
	typecheck.NotImplementedError()
end

function INSTANCE:DeleteDecal()
	typecheck.NotImplementedError()
end

function INSTANCE:GetObjectSpaceBoundingSphere()
	typecheck.NotImplementedError()
end

function INSTANCE:GetObjectSpaceBoundingBox()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateObjectSpaceBoundingVolumes()
	typecheck.NotImplementedError()
end

function INSTANCE:SetUserData()
	typecheck.NotImplementedError()
end
