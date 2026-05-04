-- Based on FileClass within Code/wwlib/wwfile.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class FileClass
--- @field Instance FileInstance The metatable used by FileInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "FileClass"

--- @class FileInstance
--- @field Static FileClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_File" )
INSTANCE.Class = "FileInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsFile = true

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum SeekDirection
    STATIC.SEEK_DIRECTION = {
        SEEK_SET = 0, -- "Seek from start of file."
        SEEK_CUR = 1, -- "Seek relative from current location."
        SEEK_END = 2  -- "Seek from end of file."
    }
    local seekDirectionEnum = STATIC.SEEK_DIRECTION

    --- @enum FileRights
    STATIC.FILE_RIGHTS = {
        READ  = 1,
        WRITE = 2
    }
    local fileRightsEnum = STATIC.FILE_RIGHTS
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class FileClass

    --- Creates a new FileInstance
    --- @return FileInstance
    function STATIC.New()
        return robustclass.New( "Renegade_File" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) FileInstance, `false` otherwise
    function STATIC.IsFile( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsFile and true or false
    end

    typecheck.RegisterType( "FileInstance", STATIC.IsFile )
end


--- @class FileInstance

local PRINTF_BUFFER_SIZE = 1024

function INSTANCE:_Renegade_File()
    typecheck.NotImplementedError()
end

--- @return string
function INSTANCE:FileName()
    typecheck.NotImplementedError()
end

--- @param fileName string
function INSTANCE:SetName( fileName )
    typecheck.NotImplementedError()
end

function INSTANCE:Create()
    typecheck.NotImplementedError()
end

function INSTANCE:Delete()
    typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:IsAvailable()
    typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:IsOpen()
    typecheck.NotImplementedError()
end

--- @overload fun( self: FileInstance, fileName: string, rights: FileRights? ): boolean
--- @overload fun( self: FileInstance, rights: FileRights? ): boolean
function INSTANCE:Open( fileName, rights )
    typecheck.NotImplementedError()
end

--- @param size integer
--- @return string buffer, integer actualSize
function INSTANCE:Read( size )
    typecheck.NotImplementedError()
end

--- @param pos integer
--- @param direction SeekDirection? [Default: `SEEK_CUR`]
--- @return integer
function INSTANCE:Seek( pos, direction )
    direction = direction or seekDirectionEnum.SEEK_CUR

    typecheck.NotImplementedError()
end

--- @return integer
function INSTANCE:Tell()
    return self:Seek( 0 )
end

function INSTANCE:Size()
    typecheck.NotImplementedError()
end

--- @param buffer string
--- @param size integer
--- @return integer
function INSTANCE:Write( buffer, size )
    typecheck.NotImplementedError()
end

function INSTANCE:Close()
    typecheck.NotImplementedError()
end

--- @return integer
function INSTANCE:GetDateTime()
    return 0
end

--- @param dateTime integer
function INSTANCE:SetDateTime( dateTime )
    return false
end

--- @param error integer
--- @param canRetry boolean? [Default: `false`]
--- @param fileName string? [Default: `nil`]
function INSTANCE:Error( error, canRetry, fileName )
    canRetry = canRetry or false

    typecheck.NotImplementedError()
end

function INSTANCE:GetFileHandle()
    typecheck.NotImplementedError()
end

--- @param start integer
--- @param length integer? [Default: -1]
function INSTANCE:Bias( start, length )
    length = length or -1

    typecheck.NotImplementedError()
end

function INSTANCE:Printf()
    typecheck.NotImplementedError()
end

function INSTANCE:PrintfIndented()
    typecheck.NotImplementedError()
end
