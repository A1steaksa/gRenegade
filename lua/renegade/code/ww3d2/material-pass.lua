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
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MaterialPassClass
	--- @field _EnablePerPolygonCulling boolean

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

	function STATIC.EnablePerPolygonCulling()
		typecheck.NotImplementedError()
	end

	function STATIC.IsPerPolygonCullingEnabled()
		typecheck.NotImplementedError()
	end
end


--- @class MaterialPassInstance
--- @field Texture TextureInstance
--- @field Shader ShaderInstance
--- @field Material VertexMaterialInstance
--- @field _EnableOnTranslucentMeshes boolean
--- @field CullVolume OBBoxInstance

function INSTANCE:Renegade_MaterialPass()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_MaterialPass()
	typecheck.NotImplementedError()
end

function INSTANCE:InstallMaterials()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTexture()
	typecheck.NotImplementedError()
end

function INSTANCE:SetShader()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMaterial()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTexture()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaterial()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekTexture()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekShader()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekMaterial()
	typecheck.NotImplementedError()
end

function INSTANCE:SetCullVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCullVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:EnableOnTranslucentMeshes()
	typecheck.NotImplementedError()
end

function INSTANCE:IsEnabledOnTranslucentMeshes()
	typecheck.NotImplementedError()
end
