-- Based on RadarManager within Code/Combat/radar.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class RadarManagerClass
local STATIC = CNC.CreateExport()
local CLASS = "RadarManager"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums

    --- "Radar mode in multiplayer"
    --- @enum RadarMode
    STATIC.RADAR_MODE = {
        Nobody      = 0,
        Teammates   = 1,
        All         = 2
    }
    local radarModeEnum = STATIC.RADAR_MODE

    --- @enum BlipShapeType
    STATIC.BLIP_SHAPE_TYPE = {
        -- Blip Shapes
        None            = 0,
        Human           = 1,
        Vehicle         = 2,
        Stationary      = 3,
        Objective       = 4,
        BlipShapeCount  = 5,

        -- Misc. Blips
        Bracket         = 5,
        Sweep           = 6,
        BlipTypeCount   = 7
    }
    local blipShapeTypeEnum = STATIC.BLIP_SHAPE_TYPE

    --- @enum BlipColorType
    STATIC.BLIP_COLOR_TYPE = {
        Nod                 = 0,
        GDI                 = 1,
        Neutral             = 2,
        Mutant              = 3,
        Renegade            = 4,
        PrimaryObjective    = 5, -- Code in code/combat/objective.lua relies on this specific value
        SecondaryObjective  = 6,
        TertiaryObjective   = 7,
        Combine             = 8,
        Rebels              = 9,
        BlackMesa           = 10,
        HECU                = 11,
        Aperture            = 12
    }
    local blipColorTypeEnum = STATIC.BLIP_COLOR_TYPE

    --- @enum Direction
    STATIC.DIRECTION = {
        North     = 0,
        NorthEast = 1,
        East      = 2,
        SouthEast = 3,
        South     = 4,
        SouthWest = 5,
        West      = 6,
        NorthWest = 7
    }
    local directionEnum = STATIC.DIRECTION
--#endregion

-- Don't bother with the rest of this class if we're being executed on the server
if not CLIENT then return end

--#region Imports

    --- @type RectClass
    local rectClass = CNC.Import( "renhud/client/code/wwmath/rect.lua" )

    --- @type Render2dClass
    local render2dClass = CNC.Import( "renhud/client/code/ww3d2/render-2d.lua" )

    --- @type Render2dTextClass
    local render2dTextClass = CNC.Import( "renhud/client/code/ww3d2/render-2d-text.lua" )

    --- @type GlobalSettingsClass
    local globalSettingsClass = CNC.Import( "renhud/client/code/combat/global-settings.lua" )

    --- @type StyleManagerClass
    local styleManagerClass = CNC.Import( "renhud/client/code/wwui/style-manager.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "renhud/client/code/combat/combat-manager.lua" )

    --- @type WWMathClass
    local wWMathClass = CNC.Import( "renhud/client/code/wwmath/wwmath.lua" )

    --- @type RadarBlipsLib
    local radarBlipsLib = CNC.Import( "renhud/client/cl_radar-blips.lua" )

    --- @type ConversionLib
    local conversionLib = CNC.Import( "renhud/sh_conversion.lua" )

    --- @type CommonBridgeClass
    local commonBridge = CNC.Import( "renhud/client/bridges/common.lua" )

    --- @type SmartGameObjectsBridge
    local smartGameObjectsBridge = CNC.Import( "renhud/client/bridges/smart-game-objects.lua" )

    --- @type PlayerType
    local playerType = CNC.Import( "renhud/client/code/combat/player-type.lua" )

    --- @type ObjectiveManagerClass
    local objectiveManagerClass = CNC.Import( "renhud/client/code/combat/objective-manager.lua" )

    --- @type TranslateDbClass
    local translateDbClass = CNC.Import( "renhud/client/code/wwtranslatedb/translatedb.lua" )
--#endregion


--#region Imported Enums
    local objectiveStatusEnum = objectiveManagerClass.OBJECTIVE_STATUS
    local playerTypeEnum      = playerType.PLAYER_TYPE_ENUM
    local fontStyleEnum       = styleManagerClass.FONT_STYLE
--#endregion

--- @class RadarManagerClass
--- @field private Markers table<integer, RadarMarkerInstance>
--- @field private Renderer Render2dInstance
--- @field private CompassRenderers Render2dTextInstance[]
--- @field private CurrentCompassRendererIndex integer
--- @field private BlipColors Color[]
--- @field private BracketEntity Entity
--- @field private BlipUv RectInstance[]
--- @field private _IsHidden boolean
--- @field private HiddenTimer number
--- @field private RadarMode RadarMode
--- @field private RadarIntensity number
--- @field private RadarColor Color
--- @field private RadarTransformationMatrix Matrix3dInstance

STATIC.BracketEntity = NULL
STATIC._IsHidden = false
STATIC.HiddenTimer = 0
STATIC.RadarMode = radarModeEnum.All
STATIC.OldRadarCenter = Vector( 0, 0 )
STATIC.RadarCenter    = Vector( 0, 0 )


--- @private
--- @type table<BlipShapeType, string>
STATIC.BlipTypeNames = {
    [blipShapeTypeEnum.None          ] = "None",
    [blipShapeTypeEnum.Human         ] = "Human",
    [blipShapeTypeEnum.Vehicle       ] = "Vehicle",
    [blipShapeTypeEnum.Stationary    ] = "Stationary",
    [blipShapeTypeEnum.Objective     ] = "Objective",
    [blipShapeTypeEnum.BlipShapeCount] = "Blip Shape Count",
    [blipShapeTypeEnum.Bracket       ] = "Bracket",
    [blipShapeTypeEnum.Sweep         ] = "Sweep",
    [blipShapeTypeEnum.BlipTypeCount ] = "Blip Type Count",
}

--- The translation identifiers for each direction
--- @private
STATIC.DirectionIdentifiers = {
    [directionEnum.North    ] = "IDS_HUD_COMPASS_N",
    [directionEnum.NorthEast] = "IDS_HUD_COMPASS_NE",
    [directionEnum.East     ] = "IDS_HUD_COMPASS_E",
    [directionEnum.SouthEast] = "IDS_HUD_COMPASS_SE",
    [directionEnum.South    ] = "IDS_HUD_COMPASS_S",
    [directionEnum.SouthWest] = "IDS_HUD_COMPASS_SW",
    [directionEnum.West     ] = "IDS_HUD_COMPASS_W",
    [directionEnum.NorthWest] = "IDS_HUD_COMPASS_NW"
}

--- @private
--- A map of the PlayerTypeEnums that are teams rather than non-team types like spectators.  
--- Keys are PlayerTypeEnums, values are either `nil` or `true`
--- @type table<PlayerTypeEnum,boolean>
STATIC.TeamPlayerTypes ={
    [playerTypeEnum.Nod      ] = true,
    [playerTypeEnum.GDI      ] = true,
    [playerTypeEnum.Combine  ] = true,
    [playerTypeEnum.Rebels   ] = true,
    [playerTypeEnum.BlackMesa] = true,
    [playerTypeEnum.HECU     ] = true,
    [playerTypeEnum.Aperture ] = true,
}

--- @type table<integer, Render2dInstance>
STATIC.Blips = {}

--- @type RadarMarkerInstance[]
STATIC.Markers = {}


local radarRangeConVar = GetConVar( "ren_radar_range" )

local RADAR_MATERIAL        = CNC.LoadMaterial( "hud_main" )

local INFO_UV_SCALE        = Vector( 1 / 256, 1 / 256 )

local RADAR_RINGS_UV_UL    = Vector(  95,   0 )
local RADAR_RINGS_UV_LR    = Vector( 197,  53 )
local RADAR_RINGS_L_OFFSET = Vector( -51, -50 )
local RADAR_RINGS_R_OFFSET = Vector(   0, -50 )
local RADAR_STAR_UV_UL     = Vector( 241, 103 )
local RADAR_STAR_UV_LR     = Vector( 249, 111 )
local RADAR_SQUARE_UV_UL   = Vector( 247,  85 )
local RADAR_SQUARE_UV_LR   = Vector( 255,  93 )
local RADAR_TRIANGLE_UV_UL = Vector( 247,  93 )
local RADAR_TRIANGLE_UV_LR = Vector( 255, 101 )
local RADAR_CIRCLE_UV_UL   = Vector( 247,  77 )
local RADAR_CIRCLE_UV_LR   = Vector( 255,  85 )
local RADAR_BRACKET_UV_UL  = Vector( 241, 114 )
local RADAR_BRACKET_UV_LR  = Vector( 249, 122 )
local RADAR_SWEEP_UV_UL    = Vector(  80, 182 )
local RADAR_SWEEP_UV_LR    = Vector(  95, 191 )

-- The radius, in pixels, of the radar HUD element 
local RADAR_RADIUS       = 84

-- The width and height, in pixels, of radar blips at the same approximate altitude as the player 
local BLIP_SIZE          = 4

local RADAR_FADE_STOP    = RADAR_RADIUS * 0.6
local RADAR_FADE_START   = RADAR_RADIUS * 0.5
local RADAR_CENTER_TWEAK = Vector( 1, 2 )

local COMPASS_OFFSET     = Vector( 2, -73 )

-- The maximum height difference, in meters, between the player and a radar blip for the blip to be considered at the same height as the player
local RADAR_Z_RANGE      = 3

function STATIC.Init()

    STATIC.BracketEntity = NULL

    STATIC.Renderer = render2dClass.New()
    STATIC.Renderer:SetMaterial( RADAR_MATERIAL )
    STATIC.Renderer:SetCoordinateRange( render2dClass.GetScreenResolution() )

    -- "Init Colors"
    STATIC.BlipColors = {}
    for i = 0, table.Count( blipColorTypeEnum ) do
        STATIC.BlipColors[i] = Color( 255, 255, 255, 255 )
    end
    -- Teams
    STATIC.BlipColors[blipColorTypeEnum.Nod               ] = globalSettingsClass.Colors.Nod
    STATIC.BlipColors[blipColorTypeEnum.GDI               ] = globalSettingsClass.Colors.GDI
    STATIC.BlipColors[blipColorTypeEnum.Neutral           ] = globalSettingsClass.Colors.Neutral
    STATIC.BlipColors[blipColorTypeEnum.Mutant            ] = globalSettingsClass.Colors.Mutant
    STATIC.BlipColors[blipColorTypeEnum.Renegade          ] = globalSettingsClass.Colors.Renegade
    STATIC.BlipColors[blipColorTypeEnum.Combine           ] = globalSettingsClass.Colors.Combine
    STATIC.BlipColors[blipColorTypeEnum.Rebels            ] = globalSettingsClass.Colors.Rebels
    STATIC.BlipColors[blipColorTypeEnum.BlackMesa         ] = globalSettingsClass.Colors.BlackMesa
    STATIC.BlipColors[blipColorTypeEnum.HECU              ] = globalSettingsClass.Colors.HECU
    STATIC.BlipColors[blipColorTypeEnum.Aperture          ] = globalSettingsClass.Colors.Aperture

    -- Objectives
    STATIC.BlipColors[blipColorTypeEnum.PrimaryObjective  ] = globalSettingsClass.Colors.PrimaryObjective
    STATIC.BlipColors[blipColorTypeEnum.SecondaryObjective] = globalSettingsClass.Colors.SecondaryObjective
    STATIC.BlipColors[blipColorTypeEnum.TertiaryObjective ] = globalSettingsClass.Colors.TertiaryObjective

    -- Blip UVs
    STATIC.BlipUv = {}
    STATIC.BlipUv[blipShapeTypeEnum.None      ] = rectClass.New( 0,0,0,0 )
	STATIC.BlipUv[blipShapeTypeEnum.Human     ] = rectClass.New( RADAR_CIRCLE_UV_UL,   RADAR_CIRCLE_UV_LR   )
	STATIC.BlipUv[blipShapeTypeEnum.Vehicle   ] = rectClass.New( RADAR_TRIANGLE_UV_UL, RADAR_TRIANGLE_UV_LR )
	STATIC.BlipUv[blipShapeTypeEnum.Stationary] = rectClass.New( RADAR_SQUARE_UV_UL,   RADAR_SQUARE_UV_LR   )
	STATIC.BlipUv[blipShapeTypeEnum.Objective ] = rectClass.New( RADAR_STAR_UV_UL,     RADAR_STAR_UV_LR     )
	STATIC.BlipUv[blipShapeTypeEnum.Bracket   ] = rectClass.New( RADAR_BRACKET_UV_UL,  RADAR_BRACKET_UV_LR  )
	STATIC.BlipUv[blipShapeTypeEnum.Sweep     ] = rectClass.New( RADAR_SWEEP_UV_UL,    RADAR_SWEEP_UV_LR    )

    -- Scaling Blip UVs
	STATIC.BlipUv[blipShapeTypeEnum.Human     ]:ScaleVector( INFO_UV_SCALE )
	STATIC.BlipUv[blipShapeTypeEnum.Vehicle   ]:ScaleVector( INFO_UV_SCALE )
	STATIC.BlipUv[blipShapeTypeEnum.Stationary]:ScaleVector( INFO_UV_SCALE )
	STATIC.BlipUv[blipShapeTypeEnum.Objective ]:ScaleVector( INFO_UV_SCALE )
	STATIC.BlipUv[blipShapeTypeEnum.Bracket   ]:ScaleVector( INFO_UV_SCALE )
	STATIC.BlipUv[blipShapeTypeEnum.Sweep     ]:ScaleVector( INFO_UV_SCALE )

    -- "Clear radar renderer pointers, these are initialized on demand"
    STATIC.CompassRenderers = {}
    for i = 0, 8 do
        STATIC.CompassRenderers[i] = NULL
    end

    STATIC.ObjectiveList = {}

    -- "Don't reset the markers here, some may have already been added when loading the level (Created)"

    STATIC.HiddenTimer = 0
end

function STATIC.Shutdown()
    if STATIC.Renderer then
        STATIC.Renderer = nil
    end

    while table.Count( STATIC.Blips ) > 0 do
        local index = table.Count( STATIC.Blips ) - 1
        STATIC.Blips[index] = nil
    end

    for i = 0, 8 do
        STATIC.CompassRenderers[i] = NULL
    end

    STATIC.Markers = {}

    STATIC._IsHidden = false -- "Do this here rather than init, because init is called after load"
end

--- @param playerTransformationMatrix Matrix3dInstance
--- @param center Vector
function STATIC.Update( playerTransformationMatrix, center )
    STATIC.OldRadarCenter = STATIC.RadarCenter
    STATIC.RadarCenter = center

    STATIC.RadarTransformationMatrix = playerTransformationMatrix
    STATIC.RadarTransformationMatrix:PreRotateZ( math.rad( 90 ) )

    STATIC.HiddenTimer = STATIC.HiddenTimer + FrameTime() * ( STATIC._IsHidden and 1 or -1 )
    STATIC.HiddenTimer = math.Clamp( STATIC.HiddenTimer, 0, 1 )

    STATIC.RadarIntensity = 1 - STATIC.HiddenTimer
    STATIC.RadarColor = Color( 255, 255, 255, ( 1 - STATIC.HiddenTimer ) * 255 )

    STATIC.Renderer:Reset()

    if STATIC.RadarIntensity == 0 then
        return
    end

    
    -- "Radar rings"
    local uv = rectClass.New( RADAR_RINGS_UV_UL, RADAR_RINGS_UV_LR )
    local draw = rectClass.New( uv )
    draw.Right = draw.Left + uv:Height()
    draw.Bottom = draw.Top + uv:Width()
    uv:ScaleVector( INFO_UV_SCALE )
    draw = draw + center + RADAR_RINGS_L_OFFSET - draw:UpperLeft()
    STATIC.Renderer:AddQuad( draw:LowerLeft(), draw:LowerRight(), draw:UpperLeft(), draw:UpperRight(), uv, STATIC.RadarColor )
    draw = draw + center + RADAR_RINGS_R_OFFSET - draw:UpperLeft()
    STATIC.Renderer:AddQuadBackfaced( draw:LowerRight(), draw:LowerLeft(), draw:UpperRight(), draw:UpperLeft(), uv, STATIC.RadarColor )

    local bearing = wWMathClass.Wrap( ( playerTransformationMatrix:GetZRotation() / math.rad( 360 ) ) + 0.25, 0, 1 )
    STATIC.CurrentCompassRendererIndex = math.floor( ( bearing * 8 ) + 0.5 )
    STATIC.CurrentCompassRendererIndex = bit.band( STATIC.CurrentCompassRendererIndex, 7 )

    -- "If the renderer object for this particular radar direction hasn't been created, create it now"
    if STATIC.CompassRenderers[ STATIC.CurrentCompassRendererIndex ] == NULL then
        local font = styleManagerClass.PeekFont( fontStyleEnum.IngameTxt )
        local newCompassRenderer = render2dTextClass.New( font )
        newCompassRenderer:SetCoordinateRange( render2dClass.GetScreenResolution() )
        STATIC.CompassRenderers[ STATIC.CurrentCompassRendererIndex ] = newCompassRenderer
        newCompassRenderer:Reset()

        local directionId = STATIC.DirectionIdentifiers[STATIC.CurrentCompassRendererIndex]
        local directionString = translateDbClass.GetString( directionId )

        local textSize = newCompassRenderer:GetTextExtents( directionString )
        local textPos = center + COMPASS_OFFSET - ( textSize * 0.5 )
        textPos.x = math.floor( textPos.x )
        textPos.y = math.floor( textPos.y )
        newCompassRenderer:SetLocation( textPos )
        newCompassRenderer:DrawText( directionString )
    else
        -- "If the radar center has moved (which should never happen unless the screen size changes)"
        if STATIC.RadarCenter ~= STATIC.OldRadarCenter then
            local compassRenderer = STATIC.CompassRenderers[ STATIC.CurrentCompassRendererIndex ]

            compassRenderer:Reset()

            local directionId = STATIC.DirectionIdentifiers[STATIC.CurrentCompassRendererIndex]
            local directionString = translateDbClass.GetString( directionId )

            local textSize = compassRenderer:GetTextExtents( directionString )
            local textPos = center + COMPASS_OFFSET - ( textSize * 0.5 )
            textPos.x = math.floor( textPos.x )
            textPos.y = math.floor( textPos.y )
            compassRenderer:SetLocation( textPos )
            compassRenderer:DrawText( directionString )
        end
    end

    -- "Now build the blips"
    local starZ = 0
    local combatStar = combatManagerClass.GetTheStar()
    local starValid = IsValid( combatStar )
    if starValid then
        starZ = combatStar:GetPos().z
    end

    --- @type boolean, boolean, boolean, boolean
    local isNpc, isPlayer, isNextBot, isVehicle

    -- "For all PhysicalGameObjs"
    --- @param k integer
    --- @param ent Entity 
    for k, ent in ents.Iterator() do
        if not IsValid( ent ) then continue end

        -- "Don't draw the star"
        if ent == combatStar then continue end

        -- Cache these values to avoid calling these same functions repeatedly
        isNpc = ent:IsNPC()
        isPlayer = ent:IsPlayer()
        isNextBot = ent:IsNextBot()
        isVehicle = ent:IsVehicle()
        if not ( isNpc or isPlayer or isNextBot or isVehicle ) then continue end

        if isNpc or isPlayer or isNextBot then
            -- "Don't draw dead soldiers"
            if not ent:Alive() then continue end
            if ent:GetMaxHealth() > 0 and ent:Health() <= 0 then continue end
        end

        -- "Filter blips based on RadarMode"
        if starValid and STATIC.RadarMode ~= radarModeEnum.All then
            if STATIC.RadarMode == radarModeEnum.Nobody then
                continue
            else
                -- Assumes radar mode is teammates-only
                local otherPlayerType = commonBridge.GetPlayerType( ent )
                local myPlayerType    = commonBridge.GetPlayerType( combatStar )

                local isDifferentPlayerType = myPlayerType ~= otherPlayerType
                local isNotOnTeam = not STATIC.TeamPlayerTypes[ myPlayerType ]
                if isDifferentPlayerType or isNotOnTeam then
                    continue
                end

            end
        end

        -- "Don't show radar blips for enemy stealthed units"
        if smartGameObjectsBridge.IsStealthed( ent ) then
            local entPlayerType = commonBridge.GetPlayerType( ent )
            local myPlayerType  = commonBridge.GetPlayerType( combatStar )

            if myPlayerType ~= entPlayerType then
                continue
            end
        end

        local entPos = ent:GetPos()

        local altitudeFade = false
        local zDiff = starZ - entPos.z
        if math.abs( zDiff ) > RADAR_Z_RANGE * conversionLib.MetersToSource then
            altitudeFade = true
        end

        local blipShape = radarBlipsLib.GetRadarBlipShapeType( ent )
        local blipColor = radarBlipsLib.GetRadarBlipColorType( ent )
        local intensity = radarBlipsLib.GetRadarBlipIntensity( ent )
        local bracket = ent == STATIC.BracketEntity
        intensity = STATIC.AddBlip( entPos, blipShape, blipColor, intensity, bracket, altitudeFade )

        radarBlipsLib.SetRadarBlipIntensity( ent, math.Clamp( intensity, 0, 1 ) )
    end

    -- "For all objectives with a position"
    local count = objectiveManagerClass.GetObjectiveCount()
    for i = 1, count do
        local objective = objectiveManagerClass.GetObjective( i ) --[[@as ObjectiveInstance]]
        if objective.DrawBlip and objective.Status == objectiveStatusEnum.IsPending then
            local intensity = objective.BlipIntensity
            intensity = STATIC.AddBlip( objective.Position, blipShapeTypeEnum.Objective, objective:RadarBlipColorType(), intensity, false )
            objective.BlipIntensity = math.Clamp( intensity, 0, 1 )
        end
    end

    -- "For all markers"
    local markers = STATIC.Markers
    for i = 1, #markers do
        local marker = markers[i]
        local intensity = marker.Intensity
        intensity = STATIC.AddBlip( marker.Position, marker.Type, marker.Color, intensity, false )
        markers[i].Intensity = math.Clamp( intensity, 0, 1 )
    end
end

--- @param ent Entity
function STATIC.SetBracketEntity( ent )
    STATIC.BracketEntity = ent
end

function STATIC.Render()
    if STATIC.HiddenTimer < 1 and STATIC.Renderer then
        STATIC.Renderer:Render()

        local compassRenderer = STATIC.CompassRenderers[STATIC.CurrentCompassRendererIndex]
        if compassRenderer ~= NULL then
            compassRenderer:Render()
        end
    end
end

--- @param uv RectInstance
--- @param textureSize number
--- @return RectInstance
function STATIC.ScaleUv( uv, textureSize )
    STATIC.NewUv = rectClass.New( uv )
    STATIC.NewUv:Scale( 1 / textureSize )
    return STATIC.NewUv
end

--- @param newValue boolean
function STATIC.SetHidden( newValue )
    if STATIC._IsHidden ~= newValue then
        if newValue then
            -- TODO: Play sound here
        else
            -- TODO: Play sound heree
        end

        STATIC._IsHidden = newValue
    end
end

--- @return boolean
function STATIC.IsHidden()
    return STATIC._IsHidden
end

--[[ Blip Shapes ]] do

    --- @return BlipShapeType
    function STATIC.GetNumBlipShapeTypes()
        return blipShapeTypeEnum.BlipShapeCount
    end

    --- @param blipType BlipShapeType
    --- @return string
    function STATIC.GetBlipShapeTypeName( blipType )
        return STATIC.BlipTypeNames[blipType]
    end
end

--[[ Special Markers ]] do

    --- @param id integer
    function STATIC.ClearMarker( id )
        local markers = STATIC.Markers
        for i = 1, #markers do
            if markers[i].Id == id then
                table.remove( markers, i )
                i = i - 1
            end
        end
    end

    function STATIC.ClearMarkers()
        table.Empty( STATIC.Markers )
    end

    --- @param marker RadarMarkerInstance
    function STATIC.AddMarker( marker )
        STATIC.Markers[#STATIC.Markers + 1] = marker
    end

    --- @param id integer
    --- @param color BlipColorType
    function STATIC.ChangeMarkerColor( id, color )
        local markers = STATIC.Markers
        for i = 1, #markers do
            local marker = markers[i]
            if marker.Id == id then
                marker.Color = color
            end
        end
    end
end

--- @private
--- @param pos Vector
--- @param shapeType BlipShapeType
--- @param colorType BlipColorType
--- @param intensity number
--- @param showBracket boolean
--- @param altitudeFade boolean? [Default: false]
--- @return number intensity
function STATIC.AddBlip( pos, shapeType, colorType, intensity, showBracket, altitudeFade )
    if not altitudeFade then altitudeFade = false end

    if shapeType ~= blipShapeTypeEnum.None then
        local screen = STATIC.RadarTransformationMatrix * pos
        screen = screen * RADAR_RADIUS

        -- TODO: Investigate if it's useful to make this magic number adjustable
        -- The original code implies this is where a zoom factor would go

        -- Original value was 0.01 which corresponded to approximately 2450 source units
        -- ( ( range / SourceToCentimeters ) / 100000 ) seems to get that original value from an input range in source units
        -- TODO: Make this math work good
        local zoomFactor = ( RADAR_RADIUS / radarRangeConVar:GetFloat() / conversionLib.SourceToCentimeters )

        screen = screen * zoomFactor
        screen.z = 0

        -- Convert from Source units (entity pos) to meters
        screen.x = screen.x * conversionLib.SourceToMeters
        screen.y = screen.y * conversionLib.SourceToMeters

        local distance = screen:Length()
        if shapeType == blipShapeTypeEnum.Objective then
            if distance >= RADAR_FADE_STOP then
                screen:Normalize()
                screen = screen * RADAR_FADE_STOP
                distance = RADAR_FADE_STOP
            end
        end

        if distance <= RADAR_FADE_STOP then
            intensity = 1 -- "Always ping"

            local alpha = 1 - ( ( distance - RADAR_FADE_START ) / ( RADAR_FADE_STOP - RADAR_FADE_START ) )
            alpha = math.Clamp( alpha, 0, 1 )
            if shapeType == blipShapeTypeEnum.Objective then
                alpha = 1
            end

            local colorAlpha = alpha * intensity
            if altitudeFade then
                colorAlpha = colorAlpha * 0.66
            end

            local templateColor = STATIC.BlipColors[colorType]
            local intensityColorAlpha = STATIC.RadarIntensity * colorAlpha * 255
            local color = Color( templateColor.r, templateColor.g, templateColor.b, intensityColorAlpha )

            if STATIC.Renderer then
                local blip = rectClass.New( -BLIP_SIZE, -BLIP_SIZE, BLIP_SIZE, BLIP_SIZE )
                if altitudeFade then
                    blip:ScaleRelativeCenter( 0.66 )
                end
                blip = blip + Vector( -screen.x, screen.y )
                blip = blip + STATIC.RadarCenter + RADAR_CENTER_TWEAK
                local uv = STATIC.BlipUv[ shapeType]
                STATIC.Renderer:AddQuad( blip, uv, color )

                if showBracket then
                    local intensityAlpha = STATIC.RadarIntensity * alpha * 255
                    color = Color( 0, 255, 0, intensityAlpha )
                    uv = STATIC.BlipUv[ blipShapeTypeEnum.Bracket ]
                    STATIC.Renderer:AddQuad( blip, uv, color )
                end
            end
        end
    end

    return intensity
end

