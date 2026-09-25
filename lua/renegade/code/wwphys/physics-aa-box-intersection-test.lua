-- Based on PhysAABoxIntersectionTestClass within Code/wwphys/physinttest.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type AABoxIntersectionTestClass
local aABoxIntersectionTestClass = CNC.Import( "code/ww3d2/aa-box-intersection-test.lua" )

--- @class PhysicsAABoxIntersectionTestClass : AABoxIntersectionTestClass
--- @field Instance PhysicsAABoxIntersectionTestInstance The metatable used by PhysicsAABoxIntersectionTestInstance
local STATIC = CNC.CreateExport( aABoxIntersectionTestClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicsAABoxIntersectionTestClass"

--- @class PhysicsAABoxIntersectionTestInstance : AABoxIntersectionTestInstance
--- @field Static PhysicsAABoxIntersectionTestClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PhysicsAABoxIntersectionTest : Renegade_AABoxIntersectionTest" )
INSTANCE.Class = "PhysicsAABoxIntersectionTestInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysicsAABoxIntersectionTest = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PhysicsAABoxIntersectionTestClass

    --- Creates a new PhysicsAABoxIntersectionTestInstance
    --- @param box any
    --- @param colliisonGroup integer
    --- @param collisionType integer
    --- @param resultList PhysicsInstance[]?
    --- @return PhysicsAABoxIntersectionTestInstance
    function STATIC.New( box, colliisonGroup, collisionType, resultList  )
        return robustclass.New( "Renegade_PhysicsAABoxIntersectionTest", box, colliisonGroup, collisionType, resultList  )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicsAABoxIntersectionTestInstance, `false` otherwise
    function STATIC.IsPhysicsAABoxIntersectionTest( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicsAABoxIntersectionTest and true or false
    end

    typecheck.RegisterType( "PhysicsAABoxIntersectionTestInstance", STATIC.IsPhysicsAABoxIntersectionTest )
end


--- @class PhysicsAABoxIntersectionTestInstance
--- @field CollisionGroup integer
--- @field CheckStaticObjects boolean
--- @field CheckDynamicObjects boolean
--- @field IntersectedObjects PhysicsInstance[]

--- @param box any
--- @param colliisonGroup integer
--- @param collisionType integer
--- @param resultList PhysicsInstance[]?
function INSTANCE:Renegade_PhysicsAABoxIntersectionTest( box, colliisonGroup, collisionType, resultList )
    aABoxIntersectionTestClass.Instance.Renegade_AABoxIntersectionTest( self, box, collisionType )

    self.CollisionGroup = colliisonGroup
    self.IntersectedObjects = resultList or {}
    self.CheckStaticObjects = true
    self.CheckDynamicObjects = true
end

--- @param object PhysicsInstance
function INSTANCE:AddIntersectedObject( object )
	if self.IntersectedObjects then
        self.IntersectedObjects[#self.IntersectedObjects+1] = object
    end
end
