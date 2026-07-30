-- Based on MicroChunkHeader within Code/wwlib/chunkio.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class MicroChunkHeaderClass
--- @field instance MicroChunkHeaderInstance The metatable used by MicroChunkHeaderInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "MicroChunkHeaderClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class MicroChunkHeaderInstance
--- @field Static MicroChunkHeaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MicroChunkHeader" )
INSTANCE.Class = "MicroChunkHeaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMicroChunkHeader = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class MicroChunkHeaderClass
    --- @field ChunkType integer
    --- @field ChunkSize integer

    --- The byte size of this class's C++ struct counterpart
    STATIC.ByteSize = 2

    --- Creates a new MicroChunkHeaderInstance
    --- @overload fun( chunkType: integer, chunkSize: integer )
    --- @overload fun()
    --- @return MicroChunkHeaderInstance
    function STATIC.New( chunkType, chunkSize )
        return robustclass.New( "Renegade_MicroChunkHeader", chunkType, chunkSize )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MicroChunkHeaderInstance, `false` otherwise
    function STATIC.IsMicroChunkHeader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMicroChunkHeader and true or false
    end

    typecheck.RegisterType( "MicroChunkHeaderInstance", STATIC.IsMicroChunkHeader )
end


--- @class MicroChunkHeaderInstance
--- @field ChunkType integer
--- @field ChunkSize integer

--- Constructs a new MicroChunkHeaderInstance
--- @overload fun( chunkType: integer, chunkSize: integer )
--- @overload fun()
function INSTANCE:Renegade_MicroChunkHeader( chunkType, chunkSize )
    self.ChunkType = chunkType or 0
    self.ChunkSize = chunkSize or 0
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