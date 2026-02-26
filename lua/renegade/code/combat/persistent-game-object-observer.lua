-- Based on PersistentGameObjObserverClass within Code/Combat/persistentgameobjobserver.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

--- @type GameObjectObserverClass
local gameObjectObserverclass = CNC.Import( "code/combat/game-object-observer.lua" )

--- @class PersistentGameObjectObserverClass : PersistClass, GameObjectObserverClass
--- @field Instance PersistentGameObjectObserverInstance The metatable used by PersistentGameObjectObserverInstance
local STATIC = CNC.CreateExport( persistClass )
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
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--#region Imported Enums
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_PLACEHOLDER = enumBuilder:Set( 0 ),
        CHUNKID_PLACEHOLDER = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class PersistentGameObjectObserverClass

    --- Creates a new PersistentGameObjectObserverInstance
    --- @vararg any
    --- @return PersistentGameObjectObserverInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_PersistentGameObjectObserver", ... )
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
--- @vararg any
function INSTANCE:Renegade_PersistentGameObjectObserver( ... )
    local args = { ... }
    local argCount = select( "#", ... )

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
