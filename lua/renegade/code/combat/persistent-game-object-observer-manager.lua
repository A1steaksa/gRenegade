-- Based on PersistentGameObjObserverManager within Code/Combat/persistentgameobjobserver.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class PersistentGameObjectObserverManagerClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PersistentGameObjectObserverManagerClass"


--#region Imports

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
        CHUNKID_OBSERVERS = enumBuilder:Set( 1 ),
    }
end


--- @class PersistentGameObjectObserverManagerClass
--- @field ObserverList PersistentGameObjectObserverInstance[]

STATIC.ObserverList = {}

--- @param observer PersistentGameObjectObserverInstance
function STATIC.Add( observer )
    STATIC.ObserverList[#STATIC.ObserverList+1] = observer
end

--- @param observer PersistentGameObjectObserverInstance
function STATIC.Remove( observer )
    table.RemoveByValue( STATIC.ObserverList, observer )
end

--[[ Save / Load ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function STATIC.Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function STATIC.Load( cload )
        typecheck.NotImplementedError()
    end
end

function STATIC.Reset()
    gameObjectObserverManagerClass.DeletePending()

    -- "Delete each in the list"
    STATIC.ObserverList = {}

    gameObjectObserverManagerClass.DeletePending()
end
