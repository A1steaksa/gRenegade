-- Based on PhysControllerClass within Code/wwphys/physcontrol.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class PhysicsControllerClass
--- @field Instance PhysicsControllerInstance The metatable used by PhysicsControllerInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicsControllerClass"

--- @class PhysicsControllerInstance
--- @field Static PhysicsControllerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PhysicsController" )
INSTANCE.Class = "PhysicsControllerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysicsController = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PhysicsControllerClass

    --- Creates a new PhysicsControllerInstance
    --- @return PhysicsControllerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PhysicsController" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicsControllerInstance, `false` otherwise
    function STATIC.IsPhysicsController( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicsController and true or false
    end

    typecheck.RegisterType( "PhysicsControllerInstance", STATIC.IsPhysicsController )
end

--- "  
--- This is an object which abstractly describes the control state
--- for a physics object.
---
---  PhysControllers are not persistant objects on their own but they
---  do provide a save and load method so that you can embed them in
---  another object if you want to.
--- "  
--- @class PhysicsControllerInstance
--- @field MoveVector Vector
--- @field TurnLeft number

function INSTANCE:Renegade_PhysicsController()
	typecheck.NotImplementedError()
end

function INSTANCE:Reset()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMoveForward()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMoveLeft()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMoveUp()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTurnLeft()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMoveForward()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMoveLeft()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMoveUp()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTurnLeft()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetMove()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMoveVector()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetTurn()
	typecheck.NotImplementedError()
end

function INSTANCE:IsInactive()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end
