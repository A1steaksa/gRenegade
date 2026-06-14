-- Based on MeshLoadContextClass within Code/ww3d2/meshmdlio.cpp

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MeshLoadContextClass
--- @field Instance MeshLoadContextInstance The metatable used by MeshLoadContextInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MeshLoadContextClass"

--- @class MeshLoadContextInstance
--- @field Static MeshLoadContextClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MeshLoadContext" )
INSTANCE.Class = "MeshLoadContextInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMeshLoadContext = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type MeshMaterialDescriptionClass
	local meshMaterialDescriptionClass = CNC.Import( "code/ww3d2/mesh-material-description.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MeshLoadContextClass

    --- Creates a new MeshLoadContextInstance
    --- @return MeshLoadContextInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MeshLoadContext" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MeshLoadContextInstance, `false` otherwise
    function STATIC.IsMeshLoadContext( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMeshLoadContext and true or false
    end

    typecheck.RegisterType( "MeshLoadContextInstance", STATIC.IsMeshLoadContext )
end

--- @class MeshLoadContextInstance
--- @field Header W3dMeshHeader3Struct
--- @field TextureCoords W3dTexCoordStruct
--- @field MaterialInfo W3dMaterialInfoStruct
--- @field PrelitChunkID integer
--- @field CurrentPass integer
--- @field CurrentTextureStage integer
--- @field LegacyMaterials LegacyMaterialInstance[]
--- @field Shaders ShaderInstance[]
--- @field VertexMaterials VertexMaterialInstance[]
--- @field VertexMaterialCrcs integer[]
--- @field Textures TextureInstance[]
--- @field AlternateMaterialDescription MeshMaterialDescriptionInstance 
--- @field TempUvArray Vector[]
--- @field LoadedDIG boolean "Record when we load the DIG chunk"

function INSTANCE:Renegade_MeshLoadContext()
	self.PrelitChunkID = 0xffffffff
	self.CurrentPass = 1
	self.CurrentTextureStage = 1
	self.TextureCoords = nil
	self.LoadedDIG = false

	self.LegacyMaterials = {}
	self.Shaders = {}
	self.VertexMaterials = {}
	self.Textures = {}
	self.TempUvArray = {}

	self.AlternateMaterialDescription = meshMaterialDescriptionClass.New()
end

function INSTANCE:_Renegade_MeshLoadContext()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTexcoordArray()
	typecheck.NotImplementedError()
end

--- "Adds a shader to the array"
--- @param shader ShaderInstance
--- @return integer # The index that the shader was stored under
function INSTANCE:AddShader( shader )
	local index = #self.Shaders + 1
	self.Shaders[index] = shader
	return index
end

--- "Adds a vertex material"
--- @param vertexMaterial VertexMaterialInstance
--- @return integer # The index that the material was stored under
function INSTANCE:AddVertexMaterial( vertexMaterial )
	local index = #self.VertexMaterials + 1
	self.VertexMaterials[index] = vertexMaterial
	return index
end

--- @param texture TextureInstance
--- @return integer # The index that the texture was stored under
function INSTANCE:AddTexture( texture )
	local index = #self.Textures + 1
	self.Textures[index] = texture
	return index
end

--- @param index integer
--- @return ShaderInstance
function INSTANCE:PeekShader( index )
	return self.Shaders[index]
end

--- @param index integer
--- @return VertexMaterialInstance
function INSTANCE:PeekVertexMaterial( index )
	return self.VertexMaterials[index]
end

--- @param index integer
--- @return TextureInstance
function INSTANCE:PeekTexture( index )
	return self.Textures[index]
end

--- @return integer
function INSTANCE:ShaderCount()
	return #self.Shaders
end

--- @return integer
function INSTANCE:VertexMaterialCount()
	return #self.VertexMaterials
end

--- @return integer
function INSTANCE:TextureCount()
	return #self.Textures
end

function INSTANCE:AddLegacyMaterial()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekLegacyShader()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekLegacyVertexMaterial()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekLegacyTexture()
	typecheck.NotImplementedError()
end

--- @param elementCount integer
--- @return Vector[]
function INSTANCE:GetTemporaryUvArray( elementCount )
	self.TempUvArray = {}
	return self.TempUvArray
end

function INSTANCE:NotifyLoadedDigChunk()
	typecheck.NotImplementedError()
end

function INSTANCE:AlreadyLoadedDig()
	typecheck.NotImplementedError()
end
