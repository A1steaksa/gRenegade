-- Based on PersistentGameObjObserverClass within Code/Combat/persistentgameobjobserver.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

--- @type GameObjectObserverClass
local gameObjectObserverclass = CNC.Import( "code/combat/game-object-observer.lua" )

--- @class PersistentGameObjectObserverClass : PersistClass, GameObjectObserverClass
--- @field Instance PersistentGameObjectObserverInstance The metatable used by PersistentGameObjectObserverInstance
local STATIC = CNC.CreateExport( persistClass, gameObjectObserverclass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PersistentGameObjectObserverClass"
--- @class PersistentGameObjectObserverInstance : PersistInstance, GameObjectObserverInstance
--- @field Static PersistentGameObjectObserverClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PersistentGameObjectObserver : Renegade_Persist, Renegade_GameObjectObserver" )
INSTANCE.Class = "PersistentGameObjectObserverInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPersistentGameObjectObserver = true


--#region Imports

    --- @type PersistentGameObjectObserverManagerClass
    local persistentGameObjectObserverManagerClass = CNC.Import( "code/combat/persistent-game-object-observer-manager.lua" )

    --- @type GameObjectObserverManagerClass
    local gameObjectObserverManagerClass = CNC.Import( "code/combat/game-object-observer-manager.lua" )
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--#region Imported Enums
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_PARENT = enumBuilder:Set( 411001149 ),
        CHUNKID_VARIABLES = enumBuilder:Next(),

        MICROCHUNKID_OBSERVER_PTR = enumBuilder:Set( 1 ),
        MICROCHUNKID_OBSERVER_ID = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class PersistentGameObjectObserverClass

    --- Creates a new PersistentGameObjectObserverInstance
    --- @return PersistentGameObjectObserverInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PersistentGameObjectObserver" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PersistentGameObjectObserverInstance, `false` otherwise
    function STATIC.IsPersistentGameObjectObserver( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPersistentGameObjectObserver and true or false
    end

    typecheck.RegisterType( "PersistentGameObjectObserverInstance", STATIC.IsPersistentGameObjectObserver )
end


--- @class PersistentGameObjectObserverInstance

--- Constructs a new PersistentGameObjectObserverInstance
function INSTANCE:Renegade_PersistentGameObjectObserver()
    self:SetId( gameObjectObserverManagerClass.GetNextObserverId() )
    persistentGameObjectObserverManagerClass.Add( self )
end

function INSTANCE:__delete()
    persistentGameObjectObserverManagerClass.Remove( self )
end


--[[ Save / Load ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:Load( cload )
        typecheck.NotImplementedError()
    end
end
