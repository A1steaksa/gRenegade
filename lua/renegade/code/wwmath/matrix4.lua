-- Based on Matrix4 within Code/WWMath/matrix4.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class Matrix4Class
--- @field Instance Matrix4Instance The metatable used by Matrix4Instance
local STATIC = CNC.CreateExport()
STATIC.Class = "Matrix4Class"
local isHotload = not table.IsEmpty( STATIC )

--- @class Matrix4Instance
--- @field Static Matrix4Class The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Matrix4" )
INSTANCE.Class = "Matrix4Instance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMatrix4 = true


--#region Imports

    --- @type Vector4Class
    local vector4Class = CNC.Import( "code/wwmath/vector4.lua" )

    --- @type Matrix3dClass
    local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class Matrix4

    --- Creates a new Matrix4Instance
    --- @vararg any
    --- @return Matrix4Instance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Matrix4", ... )
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) Matrix4Instance, `false` otherwise
    function STATIC.IsMatrix4( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMatrix4 and true or false
    end

    typecheck.RegisterType( "Matrix4Instance", STATIC.IsMatrix4 )
end


--[[ Instanced Functions and Variables ]] do

    --- [[ Public ]]

    --- @class Matrix4Instance
    --- @field Row Vector4Instance[]
    --- @operator mul( number  		  	): Matrix4Instance
    --- @operator mul( Matrix4Instance  ): Matrix4Instance
    --- @operator mul( Matrix3dInstance ): Matrix4Instance
    --- @operator mul( Vector 		  	): Vector4Instance
    --- @operator mul( Vector4Instance  ): Vector4Instance

    --- @class number
    --- @operator mul( Matrix4Instance  ): Matrix4Instance

    --- @class Matrix3dInstance
    --- @operator mul( Matrix4Instance  ): Matrix4Instance

    --- Constructs a new Matrix4Instance
    --- @vararg any
    function INSTANCE:Renegade_Matrix4( ... )
        local args = { ... }
        local argCount = select( "#", ... )

        self.Row = {
            vector4Class.New(),
            vector4Class.New(),
            vector4Class.New(),
            vector4Class.New()
        }

        -- Omitted constructors
        typecheck.AssertArgCount( INSTANCE.Class, argCount, 0 )
    end

    function INSTANCE:MakeIdentity()
        local row = self.Row

        row[1]:Set( 1, 0, 0, 0 )
        row[2]:Set( 0, 1, 0, 0 )
        row[3]:Set( 0, 0, 1, 0 )
        row[4]:Set( 0, 0, 0, 1 )
    end

    --- @overload fun( a: number,  		  	b: Matrix4Instance  ): Matrix4Instance
    --- @overload fun( a: Matrix4Instance,  b: number  		  	): Matrix4Instance
    --- @overload fun( a: Matrix4Instance,  b: Matrix4Instance  ): Matrix4Instance
    --- @overload fun( a: Matrix4Instance,  b: Matrix3dInstance ): Matrix4Instance
    --- @overload fun( a: Matrix4Instance,  b: Vector 		  	): Vector4Instance
    --- @overload fun( a: Matrix4Instance,  b: Vector4Instance  ): Vector4Instance
    --- @overload fun( a: Matrix3dInstance, b: Matrix4Instance  ): Matrix4Instance
    function INSTANCE.__mul( a, b )
        typecheck.AssertArgType( INSTANCE.Class, 1, a, { "number", "Matrix4Instance", "Matrix3dInstance" } )
        typecheck.AssertArgType( INSTANCE.Class, 2, b, { "number", "Vector", "Matrix4Instance", "Matrix3dInstance", "Vector4Instance" } )

        -- ( a: number, b: Matrix4Instance ): Matrix4Instance
        if isnumber( a ) then
            typecheck.AssertArgType( INSTANCE.Class, 2, b, "Matrix4Instance" )
            --- @cast a number
            --- @cast b Matrix4Instance
            return b * a
        end

        -- ( a: Matrix4Instance|Matrix3dInstance, b: Matrix4Instance ): Matrix4Instance
        if STATIC.IsMatrix4( b ) then
            typecheck.AssertArgType( INSTANCE.Class, 1, a, { "Matrix4Instance", "Matrix3dInstance" } )

            --- @cast a Matrix4Instance|Matrix3dInstance
            --- @cast b Matrix4Instance
            local aRow = a.Row
            local bRow = b.Row

            --- @param i integer
            --- @param j integer
            --- @return number
            local function rowCol( i, j )
                return (
                    aRow[i][1] * bRow[1][j] +
                    aRow[i][2] * bRow[2][j] +
                    aRow[i][3] * bRow[3][j] +
                    aRow[i][4] * bRow[4][j]
                )
            end

            -- ( a: Matrix4Instance, b: Matrix4Instance ): Matrix4Instance
            if STATIC.IsMatrix4( a ) then
                --- @cast a Matrix4Instance

                local result = STATIC.New()
                local resRow = result.Row
                resRow[1]:Set( rowCol( 1, 1 ), rowCol( 1, 2 ), rowCol( 1, 3 ), rowCol( 1, 4 ) )
                resRow[2]:Set( rowCol( 2, 1 ), rowCol( 2, 2 ), rowCol( 2, 3 ), rowCol( 2, 4 ) )
                resRow[3]:Set( rowCol( 3, 1 ), rowCol( 3, 2 ), rowCol( 3, 3 ), rowCol( 3, 4 ) )
                resRow[4]:Set( rowCol( 4, 1 ), rowCol( 4, 2 ), rowCol( 4, 3 ), rowCol( 4, 4 ) )
                return result
            end

            -- ( a: Matrix3dInstance, b: Matrix4Instance ): Matrix4Instance
            if STATIC.IsMatrix4( a ) then
                --- @cast a Matrix3dInstance

                -- "This function hand coded to handle the last row of b as 0,0,0,1"

                local result = STATIC.New()
                local resRow = result.Row
                resRow[1]:Set( rowCol( 1, 1 ), rowCol( 1, 2 ), rowCol( 1, 3 ), rowCol( 1, 4 ) )
                resRow[2]:Set( rowCol( 2, 1 ), rowCol( 2, 2 ), rowCol( 2, 3 ), rowCol( 2, 4 ) )
                resRow[3]:Set( rowCol( 3, 1 ), rowCol( 3, 2 ), rowCol( 3, 3 ), rowCol( 3, 4 ) )
                resRow[4]:Set( bRow[4][1], bRow[4][2], bRow[4][3], bRow[4][4] )
                return result
            end
        end

        if STATIC.IsMatrix4( a ) then

            -- ( a: Matrix4Instance, b: number ): Matrix4Instance
            if isnumber( b ) then
                --- @cast a Matrix4Instance
                --- @cast b number
                local row = a.Row
                return STATIC.New(
                    row[1] * b,
                    row[2] * b,
                    row[3] * b,
                    row[4] * b
                )
            end

            -- ( a: Matrix4Instance,  b: Matrix3dInstance ): Matrix4Instance
            if matrix3dClass.IsMatrix3d( b ) then
                --- @cast a Matrix4Instance
                --- @cast b Matrix3dInstance
                local aRow = a.Row
                local bRow = b.Row

                --- @param i integer
                --- @param j integer
                --- @return number
                local function rowCol( i, j )
                    return (
                        aRow[i][1] * bRow[1][j] +
                        aRow[i][2] * bRow[2][j] +
                        aRow[i][3] * bRow[3][j]
                    )
                end

                --- @param i integer
                --- @param j integer
                --- @return number
                local function rowColLast( i, j )
                    return (
                        aRow[i][1] * bRow[1][j] +
                        aRow[i][2] * bRow[2][j] +
                        aRow[i][3] * bRow[3][j] +
                        aRow[i][4]
                    )
                end

                local result = STATIC.New()
                local resRow = result.Row
                resRow[1]:Set( rowCol( 1, 1 ), rowCol( 1, 2 ), rowCol( 1, 3 ), rowColLast( 1, 4 ) )
                resRow[2]:Set( rowCol( 2, 1 ), rowCol( 2, 2 ), rowCol( 2, 3 ), rowColLast( 2, 4 ) )
                resRow[3]:Set( rowCol( 3, 1 ), rowCol( 3, 2 ), rowCol( 3, 3 ), rowColLast( 3, 4 ) )
                resRow[4]:Set( rowCol( 4, 1 ), rowCol( 4, 2 ), rowCol( 4, 3 ), rowColLast( 4, 4 ) )
                return result
            end

            -- ( a: Matrix4Instance, b: Vector ): Vector4Instance
            if isvector( b ) then
                --- @cast a Matrix4Instance
                --- @cast b Vector
                local aRow = a.Row

                -- "Assumes w=1.0"

                return vector4Class.New(
                    aRow[1][1] * b.x + aRow[1][2] * b.y + aRow[1][3] * b.z + aRow[1][4] * 1,
                    aRow[2][1] * b.x + aRow[2][2] * b.y + aRow[2][3] * b.z + aRow[2][4] * 1,
                    aRow[3][1] * b.x + aRow[3][2] * b.y + aRow[3][3] * b.z + aRow[3][4] * 1,
                    aRow[4][1] * b.x + aRow[4][2] * b.y + aRow[4][3] * b.z + aRow[4][4] * 1
                )
            end

            -- ( a: Matrix4Instance, b: Vector4Instance ): Vector4Instance
            if isvector( b ) then
                --- @cast a Matrix4Instance
                --- @cast b Vector4Instance
                local aRow = a.Row

                return vector4Class.New(
                    aRow[1][1] * b.x + aRow[1][2] * b.y + aRow[1][3] * b.z + aRow[1][4] * b.w,
                    aRow[2][1] * b.x + aRow[2][2] * b.y + aRow[2][3] * b.z + aRow[2][4] * b.w,
                    aRow[3][1] * b.x + aRow[3][2] * b.y + aRow[3][3] * b.z + aRow[3][4] * b.w,
                    aRow[4][1] * b.x + aRow[4][2] * b.y + aRow[4][3] * b.z + aRow[4][4] * b.w
                )
            end
        end
    end

    --- @param left number
    --- @param right number
    --- @param bottom number
    --- @param top number
    --- @param zNear number
    --- @param zFar number
    function INSTANCE:InitOrthographic( left, right, bottom, top, zNear, zFar )
        typecheck.NotImplementedError( "InitOrthographic" )
    end

    --- @overload fun( self: Matrix4Instance, left: number, right: number, bottom: number, top: number, zNear: number, zFar: number ): nil
    --- @overload fun( self: Matrix4Instance, horizontalFov: number, verticalFov: number, zNear: number, zFar: number ): nil
    function INSTANCE:InitPerspective( ... )
        local args = { ... }
        local argCount = select( "#", ... )
        typecheck.AssertArgCount( INSTANCE.Class, argCount, { 4, 6 } )
        typecheck.AssertArgType( INSTANCE.Class, 1, args[1], "number" )
        typecheck.AssertArgType( INSTANCE.Class, 2, args[2], "number" )
        typecheck.AssertArgType( INSTANCE.Class, 3, args[3], "number" )
        typecheck.AssertArgType( INSTANCE.Class, 4, args[4], "number" )

        -- ( self: Matrix4Instance, horizontalFov: number, verticalFov: number, zNear: number, zFar: number )
        if argCount == 4 then
            local horizontalFov = args[1] --[[@as number]]
            local verticalFov   = args[2] --[[@as number]]
            local zNear         = args[3] --[[@as number]]
            local zFar          = args[4] --[[@as number]]

            self:MakeIdentity()

            local row = self.Row
            row[1][1] =  ( 1 / math.tan( horizontalFov * 0.5 ) )
            row[2][2] =  ( 1 / math.tan( verticalFov   * 0.5 ) )
            row[3][3] = -( zFar + zNear ) / ( zFar - zNear )
            row[3][4] = -( 2 * zFar * zNear ) / ( zFar - zNear )
            row[4][3] = -1
            row[4][4] =  0

            return
        end

        -- ( left: number, right: number, bottom: number, top: number, zNear: number, zFar: number )
        if argCount == 6 then
            typecheck.AssertArgType( INSTANCE.Class, 5, args[5], "number" )
            typecheck.AssertArgType( INSTANCE.Class, 6, args[6], "number" )

            local left   = args[1] --[[@as number]]
            local right  = args[2] --[[@as number]]
            local bottom = args[3] --[[@as number]]
            local top    = args[4] --[[@as number]]
            local zNear  = args[5] --[[@as number]]
            local zFar   = args[6] --[[@as number]]

            self:MakeIdentity()

            local row = self.Row
            row[1][1] =  2 * zNear / ( right - left )
            row[2][3] =  ( right + left ) / ( right - left )
            row[2][2] =  2 * zNear / ( top - bottom )
            row[2][3] =  ( top + bottom ) / ( top - bottom )
            row[3][3] = -( zFar + zNear ) / ( zFar - zNear )
            row[3][4] = -( 2 * zFar * zNear ) / ( zFar - zNear )
            row[4][3] = -1
            row[4][4] =  0
            return
        end
    end
end