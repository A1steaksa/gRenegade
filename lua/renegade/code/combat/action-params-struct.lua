-- Based on ActionParamsStruct within Code/Combat/actionparams.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ActionParamsStructClass
--- @field Instance ActionParamsStructInstance The metatable used by ActionParamsStructInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ActionParamsStructClass"

--- @class ActionParamsStructInstance
--- @field Static ActionParamsStructClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ActionParamsStruct" )
INSTANCE.Class = "ActionParamsStructInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsActionParamsStruct = true

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum SoldierAiState
    STATIC.SoldierAiState = {
        NO_AI_STATE_CHANGE      = enumBuilder:Set( -1 ),
        AI_STATE_IDLE           = enumBuilder:Set( 0 ),
        AI_STATE_SECONDARY_IDLE = enumBuilder:Next(),
        AI_STATE_SEARCH         = enumBuilder:Next(),
        AI_STATE_COMBAT         = enumBuilder:Next()
    }
    local soldierAiStateEnum = STATIC.SoldierAiState
--#endregion

--#region Imports

--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ActionParamsStructClass

    --- Creates a new ActionParamsStructInstance
    --- @return ActionParamsStructInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ActionParamsStruct" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ActionParamsStructInstance, `false` otherwise
    function STATIC.IsActionParamsStruct( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsActionParamsStruct and true or false
    end

    typecheck.RegisterType( "ActionParamsStructInstance", STATIC.IsActionParamsStruct )
end


--- @class ActionParamsStructInstance
--- @field Priority any
--- @field ActionID any
--- @field ObserverID any
--- @field LookLocation any
--- @field LookObject any
--- @field LookDuration any
--- @field MoveLocation any
--- @field MoveObject any
--- @field MoveObjectOffset any
--- @field MoveSpeed any
--- @field MoveArrivedDistance any
--- @field MoveBackup any
--- @field MoveFollow any
--- @field MoveCrouched any
--- @field MovePathfind any
--- @field ShutdownEngineOnArrival any
--- @field AttackRange any
--- @field AttackError any
--- @field AttackErrorOverride any
--- @field AttackObject any
--- @field AttackPrimaryFire any
--- @field AttackCrouched any
--- @field AttackLocation any
--- @field AttackCheckBlocked any
--- @field AttackActive any
--- @field AttackWanderAllowed any
--- @field AttackFaceTarget any
--- @field AttackForceFire any
--- @field ForceFacing any
--- @field FaceLocation any
--- @field FaceDuration any
--- @field IgnoreFacing any
--- @field WaypathID any
--- @field WaypointStartID any
--- @field WaypointEndID any
--- @field WaypathSplined any
--- @field AnimationName any
--- @field AnimationLooping any
--- @field ActiveConversationID any
--- @field ConversationName any
--- @field AiState any
--- @field DockLocation any
--- @field DockEntrance any

function INSTANCE:Renegade_ActionParamsStruct()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBasic()
	typecheck.NotImplementedError()
end

function INSTANCE:SetLook()
	typecheck.NotImplementedError()
end

function INSTANCE:SetLook()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMovement()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAttack()
	typecheck.NotImplementedError()
end

function INSTANCE:SetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:SetFaceLocation()
	typecheck.NotImplementedError()
end

function INSTANCE:JoinConversation()
	typecheck.NotImplementedError()
end

function INSTANCE:StartConversation()
	typecheck.NotImplementedError()
end

function INSTANCE:DockVehicle()
	typecheck.NotImplementedError()
end
