-- Based on MotionChannelClass within var/home/JSchneider/Projects/LuaRenegadePort/C&amp;C Renegade/Code/ww3d2/motchan.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MotionChannelClass
--- @field Instance MotionChannelInstance The metatable used by MotionChannelInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MotionChannelClass"

--- @class MotionChannelInstance
--- @field Static MotionChannelClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MotionChannel" )
INSTANCE.Class = "MotionChannelInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMotionChannel = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MotionChannelClass

    --- Creates a new MotionChannelInstance
    --- @return MotionChannelInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MotionChannel" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MotionChannelInstance, `false` otherwise
    function STATIC.IsMotionChannel( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMotionChannel and true or false
    end

    typecheck.RegisterType( "MotionChannelInstance", STATIC.IsMotionChannel )
end


--- @class MotionChannelInstance
--- @field PivotIdx any
--- @field Type any
--- @field VectorLen any
--- @field ValueOffset any
--- @field ValueScale any
--- @field CompressedData any
--- @field Data any
--- @field FirstFrame any
--- @field LastFrame any

function INSTANCE:DoDataCompression()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVector()
	typecheck.NotImplementedError()
end

function INSTANCE:Renegade_MotionChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_MotionChannel()
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

function INSTANCE:SetPivot()
	typecheck.NotImplementedError()
end

function INSTANCE:Free()
	typecheck.NotImplementedError()
end

function INSTANCE:SetIdentity()
	typecheck.NotImplementedError()
end
