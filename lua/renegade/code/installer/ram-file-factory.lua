-- Based on RAMFileFactoryClass within Code/Installer/RAMFileFactory.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type FileFactoryClass
local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

--- @class RAMFileFactoryClass : FileFactoryClass
--- @field Instance RAMFileFactoryInstance The metatable used by RAMFileFactoryInstance
local STATIC = CNC.CreateExport( fileFactoryClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "RAMFileFactoryClass"

--- @class RAMFileFactoryInstance : FileFactoryInstance
--- @field Static RAMFileFactoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_RAMFileFactory : Renegade_FileFactory" )
INSTANCE.Class = "RAMFileFactoryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsRAMFileFactory = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type RamFileClass
	local ramFileClass = CNC.Import( "code/wwlib/ram-file.lua" )

	--- @type BufferedFileClass
	local bufferedFileClass = CNC.Import( "code/wwlib/buffered-file.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class RAMFileFactoryClass

    --- Creates a new RAMFileFactoryInstance
    --- @return RAMFileFactoryInstance
    function STATIC.New()
        return robustclass.New( "Renegade_RAMFileFactory" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) RAMFileFactoryInstance, `false` otherwise
    function STATIC.IsRAMFileFactory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsRAMFileFactory and true or false
    end

    typecheck.RegisterType( "RAMFileFactoryInstance", STATIC.IsRAMFileFactory )
end


--- @class RAMFileFactoryInstance
--- @field FileBuffer string
--- @field FileBufferSize integer
--- @field FileName string

function INSTANCE:Renegade_RAMFileFactory()
    fileFactoryClass.Instance.Renegade_FileFactory( self )
    self.FileBuffer = nil
end

function INSTANCE:_Renegade_RAMFileFactory()
    if self.FileBuffer ~= nil then
        self.FileBuffer = nil
    end
end

--- @param fileName string
--- @return FileInstance?
function INSTANCE:GetFile( fileName )
    -- "If file buffer has not been read then do it now."
    if ( self.FileBuffer == nil ) or ( fileName == self.FileName ) then
        if self.FileBuffer ~= nil then
            self.FileBuffer = nil
        end

        local bufferFile = bufferedFileClass.New( fileName )
        if bufferFile ~= nil and bufferFile:IsAvailable() then
            bufferFile:Open()
            self.FileBuffer = bufferFile:Read( bufferFile:Size() )
        end

        self.FileBufferSize = bufferFile:Size()
        self.FileName = fileName
    end

    local ramFile = ramFileClass.New( self.FileBuffer, self.FileBufferSize )
    return ramFile
end

function INSTANCE:ReturnFile( file )
	--- This function left intentionally empty
end
