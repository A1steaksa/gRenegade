-- Based on BaseGameObjDef within Code/Combat/basegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type DefinitionClass
local PARENT = CNC.Import( "renhud/code/wwsaveload/definition.lua" )

--- @class BaseEntityDefClass : DefinitionClass
local STATIC = CNC.CreateExport( PARENT )
local CLASS = "BaseEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class BaseEntityDefInstance : DefinitionInstance
local INSTANCE = robustclass.Register( "Renegade_BaseEntityDefClass : Renegade_Definition" )
INSTANCE.IsBaseEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--#region Imports

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum.lua" )
--#endregion


--[[ Chunk IDs ]] do

    STATIC.ChunkIds = {
        CHUNKID_DEF_PARENT = 1111991123,
    }
end


--[[ Static Functions and Variables ]] do

    --- @class BaseEntityDefClass

    --- Creates a new BaseEntityDefClass
    --- @vararg any
    --- @return BaseEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_BaseEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BaseEntityDefInstance, `false` otherwise
    function STATIC.IsBaseEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBaseEntityDefClass and true or false
    end

    typecheck.RegisterType( "BaseEntityDefInstance", STATIC.IsBaseEntityDefClass )
end

--- @class PersistInstance

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    Section.Start( "Loading " .. CLASS )

    cload:OpenChunk()
    assert( cload:CurChunkId() == STATIC.ChunkIds.CHUNKID_DEF_PARENT )
    PARENT.Instance.Load( self, cload )
    cload:CloseChunk()

    Section.End()

    return true
end
