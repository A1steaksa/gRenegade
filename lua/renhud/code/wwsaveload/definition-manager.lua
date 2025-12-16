-- Based on DefinitionMgrClass within Code/wwsaveload/definitionmgr.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SaveLoadSubSystemClass
local parentClass = CNC.Import( "renhud/code/wwsaveload/save-load-sub-system.lua" )

--- @class DefinitionManagerClass : SaveLoadSubSystemClass
--- @field instance DefinitionManagerInstance The metatable used by DefinitionManagerInstance
local STATIC = CNC.CreateExport( parentClass )
local CLASS = "DefinitionManagerInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class DefinitionManagerInstance : SaveLoadSubSystemInstance
--- @field Static DefinitionManagerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DefinitionManager : Renegade_SaveLoadSubSystem" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDefinitionManager = true


--#region Exported Enums

    --- @enum IdType
    STATIC.ID_TYPE = {
        CLASS       = 1,
        SUPERCLASS  = 2
    }
    local idTypeEnum = STATIC.ID_TYPE
--#endregion


--#region Imports

    --- @type CombatChunkId
    local combatChunkId = CNC.Import( "renhud/code/combat/combat-chunk-id.lua" )

    --- @type SaveLoadSystemClass
    local saveLoadSystemClass = CNC.Import( "renhud/code/wwsaveload/save-load.lua" )

    --- @type SaveLoadIds
    local saveLoadIdsClass = CNC.Import( "renhud/code/wwsaveload/save-load-ids.lua" )

    --- @type DefinitionClassIds
    local definitionClassIds = CNC.Import( "renhud/code/wwsaveload/definition-class-ids.lua" )
--#endregion


--#region Imported Enums

    local chunkIdEnum = saveLoadIdsClass.CHUNK_ID
    local classIdEnum = definitionClassIds.CLASS_ID
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class DefinitionManagerClass

    --- @type table<integer, DefinitionInstance>
    STATIC.IdToDefinition = {}

    --- @type table<string, DefinitionInstance>
    STATIC.NameToDefinition = {}


    --[[ Internal Chunk IDs ]] do

        STATIC.CHUNKID_VARIABLES    = 0x00000100
        STATIC.CHUNKID_OBJECTS      = STATIC.CHUNKID_VARIABLES  + 1
        STATIC.CHUNKID_OBJECT       = STATIC.CHUNKID_OBJECTS    + 1
    end


    --[[ Internal Micro Chunk IDs ]] do

        STATIC.VARID_NEXTDEFID = 0x01
    end


    --- Creates a new DefinitionManagerInstance
    --- @return DefinitionManagerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DefinitionManager" )
    end

    --- Called automatically after this class is imported
    function STATIC.StaticConstructor()
        STATIC.TheDefinitionManager = STATIC.New()
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DefinitionManagerInstance, `false` otherwise
    function STATIC.IsDefinitionManager( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDefinitionManager and true or false
    end

    typecheck.RegisterType( "DefinitionManagerInstance", STATIC.IsDefinitionManager )

    --[[ Type Identification ]] do

        --- @param id integer
        --- @param twiddle boolean? [Default: `true`]
        --- @return DefinitionInstance?
        function STATIC.FindDefinition( id, twiddle )
            if not twiddle then twiddle = true end

            local definition = STATIC.IdToDefinition[id]

            -- "Should we twiddle this definition?"
            -- "(Twiddling refers to our randomizing framework for definitions)"
            if twiddle and definition ~= nil and definition:GetClassId() == classIdEnum.TWIDDLERS then
                typecheck.NotImplementedError( "Definition \"twiddling\" in FindDefinition" )
            end

            return definition
        end

        --- @param name string
        --- @param twiddle boolean? [Default: `true`]
        --- @return DefinitionInstance
        function STATIC.FindNamedDefinition( name, twiddle )
            typecheck.NotImplementedError()
        end

        --- @param name string
        --- @param classId integer
        --- @param twiddle boolean? [Default: `true`]
        --- @return DefinitionInstance
        function STATIC.FindTypedDefinition( name, classId, twiddle )
            typecheck.NotImplementedError()
        end

        --- @param superclassId integer? [Default: All]
        function STATIC.ListAvailableDefinitions( superclassId )
            typecheck.NotImplementedError()
        end

        --- @param classId integer
        --- @return integer
        function STATIC.GetNewId( classId )
            typecheck.NotImplementedError()
        end
    end

    --[[ Definition Registration ]] do

        --- @param definition DefinitionInstance
        function STATIC.RegisterDefinition( definition )
            typecheck.NotImplementedError()
        end

        --- @param definition DefinitionInstance
        function STATIC.UnregisterDefinition( definition )
            typecheck.NotImplementedError()
        end
    end

    --[[ Definition Enumeration ]] do

        --- @overload fun( id: integer, type: IdType? ): DefinitionClass
        --- @overload fun(): DefinitionClass
        function STATIC.GetFirst( id, type )
            typecheck.NotImplementedError()
        end

        --- @overload fun( currDef: DefinitionClass, id: integer, type: IdType? ): DefinitionClass
        --- @overload fun( currDef: DefinitionClass ): DefinitionClass
        function STATIC.GetNext( currDef, id, type )
            typecheck.NotImplementedError()
        end
    end

    function STATIC.FreeDefinitions()
        typecheck.NotImplementedError()
    end

end


--- @class DefinitionManagerInstance


--[[ From SaveLoadSubSystemClass ]] do

    --- @return integer
    function INSTANCE:ChunkId()
        return chunkIdEnum.SAVELOAD_DEFMGR
    end

    --- @return boolean
    function INSTANCE:ContainsData()
        return true
    end

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:Load( cload )
        local retVal = true

        while cload:OpenChunk() do
            local chunkId = cload:CurChunkId()

            if chunkId == STATIC.CHUNKID_VARIABLES then
                retVal = retVal and self:LoadVariables( cload )
            elseif chunkId == STATIC.CHUNKID_OBJECTS then
                retVal = retVal and self:LoadObjects( cload )
            end

            cload:CloseChunk()
        end

        return retVal
    end

    --- @return string
    function INSTANCE:Name()
        return "DefinitionMgrClass"
    end
end


--[[ Persistence Methods ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:SaveObjects( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:LoadObjects( cload )
        local retVal = true

        while cload:OpenChunk() do

            local chunkId = cload:CurChunkId()

            -- "Load this definition from the chunk (if possible)"
            local factory = saveLoadSystemClass.FindPersistFactory( chunkId )

            if factory then
                Section.Print( "Found a Persist Factory for Chunk ID: " .. chunkId )

                local definition = factory:Load( cload )

                if definition then
                    local name = definition:GetName()

                    Section.Print( "Loaded definition for " .. tostring( name ) .. "!" )
                    for k, v in ipairs( definition ) do
                        Section.Print( "[" .. tostring( k ) .. "]: " .. tostring( v ) )
                    end

                    -- "Add this definition to our array"
                    STATIC.IdToDefinition[chunkId] = definition
                    STATIC.NameToDefinition[name] = definition
                else
                    error( "No definition :(" )
                end
            else

                local keyString = ""
                for k, v in pairs( combatChunkId ) do
                    if v == chunkId then
                        keyString = " AKA Combat Chunk ID: " .. k
                        break
                    end
                end

                if #keyString == 0 then
                    for k, v in pairs( chunkIdEnum ) do
                        if v == chunkId then
                            keyString = " AKA Save Load ID: " .. k
                            break
                        end
                    end
                end

                -- print( "No factory for chunk ID " .. chunkId .. keyString )
            end

            cload:CloseChunk()
        end

        -- "Sort the definition"
        -- Omitted sorting definitions for now

        -- "Assign a mgr link to each definition"
        -- Omitted manager link for now

        return retVal
    end

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:SaveVariables( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:LoadVariables( cload )
        local retVal = true

        -- "Loop through all the microchunks that define the variables"
        while cload:OpenMicroChunk() do

            print( "Micro chunk: ", cload:CurMicroChunkId() )

            if cload:CurMicroChunkId() == STATIC.VARID_NEXTDEFID then
                print( "Micro chunk is VARID_NEXTDEFID" )
                break
            end

            cload:CloseMicroChunk()
        end

        return retVal
    end
end