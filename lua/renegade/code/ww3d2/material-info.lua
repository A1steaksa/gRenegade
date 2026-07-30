-- Based on MaterialInfoClass within Code/ww3d2/matinfo.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MaterialInfoClass
--- @field Instance MaterialInfoInstance The metatable used by MaterialInfoInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MaterialInfoClass"

--- @class MaterialInfoInstance
--- @field Static MaterialInfoClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MaterialInfo" )
INSTANCE.Class = "MaterialInfoInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMaterialInfo = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MaterialInfoClass

    --- Creates a new MaterialInfoInstance
    --- @return MaterialInfoInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MaterialInfo" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MaterialInfoInstance, `false` otherwise
    function STATIC.IsMaterialInfo( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMaterialInfo and true or false
    end

    typecheck.RegisterType( "MaterialInfoInstance", STATIC.IsMaterialInfo )
end


--- @class MaterialInfoInstance
--- @field VertexMaterials VertexMaterialInstance[]
--- @field Textures TextureInstance[]

--- @param src MaterialInfoInstance?
function INSTANCE:Renegade_MaterialInfo( src )
	if src ~= nil then
		typecheck.NotImplementedError()
	else
		self.VertexMaterials = {}
		self.Textures = {}
	end
end

function INSTANCE:_Renegade_MaterialInfo()
	self:Free()
end

function INSTANCE:Clone()
	typecheck.NotImplementedError()
end

function INSTANCE:Reset()
	self:Free()
end

--- @return integer
function INSTANCE:VertexMaterialCount()
	return #self.VertexMaterials
end

--- @return integer
function INSTANCE:TextureCount()
	return #self.Textures
end

--- @param vertexMaterial VertexMaterialInstance
function INSTANCE:AddVertexMaterial( vertexMaterial )
	local index = #self.VertexMaterials + 1
	self.VertexMaterials[index] = vertexMaterial
	return index
end

--- @param texture TextureInstance
--- @return integer
function INSTANCE:AddTexture( texture )
	local index = #self.Textures + 1
	self.Textures[index] = texture
	return index
end

function INSTANCE:GetVertexMaterialIndex()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTextureIndex()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVertexMaterial()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekVertexMaterial()
	typecheck.NotImplementedError()
end

function INSTANCE:ReplaceMaterial()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetTextureMappers()
	typecheck.NotImplementedError()
end

function INSTANCE:MakeVertexMaterialsUnique()
	typecheck.NotImplementedError()
end

function INSTANCE:HasTimeVariantTextureMappers()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTexture()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekTexture()
	typecheck.NotImplementedError()
end

function INSTANCE:ReplaceTexture()
	typecheck.NotImplementedError()
end

function INSTANCE:Free()
	self.VertexMaterials = {}
	self.Textures = {}
end
