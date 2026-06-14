-- Based on BufferedFileClass within Code/wwlib/bufffile.h/cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type RawFileClass
local rawFileClass = CNC.Import( "code/wwlib/raw-file.lua" )

--- @class BufferedFileClass : RawFileClass
--- @field Instance BufferedFileInstance The metatable used by BufferedFileInstance
local STATIC = CNC.CreateExport( rawFileClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BufferedFileClass"

--- @class BufferedFileInstance : RawFileInstance
--- @field Static BufferedFileClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BufferedFile : Renegade_RawFile" )
INSTANCE.Class = "BufferedFileInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBufferedFile = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type FileClass
    local fileClass = CNC.Import( "code/wwlib/file.lua" )
--#endregion

--#region Imported Enums

    local fileRightsEnum = fileClass.FILE_RIGHTS
    local seekDirectionEnum = fileClass.SEEK_DIRECTION
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class BufferedFileClass
    --- @field DesiredBufferSize integer

    --- Creates a new BufferedFileInstance
    --- @return BufferedFileInstance
    function STATIC.New()
        return robustclass.New( "Renegade_BufferedFile" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BufferedFileInstance, `false` otherwise
    function STATIC.IsBufferedFile( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBufferedFile and true or false
    end

    typecheck.RegisterType( "BufferedFileInstance", STATIC.IsBufferedFile )

    function STATIC.SetDesiredBufferSize()
        typecheck.NotImplementedError()
    end
end


--- @class BufferedFileInstance
--- @field Buffer string "The read buffer"
--- @field BufferSize integer "The allocated size of the read buffer"
--- @field BufferAvailable integer "The amount of data in the read buffer"
--- @field BufferOffset integer "The data already given out"

local DesiredBufferSize = 1024 * 16

--- "Simple constructor for a file object."
--- @param fileName string? (Optional) "The filename to assign to this file object."
function INSTANCE:Renegade_BufferedFile( fileName )
    rawFileClass.Instance.Renegade_RawFile( self, fileName )
    self.Buffer = ""
    self.BufferSize = 0
    self.BufferAvailable = 0
    self.BufferOffset = 0
end

--- "Default deconstructor for a file object."
function INSTANCE:_Renegade_BufferedFile()
    self:ResetBuffer()
end

--- "Reads the specified number of bytes into a memory buffer."
--- @param size integer The number of bytes to read from the file
--- @return string buffer The data read from the file
--- @return integer actualSize "the number of bytes read ... If this number is less than requested, it indicates that the file has been exhausted."
function INSTANCE:Read( size )
    local read = 0
    local buffer = ""

    -- "If there is anything in the buffer, copy it in."
    if self.BufferAvailable > 0 then
        local amount = math.min( size, self.BufferAvailable )
        buffer = self.Buffer:sub( self.BufferOffset, self.BufferOffset + amount - 1 )
        self.BufferAvailable = self.BufferAvailable - amount
        self.BufferOffset = self.BufferOffset + amount
        size = size - amount
        read = read + amount
    end

    if size == 0 then
        return buffer, read
    end

    --- "  
    --- We need to get a copy of the [DesiredBufferSize] into
    --- a local variable to protect us from modifications
    --- from another thread.  Otherwise, we could pass the test
    --- (size > amount) below, only to allocate a buffer that's
    --- too small in the next block. (DRM, 04/20/01)
    --- "  
    local desiredBufferSize = DesiredBufferSize

    -- "If we need more than the buffer will hold, just read it"
    local amount = self.BufferSize
    if amount == 0 then
        amount = desiredBufferSize
    end
    if size > amount then
        local readBuffer, readBytes = rawFileClass.Instance.Read( self, size )
        return ( buffer .. readBuffer ), ( read + readBytes )
    end

    -- "If we dont have a buffer, get one"
    if self.BufferSize == 0 then
        self.BufferSize = desiredBufferSize
        self.Buffer = ""
        self.BufferAvailable = 0
        self.BufferOffset = 1
    end

    -- "Fill the buffer"
    if self.BufferAvailable == 0 then
        local readBuffer, readBytes = rawFileClass.Instance.Read( self, self.BufferSize )
        self.Buffer = readBuffer
        self.BufferAvailable = readBytes
        self.BufferOffset = 1
    end

    -- "If there is anything in the buffer, copy it in."
    if self.BufferAvailable > 0 then
        local amount = math.min( size, self.BufferAvailable )
        buffer = buffer .. self.Buffer:sub( self.BufferOffset, self.BufferOffset + amount - 1 )
        self.BufferAvailable = self.BufferAvailable - amount
        self.BufferOffset = self.BufferOffset + amount
        read = read + amount
    end

    return buffer, read
end

--- "Reposition the file pointer as indicated."
--- @param pos integer "The position to seek to.  This is interpreted as relative to the position indicated by the 'dir' parameter"
--- @param direction SeekDirection "The relative position to relate the seek to.  This can be either `SEEK_SET` for the beginning of the file, `SEEK_CUR` for the current position, or `SEEK_END` for the end of the file."
--- @return integer # "...the position that the seek ended up at."
function INSTANCE:Seek( pos, direction )
    if ( direction ~= seekDirectionEnum.SEEK_CUR ) or ( pos < 1 ) then
        self:ResetBuffer()
    end

    -- "If not buffered, pass through"
    if self.BufferAvailable == 0 then
        return rawFileClass.Instance.Seek( self, pos, direction )
    end

    -- "Use up what we can of the buffer"
    local amount = math.min( pos, self.BufferAvailable )
    pos = pos - amount
    self.BufferAvailable = self.BufferAvailable - amount
    self.BufferOffset = self.BufferOffset + amount

    return rawFileClass.Instance.Seek( self, pos, direction ) - self.BufferAvailable
end

function INSTANCE:Write()
    typecheck.NotImplementedError()
end

--- "Perform a closure of the file."
function INSTANCE:Close()
    rawFileClass.Instance.Close( self )

    self:ResetBuffer()
end

function INSTANCE:ResetBuffer()
    if self.Buffer ~= nil then
        self.Buffer = nil
        self.BufferSize = 0
        self.BufferAvailable = 0
        self.BufferOffset = 0
    end
end
