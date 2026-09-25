-- Based on SphereClass within Code/WWMath/sphere.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SphereClass
--- @field instance SphereInstance The metatable used by SphereInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "SphereClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class SphereInstance
--- @field Static SphereClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Sphere" )
INSTANCE.Class = "SphereInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSphere = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class SphereClass

    --- Creates a new SphereInstance
    --- @param center Vector
    --- @param radius number
    --- @overload fun()
    --- @overload fun( center: Vector, sphere: SphereInstance )
    --- @return SphereInstance
    function STATIC.New( center, radius )
        return robustclass.New( "Renegade_Sphere", center, radius )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SphereInstance, `false` otherwise
    function STATIC.IsSphere( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSphere and true or false
    end

    typecheck.RegisterType( "SphereInstance", STATIC.IsSphere )

    --- "Add two spheres together, creating sphere which encloses both"
    --- @param sphere1 SphereInstance
    --- @param sphere2 SphereInstance
    --- @return SphereInstance
    function STATIC.AddSpheres( sphere1, sphere2 )
        if sphere1.Radius == 0 then
            return sphere2
        else
            -- Changed this logic slightly to create a new sphere from sphere1.
            -- I'm not at all sure whether the original code modified sphere1.
            local result = STATIC.New( sphere1.Center, sphere1.Radius )
            result:AddSphere( sphere2 )
            return result
        end
    end

    --- "Transform a sphere"
    --- @param transformationMatrix Matrix3dInstance
    --- @param sphere SphereInstance
    --- @return SphereInstance
    function STATIC.TransformSphere( transformationMatrix, sphere )
        -- "Warning, assumes Orthogonal matrix"
        return STATIC.New( transformationMatrix * sphere.Center, sphere.Radius )
    end

    --- "Test whether two sphere intersect"
    --- @param sphere1 SphereInstance
    --- @param sphere2 SphereInstance
    --- @return boolean
    function STATIC.SpheresIntersect( sphere1, sphere2 )
        local delta = sphere1.Center - sphere2.Center
        local distance2 = delta * delta

        if distance2 < ( sphere1.Radius + sphere2.Radius ) * ( sphere1.Radius + sphere2.Radius ) then
            return true
        else
            return false
        end
    end

end


--- @class SphereInstance
--- @field Center Vector
--- @field Radius number

--- Constructs a new SphereInstance
--- I am omitting the constructor that takes a vertex count for now
--- as I do not know how to differentiate it from the more common radius constructor
--- @param center Vector
--- @param radius number
--- @overload fun( self: SphereInstance )
--- @overload fun( self: SphereInstance, center: Vector, sphere: SphereInstance )
function INSTANCE:Renegade_Sphere( center, radius )
    -- ()
    if center == nil and radius == nil then
        return
    end

    typecheck.AssertArgType( self.Class, 1, center, "Vector" )
    typecheck.AssertArgType( self.Class, 2, radius, { "SphereInstance", "number" } )

    -- ( center: Vector, sphere: SphereInstance )
    if typecheck.IsOfType( radius, "SphereInstance" ) then
        local sphere = radius --[[@as SphereInstance]]
        local distance = ( sphere.Center - center ):Length()
        self.Center = center
        self.Radius = sphere.Radius + distance

    -- ( center: Vector, radius: number )
    elseif typecheck.IsOfType( radius, "number" ) then
        self:Init( center, radius )
    end
end

--- @param pos Vector
--- @param radius number
function INSTANCE:Init( pos, radius )
    self.Center = pos
    self.Radius = radius
end

--- @param center Vector
function INSTANCE:ReCenter( center )
    local distance = ( self.Center - center ):Length()
    self.Center = center
    self.Radius = self.Radius + distance
end

--- "Expands 'this' sphere to enclose the given sphere"
--- @param sphere SphereInstance
function INSTANCE:AddSphere( sphere )
    if sphere.Radius == 0 then
        return
    end

    local distance = ( sphere.Center - self.Center ):Length()
    if distance == 0 then
        self.Radius = ( ( self.Radius > sphere.Radius ) and self.Radius or sphere.Radius )
        return
    end

    local radiusNew = ( distance + self.Radius + sphere.Radius ) / 2

    -- "  
    -- If [radiusNew] is smaller than either of the two sphere radii (it can't be
    -- smaller than both of them), this means that the smaller sphere is completely
    -- inside the larger, and the result of adding the two is simply the larger
    -- sphere.  If [radiusNew] isn't less than either of them, it is the new radius
    -- - calculate the new center.
    -- "  
    if radiusNew < self.Radius then
        -- "The existing sphere is the result - do nothing."
    else
        if radiusNew < sphere.Radius then
            -- "The new sphere is the result:"
            self:Init( sphere.Center, sphere.Radius )
        else
            -- "  
            -- Neither sphere is completely inside the other so [radiusNew] is the new
            -- radius - Calculate the new center
            --"
            local lerp = ( radiusNew - self.Radius ) / distance
            local center = ( sphere.Center - self.Center ) * lerp + self.Center
            self:Init( center, radiusNew )
        end
    end
end

--- "Transforms this sphere"
--- @param transformationMatrix Matrix3dInstance
function INSTANCE:Transform( transformationMatrix )
    -- "Warning, assumes Orthogonal matrix"
    self.Center = transformationMatrix * self.Center
end

--- @return number volume "...the volume of this sphere"
function INSTANCE:Volume()
    return ( 4 / 3 ) * math.pi * ( self.Radius * self.Radius * self.Radius )
end


--[[ Operators ]] do

    --- "Add two spheres together, creating a sphere which encloses both"
    --- @param a SphereInstance
    --- @param b SphereInstance
    --- @return SphereInstance
    function INSTANCE.__add( a, b )
        typecheck.AssertArgType( INSTANCE.Class, 1, a, "SphereInstance" )
        typecheck.AssertArgType( INSTANCE.Class, 2, b, "SphereInstance" )

        return STATIC.AddSpheres( a, b )
    end

    --- "Transform a sphere"
    --- @param transformationMatrix Matrix3dInstance
    --- @param sphere SphereInstance
    --- @return SphereInstance
    function INSTANCE.__mul( transformationMatrix, sphere )
        typecheck.AssertArgType( INSTANCE.Class, 1, transformationMatrix, "Matrix3dInstance" )
        typecheck.AssertArgType( INSTANCE.Class, 2, sphere, "SphereInstance" )

        return STATIC.TransformSphere( transformationMatrix, sphere )
    end
end