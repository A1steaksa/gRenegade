-- Based on Vector4 within Code/WWMath/vector4.h

--- @class Renegade
local CNC = CNC_RENEGADE

local STATIC, INSTANCE

--[[ Class Setup ]] do

    --- The instanced components of Vector4
    --- @class Vector4Instance
    --- @field Static Vector4 The static table for this instance's class
    INSTANCE = robustclass.Register( "Renegade_Vector4" )

    --- The static components of Vector4
    --- @class Vector4
    --- @field Instance Vector4Instance The Metatable used by Vector4Instance
    STATIC = CNC.CreateExport()

    STATIC.Instance = INSTANCE
    INSTANCE.Static = STATIC
    INSTANCE.IsVector4 = true
end


--[[ Static Functions and Variables ]] do

    local CLASS = "Vector4"

    --- [[ Public ]]

    --- @class Vector4

    --- Creates a new Vector4Instance
    --- @overload fun(): Vector4Instance
    --- @overload fun( x: number, y: number, x: number, w: number ): Vector4Instance
    --- @overload fun( other: Vector4Instance ): Vector4Instance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Vector4", ... )
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) Vector4Instance, `false` otherwise
    function STATIC.IsVector4( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsVector4 and true or false
    end

    typecheck.RegisterType( "Vector4Instance", STATIC.IsVector4 )

    --- @param vector Vector4Instance
    --- @return Vector4Instance
    function STATIC.Normalize( vector )
        local length2 = vector:Length2()
        if length2 ~= 0 then
            local normalizingMultiplier = 1 / math.sqrt( length2 )
            return vector * normalizingMultiplier
        end
        return STATIC.New( 0, 0, 0, 0 )
    end

    --- @param a Vector4Instance
    --- @param b Vector4Instance
    function STATIC.DotProduct( a, b )
        return a * b
    end

    -- Omitted Swap function

    --- @param a Vector4Instance
    --- @param b Vector4Instance
    --- @param alpha number
    --- @return Vector4Instance
    function STATIC.Lerp( a, b, alpha )
        return STATIC.New(
            ( a.x + ( b.x - a.x ) * alpha ),
            ( a.y + ( b.y - a.y ) * alpha ),
            ( a.z + ( b.z - a.z ) * alpha ),
            ( a.w + ( b.w - a.w ) * alpha )
        )
    end

end


--[[ Instanced Functions and Variables ]] do
    local CLASS = "Vector4Instance"

    --- [[ Public ]]

    --- @class Vector4Instance : table
    --- @field x number
    --- @field y number
    --- @field z number
    --- @field w number
    --- @field private Data {x: number, y: number, z: number, w: number}


    --- Constructs a new Vector4Instance
    function INSTANCE:Renegade_Vector4( ... )
        local args = { ... }
        local argCount = select( "#", ... )

        typecheck.AssertArgCount( CLASS, argCount, { 0, 1, 4 } )

        self.Data = {
            x = 0,
            y = 0,
            z = 0,
            w = 0
        }

        -- ()
        if argCount == 0 then
            self.x = 0
            self.y = 0
            self.z = 0
            self.w = 0
            return
        end

        if argCount == 1 then
            typecheck.AssertArgType( CLASS, 1, args[1], { "Vector4Instance", "table" } )

            -- ( other: Vector4Instance )
            if STATIC.IsVector4( args[1] ) then
                local other = args[1] --[[@as Vector4Instance]]
                self.x = other.x
                self.y = other.y
                self.z = other.z
                self.w = other.w
                return

            -- ( tbl: number[4] )
            else
                local tbl = args[1] --[[@as number[] ]]
                self.x = tbl[1]
                self.y = tbl[2]
                self.z = tbl[3]
                self.w = tbl[4]
                return
            end
        end

        --- ( x: number, y: number, x: number, w: number )
        if argCount == 4 then
            typecheck.AssertArgType( CLASS, 1, args[1], "number" )
            typecheck.AssertArgType( CLASS, 2, args[2], "number" )
            typecheck.AssertArgType( CLASS, 3, args[3], "number" )
            typecheck.AssertArgType( CLASS, 4, args[4], "number" )

            self.x = args[1] --[[@as number]]
            self.y = args[2] --[[@as number]]
            self.z = args[3] --[[@as number]]
            self.w = args[4] --[[@as number]]
            return
        end
    end

    --[[ Operators ]] do

        --- Getting values
        --- @param self Vector4Instance
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
        --- @param self Vector4Instance
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

        --- Unary negation
        --- @param self Vector4Instance
        function INSTANCE.__unm( self )
            return STATIC.New( -self.x, -self.y, -self.z, -self.w )
        end

        --- Equality
        --- @param a Vector4Instance
        --- @param b Vector4Instance
        --- @return boolean
        function INSTANCE.__eq( a, b )
            return (
                a.x == b.x and
                a.y == b.y and
                a.z == b.z and
                a.w == b.w
            )
        end

        --- Addition
        --- @param a Vector4Instance
        --- @param b Vector4Instance
        --- @return Vector4Instance
        function INSTANCE.__add( a, b )
            return STATIC.New(
                a.x + b.x,
                a.y + b.y,
                a.z + b.z,
                a.w + b.w
            )
        end

        --- Subtraction
        --- @param a Vector4Instance
        --- @param b Vector4Instance
        --- @return Vector4Instance
        function INSTANCE.__sub( a, b )
            return STATIC.New(
                a.x - b.x,
                a.y - b.y,
                a.z - b.z,
                a.w - b.w
            )
        end

        --- Multiplication
        --- @param a Vector4Instance|number
        --- @param b Vector4Instance|number
        --- @overload fun( a: Vector4Instance, b: number ): Vector4Instance
        --- @overload fun( a: number, b: Vector4Instance ): Vector4Instance
        --- @overload fun( a: Vector4Instance, b: Vector4Instance ): number
        function INSTANCE:__mul( a, b )
            typecheck.AssertArgType( CLASS, 1, a, { "Vector4Instance", "number" } )
            typecheck.AssertArgType( CLASS, 2, b, { "Vector4Instance", "number" } )

            -- ( a: number, b: Vector4Instance ): Vector4Instance
            if isnumber( a ) then
                local scalar = a --[[@as number]]
                local vector = b --[[@as Vector4Instance]]

                return STATIC.New(
                    vector.x * scalar,
                    vector.y * scalar,
                    vector.z * scalar,
                    vector.w * scalar
                )

            -- ( a: Vector4Instance, b: number ): Vector4Instance
            elseif isnumber( b ) then
                local vector = a --[[@as Vector4Instance]]
                local scalar = b --[[@as number]]

                return STATIC.New(
                    vector.x * scalar,
                    vector.y * scalar,
                    vector.z * scalar,
                    vector.w * scalar
                )

            -- ( a: Vector4Instance, b: Vector4Instance ): number
            else
                --- @cast a Vector4Instance
                --- @cast b Vector4Instance

                return (
                    a.x * b.x +
                    a.y * b.y +
                    a.z * b.z +
                    a.w * b.w
                )
            end
        end
    end

    function INSTANCE:__tostring()
        return "Vector4(" .. self.x .. ", " .. self.y .. ", " .. self.z .. ", " .. self.w .. ")"
    end

    function INSTANCE:Normalize()
        local length2 = self:Length2()
        if length2 ~= 0 then
            local normalizingMultiplier = ( 1 / math.sqrt( length2 ) )
            self.x = self.x * normalizingMultiplier
            self.y = self.y * normalizingMultiplier
            self.z = self.z * normalizingMultiplier
            self.w = self.w * normalizingMultiplier
        end
    end

    --- @return number # The length of the Vector4Instance
    function INSTANCE:Length()
        return math.sqrt( self:Length2() )
    end

    --- @return number # The square of the Vector4Instance's length
    function INSTANCE:Length2()
        return (
            self.x * self.x +
            self.y * self.y +
            self.z * self.z +
            self.w * self.w
        )
    end

    --- @param x number
    --- @param y number
    --- @param z number
    --- @param w number
    function INSTANCE:Set( x, y, z, w )
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    end

    -- Omitted IsValid function
end