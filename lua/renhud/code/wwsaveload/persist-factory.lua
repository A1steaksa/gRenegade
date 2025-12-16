-- Based on PersistClass within Code/wwsaveload/persistfactory.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class PersistFactoryClass
--- @field instance PersistFactoryInstance The metatable used by PersistFactoryInstance
local STATIC = CNC.CreateExport()
local CLASS = "PersistFactoryInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class PersistFactoryInstance
--- @field Static PersistFactoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PersistFactory" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPersistFactory = true


--#region Imports

    --- @type SaveLoadSystemClass
    local saveLoadSystemClass = CNC.Import( "renhud/code/wwsaveload/save-load.lua" )
--#endregion


--[[ Static Functions and Variables ]] do

    --- "  
    --- Create a [PersistFactoryInstance] for each concrete derived PersistClass.  These
    --- Factories automatically register with the SaveLoadSystem in their constructors and
    --- should be accessible through the virtual [GetFactory] method of any derived PrrsistClass.
    --- "  
    --- @class PersistFactoryClass

    --- Creates a new PersistFactoryInstance
    --- @return PersistFactoryInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PersistFactory" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PersistFactoryInstance, `false` otherwise
    function STATIC.IsPersistFactory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPersistFactory and true or false
    end

    typecheck.RegisterType( "PersistFactoryInstance", STATIC.IsPersistFactory )
end


--- @class PersistFactoryInstance

function INSTANCE:Renegade_PersistFactory()
    saveLoadSystemClass.RegisterPersistFactory( self )
end

function INSTANCE:__delete()
    saveLoadSystemClass.UnregisterPersistFactory( self )
end

--- @return integer
function INSTANCE:ChunkId()
    return 0
end

--- @param cload ChunkLoadInstance
--- @return DefinitionInstance
function INSTANCE:Load( cload )
end

--- @param csave ChunkSaveInstance
--- @param obj PersistInstance
function INSTANCE:Save( csave, obj )
end