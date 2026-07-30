-- Based on GameObjObserverManager within Code/Combat/gameobjobserver.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GameObjectObserverManagerClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "GameObjectObserverManagerClass"


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum PlaceholderName
    STATIC.PLACEHOLDER_NAME = {
        PLACEHOLDER = enumBuilder:Set( 0 ),
        PLACEHOLDER = enumBuilder:Next(),
    }
    local placeholderEnum = STATIC.PLACEHOLDER_NAME
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES    = enumBuilder:Set( 918001455 ),
        MICROCHUNKID_NEXT_ID = enumBuilder:Set( 1 ),
    }
end


--- @class GameObjectObserverManagerClass

--- @type integer
STATIC.NextId = 8000000;

--- @type GameObjectObserverInstance[]
STATIC.PendingDeleteList = {}

--- @param observer GameObjectObserverInstance
function STATIC.DeleteRegister( observer )
    STATIC.PendingDeleteList[#STATIC.PendingDeleteList + 1] = observer
end


function STATIC.DeletePending()
    STATIC.PendingDeleteList = {}
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
    STATIC.NextId = 6000000
end


function STATIC.GetNextObserverId()
    STATIC.NextId = STATIC.NextId + 1
    return STATIC.NextId
end