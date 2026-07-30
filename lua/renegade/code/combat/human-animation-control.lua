-- Based on HumanAnimControlClass within Code/Combat/animcontrol.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type AnimationControlClass
local animationControlClass = CNC.Import( "code/combat/animation-control.lua" )

--- @class HumanAnimationControlClass : AnimationControlClass
--- @field Instance HumanAnimationControlInstance The metatable used by HumanAnimationControlInstance
local STATIC = CNC.CreateExport( animationControlClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HumanAnimationControlClass"

--- @class HumanAnimationControlInstance : AnimationControlInstance
--- @field Static HumanAnimationControlClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HumanAnimationControl : Renegade_AnimationControl" )
INSTANCE.Class = "HumanAnimationControlInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHumanAnimationControl = true

--#region Exported Enums

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	local enumBuilder = enumBuilderClass.New()

    --- @enum AnimationControlAnimationMode
	STATIC.ANIMATION_CONTROL_ANIMATION_MODE = {
		ANIM_MODE_ONCE	 = enumBuilder:Set( 0 ),
		ANIM_MODE_LOOP	 = enumBuilder:Next(),
        ANIM_MODE_STOP   = enumBuilder:Next(),
        ANIM_MODE_TARGET = enumBuilder:Next(),
    }

	--- @enum HumanStateType
	STATIC.HUMAN_STATE_TYPE = {
		-- "Interruptable states"
		UPRIGHT	  = enumBuilder:Set( 0 ),
		LAND	  = enumBuilder:Next(),
		ANIMATION = enumBuilder:Next(),
		WOUNDED	  = enumBuilder:Next(),
		LOITER	  = enumBuilder:Next(),

		-- "Uninterruptable states"
		AIRBORNE            = enumBuilder:Next(),
		DIVE                = enumBuilder:Next(),
		DEATH               = enumBuilder:Next(),
		LADDER              = enumBuilder:Next(),
		IN_VEHICLE          = enumBuilder:Next(),
		TRANSITION          = enumBuilder:Next(),
		TRANSITION_COMPLETE = enumBuilder:Next(),
		DESTROY             = enumBuilder:Next(),
		DEBUG_FLY           = enumBuilder:Next(),
		ON_FIRE             = enumBuilder:Next(),
		ON_CHEM             = enumBuilder:Next(),
		ON_ELECTRIC         = enumBuilder:Next(),
		ON_CNC_FIRE         = enumBuilder:Next(),
		ON_CNC_CHEM         = enumBuilder:Next(),
		LOCKED_ANIMATION    = enumBuilder:Next(),

		HIGHEST_HUMAN_STATE = -1
	}
	local humanStateTypeEnum = STATIC.HUMAN_STATE_TYPE
	humanStateTypeEnum.HIGHEST_HUMAN_STATE = humanStateTypeEnum.LOCKED_ANIMATION

	--- @enum HumanStateFlagsType
	STATIC.HUMAN_STATE_FLAGS_TYPE = {
        CROUCHED_FLAG = bit.lshift( 1, 0 ),
        SNIPING_FLAG  = bit.lshift( 1, 1 ),
        HIGHEST_HUMAN_STATE_FLAGS = bit.lshift( 1, 2 ) - 1,
	}
    local humanStateFlagsType = STATIC.HUMAN_STATE_FLAGS_TYPE

	--- @enum HumanSubStateType
	STATIC.HUMAN_SUB_STATE_TYPE = {
        SUB_STATE_FORWARD       = bit.lshift( 1, 0 ),
        SUB_STATE_BACKWARD      = bit.lshift( 1, 1 ),
        SUB_STATE_UP            = bit.lshift( 1, 2 ),
        SUB_STATE_DOWN          = bit.lshift( 1, 3 ),
        SUB_STATE_LEFT          = bit.lshift( 1, 4 ),
        SUB_STATE_RIGHT         = bit.lshift( 1, 5 ),
        SUB_STATE_TURN_LEFT     = bit.lshift( 1, 6 ),
        SUB_STATE_TURN_RIGHT    = bit.lshift( 1, 7 ),
        SUB_STATE_SLOW          = bit.lshift( 1, 8 ),
        HIGHEST_HUMAN_SUB_STATE = bit.lshift( 1, 9 ) - 1
	}
    local humanSubStateType = STATIC.HUMAN_SUB_STATE_TYPE

	--- @enum HumanOuchType
	STATIC.HUMAN_OUCH_TYPE = {
        HEAD_FROM_BEHIND      = enumBuilder:Set( 0 ),
        HEAD_FROM_FRONT       = enumBuilder:Next(),
        TORSO_FROM_BEHIND     = enumBuilder:Next(),
        TORSO_FROM_FRONT      = enumBuilder:Next(),
        LEFT_ARM_FROM_BEHIND  = enumBuilder:Next(),
        LEFT_ARM_FROM_FRONT   = enumBuilder:Next(),
        RIGHT_ARM_FROM_BEHIND = enumBuilder:Next(),
        RIGHT_ARM_FROM_FRONT  = enumBuilder:Next(),
        LEFT_LEG_FROM_BEHIND  = enumBuilder:Next(),
        LEFT_LEG_FROM_FRONT   = enumBuilder:Next(),
        RIGHT_LEG_FROM_BEHIND = enumBuilder:Next(),
        RIGHT_LEG_FROM_FRONT  = enumBuilder:Next(),
        GROIN                 = enumBuilder:Next(),
        OUCH_FIRE             = enumBuilder:Next(),
        OUCH_CHEM             = enumBuilder:Next(),
        OUCH_ELECTRIC         = enumBuilder:Next(),
        OUCH_SUPER_FIRE       = enumBuilder:Next(),
	}
    local humanOuchType = STATIC.HUMAN_OUCH_TYPE

    --- @enum HumanAnimationLegStyle
    STATIC.HUMAN_ANIM_LEG_STYLE = {
        LEG_STYLE_STAND                = enumBuilder:Set( 0 ), -- "A0"
        LEG_STYLE_RUN_FORWARD          = enumBuilder:Next(), -- "A1"
        LEG_STYLE_RUN_BACKWARD         = enumBuilder:Next(), -- "A2"
        LEG_STYLE_RUN_LEFT             = enumBuilder:Next(), -- "A3"
        LEG_STYLE_RUN_RIGHT            = enumBuilder:Next(), -- "A4"
        LEG_STYLE_TURN_LEFT            = enumBuilder:Next(), -- "A5"
        LEG_STYLE_TURN_RIGHT           = enumBuilder:Next(), -- "A6"
        LEG_STYLE_WALK_FORWARD         = enumBuilder:Next(), -- "B1"
        LEG_STYLE_WALK_BACKWARD        = enumBuilder:Next(), -- "B2"
        LEG_STYLE_WALK_LEFT            = enumBuilder:Next(), -- "B3"
        LEG_STYLE_WALK_RIGHT           = enumBuilder:Next(), -- "B4"
        LEG_STYLE_CROUCH               = enumBuilder:Next(), -- "C0"
        LEG_STYLE_CROUCH_MOVE_FORWARD  = enumBuilder:Next(), -- "C1"
        LEG_STYLE_CROUCH_MOVE_BACKWARD = enumBuilder:Next(), -- "C2"
        LEG_STYLE_CROUCH_MOVE_LEFT     = enumBuilder:Next(), -- "C3"
        LEG_STYLE_CROUCH_MOVE_RIGHT    = enumBuilder:Next(), -- "C4"
        LEG_STYLE_CROUCH_TURN_LEFT     = enumBuilder:Next(), -- "C3"
        LEG_STYLE_CROUCH_TURN_RIGHT    = enumBuilder:Next(), -- "C4"
        LEG_STYLE_JUMP_UP              = enumBuilder:Next(), -- "D0"
        LEG_STYLE_JUMP_FORWARD         = enumBuilder:Next(), -- "D1"
        LEG_STYLE_JUMP_BACKWARD        = enumBuilder:Next(), -- "D2"
        LEG_STYLE_JUMP_LEFT            = enumBuilder:Next(), -- "D3"
        LEG_STYLE_JUMP_RIGHT           = enumBuilder:Next(), -- "D4"
    }
    local humanAnimationLegStyle = STATIC.HUMAN_ANIM_LEG_STYLE

--#endregion

--#region Imports

	--- @type HAnimationComboClass
	local hAnimationComboClass = CNC.Import( "code/ww3d2/h-animation-combo.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HumanAnimationControlClass

    STATIC.LegAnimationNames = {
        "A0", --- "LEG_STYLE_STAND"
        "A1", --- "LEG_STYLE_RUN_FORWARD"
        "A2", --- "LEG_STYLE_RUN_BACKWARD"
        "A3", --- "LEG_STYLE_RUN_LEFT"
        "A4", --- "LEG_STYLE_RUN_RIGHT"
        "A5", --- "LEG_STYLE_TURN_LEFT"
        "A6", --- "LEG_STYLE_TURN_RIGHT"
        "B1", --- "LEG_STYLE_WALK_FORWARD"
        "B2", --- "LEG_STYLE_WALK_BACKWARD"
        "B3", --- "LEG_STYLE_WALK_LEFT"
        "B4", --- "LEG_STYLE_WALK_RIGHT"
        "C0", --- "LEG_STYLE_CROUCH"
        "C1", --- "LEG_STYLE_CROUCH_MOVE_FORWARD"
        "C2", --- "LEG_STYLE_CROUCH_MOVE_BACKWARD"
        "C3", --- "LEG_STYLE_CROUCH_MOVE_LEFT"
        "C4", --- "LEG_STYLE_CROUCH_MOVE_RIGHT"
        "C5", --- "LEG_STYLE_CROUCH_TURN_LEFT"
        "C6", --- "LEG_STYLE_CROUCH_TURN_RIGHT"
        "J0", --- "LEG_STYLE_JUMP_UP"
        "J1", --- "LEG_STYLE_JUMP_FORWARD"
        "J2", --- "LEG_STYLE_JUMP_BACKWARD"
        "J3", --- "LEG_STYLE_JUMP_LEFT"
        "J4", --- "LEG_STYLE_JUMP_RIGHT"
    }

    STATIC.WeaponStyleNames = {
        "A0", --- "WEAPON_HOLD_STYLE_C4"
        "A0", --- "WEAPON_HOLD_STYLE_NOT_USED"
        "C2", --- "WEAPON_HOLD_STYLE_AT_SHOULDER"
        "D2", --- "WEAPON_HOLD_STYLE_AT_HIP"
        "E2", --- "WEAPON_HOLD_STYLE_LAUNCHER"
        "F2", --- "WEAPON_HOLD_STYLE_HANDGUN"
        "A0", --- "WEAPON_HOLD_STYLE_BEACO"
        "A0", --- "WEAPON_HOLD_STYLE_EMPTY_HANDS"
        "B0", --- "WEAPON_HOLD_STYLE_AT_CHEST"
        "A0", --- "WEAPON_HOLD_STYLE_HANDS_DOWN"
    }

    STATIC.DiveAnimations = {
        -- "Forwrd Anims"
		"S_A_HUMAN.H_A_SLD1_01",
		"S_A_HUMAN.H_A_SLD1_02",

        -- "Backward anims"
        "S_A_HUMAN.H_A_SLD2_01",
        "S_A_HUMAN.H_A_SLD2_02",

        -- "Left anims"
        "S_A_HUMAN.H_A_SLD3_01",
        "S_A_HUMAN.H_A_SLD3_02",

        -- "Right Anims"
        "S_A_HUMAN.H_A_SLD4_01",
        "S_A_HUMAN.H_A_SLD4_02",
    }

    STATIC.WoundAnimations = {
        "S_A_HUMAN.H_A_811A",	-- "HEAD_FROM_BEHIND"       
        "S_A_HUMAN.H_A_812A",	-- "HEAD_FROM_FRONT"        
        "S_A_HUMAN.H_A_821A",	-- "TORSO_FROM_BEHIND"      
        "S_A_HUMAN.H_A_822A",	-- "TORSO_FROM_FRONT"       
        "S_A_HUMAN.H_A_831A",	-- "LEFT_ARM_FROM_BEHIND"   
        "S_A_HUMAN.H_A_832A",	-- "LEFT_ARM_FROM_FRONT"    
        "S_A_HUMAN.H_A_841A",	-- "RIGHT_ARM_FROM_BEHIND"  
        "S_A_HUMAN.H_A_842A",	-- "RIGHT_ARM_FROM_FRONT"   
        "S_A_HUMAN.H_A_851A",	-- "LEFT_LEG_FROM_BEHIND"   
        "S_A_HUMAN.H_A_852A",	-- "LEFT_LEG_FROM_FRONT"    
        "S_A_HUMAN.H_A_861A",	-- "RIGHT_LEG_FROM_BEHIND"  
        "S_A_HUMAN.H_A_862A",	-- "RIGHT_LEG_FROM_FRONT"   
        "S_A_HUMAN.H_A_871A",	-- "GROIN"                  
    }

    STATIC.DeathAnimations = {
        "S_A_HUMAN.H_A_622A",	-- "HEAD_FROM_BEHIND"
        "S_A_HUMAN.H_A_635A",	-- "HEAD_FROM_FRONT"
        "S_A_HUMAN.H_A_622A",	-- "TORSO_FROM_BEHIND"
        "S_A_HUMAN.H_A_632A",	-- "TORSO_FROM_FRONT"
        "S_A_HUMAN.H_A_623A",	-- "LEFT_ARM_FROM_BEHIND"
        "S_A_HUMAN.H_A_634A",	-- "LEFT_ARM_FROM_FRONT"
        "S_A_HUMAN.H_A_624A",	-- "RIGHT_ARM_FROM_BEHIND"
        "S_A_HUMAN.H_A_633A",	-- "RIGHT_ARM_FROM_FRONT"
        "S_A_HUMAN.H_A_623A",	-- "LEFT_LEG_FROM_BEHIND"
        "S_A_HUMAN.H_A_634A",	-- "LEFT_LEG_FROM_FRONT"
        "S_A_HUMAN.H_A_624A",	-- "RIGHT_LEG_FROM_BEHIND"
        "S_A_HUMAN.H_A_633A",	-- "RIGHT_LEG_FROM_FRONT"
        "S_A_HUMAN.H_A_612A",	-- "GROIN"
        "S_A_HUMAN.H_A_FLMB",	-- "ON_FIRE"
        "S_A_HUMAN.H_A_FLMB",	-- "ON_CHEM"
        "S_A_HUMAN.H_A_FLMB",	-- "ON_ELECTRIC"
        "S_A_HUMAN.H_A_FLMB",	-- "ON_CNC_FIRE"
        "S_A_HUMAN.H_A_FLMB",	-- "ON_CNC_CHEM"
    }

    --- Creates a new HumanAnimationControlInstance
    --- @return HumanAnimationControlInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HumanAnimationControl" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HumanAnimationControlInstance, `false` otherwise
    function STATIC.IsHumanAnimationControl( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHumanAnimationControl and true or false
    end

    typecheck.RegisterType( "HumanAnimationControlInstance", STATIC.IsHumanAnimationControl )
end


--- @class HumanAnimationControlInstance
--- @field Channel1 any
--- @field Channel2 any
--- @field Channel2Ratio number
--- @field AnimationSpeedScale number
--- @field DataList any
--- @field AnimationCombo any
--- @field Skeleton string

function INSTANCE:Renegade_HumanAnimationControl()
    animationControlClass.Instance.Renegade_AnimationControl( self )

    self.AnimationCombo = hAnimationComboClass.New( 2 )
    self.Channel2Ratio = 0
    self.Skeleton = "A"
    self.AnimationSpeedScale = 1
end

function INSTANCE:_Renegade_HumanAnimationControl()
    -- Empty in the original code
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:SetModel()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMode()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMode()
	typecheck.NotImplementedError()
end

function INSTANCE:IsComplete()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAnimationName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetProgress()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTargetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTargetFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCurrentFrame()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimationSpeedScale()
	typecheck.NotImplementedError()
end

function INSTANCE:Update()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetInformation()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSkeleton()
	typecheck.NotImplementedError()
end

function INSTANCE:BuildSkeletonAnimationName()
	typecheck.NotImplementedError()
end
