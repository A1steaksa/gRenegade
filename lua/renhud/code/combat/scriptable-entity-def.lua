-- Based on ScriptableGameObjDef within Code/Combat/scriptablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type BaseEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/base-entity-def.lua" )

--- @class ScriptableEntityDefClass : BaseEntityDefClass
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "ScriptableEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class ScriptableEntityDefInstance : BaseEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_ScriptableEntityDefClass : Renegade_BaseEntityDefClass" )
INSTANCE.Class = "ScriptableEntityDefInstance"
INSTANCE.IsScriptableEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--#region Imports

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum-builder.lua" )
--#endregion


--[[ Chunk IDs ]] do

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

    --- @class ScriptableEntityDefClass

    --- Creates a new ScriptableEntityDefClass
    --- @vararg any
    --- @return ScriptableEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ScriptableEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ScriptableEntityDefInstance, `false` otherwise
    function STATIC.IsScriptableEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsScriptableEntityDefClass and true or false
    end

    typecheck.RegisterType( "ScriptableEntityDefInstance", STATIC.IsScriptableEntityDefClass )
end


--- @class ScriptableEntityDefInstance
--- @field ScriptNameList string[]
--- @field ScriptParameterList string[]

--- Constructs a new ScriptableEntityDefInstance
function INSTANCE:Renegade_ScriptableEntityDefClass()
    self.ScriptNameList = {}
    self.ScriptParameterList = {}
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )
    Section.Start( "Loading " .. INSTANCE.Class )

    local ids = STATIC.ChunkIds

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.CHUNKID_DEF_PARENT then
            PARENT.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_VARIABLES then
            Section.Start( INSTANCE.Class .. " Variables Start" )

            while cload:OpenMicroChunk() do

                --- @class ScriptableEntityDefLoadVals
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
                    Section.Print( "Unrecognized " .. INSTANCE.Class .. " Variable Chunk ID", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end

            Section.End()
        else
            Section.Print( "Unrecognized " .. INSTANCE.Class .. " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    Section.End()

    return true
end


--- @return boolean wasValid, string? errorMessage
function INSTANCE:IsValidConfig()
    typecheck.NotImplementedError()
end