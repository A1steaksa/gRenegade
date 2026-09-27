-- Based on CollisionMath within Code/WWMath/colmathobbobb.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class CollisionMathClass
local STATIC = CNC.Import( "code/wwmath/collision-math.lua" )
STATIC.Class = "CollisionMathClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class CollisionMath

    --[[ Object Bounding Boxes ]] do

        -- "Test intersection between two AABoxes"
        STATIC.AddIntersectionTest( "AABoxInstance", "AABoxInstance", function( a, b )
            -- Let's see if we can get away with using a built-in Garry's Mod function for once in our lives
            return util.IsBoxIntersectingBox(
                a.Center - a.Extent / 2,
                a.Center + a.Extent / 2,
                b.Center - b.Extent / 2,
                b.Center + b.Extent / 2
            )
        end )

        -- "Test an AAB for intersection with an OBB"
        STATIC.AddIntersectionTest( "AABoxInstance", "OBBoxInstance", function( a, b )
            -- Let's see if we can get away with using a built-in Garry's Mod function for once in our lives
            return util.IsOBBIntersectingOBB(
                a.Center,
                Angle( 0, 0, 0 ),
                -a.Extent / 2,
                a.Extent / 2,
                b.Center,
                Angle( b.Basis:GetYRotation(), b.Basis:GetZRotation(), b.Basis:GetXRotation() ),
                -b.Extent / 2,
                b.Extent / 2,
                0
            )
        end )
    end
end