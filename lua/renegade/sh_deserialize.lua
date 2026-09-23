-- A library to make it easy to convert byte strings into various data types and structs containing those data types

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DeserializeLib
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DeserializeLib"

--#region Exported Enums

    --- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum FundamentalDataType
    STATIC.FUNDAMENTAL_DATA_TYPE = {
        UInt32  = enumBuilder:Set( 1 ),
        UInt16  = enumBuilder:Next(),
        UInt8   = enumBuilder:Next(),
        Int     = enumBuilder:Next(),
        ULong   = enumBuilder:Next(),
        Long    = enumBuilder:Next(),
        Float   = enumBuilder:Next(),
        Float32 = enumBuilder:Next(),
        Boolean = enumBuilder:Next(),
        String  = enumBuilder:Next(),
        Pointer = enumBuilder:Next(),
    }
    local fundamentalDataTypeEnum = STATIC.FUNDAMENTAL_DATA_TYPE
--#endregion


--#region Imports

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )
--#endregion


--#region Imported Enums
--#endregion


--- @class DeserializeLib

--- @class ComplexDataTypeSchemaField
--- @field Name string The key that this field will be stored under
--- @field DataType string|FundamentalDataType Either the name of a complex data type or a fundamental data type enum
--- @field Length integer? (Optional) The number of bytes this field consumes if the data type isn't fixed-length
--- @field ArrayLength integer? (Optional) Makes this field into an array if set

--- A "union" of several possible fields.  The largest sized field will be the amount of bytes read
--- @class ComplexDataTypeSchemaUnionField
--- @field Union ComplexDataTypeSchema

--- @alias ComplexDataTypeSchema (ComplexDataTypeSchemaField|ComplexDataTypeSchemaUnionField)[]


--- @class FundamentalDataTypeInfo
--- @field Name string The pretty, print-able name of this data type
--- @field DataType FundamentalDataType 
--- @field DefaultValue any What the default state of this data type is when initialized without a specific value
--- @field Size integer The number of bytes this data type takes up
--- @field ConversionFunction fun( bytes: string ): any

--- @type table<FundamentalDataType, FundamentalDataTypeInfo>
STATIC.FundamentalDataTypeRegistry = {}


--- @class ComplexDataTypeInfo
--- @field Name string The name that will be used to reference to this data type
--- @field Schema ComplexDataTypeSchema The layout of the complex data type
--- @field Size integer The size, in bytes, of this data type

--- @type table<string, ComplexDataTypeInfo>
STATIC.ComplexDataTypeRegistry = {}


function STATIC.StaticConstructor()
    STATIC.RegisterFundamentalDataType( "UInt32",  fundamentalDataTypeEnum.UInt32,      0, 4,  STATIC.DeserializeUInt32  )
    STATIC.RegisterFundamentalDataType( "UInt16",  fundamentalDataTypeEnum.UInt16,      0, 2,  STATIC.DeserializeUInt16  )
    STATIC.RegisterFundamentalDataType( "UInt8",   fundamentalDataTypeEnum.UInt8,       0, 1,  STATIC.DeserializeUInt8   )
    STATIC.RegisterFundamentalDataType( "Int",     fundamentalDataTypeEnum.Int,         0, 4,  STATIC.DeserializeUInt32  )
    STATIC.RegisterFundamentalDataType( "ULong",   fundamentalDataTypeEnum.ULong,       0, 4,  STATIC.DeserializeUInt32  )
    STATIC.RegisterFundamentalDataType( "Long",    fundamentalDataTypeEnum.Long,        0, 4,  STATIC.DeserializeInt32   )
    STATIC.RegisterFundamentalDataType( "Float",   fundamentalDataTypeEnum.Float,     0.0, 4,  STATIC.DeserializeFloat   )
    STATIC.RegisterFundamentalDataType( "Float32", fundamentalDataTypeEnum.Float32,   0.0, 4,  STATIC.DeserializeFloat   )
    STATIC.RegisterFundamentalDataType( "Boolean", fundamentalDataTypeEnum.Boolean, false, 1,  STATIC.DeserializeBoolean )
    STATIC.RegisterFundamentalDataType( "Pointer", fundamentalDataTypeEnum.Pointer,   0, 4,  STATIC.DeserializeUInt32 )

    STATIC.RegisterComplexDataType( "Vector", {
        { Name = "X", DataType = fundamentalDataTypeEnum.Float },
        { Name = "Y", DataType = fundamentalDataTypeEnum.Float },
        { Name = "Z", DataType = fundamentalDataTypeEnum.Float },
    } )
end


--[[ Registration ]] do

    --- @param name string
    --- @param dataType FundamentalDataType
    --- @param defaultValue any
    --- @param size integer
    --- @param conversionFunction fun( bytes: string ): any
    function STATIC.RegisterFundamentalDataType( name, dataType, defaultValue, size, conversionFunction )
        STATIC.FundamentalDataTypeRegistry[dataType] = {
            Name               = name,
            DataType           = dataType,
            Size               = size,
            DefaultValue       = defaultValue,
            ConversionFunction = conversionFunction
        }
    end

    --- @param name string
    --- @param schema ComplexDataTypeSchema
    function STATIC.RegisterComplexDataType( name, schema )
        local size = STATIC.CalculateSchemaSize( schema )

        STATIC.ComplexDataTypeRegistry[name] = {
            Name     = name,
            Schema   = schema,
            Size     = size
        }
    end

    --- @param unionFields ComplexDataTypeSchema
    --- @return integer byteCount
    function STATIC.CalculateSchemaUnionFieldSize( unionFields )
        local unionSize = 0

        for unionFieldIndex, unionField in ipairs( unionFields ) do
            local unionFieldSize
            if unionField.Union ~= nil then
                --- @cast unionField ComplexDataTypeSchemaUnionField

                unionFieldSize = STATIC.CalculateSchemaUnionFieldSize( unionField.Union )
            else
                --- @cast unionField ComplexDataTypeSchemaField

                unionFieldSize = STATIC.CalculateSchemaFieldSize( unionField )
            end

            unionSize = math.max( unionSize, unionFieldSize )
        end

        return unionSize
    end

    --- @param schemaField ComplexDataTypeSchemaField
    --- @return integer byteCount
    function STATIC.CalculateSchemaFieldSize( schemaField )
        local dataTypeSize
        if schemaField.DataType == fundamentalDataTypeEnum.String then
            dataTypeSize = schemaField.Length
        else
            dataTypeSize = STATIC.GetDataTypeSize( schemaField.DataType )
        end

        local countMultiplier = schemaField.ArrayLength or 1

        return dataTypeSize * countMultiplier
    end

    --- @param schema ComplexDataTypeSchema
    --- @return integer byteCount
    function STATIC.CalculateSchemaSize( schema )
        local schemaSize = 0

        for schemaIndex, schemaEntry in ipairs( schema ) do
            local entrySize  = 0

            if schemaEntry.Union ~= nil then
                --- @cast schemaEntry ComplexDataTypeSchemaUnionField

                entrySize = STATIC.CalculateSchemaUnionFieldSize( schemaEntry.Union )
            else
                --- @cast schemaEntry ComplexDataTypeSchemaField

                entrySize = STATIC.CalculateSchemaFieldSize( schemaEntry )
            end

            schemaSize = schemaSize + entrySize
        end

        return schemaSize
    end
end


--[[ Accessors ]] do

    --- @param dataType any
    --- @return boolean
    function STATIC.IsFundamentalDataType( dataType )
        return STATIC.FundamentalDataTypeRegistry[dataType] ~= nil
    end

    --- @param dataType any
    --- @return boolean
    function STATIC.IsComplexDataType( dataType )
        return STATIC.ComplexDataTypeRegistry[dataType] ~= nil
    end

    --- @param dataType string|FundamentalDataType
    --- @return string
    function STATIC.GetDataTypeName( dataType )
        if typecheck.IsOfType( dataType, "string" ) then
            return dataType --[[@as string]]
        elseif typecheck.IsOfType( dataType, "number" ) then
            return table.KeyFromValue( fundamentalDataTypeEnum, dataType )
        end
        return "Unknown data type '" .. tostring( dataType ) .. "'"
    end

    --- @param dataType FundamentalDataType|string
    --- @return integer
    function STATIC.GetDataTypeSize( dataType )
        if STATIC.IsFundamentalDataType( dataType ) then
            return STATIC.GetFundamentalDataTypeSize( dataType --[[@as FundamentalDataType]] )
        elseif STATIC.IsComplexDataType( dataType ) then
            return STATIC.GetComplexDataTypeSize( dataType --[[@as string]] )
        end

        section.Error( "Unable to get size of datatype '", dataType, "' which is neither a registered fundamental or complex data type" )
        return -1
    end

    --- @param dataType FundamentalDataType
    --- @return integer
    function STATIC.GetFundamentalDataTypeSize( dataType )
        local registerEntry = STATIC.FundamentalDataTypeRegistry[dataType]
        if registerEntry == nil then
            section.Error( "The provided data type '", dataType, "' is not a registered fundamental data type" )
            return -1
        end

        return registerEntry.Size
    end

    --- @param dataType FundamentalDataType
    --- @return any
    function STATIC.GetFundamentalDataTypeDefault( dataType )
        return STATIC.FundamentalDataTypeRegistry[dataType].DefaultValue
    end

    --- @param dataType string
    --- @return integer
    function STATIC.GetComplexDataTypeSize( dataType )
        local registerEntry = STATIC.ComplexDataTypeRegistry[dataType]
        if registerEntry == nil then
            section.Error( "The provided data type '", dataType, "' is not a registered complex data type" )
            return -1
        end

        return registerEntry.Size
    end
end


--[[ Deserializers ]] do

    -- Credit for the original binary C++ parsing code goes to:
    -- ----------------------------------------------------------------------------
    -- Kamil Marciniak <github.com/forkerer> wrote this code. As long as you retain this 
    -- notice, you can do whatever you want with this stuff. If we
    -- meet someday, and you think this stuff is worth it, you can
    -- buy me a beer in return.
    -- ----------------------------------------------------------------------------

    --- @generic T
    --- @param dataType FundamentalDataType|`T`
    --- @param bytes string
    --- @return T
    function STATIC.Deserialize( dataType, bytes )
        -- Strings get special handling
        if dataType == fundamentalDataTypeEnum.String then
            -- If there's a null byte in the string, treat that as the end of the string
            local nullIndex = textUtils.IndexOf( bytes, "\0" )
            if nullIndex ~= nil then
                return bytes:sub( 0, nullIndex - 1 )
            end

            return bytes
        end

        if STATIC.IsFundamentalDataType( dataType ) then
            return STATIC.DeserializeFundamentalDataType( dataType --[[@as FundamentalDataType]], bytes )
        elseif STATIC.IsComplexDataType( dataType ) then
            return STATIC.DeserializeComplexDataType( dataType --[[@as string]], bytes )
        end

        section.Error( "Unable to deserialize datatype '", dataType, "' which is neither a registered fundamental or complex data type" )
    end

    --- @generic T
    --- @param dataType FundamentalDataType|`T`
    --- @param bytes string
    --- @return T[]|any[]
    function STATIC.DeserializeArray( dataType, bytes )
        local dataTypeSize = STATIC.GetDataTypeSize( dataType )

        local arrayLength = bytes:len() / dataTypeSize
        if arrayLength ~= math.floor( arrayLength ) then
            section.Error( "Cannot deserialize array of datatype '", dataType, "' from ", bytes:len(), " bytes of data.  Datatype requires ", dataTypeSize, " bytes.  Got non-integer array length of: ", arrayLength, "" )
        end

        local result = {}
        for i = 0, arrayLength - 1 do
            local startIndex = 1 + i * dataTypeSize
            local dataTypeBytes = bytes:sub( startIndex, startIndex + dataTypeSize )

            result[#result+1] = STATIC.Deserialize( dataType, dataTypeBytes )
        end

        return result
    end

    --- @generic T
    --- @param dataType `T`
    --- @param bytes string
    --- @return T?
    function STATIC.DeserializeComplexDataType( dataType, bytes )
        local registeryEntry = STATIC.ComplexDataTypeRegistry[dataType]
        if registeryEntry == nil then
            section.Error( "The provided data type '", dataType, "' is not a registered complex data type" )
            return
        end

        local result
        if robustclass.IsClassRegistered( dataType ) then
            result = robustclass.Create( dataType )
        else
            result = {}
        end

        local schema = registeryEntry.Schema
        for schemaFieldIndex, schemaField in ipairs( schema ) do

            -- Union field
            if schemaField.Union then
                --- @cast schemaField ComplexDataTypeSchemaUnionField

                local bytesToRead = STATIC.CalculateSchemaUnionFieldSize( schemaField.Union )

                if bytes:len() < bytesToRead then
                    section.Error( "Attempted to read ", bytesToRead, " bytes but only ", bytes:len(), " bytes remain" )
                    return
                end

                -- Get the bytes for this union
                local extractedBytes = bytes:sub( 1, bytesToRead )
                bytes = bytes:sub( bytesToRead + 1 )

                -- Deserialize those same bytes into each of the possible fields of the union
                for unionFieldIndex, unionField in ipairs( schemaField.Union ) do
                    result[unionField.Name] = STATIC.Deserialize( unionField.DataType, extractedBytes )
                end

            -- Single field
            else
                --- @cast schemaField ComplexDataTypeSchemaField

                local isArray = ( schemaField.ArrayLength ~= nil )
                local isfundamentalDataType = isnumber( schemaField.DataType )

                -- Figure out how many bytes each of this data type takes up
                local bytesToRead
                if schemaField.DataType == fundamentalDataTypeEnum.String then
                    bytesToRead = schemaField.Length
                elseif isfundamentalDataType then
                    bytesToRead = STATIC.GetFundamentalDataTypeSize( schemaField.DataType --[[@as FundamentalDataType]] )
                else
                    bytesToRead = STATIC.GetComplexDataTypeSize( schemaField.DataType --[[@as string]] )
                end

                if isArray then
                    local fieldArray = {}
                    result[schemaField.Name] = fieldArray

                    -- Deserialize each element of the array
                    for i = 1, schemaField.ArrayLength do
                        -- Get this array element's bytes
                        local extractedBytes = bytes:sub( 1, bytesToRead )
                        bytes = bytes:sub( bytesToRead + 1)

                        fieldArray[i] = STATIC.Deserialize( schemaField.DataType, extractedBytes )
                    end
                else
                    -- Get this field's bytes
                    local extractedBytes = bytes:sub( 1, bytesToRead )
                    bytes = bytes:sub( bytesToRead + 1 )
                    if extractedBytes:len() ~= bytesToRead then
                        section.Error( "Tried to extract ", bytesToRead, " bytes but got ", extractedBytes:len(), " bytes instead" )
                    end

                    result[schemaField.Name] = STATIC.Deserialize( schemaField.DataType, extractedBytes )
                end
            end
        end

        return result
    end

    --- @param dataType FundamentalDataType
    --- @param bytes string
    --- @return any
    function STATIC.DeserializeFundamentalDataType( dataType, bytes )
        local registeryEntry = STATIC.FundamentalDataTypeRegistry[dataType]
        if registeryEntry == nil then
            section.Error( "The provided data type '", dataType, "' is not a registered fundamental data type" )
            return
        end

        return registeryEntry.ConversionFunction( bytes )
    end

    --- @param bytes string
    --- @return integer
    function STATIC.DeserializeUInt64( bytes )
        local b1, b2, b3, b4, b5, b6, b7, b8 = bytes:byte( 1, 8 )
        return (
            b8 * 0x100000000000000 +
            b7 * 0x1000000000000 +
            b6 * 0x10000000000 +
            b5 * 0x100000000 +
            b4 * 0x1000000 +
			b3 * 0x10000 +
			b2 * 0x100 +
			b1
        )
    end

    --- @param bytes string
    --- @return integer
    function STATIC.DeserializeInt64( bytes )
        local unsignedInt = STATIC.DeserializeUInt64( bytes )

        if unsignedInt > 0x7FFFFFFFFFFFFFFF then
            return ( unsignedInt - 0x10000000000000000 )
        end

        return unsignedInt
    end

    --- @param bytes string
    --- @return integer
    function STATIC.DeserializeUInt32( bytes )
        local b1, b2, b3, b4 = bytes:byte( 1, 4 )
        return (
            b4 * 0x1000000 +
			b3 * 0x10000 +
			b2 * 0x100 +
			b1
        )
    end

    --- @param bytes string
    --- @return integer
    function STATIC.DeserializeInt32( bytes )
        local unsignedInt = STATIC.DeserializeUInt32( bytes )

        if unsignedInt > 0x7FFFFFFF then
            return ( unsignedInt - 0x100000000 )
        end

        return unsignedInt
    end

    --- @param bytes string
    --- @return integer
    function STATIC.DeserializeUInt16( bytes )
        local b1, b2 = bytes:byte( 1, 2 )
        return (
			b2 * 0x100 +
			b1
        )
    end

    --- @param bytes string
    --- @return integer
    function STATIC.DeserializeUInt8( bytes )
        return bytes:byte( 1 )
    end

    --- @param bytes string
    --- @return number
    function STATIC.DeserializeFloat( bytes )
        local b4, b3, b2, b1 = bytes:byte( 1, 4 )

        local sign = ( b1 > 128 and -1 ) or 1
        local mantissa = b2 % 0x80 * 0x10000 + b3 * 0x100 + b4
        local exp = math.floor( ( ( b1 % 128 ) * 0x100 + b2 ) / 0x80 ) - 127
        local convertedNumber = 2 ^ exp * ( mantissa / 0x800000 + 1 )
        local result = sign * convertedNumber

        return math.IsNearlyEqual( result, 0, 0.0000001 ) and 0 or result
    end

    --- @param bytes string
    --- @return boolean
    function STATIC.DeserializeBoolean( bytes )
        return STATIC.DeserializeUInt8( bytes ) == 1
    end
end

