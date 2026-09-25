-- Based on the functions within Code/ww3d2/formconv.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class FormatConverterLib
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "FormatConverterLib"

--- Apparently the official D3D enum values are made with this macro
--- @param chars string
--- @return integer
local function MAKEFOURCC( chars )
    local ch0, ch1, ch2, ch3 = string.byte( chars, 1, 4 )
    return bit.bor(
        ch0,
        bit.lshift( ch1,  8 ),
        bit.lshift( ch2, 16 ),
        bit.lshift( ch3, 24 )
    )
end

--#region Exported Enums

    --- @enum D3dFormat
    STATIC.D3D_FORMAT = {
        D3DFMT_UNKNOWN  = 0,

        D3DFMT_R8G8B8   = 20,
        D3DFMT_A8R8G8B8 = 21,
        D3DFMT_X8R8G8B8 = 22,
        D3DFMT_R5G6B5   = 23,
        D3DFMT_X1R5G5B5 = 24,
        D3DFMT_A1R5G5B5 = 25,
        D3DFMT_A4R4G4B4 = 26,
        D3DFMT_R3G3B2   = 27,
        D3DFMT_A8       = 28,
        D3DFMT_A8R3G3B2 = 29,
        D3DFMT_X4R4G4B4 = 30,

        D3DFMT_A8P8     = 40,
        D3DFMT_P8       = 41,

        D3DFMT_L8       = 50,
        D3DFMT_A8L8     = 51,
        D3DFMT_A4L4     = 52,

        D3DFMT_V8U8     = 60,
        D3DFMT_L6V5U5   = 61,
        D3DFMT_X8L8V8U8 = 62,

        D3DFMT_DXT1 = MAKEFOURCC( "DXT1" ),
        D3DFMT_DXT2 = MAKEFOURCC( "DXT2" ),
        D3DFMT_DXT3 = MAKEFOURCC( "DXT3" ),
        D3DFMT_DXT4 = MAKEFOURCC( "DXT4" ),
        D3DFMT_DXT5 = MAKEFOURCC( "DXT5" ),
    }
    local d3dFormatEnum = STATIC.D3D_FORMAT
--#endregion

--#region Imports

	--- @type WW3dFileFormatIds
	local wW3dFileFormatIds = CNC.Import( "code/ww3d2/ww3d-format.lua" )
--#endregion

--#region Imported Enums

	local wW3dFormatEnum = wW3dFileFormatIds.WW3D_FORMAT
--#endregion

--- "This file is used for conversions between D3DFORMAT and WW3DFormat"
--- @class FormatConverterLib
--- @field D3dToWW3d {[D3dFormat] : WW3dFormat}
--- @field _WW3dToSource {[WW3dFormat] : IMAGE_FORMAT }

STATIC.HIGHEST_SUPPORTED_D3DFORMAT = STATIC.D3D_FORMAT.D3DFMT_X8L8V8U8

-- Not all image formats have an enum built-in
STATIC.IMAGE_FORMAT_UNSUPPORTED = -50

STATIC.IMAGE_FORMAT_IA88 = 6
STATIC.IMAGE_FORMAT_A8   = 8
STATIC.IMAGE_FORMAT_DXT1 = 13
STATIC.IMAGE_FORMAT_DXT3 = 14
STATIC.IMAGE_FORMAT_DXT5 = 15

function STATIC.StaticConstructor()
    -- Populated during init function
    STATIC.D3dToWW3d = {}

    STATIC._WW3dToSource = {
        [wW3dFormatEnum.WW3D_FORMAT_UNKNOWN ] = IMAGE_FORMAT_DEFAULT,
        [wW3dFormatEnum.WW3D_FORMAT_R8G8B8  ] = IMAGE_FORMAT_RGB888,
        [wW3dFormatEnum.WW3D_FORMAT_A8R8G8B8] = STATIC.IMAGE_FORMAT_IA88,
        [wW3dFormatEnum.WW3D_FORMAT_X8R8G8B8] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_R5G6B5  ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_X1R5G5B5] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_A1R5G5B5] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_A4R4G4B4] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_R3G3B2  ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_A8      ] = STATIC.IMAGE_FORMAT_A8,
        [wW3dFormatEnum.WW3D_FORMAT_A8R3G3B2] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_X4R4G4B4] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_A8P8    ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_P8      ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_L8      ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_A8L8    ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_A4L4    ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_U8V8    ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_L6V5U5  ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_X8L8V8U8] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_DXT1    ] = STATIC.IMAGE_FORMAT_DXT1,
        [wW3dFormatEnum.WW3D_FORMAT_DXT2    ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_DXT3    ] = STATIC.IMAGE_FORMAT_DXT3,
        [wW3dFormatEnum.WW3D_FORMAT_DXT4    ] = STATIC.IMAGE_FORMAT_UNSUPPORTED,
        [wW3dFormatEnum.WW3D_FORMAT_DXT5    ] = STATIC.IMAGE_FORMAT_DXT5
    }
    STATIC._WW3dToSource[wW3dFormatEnum.WW3D_FORMAT_COUNT] = table.Count( STATIC._WW3dToSource )
end

--- @param d3dFormat D3dFormat  
--- @return WW3dFormat ww3dFormat
function STATIC.D3dFormatToWW3dFormat( d3dFormat )
    if d3dFormat == d3dFormatEnum.D3DFMT_DXT1 then return wW3dFormatEnum.WW3D_FORMAT_DXT1 end
    if d3dFormat == d3dFormatEnum.D3DFMT_DXT2 then return wW3dFormatEnum.WW3D_FORMAT_DXT2 end
    if d3dFormat == d3dFormatEnum.D3DFMT_DXT3 then return wW3dFormatEnum.WW3D_FORMAT_DXT3 end
    if d3dFormat == d3dFormatEnum.D3DFMT_DXT4 then return wW3dFormatEnum.WW3D_FORMAT_DXT4 end
    if d3dFormat == d3dFormatEnum.D3DFMT_DXT5 then return wW3dFormatEnum.WW3D_FORMAT_DXT5 end

    if d3dFormat > STATIC.HIGHEST_SUPPORTED_D3DFORMAT then
        return wW3dFormatEnum.WW3D_FORMAT_UNKNOWN
    else
        return STATIC.D3dToWW3d[d3dFormat]
    end
end

--- @param ww3dFormat WW3dFormat
--- @return IMAGE_FORMAT sourceFormat
function STATIC.WW3dToSource( ww3dFormat )
    return STATIC._WW3dToSource[ww3dFormat] or IMAGE_FORMAT_DEFAULT
end

function STATIC.InitD3dToWw3Conversion()
    for i = 0, STATIC.HIGHEST_SUPPORTED_D3DFORMAT do
        STATIC.D3dToWW3d[i] = wW3dFormatEnum.WW3D_FORMAT_UNKNOWN
    end

    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_R8G8B8  ] = wW3dFormatEnum.WW3D_FORMAT_R8G8B8
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_A8R8G8B8] = wW3dFormatEnum.WW3D_FORMAT_A8R8G8B8
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_X8R8G8B8] = wW3dFormatEnum.WW3D_FORMAT_X8R8G8B8
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_R5G6B5  ] = wW3dFormatEnum.WW3D_FORMAT_R5G6B5
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_X1R5G5B5] = wW3dFormatEnum.WW3D_FORMAT_X1R5G5B5
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_A1R5G5B5] = wW3dFormatEnum.WW3D_FORMAT_A1R5G5B5
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_A4R4G4B4] = wW3dFormatEnum.WW3D_FORMAT_A4R4G4B4
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_R3G3B2  ] = wW3dFormatEnum.WW3D_FORMAT_R3G3B2
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_A8      ] = wW3dFormatEnum.WW3D_FORMAT_A8
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_A8R3G3B2] = wW3dFormatEnum.WW3D_FORMAT_A8R3G3B2
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_X4R4G4B4] = wW3dFormatEnum.WW3D_FORMAT_X4R4G4B4
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_A8P8    ] = wW3dFormatEnum.WW3D_FORMAT_A8P8
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_P8      ] = wW3dFormatEnum.WW3D_FORMAT_P8
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_L8      ] = wW3dFormatEnum.WW3D_FORMAT_L8
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_A8L8    ] = wW3dFormatEnum.WW3D_FORMAT_A8L8
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_A4L4    ] = wW3dFormatEnum.WW3D_FORMAT_A4L4
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_V8U8    ] = wW3dFormatEnum.WW3D_FORMAT_U8V8     --- "Bumpmap"
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_L6V5U5  ] = wW3dFormatEnum.WW3D_FORMAT_L6V5U5   --- "Bumpmap"
    STATIC.D3dToWW3d[d3dFormatEnum.D3DFMT_X8L8V8U8] = wW3dFormatEnum.WW3D_FORMAT_X8L8V8U8 --- "Bumpmap"
end