-- Based on ChildDialogClass within Code/wwui/childdialog.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DialogBaseClass
local dialogBaseClass = CNC.Import( "code/wwui/dialog-base.lua" )

--- @class ChildDialogClass : DialogBaseClass
--- @field Instance ChildDialogInstance The metatable used by ChildDialogInstance
local STATIC = CNC.CreateExport( dialogBaseClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ChildDialogClass"

--- @class ChildDialogInstance : DialogBaseInstance
--- @field Static ChildDialogClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ChildDialog : Renegade_DialogBase" )
INSTANCE.Class = "ChildDialogInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsChildDialog = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type DialogBaseClass
	local dialogBaseClass = CNC.Import( "code/wwui/dialog-base.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ChildDialogClass

    --- Creates a new ChildDialogInstance
    --- @return ChildDialogInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ChildDialog" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ChildDialogInstance, `false` otherwise
    function STATIC.IsChildDialog( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsChildDialog and true or false
    end

    typecheck.RegisterType( "ChildDialogInstance", STATIC.IsChildDialog )
end


--- @class ChildDialogInstance
--- @field ParentDialog DialogBaseInstance?

--- @param resourceId integer
function INSTANCE:Renegade_ChildDialog( resourceId )
    self.ParentDialog = nil
    dialogBaseClass.Instance.Renegade_DialogBase( self, resourceId )
end

function INSTANCE:_Renegade_ChildDialog()
    dialogBaseClass.Instance._Renegade_DialogBase( self )
end


--[[ RTTI ]] do

    --- @return ChildDialogInstance
    function INSTANCE:AsChildDialogClass()
        return self
    end
end


--[[ From DialogBaseClass ]] do

    function INSTANCE:Render()
        -- "Only render the controls... don't render any backdrop or border."
        dialogBaseClass.Instance.Render( self )
    end

    --- @return boolean
    function INSTANCE:IsActive()
        return false
    end

    --- @return boolean
    function INSTANCE:WantsActivation()
        return false
    end
end


--[[ Parent Dialog Access ]] do

    --- @param dialog DialogBaseInstance?
    function INSTANCE:SetParentDialog( dialog )
        self.ParentDialog = dialog
    end

    --- @return DialogBaseInstance
    function INSTANCE:GetParentDialog()
        return self.ParentDialog
    end
end


--[[ Data Management ]] do
    -- "Note: Returning false from either method will keep the dialog from advancing."

    --- @return boolean
    function INSTANCE:OnApply()
        return true
    end

    --- @return boolean
    function INSTANCE:OnDiscard()
        return true
    end

    function INSTANCE:OnReload()
        -- Empty in the original code
    end
end


function INSTANCE:OnInitDialog()
    dialogBaseClass.Instance.OnInitDialog( self )
end
