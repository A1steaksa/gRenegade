-- Based on BoxRenderObjClass within Code/ww3d2/boxrobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type RenderObjectClass
local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

--- @class BoxRenderObjectClass : RenderObjectClass
--- @field Instance BoxRenderObjectInstance The metatable used by BoxRenderObjectInstance
local STATIC = CNC.CreateExport( renderObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BoxRenderObjectClass"

--- @class BoxRenderObjectInstance : RenderObjectInstance
--- @field Static BoxRenderObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BoxRenderObject : Renegade_RenderObject" )
INSTANCE.Class = "BoxRenderObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBoxRenderObject = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type BoxLoaderClass
	local boxLoaderClass = CNC.Import( "code/ww3d2/box-loader.lua" )

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class BoxRenderObjectClass
	--- @field IsInitted boolean
	--- @field DisplayMask any

    --- Creates a new BoxRenderObjectInstance
    --- @return BoxRenderObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_BoxRenderObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BoxRenderObjectInstance, `false` otherwise
    function STATIC.IsBoxRenderObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBoxRenderObject and true or false
    end

    typecheck.RegisterType( "BoxRenderObjectInstance", STATIC.IsBoxRenderObject )

	function STATIC.StaticConstructor()
		STATIC.BoxLoader = boxLoaderClass.New()
	end

	--- "
	--- Global initialization needed for boxes to work
	--- Allocates materials which all boxes share.  Initializes vertex tables, etc.
	--- "
	function STATIC.Init()
		typecheck.NotImplementedError()
	end

	function STATIC.Shutdown()
		typecheck.NotImplementedError()
	end

	function STATIC.SetBoxDisplayMask()
		typecheck.NotImplementedError()
	end

	function STATIC.GetBoxDisplayMask()
		typecheck.NotImplementedError()
	end
end


--- @class BoxRenderObjectInstance
--- @field Name string
--- @field Color Color
--- @field ObjectSpaceCenter Vector
--- @field ObjectSpaceExtent Vector
--- @field Opacity number


--- @param src W3dBoxStruct|BoxRenderObjectInstance?
function INSTANCE:Renegade_BoxRenderObject( src )
	renderObjectClass.Instance.Renegade_RenderObject( self )

	-- ()
	if src == nil then
		self.Name = ""
		self.Color = Color( 255, 255, 255 )
		self.Opacity = 0.25
		self.ObjectSpaceCenter = Vector( 0, 0, 0 )
		self.ObjectSpaceExtent = Vector( 1, 1, 1 )
		return

	else
		typecheck.AssertArgType( INSTANCE.Class, 1, src, { "W3dBoxStruct", "BoxRenderObjectInstance" } )

		-- ( def: W3dBoxStruct )
		if typecheck.IsOfType( src, "w3dBoxStruct" ) then
			local def = src --[[@as W3dBoxStruct]]

			INSTANCE.SetName( self, def.Name )
			self.Color = Color( def.Color.R, def.Color.G, def.Color.B )
			self.ObjectSpaceCenter = Vector( def.Center.X, def.Center.Y, def.Center.Z )
			self.ObjectSpaceExtent = Vector( def.Extent.X, def.Extent.Y, def.Extent.Z )
			local collisionBits = bit.rshift(
				bit.band(
					def.Attributes,
					w3dFileIds.W3D_BOX_ATTRIBUTE_COLLISION_TYPE_MASK
				),
				w3dFileIds.W3D_BOX_ATTRIBUTE_COLLISION_TYPE_SHIFT
			)
			INSTANCE.SetCollisionType( self, bit.lshift( collisionBits, 1 ) )
			self.Opacity = 0.25
			return

		-- ( box: BoxRenderObjectInstance )
		else
			--- @cast src BoxRenderObjectInstance

			typecheck.NotImplementedError()
			return
		end
	end
end

--- @return integer
function INSTANCE:GetNumPolys()
	return 12
end

--- @return string
function INSTANCE:GetName()
	return self.Name
end

--- @param name string
function INSTANCE:SetName( name )
	self.Name = name
end

--- "Sets the color of the box"
--- @param color Color
function INSTANCE:SetColor( color )
	self.Color = color
end

function INSTANCE:SetOpacity()
	typecheck.NotImplementedError()
end

function INSTANCE:SetLocalCenterExtent()
	typecheck.NotImplementedError()
end

function INSTANCE:SetLocalMinMax()
	typecheck.NotImplementedError()
end

--- @return Vector
function INSTANCE:GetLocalCenter()
	return self.ObjectSpaceCenter
end

--- @return Vector
function INSTANCE:GetLocalExtent()
	return self.ObjectSpaceExtent
end

function INSTANCE:UpdateCachedBox()
	typecheck.NotImplementedError()
end

function INSTANCE:RenderBox()
	typecheck.NotImplementedError()
end

function INSTANCE:VisRenderBox()
	typecheck.NotImplementedError()
end
