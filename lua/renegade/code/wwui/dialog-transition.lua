-- Based on DialogTransitionClass within Code/wwui/dialogtransition.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class DialogTransitionClass
--- @field Instance DialogTransitionInstance The metatable used by DialogTransitionInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DialogTransitionClass"

--- @class DialogTransitionInstance
--- @field Static DialogTransitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DialogTransition" )
INSTANCE.Class = "DialogTransitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDialogTransition = true

--#region Exported Enums

	--- @enum DialogTransitionType
	STATIC.DIALOG_TRANSITION_TYPE = {
		SCREEN_OUT = 0,
		SCREEN_IN  = 1,
	}
	local dialogTransitionTypeEnum = STATIC.DIALOG_TRANSITION_TYPE
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class DialogTransitionClass

    --- Creates a new DialogTransitionInstance
    --- @param type DialogTransitionType? [Default: `SCREEN_OUT`]
    --- @return DialogTransitionInstance
    function STATIC.New( type )
        return robustclass.New( "Renegade_DialogTransition", type )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DialogTransitionInstance, `false` otherwise
    function STATIC.IsDialogTransition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDialogTransition and true or false
    end

    typecheck.RegisterType( "DialogTransitionInstance", STATIC.IsDialogTransition )
end


--- @class DialogTransitionInstance
--- @field Type DialogTransitionType


--- @param type DialogTransitionType? [Default: `SCREEN_OUT`]
function INSTANCE:Renegade_DialogTransition( type )
    if type == nil then type = dialogTransitionTypeEnum.SCREEN_OUT end
    self.Type = type
end

function INSTANCE:_Renegade_DialogTransition()
    -- Empty in the original code
end


--[[ Configuration ]] do

    --- @param type DialogTransitionType
    function INSTANCE:SetType( type )
        self.Type = type
    end

    --- @return DialogTransitionType
    function INSTANCE:GetType()
        return self.Type
    end
end


--[[ Frame Updates ]] do

    function INSTANCE:Render()
        -- Empty in the original code
    end

    function INSTANCE:OnFrameUpdate()
        -- Empty in the original code
    end
end


--[[ Flow Control ]] do

    --- @return boolean
    function INSTANCE:IsComplete()
        return true
    end
end

