-- Based on ScriptableGameObj within Code/Combat/scriptablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ScriptableEntityClass
local STATIC = CNC.CreateExport()

--- @class ScriptableEntityInstance : BaseEntityInstance
--- @field BaseClass BaseEntityInstance
local ENT = ENT --[[@as Entity]]


--#region Imports

    --- @type ScriptableEntityDefClass
    local scriptableEntityDefClass = CNC.Import( "code/combat/scriptable-entity-def.lua" )
--#endregion


--[[ Garry's Mod Entity Setup ]] do

    ENT.Base = "ren_base-entity"
end

local BaseClass = baseclass.Get( ENT.Base ) --[[@as BaseEntityInstance]]

--- @class ScriptableEntityInstance

--[[ Definitions ]] do

    --- The Renegade Entity Init function
    --- @param definition ScriptableEntityDefInstance
    function ENT:Init( definition )
        BaseClass:Init( definition )
    end

    function ENT:ReInit()
    end

    function ENT:PostReInit()
    end

    --- @return ScriptableEntityDefInstance
    function ENT:GetDefinition()
        return self.Definition --[[@as ScriptableEntityDefInstance]]
    end

    function ENT:SetDeletePending()
    end
end

--[[ Type Identification ]] do

    --- @return ScriptableEntityInstance
    function ENT:AsScriptableEntity()
        return self
    end

    --- @return DamageableEntityInstance
    function ENT:AsDamageableEntity()
        return NULL
    end

    --- @return BuildingEntityInstance
    function ENT:AsBuildingEntity()
        return NULL
    end

    --- @return SoldierEntityInstance
    function ENT:AsSoldierEntity()
        return NULL
    end

    --- @return ScriptZoneEntityInstance
    function ENT:AsScriptZoneEntity()
        return NULL
    end

    --- @return ReferenceableEntityInstance
    function ENT:AsReferenceableEntity()
        return self
    end
end