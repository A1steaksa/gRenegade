-- Based on LogicalListenerClass within Code/WWAudio/LogicalListener.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SoundSceneObjectClass
local soundSceneObjectClass = CNC.Import( "code/wwaudio/sound-scene-object.lua" )

--- @class LogicalListenerClass : SoundSceneObjectClass
--- @field Instance LogicalListenerInstance The metatable used by LogicalListenerInstance
local STATIC = CNC.CreateExport( soundSceneObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "LogicalListenerClass"

--- @class LogicalListenerInstance : SoundSceneObjectInstance
--- @field Static LogicalListenerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_LogicalListener : Renegade_SoundSceneObject" )
INSTANCE.Class = "LogicalListenerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsLogicalListener = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class LogicalListenerClass
	--- @field GlobalScale number
	--- @field OldestTimestamp integer
	--- @field NewestTimestamp integer

    --- Creates a new LogicalListenerInstance
    --- @return LogicalListenerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_LogicalListener" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) LogicalListenerInstance, `false` otherwise
    function STATIC.IsLogicalListener( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsLogicalListener and true or false
    end

    typecheck.RegisterType( "LogicalListenerInstance", STATIC.IsLogicalListener )

	function STATIC.GetGlobalScale()
		typecheck.NotImplementedError()
	end

	--- @param scale number
	function STATIC.SetGlobalScale( scale )
		STATIC.GlobalScale = scale
	end

	function STATIC.GetNewTimestamp()
		typecheck.NotImplementedError()
	end

	function STATIC.GetNewestTimestamp()
		typecheck.NotImplementedError()
	end

	function STATIC.GetOldestTimestamp()
		typecheck.NotImplementedError()
	end

	function STATIC.SetOldestTimestamp()
		typecheck.NotImplementedError()
	end
end


--- @class LogicalListenerInstance
--- @field Scale number
--- @field TypeMask integer
--- @field Position Vector
--- @field Timestamp integer

function INSTANCE:Renegade_LogicalListener()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_LogicalListener()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTypeMask()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTypeMask()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:CullSound()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSoundCulled()
	typecheck.NotImplementedError()
end

function INSTANCE:AddToScene()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveFromScene()
	typecheck.NotImplementedError()
end

function INSTANCE:SetScale()
	typecheck.NotImplementedError()
end

function INSTANCE:GetScale()
	typecheck.NotImplementedError()
end

function INSTANCE:GetEffectiveScale()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFactory()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTimestamp()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTimestamp()
	typecheck.NotImplementedError()
end
