-- Based on Quaternion within Code/WWMath/quat.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class QuaternionClass
--- @field instance QuaternionInstance The metatable used by QuaternionInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "QuaternionClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class QuaternionInstance
--- @field Static QuaternionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Quaternion" )
INSTANCE.Class = "QuaternionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsQuaternion = true


--#region Exported Enums
--#endregion


--#region Imports

    --- @type WWMathClass
    local wwmath = CNC.Import( "code/wwmath/wwmath.lua" )

    --- @type Matrix3dClass
    local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class QuaternionClass

    local nxt = { 2, 3, 1 }

    local SLERP_EPSILON = 0.001
    local SQRT2 = 1.41421356

    --- Creates a new QuaternionInstance
    --- @vararg any
    --- @return QuaternionInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Quaternion", ... )
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) QuaternionInstance, `false` otherwise
    function STATIC.IsQuaternion( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsQuaternion and true or false
    end

    typecheck.RegisterType( "QuaternionInstance", STATIC.IsQuaternion )

    --#region  Local Functions ]]

        --- @param r number
        --- @param x number
        --- @param y number
        --- @return number
        local function ProjectToSphere( r, x, y )
            local d = math.sqrt( x * x + y * y )

            --- @type number, number
            local t, z

            -- "Inside sphere"
            if d < r * ( SQRT2 / 2.0 ) then
                z = math.sqrt( r * r - d * d )

            -- "On hyperbola"
            else
                t = r / SQRT2
                z = t * t / d
            end

            return z
        end
    --#endregion

    --- "Normalized version of the quaternion"
    --- @param a QuaternionInstance
    --- @return QuaternionInstance
    function STATIC.Normalize( a )
        local mag = a:Length()
        if 0.0 == mag then
            return a
        else
            local oomag = 1.0 / mag
            return STATIC.New(
                a[1] * oomag,
                a[2] * oomag,
                a[3] * oomag,
                a[4] * oomag
            )
        end
    end

    --- @param a QuaternionInstance
    --- @param b QuaternionInstance
    --- @param epsilon number
    function STATIC.EqualWithinEpsilon( a, b, epsilon )
        return (
            ( math.abs( a.x - b.x ) < epsilon ) and
            ( math.abs( a.y - b.y ) < epsilon ) and
            ( math.abs( a.z - b.z ) < epsilon ) and
            ( math.abs( a.w - b.w ) < epsilon )
        )
    end

    --- "Inverse of the quaternion (1/q)"  
    --- Identical to Conjuugate()
    --- @param a QuaternionInstance
    --- @return QuaternionInstance
    function STATIC.Inverse( a )
        return STATIC.New(
            -a[1],
            -a[2],
            -a[3],
            a[4]
        )
    end

    --- "Conjugate of the quaternion"  
    --- Identical to Inverse()
    --- @param a QuaternionInstance
    --- @return QuaternionInstance
    function STATIC.Conjugate( a )
        return STATIC.New(
            -a[1],
            -a[2],
            -a[3],
            a[4]
        )
    end

    --- "Creates a quaternion given an axis and angle of rotation"
    ---
    --- > "  
    --- > This function computes a quaternion based on an axis
    --- > (defined by the given Vector [axis]) and an angle about
    --- > which to rotate.  The angle is expressed in radians.  
    --- "
    --- @param axis Vector
    --- @param angle number
    --- @return QuaternionInstance
    function STATIC.AxisToQuaternion( axis, angle )
        local normalizedAxis = axis:GetNormalized()

        local q = STATIC.New()
        q[1] = normalizedAxis.x
        q[2] = normalizedAxis.y
        q[3] = normalizedAxis.z

        q:Scale( math.sin( angle / 2.0 ) )
        q[4] = math.cos( angle / 2.0 )

        return q
    end

    --- "Computes a "trackball" quaternion given 2D mouse coordinates"
    ---
    --- > "  
    --- > Pass the x and y coordinates of the last and current position
    --- > of the mouse, scaled so they are from `-1.0` to `1.0`  
    --- > The quaternion is the computed as the rotation of a trackball
    --- > between the two points projected onto a sphere.  This can
    --- > be used to implement an intuitive viewing control system.  
    --- > "
    --- @param x0 number "Normalized" mouse coordinates for the mouse movement
    --- @param y0 number "Normalized" mouse coordinates for the mouse movement
    --- @param x1 number "Normalized" mouse coordinates for the mouse movement
    --- @param y1 number "Normalized" mouse coordinates for the mouse movement
    --- @param sphereSize number Size of the trackball sphere
    --- @return QuaternionInstance # A quaternion representing the rotation of a trackball
    function STATIC.Trackball( x0, y0, x1, y1, sphereSize )

        if x0 == x1 and y0 == y1 then
            return STATIC.New( 0, 0, 0, 1 ) -- "Zero rotation"
        end

        local p1 = Vector()
        local p2 = Vector()

        -- "Compute z coordinates for projection of p1 and p2 to deformed sphere"
        p1.x = x0
        p1.y = y1
        p1.z = ProjectToSphere( sphereSize, x0, y0 )

        p2.x = x1
        p2.y = y1
        p2.z = ProjectToSphere( sphereSize, x1, y1 )

        -- "Find their cross product"
        local a = p2:Cross( p1 )

        -- "Compute how much to rotate"
        local d = p1 - p2
        local t = d:Length() / ( 2 * sphereSize )

        -- "Avoid problems with out of control values"
        if t >  1.0 then t =  1.0 end
        if t < -1.0 then t = -1.0 end
        local phi = 2.0 * math.asin( t )

        return STATIC.AxisToQuaternion( a, phi )
    end

    --- "Spherical Linear interpolation of quaternions"
    --- @param p QuaternionInstance "Start quaternion"
    --- @param q QuaternionInstance "End quaternion"
    --- @param alpha number "interpolating parameter"
    --- @return QuaternionInstance
    function STATIC.Slerp( p, q, alpha )
        --- "Complementary interploation parameter"
        local beta --[[@as number]]

        --- "Angle between p and q"
        local theta --[[@as number]]

        local cosTheta --[[@as number]]
        local ooSinTheta --[[@as number]]

        --- "Use flip of q?"
        local qFlip --[[@as integer]]

        -- "Cos theta = dot product of p and q"
        cosTheta = (
            p.x * q.x +
            p.y * q.y +
            p.z * q.z +
            p.w * q.w
        )

        -- "If q is on opposite hemisphere from A, use -B instead"
        if cosTheta < 0.0 then
            cosTheta = -cosTheta
            qFlip = true
        else
            qFlip = false
        end

        if 1.0 - cosTheta < wwmath.EPSILON * wwmath.EPSILON then
            -- "If q is very close to p, just linearly interpolate between the two"
            beta = 1.0 - alpha
        else
            -- "Normal slerp!"
            theta = math.acos( cosTheta )
            local sinTheta = math.sin( theta )
            ooSinTheta = 1.0 / sinTheta
            beta = math.sin( theta - alpha * theta ) * ooSinTheta
            alpha = math.sin( alpha * theta ) * ooSinTheta
        end

        if qFlip then
            alpha = -alpha
        end

        return STATIC.New(
            beta * p.x + alpha * q.x,
            beta * p.y + alpha * q.y,
            beta * p.z + alpha * q.z,
            beta * p.w + alpha * q.w
        )
    end

    --- "Spherical Linear interpolation of quaternions"
    --- @param p QuaternionInstance "Start quaternion"
    --- @param q QuaternionInstance "End quaternion"
    --- @param alpha number "interpolating parameter"
    --- @return QuaternionInstance
    function STATIC.FastSlerp( p, q, alpha )
        -- Omitted fast slerp logic
        return STATIC.Slerp( p, q, alpha )
    end

    function STATIC.SlerpSetup()
        typecheck.NotImplementedError()
    end

    function STATIC.Cached_Slerp()
        typecheck.NotImplementedError()
    end

    --- "Creates a quaternion from a Matrix"  
    --- **Note:** "Matrix MUST NOT have scaling!"
    --- @param matrix Matrix3dInstance|Matrix3Instance|Matrix4Instance
    --- @return QuaternionInstance
    function STATIC.BuildQuaternion( matrix )
        typecheck.AssertArgType( STATIC.Class, 1, matrix, { "Matrix3dInstance", "Matrix3Instance", "Matrix4Instance" } )

        -- ( matrix: Matrix3dInstance ): QuaternionInstance
        if typecheck.IsOfType( matrix, "Matrix3dInstance" ) then
            --- @cast matrix Matrix3dInstance

            local row = matrix.Row

            -- "Sum the diagonal of the rotation matrix"
            local tr = row[1][1] + row[2][2] + row[3][3]

            local q = STATIC.New()

            if tr > 0.0 then
                local s = math.sqrt( tr + 1.0 )
                q[4] = s * 0.5
                s = 0.5 / s

                q[1] = ( row[3][2] - row[2][3] ) * s
                q[2] = ( row[1][3] - row[3][1] ) * s
                q[3] = ( row[2][1] - row[1][2] ) * s
            else
                local i = 1

                if row[2][2] > row[1][1] then i = 2 end
                if row[3][3] > row[i][i] then i = 3 end
                local j = nxt[i]
                local k = nxt[j]

                local s = math.sqrt( ( row[i][i] - ( row[j][j] + row[k][k] ) ) + 1.0 )

                q[i] = s * 0.5
                if s ~= 0.0 then
                    s = 0.5 / s
                end

                q[4] = ( row[k][j] - row[j][k] ) * s
                q[j] = ( row[j][i] - row[i][j] ) * s
                q[k] = ( row[k][i] - row[i][k] ) * s
            end

            return q
        end

        -- ( matrix: Matrix3Instance ): QuaternionInstance
        if typecheck.IsOfType( matrix, "Matrix3Instance" ) then
            typecheck.NotImplementedError()
        end

        -- ( matrix: Matrix4Instance ): QuaternionInstance
        if typecheck.IsOfType( matrix, "Matrix4Instance" ) then
            typecheck.NotImplementedError()
        end
    end

    function STATIC.BuildMatrix3()
        typecheck.NotImplementedError()
    end

    --- "Creates a Matrix from a Quaternion"
    --- @param q QuaternionInstance
    --- @return Matrix3dInstance
    function STATIC.BuildMatrix3d( q )
        local m = matrix3dClass.New()
        local row = m.Row

        -- "initialize the rotation sub-matrix"
        row[1][1] = ( 1.0 - 2.0 * ( q[2] * q[2] + q[3] * q[3] ) )
        row[1][2] = ( 2.0 * ( q[1] * q[2] - q[3] * q[4] ) )
        row[1][3] = ( 2.0 * ( q[3] * q[1] + q[2] * q[4] ) )

        row[2][1] = ( 2.0 * ( q[1] * q[2] + q[3] * q[4] ) )
        row[2][2] = ( 1.0 - 2.0 * ( q[3] * q[3] + q[1] * q[1] ) )
        row[2][3] = ( 2.0 * ( q[2] * q[3] - q[1] * q[4] ) )

        row[3][1] = ( 2.0 * ( q[3] * q[1] - q[2] * q[4] ) )
        row[3][2] = ( 2.0 * ( q[2] * q[3] + q[1] * q[4] ) )
        row[3][3] = ( 1.0 - 2.0 * ( q[2] * q[2] + q[1] * q[1] ) )

        -- "No translation"
        row[1][4] = 0.0
        row[2][4] = 0.0
        row[3][4] = 0.0

        return m
    end

    function STATIC.BuildMatrix4()
        typecheck.NotImplementedError()
    end
end


--- @class QuaternionInstance
--- "X,Y,Z are the imaginary parts of the quaterion"
--- "W is the real part"
--- @field Data { x: number, y: number, z: number, w: number }

--- "Some values can be cached if you are performing multiple slerps between the same two quaternions..."
--- @class SlerpInfoStruct
--- @field SinT number
--- @field Theta number
--- @field Flip boolean
--- @field Linear boolean

--- Constructs a new QuaternionInstance
--- @overload fun(): QuaternionInstance
--- @overload fun( init: boolean ): QuaternionInstance
--- @overload fun( axis: Vector, angle: number ): QuaternionInstance
--- @overload fun( a: number, b: number, c: number, d: number ): QuaternionInstance
function INSTANCE:Renegade_Quaternion( ... )
    local args = { ... }
    local argCount = select( "#", ... )
    typecheck.AssertArgCount( INSTANCE.Class, argCount, {0,1,2,4} )

    self.Data = {
        x = 0,
        y = 0,
        z = 0,
        w = 0
    }

    -- ()
    if argCount == 0 then
        return
    end

    -- ( init: boolean )
    if argCount == 1 then
        local init = typecheck.AssertArgType( INSTANCE.Class, 1, args[1], "boolean" ) --[[@as boolean]]

        if init then
            self.x = 0.0
            self.y = 0.0
            self.z = 0.0
            self.w = 1.0
        end

        return
    end

    -- ( axis: Vector, angle: number )
    if argCount == 2 then
        local axis  = typecheck.AssertArgType( INSTANCE.Class, 1, args[1], "Vector" ) --[[@as Vector]]
        local angle = typecheck.AssertArgType( INSTANCE.Class, 2, args[2], "number" ) --[[@as number]]

        local sine   = math.sin( angle / 2 )
        local cosine = math.cos( angle / 2 )

        self.x = sine * axis.x
        self.y = sine * axis.y
        self.z = sine * axis.z
        self.w = cosine

        return
    end

    -- ( a: number, b: number, c: number, d: number )
    if argCount == 4 then
        local a = typecheck.AssertArgType( INSTANCE.Class, 1, args[1], "number" ) --[[@as number]]
        local b = typecheck.AssertArgType( INSTANCE.Class, 2, args[2], "number" ) --[[@as number]]
        local c = typecheck.AssertArgType( INSTANCE.Class, 3, args[3], "number" ) --[[@as number]]
        local d = typecheck.AssertArgType( INSTANCE.Class, 4, args[4], "number" ) --[[@as number]]

        self.x = a
        self.y = b
        self.z = c
        self.w = d

        return
    end
end

--- @return string
function INSTANCE:__tostring()
    return(
        "Quaternion( " ..
        "X: " .. math.Round( self.x, 2 ) .. ", " ..
        "Y: " .. math.Round( self.y, 2 ) .. ", " ..
        "Z: " .. math.Round( self.z, 2 ) .. ", " ..
        "W: " .. math.Round( self.w, 2 ) ..
        " )"
    )
end

--- "Set the quaternion"
--- @param a number? [Default: 0.0]
--- @param b number? [Default: 0.0]
--- @param c number? [Default: 0.0]
--- @param d number? [Default: 1.0]
function INSTANCE:Set( a, b, c, d )
    self.x = a or 0.0
    self.y = b or 0.0
    self.z = c or 0.0
    self.w = d or 1.0
end

function INSTANCE:MakeIdentity()
    self:Set()
end

--- @param scale number
function INSTANCE:Scale( scale )
    self.x = scale * self.x
    self.y = scale * self.y
    self.z = scale * self.z
    self.w = scale * self.w
end

--[[ Array Access ]] do

    --- Getting values
    --- @param self QuaternionInstance
    --- @param key any
    --- @return any
    function INSTANCE.__index( self, key )
        local data = rawget( self, "Data" )
        if key == "x" or key == 1 then return data.x end
        if key == "y" or key == 2 then return data.y end
        if key == "z" or key == 3 then return data.z end
        if key == "w" or key == 4 then return data.w end 
        return rawget( INSTANCE, key )
    end

    --- Setting values
    --- @param self QuaternionInstance
    --- @param key any
    --- @param value any
    function INSTANCE.__newindex( self, key, value )
        -- Convert -0 to 0
        if isnumber( value ) and value == -value then value = math.abs( value ) end

        if key == "Data" then rawset( self, "Data", value ) return end

        local data = rawget( self, "Data" )
        if key == "x" or key == 1 then data.x = value return end
        if key == "y" or key == 2 then data.y = value return end
        if key == "z" or key == 3 then data.z = value return end
        if key == "w" or key == 4 then data.w = value return end

        rawset( INSTANCE, key, value )
    end
end

--[[ Unary Operators ]] do

    --- @class QuaternionInstance
    --- @operator unm: QuaternionInstance

    --- @param self QuaternionInstance
    function INSTANCE.__neg( self )
        -- "Remember that q and -q represent the same 3D rotation."
        return STATIC.New( -self.x, -self.y, -self.z, -self.w )
    end
end

--[[ Operators ]] do

    --- @class QuaternionInstance
    --- @operator add: QuaternionInstance
    --- @operator sub: QuaternionInstance
    --- @operator mul: QuaternionInstance
    --- @operator div: QuaternionInstance

    --- "Add two quaternions"
    --- @param a QuaternionInstance
    --- @param b QuaternionInstance
    --- @return QuaternionInstance
    function INSTANCE.__add( a, b )
        return STATIC.New(
            a[1] + b[1],
            a[2] + b[2],
            a[3] + b[3],
            a[4] + b[4]
        )
    end

    --- "Subract two quaternions"
    --- @param a QuaternionInstance
    --- @param b QuaternionInstance
    --- @return QuaternionInstance
    function INSTANCE.__sub( a, b )
        return STATIC.New(
            a[1] - b[1],
            a[2] - b[2],
            a[3] - b[3],
            a[4] - b[4]
        )
    end

    --- @overload fun( a: QuaternionInstance, b: number ):QuaternionInstance
    --- @overload fun( a: QuaternionInstance, b: QuaternionInstance ):QuaternionInstance
    function INSTANCE.__mul( a, b )
        typecheck.AssertArgType( INSTANCE.Class, 1, a, "QuaternionInstance" )
        typecheck.AssertArgType( INSTANCE.Class, 2, b, { "number", "QuaternionInstance" } )

        -- ( a: QuaternionInstance, scalar: number ): QuaternionInstance
        if typecheck.IsOfType( b, "number" ) then
            local scalar = b --[[@as number]]
            return STATIC.New(
                scalar * a[1],
                scalar * a[2],
                scalar * a[3],
                scalar * a[4]
            )
        end

        -- ( a: QuaternionInstance, b: QuaternionInstance ): QuaternionInstance
        if typecheck.IsOfType( b, "QuaternionInstance" ) then
            --- @cast b QuaternionInstance

            return STATIC.New(
                a.w * b.x + b.w * a.x + ( a.y * b.z - b.y * a.z ),
                a.w * b.y + b.w * a.y - ( a.x * b.z - b.x * a.z ),
                a.w * b.z + b.w * a.z + ( a.x * b.y - b.x * a.y ),
                a.w * b.w - (a.x * b.x + a.y * b.y + a.z * b.z )
            )
        end
    end

    --- "Divide two quaternions"
    --- @param a QuaternionInstance
    --- @param b QuaternionInstance
    --- @return QuaternionInstance
    function INSTANCE.__div( a, b )
        return a * STATIC.Inverse( b )
    end
end


---"Use nearest representation to the given quaternion"
---
--- > "  
--- > Every 3D rotation can be expressed by two different quaternions.  
--- > This function makes the current quaternion convert itself to the
--- > representation which is closer on the 4D unit-hypersphere to the
--- > given quaternion  
--- > "
--- @param qto QuaternionInstance
--- @return QuaternionInstance
function INSTANCE:MakeClosest( qto )
    local cos_t = (
        qto.x * self.x +
        qto.y * self.y +
        qto.z * self.z +
        qto.w * self.w
    )

    -- "If we are on opposite hemisphere from qto, negate ourselves"
    if cos_t < 0.0 then
        self.x = -self.x
        self.y = -self.y
        self.z = -self.z
        self.w = -self.w
    end

    return self
end

--- "Square of the magnitude of the quaternion"
--- @return number
function INSTANCE:Length2()
    return (
        self.x * self.x +
        self.y * self.y +
        self.z * self.z +
        self.w * self.w
    )
end

--- "Magnitude of the quaternion"
--- @return number
function INSTANCE:Length()
    return math.sqrt( self:Length2() )
end

--- "Normalize to a unit quaternion"
function INSTANCE:Normalize()

    -- I wouldn't **want** to use Length2() for this
    local len2 = (
        self.x * self.x +
        self.y * self.y +
        self.z * self.z +
        self.w * self.w
    )

    if 0.0 == len2 then
        return
    else
        local invMag = wwmath.InvSqrt( len2 )

        self.x = self.x * invMag
        self.y = self.y * invMag
        self.z = self.z * invMag
        self.w = self.w * invMag
    end
end

--[[ Axis Rotation ]] do
    -- "Post-concatenate rotations about the coordinate axes"

    --- @param theta number
    --- @return QuaternionInstance
    function INSTANCE:RotateX( theta )
        -- "TODO: Optimize this"
        return self * STATIC.New( Vector( 1, 0, 0 ), theta )
    end

    --- @param theta number
    function INSTANCE:RotateY( theta )
        -- "TODO: Optimize this"
        return self * STATIC.New( Vector( 0, 1, 0 ), theta )
    end

    --- @param theta number
    function INSTANCE:RotateZ( theta )
        -- "TODO: Optimize this"
        return self * STATIC.New( Vector( 0, 0, 1 ), theta )
    end
end

--- "Initialize this quaternion randomly (creates a random *unit* quaternion)""
function INSTANCE:Randomize()
    self.x = bit.band( wwmath.Rand(), 0xFFFF ) / 65536.0
    self.y = bit.band( wwmath.Rand(), 0xFFFF ) / 65536.0
    self.z = bit.band( wwmath.Rand(), 0xFFFF ) / 65536.0
    self.w = bit.band( wwmath.Rand(), 0xFFFF ) / 65536.0

    self:Normalize()
end

--- "Transform (rotate) a vector with this quaternion"
--- @param vector Vector
--- @return Vector
function INSTANCE:RotateVector( vector )
    local x = self.w * vector.x + ( self.y * vector.z - vector.y * self.z )
    local y = self.w * vector.y + ( self.x * vector.z - vector.x * self.z )
    local z = self.w * vector.z + ( self.x * vector.y - vector.x * self.z )
    local w = -( self.x * vector.x + self.y * vector.y + self.z * vector.z )

    return Vector(
        w * (-self.x) + self.w * x + ( y * (-self.z) - (-self.y) * z ),
        w * (-self.y) + self.w * y - ( x * (-self.z) - (-self.x) * z ),
        w * (-self.z) + self.w * z + ( x * (-self.y) - (-self.x) * y )
    )
end

--- "Verify that none of the members of this quaternion are invalid floats"
--- @return boolean
function INSTANCE:IsValid()
    return (
        wwmath.IsValidFloat( self.x ) and
        wwmath.IsValidFloat( self.y ) and
        wwmath.IsValidFloat( self.z ) and
        wwmath.IsValidFloat( self.w )
    )
end

--- Initializes this quaternion to represent Euler angles.  
--- Uses roll, pitch, yaw order
--- Credit: https://danceswithcode.net/engineeringnotes/quaternions/quaternions.html
--- @param pitch number
--- @param yaw number
--- @param roll number
function INSTANCE:FromEuler( pitch, yaw, roll )
    local halfPitch = pitch / 2
    local halfYaw   = yaw   / 2
    local halfRoll  = roll  / 2

    local halfPitchCos = math.cos( halfPitch )
    local halfYawCos   = math.cos( halfYaw )
    local halfRollCos  = math.cos( halfRoll )

    local halfPitchSin = math.sin( halfPitch )
    local halfYawSin   = math.sin( halfYaw )
    local halfRollSin  = math.sin( halfRoll )

    local w = ( halfRollCos * halfPitchCos * halfYawCos ) + ( halfRollSin * halfPitchSin * halfYawSin )
    local x = ( halfRollSin * halfPitchCos * halfYawCos ) - ( halfRollCos * halfPitchSin * halfYawSin )
    local y = ( halfRollCos * halfPitchSin * halfYawCos ) + ( halfRollSin * halfPitchCos * halfYawSin )
    local z = ( halfRollCos * halfPitchCos * halfYawSin ) - ( halfRollSin * halfPitchSin * halfYawCos )

    self.w = w
    self.x = x
    self.y = y
    self.z = z
end

--- Retrieves Euler angles from this quaternion.  
--- Assumes roll, pitch, yaw order
--- Credit: https://danceswithcode.net/engineeringnotes/quaternions/quaternions.html
--- @return number pitch
--- @return number yaw
--- @return number roll
function INSTANCE:ToEuler()
    local x = self.x
    local y = self.y
    local z = self.z
    local w = self.w

    local rollY = 2 * ( w * x + y * z )
    local rollX = ( w * w ) - ( x * x ) - ( y * y ) + ( z * z )
    local roll = math.atan2( rollY, rollX )

    local pitchInput = 2 * ( w * y - x * z )

    local pitch = math.asin( pitchInput )

    local yaw
    if pitch == ( math.pi / 2 ) then
        roll = 0
        yaw = -2 * math.atan2( x, w )
    elseif pitch == -( wwmath.PI / 2 ) then
        roll = 0
        yaw = 2 * math.atan2( x, w )
    else
        local yawY = 2 * ( w * z + x * y )
        local yawX = ( w * w ) + ( x * x ) - ( y * y ) - ( z * z )
        yaw = math.atan2( yawY, yawX )
    end

    return pitch, yaw, roll
end
