-- Based on SmartGameObj within Code/Combat/smartgameobj.cpp/h

-- Ensure that the client receives the files relevant to them
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- Run the shared file first
include("shared.lua")

--- @class Renegade
local CNC = CNC_RENEGADE
