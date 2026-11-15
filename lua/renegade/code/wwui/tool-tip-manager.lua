-- Based on ToolTipMgrClass within Code/wwui/tooltipmgr.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ToolTipManagerClass
--- @field Instance ToolTipManagerInstance The metatable used by ToolTipManagerInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ToolTipManagerClass"

--- @class ToolTipManagerInstance
--- @field Static ToolTipManagerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ToolTipManager" )
INSTANCE.Class = "ToolTipManagerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsToolTipManager = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type DialogManagerClass
	local dialogManagerClass = CNC.Import( "code/wwui/dialog-manager.lua" )

	--- @type ToolTipClass
	local toolTipClass = CNC.Import( "code/wwui/tool-tip.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ToolTipManagerClass
	--- @field ToolTip ToolTipInstance
	--- @field ToolTipDelay integer
	--- @field DefaultToolTipDelay integer
	--- @field ToolTipDisplayed boolean
	--- @field LastMousePos Vector
	--- @field PauseTime integer
	--- @field CurrentControl DialogControlInstance

	STATIC.ToolTipDelay = 1000
	STATIC.DefaultToolTipDelay = 1000

    --- Creates a new ToolTipManagerInstance
    --- @return ToolTipManagerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ToolTipManager" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ToolTipManagerInstance, `false` otherwise
    function STATIC.IsToolTipManager( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsToolTipManager and true or false
    end

    typecheck.RegisterType( "ToolTipManagerInstance", STATIC.IsToolTipManager )

	function STATIC.StaticConstructor()
		STATIC.ToolTip = nil
		STATIC.ToolTipDisplayed = false
		STATIC.CurrentControl = nil
		STATIC.LastMousePos = Vector( 0, 0 )
		STATIC.PauseTime = -1
	end

	function STATIC.Initialize()
		STATIC.ToolTipDisplayed = false

		-- "Allocate the tooltip object"
		STATIC.ToolTip = toolTipClass.New()
	end

	function STATIC.Shutdown()
		STATIC.ToolTipDisplayed = false

		-- "Free the tooltip object"
		STATIC.ToolTip = nil
	end

	function STATIC.Render()
		-- "Simply render the tooltip (if necessary)"
		if STATIC.ToolTipDisplayed and STATIC.ToolTip ~= nil then
			STATIC.ToolTip:Render()
		end
	end

	function STATIC.Reset()
		STATIC.ToolTipDisplayed = false
	end

	--- @param mousePos Vector
	function STATIC.Update( mousePos )
		if STATIC.ToolTip == nil then
			return
		end

		if STATIC.ToolTipDisplayed == false and mousePos == STATIC.LastMousePos then
			-- "Begin waiting for the mouse to move"
			if STATIC.PauseTime == -1 then
				STATIC.PauseTime = dialogManagerClass.GetTime()
			elseif ( dialogManagerClass.GetTime() - STATIC.PauseTime ) > STATIC.ToolTipDelay then
				-- "What control are we over?"
				local control = dialogManagerClass.FindControl( mousePos )
				if control ~= nil and control:WantsTooltip() then
					STATIC.CurrentControl = control

					-- "Update the text of the tooltip"
					local text = control:GetTooltipText()
					STATIC.ToolTip:SetText( text )

					-- "Reposition the tooltip"
					local tipPos = Vector( mousePos.x + 16, mousePos.y + 32 )
					STATIC.ToolTip:SetPosition( tipPos )

					-- "Display the tooltip"
					STATIC.ToolTipDisplayed = true
					STATIC.PauseTime = -1
				end
			end
		elseif mousePos ~= STATIC.LastMousePos then
			STATIC.PauseTime = -1

			if STATIC.ToolTipDisplayed then
				-- "Did we move onto a different control"
				local control = dialogManagerClass.FindControl( mousePos )
				if control ~= STATIC.CurrentControl then
					-- "Force the tooltip to be hidden"
					STATIC.ToolTipDisplayed = false
					STATIC.CurrentControl = nil
				end
			end
		end

		STATIC.LastMousePos = mousePos
	end
end


--- @class ToolTipManagerInstance
