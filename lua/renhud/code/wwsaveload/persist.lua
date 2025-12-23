-- Based on PersistClass within Code/wwsaveload/persist.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- Parent
--- @type PostLoadableClass
local parentClass = CNC.Import( "renhud/code/wwsaveload/post-loadable.lua" )

--- @class PersistClass : PostLoadableClass
--- @field instance PersistInstance The metatable used by PersistInstance
local STATIC = CNC.CreateExport( parentClass )
STATIC.Class = "PersistClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class PersistInstance : PostLoadableInstance
--- @field Static PersistClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Persist : Renegade_PostLoadable" )
INSTANCE.Class = "PersistInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPersist = true


--#region Exported Enums

    --- @enum DataType
    STATIC.DATA_TYPE = {
        UInt32  = 1,
        Int     = 2,
        Float   = 3,
        Boolean = 4,
    }
    local dataTypeEnum = STATIC.DATA_TYPE
--#endregion


--[[ Static Functions and Variables ]] do

    --- "  
    --- PersistClass defines the interface for an object to the save load system.
    --- Each concrete derived type of PersistClass must have an associated
    --- PersistFactoryClass that basically maps a [chunkId] to a constructor,
    --- a save function, a load function, and a [onPostLoad] function (taken from
    --- [PostLoadableInstance])
    --- "  
    --- @class PersistClass
    --- @field ByteSize integer How many bytes long is this class when saved into a file?

    --- All of the metadata associated with a given data type
    --- @class DataTypeInfo
    --- @field Name string The pretty, print-able name of this data type
    --- @field Size integer The number of bytes this data type takes up
    --- @field Converter fun( self: BinaryConverter, byteString: string ): number The function to convert a byte string of this data type into a Lua number

    local converter = BinaryConverter:Get()

    --- A look-up table of information about data types
    --- @type table<DataType, DataTypeInfo>
    STATIC.DataTypeRegistry = {
        [dataTypeEnum.UInt32] = {
            Name = "UInt32",
            Size = 4,
            Converter = converter.FromUInt32
        },

        [dataTypeEnum.Int] = {
            Name = "Int",
            Size = 4,
            Converter = converter.FromInt32
        },

        [dataTypeEnum.Float] = {
            Name = "Float",
            Size = 4,
            Converter = converter.FromFloat
        },

        [dataTypeEnum.Boolean] = {
            Name = "Boolean",
            Size = 1,
            Converter = converter.FromBoolean
        },
    }

    --- Converts a byte string into a given data type
    --- @param dataType DataType
    --- @param byteString string
    --- @return any
    function STATIC.Convert( dataType, byteString )
        local conversionFunction = STATIC.DataTypeRegistry[dataType].Converter
        if not conversionFunction then
            error( "No conversion function exists for data type: " .. ( dataType and dataType or nil ) )
        end

        return conversionFunction( converter, byteString )
    end

    --- Creates a new PersistInstance
    --- @vararg any
    --- @return PersistInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Persist", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PersistInstance, `false` otherwise
    function STATIC.IsPersist( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPersist and true or false
    end

    typecheck.RegisterType( "PersistInstance", STATIC.IsPersist )
end


--- @class PersistInstance

--- @return PersistFactoryInstance?
function INSTANCE:GetFactory()
end

--- @param csave ChunkSaveInstance
--- @return boolean
function INSTANCE:Save( csave )
    return true
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    return true
end


--[[ Chunk IO ]] do
    -- These were originally macros in Code/wwlib/chunkio.cpp/h but for our purposes it makes more sense to include them here.

    --[[ Write ]] do

        --[[ Chunks ]] do
        end

        --[[ Micro-Chunks ]] do
        end
    end

    --[[ Read ]] do

        --- If and only if the next micro-chunk's ID matches the provided ID, loads the micro-chunk as the provided data type and stores it in the provided key or subkey
        --- @param cload ChunkLoadInstance
        --- @param microChunkId integer
        --- @param dataType DataType
        --- @param key any The key within this object to store the data in
        --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function INSTANCE:ReadMicroChunk( cload, microChunkId, dataType, key, subKey )
            -- Bail if this isn't our chunk ID
            if cload:CurMicroChunkId() ~= microChunkId then return false end

            local keyString = ""
            if subKey then
                keyString = "Subkey: \"" .. tostring( subKey ) .. "\""
            else
                keyString = "Key: \"" .. tostring( key ) .. "\""
            end

            local typeRegistry = STATIC.DataTypeRegistry[dataType]

            local tblNameString = ""
            if isstring( key ) then
                tblNameString = "Table: \"" .. key .. "\", "
            end

            Section.Print( "Reading " .. typeRegistry.Name .. " micro-chunk (" .. tblNameString .. "ID: " .. microChunkId .. ", " .. keyString .. ") of length " .. typeRegistry.Size )

            return self:LoadMicroChunk( cload, dataType, key, subKey )
        end

        --- @param cload ChunkLoadInstance
        --- @param id integer
        --- @param dataType DataType
        --- @param key string
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function INSTANCE:ReadSafeMicroChunk( cload, id, dataType, key )
            return self:ReadMicroChunk( cload, id, dataType, key )
        end

        --- @param cload ChunkLoadInstance
        --- @param id integer
        --- @param key string
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function INSTANCE:ReadMicroChunkString( cload, id, key )
            -- Bail if this isn't our chunk ID
            if cload:CurMicroChunkId() ~= id then return false end

            local microChunkLength = cload:CurMicroChunkLength()

            Section.Print( "Reading String micro-chunk (ID: " .. id .. ", Key: \"" .. key .. "\") of length " .. microChunkLength )

            local readByteCount, readByteString = cload:Read( microChunkLength )
            if readByteCount == 0 then
                Section.Error( "Attempted to read String micro-chunk (ID: " .. id .. ", Key: \"" .. key .. "\") of length " .. microChunkLength .. " but received " .. readByteCount .. " instead." )
                Section.Error( "Position:" .. tostring( cload:Tell() ) )
            end
            --- @cast readByteString string

            -- The final byte of each string is 0x00 which needs to be stripped off
            local cleanedByteString = readByteString:sub( 1, -2 )

            if self[key] ~= nil then
                Section.Error( "Reading duplicate String micro-chunk (ID: " .. id .. ", Key: \"" .. key .. "\") of length " .. microChunkLength )
            end
            self[key] = cleanedByteString

            return true
        end

        --- @param cload ChunkLoadInstance
        --- @param id integer
        --- @param key string
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function INSTANCE:ReadMicroChunkWWString( cload, id, key )
            return self:ReadMicroChunkString( cload, id, key )
        end

        --- @param cload ChunkLoadInstance
        --- @param id integer
        --- @param key string
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function INSTANCE:ReadMicroChunkWideString( cload, id, key )
            return self:ReadMicroChunkString( cload, id, key )
        end
    end

    --[[ Load ]] do

        --- If and only if the next micro-chunk's ID matches the provided ID, loads the micro-chunk as the provided data type and stores it in the provided key or subkey
        --- @param cload ChunkLoadInstance
        --- @param dataType DataType
        --- @param key any The key within this object to store the data in
        --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function INSTANCE:LoadMicroChunk( cload, dataType, key, subKey )
            local byteCount = STATIC.DataTypeRegistry[dataType].Size
            if not byteCount then
                Section.Error( "nil ByteCount during micro-chunk read of key:" .. ( key and key or "nil" ) )
            end

            local readByteCount, readByteString = cload:Read( byteCount )
            if readByteCount == 0 then
                Section.Error( "Failed to read micro chunk" )
            end
            --- @cast readByteString string

            local convertedData = STATIC.Convert( dataType, readByteString )

            if subKey then
                local tbl
                if istable( key ) then
                    tbl = key
                elseif isstring( key ) then
                    tbl = self[key]
                else
                    typecheck.ArgumentTypeError( INSTANCE.Class, "ReadMicroChunk", 4, type(key), { "string", "table" } )
                end

                tbl[subKey] = convertedData
            else
                self[key] = convertedData
            end

            return true
        end

        --- @param cload ChunkLoadInstance
        --- @param key any The key within this object to store the read data in or a table to store the data in
        --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
        function INSTANCE:LoadMicroChunkWWString( cload, key, subKey )
            local readByteCount, readByteString = cload:Read( cload:CurMicroChunkLength() )
            if readByteCount == 0 then
                Section.Error( "Failed to read micro chunk string" )
            end
            --- @cast readByteString string

            if subKey then
                local existingValue = key[subKey]
                if existingValue ~= nil and existingValue ~= 0 then

                    local tblNameString = ""
                    if isstring( key ) then
                        tblNameString = "Table: " .. key .. ", "
                    end

                    Section.Error( "Reading duplicate string micro-chunk ID " .. cload:CurMicroChunkId() .. " (" .. tblNameString .. "Subkey: \"" .. subKey .. "\") of length " .. cload:CurMicroChunkLength() .. ", Existing value: " .. tostring( existingValue ) )
                end

                local tbl
                if istable( key ) then
                    tbl = key
                elseif isstring( key ) then
                    tbl = self[key]
                else
                    typecheck.ArgumentTypeError( INSTANCE.Class, "ReadMicroChunk", 4, type(key), { "string", "table" } )
                end

                assert( istable( tbl ) )

                tbl[subKey] = readByteString
            else
                local existingValue = self[key]
                if existingValue ~= nil and existingValue ~= 0 then
                    Section.Print( "Existing value:" .. tostring( existingValue ) )
                    Section.Error( "Reading duplicate string micro-chunk ID " .. cload:CurMicroChunkId() .. " (Key: \"" .. key .. "\") of length " .. cload:CurMicroChunkLength() )
                end

                self[key] = readByteString
            end

            return true
        end

        --- @param cload ChunkLoadInstance
        --- @param key string
        function INSTANCE:LoadMicroChunkWideString( cload, key )
           typecheck.NotImplementedError()
        end
    end

    function INSTANCE:ObseleteMicroChunk( id )
        --- This exists to ignore a micro-chunk.  I'm not convinced it's entirely necessary but here we are
    end
end