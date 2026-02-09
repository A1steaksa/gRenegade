-- Based on PhysicalGameObj within Code/Combat/physicalgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class PhysicalEntityClass
local STATIC = CNC.CreateExport()

--- @class PhysicalEntityInstance : DamageableEntityInstance
--- @field BaseClass Entity
local ENT = ENT --[[@as Entity]]


--#region Imports

    --- @type QuaternionClass
    local quaternionClass = CNC.Import( "code/wwmath/quaternion.lua" )

    --- @type PhysicalEntityDefClass
    local physicalEntityDefClass = CNC.Import( "code/combat/physical-entity-def.lua" )
--#endregion


--[[ Garry's Mod Entity Setup ]] do

    ENT.Type = "anim"
    ENT.Base = "ren_damageable-entity"
end

local BaseClass = baseclass.Get( ENT.Base ) --[[@as DamageableEntityInstance]]

--- @class PhysicalEntityInstance

--[[ Definitions ]] do

    --- The Renegade Entity Init function
    --- @param definition PhysicalEntityDefInstance
    function ENT:Init( definition )
        BaseClass.Init( self, definition )
    end

    --- @param definition PhysicalEntityDefInstance
    function ENT:Reinit( definition )
        typecheck.NotImplementedError()
    end

    --- @return PhysicalEntityDefInstance
    function ENT:GetDefinition()
        return self.Definition --[[@as PhysicalEntityDefInstance]]
    end
end

--- Omitted bone capture functions as bone capture is not needed in Source

--- Originally from RenderObjClass (or htree?)
--- @param boneId integer
--- @return Matrix3dInstance
function ENT:GetBoneTransform( boneId )
    local bonePos, boneAng = self:GetBonePosition( boneId )

    local q = quaternionClass.New()
    q:FromEuler(
        math.rad( boneAng.pitch ),
        math.rad( boneAng.yaw   ),
        math.rad( boneAng.roll  )
    )

    local matrix = quaternionClass.BuildMatrix3d( q )
    matrix:SetTranslation( bonePos )

    return matrix
end

--- Originally from RenderObjClass (or htree?)
--- @param boneId integer
--- @param matrix Matrix3dInstance
--- @param isWorldSpaceTranslation boolean? [Default: false]
function ENT:ControlBone( boneId, matrix, isWorldSpaceTranslation )
    if isWorldSpaceTranslation == nil then isWorldSpaceTranslation = false end

    --- Omitted world space translation handling

    local q = quaternionClass.BuildQuaternion( matrix )

    local pitch, yaw, roll = q:ToEuler()
    pitch = math.deg( pitch )
    yaw   = math.deg( yaw   )
    roll  = math.deg( roll  )

    self:ManipulateBoneAngles( boneId, Angle( pitch, yaw, roll ), false )
    self:ManipulateBonePosition( boneId, matrix:GetTranslation(), false )
end