-- Based on ModelNodeClass within Code/ww3d2/hlod.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ModelNodeClass
--- @field Instance ModelNodeInstance The metatable used by ModelNodeInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ModelNodeClass"

--- @class ModelNodeInstance
--- @field Static ModelNodeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ModelNode" )
INSTANCE.Class = "ModelNodeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsModelNode = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ModelNodeClass

    --- Creates a new ModelNodeInstance
    --- @return ModelNodeInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ModelNode" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ModelNodeInstance, `false` otherwise
    function STATIC.IsModelNode( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsModelNode and true or false
    end

    typecheck.RegisterType( "ModelNodeInstance", STATIC.IsModelNode )
end


--- @class ModelNodeInstance
--- @field Model RenderObjectInstance
--- @field BoneIndex integer

--- @param other ModelNodeInstance
--- @return boolean
function INSTANCE:__eq( other )
    if not STATIC.IsModelNode( other ) then
        return false
    end

    return ( self.Model == other.Model ) and ( self.BoneIndex == other.BoneIndex )
end