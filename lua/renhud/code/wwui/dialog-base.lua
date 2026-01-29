-- Based on DialogBaseClass within Code/wwui/dialogbase.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DialogBaseClass
--- @field instance DialogBaseInstance The metatable used by DialogBaseInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "DialogBaseClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class DialogBaseInstance
--- @field Static DialogBaseClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DialogBase" )
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


--[[ Static Functions and Variables ]] do

    --- "  
    --- These dialogs are analagous to Windows dialogs.  
    --- They are initialized from an RC file, however the dialog template is only parsed - the window isn't actually created.  
    --- "  
    --- @class DialogBaseClass

    --- Creates a new DialogBaseInstance
    --- @param resourceId integer
    --- @return DialogBaseInstance
    function STATIC.New( resourceId )
        return robustclass.New( "Renegade_DialogBase", resourceId )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DialogBaseInstance, `false` otherwise
    function STATIC.IsDialogBase( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDialogBase and true or false
    end

    typecheck.RegisterType( "DialogBaseInstance", STATIC.IsDialogBase )
end


--- @class DialogBaseInstance
--- @field protected Title string
--- @field protected Rect RectInstance
--- @field protected DialogResourceId integer
--- @field protected ControlList DialogControlInstance[]
--- @field protected ChildDialogList ChildDialogInstance[]
--- @field protected LastFocusControl DialogControlInstance
--- @field protected _IsVisible boolean
--- @field protected _AreControlsHidden boolean
--- @field protected _IsRunning boolean
--- @field protected LastMouseClickTime integer

--- Constructs a new DialogBaseInstance
--- @param resourceId integer
function INSTANCE:Renegade_DialogBase( resourceId )
    self.DialogResourceId = resourceId
    self._AreControlsHidden = false
    self.LastFocusControl = nil
    self.LastMouseClickTime = 0
    self._IsVisible = true
    self._IsRunning = false
end

--[[ RITI ]] do

    --- @return MenuDialogInstance
    function INSTANCE:AsMenuDialogClass()
        typecheck.NotImplementedError()
    end

    --- @return PopupDialogInstance
    function INSTANCE:AsPopupDialogClass()
        typecheck.NotImplementedError()
    end

    --- @return ChildDialogInstance
    function INSTANCE:AsChildDialogClass()
        typecheck.NotImplementedError()
    end
end

--- @return integer
function INSTANCE:GetDialogId()
    return self.DialogResourceId
end

--[[ Display Methods ]] do

    function INSTANCE:Render()
        typecheck.NotImplementedError()
    end

    --- @param shouldBeVisible boolean
    function INSTANCE:Show( shouldBeVisible )
        self._IsVisible = shouldBeVisible
    end

    --- @return boolean
    function INSTANCE:IsVisible()
        return self._IsVisible
    end

    --- @param isDirty boolean
    function INSTANCE:SetDirty( isDirty )
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
    function INSTANCE:isRunning()
        return self._IsRunning
    end
end

--[[ Control Access ]] do

    --- @param id integer
    function INSTANCE:GetDialogItem( id )
        typecheck.NotImplementedError()
    end

    function INSTANCE:FindControl( mousePos )
        typecheck.NotImplementedError()
    end

    --- @param control DialogControlInstance
    function INSTANCE:AddControl( control )
        typecheck.NotImplementedError()
    end

    --- @param control DialogControlInstance
    function INSTANCE:RemoveControl( control )
        typecheck.NotImplementedError()
    end

    --- @param control DialogControlInstance
    --- @param direction integer? [Default: 1]
    --- @return DialogControlInstance
    function INSTANCE:FindNextControl( control, direction )
        if not direction then direction = 1 end

        typecheck.NotImplementedError()
    end

    --- @param control DialogControlInstance
    --- @param direction integer? [Default: 1]
    --- @return DialogControlInstance
    function INSTANCE:FindNextGroupControl( control, direction )
        if not direction then direction = 1 end

        typecheck.NotImplementedError()
    end

    --- @return integer
    function INSTANCE:GetControlCount()
        return #self.ControlList
    end

    --- @param index integer
    --- @return DialogControlInstance
    function INSTANCE:GetControl( index )
        return self.ControlList[index]
    end
end

--[[ Control Enable State Access ]] do

    --- @param id integer
    --- @param shouldBeEnabled boolean
    function INSTANCE:EnableDialogItem( id, shouldBeEnabled )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @return boolean
    function INSTANCE:IsDialogItemEnabled( id )
        typecheck.NotImplementedError()
    end
end

--[[ Control Text Access ]] do

    --- @param id integer
    --- @return string
    function INSTANCE:GetDialogItemText( id )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @param text string
    function INSTANCE:SetDialogItemText( id, text )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @return integer
    function INSTANCE:GetDialogItemInteger( id )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @param value integer
    function INSTANCE:SetDialogItemInteger( id, value )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @return number
    function INSTANCE:GetDialogItemFloat( id )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @param value number
    function INSTANCE:SetDialogItemFloat( id, value )
        typecheck.NotImplementedError()
    end
end

--[[ Control "Check" Access ]] do

    --- @param id integer
    --- @param shouldBeChecked boolean
    function INSTANCE:CheckDialogButton( id, shouldBeChecked )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @return boolean
    function INSTANCE:IsDialogButtonChecked( id )
        typecheck.NotImplementedError()
    end
end

--[[ Child Dialog Access ]] do

    --- @param child ChildDialogInstance
    function INSTANCE:AddChildDialog( child )
        typecheck.NotImplementedError()
    end

    --- @param child ChildDialogInstance
    function INSTANCE:RemoveChildDialog( child )
        typecheck.NotImplementedError()
    end
end

--[[ Title Access ]] do

    --- @return string
    function INSTANCE:GetTitle()
        return self.Title
    end

    --- @param newTitle string
    function INSTANCE:SetTitle( newTitle )
        self.Title = newTitle
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

--[[ Transmission Control ]] do

    --- @param previousDialog DialogBaseInstance
    --- @return DialogTransitionInstance?
    function INSTANCE:GetTransitionIn( previousDialog )
        return nil
    end

    --- @param nextDialog DialogBaseInstance
    --- @return DialogTransitionInstance?
    function INSTANCE:GetTransitionOut( nextDialog )
        return nil
    end

    --- @param shouldBeHidden boolean
    function INSTANCE:SetControlsHidden( shouldBeHidden )
        self.AreControlsHidden = shouldBeHidden
    end

    --- @return boolean
    function INSTANCE:AreControlsHidden()
        return self._AreControlsHidden
    end
end

--[[ Notifications ]] do

    --- @param controlId integer
    --- @param messageId integer
    --- @param param any
    function INSTANCE:OnCommand( controlId, messageId, param )
        typecheck.NotImplementedError()
    end
end

--[[ Default Processing Support ]] do

    --- @param callback fun()
    function STATIC.SetDefaultCommandHandler( callback )
        STATIC.DefaultCommandHandler = callback
    end

    --- @return fun() callback
    function STATIC.GetDefaultCommandHandler()
        return STATIC.DefaultCommandHandler
    end
end

--[[ Protected Methods ]] do

    function INSTANCE:OnInitDialog()
        typecheck.NotImplementedError()
    end

    function INSTANCE:OnDestroy()
        typecheck.NotImplementedError()
    end

    --- @param isActive boolean
    function INSTANCE:OnActivate( isActive )
        typecheck.NotImplementedError()
    end

    --- @param keyId KEY
    --- @param keyData integer
    function INSTANCE:OnKeyDown( keyId, keyData )
        typecheck.NotImplementedError()
    end

    --- @param unicode string
    function INSTANCE:OnUnicodeChar( unicode )
        typecheck.NotImplementedError()
    end

    --- @param direction integer
    function INSTANCE:OnMouseWheel( direction )
        typecheck.NotImplementedError()
    end

    --- @param keyId KEY
    function INSTANCE:OnKeyUp( keyId )
        typecheck.NotImplementedError()
    end

    function INSTANCE:OnFrameUpdate()
        typecheck.NotImplementedError()
    end

    function INSTANCE:OnPeriodic()
        typecheck.NotImplementedError()
    end

    function INSTANCE:FreeControls()
        typecheck.NotImplementedError()
    end

    function INSTANCE:UpdateMouseState()
        typecheck.NotImplementedError()
    end

    --- @return integer
    function INSTANCE:FindFocusControl()
        typecheck.NotImplementedError()
    end

    --- @param control DialogControlInstance
    --- @return integer
    function INSTANCE:FindControlIndex( control )
        typecheck.NotImplementedError()
    end

    --- @param control DialogControlInstance
    --- @param mousePos Vector
    function INSTANCE:SendMouseInput( control, mousePos )
        typecheck.NotImplementedError()
    end

    --- @param list DialogControlInstance[]
    function INSTANCE:BuildControlList( list )
        typecheck.NotImplementedError()
    end

    function INSTANCE:SetDefaultFocus()
        typecheck.NotImplementedError()
    end
end

