-- Based on ControlAdviseSinkClass within Code/wwui/controladvisesink.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ControlAdviseSinkClass
--- @field Instance ControlAdviseSinkInstance The metatable used by ControlAdviseSinkInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ControlAdviseSinkClass"

--- @class ControlAdviseSinkInstance
--- @field Static ControlAdviseSinkClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ControlAdviseSink" )
INSTANCE.Class = "ControlAdviseSinkInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsControlAdviseSink = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ControlAdviseSinkClass

    --- Creates a new ControlAdviseSinkInstance
    --- @return ControlAdviseSinkInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ControlAdviseSink" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ControlAdviseSinkInstance, `false` otherwise
    function STATIC.IsControlAdviseSink( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsControlAdviseSink and true or false
    end

    typecheck.RegisterType( "ControlAdviseSinkInstance", STATIC.IsControlAdviseSink )
end

--- "  
--- This is an abstrct base class that defines an interface
--- which dialog controls can communicate state/activation
--- changes via.  
--- "  
--- @class ControlAdviseSinkInstance

function INSTANCE:Renegade_ControlAdviseSink()
	-- Empty in the original code
end

function INSTANCE:_Renegade_ControlAdviseSink()
	-- Empty in the original code
end


--[[ Generic Callbacks ]] do

	--- @param control DialogControlInstance
	--- @param controlId integer
	--- @param param1 integer
	--- @param param2 integer
	--- @return boolean
	function INSTANCE:OnCommand( control, controlId, param1, param2 )
		return false
	end
end


--[[ Scrollbar Callbacks ]] do

	--- @param scrollBar ScrollBarControlInstance
	--- @param controlId integer
	--- @param newPosition integer
	function INSTANCE:OnVerticalScroll( scrollBar, controlId, newPosition )
		-- Empty in the original code
	end

	--- @param scrollBar ScrollBarControlInstance
	--- @param controlId integer
	--- @param direction integer
	function INSTANCE:OnVerticalScrollPage( scrollBar, controlId, direction )
		-- Empty in the original code
	end
end


--[[ List Control Callbacks ]] do

	--- @param listControl ListControlInstance
	--- @param controlId integer
	--- @param itemIndex integer
	function INSTANCE:OnListControlDeleteEntry( listControl, controlId, itemIndex )
		-- Empty in the original code
	end

	--- @param listControl ListControlInstance
	--- @param controlId integer
	--- @param columnIndex integer
	function INSTANCE:OnListControlColumnClick( listControl, controlId, columnIndex )
		-- Empty in the original code
	end

	--- @param listControl ListControlInstance
	--- @param controlId integer
	--- @param itemIndex integer
	function INSTANCE:OnListControlDoubleClick( listControl, controlId, itemIndex )
		-- Empty in the original code
	end

	--- @param listControl ListControlInstance
	--- @param controlId integer
	--- @param oldIndex integer
	--- @param newIndex integer
	function INSTANCE:OnListControlSelChange( listControl, controlId, oldIndex, newIndex )
		-- Empty in the original code
	end

	--- @param listControl ListControlInstance
	--- @param controlId integer
	--- @param index integer
	function INSTANCE:OnListControlMouseOver( listControl, controlId, index )
		-- Empty in the original code
	end
end


--[[ Tree Control Callbacks ]] do

	--- @param listControl TreeControlInstance
	--- @param controlId integer
	--- @param item TreeItemInstance
	function INSTANCE:OnTreeControlExpandItem( listControl, controlId, item )
		-- Empty in the original code
	end

	--- @param listControl TreeControlInstance
	--- @param controlId integer
	--- @param item TreeItemInstance
	function INSTANCE:OnTreeControlDeleteItem( listControl, controlId, item )
		-- Empty in the original code
	end

	--- @param listControl TreeControlInstance
	--- @param controlId integer
	--- @param oldItem TreeItemInstance
	--- @param newItem TreeItemInstance
	function INSTANCE:OnTreeControlSelChange( listControl, controlId, oldItem, newItem )
		-- Empty in the original code
	end

	--- @param listControl TreeControlInstance
	--- @param controlId integer
	--- @param parentItem TreeItemInstance
	function INSTANCE:OnTreeControlNeedsChildren( listControl, controlId, parentItem )
		-- Empty in the original code
	end
end


--[[ Map Control Callbacks ]] do

	--- @param mapControl MapControlInstance
	--- @param controlId integer
	--- @param markerIndex integer
	function INSTANCE:OnMapControlMarkerHilighted( mapControl, controlId, markerIndex )
		-- Empty in the original code
	end

	--- @param mapControl MapControlInstance
	--- @param controlId integer
	--- @param markerIndex integer
	function INSTANCE:OnMapControlMarkerClicked( mapControl, controlId, markerIndex )
		-- Empty in the original code
	end

	--- @param mapControl MapControlInstance
	--- @param controlId integer
	--- @param pos Vector
	function INSTANCE:OnMapControlPosClicked( mapControl, controlId, pos )
		-- Empty in the original code
	end
end


--[[ Input Control Callbacks ]] do

	--- @param viewerControl ViewerControlInstance
	--- @param controlId integer
	--- @param model RenderObjectInstance
	function INSTANCE:OnViewerControlModelLoaded( viewerControl, controlId, model )
		-- Empty in the original code
	end
end


--[[ Input Control Callbacks ]] do

	--- @param viewerControl ViewerControlInstance
	--- @param controlId integer
	--- @param keyCode KEY
	--- @param keyName string
	--- @param gameKeyId integer
	--- @return boolean
	function INSTANCE:OnInputControlGetKeyInfo( viewerControl, controlId, keyCode, keyName, gameKeyId )
		return false
	end
end


--[[ Slider Control Callbacks ]] do

	--- @param sliderControl SliderControlInstance
	--- @param controlId integer
	--- @param newPosition integer
	function INSTANCE:OnSliderControlPosChanged( sliderControl, controlId, newPosition )
		-- Empty in the original code
	end
end


--[[ Edit Control Callbacks ]] do

	--- @param editControl EditControlInstance
	--- @param controlId integer
	function INSTANCE:OnEditControlEnterPressed( editControl, controlId )
		-- Empty in the original code
	end

	--- @param editControl EditControlInstance
	--- @param keyCode KEY
	--- @param keyData integer
	--- @return boolean
	function INSTANCE:OnEditControlKeyDown( editControl, keyCode, keyData )
		return false
	end

	--- @param editControl EditControlInstance
	--- @param controlId integer
	function INSTANCE:OnEditControlChange( editControl, controlId )
		-- Empty in the original code
	end
end


--[[ Combo Control Callbacks ]] do

	--- @param comboControl ComboBoxControlInstance
	--- @param controlId integer
	--- @param oldSelection integer
	--- @param newSelection integer
	function INSTANCE:OnComboBoxControlSelChange( comboControl, controlId, oldSelection, newSelection )
		-- Empty in the original code
	end

	--- @param comboControl ComboBoxControlInstance
	--- @param controlId integer
	function INSTANCE:OnComboBoxControlEditChange( comboControl, controlId )
		-- Empty in the original code
	end
end


--[[ Merchandise Control Callbacks ]] do

	--- @param control MerchandiseControlInstance
	--- @param controlId integer
	function INSTANCE:OnMerchandiseSelected( control, controlId )
		-- Empty in the original code
	end

	--- @param control MerchandiseControlInstance
	--- @param controlId integer
	function INSTANCE:OnMerchandiseDoubleClick( control, controlId )
		-- Empty in the original code
	end
end

