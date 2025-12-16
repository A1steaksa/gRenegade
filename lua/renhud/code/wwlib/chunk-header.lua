-- Based on ChunkHeader within Code/wwlib/chunkio.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ChunkHeaderClass
--- @field instance ChunkHeaderInstance The metatable used by ChunkHeaderInstance
local STATIC = CNC.CreateExport()
local CLASS = "ChunkHeaderInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class ChunkHeaderInstance
--- @field Static ChunkHeaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ChunkHeader" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsChunkHeader = true


--[[ Static Functions and Variables ]] do

    --- @class ChunkHeaderClass

    --- The byte size of this class's C++ struct counterpart
    STATIC.ByteSize = 8

    --- Creates a new ChunkHeaderInstance
    --- @overload fun()
    --- @overload fun( chunkType: integer, chunkSize: integer, hasSubChunks: boolean )
    --- @return ChunkHeaderInstance
    function STATIC.New( chunkType, chunkSize, hasSubChunks )
        return robustclass.New( "Renegade_ChunkHeader", chunkType, chunkSize, hasSubChunks )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ChunkHeaderInstance, `false` otherwise
    function STATIC.IsChunkHeader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsChunkHeader and true or false
    end

    typecheck.RegisterType( "ChunkHeaderInstance", STATIC.IsChunkHeader )
end


--- @class ChunkHeaderInstance
--- @field ChunkType integer
--- @field ChunkSize integer
--- @field HasSubChunks boolean

--- Constructs a new ChunkHeaderInstance
--- @overload fun()
--- @overload fun( chunkType: integer, chunkSize: integer, hasSubChunks: boolean )
function INSTANCE:Renegade_ChunkHeader( chunkType, chunkSize, hasSubChunks )
    self.ChunkType = chunkType or 0
    self.ChunkSize = chunkSize or 0
    self.HasSubChunks = hasSubChunks and true or false
end

--- @param type integer
function INSTANCE:SetType( type )
    self.ChunkType = type
end

--- @return integer
function INSTANCE:GetType()
    return self.ChunkType
end

--- @param size integer
function INSTANCE:SetSize( size )
    self.ChunkSize = size
end

--- @param add integer
function INSTANCE:AddSize( add )
    self:SetSize( self:GetSize() + add )
end

--- @return integer
function INSTANCE:GetSize()
    return self.ChunkSize
end

--- @param hasSubChunks boolean
function INSTANCE:SetHasSubChunks( hasSubChunks )
    self.HasSubChunks = hasSubChunks
end

--- @param isOn boolean
function INSTANCE:SetSubChunkFlag( isOn )
    self:SetHasSubChunks( isOn )
end

--- @return boolean
function INSTANCE:GetHasSubChunks()
    return self.HasSubChunks
end

--- @return boolean
function INSTANCE:GetSubChunkFlag()
    return self:GetHasSubChunks()
end