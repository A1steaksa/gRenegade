-- Based on NetworkObjectMgrClass within Code/wwnet/networkobjectmgr.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class NetworkObjectManagerClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "NetworkObjectManagerClass"

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


--- @class NetworkObjectManagerClass
--- @field private ObjectList NetworkObjectInstance[]
--- @field private DeletePendingList NetworkObjectInstance[]
--- @field private NewDynamicId integer
--- @field private NewClientId integer
--- @field private IsLevelLoading boolean


STATIC.NETID_DYNAMIC_OBJECT_MIN = 1500000000 -- "600M dynamic"
STATIC.NETID_DYNAMIC_OBJECT_MAX = 2100000000
STATIC.NETID_STATIC_OBJECT_MIN  = 2100000001 -- "10M static"
STATIC.NETID_STATIC_OBJECT_MAX  = 2110000000
STATIC.NETID_CLIENT_OBJECT_MIN  = 2110000001 -- "100k per client, 128 clients"
STATIC.NETID_CLIENT_OBJECT_MAX  = 2122800001


STATIC.ObjectList        = {}
STATIC.DeletePendingList = {}
STATIC.NewDynamicId      = STATIC.NETID_DYNAMIC_OBJECT_MIN
STATIC.NewClientId       = 0
STATIC.IsLevelLoading    = false

--[[ Object Registration ]] do

    --- @param object NetworkObjectInstance
    function STATIC.RegisterObject( object )
        local objectId = object:GetNetworkId()
        if objectId ~= 0 then
            STATIC.ObjectList[objectId] = object
        end
    end

    --- @param object NetworkObjectInstance
    function STATIC.UnregisterObject( object )
        local objectId = object:GetNetworkId()
        if objectId ~= 0 then
            STATIC.ObjectList[objectId] = nil
        end
    end
end


--[[ Delete Registration Support ]] do
end


--[[ Timestep ]] do
end


--[[ Deletion Support ]] do

    function STATIC.SetAllDeletePending()
        typecheck.NotImplementedError()
    end

    function STATIC.DeletePending()
        typecheck.NotImplementedError()
    end

    --- @param clientId integer
    function STATIC.DeleteClientObjects( clientId )
        typecheck.NotImplementedError()
    end

    --- @param clientId integer
    function STATIC.RestoreDirtyBits( clientId )
        typecheck.NotImplementedError()
    end
end


--[[ Object Enumeration ]] do
end


--[[ Object Lookup ]] do

    --- @param objectId integer
    function STATIC.FindObject( objectId )
        return STATIC.NewDynamicId[objectId]
    end
end


--[[ ID Access ]] do

    --- @return integer
    function STATIC.GetNewDynamicId()
        local object = STATIC.FindObject( STATIC.NewDynamicId )
        while object ~= nil do
            STATIC.NewDynamicId = STATIC.NewDynamicId + 1
            object = STATIC.FindObject( STATIC.NewDynamicId )
        end

        return STATIC.NewDynamicId
    end

end

