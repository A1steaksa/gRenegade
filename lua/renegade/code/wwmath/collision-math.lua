-- Based on CollisionMath within Code/WWMath/colmath.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class CollisionMathClass
local STATIC = CNC.CreateExport()
STATIC.Class = "CollisionMathClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums

    --- This enumeration is the result of an overlap test.
    --- It indicates whether the the object is in the positive (front/outside) space
    --- Of the volume, the negative (back/inside) space of the volume, or both (overlapping)
    --- @enum OverlapType
    STATIC.OVERLAP_TYPE = {
        POSITIVE   = 0x01,
        NEGATIVE   = 0x02,
        ON         = 0x04,
        BOTH       = 0x08,
        OUTSIDE    = 0x01,
        INSIDE     = 0x02,
        OVERLAPPED = 0x08,
        FRONT      = 0x01,
        BACK       = 0x02,
    }
    local overlapType = STATIC.OVERLAP_TYPE
--#endregion

--#region Imports
--#endregion

-- #regions Imported Enums
-- #endregion


--[[ Static Functions and Variables ]] do

    --- "This is a collection of the low-level math functions for collision detection."
    --- @class CollisionMath

    STATIC.COLLISION_EPSILON   = 0.001
    STATIC.COINCIDENCE_EPSILON = 0.000001


    --[[ Intersect Functions ]] do

        --- Intersection Test Functions  
        --- A map of (Type A, Type B): Func( A, B ): boolean
        --- @type table<string, table<string, function>>
        STATIC.IntersectionTestFunctions = {}
    
        
        function STATIC.AddIntersectionTest()
        end



    end


    --[[ Overlap Functions ]] do
        --- Classify the second operand with respect to the first operand.
        --- For example Overlap_Test(plane,point) tests whether 'point' is in front of or
        --- Behind 'plane'.

        --- Overlap Test Functions  
        --- A map of (Type A, Type B): Func( A, B ): OverlapType
        --- @type table<string, table<string, function>>
        STATIC.OverlapTestFunctions = {}

        --- Registers a new overlap check function for two data types
        --- @generic A
        --- @generic B
        --- @param aType `A`
        --- @param bType `B`
        --- @param overlapFunction fun( a: A, b: B ):OverlapType
        function STATIC.AddOverlapTest( aType, bType, overlapFunction )
            typecheck.AssertArgType( STATIC.Class, 1, aType, "string" )
            typecheck.AssertArgType( STATIC.Class, 2, bType, "string" )
            typecheck.AssertArgType( STATIC.Class, 3, overlapFunction, "function" )

            --- @cast aType string
            --- @cast bType string

            aType = aType:Trim():lower()
            bType = bType:Trim():lower()

            local aTable = STATIC.OverlapTestFunctions[aType]
            if not aTable then
                aTable = {}
                STATIC.OverlapTestFunctions[aType] = aTable
            end

            STATIC.OverlapTestFunctions[aType][bType] = overlapFunction
        end

        --- Determines how, if at all, two shapes intersect or overlap
        --- @param a any 
        --- @param b any
        --- @return OverlapType
        function STATIC.OverlapTest( a, b )
            local aType = typecheck.GetType( a )
            local bType = typecheck.GetType( b )

            local aTable = STATIC.OverlapTestFunctions[aType]
            if not aTable then
                typecheck.NotImplementedError( "First operand of type '" .. aType .. "'" )
            end

            local checkFunction = aTable[bType]
            if not checkFunction then
                typecheck.NotImplementedError( "First operand of type '" .. aType .. "' and second operand of type '" .. bType .. "'" )
            end

            return checkFunction( a, b )
        end

        --- Determines the OverlapType of a CastResultStruct
        --- @param result CastResultStructInstance
        --- @return OverlapType
        function STATIC.EvaluateOverlapCollision( result )
            if result.Fraction < 1.0 then
                return overlapType.BOTH
            else
                if result.StartBad then
                    return overlapType.NEGATIVE
                else
                    return overlapType.POSITIVE
                end
            end
        end

        --- Converts an integer mask value into its corresponding OverlapType
        --- @param mask integer
        --- @return OverlapType
        function STATIC.EvaluateOverlapMask( mask )
            -- "Check if all verts are 'on'"
            if mask == overlapType.ON then
                return overlapType.ON
            end

            -- "Check if all verts are either 'on' or 'positive'"
            if bit.band( mask, bit.bnot( bit.bor( overlapType.POSITIVE, overlapType.ON ) ) ) == 0 then
                return overlapType.POSITIVE
            end

            -- "Check if all verts are either 'on' or 'back'"
            -- I believe 'back' should be 'negative' in this comment
            if bit.band( mask, bit.bnot( bit.bor( overlapType.NEGATIVE, overlapType.ON ) ) ) == 0 then
                return overlapType.NEGATIVE
            end

            -- "Overwise, poly spans the plane"
            return overlapType.BOTH
        end
    end


    --[[ Collision Functions ]] do

        --- A map of (Type A, Type B): Func( A, B ): boolean
        --- @type table<string, table<string, function>>
        STATIC.CollideFunctions = {}

    end
end

--[[ Execute Partial Class Files ]] do
    -- After this file initializes the core of the class, execute the other scripts that add to this class  

    include( "renegade/code/wwmath/collision-math-frustum.lua" )
    include( "renegade/code/wwmath/collision-math-plane.lua" )
end