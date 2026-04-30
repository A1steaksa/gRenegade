-- Based on RawFileFactoryClass within Code/wwlib/ffactory.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type FileFactoryClass
local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

--- @class RawFileFactoryClass : FileFactoryClass
--- @field Instance RawFileFactoryInstance The metatable used by RawFileFactoryInstance
local STATIC = CNC.CreateExport( fileFactoryClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "RawFileFactoryClass"

--- @class RawFileFactoryInstance : FileFactoryInstance
--- @field Static RawFileFactoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_RawFileFactory : Renegade_FileFactory" )
INSTANCE.Class = "RawFileFactoryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsRawFileFactory = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class RawFileFactoryClass

    --- Creates a new RawFileFactoryInstance
    --- @return RawFileFactoryInstance
    function STATIC.New()
        return robustclass.New( "Renegade_RawFileFactory" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) RawFileFactoryInstance, `false` otherwise
    function STATIC.IsRawFileFactory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsRawFileFactory and true or false
    end

    typecheck.RegisterType( "RawFileFactoryInstance", STATIC.IsRawFileFactory )
end


--- @class RawFileFactoryInstance

function INSTANCE:GetFile()
    typecheck.NotImplementedError()
end

function INSTANCE:ReturnFile()
    typecheck.NotImplementedError()
end
