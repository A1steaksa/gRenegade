-- Based on the structs and enums within Code/ww3d2/w3d_file.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ObsoleteW3dFileIds
local STATIC = CNC.CreateExport()

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass:New()

    --- @enum ObsoleteW3dChunkTypes
    STATIC.OBSOLETE_W3D_CHUNK_TYPES = {
        W3D_CHUNK_MESH_HEADER               = 0x00000001,	-- "Header for a mesh"
        W3D_CHUNK_SURRENDER_NORMALS         = 0x00000004,	-- "Array of surrender normals (one per vertex as req. by surrender)"
        W3D_CHUNK_TEXCOORDS                 = 0x00000005,	-- "Array of texture coordinates"
        O_W3D_CHUNK_MATERIALS               = 0x00000006,	-- "Array of materials"
        O_W3D_CHUNK_TRIANGLES               = 0x00000007,	-- "Array of triangles "
        O_W3D_CHUNK_QUADRANGLES             = 0x00000008,	-- "Array of quads "
        O_W3D_CHUNK_SURRENDER_TRIANGLES     = 0x00000009,	-- "Array of surrender format tris	"
        O_W3D_CHUNK_POV_TRIANGLES           = 0x0000000A,	-- "POV format triangles "
        O_W3D_CHUNK_POV_QUADRANGLES         = 0x0000000B,	-- "POV format quads "
        W3D_CHUNK_VERTEX_COLORS             = 0x0000000D,	-- "Pre-set vertex coloring"
        W3D_CHUNK_DAMAGE                    = 0x0000000F,	-- "Mesh damage, new set of materials, vertex positions, vertex colors	"
            W3D_CHUNK_DAMAGE_HEADER         = 0x00000010,	-- "Header for the damage data, tells what is coming"
            W3D_CHUNK_DAMAGE_VERTICES       = 0x00000011,	-- "Array of modified vertices (W3dMeshDamageVertexStruct's)"
            W3D_CHUNK_DAMAGE_COLORS         = 0x00000012,	-- "Array of modified vert colors (W3dMeshDamageColorStruct's)"
            W3D_CHUNK_DAMAGE_MATERIALS      = 0x00000013,

        O_W3D_CHUNK_MATERIALS2              = 0x00000014,	-- "Array of version 2 materials (with animation frame counts)"
        W3D_CHUNK_MATERIALS3                = 0x00000015,	-- "Array of version 3 materials (all new surrender features supported)"
            W3D_CHUNK_MATERIAL3             = 0x00000016,	-- "Each version 3 material wrapped with this chunk ID"
                W3D_CHUNK_MATERIAL3_NAME    = 0x00000017,	-- "Name of the material (array of chars, null terminated)"
                W3D_CHUNK_MATERIAL3_INFO    = 0x00000018,	-- "Contains a W3dMaterial3Struct, general material info"
                W3D_CHUNK_MATERIAL3_DC_MAP  = 0x00000019,	-- "Wraps the following two chunks, diffuse color texture"
                    W3D_CHUNK_MAP3_FILENAME = 0x0000001A,	-- "Filename of the texture"
                    W3D_CHUNK_MAP3_INFO     = 0x0000001B,	-- "A W3dMap3Struct"
                W3D_CHUNK_MATERIAL3_DI_MAP  = 0x0000001C,	-- "Diffuse illimination map, same format as other maps"
                W3D_CHUNK_MATERIAL3_SC_MAP  = 0x0000001D,	-- "Specular color map, same format as other maps"
                W3D_CHUNK_MATERIAL3_SI_MAP  = 0x0000001E,	-- "Specular illumination map, same format as other maps"
        W3D_CHUNK_PER_TRI_MATERIALS         = 0x00000021,	-- "Multi-Mtl meshes - An array of uint16 material id's"
    }
    local obsoleteW3dChunkTypesEnum = STATIC.OBSOLETE_W3D_CHUNK_TYPES
--#endregion

--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--- @class ObsoleteW3dFileIds

STATIC.W3DMAPPING_UV = 0
STATIC.W3DMAPPING_ENVIRONMENT = 1