-- Based on GameObjManager within Code/Combat/gameobjmanager.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GameObjectManagerClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "GameObjectManagerClass"


--#region Imports

    --- @type PersistentGameObjectObserverManagerClass
    local persistentGameObjectObserverManagerClass = CNC.Import( "code/combat/persistent-game-object-observer-manager.lua" )

    --- @type NetworkObjectManagerClass
    local networkObjectManagerClass = CNC.Import( "code/wwnet/network-object-manager.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    --- @type ScriptManagerClass
    local scriptManagerClass = CNC.Import( "code/combat/script-manager-class.lua" )
--#endregion


--#region Imported Enums
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_OBJECTS   = enumBuilder:Set( 916991653 ),
        CHUNKID_VARIABLES = enumBuilder:Next(),

        MICROCHUNKID_GENERATED_ID             = enumBuilder:Set( 1 ),
        MICROCHUNKID_GLOBAL_SIGHT_RANGE_SCALE = enumBuilder:Next(),
        MICROCHUNKID_CINEMATIC_FREEZE         = enumBuilder:Next(),
    }
end


--[[
    "A collection of routines to maintain lists of game objects"

    "
    In the editor, building objects will be created and added to this manager.  In the game, they will
    be loaded.  After a level has been loaded, the 'Init_Level_Buildings' function should be called.
    This manager will be the entry point for any operations that need to happen on all existing buildings
    such as save/load, per-frame processing, etc.
    "
--]]

--- @class GameObjectManagerClass
--- @field GameObjectList BaseGameObjectInstance[] "List of all game objs"
--- @field SmartGameObjectList SmartGameObjectInstance[] "List of all smart game objs"
--- @field StarGameObjectList SoldierGameObjectInstance[] "List of all star game objs"
--- @field BuildingGameObjectList BuildingGameObjectInstance[] "List of all building game obs"
--- @field CinematicFreezeActive boolean

STATIC.GameObjectList = {}


local enumBuilder = enumBuilderClass.New()

STATIC.NETID_GDI_BASE_CONTROLLER = enumBuilder:Set( networkObjectManagerClass.NETID_STATIC_OBJECT_MIN + 1 )
STATIC.NETID_NOD_BASE_CONTROLLER = enumBuilder:Next()
STATIC.NETID_NOD_TEAM            = enumBuilder:Next()
STATIC.NETID_GDI_TEAM            = enumBuilder:Next()
STATIC.NETID_SERVER_FPS          = enumBuilder:Next()
STATIC.NETID_SERVER_WEATHER      = enumBuilder:Next()
STATIC.NETID_SERVER_BACKGROUND   = enumBuilder:Next()


function STATIC.Init()
    STATIC.DestroyAll()

    STATIC.CinematicFreezeActive = false
end

function STATIC.Shutdown()
    STATIC.DestroyAll()

    persistentGameObjectObserverManagerClass.Reset()
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


--- @return integer
function STATIC.GenerateControl()
    typecheck.NotImplementedError()
end

--- @return integer
function STATIC.Think()
    typecheck.NotImplementedError()
end

--- @return integer
function STATIC.PostThink()
    typecheck.NotImplementedError()
end

--- "This static routine destroys all objects"
function STATIC.DestroyAll()
    -- "Disable new scripts"
    scriptManagerClass.EnableScriptCreation( false )

    for _, object in ipairs( STATIC.GameObjectList ) do
        object:SetDeletePending()
    end

    networkObjectManagerClass.DeletePending()

    -- "We do it twice in case any new objects got created"
    for _, object in ipairs( STATIC.GameObjectList ) do
        object:SetDeletePending()
    end

    networkObjectManagerClass.DeletePending()

    -- "Turn it back on"
    scriptManagerClass.EnableScriptCreation( true )
end


--[[ Base Game Objects ]] do

    --- @param obj BaseGameObjectInstance
    function STATIC.Add( obj )
        -- Omitted checking for duplicate network IDs

        --[[
            "
            Cinematic scripts wanted objects not to progress on the frame they were created,
            and wanted the ability to set a frame number without [having] it bumped.
            So, make new things at the head of the list, so the oldest thinks last.
            "
        --]]
        table.insert( STATIC.GameObjectList, 0, obj )
    end

    --- @param obj BaseGameObjectInstance
    function STATIC.Remove( obj )
        table.RemoveByValue( STATIC.GameObjectList, obj )
    end

    --- @return BaseGameObjectInstance[]
    function STATIC.GetGameObjectList()
        return STATIC.GameObjectList
    end
end


--[[ Smart Game Objects ]] do

    --- @param obj SmartGameObjectInstance
    function STATIC.AddSmart( obj )
        STATIC.SmartGameObjectList[#STATIC.SmartGameObjectList + 1] = obj
    end

    --- @param obj SmartGameObjectInstance
    function STATIC.RemoveSmart( obj )
        table.RemoveByValue( STATIC.SmartGameObjectList, obj )
    end

    --- @return SmartGameObjectInstance[]
    function STATIC.GetSmaryGameObjectList()
        return STATIC.SmartGameObjectList
    end
end


--[[ Star Game Objects ]] do

    --- @param obj SoldierGameObjectInstance
    function STATIC.AddStar( obj )
        STATIC.StarGameObjectList[#STATIC.StarGameObjectList + 1] = obj
    end

    --- @param obj SoldierGameObjectInstance
    function STATIC.RemoveStar( obj )
        table.RemoveByValue( STATIC.SmartGameObjectList, obj )
    end

    --- @return SoldierGameObjectInstance[]
    function STATIC.GetStarGameObjectList()
        return STATIC.StarGameObjectList
    end
end


--[[ Building Game Objects ]] do

    function STATIC.InitBuildings()
        typecheck.NotImplementedError()
    end

    function STATIC.UpdateBuildingCollectionSphere()
        typecheck.NotImplementedError()
    end

    --- @param obj BuildingGameObjectInstance
    function STATIC.AddBuilding( obj )
        STATIC.BuildingGameObjectList[#STATIC.BuildingGameObjectList + 1] = obj
    end

    --- @param obj BuildingGameObjectInstance
    function STATIC.RemoveBuilding( obj )
        table.RemoveByValue( STATIC.BuildingGameObjectList, obj )
    end

    --- @return BuildingGameObjectInstance[]
    function STATIC.GetBuildingGameObjectList()
        return STATIC.BuildingGameObjectList
    end
end


--- @param pos Vector
--- @return boolean
function STATIC.IsInEnvironmentZone( pos )
    typecheck.NotImplementedError()
end


--[[ Find Game Objects ]] do

    --- @param clientId integer
    --- @return SoldierGameObjectInstance
    function STATIC.FindSoldierOfClientId( clientId )
        typecheck.NotImplementedError()
    end

    --- @param myId integer
    --- @return SoldierGameObjectInstance
    function STATIC.FindDifferentPlayerSoldier( myId )
        typecheck.NotImplementedError()
    end

    --- @param playerType integer
    --- @return SoldierGameObjectInstance
    function STATIC.FindSoldierOfPlayerType( playerType )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @return PhysicalGameObjectInstance
    function STATIC.FindPhysicalGameObject( id )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @return SmartGameObjectInstance
    function STATIC.FindSmartGameObject( id )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    --- @return ScriptableGameObjectInstance
    function STATIC.FindScriptableGameObject( id )
        typecheck.NotImplementedError()
    end

    --- @param soldier SoldierGameObjectInstance
    --- @return VehicleGameObjectInstance
    function STATIC.FindVehicleOccupiedBy( soldier )
        typecheck.NotImplementedError()
    end
end


--[[ Cinematic Freeze ]] do

    --- @return boolean
    function STATIC.IsCinematicFreezeActive()
        return STATIC.CinematicFreezeActive
    end

    --- @param activate boolean
    function STATIC.ActivateCinematicFreeze( activate )
        STATIC.CinematicFreezeActive = activate
    end

    function STATIC.ToggleCinematicFreeze()
        STATIC.CinematicFreezeActive = not STATIC.CinematicFreezeActive
    end
end
