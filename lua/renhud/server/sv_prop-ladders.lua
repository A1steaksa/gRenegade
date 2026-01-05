-- This file adds ladders to Renegade props with models that contain them

--- @class Renegade
local CNC = CNC_RENEGADE


--#region Imports

    --- @type LadderBuilderClass
    local ladderBuilderClass = CNC.Import( "renhud/server/sv_ladder-builder.lua" )
--#endregion

--- A map of model names to a function that sets up their ladder(s)
--- @type table<string, fun( builder: LadderBuilderInstance, ent: Entity )>
local SetupFunctions = {
    -- Sniper tower
    ["models/cnc_renegade/buildings/sniper_tower.mdl"] = function( builder, ent )
        local ladderName = "sniper_tower_ladder"
        local topPos    = Vector( 73.5, 10, 200 )
        local bottomPos = Vector( 73.5, 10, 20 )
        builder:AddLadder( ladderName, bottomPos, topPos )

        local offset = 40

        builder:AddDismount( ladderName, "Top Front", topPos + Vector(       0, -offset, 0 ) )
        builder:AddDismount( ladderName, "Top Right", topPos + Vector( -offset, -offset, 0 ) )

        builder:AddDismount( ladderName, "Bottom Rear", bottomPos       + Vector(       0, offset, -2 ) )
        builder:AddDismount( ladderName, "Bottom Right", bottomPos      + Vector( -offset, offset, -2 ) )
        builder:AddDismount( ladderName, "Bottom Rear Right", bottomPos + Vector( -offset,      0, -2 ) )
    end,
}

-- Set up ladders for props with ladder setup functions defined
hook.Add( "PlayerSpawnedProp", "A1_Renegade_SetupPropLadders", function( ply, model, ent )
    -- Make sure it's one of the models we care about
    local setup = SetupFunctions[model]
    if not setup then return end

    timer.Simple( 0.1, function()
        if not IsValid( ent ) then return end
        -- Call its setup function
        local builder = ladderBuilderClass.New( ent )
        if not IsValid( ent ) then return end
        setup( builder, ent )
    end )
end )