-- Based on RadarMarkerClass within Code/Combat/radar.cpp/h

-- This should probably be a struct, but it has equality overrides so it gets to be a class.

--- @class Renegade
local CNC = CNC_RENEGADE

local STATIC, INSTANCE

--[[ Class Setup ]] do

    --- The instanced components of RadarMarker
    --- @class RadarMarkerInstance
    --- @field Static RadarMarker The static table for this instance's class
    INSTANCE = robustclass.Register( "Renegade_RadarMarker" )

    --- The static components of RadarMarker
    --- @class RadarMarker
    --- @field Instance RadarMarkerInstance The Metatable used by RadarMarkerInstance
    STATIC = CNC.CreateExport()

    STATIC.Instance = INSTANCE
    INSTANCE.Static = STATIC
    INSTANCE.IsRadarMarker = true
end


--[[ Static Functions and Variables ]] do
    local CLASS = "RadarMarker"

    --- [[ Public ]]

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


--[[ Instanced Functions and Variables ]] do
    local CLASS = "RadarMarkerInstance"

    --- [[ Public ]]

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
end