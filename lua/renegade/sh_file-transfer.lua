-- A library to make it easy to send `/data/` files to clients

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class FileTransferLib
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "FileTransferLib"

--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--- @class FileTransferLib

STATIC.ThinkHookId       = "A1_Renegade_FileTransfer_SendQueuedFiles"
STATIC.NetMessageId      = "A1_Renegade_FileTransfer"
STATIC.MaxBytesPerSecond = 65532

if SERVER then
    util.AddNetworkString( STATIC.NetMessageId )

    --- @class FileTransferLib

    --- The files that should be sent to all players when they join
    --- A mapping of `[File path][LZMA compressed file contents]`  
    --- Because these files are sent to all players, their compressed content
    --- is kept in memory to avoid repeating work and to minimize disk use
    --- @type table<string, string>
    STATIC.FilesForAll = {}

    --- A mapping of `[Players][File paths][Is file transfered?]`
    --- @type table<Player, table<string, boolean>>
    STATIC.FileTransfers = {}

    --- @private
    function STATIC.TransferFiles()
        while true do

        end
    end

    --- @private
    STATIC.Coroutine = coroutine.create( STATIC.TransferFiles ) --[[@as thread]]

    --[[ Sending Files ]] do

        --- @private
        --- Retrieves a file's contents as a compressed string
        --- @param filePath string
        --- @return string # The file's contents after being compressed
        function STATIC.GetCompressedFileContent( filePath )
            -- Check the compressed files for all cache
            local fileContent = STATIC.CompressedFilesForAll[filePath]

            -- Load and compress the file from the disk if it wasn't cached
            if not fileContent then
                local openFile = file.Open( filePath, "rb", "THIRDPARTY" )

                if not openFile then
                    section.Error( "Failed to open file to send: '", filePath, "'" )
                end

                fileContent = openFile:Read()

                openFile:Close()

                fileContent = util.Compress( fileContent )
            end

            return fileContent
        end

        --- @private
        --- Sends a given file to one or more players
        --- @param filePath string
        --- @param ply Player|Player[]
        function STATIC.SendFile( filePath, ply )

            filePath = filePath:TrimLeft()
            filePath = filePath:TrimLeft( '/' )

            local fileContent = STATIC.GetCompressedFileContent( filePath )

            local byteCount = fileContent:len()
            local filePartCount = math.ceil( byteCount / STATIC.MaxBytesPerSecond )

            section.Start( "Sending ", byteCount, " byte, ", filePartCount, " part file: '", filePath, "' to ", ply )

            -- Remove the data folder from the file path because it's implicit when
            -- writing files and we don't want to network unnecessary data
            local dataLocalFilePath = filePath
            if dataLocalFilePath:StartsWith("data/") then
                dataLocalFilePath = dataLocalFilePath:sub( 6 )
            end

            -- The first message is the file path and the number of data messages to follow
            net.Start( STATIC.NetMessageId, false )
            net.WriteString( dataLocalFilePath )
            net.WriteInt( filePartCount, 32 )
            net.Send( ply )

            local startPos = 0
            -- Send the file's contents
            for filePart = 0, filePartCount - 1 do

                local endPos = math.min( startPos + STATIC.MaxBytesPerSecond, byteCount )
                local partData = fileContent:sub( startPos, endPos )
                startPos = endPos + 1

                section.Print( "Part ", filePart, ": ", #partData, " bytes, start: ", startPos, ", end: ", endPos )

                net.Start( STATIC.NetMessageId, false )
                net.WriteData( partData )
                net.Send( ply )
            end

            section.End()
        end

        concommand.Add( "ren_debug_sendfile", function()
            local ply = player.GetAll()[1]

            --- @param filePath string
            CNC.IterateFilesRecursively( "data/renegade/", "THIRDPARTY", function( filePath )
                STATIC.QueueFile( filePath, ply )
            end )
        end )
    end

    --[[ Files for All ]] do

        --- Ensures a given file will be sent to all new and existing players
        --- @param filePath string
        function STATIC.AddFileForAll( filePath )
            typecheck.NotImplementedError()
        end

        --- Removes a file from being sent to all players
        --- @param filePath string
        --- @return boolean # `true` if the file was found in the list and removed, `false` otherwise
        function STATIC.RemoveFileForAll( filePath )
            typecheck.NotImplementedError()
        end

        --- @private
        --- Called when a client requests a copy of the "files for all"
        function STATIC.SendFilesForAll()
            typecheck.NotImplementedError()
        end
        net.Receive( STATIC.NetMessageId, STATIC.SendFilesForAll )
    end
end


if CLIENT then

    --- @class FileTransferLib
    --- @field IsFileBeingReceived boolean
    --- @field IncomingFilePath string The path, name, and extension of the file that is being downloaded
    --- @field TotalFileParts integer How many parts the incoming file will be broken up into
    --- @field ReceivedFilePartCount integer How many parts of the incoming file we have already received
    --- @field IncomingFileContents string The in-progress compressed byte string of the incoming file's data

    function STATIC.ResetQueue()
        STATIC.IsFileBeingReceived   = false
        STATIC.IncomingFileContents  = nil
        STATIC.IncomingFilePath      = ""
        STATIC.TotalFileParts        = 0
        STATIC.ReceivedFilePartCount = 0
    end

    if isHotload then
        STATIC.ResetQueue()
    end

    hook.Add( "OnLuaError", "A1_Renegade_FileTransfer_ResetQueueOnError", STATIC.ResetQueue )

    --- @private
    --- Called when a file is sent from the server
    function STATIC.ReceiveFile( bitCount )
        -- Start receiving a new file
        if not STATIC.IsFileBeingReceived then
            STATIC.IncomingFilePath      = net.ReadString()
            STATIC.TotalFileParts        = net.ReadInt( 32 )
            STATIC.ReceivedFilePartCount = 0
            STATIC.IncomingFileContents  = nil
            STATIC.IsFileBeingReceived   = true

            local incomingFileDir = string.GetPathFromFilename( STATIC.IncomingFilePath )
            file.CreateDir( incomingFileDir )

            section.Start( "Receiving ", STATIC.TotalFileParts, " part file: '", STATIC.IncomingFilePath, "'" )

            return
        end

        -- Receive a file part
        local partByteCount = math.ceil( bitCount / 8 )
        local newData = net.ReadData( partByteCount )

        if not STATIC.IncomingFileContents then
            STATIC.IncomingFileContents = newData
        else
            STATIC.IncomingFileContents = STATIC.IncomingFileContents .. newData
        end

        section.Print( "Part ", STATIC.ReceivedFilePartCount, ": ", partByteCount, " bytes" )

        STATIC.ReceivedFilePartCount = STATIC.ReceivedFilePartCount + 1

        -- Is this the end of the file?
        if STATIC.ReceivedFilePartCount == STATIC.TotalFileParts then

            section.Print( "Decompressing file from ", #STATIC.IncomingFileContents, " bytes" )

            local uncompressedFileContent = util.Decompress( STATIC.IncomingFileContents )

            if not uncompressedFileContent then
                STATIC.IsFileBeingReceived = false
                STATIC.IncomingFileContents = ""

                section.Error( "Failed to decompress incoming file contents for '", STATIC.IncomingFilePath, "'" )
            end
            --- @cast uncompressedFileContent string

            section.Print( "Writing file to disk" )

            local writeResult = file.Write( STATIC.IncomingFilePath, uncompressedFileContent )

            if not writeResult then
                section.Error( "Failed to write to disk: '", STATIC.IncomingFilePath, "'" )
            end

            STATIC.IsFileBeingReceived = false
            STATIC.IncomingFileContents = nil

            section.End()
        end
    end
    net.Receive( STATIC.NetMessageId, STATIC.ReceiveFile )
end