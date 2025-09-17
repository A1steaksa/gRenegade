-- Based mostly on Code/Combat/globalsettings.h and Code/Combat/globalsettings.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GlobalSettingsClass
local STATIC = CNC.CreateExport()
local CLASS = "GlobalSettings"

STATIC.Colors = {}

--[[ Teams ]] do

    -- Original teams
    STATIC.Colors.Nod                = Color( 255,   0,   0 )
    STATIC.Colors.GDI                = Color( 255, 255,   0 )
    STATIC.Colors.Neutral            = Color( 255, 255, 255 )
    STATIC.Colors.Mutant             = Color(   0, 255,   0 )
    STATIC.Colors.Renegade           = Color(   0,   0, 255 )

    -- New teams
    STATIC.Colors.Combine            = Color( 198, 131,  10 )
    STATIC.Colors.Rebels             = Color( 251, 127,  12 )
    STATIC.Colors.BlackMesa          = Color( 251, 127,  12 )
    STATIC.Colors.HECU               = Color(  15,   0, 231 )
    STATIC.Colors.Aperture           = Color(   0, 153, 254 )
end

--[[ Objectives ]] do

    STATIC.Colors.PrimaryObjective   = Color(   0, 255,   0 )
    STATIC.Colors.SecondaryObjective = Color(   0,   0, 255 )
    STATIC.Colors.TertiaryObjective  = Color( 255,   0, 255 )
end


--[[ Health UI ]] do

    STATIC.Colors.HealthHigh         = Color(   0, 255,   0 )
    STATIC.Colors.HealthMed          = Color( 255, 255,   0 )
    STATIC.Colors.HealthLow          = Color( 255,   0,   0 )
end

--[[ Relationship ]] do

    STATIC.Colors.Enemy              = Color( 255,   0,   0 )
    STATIC.Colors.Friendly           = Color(   0, 255,   0 )
    STATIC.Colors.NoRelation         = Color( 255, 255, 255 )
end

--[[ Reticle ]] do

    STATIC.Colors.ReticleBusy        = Color( 255, 255,   0 )
end
