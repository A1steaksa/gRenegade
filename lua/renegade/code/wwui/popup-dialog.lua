-- Based on PopupDialogClass within Code/wwui/popupdialog.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DialogBaseClass
local dialogBaseClass = CNC.Import( "code/wwui/dialog-base.lua" )

--- @class PopupDialogClass : DialogBaseClass
--- @field Instance PopupDialogInstance The metatable used by PopupDialogInstance
local STATIC = CNC.CreateExport( dialogBaseClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PopupDialogClass"

--- @class PopupDialogInstance : DialogBaseInstance
--- @field Static PopupDialogClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PopupDialog : Renegade_DialogBase" )
INSTANCE.Class = "PopupDialogInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPopupDialog = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type StyleManagerClass
	local styleManagerClass = CNC.Import( "code/wwui/style-manager.lua" )

	--- @type ShaderClass
	local shaderClass = CNC.Import( "code/ww3d2/shader.lua" )

	--- @type Render2dClass
	local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )

	--- @type RectClass
	local rectClass = CNC.Import( "code/wwmath/rect.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PopupDialogClass

    STATIC.TITLE_BORDER_WIDTH  = 10
    STATIC.TITLE_BORDER_HEIGHT = 8

    --- Creates a new PopupDialogInstance
    --- @param resourceId integer
    --- @return PopupDialogInstance
    function STATIC.New( resourceId )
        return robustclass.New( "Renegade_PopupDialog", resourceId )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PopupDialogInstance, `false` otherwise
    function STATIC.IsPopupDialog( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPopupDialog and true or false
    end

    typecheck.RegisterType( "PopupDialogInstance", STATIC.IsPopupDialog )
end


--- @class PopupDialogInstance
--- @field BlackoutRenderer Render2dInstance
--- @field BackgroundRenderer Render2dInstance
--- @field TextRenderer Render2dTextInstance
--- @field IsBackgroundDarkened boolean

--- @param resourceId integer
function INSTANCE:Renegade_PopupDialog( resourceId )
    dialogBaseClass.Instance.Renegade_DialogBase( self, resourceId )

    -- "Configure the renderers"
    styleManagerClass.ConfigureRenderer( self.BackgroundRenderer )
    styleManagerClass.ConfigureRenderer( self.BlackoutRenderer )
    styleManagerClass.AssignFont( self.TextRenderer, styleManagerClass.FONT_STYLE.Header )

    -- "Force this renderer to always render"
    self.BlackoutRenderer:GetShader():SetDepthCompare( shaderClass.DEPTH_COMPARE.PassAlways )

    -- "By default, popup background are dark"
    self.IsBackgroundDarkened = true
end

function INSTANCE:_Renegade_PopupDialog()
    -- Empty in the original code
end


--[[ RTTI ]] do

    --- @return PopupDialogInstance
    function INSTANCE:AsPopupDialogClass()
        return self
    end
end


--[[ Display Methods ]] do

    function INSTANCE:Render()
        -- "Render the backdrop"
        self.BlackoutRenderer:Render()
        self.BackgroundRenderer:Render()
        self.TextRenderer:Render()

        -- "Render the controls"
        dialogBaseClass.Instance.Render( self )
    end

    --- @param title string
    function INSTANCE:SetTitle( title )
        dialogBaseClass.Instance.SetTitle( self, title )
        self:BuildBackgroundRenderers()
    end
end


function INSTANCE:BuildBackgroundRenderers()
    -- "Configure this renderer"
    self.TextRenderer:Reset()
    self.BackgroundRenderer:Reset()
    self.BlackoutRenderer:Reset()
    self.BackgroundRenderer:EnableMaterial( false )
    self.BlackoutRenderer:EnableMaterial( false )

    local resolution = render2dClass.GetScreenResolution()

    -- "Darken the background if IsBackgroundDarkened is set"
    if self.IsBackgroundDarkened then
        self.BlackoutRenderer:AddQuad( resolution, Color( 0, 0, 0, 236 ) )
    end

    -- "Determine which color to draw the outline in"
    local color = styleManagerClass.GetLineColor()
    local bkColor = styleManagerClass.GetBkColor()

    -- "Draw the control outline"
    local rect = self.Rect
    self.BackgroundRenderer:AddRect( rect, 10.0, color, bkColor )

    if self.Title:len() > 0 then
        -- "Determine what scale to use"

        local scaleX = resolution:Width() / 800
        local scaleY = resolution:Height() / 600

        -- "Calculate the title bar rectangle"
        local textExtent = self.TextRenderer:GetTextExtents( self.Title )
        if textExtent.x ~= 0 and textExtent.y ~= 0 then
            local textRect = rectClass.New()
            textRect.Left   = self.Rect.Left
            textRect.Right  = self.Rect.Left + ( textExtent.x + ( STATIC.TITLE_BORDER_WIDTH  * 2 * scaleX ) )
            textRect.Top    = self.Rect.Top  - ( textExtent.y + ( STATIC.TITLE_BORDER_HEIGHT * 2 * scaleY ) )
            textRect.Bottom = self.Rect.Top

            -- "Draw the title bar"
            self.BackgroundRenderer:AddRect( textRect, 1.0, color, bkColor )

            -- "Draw the title text"
            styleManagerClass.RenderText( self.Title, self.TextRenderer, textRect, true, true, styleManagerClass.JUSTIFICATION.Center )
        end
    end
end

--- "Set whether or not background is darkened"
--- @param flag boolean
function INSTANCE:SetBackgroundDarkened( flag )
	self.IsBackgroundDarkened = flag
end

--[[ From DialogBaseClass ]] do

    function INSTANCE:OnInitDialog()
        -- "Generate the backdrop"
        self:BuildBackgroundRenderers()

        dialogBaseClass.Instance.OnInitDialog( self )

        -- "Play the sound effect"
        styleManagerClass.PlaySound( styleManagerClass.EVENT_AUDIO.Popup )
    end
end
