-- Based on PersistClass within Code/wwsaveload/persist.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PostLoadableClass
local postLoadableClass = CNC.Import( "code/wwsaveload/post-loadable.lua" )

--- @class PersistClass : PostLoadableClass
--- @field Instance PersistInstance The metatable used by PersistInstance
local STATIC = CNC.CreateExport( postLoadableClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PersistClass"

--- @class PersistInstance : PostLoadableInstance
--- @field Static PersistClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Persist : Renegade_PostLoadable" )
INSTANCE.Class = "PersistInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPersist = true


--#region Exported Enums
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
    --- @field ChunkIds table<string, integer> The chunk IDs used to save/load instances of this PersistClass
    --- @field MicroChunkIds table<string, integer> The micro-chunk IDs used to save/load instances of this PersistClass

    --- Creates a new PersistInstance
    --- @return PersistInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Persist" )
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

--- Constructs a new PersistInstance
function INSTANCE:Renegade_Persist()
    postLoadableClass.Instance.Renegade_PostLoadable( self )
end

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
