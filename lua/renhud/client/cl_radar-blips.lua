--- @class Renegade
local CNC = CNC_RENEGADE

-- Library that handles converting Entities into radar blips and storing their related information 
--- @class RadarBlipsLib
local LIB = CNC.CreateExport()
local CLASS = "RadarBlipsLib"
local isHotload = not table.IsEmpty( LIB )


--#region Imports

    --- @type RadarManagerClass
    local radarManagerClass = CNC.Import( "renhud/client/code/combat/radar.lua" )

    --- @type InfoEntityLib
    local infoEntityLib = CNC.Import( "renhud/sh_info-entity.lua" )

    --- @type PlayerType
    local playerTypeClass = CNC.Import( "renhud/client/code/combat/player-type.lua" )
--#endregion


--#region Imported Enums

    local blipShapeTypeEnum = radarManagerClass.BLIP_SHAPE_TYPE
    local blipColorTypeEnum = radarManagerClass.BLIP_COLOR_TYPE
    local playerTypeEnum    = playerTypeClass.PLAYER_TYPE_ENUM
--#endregion


--[[ Blip Intensity ]] do

    --- @private
    --- The current intensity for an Entity's radar blip
    --- Renegade stores this on each Entity (Object) directly
    --- Values range from 0 to 1 (inclusive)
    --- @type table<Entity, number>
    LIB.RadarBlipIntensity = {}

    --- Retrieve an Entity's current radar blip intensity value
    --- @param ent Entity
    --- @return number intensity [Default: 1]
    function LIB.GetRadarBlipIntensity( ent )
        return LIB.RadarBlipIntensity[ent] or 1
    end

    --- Update an Entity's current radar blip intensity value
    --- @param ent Entity
    --- @param intensity number
    function LIB.SetRadarBlipIntensity( ent, intensity )
        LIB.RadarBlipIntensity[ent] = intensity
    end
end


--[[ Entity Blip Shape Type ]] do

    --- @private
    --- Pairs entities with the BlipShapeType overriding their default, if any
    --- @type table<Entity, BlipShapeType>
    LIB.BlipShapeTypeOverride = {}

    --- Retrives an Entity's default BlipShapeType or current BlipShapeType override
    --- @param ent Entity
    --- @return BlipShapeType
    function LIB.GetRadarBlipShapeType( ent )
        -- Use an override if one exists
        local override = LIB.BlipShapeTypeOverride[ent]
        if override then return override end

        -- If we don't have an override, try to determine their defaults

        if ent:IsVehicle() then
            return blipShapeTypeEnum.Vehicle
        end

        return blipShapeTypeEnum.Human
    end

    --- Overrides an Entity's default BlipShapeType
    --- @param ent Entity
    --- @param newBlipShapeType BlipShapeType
    function LIB.SetRadarBlipShapeType( ent, newBlipShapeType )
        LIB.BlipShapeTypeOverride[ent] = newBlipShapeType
    end

    --- Removes an Entity's BlipShapeType override
    --- @param ent Entity
    function LIB.ResetRadarBlipShapeType( ent )
        LIB.BlipShapeTypeOverride[ent] = nil
    end
end


--[[ Entity Blip Color Type ]] do

    --- @private
    --- Converts a PlayerTypeEnum into its default BlipColorType
    --- @type table<PlayerTypeEnum, BlipColorType>
    LIB.BlipColorTypeDefault = {
        [playerTypeEnum.Spectator] = blipColorTypeEnum.Neutral,
        [playerTypeEnum.Mutant   ] = blipColorTypeEnum.Mutant,
        [playerTypeEnum.Neutral  ] = blipColorTypeEnum.Neutral,
        [playerTypeEnum.Renegade ] = blipColorTypeEnum.Renegade,
        [playerTypeEnum.Nod      ] = blipColorTypeEnum.Nod,
        [playerTypeEnum.GDI      ] = blipColorTypeEnum.GDI,
        [playerTypeEnum.Combine  ] = blipColorTypeEnum.Combine,
        [playerTypeEnum.Rebels   ] = blipColorTypeEnum.Rebels,
        [playerTypeEnum.BlackMesa] = blipColorTypeEnum.BlackMesa,
        [playerTypeEnum.HECU     ] = blipColorTypeEnum.HECU,
        [playerTypeEnum.Aperture ] = blipColorTypeEnum.Aperture,
    }

    --- @private
    --- Pairs entities with the BlipColorType overriding their default, if any
    --- @type table<Entity, BlipColorType>
    LIB.BlipColorTypeOverride = {}

    --- Retrives an Entity's default BlipColorType or current BlipColorType override
    --- @param ent Entity
    --- @return BlipColorType
    function LIB.GetRadarBlipColorType( ent )
        -- Use an override if one exists
        local override = LIB.BlipColorTypeOverride[ent]
        if override then return override end

        -- If we don't have an override, use the default
        local team = infoEntityLib.GetEntityTeamToShow( ent )
        return LIB.BlipColorTypeDefault[team]
    end

    --- Overrides an Entity's default BlipColorType
    --- @param ent Entity
    --- @param newBlipColorType BlipColorType
    function LIB.SetRadarBlipColorType( ent, newBlipColorType )
        LIB.BlipColorTypeOverride[ent] = newBlipColorType
    end

    --- Removes an Entity's BlipColorType override
    --- @param ent Entity
    function LIB.ResetRadarBlipColorType( ent )
        LIB.BlipColorTypeOverride[ent] = nil
    end
end

