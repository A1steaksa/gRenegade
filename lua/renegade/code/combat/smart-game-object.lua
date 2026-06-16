-- Based on SmartGameObj within Code/Combat/smartgameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ArmedGameObjectClass
local armedGameObjectClass = CNC.Import( "code/combat/armed-game-object.lua" )

--- @class SmartGameObjectClass : ArmedGameObjectClass
--- @field Instance SmartGameObjectInstance The metatable used by SmartGameObjectInstance
local STATIC = CNC.CreateExport( armedGameObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SmartGameObjectClass"
--- @class SmartGameObjectInstance : ArmedGameObjectInstance
--- @field Static SmartGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SmartGameObject : Renegade_ArmedGameObject" )
INSTANCE.Class = "SmartGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSmartGameObject = true

--#region Exported Enums

--#endregion


--#region Imports
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--#region Imported Enums
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        OLD_CHUNKID_PHYSICALGAMEOBJ_PARENT = enumBuilder:Set( 910991113 ),
        CHUNKID_VARIABLES                  = enumBuilder:Next(),
        CHUNKID_CONTROL                    = enumBuilder:Next(),
        CHUNKID_CONTROLLER                 = enumBuilder:Next(),
        CHUNKID_ACTION                     = enumBuilder:Next(),
        XXXCHUNKID_WEAPONBAG               = enumBuilder:Next(),
        CHUNKID_ARMEDGAMEOBJ_PARENT        = enumBuilder:Next(),
        XXXCHUNKID_PLAYER_DATA             = enumBuilder:Next(),
        CHUNKID_STEALTH_EFFECT             = enumBuilder:Next(),

        MICROCHUNKID_CONTROL_ENABLED    = enumBuilder:Set( 1 ),

        XXXMICROCHUNKID_WEAPON_TILT     = enumBuilder:Next(),
        XXXMICROCHUNKID_WEAPON_TURN     = enumBuilder:Next(),
        MICROCHUNKID_CONTROL_OWNER      = enumBuilder:Next(),
        XXX_MICROCHUNKID_IS_GHOST       = enumBuilder:Next(),
        MICROCHUNKID_IMPORT_STATE_COUNT = enumBuilder:Next(),
        MICROCHUNKID_TINT_COLOR         = enumBuilder:Next(),

        MICROCHUNKID_CONTROLLER_PTR        = enumBuilder:Next(),
        MICROCHUNKID_IS_ENEMY_SEEN_ENABLED = enumBuilder:Next(),
        XXXMICROCHUNKID_TARGETING_POS      = enumBuilder:Next(),
        MICROCHUNKID_MOVING_SOUND_TIMER    = enumBuilder:Next(),
        MICROCHUNKID_PLAYER_DATA           = enumBuilder:Next(),

        MICROCHUNKID_STEALTH_ENABLED       = enumBuilder:Next(),
        MICROCHUNKID_STEALTH_POWERUP_TIMER = enumBuilder:Next(),
        MICROCHUNKID_STEALTH_FIRING_TIMER  = enumBuilder:Next()
    }
end


--[[ Static Functions and Variables ]] do

    --- @class SmartGameObjectClass

    --- Creates a new SmartGameObjectInstance
    --- @vararg any
    --- @return SmartGameObjectInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_SmartGameObject", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SmartGameObjectInstance, `false` otherwise
    function STATIC.IsSmartGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSmartGameObject and true or false
    end

    typecheck.RegisterType( "SmartGameObjectInstance", STATIC.IsSmartGameObject )
end


--- @class SmartGameObjectInstance

--- Constructs a new SmartGameObjectInstance
--- @vararg any
function INSTANCE:Renegade_SmartGameObject( ... )
    armedGameObjectClass.Instance.Renegade_ArmedGameObject( self )

    typecheck.NotImplementedError()
end


--[[ Save / Load ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:Load( cload )
        typecheck.NotImplementedError()
    end
end
