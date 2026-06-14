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
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class BoxRenderObjectClass
		--- @field IsInitted any
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
--- @field Name any
--- @field Color any
--- @field ObjectSpaceCenter any
--- @field ObjectSpaceExtent any
--- @field Opacity any

function INSTANCE:Renegade_BoxRenderObject()
	typecheck.NotImplementedError()
end

function INSTANCE:Renegade_BoxRenderObject()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumPolys()
	typecheck.NotImplementedError()
end

function INSTANCE:GetName()
	typecheck.NotImplementedError()
end

function INSTANCE:SetName()
	typecheck.NotImplementedError()
end

function INSTANCE:SetColor()
	typecheck.NotImplementedError()
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

function INSTANCE:GetLocalCenter()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLocalExtent()
	typecheck.NotImplementedError()
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
