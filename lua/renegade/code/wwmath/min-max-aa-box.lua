-- Based on MinMaxAABoxClass within Code/WWMath/aabox.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MinMaxAABoxClass
--- @field Instance MinMaxAABoxInstance The metatable used by MinMaxAABoxInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MinMaxAABoxClass"

--- @class MinMaxAABoxInstance
--- @field Static MinMaxAABoxClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MinMaxAABox" )
INSTANCE.Class = "MinMaxAABoxInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMinMaxAABox = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MinMaxAABoxClass

    --- Creates a new MinMaxAABoxInstance
    --- @return MinMaxAABoxInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MinMaxAABox" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MinMaxAABoxInstance, `false` otherwise
    function STATIC.IsMinMaxAABox( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMinMaxAABox and true or false
    end

    typecheck.RegisterType( "MinMaxAABoxInstance", STATIC.IsMinMaxAABox )
end

--- @class MinMaxAABoxInstance
--- @field MinCorner Vector
--- @field MaxCorner Vector

--- @overload fun( self )
--- @overload fun( self, points: Vector[] )
--- @overload fun( self, that: AABoxInstance )
--- @overload fun( self, minCorner: Vector, maxCorner: Vector )
function INSTANCE:Renegade_MinMaxAABox( ... )
    local args = { ... }
    local argCount = #args
    typecheck.AssertArgCount( self.Class, argCount, { 0, 1, 2 } )

    self.MinCorner = Vector( 0, 0, 0 )
    self.MaxCorner = Vector( 0, 0, 0 )

    -- ()
    if argCount == 0 then
        return
    end

    if argCount == 1 then
        local arg = args[1]

        -- ( that: AABoxInstance )
        if typecheck.IsOfType( arg, "AABoxInstance" ) then
            local that = args[1] --[[@as AABoxInstance]]
            self:Init( that )
            return

        -- ( points: Vector[] )
        elseif typecheck.IsOfType( arg, "table" ) then
            local points = arg --[[@as Vector[] ]]
            self:Init( points )
            return
        end

        typecheck.ArgumentTypeError( self.Class, nil, 1, type( arg ), { "AABoxInstance", "table" } )
    end

    -- ( minCorner: Vector, maxCorner: Vector )
    if argCount == 2 then
        local minCorner = args[1] --[[@as Vector]]
        local maxCorner = args[2] --[[@as Vector]]
        typecheck.AssertArgType( self.Class, 1, minCorner, "Vector" )
        typecheck.AssertArgType( self.Class, 2, maxCorner, "Vector" )
        self.MinCorner = minCorner
        self.MaxCorner = maxCorner
        return
    end
end

--- @param box AABoxInstance
--- @overload fun( self, points: Vector[] )
function INSTANCE:Init( box )
    typecheck.AssertArgType( self.Class, 1, box, { "AABoxInstance", "table" } )

    -- "Initializes this box from a center-extent box"
    -- ( box: AABoxInstance )
    if typecheck.IsOfType( box, "AABoxInstance" ) then
        self.MinCorner = box.Center - box.Extent
        self.MaxCorner = box.Center + box.Extent
        return
    end

    -- "Init the box from an array of points"
    -- "Makes a box which encloses the given array of points"
    -- ( points: Vector[] )
    local points = box --[[@as Vector[] ]]
    assert( points ~= nil )

    self.MinCorner = points[1]
    self.MaxCorner = points[1]

    for _, point in ipairs( points ) do
        self.MinCorner:UpdateMin( point )
        self.MaxCorner:UpdateMax( point )
    end
end

function INSTANCE:InitEmpty()
	typecheck.NotImplementedError()
end

--- @param point Vector
function INSTANCE:AddPoint( point )
    self.MinCorner:UpdateMin( point )
    self.MaxCorner:UpdateMax( point )
end

--- "Update this box to enclose the given box"
--- @overload fun( self: MinMaxAABoxInstance, box: MinMaxAABoxInstance )
--- @overload fun( self: MinMaxAABoxInstance, box: AABoxInstance )
--- @param minCorner Vector
--- @param maxCorner Vector
function INSTANCE:AddBox( minCorner, maxCorner )
    typecheck.AssertArgType( self.Class, 1, minCorner, { "Vector", "MinMaxAABoxInstance", "AABoxInstance" } )

    -- ( minCorner: Vector, maxCorner: Vector )
    if typecheck.IsOfType( minCorner, "Vector" ) then
        typecheck.AssertArgType( self.Class, 2, maxCorner, "Vector" )

        assert( maxCorner.x >= minCorner.x )
        assert( maxCorner.y >= minCorner.y )
        assert( maxCorner.z >= minCorner.z )

        if minCorner == maxCorner then
            return
        end

        self.MinCorner:UpdateMin( minCorner )
        self.MinCorner:UpdateMax( minCorner )
        return
    end

    -- ( box: MinMaxAABoxInstance )
    if typecheck.IsOfType( minCorner, "MinMaxAABoxInstance" ) then
        local box = minCorner --[[@as MinMaxAABoxInstance]]

        if box.MinCorner == box.MaxCorner then
            return
        end

        self.MinCorner:UpdateMin( box.MinCorner )
        self.MaxCorner:UpdateMax( box.MaxCorner )
        return
    end

    -- ( box: AABoxInstance )
    if typecheck.IsOfType( minCorner, "AABoxInstance" ) then
        local box = minCorner --[[@as AABoxInstance]]

        if box.Extent == Vector( 0, 0, 0 ) then
            return
        end

        self.MinCorner:UpdateMin( box.Center - box.Extent )
        self.MaxCorner:UpdateMax( box.Center + box.Extent )
        return
    end

end

--- @param transformationMatrix Matrix3dInstance
function INSTANCE:Transform( transformationMatrix )
	local oldMin = self.MinCorner
    local oldMax = self.MaxCorner
    self.MinCorner, self.MaxCorner = transformationMatrix:TransformMinMaxAABox( oldMin, oldMax )
end


--- @param pos Vector
function INSTANCE:Translate( pos )
	typecheck.NotImplementedError()
end

--- @return number
function INSTANCE:Volume()
    local size = self.MaxCorner - self.MinCorner
    return size.x * size.y * size.z
end
