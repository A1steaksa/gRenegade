-- Based on the macros within Code/wwlib/chunkio.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ChunkIOClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ChunkIOClass"


--#region Exported Enums
--#endregion


--#region Imports

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion


--#region Imported Enums
--#endregion

--- @class ChunkIOClass


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
    --- @param dataType FundamentalDataType
    --- @param storeTable any The table where the read value will be stored
    --- @param key any The key within the store table to store the data in
    --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
    --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
    function STATIC.ReadMicroChunk( cload, microChunkId, dataType, storeTable, key, subKey )
        -- Bail if this isn't our chunk ID
        if cload:CurMicroChunkId() ~= microChunkId then return false end

        return STATIC.LoadMicroChunk( cload, dataType, storeTable, key, subKey )
    end

    --- @param cload ChunkLoadInstance
    --- @param id integer
    --- @param dataType FundamentalDataType
    --- @param storeTable any The table where the read value will be stored
    --- @param key string
    --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
    function STATIC.ReadSafeMicroChunk( cload, id, dataType, storeTable, key )
        return STATIC.ReadMicroChunk( cload, id, dataType, storeTable, key )
    end

    --- @param cload ChunkLoadInstance
    --- @param id integer
    --- @param storeTable any The table where the read value will be stored
    --- @param key string
    --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
    function STATIC.ReadMicroChunkString( cload, id, storeTable, key )
        -- Bail if this isn't our chunk ID
        if cload:CurMicroChunkId() ~= id then return false end

        local microChunkLength = cload:CurMicroChunkLength()

        local readByteCount, readByteString = cload:Read( microChunkLength )
        if readByteCount == 0 then
            section.Error( "Attempted to read String micro-chunk (ID: " .. id .. ", Key: \"" .. key .. "\") of length " .. microChunkLength .. " but received " .. readByteCount .. " instead." )
            section.Error( "Position:" .. tostring( cload:Tell() ) )
        end
        --- @cast readByteString string

        -- The final byte of each string is 0x00 which needs to be stripped off
        local cleanedByteString = readByteString:sub( 1, -2 )

        if storeTable[key] ~= nil then
            section.Error( "Reading duplicate String micro-chunk (ID: " .. id .. ", Key: \"" .. key .. "\") of length " .. microChunkLength )
        end
        storeTable[key] = cleanedByteString

        return true
    end

    --- @param cload ChunkLoadInstance
    --- @param id integer
    --- @param storeTable any The table where the read value will be stored
    --- @param key string
    --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
    function STATIC.ReadMicroChunkWWString( cload, id, storeTable, key )
        return STATIC.ReadMicroChunkString( cload, id, storeTable, key )
    end

    --- @param cload ChunkLoadInstance
    --- @param id integer
    --- @param storeTable any The table where the read value will be stored
    --- @param key string
    --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
    function STATIC.ReadMicroChunkWideString( cload, id, storeTable, key )
        return STATIC.ReadMicroChunkString( cload, id, storeTable, key )
    end
end

--[[ Load ]] do

    --- If and only if the next micro-chunk's ID matches the provided ID, loads the micro-chunk as the provided data type and stores it in the provided key or subkey
    --- @param cload ChunkLoadInstance
    --- @param dataType FundamentalDataType
    --- @param storeTable any The table where the read value will be stored
    --- @param key any The key within the store table to store the data in
    --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
    --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
    function STATIC.LoadMicroChunk( cload, dataType, storeTable, key, subKey )
        local byteCount = deserializeLib.FundamentalDataTypeRegistry[dataType].Size
        if not byteCount then
            section.Error( "nil ByteCount during micro-chunk read of key:" .. ( key and key or "nil" ) )
        end
        --- @cast byteCount integer

        local readByteCount, readByteString = cload:Read( byteCount )
        if readByteCount == 0 then
            section.Error( "Failed to read micro chunk" )
        end
        --- @cast readByteString string

        local convertedData = deserializeLib.DeserializeFundamentalDataType( dataType, readByteString )

        if subKey ~= nil then
            local tbl
            if istable( key ) then
                tbl = key
            elseif isstring( key ) then
                tbl = storeTable[key]
            else
                typecheck.ArgumentTypeError( STATIC.Class, "ReadMicroChunk", 4, type(key), { "string", "table" } )
            end

            tbl[subKey] = convertedData
        else
            storeTable[key] = convertedData
        end

        return true
    end

    --- @param cload ChunkLoadInstance
    --- @param storeTable any The table where the read value will be stored
    --- @param key any The key within this object to store the read data in or a table to store the data in
    --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
    function STATIC.LoadMicroChunkWWString( cload, storeTable, key, subKey )
        local readByteCount, readByteString = cload:Read( cload:CurMicroChunkLength() )
        if readByteCount == 0 then
            section.Error( "Failed to read micro chunk string" )
        end
        --- @cast readByteString string

        if subKey then
            local existingValue = key[subKey]
            if existingValue ~= nil and existingValue ~= 0 then

                local tblNameString = ""
                if isstring( key ) then
                    tblNameString = "Table: " .. key .. ", "
                end

                section.Error( "Reading duplicate string micro-chunk ID " .. cload:CurMicroChunkId() .. " (" .. tblNameString .. "Subkey: \"" .. subKey .. "\") of length " .. cload:CurMicroChunkLength() .. ", Existing value: " .. tostring( existingValue ) )
            end

            local tbl
            if istable( key ) then
                tbl = key
            elseif isstring( key ) then
                tbl = storeTable[key]
            else
                typecheck.ArgumentTypeError( STATIC.Class, "ReadMicroChunk", 4, type(key), { "string", "table" } )
            end

            assert( istable( tbl ) )

            tbl[subKey] = readByteString
        else
            local existingValue = storeTable[key]
            if existingValue ~= nil and existingValue ~= 0 then
                section.Print( "Existing value:" .. tostring( existingValue ) )
                section.Error( "Reading duplicate string micro-chunk ID " .. cload:CurMicroChunkId() .. " (Key: \"" .. key .. "\") of length " .. cload:CurMicroChunkLength() )
            end

            storeTable[key] = readByteString
        end

        return true
    end

    --- @param cload ChunkLoadInstance
    --- @param key string
    function STATIC.LoadMicroChunkWideString( cload, key )
        typecheck.NotImplementedError()
    end
end

function STATIC.ObseleteMicroChunk( id )
    --- This exists to ignore a micro-chunk.  I'm not convinced it's entirely necessary but here we are
end
