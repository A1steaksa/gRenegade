-- Based on NetworkObjectClass within Code/wwnet/networkobject.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class NetworkObjectClass
--- @field Instance NetworkObjectInstance The metatable used by NetworkObjectInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "NetworkObjectClass"
--- @class NetworkObjectInstance
--- @field Static NetworkObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_NetworkObject" )
INSTANCE.Class = "NetworkObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsNetworkObject = true


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum PacketTier
    STATIC.PACKET_TIER_ENUM = {
        PACKET_TIER_CREATION   = enumBuilder:Set( 0 ),
        PACKET_TIER_RARE       = enumBuilder:Next(),
        PACKET_TIER_OCCASIONAL = enumBuilder:Next(),
        PACKET_TIER_FREQUENT   = enumBuilder:Next(),
        PACKET_TIER_COUNT      = enumBuilder:Next(),
    }
    local packetTierEnum = STATIC.PACKET_TIER_ENUM

    --- @enum DirtyBit
    STATIC.DIRTY_BIT = {
        BIT_FREQUENT   = 0x01,
        BIT_OCCASIONAL = -1, -- Placeholder values
        BIT_RARE       = -1,
        BIT_CREATION   = -1,
    }
    STATIC.DIRTY_BIT.BIT_FREQUENT   = 0x01
    STATIC.DIRTY_BIT.BIT_OCCASIONAL = bit.bor( 0x02, STATIC.DIRTY_BIT.BIT_FREQUENT   )
    STATIC.DIRTY_BIT.BIT_RARE       = bit.bor( 0x04, STATIC.DIRTY_BIT.BIT_OCCASIONAL )
    STATIC.DIRTY_BIT.BIT_CREATION   = bit.bor( 0x08, STATIC.DIRTY_BIT.BIT_RARE       )
    local dirtyBitEnum = STATIC.DIRTY_BIT
--#endregion


--#region Imports

    --- @type NetworkObjectManagerClass
    local networkObjectManagerClass = CNC.Import( "code/wwnet/network-object-manager.lua" )
--#endregion


--#region Imported Enums
--#endregion

--- "Per client update information.  Bandwidth will be allocated per object, per client."
--- @class PerClientUpdateInfoStruct
--- @field LastUpdateTime integer
--- @field UpdateRate integer
--- @field ClientHintCount integer

--[[ Static Functions and Variables ]] do

    --- @class NetworkObjectClass
    --- @field private IsServer boolean

    STATIC.IsServer = false

    --- Creates a new NetworkObjectInstance
    --- @return NetworkObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_NetworkObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) NetworkObjectInstance, `false` otherwise
    function STATIC.IsNetworkObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsNetworkObject and true or false
    end

    typecheck.RegisterType( "NetworkObjectInstance", STATIC.IsNetworkObject )

    --- @param isServer boolean
    function STATIC.SetIsServer( isServer )
        STATIC.IsServer = isServer
    end
end


--- @class NetworkObjectInstance
--- @field private NetworkId integer
--- @field private UpdateInfo PerClientUpdateInfoStruct[]
--- @field private ClientStatus string
--- @field private ImportStateCount integer
--- @field private LastClientsideUpdateTime number
--- @field private ClientsideUpdateFrequencySampleStartTime number
--- @field private ClientsideUpdateFrequencySampleCount integer
--- @field private ClientsideUpdateRate integer
--- @field protected _IsDeletePending boolean
--- @field private AppPacketType integer
--- @field private LastObjectIdDamaged integer
--- @field private LastObjectIdGotDamagedBy integer
--- @field private FrequentExportPacketSize integer
--- @field private CachedPriority number
--- @field private CachedPriority2 number[]
--- @field private UnreliableOverride boolean

--[[ Public Constructors/Destructors ]] do

    --- Constructs a new NetworkObjectInstance
    function INSTANCE:Renegade_NetworkObject()
        self.ImportStateCount         = 0
        self.LastClientsideUpdateTime = 0
        self.NetworkId                = 0
        self._IsDeletePending          = false
        self.CachedPriority           = 0
        self.UnreliableOverride       = false
        self.AppPacketType            = 0
        self.FrequentExportPacketSize = 0
        self.ClientsideUpdateFrequencySampleStartTime = CurTime()
        self.ClientsideUpdateFrequencySampleCount     = 0
        self.ClientsideUpdateRate     = 0
        self.LastObjectIdDamaged      = -1
        self.LastObjectIdGotDamagedBy = -1

        if STATIC.IsServer then
            -- "
            -- Assign the object a unique ID.  This will happen on the client too during object
            -- imports, but will be corrected immediately with an explicit [SetNetworkId] call.
            -- "
            local newId = networkObjectManagerClass.GetNewDynamicId();
            self:SetNetworkId( newId )
        end

        -- "  
        -- By default, objects have the modification dirty bit set.  
        -- Static objects therefore don't need to remember to set this in their constructor.  
        -- Game objects will set BIT_CREATION  
        -- "
        self:ClearObjectDirtyBits()
    end

    function INSTANCE:_delete()
        typecheck.NotImplementedError()
    end
end

--[[ ID Support ]] do

    --- @return integer
    function INSTANCE:GetNetworkId()
        return self.NetworkId
    end

    --- @param id integer
    function INSTANCE:SetNetworkId( id )
        -- "Remove the object from the manager, change it's ID, and re-insert it."
        networkObjectManagerClass.UnregisterObject( self )
        self.NetworkId = id
        networkObjectManagerClass.RegisterObject( self )
    end
end


--[[ Class ID support ]] do
end


--[[ Server-to-client Data Importing/Exporting ]] do

    --- @param packet string
    function INSTANCE:ImportCreation( packet )
    end

    --- @param packet string
    function INSTANCE:ImportRare( packet )
    end

    --- @param packet string
    function INSTANCE:ImportOccasional( packet )
    end

    --- @param packet string
    function INSTANCE:ImportFrequent( packet )
    end

    --- @param packet string
    function INSTANCE:ExportCreation( packet )
    end

    --- @param packet string
    function INSTANCE:ExportRare( packet )
    end

    --- @param packet string
    function INSTANCE:ExportOccasional( packet )
    end

    --- @param packet string
    function INSTANCE:ExportFrequent( packet )
    end
end


--[[ Timestep Support ]] do

    function INSTANCE:NetworkThink()
    end
end


--[[ Delete Support ]] do

    --- @return boolean
    function INSTANCE:IsDeletePending()
        return self._IsDeletePending
    end

    function INSTANCE:SetDeletePending()
        self._IsDeletePending = true
        networkObjectManagerClass.RegisterObject( self )
    end

    --- "Override Delete in the subclass if you have a destructor there"
    function INSTANCE:Delete()
    end
end


--[[ Record Application Packet Type ]] do

    --- @param type integer
    function INSTANCE:SetAppPacketType( type )
        self.AppPacketType = type
    end

    --- @return integer
    function INSTANCE:GetAppPacketType()
        return self.AppPacketType
    end
end


--[[ Dirty Bit Support ]] do

    --- @overload fun( self: NetworkObjectInstance, dirtyBit: DirtyBit, bitState: boolean )
    --- @param clientId integer
    --- @param dirtyBit DirtyBit
    --- @param bitState boolean
    function INSTANCE:SetObjectDirtyBit( clientId, dirtyBit, bitState )
        typecheck.NotImplementedError()
    end

    function INSTANCE:ClearObjectDirtyBits()
        typecheck.NotImplementedError()
    end

    --- @param clientId integer
    --- @param dirtyBit DirtyBit
    --- @return boolean
    function INSTANCE:GetObjectDirtyBit( clientId, dirtyBit )
        typecheck.NotImplementedError()
    end

    --- @param clientId integer
    --- @return integer
    function INSTANCE:GetObjectDirtyBits( clientId )
        typecheck.NotImplementedError()
    end

    --- @param clientId integer
    --- @param bits integer
    function INSTANCE:SetObjectDirtyBits( clientId, bits )
        typecheck.NotImplementedError()
    end

    --- @param clientId integer
    --- @return boolean
    function INSTANCE:IsClientDirty( clientId )
        typecheck.NotImplementedError()
    end

    --- @param clientId integer
    --- @param dirtyBit DirtyBit
    --- @return boolean    
    function INSTANCE:GetObjectDirtyBit2( clientId, dirtyBit )
        typecheck.NotImplementedError()
    end

    --- @param clientId integer
    --- @return integer
    function INSTANCE:GetObjectDirtyBits2( clientId )
        typecheck.NotImplementedError()
    end
end


--[[ Filtering Support ]] do
end


--[[ Client-side update tracking ]] do
end


--[[ Ownbership ]] do
end

--[[ Per Client Update Functions ]] do
end
