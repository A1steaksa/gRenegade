-- Based on VehicleGameObj within Code/Combat/vehicle.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class VehicleEntityClass : SmartEntityClass
local STATIC = CNC.CreateExport()
STATIC.Class = "VehicleEntityClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class VehicleEntityInstance : SmartEntityInstance
--- @field BaseClass SmartEntityInstance
local ENT = ENT --[[@as SmartEntityInstance]]
ENT.Class = "VehicleEntityInstance"


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum VehicleType
    STATIC.VEHICLE_TYPE = {
        Car     = enumBuilder:Set( 0 ),
        Tank    = enumBuilder:Next(),
        Bike    = enumBuilder:Next(),
        Flying  = enumBuilder:Next(),
        Turret  = enumBuilder:Next()
    }
    local vehicleTypeEnum = STATIC.VEHICLE_TYPE

    --- @enum EngineSoundState
    STATIC.ENGINE_SOUND_STATE = {
        Starting = enumBuilder:Set( 0 ),
        Running  = enumBuilder:Next(),
        Stopping = enumBuilder:Next(),
        Off      = enumBuilder:Next()
    }
    local engineSoundStateEnum = STATIC.ENGINE_SOUND_STATE

    --- @enum Seat
    STATIC.SEAT = {
        Driver = enumBuilder:Set( 0 ),
        Gunner = enumBuilder:Next()
    }
    local seatEnum = STATIC.SEAT
--#endregion


--#region Imports

    --- @type QuaternionClass
    local quaternionClass = CNC.Import( "renhud/code/wwmath/quaternion.lua" )

    --- @type WWMathClass
    local wwmath = CNC.Import( "renhud/code/wwmath/wwmath.lua" )

    --- @type VehicleEntityDefClass
    local vehicleEntityDefClass = CNC.Import( "renhud/code/combat/vehicle-entity-def.lua" )

    --- @type Matrix3dClass
    local matrix3dClass = CNC.Import( "renhud/code/wwmath/matrix3d.lua" )
--#endregion


--[[ Garry's Mod Entity Setup ]] do

    ENT.Type = "anim"
    ENT.Base = "ren_smart-entity"
    ENT.Author = "A1steaksa"
    ENT.Category = "C&C Renegade"
    ENT.Spawnable = false
end

local BaseClass = baseclass.Get( ENT.Base ) --[[@as SmartEntityInstance]]

--[[ Class Statics ]] do

    --- @class VehicleEntityClass
    --- @field protected DefaultDriverIsGunner boolean
    --- @field protected CameraLockedToTurret boolean

    STATIC.DefaultDriverIsGunner = true
    STATIC.CameraLockedToTurret = false
    STATIC.UseTargetSteering = false

    --- @return boolean
    function STATIC.ToggleTargetSteering()
        STATIC.UseTargetSteering = not STATIC.UseTargetSteering
        return STATIC.UseTargetSteering
    end

    --- @param isTargetSteering boolean
    function STATIC.SetTargetSteering( isTargetSteering )
        STATIC.UseTargetSteering = isTargetSteering
    end

    --- @return boolean
    function STATIC.IsTargetSteering()
        return STATIC.UseTargetSteering
    end
end

--- @class VehicleEntityInstance
--- @field protected EngineSoundState EngineSoundState
--- @field protected TurretBone integer
--- @field protected BarrelBone integer
--- @field protected TurretTurn number
--- @field protected BarrelTilt number
--- @field protected BarrelOffset number
--- @field protected TransitionsEnabled boolean
--- @field protected HasEnterTransitions boolean
--- @field protected HasExitTransitions boolean
--- @field protected VehicleDelivered boolean
--- @field protected DriverIsGunner boolean
--- @field protected OccupiedSeats integer
--- @field protected SeatOccupants Entity[]
--- @field protected TransitionInstances TransitionInstance[]
--- @field protected LockOwner Entity "Who owns the lock for this vehicle?"
--- @field protected LockTimer number

function ENT:RenConstructor()
    BaseClass.RenConstructor( self )

    self.TurretBone = 0
    self.BarrelBone = 0
    self.TurretTurn = 0
    self.BarrelTilt = 0
    self.BarrelOffset = 0
    self.Sound = NULL
    self.EngineSoundState = engineSoundStateEnum.Off
    self.CachedEngineSound = NULL
    self.WheelSurfaceSound = NULL
    self.TransitionEnabled = true
    self.OccupiedSeats = 0
    self.HasEnterTransitions = false
    self.HasExitTransitions = false
    self.VehicleDelivered = false
    self.LockTimer = 0
    self.DriverIsGunner = STATIC.DefaultDriverIsGunner
    -- Omitted setting app packet type
end

--[[ Definitions ]] do

    --- @param definition VehicleEntityDefInstance?
    function ENT:Init( definition )
        --- @cast definition VehicleEntityDefInstance
        BaseClass.Init( self, definition )

        self.DriverIsGunner = STATIC.DefaultDriverIsGunner
        if not definition then return end

        self:AcquireTurretBones()
        -- self:InitWheelEffects()
        -- self:CreateAndDestroyTransitions()
        -- self:UpdateDamageMeshes()

        -- Omitted setting the app packet type for turrets
    end


end


function ENT:RenThink()

    -- self:ApplyControls()
    -- self:UpdateTransitions()

    BaseClass.RenThink( self ) -- "Perform smart object thinking"

    -- self:UpdateSoundEffects()
    -- self:UpdateWheelEffects()

    -- "Update the lock status"
    -- if self.LockTimer > 0 then
    --     self.LockTimer = self.LockTimer - FrameTime()
    -- else
    --     self.LockOwner = NULL
    -- end

    -- "Unstealth if we don't have any occupants, and we aren't in single play"
    -- if self.StealthEffect then
    --     if self:GetOccupantCount() == 0 and not IS_MISSION then
    --         self.StealthEffect:EnableStealth( false )
    --     end
    -- end
end

function ENT:AcquireTurretBones()
    if self.TurretBone == 0 then
        self.TurretBone = self:LookupBone( "turret" ) or 0
        -- Omitted bone capture
    end

    self.BarrelOffset = 0

    if self.BarrelBone == 0 then
        self.BarrelBone = self:LookupBone( "barrel" ) or 0
        -- Omitted bone capture

        -- "Find the barrel in turret space"
        if self.TurretBone ~= 0 then
            local turretBase = self:GetBoneTransform( self.TurretBone )
            local barrelPos = self:GetBoneTransform( self.BarrelBone ):GetTranslation()
            local turretSpaceBarrel = matrix3dClass.InverseTransformVector( turretBase, barrelPos )
            self.BarrelOffset = turretSpaceBarrel.y
            if math.abs( self.BarrelOffset ) < 0.1 then
                self.BarrelOffset = 0
            end
        end
    end
end

--- @param weaponTurn number
--- @param weaponTilt number
function ENT:UpdateTurret( weaponTurn, weaponTilt )
    if self.TurretBone ~= 0 then
        local facing = matrix3dClass.New( true )
        facing:RotateZ( weaponTurn )

        if self.BarrelBone == 0 then -- "If no barrel bone"
            facing:RotateY( -weaponTilt ) -- "Neg rotate y tilts up"
        end

        self:ControlBone( self.TurretBone, facing )
    end

    if self.BarrelBone ~= 0 then
        local facing = matrix3dClass.New( true )
        facing:RotateY( -weaponTilt ) -- "Neg rotate y tilts up"
        self:ControlBone( self.BarrelBone, facing )
    end
end


--- @param targetPos Vector
--- @param doTilt boolean
--- @return boolean
function ENT:SetTargeting( targetPos, doTilt )
    local ready = true

    BaseClass.SetTargeting( self, targetPos )

    -- "Find the desired turret tilt and turn"
    local relativeTurn = 0
    local relativeTilt = 0

    if self.TurretBone ~= 0 then
        -- "Find the target pos in turret space"
        local turretBase = self:GetBoneTransform( self.TurretBone )
        local turretSpaceTarget = matrix3dClass.InverseTransformVector( turretBase, targetPos )

        -- "Set the tilt and turn"
        relativeTurn = wwmath.Atan2( turretSpaceTarget.y, turretSpaceTarget.x )

        if self.BarrelOffset then
            turretSpaceTarget.z = 0

            local barrelOffsetAngle = wwmath.Atan2( self.BarrelOffset, turretSpaceTarget:Length() )
            relativeTurn = relativeTurn - barrelOffsetAngle
        end
    end

    if math.abs( relativeTurn ) < math.rad( 80 ) then
        if self.BarrelBone ~= 0 then
            -- "Find the target pos in barrel space"
            local barrelBase = self:GetBoneTransform( self.BarrelBone )
            local barrelSpaceTarget = matrix3dClass.InverseTransformVector( barrelBase, targetPos )

            local dist = barrelSpaceTarget:Length()
            if dist then
                -- "Only tilt when the turn is within 80 deg"
                relativeTilt = math.asin( barrelSpaceTarget.z / dist )
            end
        end
    end

    local definition = self:GetDefinition()
    local frameTime = FrameTime()

    -- "Move the tilt and turn towards the desired, following rates and limits"
    local maxMove = definition.WeaponTurnRate * frameTime
    if definition.WeaponTurnRate < math.rad( 1000 ) then
        self.TurretTurn = self.TurretTurn + math.Clamp( relativeTurn, -maxMove, maxMove )

        -- If we wanted to move further than we were able to, we must not be finished pointing at our target
        if math.abs( relativeTurn ) > math.abs( maxMove ) then
            ready = false
        end
    else
        self.TurretTurn = self.TurretTurn + relativeTurn
    end
    self.TurretTurn = math.Clamp( self.TurretTurn, definition.WeaponTurnMin, definition.WeaponTurnMax )
    maxMove = definition.WeaponTiltRate * frameTime
    if doTilt then
        if definition.WeaponTiltRate < math.rad( 1000 ) then
            self.BarrelTilt = self.BarrelTilt + math.Clamp( relativeTilt, -maxMove, maxMove )
            if math.abs( relativeTilt ) > math.abs( maxMove ) then
                ready = false
            end
        else
            self.BarrelTilt = self.BarrelTilt + relativeTilt
        end
    end
    self.BarrelTilt = math.Clamp( self.BarrelTilt, definition.WeaponTiltMin, definition.WeaponTiltMax )

    -- "Apply the turn and tilt to the bones"
    self:UpdateTurret( self.TurretTurn, self.BarrelTilt )

    -- "If a fast turner and had to turn, do it again, just to make sure (trying to fix obelisk)"
    if definition.WeaponTurnRate > math.rad( 1000 ) and
        ( math.abs( relativeTurn ) >= math.rad( 2 ) or math.abs( relativeTilt ) > math.rad( 2 ) ) then

        STATIC.SetTargetingRecurseCount = STATIC.SetTargetingRecurseCount or 0
        if STATIC.SetTargetingRecurseCount < 3 then
            STATIC.SetTargetingRecurseCount = STATIC.SetTargetingRecurseCount + 1
            self:SetTargeting( targetPos, doTilt ) -- "Recurse"
            STATIC.SetTargetingRecurseCount = STATIC.SetTargetingRecurseCount - 1
        end
        ready = true
    end

    return ready
end

--- @return VehicleEntityDefInstance
function ENT:GetDefinition()
    return BaseClass.GetDefinition( self ) --[[@as VehicleEntityDefInstance]]
end