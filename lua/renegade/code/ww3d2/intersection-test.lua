-- Based on IntersectionTestClass within Code/ww3d2/inttest.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class IntersectionTestClass
--- @field Instance IntersectionTestInstance The metatable used by IntersectionTestInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "IntersectionTestClass"

--- @class IntersectionTestInstance
--- @field Static IntersectionTestClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_IntersectionTest" )
INSTANCE.Class = "IntersectionTestInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsIntersectionTest = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class IntersectionTestClass

    --- Creates a new IntersectionTestInstance
    --- @return IntersectionTestInstance
    function STATIC.New()
        return robustclass.New( "Renegade_IntersectionTest" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) IntersectionTestInstance, `false` otherwise
    function STATIC.IsIntersectionTest( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsIntersectionTest and true or false
    end

    typecheck.RegisterType( "IntersectionTestInstance", STATIC.IsIntersectionTest )
end


--- @class IntersectionTestInstance
--- @field CollisionType integer

--- @param collisionType integer
--- @overload fun( self, src: IntersectionTestInstance )
function INSTANCE:Renegade_IntersectionTest( collisionType )
    -- ( collisionType: integer )
    if typecheck.IsOfType( collisionType, "number" ) then
        self.CollisionType = collisionType
        return
    end

    -- ( src: IntersectionTestInstance )
    typecheck.AssertArgType( INSTANCE.Class, 1, collisionType, "IntersectionTestInstance" )
    local src = collisionType --[[@as IntersectionTestInstance]]

    self.CollisionType = src.CollisionType
end
