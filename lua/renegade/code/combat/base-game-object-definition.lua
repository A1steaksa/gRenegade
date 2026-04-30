-- Based on BaseGameObjDef within Code/Combat/basegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class BaseGameObjectDefinitionClass : DefinitionClass
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BaseGameObjectDefinitionClass"

--- @class BaseGameObjectDefinitionInstance : DefinitionInstance
local INSTANCE = robustclass.Register( "Renegade_BaseGameObjectDefinition : Renegade_Definition" )
INSTANCE.IsBaseGameObjectDefinitionClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--#region Imports

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--[[ Chunk IDs ]] do

    local builder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_DEF_PARENT = builder:Set( 1111991123 ),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class BaseGameObjectDefinitionClass

    --- Creates a new BaseGameObjectDefinitionClass
    --- @vararg any
    --- @return BaseGameObjectDefinitionClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_BaseGameObjectDefinition", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BaseGameObjectDefinitionInstance, `false` otherwise
    function STATIC.IsBaseGameObjectDefinitionClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBaseGameObjectDefinitionClass and true or false
    end

    typecheck.RegisterType( "BaseGameObjectDefinitionInstance", STATIC.IsBaseGameObjectDefinitionClass )
end

--- @class BaseGameObjectDefinitionInstance

--[[ Save / Load ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:Load( cload )
        section.Start( "Loading " .. INSTANCE.Class )

        cload:OpenChunk()
        assert( cload:CurChunkId() == STATIC.ChunkIds.CHUNKID_DEF_PARENT )
        PARENT.Instance.Load( self, cload )
        cload:CloseChunk()

        section.End()

        return true
    end
end

