-- Based on MerchandiseControlClass within Code/wwui/merchandisectrl.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DialogControlClass
local dialogControlClass = CNC.Import( "code/wwui/dialog-control.lua" )

--- @class MerchandiseControlClass : DialogControlClass
--- @field Instance MerchandiseControlInstance The metatable used by MerchandiseControlInstance
local STATIC = CNC.CreateExport( dialogControlClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MerchandiseControlClass"

--- @class MerchandiseControlInstance : DialogControlInstance
--- @field Static MerchandiseControlClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MerchandiseControl : Renegade_DialogControl" )
INSTANCE.Class = "MerchandiseControlInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMerchandiseControl = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type Render2dSentenceClass
	local render2dSentenceClass = CNC.Import( "code/ww3d2/render-2d-sentence.lua" )

	--- @type Render2dClass
	local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )

	--- @type StyleManagerClass
	local styleManagerClass = CNC.Import( "code/wwui/style-manager.lua" )

	--- @type Ww3dAssetManagerClass
	local ww3dAssetManagerClass = CNC.Import( "code/ww3d2/ww3d-asset-manager.lua" )

	--- @type TextureClass
	local textureClass = CNC.Import( "code/ww3d2/texture.lua" )

	--- @type RectClass
	local rectClass = CNC.Import( "code/wwmath/rect.lua" )

	--- @type MouseManagerClass
	local mouseManagerClass = CNC.Import( "code/wwui/mouse-manager.lua" )
--#endregion

--#region Imported Enums

	local fontStyleEnum = styleManagerClass.FONT_STYLE
	local mipCountTypeEnum = textureClass.MIP_COUNT_TYPE
	local justificationEnum = styleManagerClass.JUSTIFICATION
	local cursorTypeEnum = mouseManagerClass.CURSOR_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MerchandiseControlClass

	STATIC.BUTTON_WIDTH = 16.0
	STATIC.BUTTON_HEIGHT = 16.0

    --- Creates a new MerchandiseControlInstance
    --- @return MerchandiseControlInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MerchandiseControl" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MerchandiseControlInstance, `false` otherwise
    function STATIC.IsMerchandiseControl( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMerchandiseControl and true or false
    end

    typecheck.RegisterType( "MerchandiseControlInstance", STATIC.IsMerchandiseControl )
end


--- @class MerchandiseControlInstance
--- @field NameTextRenderer Render2dSentenceInstance
--- @field CostTextRenderer Render2dSentenceInstance
--- @field CountTextRenderer Render2dSentenceInstance
--- @field ControlRenderer Render2dInstance
--- @field TextureRenderer Render2dInstance
--- @field HilightRenderer Render2dInstance
--- @field ButtonRenderer Render2dInstance
--- @field TextureRect RectInstance
--- @field TextRect RectInstance
--- @field CostRect RectInstance
--- @field CountRect RectInstance
--- @field UserData integer
--- @field Cost integer
--- @field Count integer
--- @field TextureNameList string[]
--- @field CurrentTextureIndex integer

function INSTANCE:Renegade_MerchandiseControl()
	dialogControlClass.Instance.Renegade_DialogControl( self )

	self.UserData = 0
	self.Cost = 0
	self.CurrentTextureIndex = 1
	self.Count = 0

	self.NameTextRenderer  = render2dSentenceClass.New()
	self.CostTextRenderer  = render2dSentenceClass.New()
	self.CountTextRenderer = render2dSentenceClass.New()
	self.ControlRenderer   = render2dClass.New()
	self.TextureRenderer   = render2dClass.New()
	self.ButtonRenderer    = render2dClass.New()
	self.HilightRenderer   = render2dClass.New()

	-- "Set the font for the text renderer"
	styleManagerClass.AssignFont( self.NameTextRenderer, fontStyleEnum.Tooltips )
	styleManagerClass.AssignFont( self.CostTextRenderer, fontStyleEnum.Header )
	styleManagerClass.AssignFont( self.CountTextRenderer, fontStyleEnum.Tooltips )
	styleManagerClass.ConfigureRenderer( self.ControlRenderer )
	styleManagerClass.ConfigureRenderer( self.TextureRenderer )
	styleManagerClass.ConfigureRenderer( self.ButtonRenderer )
	styleManagerClass.ConfigureRenderer( self.HilightRenderer )
	styleManagerClass.ConfigureHilighter( self.HilightRenderer )
	self.TextureRenderer:EnableTexturing( true )
	self.ButtonRenderer:EnableTexturing( true )

	-- "Pass the texture onto the renderer"
	local texture = ww3dAssetManagerClass.GetInstance():GetTexture( "hud_cnc_Button.tga", mipCountTypeEnum.MIP_LEVELS_1 )
	self.ButtonRenderer:SetTexture( texture )
end

function INSTANCE:_Renegade_MerchandiseControl()
	dialogControlClass.Instance._Renegade_DialogControl( self )

	-- Empty in the original code
end

--[[ From DialogControlInstance ]] do

	function INSTANCE:Render()
		-- "Update the text renderer (if necessary)"
		if self._IsDirty then
			self:CreateTextRenderer()
			self:CreateControlRenderer()
			self:CreateTextureRenderer()
		end

		-- "Render the parts of the control"
		self.TextureRenderer:Render()
		self.ControlRenderer:Render()
		self.NameTextRenderer:Render()
		self.CostTextRenderer:Render()
		self.CountTextRenderer:Render()
		self.ButtonRenderer:Render()
		self.HilightRenderer:Render()

		dialogControlClass.Instance.Render( self )
	end
end

--[[ Configuration ]] do

	--- @return integer
	function INSTANCE:GetCost()
		return self.Cost
	end

	--- @param cost integer
	function INSTANCE:SetCost( cost )
		self.Cost = cost
		self:SetDirty()
	end

	--- @param textureName string
	function INSTANCE:SetTexture( textureName )
		self.CurrentTextureIndex = 1

		-- "Cache the texture name"
		self.TextureNameList = { textureName }

		-- "Pass the texture onto the renderer"
		local texture = ww3dAssetManagerClass.GetInstance():GetTexture( textureName, mipCountTypeEnum.MIP_LEVELS_1 )
		self.TextureRenderer:SetTexture( texture )
	end

	--- @param textureName string
	function INSTANCE:AddAlternateTexture( textureName )
		self.TextureNameList[#self.TextureNameList+1] = textureName
		self:SetDirty()
	end

	--- @return integer
	function INSTANCE:GetSelectedAlternate()
		return self.CurrentTextureIndex - 1
	end

	--- @return integer
	function INSTANCE:GetUserData()
		return self.UserData
	end

	--- @param data integer
	function INSTANCE:SetUserData( data )
		self.UserData = data
	end

	function INSTANCE:IncrementPurchaseCount()
		self.Count = self.Count + 1
		self:SetDirty()
	end

	function INSTANCE:ResetPurchaseCount()
		self.Count = 0
		self:SetDirty()
	end

	--- @return integer
	function INSTANCE:GetPurchaseCount()
		return self.Count
	end
end


--- @param mousePos Vector
function INSTANCE:OnLButtonDown( mousePos )
	local buttonRect = rectClass.New()
	buttonRect.Right = self.Rect.Right - 1
	buttonRect.Top = self.Rect.Top + 2
	buttonRect.Left = ( buttonRect.Right - ( STATIC.BUTTON_WIDTH * styleManagerClass.GetXScale() ) )
	buttonRect.Bottom = ( buttonRect.Top - ( STATIC.BUTTON_HEIGHT * styleManagerClass.GetYScale() ) )

	-- "Did the user click in the cycle button?"
	if #self.TextureNameList > 1 and buttonRect:Contains( mousePos ) then
		-- "Cycle to the next texture"
		self.CurrentTextureIndex = self.CurrentTextureIndex + 1
		if self.CurrentTextureIndex > #self.TextureNameList then
			self.CurrentTextureIndex = 1
		end

		-- "Pass the texture onto the renderer"
		local texture = ww3dAssetManagerClass.GetInstance():GetTexture( self.TextureNameList[self.CurrentTextureIndex], mipCountTypeEnum.MIP_LEVELS_1 )
		if texture ~= nil then
			self.TextureRenderer:SetTexture( texture )
		end

		self:SetDirty()
	else
		-- "Notify the owner that this item has been purchased"
		if self.Parent ~= nil then self.Parent:OnMerchandiseSelected( self, self:GetId() ) end
		if self.AdviseSink ~= nil then self.AdviseSink:OnMerchandiseSelected( self, self:GetId() ) end
	end
end

--- @param mousePos Vector
function INSTANCE:OnLButtonDoubleClick( mousePos )
	local buttonRect = rectClass.New()
	buttonRect.Right = self.Rect.Right - 1
	buttonRect.Top = self.Rect.Top + 2
	buttonRect.Left = ( buttonRect.Right - ( STATIC.BUTTON_WIDTH * styleManagerClass.GetXScale() ) )
	buttonRect.Bottom = ( buttonRect.Top + ( STATIC.BUTTON_HEIGHT * styleManagerClass.GetYScale() ) )

	-- "Did the user click in the cycle button?"
	if #self.TextureNameList == 0 or buttonRect:Contains( mousePos ) == false then
		-- "Notify the owner that this item has been double-clicked"
		if self.Parent ~= nil then self.Parent:OnMerchandiseDoubleClick( self, self:GetId() ) end
		if self.AdviseSink ~= nil then self.AdviseSink:OnMerchandiseDoubleClick( self, self:GetId() ) end
	end
end

--- @param mousePos Vector
function INSTANCE:OnSetCursor( mousePos )
	-- "Change the mouse cursor"
	mouseManagerClass.SetCursor( cursorTypeEnum.CURSOR_ACTION )
end

function INSTANCE:UpdateClientRect()
	-- "Set the client area"
	self.ClientRect = rectClass.New( self.Rect )
	self.ClientRect:Inflate( Vector( -1, -1 ) )

	-- "Make the texture rectangle the 2/3 of the space"
	self.TextureRect = rectClass.New( self.Rect )
	self.TextureRect.Bottom = ( self.TextureRect.Top + ( self.Rect:Height() * 0.667 ) )

	-- "Make the cost rect use up 60% of the remaining space"
	self.CostRect = rectClass.New( self.Rect )
	self.CostRect.Top = self.TextureRect.Bottom + 1
	self.CostRect.Bottom = self.CostRect.Top + ( ( self.Rect.Bottom - self.TextureRect.Bottom ) * 0.6 )

	-- "The rest of the space goes to the text rect"
	self.TextRect = rectClass.New( self.Rect )
	self.TextRect.Top = self.CostRect.Bottom

	-- "The counter lives in the upper-right corner"
	self.CountRect = rectClass.New(self.Rect )
	self.CountRect.Left = self.CountRect.Left + ( self.Rect:Width() * 0.75 )
	self.CountRect.Bottom = self.CountRect.Top + ( self.Rect:Height() * 0.25 )

	self:SetDirty()
end

function INSTANCE:CreateControlRenderer()
	local renderer = self.ControlRenderer

	-- "Configure this renderer"
	renderer:Reset()
	self.HilightRenderer:Reset()
	self.ButtonRenderer:Reset()
	renderer:EnableTexturing( false )

	-- "Determine which color to draw the outline in"
	local color = styleManagerClass.GetLineColor()
	local bkColor = styleManagerClass.GetBkColor()
	if self._IsEnabled == false then
		color = styleManagerClass.GetDisabledLineColor()
		bkColor = styleManagerClass.GetDisabledBkColor()
	end

	-- "Draw the outlines"
	if self.Count > 0 then
		styleManagerClass.RenderHilight( self.HilightRenderer, self.Rect )
	end

	-- "Draw the cycle button in the upper right corner..."
	if #self.TextureNameList > 1 then
		-- "Draw the button"
		local buttonRect = rectClass.New()
		buttonRect.Right = self.Rect.Right - 1
		buttonRect.Top = self.Rect.Top + 2
		buttonRect.Left = buttonRect.Right - ( STATIC.BUTTON_WIDTH * styleManagerClass.GetXScale() )
		buttonRect.Bottom = buttonRect.Top - ( STATIC.BUTTON_HEIGHT * styleManagerClass.GetYScale() )

		self.ButtonRenderer:AddQuad( buttonRect )
	end

	-- "Convert the cost to a string"
	local costText = tostring( self.Cost )

	-- "Get the dimensions of the text"
	local nameExtents = self.NameTextRenderer:GetTextExtents( self.Title )
	local costExtents = self.CostTextRenderer:GetTextExtents( costText )

	-- "Build rectangles for the backdrops of the cost and text"
	local textRect = self.TextRect
	local costRect = self.CostRect
	textRect.Right = textRect.Left + nameExtents.x + 4.0
	costRect.Right = costRect.Left + costExtents.x + 4.0

	-- "Clip the backdrop to the bounding rectangle"
	textRect.Right = math.min( textRect.Right, self.Rect.Right )
	costRect.Right = math.min( costRect.Right, self.Rect.Right )

	-- "Render the text backdrops"
	local transparentColor = color:Copy()
	transparentColor.a = 0.0
	renderer:AddQuadHorizontalGradient( textRect, color, transparentColor )
	renderer:AddQuadHorizontalGradient( costRect, color, transparentColor )
end

function INSTANCE:CreateTextRenderer()
	-- "Convert the cost to a string"
	local costText = tostring( self.Cost )

	-- "Render the text"
	self.NameTextRenderer:Reset()
	self.CostTextRenderer:Reset()
	self.CountTextRenderer:Reset()
	styleManagerClass.RenderText( self.Title, self.NameTextRenderer, Color( 255, 255, 255 ), Color( 0, 0, 0 ), self.TextRect, true, true, justificationEnum.Left, true )
	styleManagerClass.RenderText( costText, self.NameTextRenderer, Color( 255, 255, 255 ), Color( 0, 0, 0 ), self.TextRect, true, true, justificationEnum.Left, true )

	-- "Render the counter (if necessary)"
	if self.Count > 1 then
		-- "Convert the count to a string"
		local countText = tostring( self.Count )
		styleManagerClass.RenderText( countText, self.CountTextRenderer, Color( 255 ,255, 255 ), Color( 0, 0, 0 ), self.CountRect, true, true, justificationEnum.Center, true )
	end
end

function INSTANCE:CreateTextureRenderer()
	-- "Darken the bitmap if its disabled"
	local color = Color( 255, 255, 255, 255 )
	if self._IsEnabled == false then
		color = Color( 96, 96, 96 )
	end

	-- "Configure this renderer"
	self.TextureRenderer:Reset()
	self.TextureRenderer:AddQuad( self.Rect, color )
end
