-- Based on SaveGameManager within Code/Combat/savegame.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SaveGameManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "SaveGameManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums
--#endregion


--#region Imports

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

    --- @type PersistClass
    local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

    --- @type SaveLoadSystemClass
    local saveLoadSystemClass = CNC.Import( "code/wwsaveload/save-load.lua" )

    --- @type ChunkLoadClass
    local chunkLoadClass = CNC.Import( "code/wwlib/chunk-load.lua" )

    --- @type EnumBuilderClass
    local enumBaseClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--#region Imported Enums

    local dataTypeEnum = persistClass.DATA_TYPE
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBaseClass.New()

    STATIC.ChunkIds = {
        CHUNKID_LEVEL_INFO  = enumBuilder:Set( 1011991648 ),
        CHUNKID_LEVEL_DATA  = enumBuilder:Next(),

        MICROCHUNKID_MAP_FILENAME           = enumBuilder:Set( 1 ),
        MICROCHUNKID_MISSION_DESCRIPTION    = enumBuilder:Next(),
        MICROCHUNKID_DESCRIPTION            = enumBuilder:Next(),
    }
end


--- @class SaveGameManagerClass
--- @field MapFileName string
--- @field CurrentGameFilename string
--- @field Description string
--- @field MissionDescriptionId integer

STATIC.DefaultDefinitionFilename = "renegade/always_dat/objects.ddb.txt"
STATIC.MissionDescriptionId = 0

--[[ Map Filename (LSD) Access ]] do

    --- @param filename string
    function STATIC.SetMapFilename( filename )
        STATIC.MapFileName = filename
    end

    --- @return string
    function STATIC.GetMapFilename()
        return STATIC.MapFileName
    end
end

--[[ Description Access ]] do

    --- @param text string
    function STATIC.SetDescription( text )
        STATIC.Description = text
    end

    --- @return string
    function STATIC.GetDescription()
        return STATIC.Description
    end
end

--[[ Mission Description Access ]] do

    --- @param id integer
    function STATIC.SetMissionDescriptionId( id )
        STATIC.MissionDescriptionId = id
    end

    --- @return integer
    function STATIC.GetMissionDescriptionId()
        return STATIC.MissionDescriptionId
    end
end

--[[ Utility Functions ]] do

    --- @param fileName string
    --- @param description string
    --- @param missionName string
    --- @return boolean
    function STATIC.SmartPeekDescription( fileName, description, missionName )
        typecheck.NotImplementedError()
    end

    --- @param fileName string
    --- @param mapName string
    --- @return boolean
    function STATIC.SmartPeekMapName( fileName, mapName )
        typecheck.NotImplementedError()
    end

    --- @param fileName string
    --- @param description string
    --- @param missionName string
    --- @return boolean
    function STATIC.PeekDescription( fileName, description, missionName )
        typecheck.NotImplementedError()
    end

    --- @param fileName string
    --- @return boolean success, string? mapName
    function STATIC.PeekMapName( fileName )

        -- "Open the file as a chunk"
        local loadedFile = file.Open( fileName, "rb", "THIRDPARTY" )
        if not loadedFile then
            Section.Error( "Failed to load file while peeking map name: \"", fileName, "\"" )
        end

        local cload = chunkLoadClass.New( loadedFile )

        local ids = STATIC.ChunkIds
        local readValues = {}

        local retVal = false

        Section.Start( "Map Peek" )

        -- "Loop until we've found the header chunk"
        while retVal == false and cload:OpenChunk() do
            local chunkId = cload:CurChunkId()

            Section.Start( "Chunk " .. chunkId )

            if chunkId == ids.CHUNKID_LEVEL_INFO then

                Section.Start( "Level Info" )

                while retVal == false and cload:OpenMicroChunk() do
                    local microChunkId = cload:CurMicroChunkId()

                    Section.Start( "Micro-chunk " .. microChunkId )

                    if microChunkId == ids.MICROCHUNKID_MAP_FILENAME then
                        Section.Print( "MIGHT BE THE MAP NAME BAYBEEEE" )
                        persistClass.Instance.LoadMicroChunkWWString( STATIC, cload, readValues, "MapName" )
                        retVal = true
                    end

                    Section.End()

                    cload:CloseMicroChunk()
                end

                Section.End()
            end

            Section.End()

            cload:CloseChunk()
        end

        Section.End()

        -- "Close the file"
        loadedFile:Close()

        return retVal, readValues.MapName
    end
end

--[[ LDD Access ]] do
    -- "Editor only calls [SaveGame], App calls both"    

    --- @param fileName string
    --- @varargs any
    function STATIC.SaveGame( fileName, ... )
        typecheck.NotImplementedError()
    end

    --- @param fileName string
    function STATIC.LoadGame( fileName )
        STATIC.CurrentGameFileName = fileName

        local loadedFile = file.Open( fileName, "rb", "THIRDPARTY" )
        assert( loadedFile ~= nil )
        local cload = chunkLoadClass.New( loadedFile )

        local ids = STATIC.ChunkIds
        local persist = persistClass.Instance

        while cload:OpenChunk() do
            local chunkId = cload:CurChunkId()
            if chunkId == ids.CHUNKID_LEVEL_INFO then
                while cload:OpenMicroChunk() do
                    local didRead =
                        persist.ReadMicroChunkWWString( STATIC, cload, ids.MICROCHUNKID_MAP_FILENAME, "MapFileName" )
                        or persist.ReadMicroChunk( STATIC, cload, ids.MICROCHUNKID_MISSION_DESCRIPTION, dataTypeEnum.Int "MissionDescriptionId" )
                        or persist.ReadMicroChunkWideString( STATIC, cload, ids.MICROCHUNKID_DESCRIPTION, "Description" )

                    if not didRead then
                        Section.Warn( "Unrecognized Level Info Chunk ID: ", cload:CurMicroChunkId() )
                    end

                    cload:CloseMicroChunk()
                end

                -- "Load level specific defs"
                local tempDdb = STATIC.MapFileName
                tempDdb = tempDdb.sub( 0, -4 )
                tempDdb = tempDdb .. ".ddb"
                STATIC.LoadDefinitions( tempDdb )

                -- "Load the static data"
                STATIC.LoadLevel()
            elseif chunkId == ids.CHUNKID_LEVEL_DATA then
                if combatManagerClass.IAmServer() then
                    saveLoadSystemClass.Load( cload, false )
                end
            else
                Section.Warn( "Unrecognized level chunk ID ", chunkId )
            end
            cload:CloseChunk()
        end

        loadedFile:Close()
    end

    --- @param fileName string
    --- @return string fileNameToLoad, string lsdFileName
    function STATIC.PreLoadGame( fileName )
        -- "Get the root name and extension from the filename"
        local rootName = string.StripExtension( fileName )
        local extension = string.GetExtensionFromFilename( fileName )

        -- Omitting setting info log level

        -- "Reset the search order"
        -- Omitting file factory list search order reset
        local fileNameToLoad = fileName
        local lsdFileName = fileName

        -- "Is this a mix file?"
        if extension == ".mix" then
            -- Omitted adding to thumbnail manager
            -- local thumbFileName = rootName .. ".thu"
            -- thumbnailManagerClass.AddThumbnailManager( thumbFileName, fileName )

            -- "Build the dynamic data filename from mix file's root name"
            fileNameToLoad = string.format( "%s.ldd", rootName )
            lsdFileName = string.format( "%s.lsd", rootName )

            -- Omitting level 9 hack hack
        elseif extension == ".lsd" then
            lsdFileName = fileName
            fileNameToLoad = string.format( "%s.ldd", rootName )
        else
            -- "Dig out the name of the map we'll use with this file"
            local success, mapName = STATIC.PeekMapName( fileName )
            if success then
                Section.Print( "Peeked map name: ", mapName )
                --- @cast mapName string

                local mixRootName = string.StripExtension( mapName )

                lsdFileName = string.format( "%s.lsd", mixRootName )
                local mixFileName = string.format( "%s.mix", mixRootName )

                -- Omitting level 9 hack hack

                -- Omitted adding to thumbnail manager
                -- local thumbFileName = mixRootName .. ".thu"
                -- thumbnailManagerClass.AddThumbnailManager( thumbFileName, mixFileName )
            else
                Section.Warn( "Failed to peek map name from: \"", fileName, "\"" )
            end
        end

        return fileNameToLoad, lsdFileName
    end

    --- @return string
    function STATIC.GetCurrentGameFileName()
        return STATIC.CurrentGameFilename
    end
end

--[[ LSD Access ]] do
    -- "Editor only calls [SaveLevel], App only calls [LoadLevel]"

    function STATIC.SaveLevel()
        typecheck.NotImplementedError()
    end

    function STATIC.LoadLevel()
        -- "false = no automatic post load processing (needs to be called explicitly)"
        STATIC.LoadSaveLoadSystem( STATIC.MapFileName, false )
    end
end

--[[ DDB Access ]] do
    -- "Editor only calls SaveLevel, App only calls LoadLevel"

    --- @param fileName string? [Default: objects.ddb]
    function STATIC.SaveDefinitions( fileName )
        typecheck.NotImplementedError()
    end

    --- @param fileName string? [Default: objects.ddb]
    function STATIC.LoadDefinitions( fileName )
        if not fileName then fileName = STATIC.DefaultDefinitionFilename end

        STATIC.LoadSaveLoadSystem( fileName, true )
    end
end

--[[ Generic [SaveLoadSubSystemClass] Access ]] do

    --- @param fileName string
    --- @param autoPostLoad boolean
    function STATIC.LoadSaveLoadSystem( fileName, autoPostLoad )
        local openedFile = file.Open( fileName, "rb", "THIRDPARTY" )
        if openedFile then
            local cload = chunkLoadClass.New( openedFile )
            saveLoadSystemClass.Load( cload, autoPostLoad )
            openedFile:Close()
        else
            Section.Error( "Failed to load file: ", fileName )
        end
    end

    --- @param fileName string
    --- @vararg any
    function STATIC.SaveSaveLoadSystem( fileName, ... )
        typecheck.NotImplementedError()
    end
end