-- Based on PhysicalGameObj within Code/Combat/physicalgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class PhysicalEntityClass
local STATIC = CNC.CreateExport()

--- @class PhysicalEntityInstance : Entity
--- @field BaseClass Entity
local ENT = ENT --[[@as Entity]]


--#region Imports

    --- @type CommonBridgeClass
    local commonBridgeClass = CNC.Import( "renhud/client/bridges/common.lua" )

    --- @type QuaternionClass
    local quaternionClass = CNC.Import( "renhud/code/wwmath/quaternion.lua" )

    --- @type PhysicalEntityDefClass
    local physicalEntityDefClass = CNC.Import( "renhud/code/combat/physical-entity-def.lua" )

    --- @type Matrix3dClass
    local matrix3dClass = CNC.Import( "renhud/code/wwmath/matrix3d.lua" )
--#endregion


--[[ Garry's Mod Entity Setup ]] do

    ENT.Type = "anim"
    ENT.Base = "base_anim"
    ENT.Author = "A1steaksa"
    ENT.Category = "C&C Renegade"
    ENT.Spawnable = false
end

local BaseClass = baseclass.Get( ENT.Base ) --[[@as Entity]]

--- @class PhysicalEntityInstance
--- Original:
--- @field Model string The path of the model this Entity should use.
--- @field Definition PhysicalEntityDefInstance
--- @field StartingDefinition PhysicalEntityDefInstance

--- The Garry's Mod Entity init function  
--- Calls ENT:Init() as its final action
function ENT:Initialize()
    if SERVER then
        self:SetModel( self.Model or "models/Gibs/HGIBS.mdl" )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )

        self:SetUseType( SIMPLE_USE )

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
    end

    -- Call our pretend C++ constructor
    self:RenConstructor()

    -- Call the Renegade Init function last
    self:Init( self.StartingDefinition )
end

--- Called just before `ENT:Init()` when this Entity is created and is the appropriate place to put elements from C++ constructors
function ENT:RenConstructor()
end

--- The Renegade Entity Init function
--- @param definition PhysicalEntityDefInstance
function ENT:Init( definition )

    -- This is normally done in basegameobj, but I'm doing it here because I don't want to do that many layers of inheritance right now.
    self.Definition = definition
    -- self:CopySettings( definition )

    -- self:HideMuzzleFlashes()

    -- "If the definition calls for it, add a material effect to the [Entity]"
    if definition.UseCreationEffect then
        -- Omitted adding spawn effect
    end
end

--- The Garry's Mod Think function  
--- Calls `ENT:RenThink()` then `ENT:PostThink()`
function ENT:Think()
    self:RenThink()
    self:PostThink()
end

--- The Think function for Renegade Entities
function ENT:RenThink()
end

--- Called after the `ENT:RenThink()` function
function ENT:PostThink()
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

--- @return PhysicalEntityDefInstance
function ENT:GetDefinition()
    return self.Definition
end