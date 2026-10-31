-- Based on DialogControlClass within Code/wwui/dialogcontrol.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ControlAdviseSinkClass
local controlAdviseSinkClass = CNC.Import( "code/wwui/control-advise-sink.lua" )

--- @class DialogControlClass : ControlAdviseSinkClass
--- @field Instance DialogControlInstance The metatable used by DialogControlInstance
local STATIC = CNC.CreateExport( controlAdviseSinkClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DialogControlClass"

--- @class DialogControlInstance : ControlAdviseSinkInstance
--- @field Static DialogControlClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DialogControl : Renegade_ControlAdviseSink" )
INSTANCE.Class = "DialogControlInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDialogControl = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type RectClass
	local rectClass = CNC.Import( "code/wwmath/rect.lua" )

	--- @type StyleManagerClass
	local styleManagerClass = CNC.Import( "code/wwui/style-manager.lua" )

	--- @type DialogManagerClass
	local dialogManagerClass = CNC.Import( "code/wwui/dialog-manager.lua" )

	--- @type MouseManagerClass
	local mouseManagerClass = CNC.Import( "code/wwui/mouse-manager.lua" )
--#endregion

--#region Imported Enums

	local cursorTypeEnum = mouseManagerClass.CURSOR_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class DialogControlClass

    --- Creates a new DialogControlInstance
    --- @return DialogControlInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DialogControl" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DialogControlInstance, `false` otherwise
    function STATIC.IsDialogControl( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDialogControl and true or false
    end

    typecheck.RegisterType( "DialogControlInstance", STATIC.IsDialogControl )
end


--- @class DialogControlInstance
--- @field Title string
--- @field ToolTipText string
--- @field Rect RectInstance
--- @field ClientRect RectInstance
--- @field Style integer
--- @field Id integer
--- @field Parent DialogBaseInstance
--- @field _HasFocus boolean
--- @field _IsDirty boolean
--- @field _WantsFocus boolean
--- @field _IsEnabled boolean
--- @field _IsVisible boolean
--- @field _IsEmbedded boolean
--- @field TextColor Color
--- @field IsTextColorOverridden boolean
--- @field AdviseSink ControlAdviseSinkInstance?

function INSTANCE:Renegade_DialogControl()
	controlAdviseSinkClass.Instance.Renegade_ControlAdviseSink( self )

	self.Rect = rectClass.New( 0, 0, 0, 0 )
	self.ClientRect = rectClass.New( 0, 0, 0, 0 )
	self.Style = 0
	self.Id = 0
	self.Parent = nil
	self._HasFocus = false
	self._IsDirty = true
	self._WantsFocus = true
	self.AdviseSink = nil
	self._IsEnabled = true
	self._IsVisible = true
	self._IsEmbedded = false
	self.IsTextColorOverridden = false

	self.TextColor = styleManagerClass.GetTextColor()
end

function INSTANCE:_Renegade_DialogControl()
	-- "Remove the input focus if this control has it"
	if dialogManagerClass.GetFocus() == self then
		dialogManagerClass.SetFocus( nil )
	end
end


--[[ RTTI ]] do

	--- @return CheckBoxControlInstance?
	function INSTANCE:AsCheckBoxControlClass()
		return nil
	end

	--- @return CheckBoxControlInstance?
	function INSTANCE:AsEditControlClass()
		return nil
	end

	--- @return ListControlInstance?
	function INSTANCE:AsListControlClass()
		return nil
	end

	--- @return TabControlInstance?
	function INSTANCE:AsTabControlClass()
		return nil
	end

	--- @return DialogTextInstance?
	function INSTANCE:AsDialogTextClass()
		return nil
	end

	--- @return InputControlInstance?
	function INSTANCE:AsInputControlClass()
		return nil
	end

	--- @return ButtonControlInstance?
	function INSTANCE:AsButtonControlClass()
		return nil
	end

	--- @return MenuEntryControlInstance?
	function INSTANCE:AsMenuEntryControlClass()
		return nil
	end

	--- @return ComboBoxControlInstance?
	function INSTANCE:AsComboBoxControlClass()
		return nil
	end

	--- @return ScrollBarControlInstance?
	function INSTANCE:AsScrollBarControlClass()
		return nil
	end

	--- @return SliderControlInstance?
	function INSTANCE:AsSliderControlClass()
		return nil
	end

	--- @return ViewerControlInstance?
	function INSTANCE:AsViewerControlClass()
		return nil
	end

	--- @return ShortcutBarControlInstance?
	function INSTANCE:AsShortcutBarControlClass()
		return nil
	end

	--- @return TreeControlInstance?
	function INSTANCE:AsTreeControlClass()
		return nil
	end
end


--[[ Simple Property Access ]] do

	--- @return string
	function INSTANCE:GetText()
		return self.Title
	end

	--- @return RectInstance
	function INSTANCE:GetWindowRect()
		return self.Rect
	end

	--- @return Vector
	function INSTANCE:GetWindowPos()
		return self.Rect:UpperLeft()
	end

	--- @return RectInstance
	function INSTANCE:GetClientRect()
		return self.ClientRect
	end

	--- @return integer
	function INSTANCE:GetStyle()
		return self.Style
	end

	--- @return integer
	function INSTANCE:GetId()
		return self.Id
	end

	--- @param title string
	function INSTANCE:SetText( title )
		self.Title = title
		self:SetDirty()
	end

	--- @param rect RectInstance
	function INSTANCE:SetWindowRect( rect )
		self.Rect = rect
		self:UpdateClientRect()
	end

	--- @param pos Vector
	function INSTANCE:SetWindowPos( pos )
		local width  = self.Rect:Width()
		local height = self.Rect:Height()

		-- "Recalculate the window's bounding rectangle"
		self.Rect.Left   = pos.x
		self.Rect.Top    = pos.y
		self.Rect.Right  = ( self.Rect.Left + width )
		self.Rect.Bottom = ( self.Rect.Top  + height )

		-- "Let the control recalculate anything it needs"
		self:UpdateClientRect()
	end

	--- @param rect RectInstance
	function INSTANCE:SetClientRect( rect )
		self.ClientRect = rect
	end

	--- @param style integer
	function INSTANCE:SetStyle( style )
		self.Style = style
	end

	--- @param id integer
	function INSTANCE:SetId( id )
		self.Id = id
	end
end


--[[ Parent Access ]] do

	--- @return DialogBaseInstance
	function INSTANCE:PeekParent()
		return self.Parent
	end

	--- @param parent DialogBaseInstance
	function INSTANCE:SetParent( parent )
		self.Parent = parent
	end
end


--[[ Advise Sink Access ]] do

	--- @return ControlAdviseSinkInstance
	function INSTANCE:GetAdviseSink()
		return self.AdviseSink
	end

	--- @param sink ControlAdviseSinkInstance?
	function INSTANCE:SetAdviseSink( sink )
		self.AdviseSink = sink
	end
end


--[[ Focus Support ]] do

	--- @return boolean
	function INSTANCE:HasFocus()
		return self._HasFocus
	end

	function INSTANCE:SetFocus()
		dialogManagerClass.SetFocus( self )
	end

	--- @return boolean
	function INSTANCE:WantsFocus()
		return self._WantsFocus
	end

	--- @param onOff boolean
	function INSTANCE:SetWantsFocus( onOff )
		self._WantsFocus = onOff
	end
end


--[[ Enabled Support ]] do

	--- @return boolean
	function INSTANCE:IsEnabled()
		return self._IsEnabled
	end

	--- @param onOff boolean
	function INSTANCE:Enable( onOff )
		if onOff ~= self._IsEnabled then
			self._IsEnabled = onOff
			self:SetDirty()

			-- "Remove the focus (if necessary)"
			if self._IsEnabled == false and dialogManagerClass.GetFocus() == self then
				dialogManagerClass.SetFocus( nil )
			end
		end
	end
end


--[[ Visibility ]] do

	--- @param onOff boolean
	function INSTANCE:Show( onOff )
		self._IsVisible = onOff
	end

	--- @return boolean
	function INSTANCE:IsVisible()
		return self._IsVisible
	end
end


--[[ Embedded Support ]] do

	--- @param onOff boolean
	function INSTANCE:SetIsEmbedded( onOff )
		self._IsEmbedded = onOff
	end

	--- @return boolean
	function INSTANCE:IsEmbedded()
		return self._IsEmbedded
	end
end


--[[ Input Capture support ]] do

	function INSTANCE:SetCapture()
		dialogManagerClass.SetCapture( self )
	end

	function INSTANCE:ReleaseCapture()
		dialogManagerClass.ReleaseCapture()
	end
end


--[[ Tooltip Support ]] do

	--- @return boolean
	function INSTANCE:WantsTooltip()
		return self.ToolTipText:len() > 0
	end

	--- @return string
	function INSTANCE:GetTooltipText()
		return self.ToolTipText
	end

	--- @param text string
	function INSTANCE:SetTooltipText( text )
		self.ToolTipText = text
	end
end


--[[ Appearance Control ]] do

	--- @return Color
	function INSTANCE:GetTextColor()
		return self.TextColor
	end

	--- @param color Color
	function INSTANCE:SetTextColor( color )
		self.TextColor = color
		self.IsTextColorOverridden = true
		self:SetDirty()
	end
end


--[[ Display Methods ]] do

	function INSTANCE:Render()
		self._IsDirty = false
	end

	function INSTANCE:CenterMouse()
		-- Empty in the original code
	end
end


--[[ Dirty Support ]] do

	--- @param onOff boolean? [Default: `true`]
	function INSTANCE:SetDirty( onOff )
		if onOff == nil then onOff = true end

		self._IsDirty = onOff
	end

	--- @return boolean
	function INSTANCE:IsDirty()
		return self._IsDirty
	end
end


--- @param mousePos Vector
function INSTANCE:OnLButtonDown( mousePos )
	-- Empty in the original code
end

--- @param mousePos Vector
function INSTANCE:OnLButtonDoubleClick( mousePos )
	-- Empty in the original code
end

--- @param mousePos Vector
function INSTANCE:OnLButtonUp( mousePos )
	-- Empty in the original code
end

--- @param mousePos Vector
function INSTANCE:OnRButtonDown( mousePos )
	-- Empty in the original code
end

--- @param mousePos Vector
function INSTANCE:OnRButtonUp( mousePos )
	-- Empty in the original code
end

--- @param mousePos Vector
function INSTANCE:OnMButtonDown( mousePos )
	-- Empty in the original code
end

--- @param mousePos Vector
function INSTANCE:OnMButtonUp( mousePos )
	-- Empty in the original code
end

--- @param mousePos Vector
function INSTANCE:OnMouseMove( mousePos )
	-- Empty in the original code
end

--- @param keyId integer
--- @param keyData integer
--- @return boolean
function INSTANCE:OnKeyDown( keyId, keyData )
	return false
end

--- @param keyId integer
--- @return boolean
function INSTANCE:OnKeyUp( keyId )
	return false
end

--- @param unicode string
function INSTANCE:OnUnicodeChar( unicode )
	-- Empty in the original code
end

--- @param direction integer
function INSTANCE:OnMouseWheel( direction )
	-- Empty in the original code
end

--- @param mousePos Vector
function INSTANCE:OnSetCursor( mousePos )
	mouseManagerClass.SetCursor( cursorTypeEnum.CURSOR_ARROW )
end

function INSTANCE:OnCreate()
	-- Empty in the original code
end

function INSTANCE:OnDestroy()
	-- Empty in the original code
end

function INSTANCE:OnAddToDialog()
	-- Empty in the original code
end

function INSTANCE:OnRemoveFromDialog()
	-- Empty in the original code
end

function INSTANCE:OnFrameUpdate()
	-- Empty in the original code
end

function INSTANCE:OnSetFocus()
	self._HasFocus = true
end

function INSTANCE:OnKillFocus()
	self._HasFocus = false
end

function INSTANCE:UpdateClientRect()
	self.ClientRect = self.Rect
	self:SetDirty()
end
