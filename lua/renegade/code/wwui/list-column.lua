-- Based on ListColumnClass within Code/wwui/listctrl.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ListColumnClass
--- @field Instance ListColumnInstance The metatable used by ListColumnInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ListColumnClass"

--- @class ListColumnInstance
--- @field Static ListColumnClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ListColumn" )
INSTANCE.Class = "ListColumnInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsListColumn = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ListEntryClass
	local listEntryClass = CNC.Import( "code/wwui/list-entry.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ListColumnClass

    --- Creates a new ListColumnInstance
    --- @return ListColumnInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ListColumn" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ListColumnInstance, `false` otherwise
    function STATIC.IsListColumn( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsListColumn and true or false
    end

    typecheck.RegisterType( "ListColumnInstance", STATIC.IsListColumn )
end


--- @class ListColumnInstance
--- @field Header ListEntryInstance
--- @field EntryList ListEntryInstance[]
--- @field Width number

function INSTANCE:Renegade_ListColumn()
	self.Width = 0

	self:ResetContents()
end

function INSTANCE:_Renegade_ListColumn()
	self:FreeData()
end


--[[ Name Access ]] do

	--- @return string
	function INSTANCE:GetName()
		return self.Header:GetName()
	end

	--- @param name string
	function INSTANCE:SetName( name )
		self.Header:SetName( name )
	end
end


--[[ Width Access ]] do

	--- @return number
	function INSTANCE:GetWidth()
		return self.Width
	end

	--- @param width number
	function INSTANCE:SetWidth( width )
		self.Width = width
	end
end


--[[ Color Access ]] do

	--- @return Color
	function INSTANCE:GetColor()
		return self.Header:GetColor()
	end

	--- @param color Color
	function INSTANCE:SetColor( color )
		self.Header:SetColor( color )
	end
end


--[[ Entry Access ]] do

	--- @param oldIndex integer
	--- @param newIndex integer
	function INSTANCE:MoveEntry( oldIndex, newIndex )
		if oldIndex < 1 or oldIndex > #self.EntryList and newIndex < 1 or newIndex > #self.EntryList then
			return
		end

		-- "Move the entry"
		local oldEntry = self.EntryList[oldIndex]
		table.insert( self.EntryList, newIndex, oldEntry )
		table.remove( self.EntryList, oldIndex )
	end

	--- @param index1 integer
	--- @param index2 integer
	function INSTANCE:SwapEntries( index1, index2 )
		if index1 < 1 or index1 > #self.EntryList and index2 < 1 or index2 > #self.EntryList then
			return
		end

		-- "Move the entry"
		local tempEntry = self.EntryList[index1]
		self.EntryList[index1] = self.EntryList[index2]
		self.EntryList[index2] = tempEntry
	end

	--- @param index integer
	--- @param entryName string
	--- @return integer
	function INSTANCE:InsertEntry( index, entryName )
		local entry = listEntryClass.New( entryName )

		-- "Should we insert this entry  in the list or add it to the end?"
		if index <= #self.EntryList then
			table.insert( self.EntryList, index, entry )
		else
			index = #self.EntryList + 1
			self.EntryList[index] = entry
		end

		return index
	end

	--- @return integer
	function INSTANCE:GetEntryCount()
		return #self.EntryList
	end

	--- @param index integer
	--- @return boolean
	function INSTANCE:DeleteEntry( index )
		local returnValue = false

		-- "Delete the entry if we can find it in our list"
		table.remove( self.EntryList, index )

		return returnValue
	end

	function INSTANCE:DeleteAllEntries()
		self.EntryList = {}
	end

	--- @param index integer
	--- @param text string
	function INSTANCE:SetEntryText( index, text )
		self.EntryList[index]:SetName( text )
	end

	--- @param index integer
	--- @return string
	function INSTANCE:GetEntryText( index )
		return self.EntryList[index]:GetName()
	end

	--- @param index integer
	--- @param color Color
	function INSTANCE:SetEntryColor( index, color )
		self.EntryList[index]:SetColor( color )
	end

	--- @param index integer
	--- @return Color
	function INSTANCE:GetEntryColor( index )
		return self.EntryList[index]:GetColor()
	end

	--- @param index integer
	--- @param data integer
	function INSTANCE:SetEntryData( index, data )
		self.EntryList[index]:SetUserData( data )
	end

	--- @param index integer
	--- @return integer
	function INSTANCE:GetEntryData( index )
		return self.EntryList[index]:GetUserData()
	end

	--- @param index integer
	--- @return integer
	function INSTANCE:GetIconCount( index )
		return self.EntryList[index]:GetIconCount()
	end

	--- @param index integer
	--- @param iconIndex integer
	--- @return string
	function INSTANCE:GetIcon( index, iconIndex )
		return self.EntryList[index]:GetIcon( iconIndex )
	end

	--- @param index integer
	--- @param name string
	function INSTANCE:AddIcon( index, name )
		self.EntryList[index]:AddIcon( name )
	end

	--- @param index integer
	function INSTANCE:ResetIcons( index )
		self.EntryList[index]:ResetIcons()
	end
end


--[[ Cleanup ]] do

	function INSTANCE:ResetContents()
		-- "Remove all the entries"
		self:FreeData()
	end

	function INSTANCE:FreeData()
		self:DeleteAllEntries()
	end
end
