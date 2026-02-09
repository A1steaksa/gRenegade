-- Based on ArmedGameObj within Code/Combat/armedgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ArmedEntityClass : PhysicalEntityClass
local STATIC = CNC.CreateExport()

--- @class ArmedEntityInstance : PhysicalEntityInstance
--- @field BaseClass PhysicalEntityInstance
local ENT = ENT --[[@as PhysicalEntityInstance]]


--#region Imports

    --- @type WeaponBagClass
    local weaponBagClass = CNC.Import( "code/combat/weaponbag.lua" )

    --- @type ArmedEntityDefClass
    local armedEntityDefClass = CNC.Import( "code/combat/armed-entity-def.lua" )
--#endregion


--[[ Garry's Mod Entity Setup ]] do

    ENT.Type = "anim"
    ENT.Base = "ren_physical-entity"
end

local BaseClass = baseclass.Get( ENT.Base ) --[[@as PhysicalEntityInstance]]

--- @class ArmedEntityInstance
--- @field protected WeaponBag WeaponBagInstance -- "Weapon & Ammo collection"
--- @field private TargetingPos Vector
--- @field private MuzzleA0Bone integer -- "YUCK!!!"
--- @field private MuzzleA1Bone integer
--- @field private MuzzleB0Bone integer
--- @field private MuzzleB1Bone integer
--- @field private MuzzleRecoilController MuzzleRecoilInstance[]

local MAX_MUZZLES = 4

--[[ Definitions ]] do

    function ENT:RenConstructor()
        BaseClass.RenConstructor( self )

        self.MuzzleA0Bone = 0
        self.MuzzleA1Bone = 0
        self.MuzzleB0Bone = 0
        self.MuzzleB1Bone = 0

        self.TargetingPos = Vector( 0, 0, 0 )
        self.WeaponBag = weaponBagClass.New( self )

        self.MuzzleRecoilController = {}
    end

    --- @param definition SmartEntityDefInstance
    function ENT:Init( definition )
        BaseClass.Init( self, definition )
        self:CopySettings( definition )
    end

    --- @param definition ArmedEntityDefInstance
    function ENT:CopySettings( definition )
        local weapon = NULL
        -- if definition.WeaponDefId ~= 0 then
        --     weapon = self.WeaponBag:AddWeapon( definition.WeaponDefId, definition.WeaponRounds )
        -- end

        -- if definition.SecondaryWeaponDefId ~= 0 then
        --     local secondaryWeapon = self.WeaponBag:AddWepaon( definition.SecondaryWeaponDefId, definition.WeaponRounds )
        --     if weapon == NULL then
        --         weapon = secondaryWeapon
        --     end
        -- end

        -- if weapon ~= NULL then
        --     self.WeaponBag:SelectWeapon( weapon )
        -- end

        self:InitMuzzleBones()
    end

    --- @param definition ArmedEntityDefInstance
    function ENT:ReInit( definition )
        BaseClass.ReInit( self, definition --[[@as PhysicalEntityDefInstance]] )

        -- "Remnove all non-beacon entries from the weapon bag..."
        local oldBag = self.WeaponBag
        if self.WeaponBag then
            -- -- "Loop over all the weapons in the bag"
            -- local weaponIndex = self.WeaponBag:GetCount()
            -- while weaponIndex > 0 do
            --     weaponIndex = weaponIndex - 1
            --     local weapon = self.WeaponBag:PeekWeapon( weaponIndex )

            --     -- "If this isn't a beacon, then remove it"
            --     if weapon and weapon:GetDefinition().Style ~= WEAPON_HOLD_STYLE_BEACON then
            --         self.WeaponBag:RemoveWepaon( weaponIndex )
            --     end
            -- end
        end

        -- "Re-initialize the weapon bag"
        self.WeaponBag = weaponBagClass.New( self )

        -- "Copy any internal settings from the definition"
        self:CopySettings( definition )

        -- "Now add any beacons back into the weapon bag"
        -- if oldBag then
        --     self.WeaponBag:MoveContents( oldBag )
        -- end
    end

    --- @return ArmedEntityDefInstance
    function ENT:GetDefinition()
        return BaseClass.GetDefinition( self ) --[[@as ArmedEntityDefInstance]]
    end
end

-- function ENT:PostThink()
--     BaseClass.PostThink( self )

--     -- "Don't update if destroying... (so we don't create a new laser!)"
--     if self:IsMarkedForDeletion() then
--         return
--     end

--     -- "Update the weapon after the commands and update_human_animation"
--     if self:GetWeapon() ~= NULL then
--         self:GetWeapon():Update()
--     end

--     -- "Allow any recoil animation to progress"
--     for i = 1, #self.MuzzleRecoilController do
--         self.MuzzleRecoilController[i]:Update( self )
--     end
-- end

--[[ Weapons ]] do

    --- @return WeaponInstance
    function ENT:GetWeapon()
        return self.WeaponBag:GetWeapon()
    end

    --- @return WeaponBagInstance
    function ENT:GetWeaponBag()
        return self.WeaponBag
    end

    function ENT:InitMuzzleBones()
        self.MuzzleA0Bone = self:LookupBone( "muzzlea0" ) --[[@as integer]]
        self.MuzzleA1Bone = self:LookupBone( "muzzlea1" ) --[[@as integer]]
        self.MuzzleB0Bone = self:LookupBone( "muzzleb0" ) --[[@as integer]]
        self.MuzzleB1Bone = self:LookupBone( "muzzleb1" ) --[[@as integer]]

        if not self.MuzzleA1Bone then
            self.MuzzleA1Bone = self.MuzzleA0Bone
        end
        if not self.MuzzleB0Bone then
            self.MuzzleB0Bone = self.MuzzleA0Bone
        end
        if not self.MuzzleB1Bone then
            self.MuzzleB1Bone = self.MuzzleB0Bone
        end

        -- self.MuzzleRecoilController[1]:Init( self.MuzzleA0Bone )
        -- self.MuzzleRecoilController[2]:Init( self.MuzzleA1Bone )
        -- self.MuzzleRecoilController[3]:Init( self.MuzzleB0Bone )
        -- self.MuzzleRecoilController[4]:Init( self.MuzzleB1Bone )

        -- "Let the weapon learn about muzzle flashes"
        -- if self:GetWeapon() ~= NULL then
        --     self:GetWeapon():SetModel( self:GetModel() )
        -- end
    end

    --- @param index integer? [Default: 1]
    --- @return boolean
    function ENT:MuzzleExists( index )
        if not index then index = 1 end

        if index == 1 then
            return self.MuzzleA0Bone ~= 0
        end
        if index == 2 then
            return self.MuzzleA1Bone ~= 0
        end
        if index == 3 then
            return self.MuzzleB0Bone ~= 0
        end
        if index == 4 then
            return self.MuzzleB1Bone ~= 0
        end

        return false
    end

    --- @param index integer? [Default: 1]
    --- @return Matrix3dInstance
    function ENT:GetMuzzle( index )
        if not index then index = 1 end

        if index == 2 and self.MuzzleB1Bone ~= 0 then
            return self:GetBoneTransform( self.MuzzleB1Bone )
        end

        if index == 1 and self.MuzzleB0Bone ~= 0 then
            return self:GetBoneTransform( self.MuzzleB0Bone )
        end

        if index == 0 and self.MuzzleA1Bone ~= 0 then
            return self:GetBoneTransform( self.MuzzleA1Bone )
        end

        if self.MuzzleA0Bone ~= 0 then
            return self:GetBoneTransform( self.MuzzleA0Bone )
        end

        return self:GetTransform()
    end

    --- @param muzzleIndex integer
    --- @param recoilScale number
    --- @param recoilTime number
    function ENT:StartRecoil( muzzleIndex, recoilScale, recoilTime )
        self.MuzzleRecoilController[muzzleIndex]:StartRecoil( recoilScale, recoilTime )
    end

    --- @return number
    function ENT:GetWeaponError()
        return self:GetDefinition().WeaponError
    end
end

--[[ Targeting ]] do

    --- @return Vector
    function ENT:GetTargetingPos()
        return self.TargetingPos
    end

    --- @param targetPos Vector
    --- @param doTilt boolean? [Default: true]
    --- @return boolean
    function ENT:SetTargeting( targetPos, doTilt )
        if not doTilt then doTilt = true end

        self.TargetingPos = targetPos

        -- "Move the turret to match the target"
        return true
    end
end

--[[ Type Identification ]] do

    --- @return ArmedEntityInstance
    function ENT:AsArmedEntity()
        return self
    end
end
