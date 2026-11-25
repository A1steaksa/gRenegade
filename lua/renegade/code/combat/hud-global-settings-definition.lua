-- Based on HudGlobalSettingsDef within Code/Combat/globalsettings.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class HudGlobalSettingsDefinitionClass : DefinitionClass
--- @field Instance HudGlobalSettingsDefinitionInstance The metatable used by HudGlobalSettingsDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HudGlobalSettingsDefinitionClass"

--- @class HudGlobalSettingsDefinitionInstance : DefinitionInstance
--- @field Static HudGlobalSettingsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HudGlobalSettingsDefinition : Renegade_Definition" )
INSTANCE.Class = "HudGlobalSettingsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHudGlobalSettingsDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type RectClass
	local rectClass = CNC.Import( "code/wwmath/rect.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SimpleDefinitionFactoryClass
	local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_HL_DEF_PARENT								= enumBuilder:Set( 803001812 ),
        CHUNKID_HL_DEF_VARIABLES							= enumBuilder:Next(),

        MICROCHUNKID_HL_DEF_ACTIVATION_DELAY				= enumBuilder:Set( 1 ),
        MICROCHUNKID_HL_DEF_LOITER_FREQUENCY				= enumBuilder:Next(),
        MICROCHUNKID_HL_DEF_LOITER_ANIM_LIST_ENTRY			= enumBuilder:Next(),

        CHUNKID_HUD_DEF_PARENT								= enumBuilder:Set( 803001812 ),
        CHUNKID_HUD_DEF_VARIABLES							= enumBuilder:Next(),

        MICROCHUNKID_HUD_DEF_NOD_COLOR						= enumBuilder:Set( 1 ),
        MICROCHUNKID_HUD_DEF_GDI_COLOR						= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_NEUTRAL_COLOR					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_PRIMARY_OBJECTIVE_COLOR		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SECONDARY_OBJECTIVE_COLOR		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TERTIARY_OBJECTIVE_COLOR		= enumBuilder:Next(),

        MICROCHUNKID_HUD_DEF_STAR_BRACKET_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BRACKET_OFFSET			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BRACKET_UV				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_SIZE			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_OFFSET		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_UV			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BAR_SIZE					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BAR_OFFSET				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BAR_UV					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BAR_END_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BAR_END_OFFSET			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BAR_END_UV				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_HEALTH_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_HEALTH_OFFSET				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_HEALTH_UV					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_SHIELD_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_SHIELD_OFFSET				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_SHIELD_UV					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_BRACKET_SIZE			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_BRACKET_OFFSET			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_BRACKET_UV				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_ICON_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_ICON_OFFSET				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_NAME_BAR_SIZE			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_NAME_BAR_OFFSET			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_NAME_BAR_UV				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_NAME_OFFSET				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_BAR_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_BAR_OFFSET				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_BAR_UV					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_BAR_END_SIZE			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_BAR_END_OFFSET			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_BAR_END_UV				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_HEALTH_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_HEALTH_OFFSET			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_HEALTH_UV				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_SHIELD_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_SHIELD_OFFSET			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_TARGET_SHIELD_UV				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_OFFSET					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_RADIUS					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_FRAME_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_FRAME_UV					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_COMPASS_OFFSET			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_COMPASS_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_COMPASS_BASE_UV			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_COMPASS_UV_OFFSET		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_HUMAN_BLIP_UV			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_VEHICLE_BLIP_UV			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_STATIONARY_BLIP_UV		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_OBJECTIVE_BLIP_UV		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_BLIP_BRACKET_UV			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_SWEEP_UV					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_ARMED_SIZE	= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_ARMED_OFFSET	= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_ARMED_UV		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_WEAPON_ICON_SIZE			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_STAR_WEAPON_ICON_OFFSET		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_VIEW					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_VIEW_UV					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_BLACK_COVER_UV			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_TILT_BAR				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_TILT_BAR_RATE			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_TILT_BAR_UV				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_TURN_BAR				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_TURN_BAR_RATE			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_TURN_BAR_UV				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_DISTANCE_GRAPH			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_DISTANCE_GRAPH_UV		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_DISTANCE_GRAPH_MAX		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_SCAN_LINE_UV			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_INFO_TEXTURE_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_TEXTURE_SIZE				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_TEXTURE_SIZE			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_DAMAGE_INDICATOR_UV			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_DAMAGE_DIAG_INDICATOR_UV		= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_ZOOM_GRAPH				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_SNIPER_ZOOM_GRAPH_UV			= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_ON_SOUND_ID				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RADAR_OFF_SOUND_ID				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_MUTANT_COLOR					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_RENEGADE_COLOR					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_HEALTH_HIGH_COLOR				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_HEALTH_MED_COLOR				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_HEALTH_LOW_COLOR				= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_ENEMY_COLOR					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_FRIENDLY_COLOR					= enumBuilder:Next(),
        MICROCHUNKID_HUD_DEF_NO_RELATION_COLOR				= enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class HudGlobalSettingsDefinitionClass
    --- @field TheInstance HudGlobalSettingsDefinitionInstance

    STATIC.INFO_TEXTURE_SIZE 				= 128
    STATIC.STAR_BRACKET_SIZE 				= Vector( 72, 56 )
    STATIC.STAR_BRACKET_OFFSET 				= Vector( -70, -58 )
    STATIC.STAR_BRACKET_UV 					= rectClass.New( 55.0, 1.0, 127.0, 57.0 )
    STATIC.STAR_BRACKET_TOP_SIZE 			= Vector( 38, 16 )
    STATIC.STAR_BRACKET_TOP_OFFSET 			= STATIC.STAR_BRACKET_OFFSET + Vector( 25, -16 )
    STATIC.STAR_BRACKET_TOP_UV 				= rectClass.New( 2.0, 81.0, 40.0, 97.0 )
    STATIC.STAR_BRACKET_TOP_ARMED_SIZE		= Vector( 38, 16 )
    STATIC.STAR_BRACKET_TOP_ARMED_OFFSET	= STATIC.STAR_BRACKET_OFFSET + Vector( 25, -16 )
    STATIC.STAR_BRACKET_TOP_ARMED_UV 		= rectClass.New( 40.0, 81.0, 2.0, 97.0 )
    STATIC.STAR_BAR_LENGTH 					= 130
    STATIC.STAR_BAR_SIZE 					= Vector( STATIC.STAR_BAR_LENGTH, 18 )
    STATIC.STAR_BAR_OFFSET 					= STATIC.STAR_BRACKET_OFFSET + Vector( -STATIC.STAR_BAR_LENGTH + 2, 31 )
    STATIC.STAR_BAR_UV						= rectClass.New( 55.0, 60.0, 79.0, 78.0 )
    STATIC.STAR_BAR_END_SIZE				= Vector( 32, 24 )
    STATIC.STAR_BAR_END_OFFSET				= STATIC.STAR_BAR_OFFSET + Vector( -26, -2 )
    STATIC.STAR_BAR_END_UV 					= rectClass.New( 79.0, 57.0, 111.0, 81.0 )
    STATIC.STAR_HEALTH_SIZE 				= Vector( STATIC.STAR_BAR_LENGTH, 6 )
    STATIC.STAR_HEALTH_OFFSET 				= STATIC.STAR_BAR_OFFSET + Vector( 0, 3 )
    STATIC.STAR_HEALTH_UV 					= rectClass.New( 112.0, 66.0, 126.0, 72.0 )
    STATIC.STAR_SHIELD_SIZE 				= Vector( STATIC.STAR_BAR_LENGTH + 4, 6 )
    STATIC.STAR_SHIELD_OFFSET 				= STATIC.STAR_BAR_OFFSET + Vector( -4, 10 )
    STATIC.STAR_SHIELD_UV 					= rectClass.New( 112.0, 66.0, 126.0, 72.0 )
    STATIC.STAR_WEAPON_ICON_SIZE 			= Vector( 64, 64 )
    STATIC.STAR_WEAPON_ICON_OFFSET 			= STATIC.STAR_BRACKET_OFFSET + Vector( 0, -70 )
    STATIC.TARGET_BRACKET_SIZE 				= Vector( 21, 52 )
    STATIC.TARGET_BRACKET_OFFSET 			= Vector( 68, -60 )
    STATIC.TARGET_BRACKET_UV 				= rectClass.New( 2.0, 1.0, 23.0, 53.0 )
    STATIC.TARGET_ICON_SIZE 				= Vector( 64, 64 )
    STATIC.TARGET_ICON_OFFSET 				= Vector( 2, -68 )
    STATIC.TARGET_NAME_BAR_SIZE 			= Vector( 120, 20 )
    STATIC.TARGET_NAME_BAR_OFFSET 			= (STATIC.TARGET_BRACKET_OFFSET + Vector( 19, 2 ))  
    STATIC.TARGET_NAME_BAR_UV 				= rectClass.New( 1.0, 59.0, 31.0, 79.0 )
    STATIC.TARGET_NAME_OFFSET 				= (STATIC.TARGET_BRACKET_OFFSET + Vector( 24, 8 ))  
    STATIC.TARGET_BAR_LENGTH 				= 130
    STATIC.TARGET_BAR_SIZE 					= Vector( STATIC.TARGET_BAR_LENGTH, 18 )
    STATIC.TARGET_BAR_OFFSET 				= (STATIC.TARGET_BRACKET_OFFSET + Vector( 19 , 33 ))
    STATIC.TARGET_BAR_UV 					= rectClass.New( 55.0, 60.0, 79.0, 78.0 )
    STATIC.TARGET_BAR_END_SIZE				= Vector( 32, 24 )
    STATIC.TARGET_BAR_END_OFFSET 			= (STATIC.TARGET_BAR_OFFSET + Vector( STATIC.TARGET_BAR_LENGTH - 6, -2 ))
    STATIC.TARGET_BAR_END_UV 				= rectClass.New( 111.0, 57.0, 79.0, 81.0 )
    STATIC.TARGET_HEALTH_SIZE				= Vector( STATIC.TARGET_BAR_LENGTH, 6 )
    STATIC.TARGET_HEALTH_OFFSET 			= (STATIC.TARGET_BAR_OFFSET + Vector( 0, 3 ))
    STATIC.TARGET_HEALTH_UV 				= rectClass.New( 126.0, 66.0, 112.0, 72.0 )
    STATIC.TARGET_SHIELD_SIZE 				= Vector( STATIC.TARGET_BAR_LENGTH + 4, 6 )
    STATIC.TARGET_SHIELD_OFFSET 			= (STATIC.TARGET_BAR_OFFSET + Vector( 0, 10 ))
    STATIC.TARGET_SHIELD_UV 				= rectClass.New( 126.0, 66.0, 112.0, 72.0 )
    STATIC.RADAR_TEXTURE_SIZE 				= 128
    STATIC.RADAR_OFFSET 					= Vector( 82, -124 )
    STATIC.RADAR_RADIUS 					= 64
    STATIC.RADAR_FRAME_SIZE 				= Vector( 112, 128 )
    STATIC.RADAR_FRAME_UV 					= rectClass.New( 0, 0, 112.0, 128.0 )
    STATIC.RADAR_COMPASS_OFFSET 			= Vector( -7, 54 )
    STATIC.RADAR_COMPASS_SIZE 				= Vector( 16, 8 )
    STATIC.RADAR_COMPASS_BASE_UV 			= rectClass.New( 112.0, 64.0, 128.0, 72.0 )
    STATIC.RADAR_COMPASS_UV_OFFSET 			= Vector( 0, 8 )
    STATIC.RADAR_HUMAN_BLIP_UV 	 			= rectClass.New( 112.0, 0.0,  120.0,  8.0 )
    STATIC.RADAR_VEHICLE_BLIP_UV 			= rectClass.New( 120.0, 0.0,  128.0,  8.0 )
    STATIC.RADAR_STATIONARY_BLIP_UV 		= rectClass.New( 112.0, 8.0,  120.0, 16.0 )
    STATIC.RADAR_OBJECTIVE_BLIP_UV 			= rectClass.New( 120.0, 8.0,  128.0, 16.0 )
    STATIC.RADAR_BLIP_BRACKET_UV 			= rectClass.New( 112.0, 16.0, 120.0, 24.0 )
    STATIC.RADAR_SWEEP_UV 					= rectClass.New( 121.0, 24.0, 127.0, 32.0 )
    STATIC.SNIPER_TEXTURE_SIZE 				= 256
    STATIC.SNIPER_VIEW 						= rectClass.New( 0.2, 0.12,   0.8,  0.88 )
    STATIC.SNIPER_VIEW_UV 					= rectClass.New( 0.0,  0.0, 240.0, 227.0 )
    STATIC.SNIPER_SCAN_LINE_UV 				= rectClass.New( 0.01, 0.01, 0.05,  0.05 )
    STATIC.SNIPER_BLACK_COVER_UV 			= rectClass.New( 0.01, 0.01, 0.05,  0.05 )
    STATIC.SNIPER_TILT_BAR 					= rectClass.New( 0.20, 0.25, 0.225, 0.75 )
    STATIC.SNIPER_TILT_BAR_RATE 			= 1
    STATIC.SNIPER_TILT_BAR_UV 				= rectClass.New( 245.0, 3.0, 250.0, 208.0 )
    STATIC.SNIPER_TURN_BAR 					= rectClass.New( 0.35, 0.25, 0.65, 0.275 )
    STATIC.SNIPER_TURN_BAR_RATE 			= 1
    STATIC.SNIPER_TURN_BAR_UV 				= rectClass.New( 1.0, 244.0, 109.0, 253.0 )
    STATIC.SNIPER_DISTANCE_GRAPH 			= rectClass.New( 0.175, 0.3, 0.2, 0.65 )
    STATIC.SNIPER_DISTANCE_GRAPH_UV 		= rectClass.New( 1.0, 231.0, 87.0, 239.0 )
    STATIC.SNIPER_DISTANCE_GRAPH_MAX 		= 200
    STATIC.SNIPER_ZOOM_GRAPH 				= rectClass.New( 0.72, 0.18, 0.8, 0.22 )
    STATIC.SNIPER_ZOOM_GRAPH_UV 			= rectClass.New( 218.0, 247.0, 254.0, 254.0 )
    STATIC.DAMAGE_INDICATOR_UV 				= rectClass.New( 31.0, 1.0, 51.0, 59.0 )
    STATIC.DAMAGE_DIAG_INDICATOR_UV 		= rectClass.New( 1.0, 60.0, 47.0, 106.0 )

    --- Creates a new HudGlobalSettingsDefinitionInstance
    --- @return HudGlobalSettingsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HudGlobalSettingsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HudGlobalSettingsDefinitionInstance, `false` otherwise
    function STATIC.IsHudGlobalSettingsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHudGlobalSettingsDefinition and true or false
    end

    typecheck.RegisterType( "HudGlobalSettingsDefinitionInstance", STATIC.IsHudGlobalSettingsDefinition )

    function STATIC.StaticConstructor()
        STATIC.HudGlobalSettingsDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CHUNKID_GLOBAL_SETTINGS_DEF_HUD )
        STATIC.HudGlobalSettingsDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_HUD, "HUD" )
    end

    --- @return HudGlobalSettingsDefinitionInstance
    function STATIC.GetInstance()
        return STATIC.TheInstance
    end
end


--- @class HudGlobalSettingsDefinitionInstance
--- @field NodColor Color
--- @field GdiColor Color
--- @field NeutralColor Color
--- @field MutantColor Color
--- @field RenegadeColor Color
--- @field PrimaryObjectiveColor Color
--- @field SecondaryObjectiveColor Color
--- @field TertiaryObjectiveColor Color
--- @field HealthHighColor Color
--- @field HealthMediumColor Color
--- @field HealthLowColor Color
--- @field EnemyColor Color
--- @field FriendlyColor Color
--- @field NoRelationColor Color
--- @field InfoTextureSize number
--- @field StarBracketSize Vector
--- @field StarBracketOffset Vector
--- @field StarBracketUV RectInstance
--- @field StarBracketTopSize Vector
--- @field StarBracketTopOffset Vector
--- @field StarBracketTopUV RectInstance
--- @field StarBracketTopArmedSize Vector
--- @field StarBracketTopArmedOffset Vector
--- @field StarBracketTopArmedUV RectInstance
--- @field StarBarSize Vector
--- @field StarBarOffset Vector
--- @field StarBarUV RectInstance
--- @field StarBarEndSize Vector
--- @field StarBarEndOffset Vector
--- @field StarBarEndUV RectInstance
--- @field StarHealthSize Vector
--- @field StarHealthOffset Vector
--- @field StarHealthUV RectInstance
--- @field StarShieldSize Vector
--- @field StarShieldOffset Vector
--- @field StarShieldUV RectInstance
--- @field StarWeaponIconSize Vector
--- @field StarWeaponIconOffset Vector
--- @field TargetBracketSize Vector
--- @field TargetBracketOffset Vector
--- @field TargetBracketUV RectInstance
--- @field TargetIconSize Vector
--- @field TargetIconOffset Vector
--- @field TargetNameBarSize Vector
--- @field TargetNameBarOffset Vector
--- @field TargetNameBarUV RectInstance
--- @field TargetNameOffset Vector
--- @field TargetBarSize Vector
--- @field TargetBarOffset Vector
--- @field TargetBarUV RectInstance
--- @field TargetBarEndSize Vector
--- @field TargetBarEndOffset Vector
--- @field TargetBarEndUV RectInstance
--- @field TargetHealthSize Vector
--- @field TargetHealthOffset Vector
--- @field TargetHealthUV RectInstance
--- @field TargetShieldSize Vector
--- @field TargetShieldOffset Vector
--- @field TargetShieldUV RectInstance
--- @field RadarTextureSize number
--- @field RadarOffset Vector
--- @field RadarRadius number
--- @field RadarFrameSize Vector
--- @field RadarFrameUV RectInstance
--- @field RadarCompassOffset Vector
--- @field RadarCompassSize Vector
--- @field RadarCompassBaseUV RectInstance
--- @field RadarCompassUvOffset Vector
--- @field RadarHumanBlipUV RectInstance
--- @field RadarVehicleBlipUV RectInstance
--- @field RadarStationaryBlipUV RectInstance
--- @field RadarObjectiveBlipUV RectInstance
--- @field RadarBlipBracketUV RectInstance
--- @field RadarSweepUV RectInstance
--- @field RadarOnSoundID integer
--- @field RadarOffSoundID integer
--- @field SniperTextureSize number
--- @field SniperView RectInstance
--- @field SniperViewUV RectInstance
--- @field SniperScanLineUV RectInstance
--- @field SniperBlackCoverUV RectInstance
--- @field SniperTiltBar RectInstance
--- @field SniperTiltBarRate number
--- @field SniperTiltBarUV RectInstance
--- @field SniperTurnBar RectInstance
--- @field SniperTurnBarRate number
--- @field SniperTurnBarUV RectInstance
--- @field SniperDistanceGraph RectInstance
--- @field SniperDistanceGraphUV RectInstance
--- @field SniperDistanceGraphMax number
--- @field SniperZoomGraph RectInstance
--- @field SniperZoomGraphUV RectInstance
--- @field DamageIndicatorUV RectInstance
--- @field DamageDiagIndicatorUV RectInstance

function INSTANCE:Renegade_HudGlobalSettingsDefinition()
    self.NodColor 				 = Color( 255,   0,   0 )
    self.GdiColor 				 = Color( 255, 255,   0 )
    self.NeutralColor 			 = Color( 255, 255, 255 )
    self.MutantColor 			 = Color(   0, 255,   0 )
    self.RenegadeColor 			 = Color(   0,   0, 255 )
    self.CombineColor            = Color( 198, 131,  10 )
    self.RebelColor              = Color( 251, 127,  12 )
    self.BlackMesaColor          = Color( 251, 127,  12 )
    self.HecuColor               = Color(  15,   0, 231 )
    self.ApertureColor           = Color(   0, 153, 254 )

    self.PrimaryObjectiveColor 	 = Color(   0, 255,   0 )
    self.SecondaryObjectiveColor = Color(   0,   0, 255 )
    self.TertiaryObjectiveColor  = Color( 255,   0, 255 )

    self.HealthHighColor 		 = Color(   0, 255,   0 )
    self.HealthMediumColor 		 = Color( 255, 255,   0 )
    self.HealthLowColor 		 = Color( 255,   0,   0 )

    self.EnemyColor 			 = Color( 255,   0,   0 )
    self.FriendlyColor 			 = Color(   0, 255,   0 )
    self.NoRelationColor 		 = Color( 255, 255, 255 )

    self.ReticleBusyColor        = Color( 255, 255,   0 )

    self.InfoTextureSize 			= STATIC.INFO_TEXTURE_SIZE
    self.StarBracketSize			= STATIC.STAR_BRACKET_SIZE
    self.StarBracketOffset			= STATIC.STAR_BRACKET_OFFSET
    self.StarBracketUV				= STATIC.STAR_BRACKET_UV
    self.StarBracketTopSize			= STATIC.STAR_BRACKET_TOP_SIZE
    self.StarBracketTopOffset		= STATIC.STAR_BRACKET_TOP_OFFSET
    self.StarBracketTopUV			= STATIC.STAR_BRACKET_TOP_UV
    self.StarBracketTopArmedSize	= STATIC.STAR_BRACKET_TOP_ARMED_SIZE
    self.StarBracketTopArmedOffset	= STATIC.STAR_BRACKET_TOP_ARMED_OFFSET
    self.StarBracketTopArmedUV		= STATIC.STAR_BRACKET_TOP_ARMED_UV
    self.StarBarSize				= STATIC.STAR_BAR_SIZE
    self.StarBarOffset				= STATIC.STAR_BAR_OFFSET
    self.StarBarUV					= STATIC.STAR_BAR_UV
    self.StarBarEndSize				= STATIC.STAR_BAR_END_SIZE
    self.StarBarEndOffset			= STATIC.STAR_BAR_END_OFFSET
    self.StarBarEndUV				= STATIC.STAR_BAR_END_UV
    self.StarHealthSize				= STATIC.STAR_HEALTH_SIZE
    self.StarHealthOffset			= STATIC.STAR_HEALTH_OFFSET
    self.StarHealthUV				= STATIC.STAR_HEALTH_UV
    self.StarShieldSize				= STATIC.STAR_SHIELD_SIZE
    self.StarShieldOffset			= STATIC.STAR_SHIELD_OFFSET
    self.StarShieldUV				= STATIC.STAR_SHIELD_UV
    self.StarWeaponIconSize			= STATIC.STAR_WEAPON_ICON_SIZE
    self.StarWeaponIconOffset		= STATIC.STAR_WEAPON_ICON_OFFSET
    self.TargetBracketSize			= STATIC.TARGET_BRACKET_SIZE
    self.TargetBracketOffset		= STATIC.TARGET_BRACKET_OFFSET
    self.TargetBracketUV			= STATIC.TARGET_BRACKET_UV
    self.TargetIconSize				= STATIC.TARGET_ICON_SIZE
    self.TargetIconOffset			= STATIC.TARGET_ICON_OFFSET
    self.TargetNameBarSize			= STATIC.TARGET_NAME_BAR_SIZE
    self.TargetNameBarOffset		= STATIC.TARGET_NAME_BAR_OFFSET
    self.TargetNameBarUV			= STATIC.TARGET_NAME_BAR_UV
    self.TargetNameOffset			= STATIC.TARGET_NAME_OFFSET
    self.TargetBarSize				= STATIC.TARGET_BAR_SIZE
    self.TargetBarOffset			= STATIC.TARGET_BAR_OFFSET
    self.TargetBarUV				= STATIC.TARGET_BAR_UV
    self.TargetBarEndSize			= STATIC.TARGET_BAR_END_SIZE
    self.TargetBarEndOffset			= STATIC.TARGET_BAR_END_OFFSET
    self.TargetBarEndUV				= STATIC.TARGET_BAR_END_UV
    self.TargetHealthSize			= STATIC.TARGET_HEALTH_SIZE
    self.TargetHealthOffset			= STATIC.TARGET_HEALTH_OFFSET
    self.TargetHealthUV				= STATIC.TARGET_HEALTH_UV
    self.TargetShieldSize			= STATIC.TARGET_SHIELD_SIZE
    self.TargetShieldOffset			= STATIC.TARGET_SHIELD_OFFSET
    self.TargetShieldUV				= STATIC.TARGET_SHIELD_UV
    self.RadarTextureSize			= STATIC.RADAR_TEXTURE_SIZE
    self.RadarOffset				= STATIC.RADAR_OFFSET
    self.RadarRadius				= STATIC.RADAR_RADIUS
    self.RadarFrameSize				= STATIC.RADAR_FRAME_SIZE
    self.RadarFrameUV				= STATIC.RADAR_FRAME_UV
    self.RadarCompassOffset			= STATIC.RADAR_COMPASS_OFFSET
    self.RadarCompassSize			= STATIC.RADAR_COMPASS_SIZE
    self.RadarCompassBaseUV			= STATIC.RADAR_COMPASS_BASE_UV
    self.RadarCompassUvOffset		= STATIC.RADAR_COMPASS_UV_OFFSET
    self.RadarHumanBlipUV			= STATIC.RADAR_HUMAN_BLIP_UV
    self.RadarVehicleBlipUV			= STATIC.RADAR_VEHICLE_BLIP_UV
    self.RadarStationaryBlipUV		= STATIC.RADAR_STATIONARY_BLIP_UV
    self.RadarObjectiveBlipUV		= STATIC.RADAR_OBJECTIVE_BLIP_UV
    self.RadarBlipBracketUV			= STATIC.RADAR_BLIP_BRACKET_UV
    self.RadarSweepUV				= STATIC.RADAR_SWEEP_UV
    self.RadarOnSoundID				= 0
    self.RadarOffSoundID			= 0
    self.SniperTextureSize			= STATIC.SNIPER_TEXTURE_SIZE
    self.SniperView					= STATIC.SNIPER_VIEW
    self.SniperViewUV				= STATIC.SNIPER_VIEW_UV
    self.SniperScanLineUV			= STATIC.SNIPER_SCAN_LINE_UV
    self.SniperBlackCoverUV			= STATIC.SNIPER_BLACK_COVER_UV
    self.SniperTiltBar				= STATIC.SNIPER_TILT_BAR
    self.SniperTiltBarRate			= STATIC.SNIPER_TILT_BAR_RATE
    self.SniperTiltBarUV			= STATIC.SNIPER_TILT_BAR_UV
    self.SniperTurnBar				= STATIC.SNIPER_TURN_BAR
    self.SniperTurnBarRate			= STATIC.SNIPER_TURN_BAR_RATE
    self.SniperTurnBarUV			= STATIC.SNIPER_TURN_BAR_UV
    self.SniperDistanceGraph		= STATIC.SNIPER_DISTANCE_GRAPH
    self.SniperDistanceGraphUV		= STATIC.SNIPER_DISTANCE_GRAPH_UV
    self.SniperDistanceGraphMax		= STATIC.SNIPER_DISTANCE_GRAPH_MAX
    self.SniperZoomGraph			= STATIC.SNIPER_ZOOM_GRAPH
    self.SniperZoomGraphUV			= STATIC.SNIPER_ZOOM_GRAPH_UV
    self.DamageIndicatorUV			= STATIC.DAMAGE_INDICATOR_UV
    self.DamageDiagIndicatorUV		= STATIC.DAMAGE_DIAG_INDICATOR_UV

    STATIC.TheInstance = self
end

function INSTANCE:_Renegade_HudGlobalSettingsDefinition()
    STATIC.Instance = nil
end

--- @return integer
function INSTANCE:GetClassId()
    return combatChunkIdClass.CLASSID_GLOBAL_SETTINGS_DEF_HUD
end

--- @return PersistInstance
function INSTANCE:Create()
    assert( false )
end

--- @param csave ChunkSaveInstance
function INSTANCE:Save( csave )
    typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    local ids = STATIC.ChunkIds

    while cload:OpenChunk() do
        local id = cload:CurChunkId()

        if id == ids.CHUNKID_HL_DEF_PARENT then
            definitionClass.Instance.Load( self, cload )

        elseif id == ids.CHUNKID_HL_DEF_VARIABLES then
            while cload:OpenMicroChunk() do
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_NOD_COLOR,					"Color", self, "NodColor"                )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_GDI_COLOR,					"Color", self, "GdiColor"                )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_NEUTRAL_COLOR,				"Color", self, "NeutralColor"            )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_MUTANT_COLOR,				"Color", self, "MutantColor"             )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RENEGADE_COLOR,			"Color", self, "RenegadeColor"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_PRIMARY_OBJECTIVE_COLOR,	"Color", self, "PrimaryObjectiveColor"   )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SECONDARY_OBJECTIVE_COLOR,	"Color", self, "SecondaryObjectiveColor" )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TERTIARY_OBJECTIVE_COLOR,	"Color", self, "TertiaryObjectiveColor"  )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_HEALTH_HIGH_COLOR,			"Color", self, "HealthHighColor"         )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_HEALTH_MED_COLOR,			"Color", self, "HealthMediumColor"       )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_HEALTH_LOW_COLOR,			"Color", self, "HealthLowColor"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_ENEMY_COLOR,				"Color", self, "EnemyColor"              )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_FRIENDLY_COLOR,			"Color", self, "FriendlyColor"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_NO_RELATION_COLOR,			"Color", self, "NoRelationColor"         )

                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_INFO_TEXTURE_SIZE,             fundamentalDataTypeEnum.Float,    self, "InfoTextureSize"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BRACKET_SIZE,             "Vector2",              self, "StarBracketSize"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BRACKET_OFFSET,           "Vector2",              self, "StarBracketOffset"         )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BRACKET_UV,               "Rect",                 self, "StarBracketUV"             )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_SIZE,         "Vector2",              self, "StarBracketTopSize"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_OFFSET,       "Vector2",              self, "StarBracketTopOffset"      )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_UV,           "Rect",                 self, "StarBracketTopUV"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_ARMED_SIZE,   "Vector2",              self, "StarBracketTopArmedSize"   )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_ARMED_OFFSET, "Vector2",              self, "StarBracketTopArmedOffset" )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BRACKET_TOP_ARMED_UV,     "Rect",                 self, "StarBracketTopArmedUV"     )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BAR_SIZE,                 "Vector2",              self, "StarBarSize"               )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BAR_OFFSET,               "Vector2",              self, "StarBarOffset"             )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BAR_UV,                   "Rect",                 self, "StarBarUV"                 )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BAR_END_SIZE,             "Vector2",              self, "StarBarEndSize"            )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BAR_END_OFFSET,           "Vector2",              self, "StarBarEndOffset"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_BAR_END_UV,               "Rect",                 self, "StarBarEndUV"              )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_HEALTH_SIZE,              "Vector2",              self, "StarHealthSize"            )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_HEALTH_OFFSET,            "Vector2",              self, "StarHealthOffset"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_HEALTH_UV,                "Rect",                 self, "StarHealthUV"              )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_SHIELD_SIZE,              "Vector2",              self, "StarShieldSize"            )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_SHIELD_OFFSET,            "Vector2",              self, "StarShieldOffset"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_SHIELD_UV,                "Rect",                 self, "StarShieldUV"              )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_WEAPON_ICON_SIZE,         "Vector2",              self, "StarWeaponIconSize"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_STAR_WEAPON_ICON_OFFSET,       "Vector2",              self, "StarWeaponIconOffset"      )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_BRACKET_SIZE,           "Vector2",              self, "TargetBracketSize"         )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_BRACKET_OFFSET,         "Vector2",              self, "TargetBracketOffset"       )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_BRACKET_UV,             "Rect",                 self, "TargetBracketUV"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_ICON_SIZE,              "Vector2",              self, "TargetIconSize"            )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_ICON_OFFSET,            "Vector2",              self, "TargetIconOffset"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_NAME_BAR_SIZE,          "Vector2",              self, "TargetNameBarSize"         )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_NAME_BAR_OFFSET,        "Vector2",              self, "TargetNameBarOffset"       )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_NAME_BAR_UV,            "Rect",                 self, "TargetNameBarUV"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_NAME_OFFSET,            "Vector2",              self, "TargetNameOffset"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_BAR_SIZE,               "Vector2",              self, "TargetBarSize"             )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_BAR_OFFSET,             "Vector2",              self, "TargetBarOffset"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_BAR_UV,                 "Rect",                 self, "TargetBarUV"               )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_BAR_END_SIZE,           "Vector2",              self, "TargetBarEndSize"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_BAR_END_OFFSET,         "Vector2",              self, "TargetBarEndOffset"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_BAR_END_UV,             "Rect",                 self, "TargetBarEndUV"            )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_HEALTH_SIZE,            "Vector2",              self, "TargetHealthSize"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_HEALTH_OFFSET,          "Vector2",              self, "TargetHealthOffset"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_HEALTH_UV,              "Rect",                 self, "TargetHealthUV"            )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_SHIELD_SIZE,            "Vector2",              self, "TargetShieldSize"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_SHIELD_OFFSET,          "Vector2",              self, "TargetShieldOffset"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_TARGET_SHIELD_UV,              "Rect",                 self, "TargetShieldUV"            )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_TEXTURE_SIZE,            fundamentalDataTypeEnum.Float,    self, "RadarTextureSize"         )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_OFFSET,                  "Vector2",              self, "RadarOffset"               )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_RADIUS,                  fundamentalDataTypeEnum.Float,    self, "RadarRadius"              )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_FRAME_SIZE,              "Vector2",              self, "RadarFrameSize"            )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_FRAME_UV,                "Rect",                 self, "RadarFrameUV"              )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_COMPASS_OFFSET,          "Vector2",              self, "RadarCompassOffset"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_COMPASS_SIZE,            "Vector2",              self, "RadarCompassSize"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_COMPASS_BASE_UV,         "Rect",                 self, "RadarCompassBaseUV"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_COMPASS_UV_OFFSET,       "Vector2",              self, "RadarCompassUvOffset"      )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_HUMAN_BLIP_UV,           "Rect",                 self, "RadarHumanBlipUV"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_VEHICLE_BLIP_UV,         "Rect",                 self, "RadarVehicleBlipUV"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_STATIONARY_BLIP_UV,      "Rect",                 self, "RadarStationaryBlipUV"     )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_OBJECTIVE_BLIP_UV,       "Rect",                 self, "RadarObjectiveBlipUV"      )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_BLIP_BRACKET_UV,         "Rect",                 self, "RadarBlipBracketUV"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_SWEEP_UV,                "Rect",                 self, "RadarSweepUV"              )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_ON_SOUND_ID,             fundamentalDataTypeEnum.Int,      self, "RadarOnSoundID"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_RADAR_OFF_SOUND_ID,            fundamentalDataTypeEnum.Int,      self, "RadarOffSoundID"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_TEXTURE_SIZE,           fundamentalDataTypeEnum.Float,    self, "SniperTextureSize"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_VIEW,                   "Rect",                 self, "SniperView"                )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_VIEW_UV,                "Rect",                 self, "SniperViewUV"              )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_SCAN_LINE_UV,           "Rect",                 self, "SniperScanLineUV"          )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_BLACK_COVER_UV,         "Rect",                 self, "SniperBlackCoverUV"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_TILT_BAR,               "Rect",                 self, "SniperTiltBar"             )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_TILT_BAR_RATE,          fundamentalDataTypeEnum.Float,    self, "SniperTiltBarRate"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_TILT_BAR_UV,            "Rect",                 self, "SniperTiltBarUV"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_TURN_BAR,               "Rect",                 self, "SniperTurnBar"             )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_TURN_BAR_RATE,          fundamentalDataTypeEnum.Float,    self, "SniperTurnBarRate"        )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_TURN_BAR_UV,            "Rect",                 self, "SniperTurnBarUV"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_DISTANCE_GRAPH,         "Rect",                 self, "SniperDistanceGraph"       )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_DISTANCE_GRAPH_UV,      "Rect",                 self, "SniperDistanceGraphUV"     )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_DISTANCE_GRAPH_MAX,     fundamentalDataTypeEnum.Float,    self, "SniperDistanceGraphMax"   )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_ZOOM_GRAPH,             "Rect",                 self, "SniperZoomGraph"           )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_SNIPER_ZOOM_GRAPH_UV,          "Rect",                 self, "SniperZoomGraphUV"         )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_DAMAGE_INDICATOR_UV,           "Rect",                 self, "DamageIndicatorUV"         )
                chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_HUD_DEF_DAMAGE_DIAG_INDICATOR_UV,      "Rect",                 self, "DamageDiagIndicatorUV"     )

                cload:CloseMicroChunk()
            end
        else
            section.Warn( "Unahndled Chunk ID: ", id )
        end

        cload:CloseChunk()
    end

    return true
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
    return STATIC.HudGlobalSettingsDefinitionPersistFactory
end

--[[ Team Colors ]] do

    --- @return Color
    function INSTANCE:GetNodColor()
        return self.NodColor
    end

    --- @return Color
    function INSTANCE:GetGdiColor()
        return self.GdiColor
    end

    --- @return Color
    function INSTANCE:GetNeutralColor()
        return self.NeutralColor
    end

    --- @return Color
    function INSTANCE:GetMutantColor()
        return self.MutantColor
    end

    --- @return Color
    function INSTANCE:GetRenegadeColor()
        return self.RenegadeColor
    end

    --- @return Color
    function INSTANCE:GetCombineColor()
        return self.CombineColor
    end

    --- @return Color
    function INSTANCE:GetRebelColor()
        return self.RebelColor
    end

    --- @return Color
    function INSTANCE:GetBlackMesaColor()
        return self.BlackMesaColor
    end

    --- @return Color
    function INSTANCE:GetHecuColor()
        return self.HecuColor
    end

    --- @return Color
    function INSTANCE:GetApertureColor()
        return self.ApertureColor
    end
end


--[[ Objective Colors ]] do

    --- @return Color
    function INSTANCE:GetPrimaryObjectiveColor()
        return self.PrimaryObjectiveColor
    end

    --- @return Color
    function INSTANCE:GetSecondaryObjectiveColor()
        return self.SecondaryObjectiveColor
    end

    --- @return Color
    function INSTANCE:GetTertiaryObjectiveColor()
        return self.TertiaryObjectiveColor
    end
end


--[[ Health Colors ]] do

    --- @return Color
    function INSTANCE:GetHealthHighColor()
        return self.HealthHighColor
    end

    --- @return Color
    function INSTANCE:GetHealthMediumColor()
        return self.HealthMediumColor
    end

    --- @return Color
    function INSTANCE:GetHealthLowColor()
        return self.HealthLowColor
    end
end


--[[ Relationship Colors ]] do

    --- @return Color
    function INSTANCE:GetEnemyColor()
        return self.EnemyColor
    end

    --- @return Color
    function INSTANCE:GetFriendlyColor()
        return self.FriendlyColor
    end

    --- @return Color
    function INSTANCE:GetNoRelationColor()
        return self.NoRelationColor
    end
end

--[[ Misc. Colors ]] do

    --- @return Color
    function INSTANCE:GetReticleBusyColor()
        return self.ReticleBusyColor
    end
end