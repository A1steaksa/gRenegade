-- Based on SmartGameObj within Code/Combat/smartgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SmartEntityClass
local STATIC = CNC.CreateExport()

--- @class SmartEntityInstance : ArmedEntityInstance
--- @field BaseClass ArmedEntityInstance
local ENT = ENT --[[@as ArmedEntityInstance]]


--#region Imports

    --- @type SmartEntityDefClass
    local smartEntityDefClass = CNC.Import( "renhud/code/combat/smart-entity-def.lua" )
--#endregion


--[[ Garry's Mod Entity Setup ]] do

    ENT.Type = "anim"
    ENT.Base = "ren_armed-entity"
    ENT.Author = "A1steaksa"
    ENT.Category = "C&C Renegade"
    ENT.Spawnable = false
end

local BaseClass = baseclass.Get( ENT.Base ) --[[@as ArmedEntityInstance]]


--[[ Definitions ]] do

    --- @param definition SmartEntityDefInstance
    function ENT:Init( definition )
        BaseClass.Init( self, definition )
        -- self:CopySettings( definition )
    end
end


--- @return SmartEntityDefInstance
function ENT:GetDefinition()
    return BaseClass.GetDefinition( self ) --[[@as SmartEntityDefInstance]]
end