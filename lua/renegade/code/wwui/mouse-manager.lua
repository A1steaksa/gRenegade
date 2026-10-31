-- Based on MouseMgrClass within Code/wwui/mousemgr.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MouseManagerClass
--- @field Instance MouseManagerInstance The metatable used by MouseManagerInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MouseManagerClass"

--- @class MouseManagerInstance
--- @field Static MouseManagerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MouseManager" )
INSTANCE.Class = "MouseManagerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMouseManager = true

--#region Exported Enums    --- @type EnumBuilderClass

    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum CursorType
    STATIC.CURSOR_TYPE = {
        CURSOR_ARROW	= enumBuilder:Set( 0 ),
        CURSOR_TEXT		= enumBuilder:Next(),
        CURSOR_ACTION	= enumBuilder:Next(),
        CURSOR_BUSY		= enumBuilder:Next(),
        CURSOR_PAN_UP	= enumBuilder:Next(),
        CURSOR_ROTATE	= enumBuilder:Next(),
        CURSOR_COUNT	= enumBuilder:Next(),
    }
    local cursorTypeEnum = STATIC.CURSOR_TYPE
--#endregion

--#region Imports

	--- @type Ww3dAssetManagerClass
	local ww3dAssetManagerClass = CNC.Import( "code/ww3d2/ww3d-asset-manager.lua" )

	--- @type TextureClass
	local textureClass = CNC.Import( "code/ww3d2/texture.lua" )

	--- @type ScreenCursorClass
	local screenCursorClass = CNC.Import( "code/wwui/screen-cursor.lua" )
--#endregion

--#region Imported Enums

	local mipCountTypeEnum = textureClass.MIP_COUNT_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MouseManagerClass
	--- @field Textures TextureInstance[]
	--- @field MouseCursor ScreenCursorInstance
	--- @field CursorType CursorType
	--- @field CursorWaitCount integer

	STATIC.TEXTURE_NAME = {
		"cursor_arrow.tga",
		"cursor_text.tga",
		"cursor_action.tga",
		"cursor_busy.tga",
		"cursor_pan_up.tga",
		"cursor_rotate.tga"
	}

	STATIC.HOTSPOTS = {
		Vector( 0,  0  ),
		Vector( 15, 15 ),
		Vector( 7,  1  ),
		Vector( 15, 15 ),
		Vector( 15, 17 ),
		Vector( 15, 15 )
	}

    --- Creates a new MouseManagerInstance
    --- @return MouseManagerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MouseManager" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MouseManagerInstance, `false` otherwise
    function STATIC.IsMouseManager( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMouseManager and true or false
    end

    typecheck.RegisterType( "MouseManagerInstance", STATIC.IsMouseManager )


	--[[ Initialization ]] do

		function STATIC.StaticConstructor()
			STATIC.Textures = {}
			STATIC.MouseCursor = nil
			STATIC.CursorType = cursorTypeEnum.CURSOR_ARROW
			STATIC.CursorWaitCount = 0
		end

		function STATIC.Initialize()
			-- "Load each mouse cursor texture"
			for index = 1, cursorTypeEnum.CURSOR_COUNT do
				STATIC.Textures[index] = ww3dAssetManagerClass.GetInstance():GetTexture( STATIC.TEXTURE_NAME[index], mipCountTypeEnum.MIP_LEVELS_1 )
			end
		end

		function STATIC.Shutdown()
			-- "This will free the cursor object"
			STATIC.ShowCursor( false )
		end
	end


	--[[ Display Methods ]] do

		--- @param onOff boolean
		function STATIC.ShowCursor( onOff )
			if STATIC.MouseCursor == nil and onOff then
				-- "Create the mouse cursor"
				STATIC.MouseCursor = screenCursorClass.New()
				STATIC.MouseCursor:SetTexture( STATIC.Textures[STATIC.CursorType] )
				STATIC.MouseCursor:SetHotspot( STATIC.HOTSPOTS[STATIC.CursorType] )
				STATIC.CursorWaitCount = 0
			elseif STATIC.MouseCursor ~= nil and onOff == false then
				-- "Free the mouse cursor"
				STATIC.MouseCursor = nil
			end
		end

		--- @param type CursorType
		function STATIC.SetCursor( type )
			if STATIC.CursorType ~= type and STATIC.MouseCursor ~= nil and STATIC.CursorWaitCount == 0 then
				STATIC.MouseCursor:SetTexture( STATIC.Textures[type] )
				STATIC.MouseCursor:SetHotspot( STATIC.HOTSPOTS[type] )
				STATIC.CursorType = type
			end
		end

		function STATIC.BeginWaitCursor()
			if STATIC.CursorWaitCount == 0 then
				STATIC.SetCursor( cursorTypeEnum.CURSOR_BUSY )
			end

			STATIC.CursorWaitCount = STATIC.CursorWaitCount + 1
		end

		function STATIC.EndWaitCursor()
			assert( STATIC.CursorWaitCount > 0 )

			if STATIC.CursorWaitCount > 0 then
				STATIC.CursorWaitCount = STATIC.CursorWaitCount - 1

				if STATIC.CursorWaitCount == 0 then
					STATIC.SetCursor( cursorTypeEnum.CURSOR_ARROW )
				end
			end
		end
	end


	--[[ Render Methods ]] do

		function STATIC.Render()
			if STATIC.MouseCursor ~= nil then
				STATIC.MouseCursor:Render()
			end
		end
	end
end


--- @class MouseManagerInstance
