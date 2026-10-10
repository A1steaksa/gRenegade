-- Based on MaterialPassClass within Code/ww3d2/matpass.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MaterialPassClass
--- @field Instance MaterialPassInstance The metatable used by MaterialPassInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MaterialPassClass"

--- @class MaterialPassInstance
--- @field Static MaterialPassClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MaterialPass" )
INSTANCE.Class = "MaterialPassInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMaterialPass = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ShaderClass
	local shaderClass = CNC.Import( "code/ww3d2/shader.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MaterialPassClass
	--- @field _EnablePerPolygonCulling boolean

	STATIC.MAX_TEX_STAGES = 2
	STATIC._EnablePerPolygonCulling = true

    --- Creates a new MaterialPassInstance
    --- @return MaterialPassInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MaterialPass" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MaterialPassInstance, `false` otherwise
    function STATIC.IsMaterialPass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMaterialPass and true or false
    end

    typecheck.RegisterType( "MaterialPassInstance", STATIC.IsMaterialPass )

	--- @param onOff boolean
	function STATIC.EnablePerPolygonCulling( onOff )
		STATIC._EnablePerPolygonCulling = onOff
	end

	--- @return boolean
	function STATIC.IsPerPolygonCullingEnabled()
		return STATIC._EnablePerPolygonCulling
	end
end

--- "
--- This class wraps all of the data needed to describe an additional material pass for any object.  
--- The motivation for this class is to implement certain types of special effects.  
--- All data needed to apply the pass should be generated procedurally.  
--- Typically a vertex processor will be used to generate any needed u-v's or vertex colors.  
--- Alternatively, we could add the option to request to re-use the model's existing u-v's or vertex colors.  
--- "
--- @class MaterialPassInstance
--- @field Texture TextureInstance[]
--- @field Shader ShaderInstance
--- @field Material VertexMaterialInstance
--- @field _EnableOnTranslucentMeshes boolean
--- @field CullVolume OBBoxInstance

function INSTANCE:Renegade_MaterialPass()
	self.Shader = shaderClass.New( 0 )
	self.Material = nil
	self.CullVolume = nil
	self._EnableOnTranslucentMeshes = true

	self.Texture = {}
end

function INSTANCE:_Renegade_MaterialPass()
	self.Texture = nil
	self.Material = nil
end

--- "Plug our material settings into D3D"
function INSTANCE:InstallMaterials()
	typecheck.NotImplementedError()
end

--- "Set texture to use"
--- @param texture TextureInstance?
--- @param stage integer? [Default: `1`]
function INSTANCE:SetTexture( texture, stage )
	if stage == nil then stage = 1 end

	assert( stage >= 1 )
	assert( stage < STATIC.MAX_TEX_STAGES )

	self.Texture[stage] = texture
end

--- "Set the shader to use"
--- @param shader ShaderInstance "Shader for this material pass"
function INSTANCE:SetShader( shader )
	self.Shader = shader
	self.Shader:EnableFog( "MaterialPassClass" );
end

--- "Set vertex material to use"
--- @param material VertexMaterialInstance
function INSTANCE:SetMaterial( material )
	self.Material = material
end

--- "Get a pointer to the texture"
--- @param stage integer? [Default: `1`]
--- @return TextureInstance
function INSTANCE:GetTexture( stage )
	if stage == nil then stage = 1 end

	assert( stage >= 0 )
	assert( stage < STATIC.MAX_TEX_STAGES )

	return self.Texture[stage]
end

--- "Get the vertex material"
--- @return VertexMaterialInstance
function INSTANCE:GetMaterial()
	return self.Material
end

--- @param stage integer? [Default: `1`]
--- @return TextureInstance
function INSTANCE:PeekTexture( stage )
	if stage == nil then stage = 1 end

	return self.Texture[stage]
end

--- @return ShaderInstance
function INSTANCE:PeekShader()
	return self.Shader
end

--- @return VertexMaterialInstance
function INSTANCE:PeekMaterial()
	return self.Material
end

--- @param volume OBBoxInstance
function INSTANCE:SetCullVolume( volume )
	self.CullVolume = volume
end

--- @return OBBoxInstance
function INSTANCE:GetCullVolume()
	return self.CullVolume
end

--- @param onOff boolean
function INSTANCE:EnableOnTranslucentMeshes( onOff )
	self._EnableOnTranslucentMeshes = onOff
end

--- @return boolean
function INSTANCE:IsEnabledOnTranslucentMeshes()
	return self._EnableOnTranslucentMeshes
end
