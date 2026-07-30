-- Based on FileFactoryClass within Code/wwlib/ffactory.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class FileFactoryClass
--- @field Instance FileFactoryInstance The metatable used by FileFactoryInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "FileFactoryClass"

--- @class FileFactoryInstance
--- @field Static FileFactoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_FileFactory" )
INSTANCE.Class = "FileFactoryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsFileFactory = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type SimpleFileFactoryClass
    local simpleFileFactoryClass = CNC.Import( "code/wwlib/simple-file-factory.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- "a pure virtual class used to create FileClasses"
    --- @class FileFactoryClass
    --- @field DefaultFileFactory SimpleFileFactoryInstance
    --- @field TheFileFactory FileFactoryInstance
    --- @field TheSimpleFileFactory SimpleFileFactoryInstance
    --- @field DefaultWritingFileFactory SimpleFileFactoryInstance
    --- @field TheWritingFileFactory FileFactoryInstance

    --- Creates a new FileFactoryInstance
    --- @return FileFactoryInstance
    function STATIC.New()
        return robustclass.New( "Renegade_FileFactory" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) FileFactoryInstance, `false` otherwise
    function STATIC.IsFileFactory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsFileFactory and true or false
    end

    function STATIC.StaticConstructor()
        STATIC.DefaultFileFactory = simpleFileFactoryClass.New()
        STATIC.TheFileFactory = STATIC.DefaultFileFactory
        STATIC.TheSimpleFileFactory = STATIC.DefaultFileFactory

        STATIC.DefaultWritingFileFactory = simpleFileFactoryClass.New()
        STATIC.TheWritingFileFactory = STATIC.DefaultWritingFileFactory
    end

    typecheck.RegisterType( "FileFactoryInstance", STATIC.IsFileFactory )
end

--- "a pure virtual class used to create FileClasses"
--- @class FileFactoryInstance

function INSTANCE:Renegade_FileFactory()
    -- Intentionally empty. Exists so child classes have a parent constructor to call.
end

function INSTANCE:_Renegade_FileFactory()
    CNC.VirtualFunction()
end

--- @param fileName string
--- @return FileInstance?
function INSTANCE:GetFile( fileName )
    return CNC.VirtualFunction() --[[@as FileInstance]]
end

--- @param file FileInstance
function INSTANCE:ReturnFile( file )
    CNC.VirtualFunction()
end
