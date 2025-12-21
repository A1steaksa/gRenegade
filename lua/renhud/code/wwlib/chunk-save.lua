-- Based on ChunkSaveClass within Code/wwlib/chunkio.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ChunkSaveInstance
--- @field instance ChunkSaveInstance The metatable used by ChunkSaveInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "ChunkSaveClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class ChunkSaveInstance
--- @field Static ChunkSaveInstance The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ChunkSave" )
INSTANCE.Class = "ChunkSaveInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsChunkSave = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class ChunkSaveInstance

    --- Creates a new ChunkSaveInstance
    --- @param file File
    --- @return ChunkSaveInstance
    function STATIC.New( file )
        return robustclass.New( "Renegade_ChunkSave", file )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ChunkSaveInstance, `false` otherwise
    function STATIC.IsChunkSave( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsChunkSave and true or false
    end

    typecheck.RegisterType( "ChunkSaveInstance", STATIC.IsChunkSave )
end

--- "Wrap an instance of this class around an opened file for easy chunk creation"
--- @class ChunkSaveInstance
--- @field private File File
--- Chunk building support
--- @field private StackIndex integer
--- @field private PositionStack integer[]
--- @field private HeaderStack ChunkHeaderInstance[]
--- MicroChunkInstance building support
--- @field private InMicroChunk boolean
--- @field private MicroChunkPosition integer
--- @field private MicroChunkHeader MicroChunkHeaderInstance

local MAX_STACK_DEPTH = 256

--- Constructs a new ChunkSaveInstance
--- @param file File
function INSTANCE:Renegade_ChunkSave( file )
    typecheck.NotImplementedError()

    self.PositionStack = {}
    self.HeaderStack = {}
end

--[[ "Chunk Methods" ]] do

    --- @param id integer
    --- @return boolean
    function INSTANCE:BeginChunk( id )
        typecheck.NotImplementedError()
    end

    --- @return boolean
    function INSTANCE:EndChunk()
        typecheck.NotImplementedError()
    end

    --- @return integer
    function INSTANCE:CurChunkDepth()
        typecheck.NotImplementedError()
    end
end

--[[ "Micro Chunk Methods" ]] do

    --- @param id integer
    --- @return boolean
    function INSTANCE:BeginMicroChunk( id )
        typecheck.NotImplementedError()
    end

    --- @return boolean
    function INSTANCE:EndMicroChunk()
        typecheck.NotImplementedError()
    end
end

--- "Write data into the file"
--- @overload fun( buffer )
function INSTANCE:Write( ... )
    typecheck.NotImplementedError()
end