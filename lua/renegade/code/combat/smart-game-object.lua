-- Based on SmartGameObj within Code/Combat/smartgameobj.h

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
		--- @field GlobalSightRangeScale any

    --- Creates a new SmartGameObjectInstance
    --- @return SmartGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SmartGameObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SmartGameObjectInstance, `false` otherwise
    function STATIC.IsSmartGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSmartGameObject and true or false
    end

    typecheck.RegisterType( "SmartGameObjectInstance", STATIC.IsSmartGameObject )

	function STATIC.GetGlobalSightRangeScale()
		typecheck.NotImplementedError()
	end

	function STATIC.SetGlobalSightRangeScale()
		typecheck.NotImplementedError()
	end
end


--- @class SmartGameObjectInstance
--- @field Control any
--- @field Controller any
--- @field ControlEnabled any
--- @field StealthEnabled any
--- @field StealthPowerupTimer any
--- @field StealthFiringTimer any
--- @field StealthEffect any
--- @field Action any
--- @field ControlOwner any
--- @field PlayerData any
--- @field IsEnemySeenEnabled any
--- @field MovingSoundTimer any
--- @field Listener any

function INSTANCE:Renegade_SmartGameObject()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_SmartGameObject()
	typecheck.NotImplementedError()
end

function INSTANCE:Init()
	typecheck.NotImplementedError()
end

function INSTANCE:CopySettings()
	typecheck.NotImplementedError()
end

function INSTANCE:ReInit()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDefinition()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:OnPostLoad()
	typecheck.NotImplementedError()
end

function INSTANCE:ClearControl()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBooleanControl()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnalogControl()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportControlCs()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportControlCs()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportControlSc()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportControlSc()
	typecheck.NotImplementedError()
end

function INSTANCE:GetControl()
	typecheck.NotImplementedError()
end

function INSTANCE:ControlEnable()
	typecheck.NotImplementedError()
end

function INSTANCE:IsControlEnabled()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetController()
	typecheck.NotImplementedError()
end

function INSTANCE:GenerateControl()
	typecheck.NotImplementedError()
end

function INSTANCE:GetControlOwner()
	typecheck.NotImplementedError()
end

function INSTANCE:GetWeaponControlOwner()
	typecheck.NotImplementedError()
end

function INSTANCE:SetControlOwner()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPlayerData()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPlayerData()
	typecheck.NotImplementedError()
end

function INSTANCE:HasPlayer()
	typecheck.NotImplementedError()
end

function INSTANCE:IsHumanControlled()
	typecheck.NotImplementedError()
end

function INSTANCE:IsControlledByMe()
	typecheck.NotImplementedError()
end

function INSTANCE:ApplyControl()
	typecheck.NotImplementedError()
end

function INSTANCE:Think()
	typecheck.NotImplementedError()
end

function INSTANCE:PostThink()
	typecheck.NotImplementedError()
end

function INSTANCE:ApplyDamage()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaxSpeed()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTurnRate()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAction()
	typecheck.NotImplementedError()
end

function INSTANCE:AsSmartGameObject()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportFrequent()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportFrequent()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportStateCs()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportStateCs()
	typecheck.NotImplementedError()
end

function INSTANCE:ExportCreation()
	typecheck.NotImplementedError()
end

function INSTANCE:ImportCreation()
	typecheck.NotImplementedError()
end

function INSTANCE:IsControlDataDirty()
	typecheck.NotImplementedError()
end

function INSTANCE:IsObjectVisible()
	typecheck.NotImplementedError()
end

function INSTANCE:SetEnemySeenEnabled()
	typecheck.NotImplementedError()
end

function INSTANCE:IsEnemySeenEnabled()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLookTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:IsVisible()
	typecheck.NotImplementedError()
end

function INSTANCE:OnLogicalHeard()
	typecheck.NotImplementedError()
end

function INSTANCE:BeginHibernation()
	typecheck.NotImplementedError()
end

function INSTANCE:EndHibernation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetInformation()
	typecheck.NotImplementedError()
end

function INSTANCE:EnableStealth()
	typecheck.NotImplementedError()
end

function INSTANCE:ToggleStealth()
	typecheck.NotImplementedError()
end

function INSTANCE:IsStealthEnabled()
	typecheck.NotImplementedError()
end

function INSTANCE:IsStealthed()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStealthFadeDistance()
	typecheck.NotImplementedError()
end

function INSTANCE:GrantStealthPowerup()
	typecheck.NotImplementedError()
end

function INSTANCE:RemainingStealthPowerupTime()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekStealthEffect()
	typecheck.NotImplementedError()
end

function INSTANCE:AllocStealthEffect()
	typecheck.NotImplementedError()
end

function INSTANCE:RegisterListener()
	typecheck.NotImplementedError()
end
