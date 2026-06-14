-- Based on VertexMaterialClass within Code/ww3d2/vertmaterial.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class VertexMaterialClass
--- @field Instance VertexMaterialInstance The metatable used by VertexMaterialInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "VertexMaterialClass"

--- @class VertexMaterialInstance
--- @field Static VertexMaterialClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_VertexMaterial" )
INSTANCE.Class = "VertexMaterialInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsVertexMaterial = true

--#region Exported Enums

    --- @type ObsoleteW3dFileIds
	local obsoleteW3dFileIds = CNC.Import( "code/ww3d2/w3d-obsolete.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum MappingType
    STATIC.MAPPING_TYPE = {
        MAPPING_NONE        = -1,                                        -- "No mapping needed"
        MAPPING_UV          = obsoleteW3dFileIds.W3DMAPPING_UV,          -- "Default, use the u-v values in the model"
        MAPPING_ENVIRONMENT = obsoleteW3dFileIds.W3DMAPPING_ENVIRONMENT, -- "Use the environment mapper"
    }
    local mappingTypeEnum = STATIC.MAPPING_TYPE

    --- @enum FlagsType
    STATIC.FLAGS_TYPE = {
        DEPTH_CUE                = enumBuilder:Set( 0 ), -- "Enable depth cueing (default = false)"
        DEPTH_CUE_TO_ALPHA       = enumBuilder:Next(),
        COPY_SPECULAR_TO_DIFFUSE = enumBuilder:Next(),
    }
    local flagsTypeEnum = STATIC.FLAGS_TYPE

    --- @enum ColorSourceType
    STATIC.COLOR_SOURCE_TYPE = {
        MATERIAL = enumBuilder:Set( 0 ), -- "D3DMCS_MATERIAL - The color source should be taken from the material setting"
        COLOR1 	 = enumBuilder:Next(),          -- "D3DMCS_COLOR1 - The color should be taken from per-vertex color array 1 (aka D3DFVF_DIFFUSE)"
        COLOR2 	 = enumBuilder:Next(),			-- "D3DMCS_COLOR2 - The color should be taken from per-vertex color array 2 (aka D3DFVF_SPECULAR)"
    }
    local colorSourceTypeEnum = STATIC.COLOR_SOURCE_TYPE

    --- @enum PresetType
    STATIC.PRESET_TYPE = {
        PRELIT_DIFFUSE   = enumBuilder:Set( 0 ),
        PRELIT_NODIFFUSE = enumBuilder:Next(),
        PRESET_COUNT 	 = enumBuilder:Next(),
    }
    local presetTypeEnum = STATIC.PRESET_TYPE
--#endregion

--#region Imports

	--- @type MeshBuilderClass
	local meshBuilderClass = CNC.Import( "code/ww3d2/mesh-builder.lua" )

	--- @type WW3dErrorTypes
	local wW3dErrorTypes = CNC.Import( "code/ww3d2/w3d-errors.lua" )

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )
--#endregion

--#region Imported Enums

	local wW3dErrorTypeEnum = wW3dErrorTypes.WW3D_ERROR_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class VertexMaterialClass
		--- @field Presets any

    --- Creates a new VertexMaterialInstance
    --- @param src VertexMaterialInstance?
    --- @return VertexMaterialInstance
    function STATIC.New( src )
        return robustclass.New( "Renegade_VertexMaterial", src )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) VertexMaterialInstance, `false` otherwise
    function STATIC.IsVertexMaterial( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsVertexMaterial and true or false
    end

    typecheck.RegisterType( "VertexMaterialInstance", STATIC.IsVertexMaterial )

	function STATIC.Init()
		typecheck.NotImplementedError()
	end

	function STATIC.Shutdown()
		typecheck.NotImplementedError()
	end

	function STATIC.GetPreset()
		typecheck.NotImplementedError()
	end

	function STATIC.ApplyNull()
		typecheck.NotImplementedError()
	end
end


--- @class VertexMaterialInstance
--- @field Material IMaterial
--- @field Flags integer
--- @field AmbientColorSource ColorSourceType
--- @field EmissiveColorSource ColorSourceType
--- @field DiffuseColorSource ColorSourceType
--- @field Name string
--- @field Mapper TextureMapperInstance[]
--- @field UvSource integer[]
--- @field UseLighting boolean
--- @field UniqueID integer
--- @field Crc integer
--- @field CrcDirty boolean

--- @param src VertexMaterialInstance?
function INSTANCE:Renegade_VertexMaterial( src )
    -- ()
    if src == nil then
        self.Material = nil
        self.Flags = 0
        self.AmbientColorSource  = colorSourceTypeEnum.MATERIAL
        self.EmissiveColorSource = colorSourceTypeEnum.MATERIAL
        self.DiffuseColorSource  = colorSourceTypeEnum.MATERIAL
        self.UseLighting = false
        self.UniqueID = 0
        self.CrcDirty = true

        self.Mapper = {}
        self.UvSource = {}

        for i = 1, meshBuilderClass.MAX_STAGES do
            self.Mapper[i] = nil
            self.UvSource[i] = i
        end

        -- Omitted setting the Material field to a "D3DMATERIAL8"
        -- self:SetAmbient( 1.0, 1.0, 1.0 )
        -- self:SetDiffuse( 1.0, 1.0, 1.0 )

        -- self:SetOpacity( 1.0 )

    -- ( src: VertexMaterialInstance )
    else
        typecheck.AssertArgType( self.Class, 1, src, "VertexMaterialInstance" )
        --- @cast src VertexMaterialInstance

        self.Material = nil
        self.Flags = src.Flags
        self.AmbientColorSource = src.AmbientColorSource
        self.EmissiveColorSource = src.EmissiveColorSource
        self.DiffuseColorSource = src.DiffuseColorSource
        self.UseLighting = src.UseLighting
        self.Name = src.Name
        self.UniqueID = src.UniqueID
        self.CrcDirty = true

        for i = 1, meshBuilderClass.MAX_STAGES do
            self.Mapper[i] = nil
            if src.Mapper[i] then
                local mapper = src.Mapper[i]:Clone()
                self:SetMapper( mapper, i )
            end

            self.UvSource[i] = src.UvSource[i]
        end

        self.Material = src.Material
    end
end

function INSTANCE:_Renegade_VertexMaterial()
	typecheck.NotImplementedError()
end

function INSTANCE:Clone()
	typecheck.NotImplementedError()
end

--- @param name string
function INSTANCE:SetName( name )
    self.Name = name

    -- Trying creating the material here
    self.Material = Material( "Renegade_VertexMaterial_" .. self.Name )
end

--- @return string
function INSTANCE:GetName()
	return self.Name
end

--- "Control over the material flags"
--- @param flag FlagsType
--- @param onOff boolean
function INSTANCE:SetFlag( flag, onOff )
    self.CrcDirty = true
    if onOff then
        self.Flags = bit.bor( self.Flags, bit.lshift( 1, flag ) )
    else
        self.Flags = bit.band( self.Flags, bit.bnot( bit.lshift( 1, flag ) ) )
    end
end

function INSTANCE:GetFlag()
	typecheck.NotImplementedError()
end


--[[ Basic Material Properties ]] do

    --- @return number
    function INSTANCE:GetShininess()
        typecheck.NotImplementedError()
    end

    --- @param shine number
    function INSTANCE:SetShininess( shine )
        self.Material:SetInt( "$phong", 1 )
        self.Material:SetFloat( "$phongboost", shine )
    end

    --- @return number
    function INSTANCE:GetOpacity()
        typecheck.NotImplementedError()
    end

    --- @param opacity number
    function INSTANCE:SetOpacity( opacity )
        self.Material:SetInt( "$alpha", opacity )
    end

    --- @return Color
    function INSTANCE:GetAmbient()
        typecheck.NotImplementedError()
    end

    --- @param r number
    --- @param g number
    --- @param b number
    --- @overload fun( self: VertexMaterialInstance, color: Color )
    function INSTANCE:SetAmbient( r, g, b )
        typecheck.AssertArgType( self.Class, 1, r, { "number", "Color" } )

        if typecheck.IsOfType( r, "Color" ) then
            local color = r --[[@as Color]]
            r = color.r
            g = color.g
            b = color.b
        else
            typecheck.AssertArgType( self.Class, 2, g, "number" )
            typecheck.AssertArgType( self.Class, 3, b, "number" )
        end

        self.Material:SetInt( "$selfillum", 1 )
        self.Material:SetVector( "$selfillumtint", Vector( r, g, b ) )
    end

    --- @return Color
    function INSTANCE:GetDiffuse()
        typecheck.NotImplementedError()
    end

    --- @param r number
    --- @param g number
    --- @param b number
    --- @overload fun( self: VertexMaterialInstance, color: Color )
    function INSTANCE:SetDiffuse( r, g, b )
        typecheck.AssertArgType( self.Class, 1, r, { "number", "Color" } )

        if typecheck.IsOfType( r, "Color" ) then
            local color = r --[[@as Color]]
            r = color.r
            g = color.g
            b = color.b
        else
            typecheck.AssertArgType( self.Class, 2, g, "number" )
            typecheck.AssertArgType( self.Class, 3, b, "number" )
        end

        self.Material:SetInt( "$allowdiffusemodulation", 1 )
        self.Material:SetVector( "$color2", Vector( r, g, b ) )
    end

    --- @return Color
    function INSTANCE:GetSpecular()
        typecheck.NotImplementedError()
    end

    --- @param r number
    --- @param g number
    --- @param b number
    --- @overload fun( self: VertexMaterialInstance, color: Color )
    function INSTANCE:SetSpecular( r, g, b )
        typecheck.AssertArgType( self.Class, 1, r, { "number", "Color" } )

        if typecheck.IsOfType( r, "Color" ) then
            local color = r --[[@as Color]]
            r = color.r
            g = color.g
            b = color.b
        else
            typecheck.AssertArgType( self.Class, 2, g, "number" )
            typecheck.AssertArgType( self.Class, 3, b, "number" )
        end

        self.Material:SetInt( "$phong", 1 )
        self.Material:SetVector( "$phongtint", Vector( r, g, b ) )
    end

    --- @return Color
    function INSTANCE:GetEmissive()
        typecheck.NotImplementedError()
    end

    --- @param r number
    --- @param g number
    --- @param b number
    --- @overload fun( self: VertexMaterialInstance, color: Color )
    function INSTANCE:SetEmissive(r, g, b )
        typecheck.AssertArgType( self.Class, 1, r, { "number", "Color" } )

        if typecheck.IsOfType( r, "Color" ) then
            local color = r --[[@as Color]]
            r = color.r
            g = color.g
            b = color.b
        else
            typecheck.AssertArgType( self.Class, 2, g, "number" )
            typecheck.AssertArgType( self.Class, 3, b, "number" )
        end

        self.Material:SetInt( "$emissiveblendenabled", 1 )
        self.Material:SetVector( "$emissiveblendtint", Vector( r, g, b ) )
    end

    --- @param lighting boolean
    function INSTANCE:SetLighting( lighting )
        self.CrcDirty = true
        self.UseLighting = lighting
    end

    --- @return boolean
    function INSTANCE:GetLighting()
        return self.UseLighting
    end
end


--[[ Color Source Control ]] do
    -- "  
    -- Note that if you set one of the sources to be one of the arrays,
    -- then the setting in the material is ignored.  (i.e. if you set the
    -- diffuse source to array0, then the diffulse color set into the vertex
    -- material is ignored.  
    -- "  

    --- @param source ColorSourceType
    function INSTANCE:SetAmbientColorSource( source )
        self.CrcDirty = true
        if source == colorSourceTypeEnum.COLOR1 then
            self.AmbientColorSource = colorSourceTypeEnum.COLOR1
        elseif source == colorSourceTypeEnum.COLOR2 then
            self.AmbientColorSource = colorSourceTypeEnum.COLOR2
        else
            self.AmbientColorSource = colorSourceTypeEnum.MATERIAL
        end
    end

    --- @return ColorSourceType
    function INSTANCE:GetAmbientColorSource()
        local source = self.AmbientColorSource
        if source == colorSourceTypeEnum.COLOR1 then
            return colorSourceTypeEnum.COLOR1
        elseif source == colorSourceTypeEnum.COLOR2 then
            return colorSourceTypeEnum.COLOR2
        else
            return colorSourceTypeEnum.MATERIAL
        end
    end

    --- @param source ColorSourceType
    function INSTANCE:SetEmissiveColorSource( source )
        self.CrcDirty = true
        if source == colorSourceTypeEnum.COLOR1 then
            self.EmissiveColorSource = colorSourceTypeEnum.COLOR1
        elseif source == colorSourceTypeEnum.COLOR2 then
            self.EmissiveColorSource = colorSourceTypeEnum.COLOR2
        else
            self.EmissiveColorSource = colorSourceTypeEnum.MATERIAL
        end
    end

    --- @return ColorSourceType
    function INSTANCE:GetEmissiveColorSource()
        local source = self.EmissiveColorSource
        if source == colorSourceTypeEnum.COLOR1 then
            return colorSourceTypeEnum.COLOR1
        elseif source == colorSourceTypeEnum.COLOR2 then
            return colorSourceTypeEnum.COLOR2
        else
            return colorSourceTypeEnum.MATERIAL
        end
    end

    --- @param source ColorSourceType
    function INSTANCE:SetDiffuseColorSource( source )
        self.CrcDirty = true
        if source == colorSourceTypeEnum.COLOR1 then
            self.DiffuseColorSource = colorSourceTypeEnum.COLOR1
        elseif source == colorSourceTypeEnum.COLOR2 then
            self.DiffuseColorSource = colorSourceTypeEnum.COLOR2
        else
            self.DiffuseColorSource = colorSourceTypeEnum.MATERIAL
        end
    end

    --- @return ColorSourceType
    function INSTANCE:GetDiffuseColorSource()
        local source = self.DiffuseColorSource
        if source == colorSourceTypeEnum.COLOR1 then
            return colorSourceTypeEnum.COLOR1
        elseif source == colorSourceTypeEnum.COLOR2 then
            return colorSourceTypeEnum.COLOR2
        else
            return colorSourceTypeEnum.MATERIAL
        end
    end
end


--[[ UV Source Control ]] do

    -- "  
    -- The DX8 FVF can support up to 8 uv-arrays.  The vertex material
    -- can/must be configured to index to the uv-arrays that you want to
    -- use for the texture stages.
    -- "  

    --- @param stage integer
    --- @param arrayIndex integer
    function INSTANCE:SetUvSource( stage, arrayIndex )
        self.CrcDirty = true
        self.UvSource[stage] = arrayIndex
    end

    --- @param stage integer
    --- @return integer
    function INSTANCE:GetUvSource( stage )
        return self.UvSource[stage]
    end
end


--[[ Mapper Control ]] do

    --- @param mapper TextureMapperInstance
    --- @param stage integer
    function INSTANCE:SetMapper( mapper, stage )
        self.CrcDirty = true
        self.Mapper[stage] = mapper
    end

    function INSTANCE:GetMapper()
        typecheck.NotImplementedError()
    end

    function INSTANCE:PeekMapper()
        typecheck.NotImplementedError()
    end

    function INSTANCE:ResetMappers()
        typecheck.NotImplementedError()
    end
end


--[[ Loading and Saving to W3D Files ]] do

    --- @param cload ChunkLoadInstance
    --- @return WW3dErrorType
    function INSTANCE:LoadW3d( cload )
        --- @type W3dVertexMaterialStruct
        local vertexMaterial
        local hasName = false

        local mapping0ArgBuffer
        local mapping1ArgBuffer
        local mapping0ArgLen = 0
        local mapping1ArgLen = 0

        --- @type string
        local name

        local ids = w3dFileIds.W3D_CHUNK_TYPE
        while cload:OpenChunk() do
            local chunkId = cload:CurChunkId()
            local chunkLength = cload:CurChunkLength()

            if chunkId == ids.W3D_CHUNK_VERTEX_MATERIAL_NAME then
                local readByteCount, readBytes = cload:Read( chunkLength )
                if readByteCount ~= chunkLength then
                    return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
                end
                name = readBytes --[[@as string]]
                hasName = true

            elseif chunkId == ids.W3D_CHUNK_VERTEX_MATERIAL_INFO then
                local struct = cload:ReadStruct( "W3dVertexMaterialStruct" )
                if struct == nil then
                    return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
                end
                vertexMaterial = struct

            elseif chunkId == ids.W3D_CHUNK_VERTEX_MAPPER_ARGS0 then
                mapping0ArgLen = chunkLength
                local readByteCount, readBytes = cload:Read( mapping0ArgLen )
                if readByteCount ~= mapping0ArgLen then
                    return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
                end
                mapping0ArgBuffer = readBytes --[[@as string]]

            elseif chunkId == ids.W3D_CHUNK_VERTEX_MAPPER_ARGS1 then
                mapping1ArgLen = chunkLength
                local readByteCount, readBytes = cload:Read( mapping1ArgLen )
                if readByteCount ~= mapping1ArgLen then
                    return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
                end
                mapping1ArgBuffer = readBytes --[[@as string]]

            else
                section.Error( "Hit unknown chunk ID '", chunkId, "'" )
            end
            cload:CloseChunk()
        end

        if hasName then
            self:SetName( name )
        end

        -- "Read an INIClass from the mapping argument buffer - this will be used
        -- to initialize any special mappers used.
        local mapping0ArgIni
        if mapping0ArgBuffer then
            typecheck.NotImplementedError()
        end

        local mapping1ArgIni
        if mapping1ArgBuffer then
            typecheck.NotImplementedError()
        end

        if bit.band( vertexMaterial.Attributes, w3dFileIds.W3DVERTMAT_USE_DEPTH_CUE ) == 1 then
            self:SetFlag( flagsTypeEnum.DEPTH_CUE, true )
        end

        if bit.band( vertexMaterial.Attributes, w3dFileIds.W3DVERTMAT_COPY_SPECULAR_TO_DIFFUSE ) == 1 then
            self:SetFlag( flagsTypeEnum.COPY_SPECULAR_TO_DIFFUSE, true )
        end

        -- "  
        -- Set up the vertex mapper.  
        -- If it is one of the simple ones, set the pointer to one of the global instances.  
        -- "  
        local mapping = bit.band( vertexMaterial.Attributes, w3dFileIds.W3DVERTMAT_STAGE1_MAPPING_MASK )
        if mapping == w3dFileIds.W3DVERTMAT_STAGE1_MAPPING_UV then
            -- Empty in the original code
        else
            typecheck.NotImplementedError()
        end

        -- "Same setup for stage 1's mapper."
        mapping = bit.band( vertexMaterial.Attributes, w3dFileIds.W3DVERTMAT_STAGE1_MAPPING_MASK )
        if mapping == w3dFileIds.W3DVERTMAT_STAGE1_MAPPING_UV then
            -- Empty in the original code
        else
            typecheck.NotImplementedError()
        end

        local temp
        local ambient = vertexMaterial.Ambient
        temp = Color( ambient.R, ambient.G, ambient.B )
        self:SetAmbient( temp )

        local diffuse = vertexMaterial.Diffuse
        temp = Color( diffuse.R, diffuse.G, diffuse.B )
        self:SetDiffuse( temp )

        local specular = vertexMaterial.Specular
        temp = Color( specular.R, specular.G, specular.B )
        self:SetSpecular( temp )

        local emissive = vertexMaterial.Emissive
        temp = Color( emissive.R, emissive.G, emissive.B )
        self:SetEmissive( temp )

        self:SetShininess( vertexMaterial.Shininess )
        self:SetOpacity( vertexMaterial.Opacity )

        return wW3dErrorTypeEnum.WW3D_ERROR_OK
    end

    function INSTANCE:SaveW3d()
        typecheck.NotImplementedError()
    end
end


function INSTANCE:InitFromMaterial3()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCrc()
	typecheck.NotImplementedError()
end

function INSTANCE:DoMappersNeedNormals()
	typecheck.NotImplementedError()
end

function INSTANCE:AreMappersTimeVariant()
	typecheck.NotImplementedError()
end

function INSTANCE:MakeUnique()
	typecheck.NotImplementedError()
end

function INSTANCE:Apply()
	typecheck.NotImplementedError()
end

function INSTANCE:ComputeCrc()
	typecheck.NotImplementedError()
end
