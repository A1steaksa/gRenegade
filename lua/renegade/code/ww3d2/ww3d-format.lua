-- Based on the structs and enums within Code/ww3d2/ww3dformat.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class WW3dFileFormatIds
local STATIC = CNC.CreateExport()

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass:New()

    --- "   
    --- Enum for possible surface formats. This is a small subset of the D3DFORMAT
    --- enum which lists the formats supported by DX8; we will add new members to
    --- this list as needed (keeping it in the same order as D3DFORMAT).  
    --- NOTE: Whenever this is changed, formconv.h/.cpp must be modified as well
    --- (that contains the code for converting between this and D3DFORMAT)..  
    --- The format names use the D3DFORMAT conventions:  
    ---      A = Alpha  
    ---      R = Red  
    ---      G = Green  
    ---      B = Blue  
    ---      X = Unused Bits  
    ---      P = Palette  
    ---      L = Luminance  
    ---      Further, the order of the pieces are from MSB first; hence
    ---      WW3D_FORMAT_A8L8 indicates that the high byte of this two byte
    ---      format is alpha.  
    --- "
    --- @enum WW3dFormat
    STATIC.WW3D_FORMAT = {
        WW3D_FORMAT_UNKNOWN  = enumBuilder:Set( 0 ),
        WW3D_FORMAT_R8G8B8   = enumBuilder:Next(),
        WW3D_FORMAT_A8R8G8B8 = enumBuilder:Next(),
        WW3D_FORMAT_X8R8G8B8 = enumBuilder:Next(),
        WW3D_FORMAT_R5G6B5   = enumBuilder:Next(),
        WW3D_FORMAT_X1R5G5B5 = enumBuilder:Next(),
        WW3D_FORMAT_A1R5G5B5 = enumBuilder:Next(),
        WW3D_FORMAT_A4R4G4B4 = enumBuilder:Next(),
        WW3D_FORMAT_R3G3B2   = enumBuilder:Next(),
        WW3D_FORMAT_A8       = enumBuilder:Next(),
        WW3D_FORMAT_A8R3G3B2 = enumBuilder:Next(),
        WW3D_FORMAT_X4R4G4B4 = enumBuilder:Next(),
        WW3D_FORMAT_A8P8     = enumBuilder:Next(),
        WW3D_FORMAT_P8       = enumBuilder:Next(),
        WW3D_FORMAT_L8       = enumBuilder:Next(),
        WW3D_FORMAT_A8L8     = enumBuilder:Next(),
        WW3D_FORMAT_A4L4     = enumBuilder:Next(),
        WW3D_FORMAT_U8V8     = enumBuilder:Next(), -- "Bumpmap"
        WW3D_FORMAT_L6V5U5   = enumBuilder:Next(), -- "Bumpmap"
        WW3D_FORMAT_X8L8V8U8 = enumBuilder:Next(), -- "Bumpmap"
        WW3D_FORMAT_DXT1     = enumBuilder:Next(),
        WW3D_FORMAT_DXT2     = enumBuilder:Next(),
        WW3D_FORMAT_DXT3     = enumBuilder:Next(),
        WW3D_FORMAT_DXT4     = enumBuilder:Next(),
        WW3D_FORMAT_DXT5     = enumBuilder:Next(),
        WW3D_FORMAT_COUNT    = enumBuilder:Next(), -- "Used only to determine number of surface formats"
    }
    local wW3dFormatEnum = STATIC.WW3D_FORMAT
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--- @class WW3dFileFormatIds
