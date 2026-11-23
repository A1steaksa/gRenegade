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

	--- @type SaveLoadIds
	local saveLoadIds = CNC.Import( "code/wwsaveload/save-load-ids.lua" )

	--- @type CommandoChunkIds
	local commandoChunkIds = CNC.Import( "code/commando/commando-chunk-ids.lua" )

	--- @type SoundChunkIds
	local soundChunkIds = CNC.Import( "code/wwaudio/sound-chunk-ids.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type TranslateDbIdsClass
	local translateDbIdsClass = CNC.Import( "code/wwtranslatedb/translate-db-ids.lua" )
--#endregion


--#region Imported Enums

	local soundChunkIdEnum = soundChunkIds.SOUND_CHUNK_ID
--#endregion

--- @class ChunkIOClass

--- @param chunkId integer
--- @return string
function STATIC.GetChunkIdName( chunkId )
    local chunkName = table.KeyFromValue( combatChunkIdClass, chunkId )
    chunkName = chunkName or table.KeyFromValue( soundChunkIdEnum, chunkId )
    chunkName = chunkName or table.KeyFromValue( commandoChunkIds.CHUNK_ID, chunkId )
    chunkName = chunkName or table.KeyFromValue( saveLoadIds.ChunkIds, chunkId )
    chunkName = chunkName or table.KeyFromValue( translateDbIdsClass.ChunkIds, chunkId )

    return ( chunkName == nil and "unknown" or chunkName )
end


-- These were originally macros in Code/wwlib/chunkio.cpp/h but for our purposes it makes more sense to include them here.

--[[ Write ]] do

    --[[ Chunks ]] do
    end

    --[[ Micro-Chunks ]] do
    end
end

--[[ Read ]] do

    --[[ Chunks ]] do

        --- @param cload ChunkLoadInstance
        --- @param chunkId integer
        --- @param storeTable any The table where the read value will be stored
        --- @param key any The key within the store table to store the data in
        --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
        --- @return boolean # `true` if the current chunk ID matched this ID, `false` if this function was skipped
        function STATIC.ReadWWStringChunk( cload, chunkId, storeTable, key, subKey )
            -- Bail if this isn't our chunk ID
            if cload:CurChunkId() ~= chunkId then return false end

            return STATIC.LoadChunkWWString( cload, storeTable, key, subKey )
        end
    end

    --[[ Micro-Chunks ]] do

        --- If and only if the next micro-chunk's ID matches the provided ID, loads the micro-chunk as the provided data type and stores it in the provided key or subkey
        --- @param cload ChunkLoadInstance
        --- @param microChunkId integer
        --- @param dataType FundamentalDataType|string
        --- @param storeTable any The table where the read value will be stored
        --- @param key any The key within the store table to store the data in
        --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function STATIC.ReadMicroChunk( cload, microChunkId, dataType, storeTable, key, subKey )
            -- Bail if this isn't our micro chunk ID
            if cload:CurMicroChunkId() ~= microChunkId then return false end

            return STATIC.LoadMicroChunk( cload, dataType, storeTable, key, subKey )
        end

        --- @param cload ChunkLoadInstance
        --- @param id integer
        --- @param dataType FundamentalDataType
        --- @param storeTable any The table where the read value will be stored
        --- @param key any
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function STATIC.ReadSafeMicroChunk( cload, id, dataType, storeTable, key )
            return STATIC.ReadMicroChunk( cload, id, dataType, storeTable, key )
        end

        --- @param cload ChunkLoadInstance
        --- @param id integer
        --- @param storeTable any The table where the read value will be stored
        --- @param key any
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function STATIC.ReadMicroChunkString( cload, id, storeTable, key )
            -- Bail if this isn't our micro chunk ID
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
        --- @param key any
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function STATIC.ReadMicroChunkWWString( cload, id, storeTable, key )
            return STATIC.ReadMicroChunkString( cload, id, storeTable, key )
        end

        --- @param cload ChunkLoadInstance
        --- @param id integer
        --- @param storeTable any The table where the read value will be stored
        --- @param key any
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function STATIC.ReadMicroChunkWideString( cload, id, storeTable, key )
            return STATIC.ReadMicroChunkString( cload, id, storeTable, key )
        end
    end
end

--[[ Load ]] do

    --[[ Chunks ]] do

        --- @param cload ChunkLoadInstance
        --- @param storeTable any The table where the read value will be stored
        --- @param key any The key within this object to store the read data in or a table to store the data in
        --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
        function STATIC.LoadChunkWWString( cload, storeTable, key, subKey )
            local readByteCount, readByteString = cload:Read( cload:CurChunkLength() )
            if readByteCount == 0 then
                section.Error( "Failed to read chunk string" )
            end
            --- @cast readByteString string

            -- section.Print( "Before trimming: '", readByteString, "'" )


            -- Commented to because it was causing all translated strings to come back as only a single character.
            -- I'm guessing this is because the text is stored in UTF16 or something stupid like that
            -- readByteString = readByteString:TrimRight( string.char( 0x00 ) )

            if subKey then
                local existingValue = key[subKey]
                if existingValue ~= nil and existingValue ~= 0 then

                    local tblNameString = ""
                    if isstring( key ) then
                        tblNameString = "Table: " .. key .. ", "
                    end

                    section.Error( "Reading duplicate string chunk ID " .. cload:CurChunkId() .. " (" .. tblNameString .. "Subkey: \"" .. subKey .. "\") of length " .. cload:CurChunkLength() .. ", Existing value: " .. tostring( existingValue ) )
                end

                local tbl
                if istable( key ) then
                    tbl = key
                elseif isstring( key ) then
                    tbl = storeTable[key]
                else
                    typecheck.ArgumentTypeError( STATIC.Class, "LoadChunkWWString", 4, type(key), { "string", "table" } )
                end

                assert( istable( tbl ) )

                tbl[subKey] = readByteString
            else
                local existingValue = storeTable[key]
                if existingValue ~= nil and existingValue ~= 0 then
                    section.Print( "Existing value:" .. tostring( existingValue ) )
                    section.Error( "Reading duplicate string chunk ID " .. cload:CurChunkId() .. " (Key: \"" .. key .. "\") of length " .. cload:CurChunkLength() )
                end

                storeTable[key] = readByteString
            end

            return true
        end
    end

    --[[ Micro-Chunks ]] do

        --- If and only if the next micro-chunk's ID matches the provided ID, loads the micro-chunk as the provided data type and stores it in the provided key or subkey
        --- @param cload ChunkLoadInstance
        --- @param dataType FundamentalDataType|string
        --- @param storeTable any The table where the read value will be stored
        --- @param key any The key within the store table to store the data in
        --- @param subKey any? If the key is a table, the subkey is the key within that table to store data in
        --- @return boolean # `true` if the current micro-chunk ID matched this ID, `false` if this function was skipped
        function STATIC.LoadMicroChunk( cload, dataType, storeTable, key, subKey )
            local byteCount = deserializeLib.GetDataTypeSize( dataType )
            if not byteCount then
                section.Error( "nil ByteCount during micro-chunk read of key:" .. ( key and key or "nil" ) )
            end
            --- @cast byteCount integer

            local readByteCount, readByteString = cload:Read( byteCount )
            if readByteCount == 0 then
                section.Error( "Failed to read micro chunk of type '", deserializeLib.GetDataTypeName( dataType ), "' with an expected size of ", byteCount, " bytes due to only reading ", readByteCount, " bytes" )
            end
            --- @cast readByteString string

            local convertedData = deserializeLib.Deserialize( dataType, readByteString )

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

            readByteString = readByteString:TrimRight( string.char( 0x00 ) )

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
end

function STATIC.ObseleteMicroChunk( id )
    --- This exists to ignore a micro-chunk.  I'm not convinced it's entirely necessary but here we are
end
