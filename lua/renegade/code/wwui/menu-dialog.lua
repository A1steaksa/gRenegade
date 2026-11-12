-- Based on MenuDialogClass within Code/wwui/menudialog.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DialogBaseClass
local dialogBaseClass = CNC.Import( "code/wwui/dialog-base.lua" )

--- @class MenuDialogClass : DialogBaseClass
--- @field Instance MenuDialogInstance The metatable used by MenuDialogInstance
local STATIC = CNC.CreateExport( dialogBaseClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MenuDialogClass"

--- @class MenuDialogInstance : DialogBaseInstance
--- @field Static MenuDialogClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MenuDialog : Renegade_DialogBase" )
INSTANCE.Class = "MenuDialogInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMenuDialog = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type MenuBackDropClass
	local menuBackDropClass = CNC.Import( "code/wwui/menu-backdrop.lua" )

	--- @type DialogManagerClass
	local dialogManagerClass = CNC.Import( "code/wwui/dialog-manager.lua" )

	--- @type Render2dClass
	local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )

	--- @type StyleManagerClass
	local styleManagerClass = CNC.Import( "code/wwui/style-manager.lua" )
--#endregion

--#region Imported Enums

	local eventAudioEnum = styleManagerClass.EVENT_AUDIO
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MenuDialogClass
	--- @field ActiveMenu MenuDialogInstance
	--- @field BackDrop MenuBackDropInstance
	--- @field MenuStack MenuDialogInstance[]

    --- Creates a new MenuDialogInstance
    --- @return MenuDialogInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MenuDialog" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MenuDialogInstance, `false` otherwise
    function STATIC.IsMenuDialog( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMenuDialog and true or false
    end

    typecheck.RegisterType( "MenuDialogInstance", STATIC.IsMenuDialog )

	function STATIC.Initialize()
		STATIC.BackDrop = menuBackDropClass.New()
	end

	function STATIC.Shutdown()
		if STATIC.BackDrop ~= nil then
			STATIC.BackDrop = nil
		end
	end

	--- @return MenuBackDropInstance
	function STATIC.GetBackDrop()
		return STATIC.BackDrop
	end

	--- @param backdrop MenuBackDropInstance
	function STATIC.ReplaceBackDrop( backdrop )
		local returnValue = STATIC.BackDrop
		STATIC.BackDrop = backdrop
		return returnValue
	end
end


--- @class MenuDialogInstance

--- @param resourceId integer
function INSTANCE:Renegade_MenuDialog( resourceId )
	dialogBaseClass.Instance.Renegade_DialogBase( self, resourceId )

	-- "Add ourselves to the global stack of menus"
	STATIC.MenuStack[#STATIC.MenuStack+1] = self
end

function INSTANCE:_Renegade_MenuDialog()
	if STATIC.ActiveMenu == self then
		STATIC.ActiveMenu = nil
	end

	-- "Remove ourselves from the stack"
	local index = table.KeyFromValue( STATIC.MenuStack, self )
	if index ~= nil then
		table.remove( STATIC.MenuStack, index )
	end
end


--[[ RTTI ]] do

	--- @return MenuDialogInstance
	function INSTANCE:AsMenuDialogClass()
		return self
	end
end


--[[ Informational ]] do

	--- @return boolean
	function INSTANCE:IsActiveMenu()
		return STATIC.ActiveMenu == self
	end
end


--[[ From DialogBaseInstance ]] do

	function INSTANCE:StartDialog()
		-- "As a menu dialog we use the whole screen"
		self.Rect = render2dClass.GetScreenResolution()

		dialogBaseClass.Instance.StartDialog( self )
	end

	function INSTANCE:Render()
		-- "Don't render if we aren't the active menu"
		if STATIC.ActiveMenu == self or dialogManagerClass.PeekTransitioningDialog() == self then
			-- Render the background scene first
			STATIC.BackDrop:Render()

			-- "Now, let the dialog subsystem render the controls and such..."
			dialogBaseClass.Instance.Render( self )
		end
	end

	function INSTANCE:EndDialog()
		-- "Is this the last menu?  If so, send a notification"
		if dialogManagerClass.IsFlushingDialogs() == false then
			if #STATIC.MenuStack == 1 then
				self:OnLastMenuEnding()
			else
				-- "Play the sound effect"
				styleManagerClass.PlaySound( eventAudioEnum.MenuBack )
			end
		end

		dialogBaseClass.Instance.EndDialog( self )
	end

	--- @param onOff boolean
	function INSTANCE:OnActivate( onOff )
		if onOff then
			-- "Notify the old menu"
			if STATIC.ActiveMenu ~= nil then
				STATIC.ActiveMenu:OnMenuActivate( false )
			end

			-- "Switch to active state"
			STATIC.ActiveMenu = self
			self:OnMenuActivate( true )
		end

		dialogBaseClass.Instance.OnActivate( self, onOff )
	end
end


--[[ New notifications ]] do

	--- @param onOff boolean
	function INSTANCE:OnMenuActivate( onOff )
		-- Empty in the original code
	end

	function INSTANCE:OnLastMenuEnding()
		-- Empty in the original code
	end
end
