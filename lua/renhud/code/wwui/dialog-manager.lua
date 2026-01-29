-- Based on DialogMgrClass within Code/wwui/dialogmgr.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DialogManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "DialogManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums
--#endregion


--#region Imports

    --- @type StyleManagerClass
    local styleManagerClass = CNC.Import( "renhud/code/wwui/style-manager.lua" )
--#endregion


--#region Imported Enums
--#endregion

--[[
    Note to maintainers:
    I'm pretty sure we don't need to worry about inputs down at the IME level, so I'm omitting IME logic
--]]

--- @class DialogManagerClass
--- @field DialogList DialogBaseInstance[]
--- @field TestArray DialogBaseInstance[]
--- @field TestArrayCount integer
--- @field TestArrayMaxCount integer
--- @field IsFirstRender boolean
--- @field IsInMenuMode boolean
--- @field ActiveDialog DialogBaseInstance
--- @field InputCapture DialogControlInstance
--- @field FocusControl DialogControlInstance
--- @field Input RenegadeUIInputInstance
--- @field Transition DialogTransitionInstance
--- @field PendingActiveDialog DialogBaseInstance
--- @field TransitionDialog DialogBaseInstance
--- @field CurrTime integer
--- @field LastFrameTime integer
--- @field LastMousePos Vector
--- @field LastMouseButtonState boolean
--- @field IsFlushing boolean
--- @field MIMEMessage ToolTipInstance
--- @field MIMEMessageTime integer

STATIC.IsFirstRender = false
STATIC.IsInMenuMode = false
STATIC.CurrTime = 0
STATIC.LastFrameTime = 0
STATIC.LastMousePos = Vector( 0, 0, 0 )
STATIC.LastMouseButtonState = false
STATIC.IsFlushing = false
STATIC.MIMEMessageTime = 0

-- Things added because there were errors.
-- They probably shouldn't be initialized here, but I'm not sure where they should be initialized.
STATIC.GameWasInFocus = false
STATIC.TestArrayMaxCount = 0
STATIC.DialogList = {}


--[[ Library Management ]] do

    --- @param styleManagerIni string
    function STATIC.Initialize( styleManagerIni )
        styleManagerClass.InitializeFromIni( styleManagerIni )
        -- mouseManagerClass.Initialize()
        -- toolTipManagerClass.Initialize()
        -- menuDialogClass.Initialize()

        STATIC.TestArrayMaxCount = 0
    end

    function STATIC.Shutdown()
        typecheck.NotImplementedError()
    end
end


--[[ Per-frame processing ]] do

    function STATIC.Render()
        typecheck.NotImplementedError()
    end

    function STATIC.OnFrameUpdate()
        -- Update the timing
        local oldTime = STATIC.CurrTime
        STATIC.CurrTime = CurTime()
        STATIC.LastFrameTime = STATIC.CurrTime - oldTime

        local dialogList = STATIC.DialogList

        if #dialogList > STATIC.TestArrayMaxCount then
            STATIC.TestArrayMaxCount = #dialogList
            STATIC.TestArray = {}
        end
        STATIC.TestArrayCount = #dialogList

        local testArray = STATIC.TestArray
        for i = 1, STATIC.TestArrayCount do
            testArray[i] = dialogList[i]
        end

        -- "Let each dialog think"
        for index = 1, #STATIC.DialogList do
            -- "Simple check to ensure that the DialogList hasn't changed due to this [OnFrameUpdate()] call"
            if index > STATIC.TestArrayCount or STATIC.DialogList[index] ~= STATIC.TestArray[index] then
                break
            end

            local dialog = STATIC.DialogList[index]
            assert( dialog ~= nil )

            -- Omitting adding a reference count / refcount

            if dialog:IsActive() and dialog:AsChildDialogClass() ~= nil then
                dialog:OnFrameUpdate()
            end

            -- "Force an '[OnPeriodic]' for dialogs that aren't in focus'
            dialog:OnPeriodic()

            -- Omitted releasing reference count / refcount
        end

        -- "Return from 'dialog' mode if the ESC key has been let up..."
        if STATIC.IsInMenuMode and #STATIC.DialogList == 0 and input.IsKeyDown( KEY_ESCAPE ) then
            STATIC.IsInMenuMode = false
            STATIC.Input:ExitMenuMode()
        end
    end
end


--[[ Input Support ]] do

    --- @param instance RenegadeUIInputInstance
    function STATIC.InstallInput( instance )
        STATIC.Input = instance
    end
end

--[[ Keyboard Input ]] do

    --- @param index integer
    --- @return string
    function STATIC.GetVKeyState( index )
        typecheck.NotImplementedError()
    end
end

function STATIC.Reset()
    typecheck.NotImplementedError()
end

--[[ Mouse Input ]] do

    --- "Note X,Y are screen coordinates, while the Z component is the mouse wheel position."
    --- @return Vector
    function STATIC.GetMousePos()
        return STATIC.Input:GetMousePos()
    end

    --- @param pos Vector
    function STATIC.SetMousePos( pos )
        STATIC.Input:SetMousePos( pos )
    end

    --- @return Vector
    function STATIC.GetLastMousePos()
        return STATIC.LastMousePos
    end

    --- @param pos Vector
    function STATIC.SetLastMousePos( pos )
        STATIC.LastMousePos = pos
    end

end