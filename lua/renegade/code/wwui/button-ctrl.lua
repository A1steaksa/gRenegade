-- Based on ButtonControlClass within Code/wwui/buttonctrl.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DialogControlClass
local dialogControlClass = CNC.Import( "code/wwui/dialog-control.lua" )

--- @class ButtonControlClass : DialogControlClass
--- @field Instance ButtonControlInstance The metatable used by ButtonControlInstance
local STATIC = CNC.CreateExport( dialogControlClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ButtonControlClass"

--- @class ButtonControlInstance : DialogControlInstance
--- @field Static ButtonControlClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ButtonControl : Renegade_DialogControl" )
INSTANCE.Class = "ButtonControlInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsButtonControl = true

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum ButtonState
    STATIC.BUTTON_STATE = {
        UP        = enumBuilder:Set( 0),
        DOWN	  = enumBuilder:Next(),
        STATE_MAX = enumBuilder:Next(),
    }
    local buttonStateEnum = STATIC.BUTTON_STATE

    --- @enum ButtonEvent
    STATIC.BUTTON_EVENT = {
        BN_CLICKED   = enumBuilder:Set( 0 ),
        BN_DBLCLK    = enumBuilder:Next(),
        BN_DISABLE   = enumBuilder:Next(),
        BN_PUSHED    = enumBuilder:Next(),
        BN_KILLFOCUS = enumBuilder:Next(),
        BN_PAINT     = enumBuilder:Next(),
        BN_SETFOCUS  = enumBuilder:Next(),
        BN_UNPUSHED  = enumBuilder:Next(),
    }
    local buttonEventEnum = STATIC.BUTTON_EVENT

    --- @enum ButtonStyle
    STATIC.BUTTON_STYLE = {
        BS_3STATE         = 0x5,
        BS_AUTO3STATE     = 0x6,
        BS_AUTOCHECKBOX   = 0x3,
        BS_AUTORADIOBOX   = 0x9,
        BS_BITMAP         = 0x80,
        BS_BOTTOM         = 0x800,
        BS_CENTER         = 0x300,
        BS_CHECKBOX       = 0x2,
        BS_DEFPUSHBUTTON  = 0x1,
        BS_FLAT           = 0x8000,
        BS_GROUPBOX       = 0x7,
        BS_ICON           = 0x40,
        BS_LEFT           = 0x100,
        BS_LEFTTEXT       = 0x20,
        BS_MULTILINE      = 0x2000,
        BS_NOTIFY         = 0x4000,
        BS_OWNERDRAW      = 0xB,
        BS_PUSHBUTTON     = 0x0,
        BS_PUSHLIKE       = 0x1000,
        BS_RADIOBUTTON    = 0x4,
        BS_RIGHT          = 0x200,
        BS_RIGHTBUTTON    = 0x20,
        BS_TEXT           = 0x0,
        BS_TOP            = 0x400,
        BS_USERBUTTON     = 0x8,
        BS_VCENTER        = 0xC00,
    }
    local buttonStyleEnum = STATIC.BUTTON_STYLE

--#endregion

--#region Imports

	--- @type RectClass
	local rectClass = CNC.Import( "code/wwmath/rect.lua" )

	--- @type StyleManagerClass
	local styleManagerClass = CNC.Import( "code/wwui/style-manager.lua" )

	--- @type Render2dTextClass
	local render2dTextClass = CNC.Import( "code/ww3d2/render-2d-text.lua" )

	--- @type Render2dSentenceClass
	local render2dSentenceClass = CNC.Import( "code/ww3d2/render-2d-sentence.lua" )

	--- @type Render2dClass
	local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )

	--- @type MouseManagerClass
	local mouseManagerClass = CNC.Import( "code/wwui/mouse-manager.lua" )

	--- @type DialogControlClass
	local dialogControlClass = CNC.Import( "code/wwui/dialog-control.lua" )

	--- @type DialogManagerClass
	local dialogManagerClass = CNC.Import( "code/wwui/dialog-manager.lua" )

	--- @type Ww3dAssetManagerClass
	local ww3dAssetManagerClass = CNC.Import( "code/ww3d2/ww3d-asset-manager.lua" )

	--- @type TextureClass
	local textureClass = CNC.Import( "code/ww3d2/texture.lua" )

	--- @type ShaderClass
	local shaderClass = CNC.Import( "code/ww3d2/shader.lua" )
--#endregion

--#region Imported Enums

	local fontStyleEnum = styleManagerClass.FONT_STYLE
	local eventAudioEnum = styleManagerClass.EVENT_AUDIO
	local justificationEnum = styleManagerClass.JUSTIFICATION
	local cursorTypeEnum = mouseManagerClass.CURSOR_TYPE
	local mipCountTypeEnum = textureClass.MIP_COUNT_TYPE
	local dstBlendFuncEnum = shaderClass.DST_BLEND_FUNC
	local srcBlendFuncEnum = shaderClass.SRC_BLEND_FUNC
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ButtonControlClass

    --- Creates a new ButtonControlInstance
    --- @return ButtonControlInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ButtonControl" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ButtonControlInstance, `false` otherwise
    function STATIC.IsButtonControl( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsButtonControl and true or false
    end

    typecheck.RegisterType( "ButtonControlInstance", STATIC.IsButtonControl )

    function STATIC.StaticConstructor()
        STATIC.BUTTON_UVS    = rectClass.New( 96.0, 51.0, 217.0, 84.0 )
        STATIC.BUTTON_DN_UVS = rectClass.New( 96.0, 92.0, 217.0, 125.0 )
        STATIC.HILIGHT_UVS   = rectClass.New( 117.0, 4.0, 220.0, 41.0 )
    end

    --- @param renderer Render2dInstance
    --- @param screenPos Vector
    --- @param texturePos Vector
    --- @param pixels Vector
    --- @param textureDimensions Vector
    function STATIC.BlitSection( renderer, screenPos, texturePos, pixels, textureDimensions )
        local screenRect = rectClass.New()
        screenRect.Left   = screenPos.x
        screenRect.Top    = screenPos.y
        screenRect.Right  = screenRect.Left + pixels.x
        screenRect.Bottom = screenRect.Top  + pixels.y

        local uvRect = rectClass.New( texturePos.x, texturePos.y, texturePos.x + pixels.x, texturePos.y + pixels.y )
        uvRect:InverseScaleVector( textureDimensions )

        renderer:AddQuad( screenRect, uvRect )
    end
end


--- @class ButtonControlInstance
--- @field GlowRenderer Render2dSentenceInstance
--- @field TextRenderer Render2dSentenceInstance
--- @field ButtonRenderers Render2dInstance[]
--- @field WasButtonPressedOnMe boolean
--- @field IsMouseOverMe boolean
--- @field IsBitmapMode boolean
--- @field PulseTime integer

function INSTANCE:Renegade_ButtonControl()
    dialogControlClass.Instance.Renegade_DialogControl( self )

    self.WasButtonPressedOnMe = false
    self.IsMouseOverMe = false
    self.PulseTime = 0

    self.TextRenderer = render2dSentenceClass.New()

    -- "Set the font for the text renderer"
    styleManagerClass.AssignFont( self.TextRenderer, fontStyleEnum.Controls )
    styleManagerClass.AssignFont( self.GlowRenderer, fontStyleEnum.Controls )

    self.ButtonRenderers = {}
    self.ButtonRenderers[1] = render2dClass.New()
    self.ButtonRenderers[2] = render2dClass.New()

    -- Configure the renderers
    styleManagerClass.ConfigureRenderer( self.ButtonRenderers[1] )
    styleManagerClass.ConfigureRenderer( self.ButtonRenderers[2] )
end

function INSTANCE:_Renegade_ButtonControl()
    -- Empty in the original code.
end

--[[ RTTI ]] do

    --- @return ButtonControlInstance
    function INSTANCE:AsButtonControlClass()
        return self
    end
end


function INSTANCE:Render()
    -- "Recreate the renderers (if necessary)"
    if self:IsDirty() then
        self:CreateTextRenderers()

        -- "Determine which type of button to create"
        if tobool( bit.band( self:GetStyle(), buttonStyleEnum.BS_BITMAP ) ) == false then
            self:CreateComponentButton()
        else
            self:CreateBitmapButton()
        end
    end

    if self.WasButtonPressedOnMe and self.IsMouseOverMe then
        -- "Render the button 'pressed'"
        self.ButtonRenderers[buttonStateEnum.DOWN]:Render()
        self.ButtonRenderers[buttonStateEnum.UP]:Render()
    else
        -- "Render the button normally"
        self.ButtonRenderers[buttonStateEnum.UP]:Render()
    end

    -- "Render the text (only if its not a bitmap button)"
    if tobool( bit.band( self:GetStyle(), buttonStyleEnum.BS_BITMAP ) ) == false then
        if self._HasFocus then
            self.GlowRenderer:Render()
        end
        self.TextRenderer:Render()
    end

    dialogControlClass.Instance.Render( self )
end

--- @param textureUpName string
--- @param textureDownName string?
function INSTANCE:SetBitmap( textureUpName, textureDownName )
    -- "Configure the up bitmap"
    local textureUp = ww3dAssetManagerClass.GetInstance():GetTexture( textureUpName, mipCountTypeEnum.MIP_LEVELS_1 )
    self.ButtonRenderers[1]:SetTexture( textureUp )

    -- "Configure the down bitmap"
    if textureDownName ~= nil and #textureDownName ~= 0 then
        local textureDown = ww3dAssetManagerClass.GetInstance():GetTexture( textureDownName, mipCountTypeEnum.MIP_LEVELS_1 )
        self.ButtonRenderers[2]:SetTexture( textureDown )
    else
        self.ButtonRenderers[2]:SetTexture( textureUp )
    end

    -- "Force the bitmap style on..."
    self.Style = bit.bor( self.Style, buttonStyleEnum.BS_BITMAP )
end

--- @param mousePos Vector
function INSTANCE:OnLButtonDown( mousePos )
    self:SetCapture()
    self.WasButtonPressedOnMe = true

    -- "Play the sound effect"
    styleManagerClass.PlaySound( eventAudioEnum.MouseClick )
end

--- @param mousePos Vector
function INSTANCE:OnLButtonUp( mousePos )
    self:ReleaseCapture()

    self.IsMouseOverMe = self.Rect:Contains( mousePos )

    -- "Notify the parent (if necessary)"
    if self.WasButtonPressedOnMe and self.IsMouseOverMe then
        self.Parent:OnCommand( self.Id, buttonEventEnum.BN_CLICKED, 0 )
    end

    self.WasButtonPressedOnMe = false
end

--- @param mousePos Vector
function INSTANCE:OnMouseMove( mousePos )
    self.IsMouseOverMe = self.Rect:Contains( mousePos )
end

--- @param mousePos Vector
function INSTANCE:OnSetCursor( mousePos )
    -- "Change the mouse cursor if necessary"
    if self.ClientRect:Contains( mousePos ) then
        mouseManagerClass.SetCursor( cursorTypeEnum.CURSOR_ACTION )
    end
end

function INSTANCE:OnCreate()
    self.GlowRenderer:BuildSentence( self.Title )
end

--- @param focus DialogControlInstance
function INSTANCE:OnKillFocus( focus )
    self.WasButtonPressedOnMe = false
    self.IsMouseOverMe = false

    dialogControlClass.Instance.OnKillFocus( self, focus )
end

--- @param keyId KEY
--- @param keyData integer
--- @return boolean
function INSTANCE:OnKeyDown( keyId, keyData )
    if keyId == KEY_ENTER or keyId == KEY_SPACE then
        self.Parent:OnCommand( self.Id, buttonEventEnum.BN_CLICKED, 0 )

        -- "Play the sound effect"
        styleManagerClass.PlaySound( eventAudioEnum.MouseClick )
        return true
    end

    return false
end

function INSTANCE:OnFrameUpdate()
    dialogControlClass.Instance.OnFrameUpdate( self )

    -- "Get the current mouse position"
    local completeMousePos = dialogManagerClass.GetMousePos()
    -- Omitted creating another mouse pos vector out of the complete one

    -- "Update the pulse (as necessary)"
    if self.ClientRect:Contains( completeMousePos ) then
        self:UpdatePulse( true )
    else
        self:UpdatePulse( false )
    end
end

function INSTANCE:CreateBitmapButton()
    -- "Darken the bitmap if its disabled"
    local color = Color( 255, 255, 255, 255 )
    if self._IsEnabled == false then
        color.r = 96
        color.g = 96
        color.b = 96
    end

    self.ButtonRenderers[1]:Reset()
    self.ButtonRenderers[2]:Reset()
    self.ButtonRenderers[1]:AddQuad( self.Rect, color )
    self.ButtonRenderers[2]:AddQuad( self.Rect, color )
end

function INSTANCE:CreateComponentButton()
    self.ButtonRenderers[1]:Reset()
    self.ButtonRenderers[2]:Reset()

    -- "Turn off texturing on the UI background"
    local texture = ww3dAssetManagerClass.GetInstance():GetTexture( "if_circle02.tga", mipCountTypeEnum.MIP_LEVELS_1 )
    self.ButtonRenderers[1]:SetTexture( texture )
    self.ButtonRenderers[2]:SetTexture( texture )

    local height = 10.0
    local edgeWidth = 10.0

    local top    = STATIC.BUTTON_UVS.Top
    local left   = STATIC.BUTTON_UVS.Left
    local right  = STATIC.BUTTON_UVS.Right
    local bottom = STATIC.BUTTON_UVS.Bottom

    local textureDimensions = Vector( 256.0, 256.0 )

    -- Upper left
    STATIC.BlitSection(
        self.ButtonRenderers[1],
        Vector( self.Rect.Left, self.Rect.Top ),
        Vector( left, top ),
        Vector( edgeWidth, height ),
        textureDimensions
    )

    -- Upper right
    STATIC.BlitSection(
        self.ButtonRenderers[1],
        Vector( self.Rect.Right - edgeWidth, self.Rect.Top ),
        Vector( right - edgeWidth, top ),
        Vector( edgeWidth, height ),
        textureDimensions
    )

    -- Lower left
    STATIC.BlitSection(
        self.ButtonRenderers[1],
        Vector( self.Rect.Left, self.Rect.Bottom - height ),
        Vector( left, bottom - height ),
        Vector( edgeWidth, height ),
        textureDimensions
    )

    -- Lower right
    STATIC.BlitSection(
        self.ButtonRenderers[1],
        Vector( self.Rect.Right - edgeWidth, self.Rect.Bottom - height ),
        Vector( right - edgeWidth, bottom - height ),
        Vector( edgeWidth, height ),
        textureDimensions
    )

    local horizontalTopPos    = Vector( left + ( ( right - left ) / 2 ) - 5, top )
    local horizontalBottomPos = Vector( left + ( ( right - left ) / 2 ) - 5, bottom - height )
    local horizontalSize      = Vector( 10, height )

    -- "Horizontal tile"
    local remainingWidth = self.Rect:Width() - ( edgeWidth * 2 )
    local xPos = self.Rect.Left + edgeWidth
    while remainingWidth > 0 do
        horizontalSize.x = math.min( remainingWidth, horizontalSize.x )

        STATIC.BlitSection( self.ButtonRenderers[1], Vector( xPos, self.Rect.Top ), horizontalTopPos, horizontalSize, textureDimensions )
        STATIC.BlitSection( self.ButtonRenderers[1], Vector( xPos, self.Rect.Bottom - height ), horizontalBottomPos, horizontalSize, textureDimensions )

        xPos = xPos + horizontalSize.x
        remainingWidth = remainingWidth - horizontalSize.x
    end

    local verticalLeftPos  = Vector( left, top + ( ( bottom - top ) / 2 ) - 5 )
    local verticalRightPos = Vector( right - edgeWidth, top + ( ( bottom - top ) / 2 ) - 5 )
    local verticalSize     = Vector( edgeWidth, 10 )

    -- "Vertical tile"
    local remainingHeight = self.Rect:Height() - ( height * 2 )
    local yPos = self.Rect.Top + height
    while remainingHeight > 0 do
        verticalSize.y = math.min( remainingHeight, verticalSize.y )

        STATIC.BlitSection( self.ButtonRenderers[1], Vector( self.Rect.Left, yPos ), verticalLeftPos, verticalSize, textureDimensions )

        STATIC.BlitSection( self.ButtonRenderers[1], Vector( self.Rect.Right - edgeWidth, yPos ), verticalRightPos, verticalSize, textureDimensions )

        yPos = yPos + verticalSize.y
        remainingHeight = remainingHeight - verticalSize.y
    end

    local hilightRect = rectClass.New( self.Rect )
    hilightRect:Inflate( Vector( -( ( edgeWidth / 2 ) + 1 ), -( ( height / 2 ) + 1 ) ) )
    hilightRect.Right = hilightRect.Right + 1.0
    hilightRect.Bottom = hilightRect.Bottom + 1.0
    local uvRect = rectClass.New( STATIC.HILIGHT_UVS )
    uvRect:InverseScaleVector( Vector( 256.0, 256.0 ) )
    self.ButtonRenderers[2]:AddQuad( hilightRect, uvRect )

    local shader = self.ButtonRenderers[1]:GetShader()
    shader:SetDstBlendFunc( dstBlendFuncEnum.One )
    shader:SetSrcBlendFunc( srcBlendFuncEnum.One )

    shader = self.ButtonRenderers[2]:GetShader()
    shader:SetDstBlendFunc( dstBlendFuncEnum.One )
    shader:SetSrcBlendFunc( srcBlendFuncEnum.One )
end

function INSTANCE:CreateComponentButton2()
    -- A classic joke function that's never used
    typecheck.NotImplementedError()
end

function INSTANCE:CreateVectorButton()
    -- This is one of those joke functions that isn't ever used
    typecheck.NotImplementedError()
end

function INSTANCE:CreateTextRenderers()
    self.TextRenderer:Reset()
    self.GlowRenderer:ResetPolys()

    -- "Draw the text"
    styleManagerClass.RenderText( self.Title, self.TextRenderer, self.Rect, true, true, justificationEnum.Center )

    -- "Draw the glow effect"
    styleManagerClass.RenderGlow( self.Title, self.GlowRenderer, self.Rect, 8, 8, styleManagerClass.GetTabGlowColor(), justificationEnum.Center )
end

--- @param isMouseOver boolean
function INSTANCE:UpdatePulse( isMouseOver )
    local PULSE_LENGTH = 1000

    -- "Short circuit if there's nothing to do"
    if self.PulseTime == PULSE_LENGTH and isMouseOver == false then
        return
    end

    local color
    if self._IsEnabled then
        if isMouseOver then
            -- "Examine the current time to determine what percent of the 'pulse' we are at"
            self.PulseTime = self.PulseTime - FrameTime()
            if self.PulseTime < 0 then
                self.PulseTime = self.PulseTime + PULSE_LENGTH
            end

            local percent = self.PulseTime / PULSE_LENGTH

            -- "Map the percent onto a circle to give us a pulse"
            local value = math.cos( math.rad( 360.0 ) * percent )
            value = 0.8 + ( value * 0.2 )

            -- "Convert this value into a grayscale color"
            color = Color( value, value, value )
        else
            color = Color( 255, 255, 255 )
            self.PulseTime = PULSE_LENGTH
        end
    else
        color = Color( 0x60, 0x60, 0x60 )
    end

    -- "Update the color vector arrays"
    local colorArray = self.ButtonRenderers[1]:GetColorArray()
    for index = 1, #colorArray do
        colorArray[index] = color
    end

    local colorArray2 = self.ButtonRenderers[2]:GetColorArray()
    for index = 1, #colorArray2 do
        colorArray2[index] = color
    end
end
