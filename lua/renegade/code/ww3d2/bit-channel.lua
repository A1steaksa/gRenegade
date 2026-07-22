-- Based on BitChannelClass within var/home/JSchneider/Projects/LuaRenegadePort/C&amp;C Renegade/Code/ww3d2/motchan.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class BitChannelClass
--- @field Instance BitChannelInstance The metatable used by BitChannelInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BitChannelClass"

--- @class BitChannelInstance
--- @field Static BitChannelClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BitChannel" )
INSTANCE.Class = "BitChannelInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBitChannel = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class BitChannelClass

    --- Creates a new BitChannelInstance
    --- @return BitChannelInstance
    function STATIC.New()
        return robustclass.New( "Renegade_BitChannel" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BitChannelInstance, `false` otherwise
    function STATIC.IsBitChannel( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBitChannel and true or false
    end

    typecheck.RegisterType( "BitChannelInstance", STATIC.IsBitChannel )
end


--- @class BitChannelInstance
--- @field PivotIdx any
--- @field Type any
--- @field DefaultVal any
--- @field FirstFrame any
--- @field LastFrame any
--- @field Bits any

function INSTANCE:Renegade_BitChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_BitChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadW3d()
	typecheck.NotImplementedError()
end

function INSTANCE:GetType()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPivot()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBit()
	typecheck.NotImplementedError()
end

function INSTANCE:Free()
	typecheck.NotImplementedError()
end
