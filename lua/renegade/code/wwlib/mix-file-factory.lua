-- Based on MixFileFactoryClass within Code/wwlib/mixfile.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type FileFactoryClass
local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

--- @class MixFileFactoryClass : FileFactoryClass
--- @field Instance MixFileFactoryInstance The metatable used by MixFileFactoryInstance
local STATIC = CNC.CreateExport( fileFactoryClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MixFileFactoryClass"

--- @class MixFileFactoryInstance : FileFactoryInstance
--- @field Static MixFileFactoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MixFileFactory : Renegade_FileFactory" )
INSTANCE.Class = "MixFileFactoryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMixFileFactory = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type FileClass
    local fileClass = CNC.Import( "code/wwlib/file.lua" )
--#endregion

--#region Imported Enums

    local seekDirectionEnum = fileClass.SEEK_DIRECTION
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MixFileFactoryClass

    --- Creates a new MixFileFactoryInstance
    --- @param mixFileName string
    --- @param factory FileFactoryInstance
    --- @return MixFileFactoryInstance
    function STATIC.New( mixFileName, factory )
        return robustclass.New( "Renegade_MixFileFactory", mixFileName, factory )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MixFileFactoryInstance, `false` otherwise
    function STATIC.IsMixFileFactory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMixFileFactory and true or false
    end

    typecheck.RegisterType( "MixFileFactoryInstance", STATIC.IsMixFileFactory )
end

--- @class MixFileHeaderStruct
--- @field Signature string
--- @field HeaderOffset integer
--- @field NamesOffset integer

local mixFileHeaderStructSize = 12
local mixFileHeaderSignatureSize = 4
local mixFileHeaderHeaderOffsetSize = 4
local mixFileHeaderNamesOffsetSize = 4

--- @param rawMixFileHeaderStruct string
--- @return MixFileHeaderStruct
local function DeserializeMixFileHeaderStruct( rawMixFileHeaderStruct )
    local binaryConverter = BinaryConverter:Get()

    -- Signature
    local startIndex = 1
    local endIndex = mixFileHeaderSignatureSize
    local rawSignature = rawMixFileHeaderStruct:sub( startIndex, endIndex )
    local signature = binaryConverter:FromCharArray( rawSignature )

    -- Header Offset
    startIndex = endIndex + 1
    endIndex = startIndex + mixFileHeaderHeaderOffsetSize - 1
    local rawHeaderOffset = rawMixFileHeaderStruct:sub( startIndex, endIndex )
    local headerOffset = binaryConverter:FromInt32( rawHeaderOffset )

    -- Names Offset
    startIndex = endIndex + 1
    endIndex = startIndex + mixFileHeaderNamesOffsetSize - 1
    local rawNamesOffset = rawMixFileHeaderStruct:sub( startIndex, endIndex )
    local namesOffset = binaryConverter:FromInt32( rawNamesOffset )

    return {
        Signature = signature,
        HeaderOffset = headerOffset,
        NamesOffset = namesOffset
    }
end

--- @class MixFileDataHeader
--- @field fileCount integer

local mixFileDataHeaderSize = 12

--- @class FileInfoStruct
--- @field Crc integer "CRC code for embedded file."
--- @field Offset integer "Offset from start of data section"
--- @field Size integer "Size of data subfile"

local fileInfoStructSize = 12
local fileInfoCrcSize = 4
local fileInfoOffsetSize = 4
local fileInfoSizeSize = 4

--- @param rawStruct string
--- @return FileInfoStruct
local function DeserializeFileInfoStruct( rawStruct )
    local binaryConverter = BinaryConverter:Get()

    -- CRC
    local startIndex = 1
    local endIndex = fileInfoCrcSize
    local rawCrc = rawStruct:sub( startIndex, endIndex )
    local crc = binaryConverter:FromUInt32( rawCrc )

    -- Offset
    startIndex = endIndex + 1
    endIndex = startIndex + fileInfoOffsetSize - 1
    local rawOffset = rawStruct:sub( startIndex, endIndex )
    local offset = binaryConverter:FromUInt32( rawOffset )

    -- Size
    startIndex = endIndex + 1
    endIndex = startIndex + fileInfoSizeSize - 1
    local rawSize = rawStruct:sub( startIndex, endIndex )
    local size = binaryConverter:FromUInt32( rawSize )

    return {
        Crc = crc,
        Offset = offset,
        Size = size
    }
end

--- @param rawStructArray string
--- @return FileInfoStruct[]
local function DeserializeFileInfoStructArray( rawStructArray )
    --- @type FileInfoStruct[]
    local fileInfoStructs = {}

    local structCount = rawStructArray:len() / fileInfoStructSize
    if structCount ~= math.floor( structCount ) then
        section.Error( "Got incomplete FileInfoStruct during MixFileFactory deserializing" )
    end

    for structIndex = 1, structCount do
        local startIndex = 1 + ( structIndex - 1 ) * fileInfoStructSize
        local endIndex = startIndex + fileInfoStructSize - 1
        local rawStruct = rawStructArray:sub( startIndex, endIndex )

        fileInfoStructs[#fileInfoStructs+1] = DeserializeFileInfoStruct( rawStruct )

        local fileInfoStruct = fileInfoStructs[#fileInfoStructs]
    end

    return fileInfoStructs
end

--- @class AddInfoStruct
--- @field FullPath string
--- @field Filename string

--- @class MixFileFactoryInstance
--- @field Factory FileFactoryInstance
--- @field FileInfo FileInfoStruct[]
--- @field MixFilename string
--- @field BaseOffset integer
--- @field FileCount integer
--- @field NamesOffset integer
--- @field IsValid boolean
--- @field FilenameList string[]
--- @field PendingAddFileList AddInfoStruct[]
--- @field IsModified boolean

--- @param mixFileName string
--- @param factory FileFactoryInstance
function INSTANCE:Renegade_MixFileFactory( mixFileName, factory )
    self.FileCount = 0
    self.NamesOffset = 0
    self.IsValid = false
    self.BaseOffset = 0
    self.Factory = nil
    self.IsModified = false

    self.MixFilename = mixFileName
    self.Factory = factory

    -- "First, open the mix file"
    local file = factory:GetFile( mixFileName )

    if file ~= nil and file:IsAvailable() then

        local binaryConverter = BinaryConverter:Get()

        file:Open()

        self.IsValid = true

        -- "Read the file header"
        local rawHeader = file:Read( mixFileHeaderStructSize )
        local header = DeserializeMixFileHeaderStruct( rawHeader )
        self.IsValid = ( rawHeader:len() == mixFileHeaderStructSize )

        -- "Validate the file header"
        if self.IsValid then
            self.IsValid = ( header.Signature == "MIX1" )
        end

        -- "Seek to the data start"
        self.FileCount = 0
        if self.IsValid then
            file:Seek( header.HeaderOffset, seekDirectionEnum.SEEK_SET )

            local fileCountSize = 4
            local rawFileCount = file:Read( fileCountSize )

            self.FileCount = binaryConverter:FromInt32( rawFileCount ) --[[@as integer]]

            self.IsValid = ( rawFileCount:len() == fileCountSize )
        end

        -- "Read the array of data headers"
        if self.IsValid then
            self.FileInfo = self.FileInfo or {}
            local size = self.FileCount * fileInfoStructSize

            local rawDataHeaders = file:Read( size )

            self.FileInfo = DeserializeFileInfoStructArray( rawDataHeaders )

            self.IsValid = #self.FileInfo == self.FileCount
        end

        -- "Check for success"
        if self.IsValid then
            self.BaseOffset = 0
            self.NamesOffset = header.NamesOffset
            section.Print( "MixFileFactory( ", self.MixFilename, " ) loaded successfully ", #self.FileInfo, " files" )
        else
            self.FileInfo = {}
        end

        factory:ReturnFile( file )
    else
        section.Error( "MixFileFactory( ", mixFileName, " ) FAILED" )
    end
end

function INSTANCE:_Renegade_MixFileFactory()
    typecheck.NotImplementedError()
end

--- @param fileName string
--- @return FileInstance?
function INSTANCE:GetFile( fileName )
    if #self.FileInfo == 0 then
        return nil
    end

    --- @type RawFileInstance
    local file

    -- "Create the key block that will be used to binary search for the file"
    local crc = tonumber( util.CRC( fileName:upper() ) )

    -- "Binary search for the file in this mixfile.  If it is found, then create the file"
    --- @type FileInfoStruct
    local info
    local base = 1
    local stride = #self.FileInfo
    while stride > 0 do
        local pivotIndex = base + math.floor( stride / 2 )
        local pivotFileInfoStruct = self.FileInfo[pivotIndex]

        if crc < pivotFileInfoStruct.Crc then
            stride = math.floor( stride / 2 )
        else
            if pivotFileInfoStruct.Crc == crc then
                info = pivotFileInfoStruct
                break
            end
            base = pivotIndex + 1
            stride = stride - math.floor( stride / 2 ) - 1
        end
    end

    if info ~= nil then
        file = self.Factory:GetFile( self.MixFilename ) --[[@as RawFileInstance]]
        if file ~= nil then
            file:Bias( self.BaseOffset + info.Offset, info.Size )
        end
    end

    return file
end

function INSTANCE:ReturnFile()
    typecheck.NotImplementedError()
end

function INSTANCE:BuildFilenameList()
    typecheck.NotImplementedError()
end

function INSTANCE:BuildInternalFilenameList()
    typecheck.NotImplementedError()
end

function INSTANCE:GetFilenameList()
    typecheck.NotImplementedError()
end

function INSTANCE:AddFile()
    typecheck.NotImplementedError()
end

function INSTANCE:DeleteFile()
    typecheck.NotImplementedError()
end

function INSTANCE:FlushChanges()
    typecheck.NotImplementedError()
end

function INSTANCE:IsValid()
    typecheck.NotImplementedError()
end

function INSTANCE:GetTempFilename()
    typecheck.NotImplementedError()
end
