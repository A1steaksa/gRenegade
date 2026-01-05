-- Renegade Console Variables

local realmColor = SERVER and Color( 0, 0, 255 ) or Color( 255, 255, 0 )

Section.Print( realmColor, "[REN] Loading ConVars" )

local standardFlags     = { FCVAR_ARCHIVE }
local replicatedFlags   = { FCVAR_ARCHIVE, FCVAR_REPLICATED }

CreateConVar( "ren_hud_enabled", "1", replicatedFlags, "Should the HUD draw?", 0, 1 )

--[[ Info Entity / Entity Targeting ]] do

    if SERVER then
        CreateConVar( "ren_entityinfo_update_delay", "0.250", standardFlags, "How frequently, in seconds between updates, should the server send updated InfoEntity data to clients?" )
    end

    CreateConVar( "ren_entityinfo_enabled",    "1",   replicatedFlags, "Should target info draw?", 0, 1 )
    CreateConVar( "ren_entityinfo_max_length", "500", replicatedFlags, "The maximum distance, in Source units, that an Entity can be from the camera and still be targeted", 1 )
end

--[[ Directional Damage Indicators ]] do
    CreateConVar( "ren_damageindicator_enabled",          "1", replicatedFlags, "Should damage direction indicators draw?", 0, 1 )
    CreateConVar( "ren_damageindicator_vehicles_enabled", "0", replicatedFlags, "Should damage direction indicators be shown for damage taken by the vehicle the player is in?", 0, 1 )
end

--[[ Weapon Display / Ammo Counts ]] do
    CreateConVar( "ren_weaponinfo_center_ammo_display_time", "2", replicatedFlags, "How long, in seconds, should the center-right ammo counter be displayed when it appears?" )
end

--[[ Radar ]] do
    CreateConVar( "ren_radar_range", "2450", replicatedFlags, "The maximum distance of the radar, in Source units" )
end