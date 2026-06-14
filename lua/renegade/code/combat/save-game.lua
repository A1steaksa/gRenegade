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
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type FileFactoryClass
	local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

	--- @type FileClass
	local fileClass = CNC.Import( "code/wwlib/file.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion


--#region Imported Enums

	local fileRightsEnum = fileClass.FILE_RIGHTS
	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

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

STATIC.DefaultDefinitionFilename = "objects.ddb"
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
    --- @return boolean success
    --- @return string? mapName
    function STATIC.PeekMapName( fileName )
        -- "Open the file as a chunk"
        local file = fileFactoryClass.TheFileFactory:GetFile( fileName )
        assert( file ~= nil )
        file:Open( fileRightsEnum.READ )
        local cload = chunkLoadClass.New( file )

        local returnValue = false

        --- @type string
        local mapName

        local readTable = {}

        -- "Loop until we've found the header chunk"
        while returnValue == false and cload:OpenChunk() do
            local chunkId = cload:CurChunkId()

            if chunkId == STATIC.ChunkIds.CHUNKID_LEVEL_INFO then
                while returnValue == false and cload:OpenMicroChunk() do
                    local microChunkId = cload:CurMicroChunkId()
                    if microChunkId == STATIC.ChunkIds.MICROCHUNKID_MAP_FILENAME then
                        chunkIOClass.LoadMicroChunkWWString( cload, readTable, "MapName" )
                        mapName = readTable.MapName --[[@as string]]

                        returnValue = true
                    end
                    cload:CloseMicroChunk()
                end
            end
            cload:CloseChunk()
        end

        -- "Close the file"
        file:Close()
        fileFactoryClass.TheFileFactory:ReturnFile( file )

        return returnValue, mapName
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

        local file = fileFactoryClass.TheFileFactory:GetFile( fileName )
        assert( file ~= nil )
        file:Open( fileRightsEnum.READ )
        local cload = chunkLoadClass.New( file )

        local ids = STATIC.ChunkIds

        while cload:OpenChunk() do
            local chunkId = cload:CurChunkId()
            if chunkId == ids.CHUNKID_LEVEL_INFO then
                while cload:OpenMicroChunk() do
                    local microChunkId = cload:CurMicroChunkId()

                    local didRead =
                        chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_MAP_FILENAME, STATIC, "MapFileName" )
                        or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_MISSION_DESCRIPTION, fundamentalDataTypeEnum.Int, STATIC, "MissionDescriptionId" )
                        or chunkIOClass.ReadMicroChunkWideString( cload, ids.MICROCHUNKID_DESCRIPTION, STATIC, "Description" )

                    if not didRead then
                        section.Warn( "Unrecognized level info chunkID ", microChunkId )
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
                section.Warn( "Unrecognized level chunk ID ", chunkId )
            end
            cload:CloseChunk()
        end

        file:Close()
    end

    --- @param fileName string
    --- @return string fileNameToLoad
    --- @return string lsdFileName
    function STATIC.PreLoadGame( fileName )


        if fileName:EndsWith( ".txt" ) then
            fileName = fileName:sub( 1, -5 )
        end

        -- "Get the root name and extension from the filename"
        local rootName = string.StripExtension( fileName )
        local extension = "." .. string.GetExtensionFromFilename( fileName )

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
                section.Print( "Peeked map name: ", mapName )
                --- @cast mapName string

                local mixRootName = string.StripExtension( mapName )

                lsdFileName = string.format( "%s.lsd", mixRootName )
                local mixFileName = string.format( "%s.mix", mixRootName )

                -- Omitting level 9 hack hack

                -- Omitted adding to thumbnail manager
                -- local thumbFileName = mixRootName .. ".thu"
                -- thumbnailManagerClass.AddThumbnailManager( thumbFileName, mixFileName )
            else
                section.Warn( "Failed to peek map name from: \"", fileName, "\"" )
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
        if fileName == nil then fileName = STATIC.DefaultDefinitionFilename end

        STATIC.LoadSaveLoadSystem( fileName, true )
    end
end

--[[ Generic [SaveLoadSubSystemClass] Access ]] do

    --- @param fileName string
    --- @param autoPostLoad boolean
    function STATIC.LoadSaveLoadSystem( fileName, autoPostLoad )


        section.Print( Color( 20, 255, 0 ), fileName )

        local file = fileFactoryClass.TheFileFactory:GetFile( fileName )
        if file ~= nil then
            file:Open( fileRightsEnum.READ )
            local cload = chunkLoadClass.New( file )
            saveLoadSystemClass.Load( cload, autoPostLoad )
            file:Close()
            fileFactoryClass.TheFileFactory:ReturnFile( file )
        else
            section.Error( "Failed to load file: ", fileName )
        end
    end

    --- @param fileName string
    --- @vararg any
    function STATIC.SaveSaveLoadSystem( fileName, ... )
        typecheck.NotImplementedError()
    end
end