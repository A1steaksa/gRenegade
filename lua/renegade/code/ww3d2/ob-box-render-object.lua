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

	--- @type OBBoxClass
	local oBBoxClass = CNC.Import( "code/wwmath/obbox.lua" )

	--- @type Matrix3dClass
	local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )

	--- @type RenderObjectClass
	local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

	--- @type SphereClass
	local sphereClass = CNC.Import( "code/wwmath/sphere.lua" )

	--- @type AABoxClass
	local aABoxClass = CNC.Import( "code/wwmath/aabox.lua" )
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
--- @field CachedBox OBBoxInstance

--- @param src W3dBoxStruct|OBBoxRenderObjectInstance|OBBoxInstance?
function INSTANCE:Renegade_OBBoxRenderObject( src )
	self.CachedBox = oBBoxClass.New()

	-- "Constructor"
	-- ()
	if src == nil then
		--- @cast src nil

		boxRenderObjectClass.Instance.Renegade_BoxRenderObject( self )

		INSTANCE.UpdateCachedBox( self )
		return
	else
		typecheck.AssertArgType( INSTANCE.Class, 1, src, { "W3dBoxStruct", "OBBoxRenderObjectInstance", "OBBoxInstance" } )

		-- "Init from a definition"
		-- ( def: W3dBoxStruct )
		if typecheck.IsOfType( src, "W3dBoxStruct" ) then
			local def = src --[[@as W3dBoxStruct]]

			boxRenderObjectClass.Instance.Renegade_BoxRenderObject( self, def )

			INSTANCE.UpdateCachedBox( self )
			return

		-- "Copy constructor"
		-- ( src: OBBoxRenderObjectInstance )
		elseif typecheck.IsOfType( src, "OBBoxRenderObjectInstance" ) then
			--- @cast src OBBoxRenderObjectInstance

			boxRenderObjectClass.Instance.Renegade_BoxRenderObject( self )

			typecheck.NotImplementedError()
			return

		-- "Constructor from a wwmath obbox"
		-- ( box: OBBoxInstance )
		else
			local box = src --[[@as OBBoxInstance]]

			boxRenderObjectClass.Instance.Renegade_BoxRenderObject( self )

			self.ObjectSpaceCenter = Vector( 0, 0, 0 )
			self.ObjectSpaceExtent = box.Extent
			INSTANCE.SetTransform( self, matrix3dClass.New( box.Basis, box.Center ) )
			INSTANCE.UpdateCachedBox( self ) -- "Cached box should == box!"
			return
		end
	end
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

--- @param matrix Matrix3dInstance
function INSTANCE:SetTransform( matrix )
	renderObjectClass.Instance.SetTransform( self, matrix )
	INSTANCE.UpdateCachedBox( self )
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

--- @return SphereInstance
function INSTANCE:GetObjectSpaceBoundingSphere()
	local sphere = sphereClass.New()
	sphere:Init( self.ObjectSpaceCenter, self.ObjectSpaceExtent:Length() )
	return sphere
end

--- @return AABoxInstance
function INSTANCE:GetObjectSpaceBoundingBox()
	local box = aABoxClass.New()
	box:Init( self.ObjectSpaceCenter, self.ObjectSpaceExtent )
	return box
end

function INSTANCE:GetBox()
	typecheck.NotImplementedError()
end

--- "Update the cached world-space box"
function INSTANCE:UpdateCachedBox()
	self.CachedBox.Center = matrix3dClass.TransformVector( self.Transform, self.ObjectSpaceCenter )
	self.CachedBox.Extent = self.ObjectSpaceExtent
	self.CachedBox.Basis = self.Transform
end
