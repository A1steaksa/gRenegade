-- Based on SmartGameObj within Code/Combat/smartgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ArmedEntityClass
local PARENT = CNC.Import( "entities/ren_armed-entity/shared.lua" )

--- @class SmartEntityClass : ArmedEntityClass
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ArmedEntityClass"

--- @class SmartEntityInstance : ArmedEntityInstance
--- @field BaseClass ArmedEntityInstance
local ENT = ENT --[[@as ArmedEntityInstance]]
ENT.Class = "ArmedEntityInstance"


--#region Imports

    --- @type SmartEntityDefClass
    local smartEntityDefClass = CNC.Import( "code/combat/smart-entity-def.lua" )
--#endregion


--[[ Garry's Mod Entity Setup ]] do

    ENT.Type = "anim"
    ENT.Base = "ren_armed-entity"
    ENT.Spawnable = false
end

local BaseClass = baseclass.Get( ENT.Base ) --[[@as ArmedEntityInstance]]

--- @class SmartEntityInstance

--[[ Definitions ]] do

    --- @param definition SmartEntityDefInstance
    function ENT:Init( definition )
        BaseClass.Init( self, definition )
    end

    --- @return SmartEntityDefInstance
    function ENT:GetDefinition()
        return BaseClass.GetDefinition( self ) --[[@as SmartEntityDefInstance]]
    end
end

