-- Based on Listener3DClass within Code/WWAudio/Listener.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type Sound3dClass
local sound3dClass = CNC.Import( "code/wwaudio/sound-3d.lua" )

--- @class Listener3dClass : Sound3dClass
--- @field Instance Listener3dInstance The metatable used by Listener3dInstance
local STATIC = CNC.CreateExport( sound3dClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "Listener3dClass"

--- @class Listener3dInstance : Sound3dInstance
--- @field Static Listener3dClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Listener3d : Renegade_Sound3d" )
INSTANCE.Class = "Listener3dInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsListener3D = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class Listener3dClass

    --- Creates a new Listener3DInstance
    --- @return Listener3dInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Listener3d" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) Listener3dInstance, `false` otherwise
    function STATIC.IsListener3d( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsListener3d and true or false
    end

    typecheck.RegisterType( "Listener3dInstance", STATIC.IsListener3d )
end


--- @class Listener3dInstance

function INSTANCE:Renegade_Listener3d()
	sound3dClass.Instance.Renegade_Sound3d( self )

	-- Empty in the original code
end

function INSTANCE:_Renegade_Listener3d()
	sound3dClass.Instance._Renegade_Sound3d( self )

	typecheck.NotImplementedError()
end

function INSTANCE:GetClassId()
	typecheck.NotImplementedError()
end

function INSTANCE:AsListener3dcLass()
	typecheck.NotImplementedError()
end

function INSTANCE:OnAddedToScene()
	typecheck.NotImplementedError()
end

function INSTANCE:OnRemovedFromScene()
	typecheck.NotImplementedError()
end

function INSTANCE:Pause()
	typecheck.NotImplementedError()
end

function INSTANCE:Resume()
	typecheck.NotImplementedError()
end

function INSTANCE:Stop()
	typecheck.NotImplementedError()
end

function INSTANCE:Seek()
	typecheck.NotImplementedError()
end

function INSTANCE:GetState()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMaxVolRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaxVolRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:StartSample()
	typecheck.NotImplementedError()
end

function INSTANCE:StopSample()
	typecheck.NotImplementedError()
end

function INSTANCE:ResumeSample()
	typecheck.NotImplementedError()
end

function INSTANCE:EndSample()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSampleVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSampleVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSamplePan()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSamplePan()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSampleLoopCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSampleLoopCount()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSampleMsPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSampleMsPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSamplePlaybackRate()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSamplePlaybackRate()
	typecheck.NotImplementedError()
end

function INSTANCE:InitializeMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:AllocateMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:FreeMilesHandle()
	typecheck.NotImplementedError()
end
