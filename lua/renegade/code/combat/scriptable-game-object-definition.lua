-- Based on ScriptableGameObjDef within Code/Combat/scriptablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type BaseGameObjectDefinitionClass
local PARENT = CNC.Import( "code/combat/base-game-object-definition.lua" )

--- @class ScriptableGameObjectDefinitionClass : BaseGameObjectDefinitionClass
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "ScriptableGameObjectDefinitionClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class ScriptableGameObjectDefinitionInstance : BaseGameObjectDefinitionInstance
local INSTANCE = robustclass.Register( "Renegade_ScriptableGameObjectDefinitionClass : Renegade_BaseGameObjectDefinitionClass" )
INSTANCE.Class = "ScriptableGameObjectDefinitionInstance"
INSTANCE.IsScriptableGameObjectDefinitionClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--[[ Chunk IDs ]] do

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_DEF_PARENT      = enumBuilder:Set( 627001056 ),
        CHUNKID_DEF_VARIABLES   = enumBuilder:Next(),

        XXX_MICROCHUNKID_DEF_TYPE           = enumBuilder:Set( 1 ),
        MICROCHUNKID_DEF_SCRIPT_NAME        = enumBuilder:Next(),
        MICROCHUNKID_DEF_SCRIPT_PARAMETERS  = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class ScriptableGameObjectDefinitionClass

    --- Creates a new ScriptableGameObjectDefinitionClass
    --- @vararg any
    --- @return ScriptableGameObjectDefinitionClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ScriptableGameObjectDefinitionClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ScriptableGameObjectDefinitionInstance, `false` otherwise
    function STATIC.IsScriptableGameObjectDefinitionClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsScriptableGameObjectDefinitionClass and true or false
    end

    typecheck.RegisterType( "ScriptableGameObjectDefinitionInstance", STATIC.IsScriptableGameObjectDefinitionClass )
end


--- @class ScriptableGameObjectDefinitionInstance
--- @field ScriptNameList string[]
--- @field ScriptParameterList string[]

--- Constructs a new ScriptableGameObjectDefinitionInstance
function INSTANCE:Renegade_ScriptableGameObjectDefinitionClass()
    self.ScriptNameList = {}
    self.ScriptParameterList = {}
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )
    section.Start( "Loading " .. INSTANCE.Class )

    local ids = STATIC.ChunkIds

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.CHUNKID_DEF_PARENT then
            PARENT.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_VARIABLES then
            section.Start( INSTANCE.Class .. " Variables Start" )

            while cload:OpenMicroChunk() do

                --- @class ScriptableGameObjectDefinitionLoadVals
                --- @field ScriptName string
                --- @field ScriptParameters string
                local readVals = {}

                local microChunkId = cload:CurMicroChunkId()

                if microChunkId == ids.MICROCHUNKID_DEF_SCRIPT_NAME then
                    self:LoadMicroChunkWWString( cload, readVals, "ScriptName" )
                    self.ScriptNameList[#self.ScriptNameList + 1] = readVals.ScriptName

                elseif microChunkId == ids.MICROCHUNKID_DEF_SCRIPT_PARAMETERS then
                    self:LoadMicroChunkWWString( cload, readVals, "ScriptParameters" )
                    self.ScriptParameterList[#self.ScriptParameterList + 1] = readVals.ScriptParameters

                else
                    section.Print( "Unrecognized " .. INSTANCE.Class .. " Variable Chunk ID", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end

            section.End()
        else
            section.Print( "Unrecognized " .. INSTANCE.Class .. " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    section.End()

    return true
end


--- @return boolean wasValid, string? errorMessage
function INSTANCE:IsValidConfig()
    typecheck.NotImplementedError()
end