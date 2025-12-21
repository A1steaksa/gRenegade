-- Based on RadarMarekrClass within Code/Combat/radar.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class RadarMarkerClass
--- @field instance RadarMarkerInstance The metatable used by RadarMarkerInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "RadarMarkerClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class RadarMarkerInstance
--- @field Static RadarMarkerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_RadarMarker" )
INSTANCE.Class = "RadarMarkerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsRadarMarker = true


--[[ Static Functions and Variables ]] do

    --- @class RadarMarker

    --- Creates a new RadarMarkerInstance
    --- @return RadarMarkerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_RadarMarker" )
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) RadarMarkerInstance, `false` otherwise
    function STATIC.IsRadarMarker( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsRadarMarker and true or false
    end

    typecheck.RegisterType( "RadarMarkerInstance", STATIC.IsRadarMarker )
end


--- @class RadarMarkerInstance
--- @field Id integer
--- @field Type BlipShapeType
--- @field Color BlipColorType
--- @field Position Vector
--- @field Intensity number

--- @param other any
function INSTANCE:__eq( other )
    -- This seems like lunatic code, but who am I to judge?
    return false
end