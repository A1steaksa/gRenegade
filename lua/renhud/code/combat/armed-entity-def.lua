-- Based on ArmedGameObjDef within Code/Combat/armedgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type PhysicalEntityDefClass
local PARENT = CNC.Import( "code/combat/physical-entity-def.lua" )

--- @class ArmedEntityDefClass : PhysicalEntityDefClass
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "ArmedEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class ArmedEntityDefInstance : PhysicalEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_ArmedEntityDefClass : Renegade_PhysicalEntityDefClass" )
INSTANCE.Class = "ArmedEntityDefInstance"
INSTANCE.IsArmedEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--#region Imports

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_DEF_PARENT                                  = enumBuilder:Set( 418001829 ),
        CHUNKID_DEF_VARIABLES                               = enumBuilder:Next(),

        MICROCHUNKID_DEF_WEAPON_TILT_RATE                   = enumBuilder:Set( 1 ),
        MICROCHUNKID_DEF_WEAPON_TILT_MIN                    = enumBuilder:Next(),
        MICROCHUNKID_DEF_WEAPON_TILT_MAX                    = enumBuilder:Next(),
        MICROCHUNKID_DEF_WEAPON_TURN_RATE                   = enumBuilder:Next(),
        MICROCHUNKID_DEF_WEAPON_TURN_MIN                    = enumBuilder:Next(),
        MICROCHUNKID_DEF_WEAPON_TURN_MAX                    = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_PRIMARY_ROUNDS                  = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_PRIMARY_AMMO_WEAPON_DEF_ID      = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_SECONDARY_AMMO_WEAPON_DEF_ID    = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_SECONDARY_ROUNDS                = enumBuilder:Next(),
        MICROCHUNKID_DEF_WEAPON_DEF_ID                      = enumBuilder:Next(),
        MICROCHUNKID_DEF_WEAPON_ROUNDS                      = enumBuilder:Next(),
        MICROCHUNKID_DEF_WEAPON_ERROR                       = enumBuilder:Next(),
        MICROCHUNKID_DEF_SECONDARY_WEAPON_DEF_ID            = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class ArmedEntityDefClass

    --- Creates a new ArmedEntityDefClass
    --- @vararg any
    --- @return ArmedEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ArmedEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ArmedEntityDefInstance, `false` otherwise
    function STATIC.IsArmedEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsArmedEntityDefClass and true or false
    end

    typecheck.RegisterType( "ArmedEntityDefInstance", STATIC.IsArmedEntityDefClass )
end


--- @class ArmedEntityDefInstance
--- @field WeaponTiltRate number
--- @field WeaponTiltMin number
--- @field WeaponTiltMax number
--- @field WeaponTurnRate number
--- @field WeaponTurnMin number
--- @field WeaponTurnMax number
--- @field WeaponError number
--- @field WeaponDefId integer
--- @field SecondaryWeaponDefId integer
--- @field WeaponRounds integer

--- Constructs a new ArmedEntityDefInstance
function INSTANCE:Renegade_ArmedEntityDefClass()
    self.WeaponTiltRate = 1
    self.WeaponTiltMin = -10000.0
    self.WeaponTiltMax =  10000.0
    self.WeaponTurnRate = 1
    self.WeaponTurnMin = -10000.0
    self.WeaponTurnMax =  10000.0
    self.WeaponError = 0
    self.WeaponDefId = 0
    self.SecondaryWeaponDefId = 0
    self.WeaponRounds = -1
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )
    local ids = STATIC.ChunkIds
    local dataTypeEnum = STATIC.DATA_TYPE

    Section.Start( "Loading " .. INSTANCE.Class )

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == STATIC.ChunkIds.CHUNKID_DEF_PARENT then
            PARENT.Instance.Load( self, cload )
        elseif chunkId == STATIC.ChunkIds.CHUNKID_DEF_VARIABLES then
            Section.Start( INSTANCE.Class .. " Variables Start" )

            while cload:OpenMicroChunk() do
                local didRead =
                    self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_WEAPON_TILT_RATE, dataTypeEnum.Float, "WeaponTiltRate" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_WEAPON_TILT_MIN, dataTypeEnum.Float, "WeaponTiltMin" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_WEAPON_TILT_MAX, dataTypeEnum.Float, "WeaponTiltMax" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_WEAPON_TURN_RATE, dataTypeEnum.Float, "WeaponTurnRate" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_WEAPON_TURN_MIN, dataTypeEnum.Float, "WeaponTurnMin" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_WEAPON_TURN_MAX, dataTypeEnum.Float, "WeaponTurnMax" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_WEAPON_DEF_ID, dataTypeEnum.Int, "WeaponDefID" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SECONDARY_WEAPON_DEF_ID, dataTypeEnum.Int, "SecondaryWeaponDefID" )
                    or self:ReadSafeMicroChunk( cload, ids.MICROCHUNKID_DEF_WEAPON_ROUNDS, dataTypeEnum.Int, "WeaponRounds" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_WEAPON_ERROR, dataTypeEnum.Float, "WeaponError" )

                if not didRead then
                    Section.Print( "Unrecognized ", INSTANCE.Class, " Variable Chunk ID", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end

            Section.End()
        else
            Section.Print( "Unrecognized ", INSTANCE.Class, " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    Section.End()

    return true
end