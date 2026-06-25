-- Based on AABoxIntersectionTestClass within Code/ww3d2/inttest.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type IntersectionTestClass
local intersectionTestClass = CNC.Import( "code/ww3d2/intersection-test.lua" )

--- @class AABoxIntersectionTestClass : IntersectionTestClass
--- @field Instance AABoxIntersectionTestInstance The metatable used by AABoxIntersectionTestInstance
local STATIC = CNC.CreateExport( intersectionTestClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AABoxIntersectionTestClass"

--- @class AABoxIntersectionTestInstance : IntersectionTestInstance
--- @field Static AABoxIntersectionTestClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AABoxIntersectionTest : Renegade_IntersectionTest" )
INSTANCE.Class = "AABoxIntersectionTestInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAABoxIntersectionTest = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type CollisionMathClass
	local collisionMathClass = CNC.Import( "code/wwmath/collision-math.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class AABoxIntersectionTestClass

    --- Creates a new AABoxIntersectionTestInstance
    --- @param box AABoxInstance
    --- @param collisionType integer
    --- @overload fun( src: AABoxIntersectionTestInstance )
    --- @return AABoxIntersectionTestInstance
    function STATIC.New( box, collisionType )
        return robustclass.New( "Renegade_AABoxIntersectionTest", box, collisionType )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AABoxIntersectionTestInstance, `false` otherwise
    function STATIC.IsAABoxIntersectionTest( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAABoxIntersectionTest and true or false
    end

    typecheck.RegisterType( "AABoxIntersectionTestInstance", STATIC.IsAABoxIntersectionTest )
end


--- @class AABoxIntersectionTestInstance
--- @field Box AABoxInstance "World space aabox that we want to test with"

--- @param box AABoxInstance
--- @param collisionType integer
--- @overload fun( self, src: AABoxIntersectionTestInstance )
function INSTANCE:Renegade_AABoxIntersectionTest( box, collisionType )
    -- ( box: AABoxInstance, collisionType: integer )
    if typecheck.IsOfType( box, "AABoxInstance" ) then
        typecheck.AssertArgType( INSTANCE.Class, 2, collisionType, "number" )

        intersectionTestClass.Instance.Renegade_IntersectionTest( self, collisionType )
        self.Box = box
        return
    end

    -- ( src: AABoxIntersectionTestInstance )
    typecheck.AssertArgType( INSTANCE.Class, 1, box, "AABoxIntersectionTestInstance" )
    local src = box --[[@as AABoxIntersectionTestInstance]]

    intersectionTestClass.Instance.Renegade_IntersectionTest( self, src )
    self.Box = src.Box
end

--- @param cullMin Vector
--- @param cullMax Vector
--- @return boolean
--- @overload fun( self, cullBox: AABoxInstance ): boolean
function INSTANCE:Cull( cullMin, cullMax )
    -- ( cullMin: Vector, cullMax: Vector ): boolean
    if typecheck.IsOfType( cullMin, "Vector" ) then
        local boxMin = ( self.Box.Center - self.Box.Extent )
        local boxMax = ( self.Box.Center + self.Box.Extent )

        if ( boxMin.x > cullMax.x ) or ( boxMax.x < cullMin.x ) then
            return true
        end

        if ( boxMin.y > cullMax.y ) or ( boxMax.y < cullMin.y ) then
            return true
        end

        if ( boxMin.z > cullMax.z ) or ( boxMax.z < cullMin.z ) then
            return true
        end

        return false
    end

    -- ( cullBox: AABoxInstance ): boolean
    typecheck.AssertArgType( INSTANCE.Class, 1, cullMin, "AABoxInstance" )
    local cullBox = cullMin --[[@as AABoxInstance]]

    local dc = ( cullBox.Center - self.Box.Center )
    local r  = ( cullBox.Extent + self.Box.Extent )

    if math.abs( dc.x ) > r.x then
        return true
    end

    if math.abs( dc.y ) > r.y then
        return true
    end

    if math.abs( dc.z ) > r.z then
        return true
    end

    return false
end

--- @param tri TriInstance
--- @return boolean
function INSTANCE:IntersectTriangle( tri )
    return collisionMathClass.IntersectionTest( self.Box, tri )
end
