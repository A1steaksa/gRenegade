-- Based on PhysicalGameObj within Code/Combat/armedgameobj.cpp/h

-- Run the shared file first
include("shared.lua")

--- @class Renegade
local CNC = CNC_RENEGADE

--[[ Garry's Mod Entity Setup ]] do

    ENT.AutomaticFrameAdvance = true
end

function ENT:Draw()
    self:DrawModel()
end