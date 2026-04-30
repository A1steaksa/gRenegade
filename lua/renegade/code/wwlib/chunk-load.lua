-- Based on ChunkLoadClass within Code/wwlib/chunkio.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ChunkLoadClass
--- @field instance ChunkLoadInstance The metatable used by ChunkLoadInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "ChunkLoadClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class ChunkLoadInstance
--- @field Static ChunkLoadClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ChunkLoad" )
INSTANCE.Class = "ChunkLoadInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsChunkLoad = true


--#region Exported Enums
--#endregion


--#region Imports

    --- @type SaveLoadSystemClass
    local saveLoadSystemClass = CNC.Import( "code/wwsaveload/save-load.lua" )

    --- @type ChunkHeaderClass
    local chunkHeaderClass = CNC.Import( "code/wwlib/chunk-header.lua" )

    --- @type MicroChunkHeaderClass
    local microChunkHeaderClass = CNC.Import( "code/wwlib/micro-chunk-header.lua" )

    --- @type FileClass
    local fileClass = CNC.Import( "code/wwlib/file.lua" )
--#endregion


--#region Imported Enums

    local seekDirectionEnum = fileClass.SEEK_DIRECTION
--#endregion

--[[
Porting Notes:
* I'm going to be zero-indexing tables here to (hopefully) avoid chasing off-by-one issues
--]]

local MAX_STACK_DEPTH = 256

--[[ Static Functions and Variables ]] do

    --- @class ChunkLoadClass
    --- @field Converter BinaryConverter

    --- Creates a new ChunkLoadInstance
    --- @param file FileInstance
    --- @return ChunkLoadInstance
    function STATIC.New( file )

        -- Ensure we have a binary converter available
        if not STATIC.Converter then
            STATIC.Converter = BinaryConverter:New()
        end

        return robustclass.New( "Renegade_ChunkLoad", file )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ChunkLoadInstance, `false` otherwise
    function STATIC.IsChunkLoad( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsChunkLoad and true or false
    end

    typecheck.RegisterType( "ChunkLoadInstance", STATIC.IsChunkLoad )

    --[[ Byte Parsing ]] do

        -- Unlike C++, Lua doesn't have the benefit of being able to interpret a pile of bytes as a struct
        -- so we have to parse the bytes back into their appropriate classes manually

        --- @param bytes string
        --- @return ChunkHeaderInstance
        function STATIC.ByteStringToChunkHeader( bytes )
            local converter = STATIC.Converter

            local chunkTypeByteString = bytes:sub( 1, 4 )
            local chunkType = converter:FromUInt32( chunkTypeByteString ) --[[@as number]]

            local chunkSizeByteString = bytes:sub( 5, 8 )

            -- The most significant bit (msb) of the chunk size is a bit flag for
            -- whether sub-chunks are present within this chunk
            -- An MSB of 0 indicates no sub-chunks
            -- An MSB of 1 incidates sub-chunks
            -- The ChunkHeaderInstance class has a separate boolean for this flag so
            -- we need to parse it out here and set that bit to 0 in the chunk size.

            -- Grab the most significant byte from the chunk size
            local leftByteString = chunkSizeByteString:sub( 4, 4 )

            -- Convert it from a string into a number so we can do bitwise operations to it
            local leftByteNumber = converter:FromUInt8( leftByteString )

            -- Create a bit mask for the leftmost bit from the byte number
            local msbMask = bit.lshift( 1, 7 )

            -- Use the mask to check the value of the leftmost bit and determine if the bit flag is set
            local hasSubChunks = bit.band( leftByteNumber, msbMask ) ~= 0

            -- Set the most significant bit in the chunk size to 0 so it doesn't influence the size value
            local leftByteNumberWithoutMSB = bit.band( leftByteNumber, bit.bnot( msbMask ) )

            chunkSizeByteString = chunkSizeByteString:SetChar( 4, string.char( leftByteNumberWithoutMSB ) )

            local chunkSize = converter:FromUInt32( chunkSizeByteString )

            return chunkHeaderClass.New( chunkType, chunkSize, hasSubChunks )
        end

        --- @param bytes string
        --- @return MicroChunkHeaderInstance
        function STATIC.ByteStringToMicroChunkHeader( bytes )
            local converter = STATIC.Converter

            local chunkTypeByte = bytes:sub( 1, 1 )
            local chunkType = converter:FromUInt8( chunkTypeByte )

            local chunkSizeByte = bytes:sub( 2, 2 )
            local chunkSize = converter:FromUInt8( chunkSizeByte )

            return microChunkHeaderClass.New( chunkType, chunkSize )
        end
    end
end


--- "Wrap an instance of one of these objects around an opened file to easily parse the chunks in the file"
--- @class ChunkLoadInstance
--- @field private File FileInstance
--- "Chunk reading support"
--- @field private StackIndex integer
--- @field private PositionStack integer[]
--- @field private HeaderStack ChunkHeaderInstance[]
--- "[MicroChunkInstance] reading support"
--- @field private InMicroChunk boolean
--- @field private MicroChunkPosition integer
--- @field private MicroChunkHeader MicroChunkHeaderInstance

--- Constructs a new ChunkLoadInstance
--- @param file FileInstance
function INSTANCE:Renegade_ChunkLoad( file )
    self.File = file
    self.StackIndex = 0
    self.InMicroChunk = false
    self.MicroChunkPosition = 0

    self.PositionStack = {}
    self.HeaderStack = {}
end

--[[ Chunk Methods ]] do

    --- "Open a chunk in the file, reads in the chunk header"
    --- @return boolean # `true` if a chunk was opened, `false` otherwise, including if a parent chunk has run out of child chunks
    function INSTANCE:OpenChunk()
        -- "If user didn't close any micro chunks that [they] opened, bad things could happen"
        assert( self.InMicroChunk == false )

        -- "Check for stack overflow"
        assert( self.StackIndex < MAX_STACK_DEPTH - 1 )

        -- "If the parent chunk has been completely eaten, return false"
        if ( self.StackIndex > 0 ) and ( self.PositionStack[self.StackIndex - 1] == self.HeaderStack[self.StackIndex - 1]:GetSize() ) then
            return false
        end

        -- "Read the chunk header"
        local chunkHeaderBytes = self.File:Read( chunkHeaderClass.ByteSize )
        if not chunkHeaderBytes or #chunkHeaderBytes ~= chunkHeaderClass.ByteSize then
            return false
        end
        self.HeaderStack[self.StackIndex] = STATIC.ByteStringToChunkHeader( chunkHeaderBytes )

        self.PositionStack[self.StackIndex] = 0
        self.StackIndex = self.StackIndex + 1
        return true
    end

    --- "Close a chunk, seeks to the end if needed"
    --- @return boolean true
    function INSTANCE:CloseChunk()
        -- "If user didn't close any micro chunks that [they] opened, bad things could happen"
        assert( self.InMicroChunk == false )

        -- "Check for stack overflow"
        assert( self.StackIndex > 0 )

        local cSize = self.HeaderStack[self.StackIndex - 1]:GetSize()
        local pos = self.PositionStack[self.StackIndex - 1]

        if pos < cSize then
            self.File:Seek( cSize - pos, seekDirectionEnum.SEEK_CUR )
        end

        self.StackIndex = self.StackIndex - 1
        if self.StackIndex > 0 then
            self.PositionStack[self.StackIndex - 1] = self.PositionStack[self.StackIndex - 1] + cSize + chunkHeaderClass.ByteSize
        end

        return true
    end

    --- @return integer "...the ID of the current chunk"
    function INSTANCE:CurChunkId()
        return self.HeaderStack[self.StackIndex - 1]:GetType()
    end

    --- @return integer "...the current length of the current chunk"
    function INSTANCE:CurChunkLength()
        return self.HeaderStack[self.StackIndex - 1]:GetSize()
    end

    --- @return integer "..the current chunk recursion depth"
    function INSTANCE:CurChunkDepth()
        return self.StackIndex
    end

    --- "Test whether the current chunk contains chunks (or data)"
    --- @return boolean
    function INSTANCE:ContainsChunks()
        return self.HeaderStack[self.StackIndex - 1]:GetSubChunkFlag()
    end
end

--[[ Micro Chunk Methods ]] do

    --- "Reads in a micro-chunk header"
    --- @return boolean # `true` if the micro chunk header was opened successfully, `false` otherwise 
    function INSTANCE:OpenMicroChunk()
        assert( not self.InMicroChunk )

        -- "Read the chunk header"
        -- "Calling the ChunkLoadClass:Read fn so that if we exhaust the chunk, the read will fail"
        local readByteCount, byteString = self:Read( microChunkHeaderClass.ByteSize )
        if readByteCount ~= microChunkHeaderClass.ByteSize then
            section.Warn( "Open Micro-Chunk failed because file read returned the wrong number of bytes. Expected ", microChunkHeaderClass.ByteSize, " but got ", readByteCount )
            return false
        end
        --- @cast byteString string

        self.MicroChunkHeader = STATIC.ByteStringToMicroChunkHeader( byteString )

        self.InMicroChunk = true
        self.MicroChunkPosition = 0
        return true
    end

    --- "Closes a micro-chunk (seeks to end)"
    --- @return boolean true
    function INSTANCE:CloseMicroChunk()
        assert( self.InMicroChunk )
        self.InMicroChunk = false

        local cSize = self.MicroChunkHeader:GetSize()
        local pos = self.MicroChunkPosition

        -- "Seek the file past this micro chunk"
        if pos < cSize then
            self.File:Seek( cSize - pos, seekDirectionEnum.SEEK_CUR )

            -- "Update the tracking variables for where we are in the normal chunk"
            if self.StackIndex > 0 then
                self.PositionStack[self.StackIndex - 1] = self.PositionStack[self.StackIndex - 1] + cSize - pos
            end
        end

        return true
    end

    --- @return integer "...the ID of the current micro-chunk (asserts if"
    function INSTANCE:CurMicroChunkId()
        return self.MicroChunkHeader:GetType()
    end

    --- @return integer "...the size of the current micro chunk"
    function INSTANCE:CurMicroChunkLength()
        return self.MicroChunkHeader:GetSize()
    end
end

--[[ Reading ]] do

    --- "Read data from the file"
    --- @param byteCount integer How many bytes to read
    --- @return integer readByteCount, string? readByteString
    function INSTANCE:Read( byteCount )
        local index = self.StackIndex - 1
        local positionStack = self.PositionStack

        -- "Don't read if we would go past the end of the current chunk"
        if positionStack[index] + byteCount > self.HeaderStack[index]:GetSize() then
            section.Warn( "Don't read if we would go past the end of the current chunk" )
            return 0
        end

        -- "Don't read if we are in a micro chunk and would go past the end of it"
        if self.InMicroChunk and self.MicroChunkPosition + byteCount > self.MicroChunkHeader:GetSize() then
            section.Warn( "Don't read if we are in a micro chunk and would go past the end of it" )
            return 0
        end

        if byteCount <= 0 then
            section.Warn( "Read byte count is lower than expected: " .. tostring( byteCount ) )
            return 0
        end

        local byteString = self.File:Read( byteCount )
        if string.len( byteString ) ~= byteCount then
            section.Error( "Read byte count does not match expected byte count" )
            return 0
        end

        -- "Update our position in the chunk"
        positionStack[index] = positionStack[index] + byteCount

        -- "Update our position in the micro chunk if we are in one"
        if self.InMicroChunk then
            self.MicroChunkPosition = self.MicroChunkPosition + byteCount
        end

        return byteCount, byteString
    end

    --- @return integer readByteCount, IOVector2Instance readVector2
    function INSTANCE:ReadIOVector2()
        typecheck.NotImplementedError()
    end

    --- @return integer readByteCount, IOVector3Instance readVector3
    function INSTANCE:ReadIOVector3()
        typecheck.NotImplementedError()
    end

    --- @return integer readByteCount, IOVector4Instance readVector4
    function INSTANCE:ReadIOVector4()
        typecheck.NotImplementedError()
    end

    --- @return integer readByteCount, IOQuaternionInstance readQuaternion
    function INSTANCE:ReadIOQuaternion()
        typecheck.NotImplementedError()
    end
end

--- @return integer # The byte position of the chunk loader within its file
function INSTANCE:Tell()
    return self.File:Tell()
end

--- "Seek over [byteCount] in the stream"
--- @param byteCount integer The number of bytes to seek by
--- @return integer
function INSTANCE:Seek( byteCount )
    local index = self.StackIndex - 1

    -- "Don't seek if we would go past the end of the current chunk"
    if self.PositionStack[index] + byteCount > self.HeaderStack[index]:GetSize() then
        return 0
    end

    -- "Don't read if we are in a micro chunk and would go past the end of it"
    if self.InMicroChunk and self.MicroChunkPosition + byteCount > self.MicroChunkHeader:GetSize() then
        return 0
    end

    local curPos = self.File:Tell()
    if self.File:Seek( byteCount, seekDirectionEnum.SEEK_CUR ) - curPos ~= byteCount then
        section.Warn( "Chunk Load Seek has incorrect end position" )
        return 0
    end

    -- "Update our position in the chunk"
    self.PositionStack[index] = self.PositionStack[index] + byteCount

    -- "Update our position in the micro chunk if we ware in one"
    if self.InMicroChunk then
        self.MicroChunkPosition = self.MicroChunkPosition + byteCount
    end

    return byteCount
end

--- "Sneak peek into the next chunk that will be opened"
--- @return boolean wasSuccessful, integer? id, integer? size, boolean? containsMicroChunks
function INSTANCE:PeekNextChunk()
    -- "If the parent chunk has been completely eaten, return false"
    local stackIndex = self.StackIndex
    if ( stackIndex > 0 ) and ( self.PositionStack[stackIndex - 1] == self.HeaderStack[stackIndex - 1]:GetSize() ) then
        return false
    end

    local preReadPos = self.File:Tell()

    -- "Peek at the next chunk header, return false if the read fails"
    local byteCountToRead = chunkHeaderClass.ByteSize
    local byteString = self.File:Read( byteCountToRead )
    if not byteString or string.len( byteString ) ~= byteCountToRead then
        return false
    end

    -- Parse out the class/struct from the raw byte string
    local tempHeader = STATIC.ByteStringToChunkHeader( byteString )

    -- Revert to the position in the file we were at before we read.
    -- Without this, we wouldn't be "peeking"
    self.File:Seek( preReadPos )

    local id = tempHeader:GetType()
    local size = tempHeader:GetSize()
    local containsMicroChunks = tempHeader:GetHasSubChunks()

    return true, id, size, containsMicroChunks
end
