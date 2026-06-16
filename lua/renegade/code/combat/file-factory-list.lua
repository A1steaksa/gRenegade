-- Based on FileFactoryListClass within Code/Combat/ffactorylist.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type FileFactoryClass
local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

--- @class FileFactoryListClass : FileFactoryClass
--- @field Instance FileFactoryListInstance The metatable used by FileFactoryListInstance
local STATIC = CNC.CreateExport( fileFactoryClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "FileFactoryListClass"

--- @class FileFactoryListInstance : FileFactoryInstance
--- @field Static FileFactoryListClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_FileFactoryList : Renegade_FileFactory" )
INSTANCE.Class = "FileFactoryListInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsFileFactoryList = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class FileFactoryListClass
    --- @field TheInstance FileFactoryListInstance

    --- Creates a new FileFactoryListInstance
    --- @return FileFactoryListInstance
    function STATIC.New()
        return robustclass.New( "Renegade_FileFactoryList" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) FileFactoryListInstance, `false` otherwise
    function STATIC.IsFileFactoryList( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsFileFactoryList and true or false
    end

    typecheck.RegisterType( "FileFactoryListInstance", STATIC.IsFileFactoryList )

    function STATIC.GetInstance()
        return STATIC.TheInstance
    end
end


--- @class FileFactoryListInstance
--- @field TempFactory FileFactoryInstance
--- @field FactoryList FileFactoryInstance[]
--- @field FactoryNameList string[]
--- @field SearchStartIndex integer

function INSTANCE:Renegade_FileFactoryList()
    fileFactoryClass.Instance.Renegade_FileFactory( self )

    self.FactoryList = {}
    self.FactoryNameList = {}
end

function INSTANCE:_Renegade_FileFactoryList()
    typecheck.NotImplementedError()
end

--- @param factory FileFactoryInstance
--- @param name string
function INSTANCE:AddFileFactory( factory, name )
    self.FactoryList[#self.FactoryList + 1] = factory
    self.FactoryNameList[#self.FactoryNameList+1] = name
    self:ResetSearchStart()
end

function INSTANCE:RemoveFileFactory()
    typecheck.NotImplementedError()
end

function INSTANCE:SetSearchStart()
    typecheck.NotImplementedError()
end

function INSTANCE:ResetSearchStart()
    self.SearchStartIndex = 1
end

function INSTANCE:AddTempFileFactory()
    typecheck.NotImplementedError()
end

function INSTANCE:RemoveTempFileFactory()
    typecheck.NotImplementedError()
end

--- @return FileFactoryInstance
function INSTANCE:PeekTempFileFactory()
    return self.TempFactory
end

--- @param fileName string
--- @return FileInstance?
function INSTANCE:GetFile( fileName )
    -- "Very kludgly..."

    -- "Then the temp factory"
    if self.TempFactory then
        local file = self.TempFactory:GetFile( fileName )
        if file:IsAvailable() then
            return file
        else
            self.TempFactory:ReturnFile( file )
        end
    end

    -- "Try the first in the list..."
    if self.SearchStartIndex < ( #self.FactoryList + 1 ) then
        local file = self.FactoryList[self.SearchStartIndex]:GetFile( fileName )
        if file ~= nil then
            if file:IsAvailable() then
                return file
            else
                self.FactoryList[self.SearchStartIndex]:ReturnFile( file )
            end
        end
    end

    -- "Then try the rest"
    for factoryIndex = 1, #self.FactoryList do
        if factoryIndex ~= self.SearchStartIndex then
            local file = self.FactoryList[factoryIndex]:GetFile( fileName )
            if file ~= nil then
                if file:IsAvailable() then
                    return file
                else
                    self.FactoryList[factoryIndex]:ReturnFile( file )
                end
            end
        end
    end

    -- "Failed!"

    -- "Just use the first and don't check for available"
    if #self.FactoryList > 0 then
        local file = self.FactoryList[1]:GetFile( fileName )
        if file ~= nil then
            return file
        end
    end

    return nil
end

--- @param file FileInstance
function INSTANCE:ReturnFile( file )
    -- "This is kinda bad.  Just return it to the first one.  (Since they all do the same thing)"
    self.FactoryList[1]:ReturnFile( file )
end

function INSTANCE:GetFactoryCount()
    return #self.FactoryList
end

--- @param index integer
--- @return FileFactoryInstance
function INSTANCE:GetFactory( index )
    return self.FactoryList[index]
end
