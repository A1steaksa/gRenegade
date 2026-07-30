-- Based on OBBoxIntersectionTestClass within Code/ww3d2/inttest.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type IntersectionTestClass
local intersectionTestClass = CNC.Import( "code/ww3d2/intersection-test.lua" )

--- @class OBBoxIntersectionTestClass : IntersectionTestClass
--- @field Instance OBBoxIntersectionTestInstance The metatable used by OBBoxIntersectionTestInstance
local STATIC = CNC.CreateExport( intersectionTestClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "OBBoxIntersectionTestClass"

--- @class OBBoxIntersectionTestInstance : IntersectionTestInstance
--- @field Static OBBoxIntersectionTestClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_OBBoxIntersectionTest : Renegade_IntersectionTest" )
INSTANCE.Class = "OBBoxIntersectionTestInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsOBBoxIntersectionTest = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class OBBoxIntersectionTestClass

    --- Creates a new OBBoxIntersectionTestInstance
    --- @return OBBoxIntersectionTestInstance
    function STATIC.New()
        return robustclass.New( "Renegade_OBBoxIntersectionTest" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) OBBoxIntersectionTestInstance, `false` otherwise
    function STATIC.IsOBBoxIntersectionTest( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsOBBoxIntersectionTest and true or false
    end

    typecheck.RegisterType( "OBBoxIntersectionTestInstance", STATIC.IsOBBoxIntersectionTest )
end


--- @class OBBoxIntersectionTestInstance
--- @field Box OBBoxInstance "World space obbox that we want to test with"
--- @field BoundingBox AABoxInstance "Axis aligned w-s bounding box"

--- @param box OBBoxInstance
--- @param collisionType integer
--- @overload fun( src: OBBoxIntersectionTestInstance )
--- @overload fun( src: OBBoxIntersectionTestInstance, transformationMatrix: Matrix3dInstance )
--- @overload fun( src: AABoxIntersectionTestInstance, transformationMatrix: Matrix3dInstance )
function INSTANCE:Renegade_OBBoxIntersectionTest( box, collisionType )
	typecheck.NotImplementedError()
end

function INSTANCE:Renegade_OBBoxIntersectionTest()
	typecheck.NotImplementedError()
end

function INSTANCE:Cull()
	typecheck.NotImplementedError()
end

function INSTANCE:IntersectTriangle()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateBoundingBox()
	typecheck.NotImplementedError()
end
