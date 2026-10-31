-- Based on ScreenCursorClass within Code/wwui/screencursor.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ScreenCursorClass
--- @field Instance ScreenCursorInstance The metatable used by ScreenCursorInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ScreenCursorClass"

--- @class ScreenCursorInstance
--- @field Static ScreenCursorClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ScreenCursor" )
INSTANCE.Class = "ScreenCursorInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsScreenCursor = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type Render2dClass
	local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )

	--- @type DialogManagerClass
	local dialogManagerClass = CNC.Import( "code/wwui/dialog-manager.lua" )

	--- @type RectClass
	local rectClass = CNC.Import( "code/wwmath/rect.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ScreenCursorClass

    STATIC.Uvs = rectClass.New( 0, 0, 1, 1 )

    --- Creates a new ScreenCursorInstance
    --- @return ScreenCursorInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ScreenCursor" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ScreenCursorInstance, `false` otherwise
    function STATIC.IsScreenCursor( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsScreenCursor and true or false
    end

    typecheck.RegisterType( "ScreenCursorInstance", STATIC.IsScreenCursor )
end


--- @class ScreenCursorInstance
--- @field Hotspot Vector
--- @field Width integer
--- @field Height integer
--- @field Renderer Render2dInstance
--- @field Texture TextureInstance

function INSTANCE:Renegade_ScreenCursor()
    self.Hotspot = Vector( 0, 0 )
    self.Texture = nil
    self.Width = 0
    self.Height = 0
end

function INSTANCE:_Renegade_ScreenCursor()
    -- Empty in the original code
end

--- @param texture TextureInstance
function INSTANCE:SetTexture( texture )
    -- "Find the dimensions of the texture:"
    if self.Texture ~= nil then
        self.Texture:Init()
        self.Width  = self.Texture:GetWidth()
        self.Height = self.Texture:GetHeight()
    end

    self.Renderer:SetMaterial( self.Texture )
    self.Renderer:SetCoordinateRange( render2dClass.GetScreenResolution() )
end

function INSTANCE:Render()
    -- "Get the cursor's position"
    local cursorPos = dialogManagerClass.GetMousePos()

    -- "Clamp the cursor to the screen bounds"
    local screenRect = render2dClass.GetScreenResolution()
    cursorPos.x = math.Clamp( cursorPos.x, screenRect.Left, screenRect.Right - 5 )
    cursorPos.y = math.Clamp( cursorPos.y, screenRect.Top, screenRect.Bottom - 5 )
    dialogManagerClass.SetMousePos( cursorPos )

    -- "Take the hotspot into account"
    cursorPos.x = cursorPos.x - self.Hotspot.x
    cursorPos.y = cursorPos.y - self.Hotspot.y

    -- "Build the screen-space rectangle we'll render to"
    local rect = rectClass.New()
    rect.Left = cursorPos.x
    rect.Top = cursorPos.y
    rect.Right = cursorPos.x + self.Width
    rect.Bottom = cursorPos.y + self.Height

    -- "Render the mouse cursor"
    self.Renderer:Reset()
    self.Renderer:AddQuad( rect, STATIC.Uvs )
    self.Renderer:Render()
end

--- @param pos Vector
function INSTANCE:SetHotspot( pos )
	self.Hotspot = pos
end

--- @return Vector
function INSTANCE:GetHotspot()
    return self.Hotspot
end
