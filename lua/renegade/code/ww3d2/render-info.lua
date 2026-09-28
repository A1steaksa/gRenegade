-- Based on RenderInfoClass within Code/ww3d2/rinfo.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class RenderInfoClass
--- @field Instance RenderInfoInstance The metatable used by RenderInfoInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "RenderInfoClass"

--- @class RenderInfoInstance
--- @field Static RenderInfoClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_RenderInfo" )
INSTANCE.Class = "RenderInfoInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsRenderInfo = true

--#region Exported Enums
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum RenderInfoOverrideFlags
    STATIC.RENDER_INFO_OVERRIDE_FLAGS = {
        RINFO_OVERRIDE_DEFAULT                = 0x0000, -- "No overrides"
        RINFO_OVERRIDE_FORCE_TWO_SIDED        = 0x0001, -- "Override mesh settings to force no backface culling"
        RINFO_OVERRIDE_FORCE_SORTING          = 0x0002, -- "Override mesh settings to force sorting"
        RINFO_OVERRIDE_ADDITIONAL_PASSES_ONLY = 0x0004,	-- "Do not render base passes (only additional passes)"
        RINFO_OVERRIDE_SHADOW_RENDERING       = 0x0008  -- "Hint: we are rendering a shadow"
    }
    local renderInfoOverrideFlagsEnum = STATIC.RENDER_INFO_OVERRIDE_FLAGS
--#endregion

--#region Imports

--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class RenderInfoClass

    STATIC.MAX_ADDITIONAL_MATERIAL_PASSES = 32
    STATIC.MAX_OVERRIDE_FLAG_LEVEL = 32

    --- Creates a new RenderInfoInstance
    --- @param camera CameraInstance
    --- @return RenderInfoInstance
    function STATIC.New( camera )
        return robustclass.New( "Renegade_RenderInfo", camera )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) RenderInfoInstance, `false` otherwise
    function STATIC.IsRenderInfo( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsRenderInfo and true or false
    end

    typecheck.RegisterType( "RenderInfoInstance", STATIC.IsRenderInfo )
end

--- This class contains all of the data needed for the scene to render
--- itself.  It will be passed on to the scene from a WW3D::Render(scene)
--- call.
--- @class RenderInfoInstance
--- @field Camera CameraInstance "The camera being used to render the scene, contains culling code, etc."
--- @field FogScale number
--- @field FogStart number
--- @field FogEnd number
--- @field LightEnvironment LightEnvironmentInstance
--- @field AdditionalMaterialPassArray MaterialPassInstance
--- @field AdditionalMaterialPassCount integer
--- @field RejectedMaterialPasses integer
--- @field OverrideFlag RenderInfoOverrideFlags[]
--- @field OverrideFlagLevel RenderInfoOverrideFlags

--- @param camera CameraInstance
function INSTANCE:Renegade_RenderInfo( camera )
    self.Camera   = camera
    self.FogStart = 0.0
    self.FogEnd   = 0.0
    self.FogScale = 0.0
    self.LightEnvironment = nil
    self.AdditionalMaterialPassCount = 0
    self.RejectedMaterialPasses = 0
    self.OverrideFlagLevel = renderInfoOverrideFlagsEnum.RINFO_OVERRIDE_DEFAULT

    -- "Need to have one entry in the override flags stack, initialize it to default values."
    self.OverrideFlag = {}
    self.OverrideFlag[self.OverrideFlagLevel] = renderInfoOverrideFlagsEnum.RINFO_OVERRIDE_DEFAULT
end

function INSTANCE:_Renegade_RenderInfo()
    -- Empty in the original code
end

--- @param materialPass MaterialPassInstance
function INSTANCE:PushMaterialPass( materialPass )
	-- "Add to the end of the array"
    if self.AdditionalMaterialPassCount < STATIC.MAX_ADDITIONAL_MATERIAL_PASSES - 1 then
        self.AdditionalMaterialPassCount = self.AdditionalMaterialPassCount + 1
        self.AdditionalMaterialPassArray[self.AdditionalMaterialPassCount] = materialPass
    else
        self.RejectedMaterialPasses = self.RejectedMaterialPasses + 1
    end
end

function INSTANCE:PopMaterialPass()
    if self.RejectedMaterialPasses == 0 then
        -- "Remove from the end of the array"
        self.AdditionalMaterialPassArray[self.AdditionalMaterialPassCount] = nil
        self.AdditionalMaterialPassCount = self.AdditionalMaterialPassCount - 1
    else
        self.RejectedMaterialPasses = self.RejectedMaterialPasses - 1
    end
end

--- @return integer
function INSTANCE:AdditionalPassCount()
	return self.AdditionalMaterialPassCount
end

--- @param passIndex integer
--- @return MaterialPassInstance
function INSTANCE:PeekAdditionalPass( passIndex )
    return self.AdditionalMaterialPassArray[passIndex]
end

--- @param flag RenderInfoOverrideFlags
function INSTANCE:PushOverrideFlags( flag )
	-- "Copy to the end of the array"
    assert( self.OverrideFlagLevel < STATIC.MAX_OVERRIDE_FLAG_LEVEL )
    self.OverrideFlagLevel = self.OverrideFlagLevel + 1
    self.OverrideFlag[self.OverrideFlagLevel] = flag
end

function INSTANCE:PopOverrideFlags()
    assert( self.OverrideFlagLevel > 0 )
    self.OverrideFlagLevel = self.OverrideFlagLevel - 1
end

--- @return RenderInfoOverrideFlags
function INSTANCE:CurrentOverrideFlags()
	return self.OverrideFlag[self.OverrideFlagLevel]
end
