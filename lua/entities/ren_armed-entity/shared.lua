-- Based on ArmedGameObj within Code/Combat/armedgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ArmedEntityClass
local STATIC = CNC.CreateExport()

--- @class ArmedEntityInstance : PhysicalEntityInstance
--- @field BaseClass PhysicalEntityInstance
local ENT = ENT --[[@as PhysicalEntityInstance]]


--#region Imports

    --- @type ArmedEntityDefClass
    local armedEntityDefClass = CNC.Import( "renhud/code/combat/armed-entity-def.lua" )
--#endregion


--[[ Garry's Mod Entity Setup ]] do

    ENT.Type = "anim"
    ENT.Base = "ren_physical-entity"
    ENT.Author = "A1steaksa"
    ENT.Category = "C&C Renegade"
    ENT.Spawnable = false
end

local BaseClass = baseclass.Get( ENT.Base ) --[[@as PhysicalEntityInstance]]

--- @class ArmedEntityInstance
--- @field protected WeaponBag WeaponBagInstance -- "Weapon & Ammo collection"
--- @field private TargetingPos Vector
--- @field private MuzzleA0Bone integer -- "YUCK!!!"
--- @field private MuzzleA1Bone integer
--- @field private MuzzleB0Bone integer
--- @field private MuzzleB1Bone integer

--[[ Definitions ]] do

    --- @param definition ArmedEntityDefInstance
    function ENT:Init( definition )
        BaseClass.Init( self, definition )
        self:CopySettings( definition )
    end

    --- @param definition ArmedEntityDefInstance
    function ENT:CopySettings( definition )
        local weapon = NULL
        if definition.WeaponDefId ~= 0 then
            weapon = self.WeaponBag:AddWeapon( definition.WeaponDefId, definition.WeaponRounds )
        end

        if definition.SecondaryWeaponDefId ~= 0 then
            local secondaryWeapon = self.WeaponBag:AddWepaon( definition.SecondaryWeaponDefId, definition.WeaponRounds )
            if weapon == NULL then
                weapon = secondaryWeapon
            end
        end

        if weapon ~= NULL then
            self.WeaponBag:SelectWeapon( weapon )
        end

        self:InitMuzzleBones()
    end

    --- @param definition ArmedEntityDefInstance
    function ENT:ReInit( definition )
        typecheck.NotImplementedError()
    end

    --- @return ArmedEntityDefInstance
    function ENT:GetDefinition()
        return BaseClass.GetDefinition( self ) --[[@as ArmedEntityDefInstance]]
    end
end

--[[ Thinking ]] do

    function ENT:PostThink()
        -- typecheck.NotImplementedError()
    end
end

--[[ Weapon ]] do

    --- @return WeaponInstance
    function ENT:GetWeapon()
        typecheck.NotImplementedError()
    end

    --- @return WeaponBagInstance
    function ENT:GetWeaponBag()
        return self.WeaponBag
    end

    --- @param index integer? [Default: 0]
    --- @return boolean
    function ENT:MuzzleExists( index )
        if not index then index = 0 end
        typecheck.NotImplementedError()
    end

    --- @param index integer? [Default: 0]
    --- @return Matrix3dInstance
    function ENT:GetMuzzle( index )
        if not index then index = 0 end
        typecheck.NotImplementedError()
    end

    --- @param muzzleIndex integer
    --- @param recoilScale number
    --- @param recoilTime number
    function ENT:StartRecoil( muzzleIndex, recoilScale, recoilTime )
        typecheck.NotImplementedError()
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



