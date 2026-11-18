-- Based on ListEntryClass within Code/wwui/listctrl.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ListEntryClass
--- @field Instance ListEntryInstance The metatable used by ListEntryInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ListEntryClass"

--- @class ListEntryInstance
--- @field Static ListEntryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ListEntry" )
INSTANCE.Class = "ListEntryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsListEntry = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ListEntryClass

    --- Creates a new ListEntryInstance
    --- @return ListEntryInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ListEntry" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ListEntryInstance, `false` otherwise
    function STATIC.IsListEntry( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsListEntry and true or false
    end

    typecheck.RegisterType( "ListEntryInstance", STATIC.IsListEntry )
end


--- @class ListEntryInstance
--- @field Name string
--- @field Color Color
--- @field UserData integer
--- @field IconList string[]

--- @param name string?
function INSTANCE:Renegade_ListEntry( name )
    if isstring( name ) then
        self.Name = name --[[@as string]]
    else
        self.Name = ""
    end

    self.Color = Color( 255, 255, 255 )
    self.UserData = 0
end

function INSTANCE:_Renegade_ListEntry()
	self:ResetIcons()
end


--[[ Name Access ]] do

    --- @return string
    function INSTANCE:GetName()
        return self.Name
    end

    --- @param name string
    function INSTANCE:SetName( name )
        self.Name = name
    end
end


--[[ Color Access ]] do

    --- @return Color
    function INSTANCE:GetColor()
        return self.Color
    end

    --- @param color Color
    function INSTANCE:SetColor( color )
        self.Color = color
    end
end


--[[ User Data Access ]] do

    --- @return integer
    function INSTANCE:GetUserData()
        return self.UserData
    end

    --- @param userData integer
    function INSTANCE:SetUserData( userData )
        self.UserData = userData
    end
end


--[[ Icon Support ]] do

    --- @return integer
    function INSTANCE:GetIconCount()
        return #self.IconList
    end

    --- @param index integer
    --- @return string
    function INSTANCE:GetIcon( index )
        return self.IconList[index]
    end

    --- @param name string
    function INSTANCE:AddIcon( name )
        self.IconList[#self.IconList+1] = name
    end

    function INSTANCE:ResetIcons()
        self.IconList = {}
    end
end
