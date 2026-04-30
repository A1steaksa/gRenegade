-- Based on FileStraw within Code/wwlib/xstraw.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type StrawClass
local strawClass = CNC.Import( "code/wwlib/straw.lua" )

--- @class FileStrawClass : StrawClass
--- @field Instance FileStrawInstance The metatable used by FileStrawInstance
local STATIC = CNC.CreateExport( strawClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "FileStrawClass"

--- @class FileStrawInstance : StrawInstance
--- @field Static FileStrawClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_FileStraw : Renegade_Straw" )
INSTANCE.Class = "FileStrawInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsFileStraw = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type FileClass
    local fileClass = CNC.Import( "code/wwlib/file.lua" )
--#endregion

--#region Imported Enums

    local fileRightsEnum = fileClass.FILE_RIGHTS
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class FileStrawClass

    --- Creates a new FileStrawInstance
    --- @param file FileInstance
    --- @return FileStrawInstance
    function STATIC.New( file )
        return robustclass.New( "Renegade_FileStraw", file )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) FileStrawInstance, `false` otherwise
    function STATIC.IsFileStraw( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsFileStraw and true or false
    end

    typecheck.RegisterType( "FileStrawInstance", STATIC.IsFileStraw )
end

--- "  
--- This class is used to manage a file as a data source.  
--- Data requests will draw from the file until the file has been completely read.
--- "  
--- @class FileStrawInstance
--- @field File FileInstance
--- @field HasOpened boolean

--- @param file FileInstance
function INSTANCE:Renegade_FileStraw( file )
    self.File = file
    self.HasOpened = false
end

-- "This destructor only needs to close the file if it was the one to open it."
function INSTANCE:_Renegade_FileStraw()
    if self:ValidFile() and self.HasOpened then
        self.File:Close()
        self.HasOpened = false
        self.File = nil
    end
end

--- @param slen integer "The number of data bytes requested"
--- @return integer readByteCount, string buffer
function INSTANCE:Get( slen )
    if self:ValidFile() and slen > 0 then
        if not self.File:IsOpen() then
            self.HasOpened = true
            if not self.File:IsAvailable() then
                return 0, ""
            end

            if not self.File:Open( fileRightsEnum.READ ) then
                return 0, ""
            end
        end

        local buffer, actualSize = self.File:Read( slen )

        return actualSize, buffer
    end

    return 0, ""
end

function INSTANCE:ValidFile()
    return self.File ~= nil
end
