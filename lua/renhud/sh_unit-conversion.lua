--- @class Renegade
local CNC = CNC_RENEGADE

--- A library for converting Renegade's unit space (meters) to Garry's Mod's unit space (Source Units)  
--- `1` Renegade Unit == `254` Source Units  
--- `1` Source Unit == `2.54` Renegade Units  
--- @class ConversionLib
local LIB = CNC.CreateExport()
local CLASS = "ConversionLib"
local isHotload = not table.IsEmpty( LIB )

--- 1 Source Unit is 2.54 Centimeters
LIB.SourceToCentimeters = 2.54

--- 1 Source Unit is 0.0254 Meters
LIB.SourceToMeters = LIB.SourceToCentimeters / 100

--- 1 Meter is 39.370 Source Units
LIB.MetersToSource = 1 / LIB.SourceToMeters

--- 1 Centimeter is 0.3937 Source Units
LIB.CentimetersToSource = 1 / LIB.SourceToCentimeters