-- Based on DialogBaseClass within Code/wwui/dialogbase.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ControlAdviseSinkClass
local controlAdviseSinkClass = CNC.Import( "code/wwui/control-advise-sink.lua" )

--- @type NotifierClass
local notifierClass = CNC.Import( "code/wwlib/notifier.lua" )

--- @class DialogBaseClass : ControlAdviseSinkClass, NotifierClass
--- @field Instance DialogBaseInstance The metatable used by DialogBaseInstance
local STATIC = CNC.CreateExport( controlAdviseSinkClass, notifierClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DialogBaseClass"

--- @class DialogBaseInstance : ControlAdviseSinkInstance, NotifierInstance
--- @field Static DialogBaseClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DialogBase : Renegade_ControlAdviseSink, Renegade_Notifier" )
INSTANCE.Class = "DialogBaseInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDialogBase = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--- @alias DEFAULT_DLG_CMD_HANDLER fun( dialog: DialogBaseInstance, controlId: integer, messageId: integer, param: any ): boolean

--[[ Static Functions and Variables ]] do

	STATIC.RES_SCREEN_WIDTH  = 400
	STATIC.RES_SCREEN_HEIGHT = 300

    --- @class DialogBaseClass
	--- @field DefaultCmdHandler DEFAULT_DLG_CMD_HANDLER

    --- Creates a new DialogBaseInstance
    --- @return DialogBaseInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DialogBase" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DialogBaseInstance, `false` otherwise
    function STATIC.IsDialogBase( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDialogBase and true or false
    end

    typecheck.RegisterType( "DialogBaseInstance", STATIC.IsDialogBase )


	--[[ Default Processing Support ]] do

		--- @param pointer DEFAULT_DLG_CMD_HANDLER
		function STATIC.SetDefaultCommandHandler( pointer )
			STATIC.SetDefaultCommandHandler = pointer
		end

		--- @return DEFAULT_DLG_CMD_HANDLER
		function STATIC.GetDefaultCommandHandler()
			return STATIC.DefaultCmdHandler
		end
	end
end


--- @class DialogBaseInstance
--- @field Title string
--- @field Rect RectInstance
--- @field DialogResourceID integer
--- @field ControlList DialogControlInstance[]
--- @field ChildDialogList ChildDialogInstance[]
--- @field LastFocusControl DialogControlInstance
--- @field _IsVisible boolean
--- @field _AreControlsHidden boolean
--- @field _IsRunning boolean
--- @field LastMouseClickTime integer

--- @param resourceId integer
function INSTANCE:Renegade_DialogBase( resourceId )
	self.DialogResourceID = resourceId
	self._AreControlsHidden = false
	self.LastFocusControl = nil
	self.LastMouseClickTime = 0
	self._IsVisible = true
	self._IsRunning = false
end

function INSTANCE:_Renegade_DialogBase()
	self:FreeControls()
end


--[[ RTTI ]] do

	function INSTANCE:AsMenuDialogClass()
		typecheck.NotImplementedError()
	end

	function INSTANCE:AsPopupDialogClass()
		typecheck.NotImplementedError()
	end

	function INSTANCE:AsChildDialogClass()
		typecheck.NotImplementedError()
	end
end


--- @return integer
function INSTANCE:GetDialogId()
	return self.DialogResourceID
end


--[[ Display Methods ]] do

	function INSTANCE:Render()
		typecheck.NotImplementedError()
	end

	--- @param onOff boolean
	function INSTANCE:Show( onOff )
		self._IsVisible = onOff
	end

	--- @return boolean
	function INSTANCE:IsVisible()
		return self._IsVisible
	end

	--- @param onOff boolean? [Default: `true`]
	function INSTANCE:SetDirty( onOff )
		if onOff == nil then onOff = true end

		typecheck.NotImplementedError()
	end
end


--[[ Position Control ]] do

	--- @return RectInstance
	function INSTANCE:GetRect()
		return self.Rect
	end

	--- @param rect RectInstance
	function INSTANCE:SetRect( rect )
		typecheck.NotImplementedError()
	end
end


--[[ Flow Control ]] do

	function INSTANCE:StartDialog()
		typecheck.NotImplementedError()
	end

	function INSTANCE:EndDialog()
		typecheck.NotImplementedError()
	end

	--- @return boolean
	function INSTANCE:IsRunning()
		return self._IsRunning
	end
end


--[[ Control Access ]] do

	function INSTANCE:GetDialogItem()
		typecheck.NotImplementedError()
	end

	function INSTANCE:FindControl()
		typecheck.NotImplementedError()
	end

	--- @param control DialogControlInstance
	function INSTANCE:AddControl( control )
		-- "Simply add the control to the list"
		if table.KeyFromValue( self.ControlList, control ) == nil then
			self.ControlList[#self.ControlList+1] = control
			control:SetParent( self )
			control:OnAddToDialog()
		end
	end

	function INSTANCE:RemoveControl()
		typecheck.NotImplementedError()
	end

	--- @param control DialogControlInstance
	--- @param direction integer? [Default: `1`]
	function INSTANCE:FindNextControl( control, direction )
		if direction == nil then direction = 1 end

		typecheck.NotImplementedError()
	end

	--- @param control DialogControlInstance
	--- @param direction integer? [Default: `1`]
	function INSTANCE:FindNextGroupControl( control, direction )
		if direction == nil then direction = 1 end

		typecheck.NotImplementedError()
	end

	--- @return integer
	function INSTANCE:GetControlCount()
		return #self.ControlList
	end

	--- @param index integer?
	--- @return DialogControlInstance?
	function INSTANCE:GetControl( index )
		return self.ControlList[index]
	end
end


--[[ Control Enable State Access ]] do

	function INSTANCE:EnableDialogItem()
		typecheck.NotImplementedError()
	end

	function INSTANCE:IsDialogItemEnabled()
		typecheck.NotImplementedError()
	end
end


--[[ Control Text Access ]] do

	function INSTANCE:GetDialogItemText()
		typecheck.NotImplementedError()
	end

	function INSTANCE:SetDialogItemText()
		typecheck.NotImplementedError()
	end

	function INSTANCE:GetDialogItemInt()
		typecheck.NotImplementedError()
	end

	function INSTANCE:SetDialogItemInt()
		typecheck.NotImplementedError()
	end

	function INSTANCE:GetDialogItemFloat()
		typecheck.NotImplementedError()
	end

	function INSTANCE:SetDialogItemFloat()
		typecheck.NotImplementedError()
	end
end


--[[ Control "Check" Access ]] do

	function INSTANCE:CheckDialogButton()
		typecheck.NotImplementedError()
	end

	function INSTANCE:IsDialogButtonChecked()
		typecheck.NotImplementedError()
	end
end


--[[ Child Dialog Access ]] do

	function INSTANCE:AddChildDialog()
		typecheck.NotImplementedError()
	end

	function INSTANCE:RemoveChildDialog()
		typecheck.NotImplementedError()
	end
end


--[[ Title Access ]] do

	--- @return string
	function INSTANCE:GetTitle()
		return self.Title
	end

	--- @param title string
	function INSTANCE:SetTitle( title )
		self.Title = title
	end
end


--[[ Activation Access ]] do

	--- @return boolean
	function INSTANCE:IsActive()
		typecheck.NotImplementedError()
	end

	--- @return boolean
	function INSTANCE:WantsActivation()
		return true
	end
end


--[[ Transition Control ]] do

	--- @param previousDialog DialogBaseInstance
	--- @return DialogTransitionInstance?
	function INSTANCE:GetTransitionIn( previousDialog )
		return nil
	end

	--- @param previousDialog DialogBaseInstance
	--- @return DialogTransitionInstance?
	function INSTANCE:GetTransitionOut( previousDialog )
		return nil
	end

	--- @param onOff boolean
	function INSTANCE:SetControlsHidden( onOff )
		self._AreControlsHidden = onOff
	end

	--- @return boolean
	function INSTANCE:AreControlsHidden()
		return self._AreControlsHidden
	end
end


--[[ Notifications ]] do

	function INSTANCE:OnCommand()
		typecheck.NotImplementedError()
	end
end


function INSTANCE:OnInitDialog()
	typecheck.NotImplementedError()
end

function INSTANCE:OnDestroy()
	-- Empty in the original code
end

function INSTANCE:OnActivate()
	typecheck.NotImplementedError()
end

function INSTANCE:OnKeyDown()
	typecheck.NotImplementedError()
end

function INSTANCE:OnUnicodeChar()
	typecheck.NotImplementedError()
end

function INSTANCE:OnMouseWheel()
	typecheck.NotImplementedError()
end

function INSTANCE:OnKeyUp()
	typecheck.NotImplementedError()
end

function INSTANCE:OnFrameUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:OnPeriodic()
	-- Empty in the original code
end

function INSTANCE:FreeControls()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateMouseState()
	typecheck.NotImplementedError()
end

function INSTANCE:FindFocusControl()
	typecheck.NotImplementedError()
end

--- @param control DialogControlInstance
--- @return integer?
function INSTANCE:FindControlIndex( control )
	return table.KeyFromValue( self.ControlList, control )
end

function INSTANCE:SendMouseInput()
	typecheck.NotImplementedError()
end

function INSTANCE:BuildControlList()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDefaultFocus()
	typecheck.NotImplementedError()
end
