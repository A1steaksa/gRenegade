-- Based on ActionClass within Code/Combat/action.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ActionClass
--- @field Instance ActionInstance The metatable used by ActionInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ActionClass"

--- @class ActionInstance
--- @field Static ActionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Action" )
INSTANCE.Class = "ActionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAction = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ActionClass

    --- Creates a new ActionInstance
    --- @return ActionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Action" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ActionInstance, `false` otherwise
    function STATIC.IsAction( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAction and true or false
    end

    typecheck.RegisterType( "ActionInstance", STATIC.IsAction )
end


--- @class ActionInstance
--- @field ActionObject any
--- @field ActionCode any
--- @field Parameters any
--- @field IsPaused any
--- @field ActCount any

function INSTANCE:Renegade_Action()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_Action()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:GetActionObject()
	typecheck.NotImplementedError()
end

function INSTANCE:GetParameters()
	typecheck.NotImplementedError()
end

function INSTANCE:IsActing()
	typecheck.NotImplementedError()
end

function INSTANCE:IsAnimating()
	typecheck.NotImplementedError()
end

function INSTANCE:BeginHibernation()
	typecheck.NotImplementedError()
end

function INSTANCE:EndHibernation()
	typecheck.NotImplementedError()
end

function INSTANCE:Reset()
	typecheck.NotImplementedError()
end

function INSTANCE:FollowInput()
	typecheck.NotImplementedError()
end

function INSTANCE:Stand()
	typecheck.NotImplementedError()
end

function INSTANCE:PlayAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:Goto()
	typecheck.NotImplementedError()
end

function INSTANCE:EnterExit()
	typecheck.NotImplementedError()
end

function INSTANCE:Dive()
	typecheck.NotImplementedError()
end

function INSTANCE:Attack()
	typecheck.NotImplementedError()
end

function INSTANCE:FaceLocation()
	typecheck.NotImplementedError()
end

function INSTANCE:HaveConversation()
	typecheck.NotImplementedError()
end

function INSTANCE:DockVehicle()
	typecheck.NotImplementedError()
end

function INSTANCE:Modify()
	typecheck.NotImplementedError()
end

function INSTANCE:Act()
	typecheck.NotImplementedError()
end

function INSTANCE:GetActCount()
	typecheck.NotImplementedError()
end

function INSTANCE:IsActive()
	typecheck.NotImplementedError()
end

function INSTANCE:IsBusy()
	typecheck.NotImplementedError()
end

function INSTANCE:IsPaused()
	typecheck.NotImplementedError()
end

function INSTANCE:Pause()
	typecheck.NotImplementedError()
end

function INSTANCE:Done()
	typecheck.NotImplementedError()
end

function INSTANCE:NotifyCompleted()
	typecheck.NotImplementedError()
end

function INSTANCE:RequestAction()
	typecheck.NotImplementedError()
end

function INSTANCE:SetActionCode()
	typecheck.NotImplementedError()
end
