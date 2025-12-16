-- Based on VehicleGameObjDef within Code/Combat/vehicle.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SmartEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/smart-entity-def.lua" )

--- @class VehicleEntityDefClass : SmartEntityDefClass
local STATIC = CNC.CreateExport( PARENT )
local CLASS = "VehicleEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class VehicleEntityDefInstance : SmartEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_VehicleEntityDefClass : Renegade_SmartEntityDefClass" )
INSTANCE.IsVehicleEntityDefInstance = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC

--#region Imports

    --- @type VehicleEntityClass
    local vehicleEntClass = CNC.Import( "entities/ren_vehicle-entity/shared.lua" )
--#endregion


--#region Imported Enums

    local vehicleTypeEnum = vehicleEntClass.VEHICLE_TYPE
    local engineSoundStateEnum = vehicleEntClass.ENGINE_SOUND_STATE
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class VehicleEntityDefClass
    --- @field protected DefaultDriverIsGunner boolean
    --- @field protected CameraLockedToTurret boolean

    --- Creates a new VehicleEntityDefInstance
    --- @vararg any
    --- @return VehicleEntityDefInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_VehicleEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) VehicleEntityDefInstance, `false` otherwise
    function STATIC.IsVehicleEntityDefInstance( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsVehicleEntityDefInstance and true or false
    end

    typecheck.RegisterType( "VehicleEntityDefInstance", STATIC.IsVehicleEntityDefInstance )
end

--- @class VehicleEntityDefInstance
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

--- Constructs a new VehicleEntityDefInstance
function INSTANCE:Renegade_VehicleEntityDefClass()
    print( "Vehicle Entity Definition Constructor" )

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

--- @return integer
function INSTANCE:GetClassId()
    -- Only used by the Sakura boss fight?
    typecheck.NotImplementedError()
end

--- @return VehicleEntityInstance
function INSTANCE:Create()
    local ent = vehicleEntClass.New()
    ent:Init( self )
    return ent
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
