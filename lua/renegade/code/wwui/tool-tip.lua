-- Based on ToolTipClass within Code/wwui/tooltip.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ToolTipClass
--- @field Instance ToolTipInstance The metatable used by ToolTipInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ToolTipClass"

--- @class ToolTipInstance
--- @field Static ToolTipClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ToolTip" )
INSTANCE.Class = "ToolTipInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsToolTip = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type RectClass
	local rectClass = CNC.Import( "code/wwmath/rect.lua" )

	--- @type StyleManagerClass
	local styleManagerClass = CNC.Import( "code/wwui/style-manager.lua" )

	--- @type Render2dSentenceClass
	local render2dSentenceClass = CNC.Import( "code/ww3d2/render-2d-sentence.lua" )

	--- @type Render2dClass
	local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )
--#endregion

--#region Imported Enums

	local fontStyleEnum = styleManagerClass.FONT_STYLE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ToolTipClass

    --- Creates a new ToolTipInstance
    --- @return ToolTipInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ToolTip" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ToolTipInstance, `false` otherwise
    function STATIC.IsToolTip( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsToolTip and true or false
    end

    typecheck.RegisterType( "ToolTipInstance", STATIC.IsToolTip )
end


--- @class ToolTipInstance
--- @field TextRenderer Render2dSentenceInstance
--- @field BackgroundRenderer Render2dInstance
--- @field Text string
--- @field Rect RectInstance
--- @field TextColor Color
--- @field BkColor Color

function INSTANCE:Renegade_ToolTip()
    self.Rect = rectClass.New( 0, 0, 0, 0 )
    self.TextColor = Color( 0, 0, 0 )
    self.BkColor = Color( 1.0 * 255, 0.956 * 255, 0.733 * 255 )

    self.TextRenderer = render2dSentenceClass.New()

    -- "Set the font for the text renderers"
    styleManagerClass.AssignFont( self.TextRenderer, fontStyleEnum.Tooltips )
end

function INSTANCE:_Renegade_ToolTip()
    -- Empty in the original code
end

function INSTANCE:Render()
    -- "Render the background and text"
    self.BackgroundRenderer:Render()
    self.TextRenderer:Render()
end

--- @param text string
function INSTANCE:SetText( text )
	self.Text = text

    -- "Force the renderer's to be repositioned and resized"
    self:UpdateRect()
end

--- @param pos Vector
function INSTANCE:SetPosition( pos )
	self.Rect.Left = pos.x
    self.Rect.Top  = pos.y

    self:UpdateRect()
end

function INSTANCE:CreateTextRenderer()
    local renderer = self.TextRenderer

    -- "Setup the coordinate system of the renderer"
    renderer:Reset()

    -- "Calculate where to draw the text"
    local textExtent = renderer:GetTextExtents( self.Text )

    local xPos = self.Rect.Left + ( (self.Rect:Width() - textExtent.x ) / 2 )
    local yPos = self.Rect.Top + ( (self.Rect:Height() - textExtent.y ) / 2 )

    -- "Draw the text"
    renderer:SetLocation( Vector( xPos, yPos ) )
    renderer:SetClippingRect( self.Rect )

    renderer:BuildSentence( self.Text )
    renderer:DrawSentence( self.TextColor )
end

function INSTANCE:CreateBackgroundRenderer()
    local renderer = self.BackgroundRenderer

    -- "Configure this renderer"
    renderer:Reset()
    renderer:EnableTexturing( false )
    renderer:SetCoordinateRange( render2dClass.GetScreenResolution() )

    -- "Make a hilight color by brightening the background color"
    local hilightColor = Color(
        math.min( 255, self.BkColor.r * 2 ),
        math.min( 255, self.BkColor.g * 2 ),
        math.min( 255, self.BkColor.b * 2 )
    )

    local shadowColor = Color( 0, 0, 0 )

    -- "Draw the box outline"
    local rect = self.Rect
    renderer:AddLine( Vector( rect.Left,  rect.Bottom ), Vector( rect.Left,  rect.Top - 1 ), 1, hilightColor )
    renderer:AddLine( Vector( rect.Left,  rect.Top    ), Vector( rect.Right, rect.Top     ), 1, hilightColor )
    renderer:AddLine( Vector( rect.Right, rect.Top    ), Vector( rect.Right, rect.Bottom  ), 1, shadowColor  )
    renderer:AddLine( Vector( rect.Right, rect.Bottom ), Vector( rect.Left,  rect.Bottom  ), 1, shadowColor  )

    -- "Now draw the background"
    rect.Right  = rect.Right  - 1
    rect.Bottom = rect.Bottom - 1
    renderer:AddQuad( rect, self.BkColor )
end

function INSTANCE:UpdateRect()
    -- "Get the dimensions of the string"
    local screenRect = render2dClass.GetScreenResolution()
    local textExtent = self.TextRenderer:GetTextExtents( self.Text )

    if textExtent.x <= 0.0 then
        self.BackgroundRenderer:Reset()
        self.TextRenderer:Reset()
        return
    end

    -- "Update the rectangle's width and height"
    self.Rect.Right = self.Rect.Left + ( textExtent.x + 5 )
    self.Rect.Bottom = self.Rect.Top + ( textExtent.y + 4 )

    -- "Clip the rectangle to the right side of the screen"
    if self.Rect.Right > screenRect.Right then
        local delta = self.Rect.Right - screenRect.Right
        self.Rect.Left = self.Rect.Left - delta
        self.Rect.Right = self.Rect.Right - delta
    end

    -- "Clip the rectangle to the bottom of the screen"
    if self.Rect.Bottom > screenRect.Bottom then
        local delta = self.Rect.Bottom - screenRect.Bottom
        self.Rect.Top = self.Rect.Top - delta
        self.Rect.Bottom = self.Rect.Bottom - delta
    end

    -- "Update the renderer's"
    self:CreateTextRenderer()
    self:CreateBackgroundRenderer()
end
