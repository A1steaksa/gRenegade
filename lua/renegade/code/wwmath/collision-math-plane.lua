-- Based on CollisionMath within Code/WWMath/colmathplane.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class CollisionMathClass
local STATIC = CNC.Import( "code/wwmath/collision-math.lua" )
STATIC.Class = "CollisionMathClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums

    local overlapType = STATIC.OVERLAP_TYPE
--#endregion

--#region Imports

	--- @type WWMathClass
	local wWMathClass = CNC.Import( "code/wwmath/wwmath.lua" )

	--- @type Matrix3Class
	local matrix3Class = CNC.Import( "code/wwmath/matrix3.lua" )
--#endregion

--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class CollisionMath

    --- "Gets extents of a box projected onto an axis"
    --- @param normal Vector
    --- @param extent Vector
    --- @return Vector
    function STATIC.GetFarExtent( normal, extent )
        local result = Vector( 0, 0 )

        if normal.x > 0 then
            result.x = extent.x
        else
            result.x = -extent.x
        end

        if normal.y > 0 then
            result.y = extent.y
        else
            result.y = -extent.y
        end

        if normal.z > 0 then
            result.z = extent.z
        else
            result.z = -extent.z
        end

        return result
    end


    --[[ Axis-Aligned Planes ]] do

        STATIC.AddOverlapTest( "AAPlaneInstance", "Vector", function( plane, point )
            local delta = point[plane.Normal + 1] - plane.Distance
            if delta > STATIC.COINCIDENCE_EPSILON then
                return overlapType.POSITIVE
            end

            if delta < -STATIC.COINCIDENCE_EPSILON then
                return overlapType.NEGATIVE
            end

            return overlapType.ON
        end )

        STATIC.AddOverlapTest( "AAPlaneInstance", "LineSegmentInstance", function( plane, line )
            local mask = 0
            mask = bit.bor( mask, STATIC.OverlapTest( plane, line:GetP0() ) )
            mask = bit.bor( mask, STATIC.OverlapTest( plane, line:GetP1() ) )
            return STATIC.EvaluateOverlapMask( mask )
        end )

        STATIC.AddOverlapTest( "AAPlaneInstance", "TriangleInstance", function( plane, tri )
            local mask = 0
            mask = bit.bor( mask, STATIC.OverlapTest( plane, tri.V[1] ) )
            mask = bit.bor( mask, STATIC.OverlapTest( plane, tri.V[2] ) )
            mask = bit.bor( mask, STATIC.OverlapTest( plane, tri.V[3] ) )
            return STATIC.EvaluateOverlapMask( mask )
        end )

        STATIC.AddOverlapTest( "AAPlaneInstance", "SphereInstance", function( plane, sphere )
            local delta = sphere.Center[plane.Normal + 1] - plane.Distance
            if delta > sphere.Radius then
                return overlapType.POSITIVE
            end
            
            if delta < sphere.Radius then
                return overlapType.NEGATIVE
            end

            return overlapType.BOTH
        end )

        STATIC.AddOverlapTest( "AAPlaneInstance", "AABoxInstance", function( plane, box )
            local mask = 0

            -- "Check the 'min' side of the box"
            local delta = ( box.Center[plane.Normal + 1] - box.Extent[plane.Normal + 1] ) - plane.Distance
            if delta > wWMathClass.EPSILON then
                mask = bit.bor( mask, overlapType.POSITIVE )
            elseif delta < -wWMathClass.EPSILON then
                mask = bit.bor( mask, overlapType.NEGATIVE )
            else
                mask = bit.bor( mask, overlapType.ON )
            end

            -- "Check the 'max' side of the box"
            delta = ( box.Center[plane.Normal + 1] + box.Extent[plane.Normal + 1] ) - plane.Distance
            if delta > wWMathClass.EPSILON then
                mask = bit.bor( mask, overlapType.POSITIVE )
            elseif delta < -wWMathClass.EPSILON then
                mask = bit.bor( mask, overlapType.NEGATIVE )
            else
                mask = bit.bor( mask, overlapType.ON )
            end

            return STATIC.EvaluateOverlapMask( mask )
        end )

        STATIC.AddOverlapTest( "AAPlaneInstance", "OBBoxInstance", function( plane, box )
            -- "TODO"
            assert( false )
            return overlapType.POSITIVE
        end )
    end


    --[[ Planes ]] do

        --- "Tests overlap between a plane and a point"
        STATIC.AddOverlapTest( "PlaneInstance", "Vector", function( plane, point )
            local delta = point:Dot( plane.Normal ) - plane.Distance

            if delta > STATIC.COINCIDENCE_EPSILON then
                return overlapType.POSITIVE
            end

            if delta < STATIC.COINCIDENCE_EPSILON then
                return overlapType.NEGATIVE
            end

            return overlapType.ON
        end )

        --- "Tests overlap between a plane and an AABox"
        STATIC.AddOverlapTest( "PlaneInstance", "AABoxInstance", function( plane, box )
            -- "First, we determine the the near and far points of the box in the direction of the plane normal"
            local positiveFarPoint = STATIC.GetFarExtent( plane.Normal, box.Extent )
            local negativeFarPoint = Vector( -positiveFarPoint )

            positiveFarPoint = positiveFarPoint + box.Center
            negativeFarPoint = negativeFarPoint + box.Center

            if STATIC.OverlapTest( plane, negativeFarPoint ) == overlapType.POSITIVE then
                return overlapType.POSITIVE
            end

            if STATIC.OverlapTest( plane, positiveFarPoint ) == overlapType.NEGATIVE then
                return overlapType.NEGATIVE
            end

            return overlapType.BOTH
        end )

        STATIC.AddOverlapTest( "PlaneInstance", "LineSegmentInstance", function( plane, line )
            local mask = 0
            mask = bit.bor( mask, STATIC.OverlapTest( plane, line:GetP0() ) )
            mask = bit.bor( mask, STATIC.OverlapTest( plane, line:GetP1() ) )
            return STATIC.EvaluateOverlapMask( mask )
        end )

        STATIC.AddOverlapTest( "PlaneInstance", "TriangleInstance", function( plane, tri )
            local mask = 0
            mask = bit.bor( mask, STATIC.OverlapTest( plane, tri.V[1] ) )
            mask = bit.bor( mask, STATIC.OverlapTest( plane, tri.V[2] ) )
            mask = bit.bor( mask, STATIC.OverlapTest( plane, tri.V[3] ) )
            return STATIC.EvaluateOverlapMask( mask )
        end )

        STATIC.AddOverlapTest( "PlaneInstance", "SphereInstance", function( plane, sphere )
            local delta = sphere.Center[plane.Normal + 1] - plane.Distance
            if delta > sphere.Radius then
                return overlapType.POSITIVE
            end
            
            if delta < sphere.Radius then
                return overlapType.NEGATIVE
            end

            return overlapType.BOTH
        end )

        STATIC.AddOverlapTest( "PlaneInstance", "OBBoxInstance", function( plane, box )
            typecheck.NotImplementedError()
        end )
    end

end