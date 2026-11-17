-- Based on ListRowClass within Code/wwui/listctrl.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ListRowClass
--- @field Instance ListRowInstance The metatable used by ListRowInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ListRowClass"

--- @class ListRowInstance
--- @field Static ListRowClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ListRow" )
INSTANCE.Class = "ListRowInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsListRow = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ListRowClass

    --- Creates a new ListRowInstance
    --- @return ListRowInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ListRow" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ListRowInstance, `false` otherwise
    function STATIC.IsListRow( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsListRow and true or false
    end

    typecheck.RegisterType( "ListRowInstance", STATIC.IsListRow )
end


--- @class ListRowInstance
--- @field Height number
--- @field _IsSelected boolean

function INSTANCE:Renegade_ListRow()
    self.Height = 0
    self._IsSelected = false
end

function INSTANCE:_Renegade_ListRow()
    -- Empty in the original code.
end

--- @return number
function INSTANCE:GetHeight()
    return self.Height
end

--- @param height number
function INSTANCE:SetHeight( height )
	self.Height = height
end

--- @return boolean
function INSTANCE:IsSelected()
    return self._IsSelected
end

--- @param onOff boolean
function INSTANCE:Select( onOff )
    self._IsSelected = onOff
end
