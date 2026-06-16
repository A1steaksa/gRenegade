-- Based on HLodClass within Code/ww3d2/hlod.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type Animatable3dObjectClass
local animatable3dObjectClass = CNC.Import( "code/ww3d2/animatable-3d-object.lua" )

--- @class HLodClass : Animatable3dObjectClass
--- @field Instance HLodInstance The metatable used by HLodInstance
local STATIC = CNC.CreateExport( animatable3dObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HLodClass"

--- @class HLodInstance : Animatable3dObjectInstance
--- @field Static HLodClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HLod : Renegade_Animatable3dObject" )
INSTANCE.Class = "HLodInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHLod = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HLodClass

    --- Creates a new HLodInstance
	--- @overload fun( src: HLodInstance ): HLodInstance
	--- @overload fun( name: string, lods: RenderObjectInstance, count: integer ): HLodInstance
	--- @overload fun( definition: HLodDefinitionInstance ): HLodInstance
	--- @overload fun( definition: HModelDefinitionInstance ): HLodInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_HLod", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HLodInstance, `false` otherwise
    function STATIC.IsHLod( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHLod and true or false
    end

    typecheck.RegisterType( "HLodInstance", STATIC.IsHLod )
end


--- @class HLodInstance
--- @field LodCount integer Lod Render Objects, basically one of the LOD Models will be rendered.  Typically each model in an HLodModel will be a mesh or a 'simple' HLod (one with a single LOD)
--- @field CurrentLod integer
--- @field Lod ModelArrayInstance
--- @field BoundingBoxIndex integer "An animating heirarchy can use a hidden CLASSID_OBBOX mesh to represent its bounding box as it animates.  This is the sub object index of that mesh (if it exists)"
--- @field Cost number[] "Cost array (recalculated every frame)"
--- @field Value number[] "Value array (recalculated every frame)"
--- @field AdditionalModels ModelArrayInstance "Additional models, these models have been linked to one of the bones in this model.  They are all always rendered.  They can be HLODs themselves in order to implement switching on sub models.  Note:  This uses [ModelArrayInstance] for convenience, but MaxScreenSize, NonPixelCost, PixelCostPerArea, BenefitFactor are not used here."
--- @field SnapPoints SnapPointsInstance[] "Possible array of snap points."
--- @field ProxyArray ProxyArrayInstance[] "Possible array of proxy objects (names and bone indexes for application defined usage)"
--- @field LodBias number "Current LOD Bias (affects recalculation of the Value array)"


function INSTANCE:Renegade_HLod( ... )
	local args = { ... }
	local argCount = #args

	-- ()
	if argCount == 0 then
		animatable3dObjectClass.Instance.Renegade_Animatable3dObject( self, nil )

		self.LodCount = 0
		self.CurrentLod = 0
		self.Lod = nil
		self.BoundingBoxIndex = -1
		self.Cost = nil
		self.Value = nil
		self.AdditionalModels = modelArrayClass.New()
		self.SnapPoints = nil
		self.ProxyArray = nil
		self.LodBias = 1.0
		return
	end

	if argCount == 1 then
		local arg = args[1]

		typecheck.AssertArgType( self.Class, 1, arg, { "HLodInstance", "HLodDefinitionInstance", "HModelDefinitionInstance" } )

		-- ( src: HLodInstance )
		if typecheck.IsOfType( arg, "HLodInstance" ) then
			typecheck.NotImplementedError()
		-- ( definition: HLodDefinitionInstance )
		elseif typecheck.IsOfType( arg, "HLodDefinitionInstance" ) then
			typecheck.NotImplementedError()

		-- ( definition: HModelDefinitionInstance )
		else
			typecheck.NotImplementedError()
		end
	end

	if argCount == 3 then
		-- ( name: string, lods: RenderObjectInstance, count: integer )
		local name = args[1] --[[@as string]]
		local lods = args[2] --[[@as RenderObjectInstance]]
		local count = args[3] --[[@as integer]]
		typecheck.AssertArgType( self.Class, 1, name, "string" )

		typecheck.NotImplementedError()
		return
	end
end

function INSTANCE:_Renegade_HLod()
	typecheck.NotImplementedError()
end

function INSTANCE:Clone()
	typecheck.NotImplementedError()
end

function INSTANCE:ClassId()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumPolys()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMaxScreenSize()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaxScreenSize()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLodCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLodModelCount()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekLodModel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLodModel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLodModelBone()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAdditionalModelCount()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekAdditionalModel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAdditionalModel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAdditionalModelBone()
	typecheck.NotImplementedError()
end

function INSTANCE:IsNullLodIncluded()
	typecheck.NotImplementedError()
end

function INSTANCE:IncludeNullLod()
	typecheck.NotImplementedError()
end

function INSTANCE:GetProxyCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetProxy()
	typecheck.NotImplementedError()
end

function INSTANCE:Render()
	typecheck.NotImplementedError()
end

function INSTANCE:SpecialRender()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:NotifyAdded()
	typecheck.NotImplementedError()
end

function INSTANCE:NotifyRemoved()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumSubObjects()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSubObject()
	typecheck.NotImplementedError()
end

function INSTANCE:AddSubObject()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveSubObject()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumSubObjectsOnBone()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSubObjectOnBone()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSubObjectBoneIndex()
	typecheck.NotImplementedError()
end

function INSTANCE:AddSubObjectToBone()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:CastRay()
	typecheck.NotImplementedError()
end

function INSTANCE:CastAaBox()
	typecheck.NotImplementedError()
end

function INSTANCE:CastObBox()
	typecheck.NotImplementedError()
end

function INSTANCE:IntersectAaBox()
	typecheck.NotImplementedError()
end

function INSTANCE:IntersectObBox()
	typecheck.NotImplementedError()
end

function INSTANCE:PrepareLod()
	typecheck.NotImplementedError()
end

function INSTANCE:RecalculateStaticLodFactors()
	typecheck.NotImplementedError()
end

function INSTANCE:IncrementLod()
	typecheck.NotImplementedError()
end

function INSTANCE:DecrementLod()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCost()
	typecheck.NotImplementedError()
end

function INSTANCE:GetValue()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPostIncrementValue()
	typecheck.NotImplementedError()
end

function INSTANCE:SetLodLevel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLodLevel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLodCount()
	typecheck.NotImplementedError()
end

function INSTANCE:SetLodBias()
	typecheck.NotImplementedError()
end

function INSTANCE:CalculateCostValueArrays()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCurrentLod()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBoundingSphere()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBoundingBox()
	typecheck.NotImplementedError()
end

function INSTANCE:GetObjectSpaceBoundingSphere()
	typecheck.NotImplementedError()
end

function INSTANCE:GetObjectSpaceBoundingBox()
	typecheck.NotImplementedError()
end

function INSTANCE:CreateDecal()
	typecheck.NotImplementedError()
end

function INSTANCE:DeleteDecal()
	typecheck.NotImplementedError()
end

function INSTANCE:Scale()
	typecheck.NotImplementedError()
end

function INSTANCE:GetNumSnapPoints()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSnapPoint()
	typecheck.NotImplementedError()
end

function INSTANCE:SetHidden()
	typecheck.NotImplementedError()
end

function INSTANCE:SetHTree()
	typecheck.NotImplementedError()
end

function INSTANCE:Free()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateSubObjectTransforms()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateObjectSpaceBoundingVolumes()
	typecheck.NotImplementedError()
end

function INSTANCE:AddLodModel()
	typecheck.NotImplementedError()
end
