-- Based on VehicleGameObjDef within Code/Combat/vehicle.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SmartGameObjectDefinitionClass
local PARENT = CNC.Import( "code/combat/smart-game-object-definition.lua" )

--- @class VehicleGameObjectDefinitionClass : SmartGameObjectDefinitionClass
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "VehicleGameObjectDefinitionClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class VehicleGameObjectDefinitionInstance : SmartGameObjectDefinitionInstance
local INSTANCE = robustclass.Register( "Renegade_VehicleGameObjectDefinition : Renegade_SmartGameObjectDefinition" )
INSTANCE.Class = "VehicleGameObjectDefinitionInstance"
INSTANCE.IsVehicleGameObjectDefinitionInstance = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC

--#region Imports

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    --- @type CombatChunkIdClass
    local combatChunkId = CNC.Import( "code/combat/combat-chunk-id.lua" )

    --- @type SimpleDefinitionFactoryClass
    local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

    --- @type SimplePersistFactoryClass
    local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

    --- @type VehicleGameObjectClass
    local vehicleEntClass = CNC.Import( "entities/ren_vehicle-entity/shared.lua" )
--#endregion


--#region Imported Enums

    local vehicleTypeEnum = vehicleEntClass.VEHICLE_TYPE
    local engineSoundStateEnum = vehicleEntClass.ENGINE_SOUND_STATE
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_DEF_PARENT                          = enumBuilder:Set( 930991656 ),
        CHUNKID_DEF_VARIABLES                       = enumBuilder:Next(),
        CHUNKID_DEF_TRANSITION                      = enumBuilder:Next(),

        MICROCHUNKID_TYPE                           = enumBuilder:Set( 1 ),
        MICROCHUNKID_TYPE_NAME                      = enumBuilder:Next(),
        MICROCHUNKID_FIRE0ANIM                      = enumBuilder:Next(),
        MICROCHUNKID_FIRE1ANIM                      = enumBuilder:Next(),
        MICROCHUNKID_PROFILE                        = enumBuilder:Next(),
        MICROCHUNKID_WEAPON_TURN_TRANS              = enumBuilder:Next(),

        XXXMICROCHUNKID_SOUND                       = enumBuilder:Next(),
        MICROCHUNKID_EMITER_NAME                    = enumBuilder:Next(),
        MICROCHUNKID_EMITER_OFFSET                  = enumBuilder:Next(),
        MICROCHUNKID_EMITER2_NAME                   = enumBuilder:Next(),
        MICROCHUNKID_EMITER2_OFFSET                 = enumBuilder:Next(),
        XXX_MICROCHUNKID_MASS                       = enumBuilder:Next(),
        XXX_MICROCHUNKID_MAX_ENGINE_TORQUE          = enumBuilder:Next(),
        XXX_MICROCHUNKID_STEERING_ANGLE             = enumBuilder:Next(),
        XXX_MICROCHUNKID_SPRING_CONSTANT            = enumBuilder:Next(),
        XXX_MICROCHUNKID_DAMPING_COEFFIENT          = enumBuilder:Next(),
        XXX_MICROCHUNKID_SPRING_LENGTH              = enumBuilder:Next(),
        MICROCHUNKID_PHYS_ID                        = enumBuilder:Next(),
        MICROCHUNKID_TURN_RADIUS                    = enumBuilder:Next(),
        MICROCHUNKID_OCCUPANTS_VISIBLE              = enumBuilder:Next(),

        XXX_MICROCHUNKID_ENGINE_SOUND_RPM_SCALE_MIN = enumBuilder:Next(),
        XXX_MICROCHUNKID_ENGINE_SOUND_RPM_SCALE_MAX = enumBuilder:Next(),
        MICROCHUNKID_ENGINE_START_SOUND             = enumBuilder:Next(),
        MICROCHUNKID_ENGINE_RUN_SOUND               = enumBuilder:Next(),
        MICROCHUNKID_ENGINE_STOP_SOUND              = enumBuilder:Next(),
        MICROCHUNKID_ENGINE_OFF_SOUND               = enumBuilder:Next(),

        MICROCHUNKID_DEF_SIGHT_DOWN_MUZZLE          = enumBuilder:Next(),
        MICROCHUNKID_DEF_AIM_2D                     = enumBuilder:Next(),

        MICROCHUNKID_DEF_SQUISH_VELOCITY            = enumBuilder:Next(),
        MICROCHUNKID_ENGINE_SOUND_MAX_PITCH_FACTOR  = enumBuilder:Next(),
        MICROCHUNKID_DEF_VEHICLE_NAME_ID            = enumBuilder:Next(),
        MICROCHUNKID_DEF_NUM_SEATS                  = enumBuilder:Next(),
        MICROCHUNKID_DEF_GDI_DAMAGE_REPORT_ID       = enumBuilder:Next(),
        MICROCHUNKID_DEF_NOD_DAMAGE_REPORT_ID       = enumBuilder:Next(),
        MICROCHUNKID_DEF_GDI_DESTROY_REPORT_ID      = enumBuilder:Next(),
        MICROCHUNKID_DEF_NOD_DESTROY_REPORT_ID      = enumBuilder:Next(),
    }
end

--[[ Static Functions and Variables ]] do

    --- @class VehicleGameObjectDefinitionClass
    --- @field protected DefaultDriverIsGunner boolean
    --- @field protected CameraLockedToTurret boolean

    --- Creates a new VehicleGameObjectDefinitionInstance
    --- @vararg any
    --- @return VehicleGameObjectDefinitionInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_VehicleGameObjectDefinition", ... )
    end

    function STATIC.StaticConstructor()
        STATIC.VehicleGameObjectDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkId.CHUNKID_GAME_OBJECT_DEF_VEHICLE )
        STATIC.VehicleGameObjectDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, combatChunkId.CLASSID_GAME_OBJECT_DEF_VEHICLE, "Vehicle", nil )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) VehicleGameObjectDefinitionInstance, `false` otherwise
    function STATIC.IsVehicleGameObjectDefinitionInstance( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsVehicleGameObjectDefinitionInstance and true or false
    end

    typecheck.RegisterType( "VehicleGameObjectDefinitionInstance", STATIC.IsVehicleGameObjectDefinitionInstance )
end

--- @class VehicleGameObjectDefinitionInstance
--- @field Type VehicleType
--- @field TypeName string
--- @field Fire0Anim string
--- @field Fire1Anim string
--- @field Profile string
--- @field Transitions TRANSITION_DATA_LIST
--- @field TurnRadius number
--- @field OccupantsVisible boolean
--- @field SightDownMuzzle boolean
--- @field Aim2d boolean
--- @field EngineSoundMaxPitchFactor number
--- @field EngineSound integer[]
--- @field SquishVelocity number
--- @field VehicleNameId integer
--- @field NumSeats integer
--- @field GdiDamageReportId integer
--- @field NodDamageReportId integer
--- @field GdiDestroyReportId integer
--- @field NodDestroyReportId integer

--- Constructs a new VehicleGameObjectDefinitionInstance
function INSTANCE:Renegade_VehicleGameObjectDefinition()
    self.Type = vehicleTypeEnum.Car
    self.TurnRadius = 10.0
    self.OccupantsVisible = true
    self.EngineSoundMaxPitchFactor = 2.0
    self.SightDownMuzzle = false
    self.Aim2d = true
    self.SquishVelocity = 1.5
    self.VehicleNameId = 0
    self.NumSeats = 2
    self.GdiDamageReportId = 0
    self.NodDamageReportId = 0
    self.GdiDestroyReportId = 0
    self.NodDestroyReportId = 0

    self.EngineSound = {}

    -- "Initialize all engine sound degs to zero"
    -- for i = 0, engineSoundStateEnum do
    --     self.EngineSound[i] = 0
    -- end
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    -- Omitted freeing transition list

    section.Disable()
    section.Start( "Loading " .. INSTANCE.Class )

    local ids = STATIC.ChunkIds
    local dataTypeEnum = STATIC.DATA_TYPE

    while cload:OpenChunk() do
        local id = cload:CurChunkId()

        if id == ids.CHUNKID_DEF_PARENT then
            PARENT.Instance.Load( self, cload )

        elseif id == ids.CHUNKID_DEF_TRANSITION then
            section.Print( INSTANCE.Class .. " Transition Loading is not yet implemented" )

        elseif id == ids.CHUNKID_DEF_VARIABLES then

            while cload:OpenMicroChunk() do
                local didRead =
                    self:ReadMicroChunk( cload, ids.MICROCHUNKID_TYPE, dataTypeEnum.Int, "Type" )
                    or self:ReadMicroChunkWWString( cload, ids.MICROCHUNKID_TYPE_NAME, "TypeName" )
                    or self:ReadMicroChunkWWString( cload, ids.MICROCHUNKID_FIRE0ANIM, "Fire0Anim" )
                    or self:ReadMicroChunkWWString( cload, ids.MICROCHUNKID_FIRE1ANIM, "Fire1Anim" )
                    or self:ReadMicroChunkWWString( cload, ids.MICROCHUNKID_PROFILE, "Profile" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_PHYS_ID, dataTypeEnum.Int, "PhysDefId" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_TURN_RADIUS, dataTypeEnum.Float, "TurnRadius" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_OCCUPANTS_VISIBLE, dataTypeEnum.Boolean, "OccupantsVisible" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_ENGINE_SOUND_MAX_PITCH_FACTOR, dataTypeEnum.Float, "EngineSoundMaxPitchFactor")

                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_ENGINE_START_SOUND, dataTypeEnum.Int, "EngineSound", engineSoundStateEnum.Starting  )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_ENGINE_RUN_SOUND,   dataTypeEnum.Int, "EngineSound", engineSoundStateEnum.Running   )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_ENGINE_STOP_SOUND,  dataTypeEnum.Int, "EngineSound", engineSoundStateEnum.Stopping  )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_ENGINE_OFF_SOUND,   dataTypeEnum.Int, "EngineSound", engineSoundStateEnum.Off       )

                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SIGHT_DOWN_MUZZLE, dataTypeEnum.Boolean, "SightDownMuzzle" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_AIM_2D, dataTypeEnum.Boolean, "Aim2d" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SQUISH_VELOCITY, dataTypeEnum.Float, "SquishVelocity" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_VEHICLE_NAME_ID, dataTypeEnum.Int, "VehicleNameId" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_NUM_SEATS, dataTypeEnum.Int, "NumSeats" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_GDI_DAMAGE_REPORT_ID, dataTypeEnum.Int, "GdiDamageReportId" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_NOD_DAMAGE_REPORT_ID, dataTypeEnum.Int, "NodDamageReportId" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_GDI_DESTROY_REPORT_ID, dataTypeEnum.Int, "GdiDestroyReportId" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_NOD_DESTROY_REPORT_ID, dataTypeEnum.Int, "NodDestroyReportId" )

                if not didRead then
                    section.Print( "Unrecognized " .. INSTANCE.Class .. " Variable Chunk ID " .. tostring( cload:CurMicroChunkId() ) )
                end

                cload:CloseMicroChunk()
            end
        else
            section.Print( "Unrecognized " .. INSTANCE.Class .. " Chunk ID " .. tostring( cload:CurChunkId() ) )
        end

        cload:CloseChunk()
    end

    section.End()
    section.Enable()
    section.Print( "Loaded ", self.Name )

    return true
end

--- @return integer
function INSTANCE:GetClassId()
    -- Only used by the Sakura boss fight?
    typecheck.NotImplementedError()
end

--- @return VehicleGameObjectInstance
function INSTANCE:Create()
    typecheck.NotImplementedError()
end

--- @return PersistFactoryClass
function INSTANCE:GetFactory()
    typecheck.NotImplementedError()
end

--- @return TRANSITION_DATA_LIST
function INSTANCE:GetTransitionList()
    return self.Transitions
end

--- @param team integer
function INSTANCE:GetDamageReport( team )
    if playerTypeEnum.Gdi == team then
        return self.GdiDamageReportId
    elseif playerTypeEnum.Nod == team then
        return self.NodDamageReportId
    end

    return 0
end

--- @param team integer
function INSTANCE:GetDestroyReport( team )
    typecheck.NotImplementedError()
end
