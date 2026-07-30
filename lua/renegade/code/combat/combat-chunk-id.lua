-- Based on the enums within Code/Combat/combatchunkid.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class CombatChunkIdClass
local STATIC = CNC.CreateExport()

--#region Imports

    --- @type EnumBuilderClass
    local enumBaseClass = CNC.Import( "sh_enum-builder.lua" )

    --- @type DefinitionClassIds
    local definitionClassIds = CNC.Import( "code/wwsaveload/definition-class-ids.lua" )

    --- @type SaveLoadIds
    local saveLoadIds = CNC.Import( "code/wwsaveload/save-load-ids.lua" )
--#endregion

local enumBuilder = enumBaseClass.New()

--[[ Chunk IDs ]] do

    STATIC.CHUNKID_COMBAT                                   = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN )

    STATIC.CHUNKID_TIMER                                    = enumBuilder:Next()
    STATIC.CHUNKID_TIMER_GAME_OBJ                           = enumBuilder:Next()
    STATIC.CHUNKID_TIMER_GAME_OBJ_CUSTOM                    = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECTS_BEGIN                       = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN + 0x100 )

    STATIC.CHUNKID_GAME_OBJECT_BULLET                       = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_C4			                = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_C4			            = enumBuilder:Next()

    STATIC.XXXCHUNKID_GAME_OBJECT_COMMANDO			        = enumBuilder:Next()
    STATIC.XXXCHUNKID_GAME_OBJECT_DEF_COMMANDO		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_POWERUP			            = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_POWERUP			        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_SAMSITE			            = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_SAMSITE			        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_SIMPLE			            = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_SIMPLE			        = enumBuilder:Next()

    STATIC.XXXCHUNKID_GAME_OBJECT_SIMPLE3			        = enumBuilder:Next()
    STATIC.XXXCHUNKID_GAME_OBJECT_DEF_SIMPLE3		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_SOLDIER			            = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_SOLDIER			        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_VEHICLE			            = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_VISUAL			            = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_TIMED_VISUAL			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_ANIMATED_VISUAL		        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_PROJECTILE_VISUAL	        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_XXXXXXXXXXXXXXXXX	        = enumBuilder:Next()

    STATIC.XXXCHUNKID_GAME_OBJECT_TANK			            = enumBuilder:Next()
    STATIC.XXXCHUNKID_GAME_OBJECT_DEF_TANK			        = enumBuilder:Next()

    STATIC.XXXCHUNKID_GAME_OBJECT_TURRET			        = enumBuilder:Next()
    STATIC.XXXCHUNKID_GAME_OBJECT_DEF_TURRET		        = enumBuilder:Next()

    STATIC.XXXCHUNKID_GAME_OBJECT_BIKE			            = enumBuilder:Next()
    STATIC.XXXCHUNKID_GAME_OBJECT_DEF_BIKE			        = enumBuilder:Next()

    STATIC.XXXCHUNKID_GAME_OBJECT_FLYING			        = enumBuilder:Next()
    STATIC.XXXCHUNKID_GAME_OBJECT_DEF_FLYING		        = enumBuilder:Next()

    STATIC.XXXCHUNKID_GAME_OBJECT_CAR			            = enumBuilder:Next()
    STATIC.XXXCHUNKID_GAME_OBJECT_DEF_CAR			        = enumBuilder:Next()

    STATIC.CHUNKID_SPAWNER			                        = enumBuilder:Next()
    STATIC.CHUNKID_SPAWNER_DEF			                    = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_SCRIPT_ZONE			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_SCRIPT_ZONE		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_TRANSITION			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_TRANSITION		        = enumBuilder:Next()


    STATIC.CHUNKID_BACKGROUND_MGR		        	        = enumBuilder:Next()
    STATIC.CHUNKID_WEAPON_DEF                               = enumBuilder:Next()
    STATIC.CHUNKID_AMMO_DEF                                 = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_DEF_VEHICLE                  = enumBuilder:Next()

    STATIC.CHUNKID_EXPLOSION_DEF                            = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_CINEMATIC			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_CINEMATIC		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_DAMAGE_ZONE			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_DAMAGE_ZONE		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_SPECIAL_EFFECTS		        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_SPECIAL_EFFECTS	        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_SAKURA_BOSS			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_SAKURA_BOSS		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_BUILDING			            = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_BUILDING			        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_BEACON			            = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_BEACON			        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_REFINERY			            = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_REFINERY			        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_POWERPLANT			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_POWERPLANT		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_SOLDIER_FACTORY		        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_SOLDIER_FACTORY	        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_VEHICLE_FACTORY		        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_VEHICLE_FACTORY	        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_AIRSTRIP			            = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_AIRSTRIP			        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_WARFACTORY			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_WARFACTORY		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_COMCENTER			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_COMCENTER		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_REPAIR_BAY			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_REPAIR_BAY		        = enumBuilder:Next()

    STATIC.CHUNKID_MAPMGR			                        = enumBuilder:Next()
    STATIC.CHUNKID_ENCYCLOPEDIAMGR			                = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_MENDOZA_BOSS			        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_MENDOZA_BOSS		        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_RAVESHAW_BOSS		        = enumBuilder:Next()
    STATIC.CHUNKID_GAME_OBJECT_DEF_RAVESHAW_BOSS	        = enumBuilder:Next()

    STATIC.CHUNKID_GAME_OBJECT_OBSERVERS_BEGIN		        = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN + 0x200 )
    STATIC.CHUNKID_SOLDIER_OBSERVER			                = enumBuilder:Next()
    STATIC.CHUNKID_BEACON_MONITOR			                = enumBuilder:Next()

    STATIC.CHUNKID_BUILDINGS_BEGIN					        = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN + 0x301 )
    STATIC.CHUNKID_BUILDING			                        = enumBuilder:Next()

    STATIC.CHUNKID_BUILDINGS_DEF_BEGIN				        = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN + 0x401 )
    STATIC.CHUNKID_BUILDING_DEF			                    = enumBuilder:Next()

    STATIC.CHUNKID_ACTION_CODE_BEGIN				        = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN + 0x500 )
    STATIC.CHUNKID_ACTION_CODE_FOLLOW_INPUT			        = enumBuilder:Next()
    STATIC.CHUNKID_ACTION_CODE_STAND			            = enumBuilder:Next()
    STATIC.CHUNKID_ACTION_CODE_GOTO			                = enumBuilder:Next()
    STATIC.CHUNKID_ACTION_CODE_ENTER_EXIT			        = enumBuilder:Next()
    STATIC.CHUNKID_ACTION_CODE_ATTACK			            = enumBuilder:Next()
    STATIC.CHUNKID_ACTION_CODE_PLAY_ANIMATION		        = enumBuilder:Next()
    STATIC.CHUNKID_ACTION_CODE_FACE_LOCATION		        = enumBuilder:Next()
    STATIC.CHUNKID_ACTION_CODE_DIVE			                = enumBuilder:Next()
    STATIC.CHUNKID_ACTION_CODE_CONVERSATION			        = enumBuilder:Next()
    STATIC.CHUNKID_ACTION_CODE_DOCK			                = enumBuilder:Next()

    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF				        = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN + 0x600 )
    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF_HUMAN_LOITER	        = enumBuilder:Next()
    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF_GENERAL		        = enumBuilder:Next()
    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF_HUD			        = enumBuilder:Next()
    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF_EVA			        = enumBuilder:Next()
    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF_CHAR_CLASS	        = enumBuilder:Next()
    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF_HUMAN_ANIM_OVERRIDE  = enumBuilder:Next()
    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF_PURCHASE		        = enumBuilder:Next()
    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF_TEAM_PURCHASE        = enumBuilder:Next()
    STATIC.CHUNKID_GLOBAL_SETTINGS_DEF_CNCMODE			    = enumBuilder:Next()

    STATIC.CHUNKID_CONVERSATION_MGR					        = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN + 0x700 )

    STATIC.CHUNKID_WEATHER_MGR							    = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN + 0x800 )

    STATIC.CHUNKID_PLAYER_DATA							    = enumBuilder:Set( saveLoadIds.ChunkIds.CHUNKID_COMBAT_BEGIN + 0x900 )
    STATIC.CHUNKID_PLAYER_DATA_CPLAYER			            = enumBuilder:Next()
end


--[[ Entity Class IDs ]] do

    STATIC.CLASSID_GAME_OBJECT_DEF_SOLDIER          = enumBuilder:Set( definitionClassIds.CLASS_ID.GAME_OBJECTS + 1 )
	STATIC.XXXCLASSID_GAME_OBJECT_DEF_COMMANDO      = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_POWERUP          = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_SIMPLE           = enumBuilder:Next()
	STATIC.XXXCLASSID_GAME_OBJECT_DEF_SIMPLE3       = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_C4               = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_SAMSITE          = enumBuilder:Next()
	STATIC.XXCLASSID_GAME_OBJECT_DEF_TANK           = enumBuilder:Next()
	STATIC.XXCLASSID_GAME_OBJECT_DEF_TURRET         = enumBuilder:Next()
	STATIC.XXCLASSID_GAME_OBJECT_DEF_BIKE           = enumBuilder:Next()
	STATIC.XXCLASSID_GAME_OBJECT_DEF_FLYING         = enumBuilder:Next()
	STATIC.XXCLASSID_GAME_OBJECT_DEF_CAR            = enumBuilder:Next()

	STATIC.CLASSID_SPAWNER_DEF                      = enumBuilder:Next()

	STATIC.CLASSID_GAME_OBJECT_DEF_SCRIPT_ZONE      = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_TRANSITION       = enumBuilder:Next()

	STATIC.CLASSID_GAME_OBJECT_DEF_VEHICLE           = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_CINEMATIC         = enumBuilder:Next()

	STATIC.CLASSID_GAME_OBJECT_DEF_DAMAGE_ZONE      = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_SPECIAL_EFFECTS  = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_SAKURA_BOSS      = enumBuilder:Next()
	STATIC.XXXCLASSID_GAME_OBJECT_DEF_BUILDING      = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_BEACON           = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_MENDOZA_BOSS     = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_RAVESHAW_BOSS    = enumBuilder:Next()
end


--[[ Munitions Class IDs ]] do

    STATIC.CLASSID_DEF_WEAPON      = enumBuilder:Set( definitionClassIds.CLASS_ID.MUNITIONS + 1 )
	STATIC.CLASSID_DEF_AMMO        = enumBuilder:Next()
	STATIC.CLASSID_DEF_EXPLOSION   = enumBuilder:Next()
end


--[[ Building Class IDs ]] do

    STATIC.CLASSID_GAME_OBJECT_DEF_BUILDING         = enumBuilder:Set( definitionClassIds.CLASS_ID.BUILDINGS + 1 )

	STATIC.CLASSID_GAME_OBJECT_DEF_REFINERY         = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_POWERPLANT       = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_SOLDIER_FACTORY  = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_VEHICLE_FACTORY  = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_AIRSTRIP         = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_WARFACTORY       = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_COMCENTER        = enumBuilder:Next()
	STATIC.CLASSID_GAME_OBJECT_DEF_REPAIR_BAY       = enumBuilder:Next()
end


--[[ GlobalSettings Class IDs ]] do

    STATIC.CLASSID_GLOBAL_SETTINGS_DEF                      = enumBuilder:Set( definitionClassIds.CLASS_ID.GLOBAL_SETTINGS + 1 )
	STATIC.CLASSID_GLOBAL_SETTINGS_DEF_HUMAN_LOITER         = enumBuilder:Next()
	STATIC.CLASSID_GLOBAL_SETTINGS_DEF_GENERAL              = enumBuilder:Next()
	STATIC.CLASSID_GLOBAL_SETTINGS_DEF_HUD                  = enumBuilder:Next()
	STATIC.CLASSID_GLOBAL_SETTINGS_DEF_EVA                  = enumBuilder:Next()
	STATIC.CLASSID_GLOBAL_SETTINGS_DEF_CHAR_CLASS           = enumBuilder:Next()
	STATIC.CLASSID_GLOBAL_SETTINGS_DEF_HUMAN_ANIM_OVERRIDE  = enumBuilder:Next()
	STATIC.CLASSID_GLOBAL_SETTINGS_DEF_PURCHASE             = enumBuilder:Next()
	STATIC.CLASSID_GLOBAL_SETTINGS_DEF_TEAM_PURCHASE        = enumBuilder:Next()
	STATIC.CLASSID_GLOBAL_SETTINGS_DEF_CNCMODE              = enumBuilder:Next()
end