-- Based on ModelArrayClass within Code/ww3d2/hlod.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ModelArrayClass
--- @field Instance ModelArrayInstance The metatable used by ModelArrayInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ModelArrayClass"

--- @class ModelArrayInstance : {[integer]: ModelNodeInstance}
--- @field Static ModelArrayClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ModelArray" )
INSTANCE.Class = "ModelArrayInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsModelArray = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ModelArrayClass

    --- Creates a new ModelArrayInstance
    --- @return ModelArrayInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ModelArray" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ModelArrayInstance, `false` otherwise
    function STATIC.IsModelArray( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsModelArray and true or false
    end

    typecheck.RegisterType( "ModelArrayInstance", STATIC.IsModelArray )
end


--- @class ModelArrayInstance : {[integer]: ModelNodeInstance}
--- @field MaxScreenSize number "Maximum screen size for this LOD"
--- @field NonPixelCost number "Cost heuristics of LODS (w/o per-pixel cost)"
--- @field PixelCostPerArea number "PixelCostPerArea * area(normalized) + NonPixelCost = total Cost"
--- @field BenefitFactor number "BenefitFactor * area(normalized) = Benefit"

function INSTANCE:Renegade_ModelArray()
    self.MaxScreenSize = math.huge
    self.NonPixelCost = 0.0
    self.PixelCostPerArea = 0.0
    self.BenefitFactor = 0.0
end
