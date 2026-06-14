-- Based on the enum within Code/ww3d2/w3derr.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class WW3dErrorTypes
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "WW3dErrorTypes"

--- @class WW3dErrorTypes

--#region Exported Enums

--- @type EnumBuilderClass
local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

local enumBuilder = enumBuilderClass.New()

--- @enum WW3dErrorType
STATIC.WW3D_ERROR_TYPE = {
    WW3D_ERROR_OK				              = enumBuilder:Set( 0 ),
    WW3D_ERROR_GENERIC                        = enumBuilder:Next(),
    WW3D_ERROR_LOAD_FAILED                    = enumBuilder:Next(),
    WW3D_ERROR_SAVE_FAILED                    = enumBuilder:Next(),
    WW3D_ERROR_WINDOW_NOT_OPEN                = enumBuilder:Next(),
    WW3D_ERROR_INITIALIZATION_FAILED          = enumBuilder:Next(),
    WW3D_ERROR_DIRECTX8_INITIALIZATION_FAILED = enumBuilder:Next()
}
local wW3dErrorTypeEnum = STATIC.WW3D_ERROR_TYPE
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion
