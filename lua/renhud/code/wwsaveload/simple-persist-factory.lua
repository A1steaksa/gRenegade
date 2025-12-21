-- Based on SimplePersistFactoryClass within Code/wwsaveload/persistfactory.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistFactoryClass
local PARENT = CNC.Import( "renhud/code/wwsaveload/persist-factory.lua" )

--- @class SimplePersistFactoryClass : PersistFactoryClass
--- @field instance SimplePersistFactoryInstance The metatable used by SimplePersistFactoryInstance
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "SimplePersistFactoryClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class SimplePersistFactoryInstance : PersistFactoryInstance
--- @field Static SimplePersistFactoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SimplePersistFactory : Renegade_PersistFactory" )
INSTANCE.Class = "SimplePersistFactoryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSimplePersistFactory = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class SimplePersistFactoryClass

    --- The template data stored prior to instantiation
    --- @class SimplePersistFactoryTemplateData
    --- @field Class PersistClass
    --- @field ChunkId integer
    STATIC.TemplateData = {}

    --[[ Internal Chunk IDs ]] do

        STATIC.SIMPLEFACTORY_CHUNKID_OBJPOINTER = 0x00100100
        STATIC.SIMPLEFACTORY_CHUNKID_OBJDATA = STATIC.SIMPLEFACTORY_CHUNKID_OBJPOINTER + 1
    end

    --- Creates a new SimplePersistFactoryInstance
    --- @param class PersistClass
    --- @param chunkId integer
    --- @return SimplePersistFactoryInstance
    function STATIC.New( class, chunkId  )
        STATIC.TemplateData.Class = class
        STATIC.TemplateData.ChunkId = chunkId

        return robustclass.New( "Renegade_SimplePersistFactory" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SimplePersistFactoryInstance, `false` otherwise
    function STATIC.IsSimplePersistFactory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSimplePersistFactory and true or false
    end

    typecheck.RegisterType( "SimplePersistFactoryInstance", STATIC.IsSimplePersistFactory )
end


--- @class SimplePersistFactoryInstance
--- @field _ChunkId integer
--- @field _Class PersistClass The static for the class this factory saves and loads

--- Constructs a new SimplePersistFactoryInstance
function INSTANCE:Renegade_SimplePersistFactory()
    self._ChunkId = self._ChunkId or STATIC.TemplateData.ChunkId
    self._Class = self._Class or STATIC.TemplateData.Class
end

function INSTANCE:ChunkId()
    -- Load from the template data if it's accessed before the constructor
    if not self._ChunkId then
        self._ChunkId = STATIC.TemplateData.ChunkId
    end

    return self._ChunkId
end

--- @return PersistClass
function INSTANCE:GetClass()
    -- Load from the template data if it's accessed before the constructor
    if not self._Class then
        self._Class = STATIC.TemplateData.Class
    end

    return self._Class
end

--- @param cload ChunkLoadInstance
--- @return PersistInstance
function INSTANCE:Load( cload )
    local class = self:GetClass()
    local newObj = class.New()

    Section.Print( "Loading simple persist factory for ", self._Class.instance )

    cload:OpenChunk()
    assert( cload:CurChunkId() == STATIC.SIMPLEFACTORY_CHUNKID_OBJPOINTER )
    local oldObj = cload:Read( 4 ) -- 4 bytes for a 32 bit pointer
    cload:CloseChunk()

    cload:OpenChunk()
    assert( cload:CurChunkId() == STATIC.SIMPLEFACTORY_CHUNKID_OBJDATA )
    newObj:Load( cload )
    cload:CloseChunk()

    return newObj
end

--- @param csave ChunkSaveInstance
--- @param obj PersistInstance
function INSTANCE:Save( csave, obj )
    typecheck.NotImplementedError()
end