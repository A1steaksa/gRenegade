-- Based on SoundSceneObjClass within Code/WWAudio/SoundSceneObj.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class SoundSceneObjectClass
--- @field Instance SoundSceneObjectInstance The metatable used by SoundSceneObjectInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SoundSceneObjectClass"

--- @class SoundSceneObjectInstance
--- @field Static SoundSceneObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SoundSceneObject" )
INSTANCE.Class = "SoundSceneObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSoundSceneObject = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class SoundSceneObjectClass
	--- @field MGlobalSoundList SoundSceneObjectInstance[]
	--- @field MNextAvailableID Uint32Instance
	--- @field MIdListMutex CriticalSectionInstance

    --- Creates a new SoundSceneObjectInstance
    --- @return SoundSceneObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SoundSceneObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SoundSceneObjectInstance, `false` otherwise
    function STATIC.IsSoundSceneObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSoundSceneObject and true or false
    end

    typecheck.RegisterType( "SoundSceneObjectInstance", STATIC.IsSoundSceneObject )

	function STATIC.RegisterSoundObject()
		typecheck.NotImplementedError()
	end

	function STATIC.UnregisterSoundObject()
		typecheck.NotImplementedError()
	end

	function STATIC.FindSoundObject()
		typecheck.NotImplementedError()
	end
end


--- @class SoundSceneObjectInstance
--- @field Scene SoundSceneInstance
--- @field PhysicsWrapper SoundCullObjectInstance
--- @field PCallback AudioCallbackInstance
--- @field RegisteredEvents AudioCallbackClassEVENTSInstance
--- @field Id integer
--- @field AttachedObject RenderObjectInstance
--- @field AttachedBone integer
--- @field UserData integer
--- @field UserObject any

function INSTANCE:Renegade_SoundSceneObject()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_SoundSceneObject()
	typecheck.NotImplementedError()
end

function INSTANCE:AsSound3dcLass()
	typecheck.NotImplementedError()
end

function INSTANCE:AsSoundPseudo3dcLass()
	typecheck.NotImplementedError()
end

function INSTANCE:AsFilteredSoundClass()
	typecheck.NotImplementedError()
end

function INSTANCE:AsListener3dcLass()
	typecheck.NotImplementedError()
end

function INSTANCE:AsAudibleSoundClass()
	typecheck.NotImplementedError()
end

function INSTANCE:GetId()
	typecheck.NotImplementedError()
end

function INSTANCE:SetId()
	typecheck.NotImplementedError()
end

function INSTANCE:OnFrameUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:OnEvent()
	typecheck.NotImplementedError()
end

function INSTANCE:RegisterCallback()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveCallback()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:SetListenerTransform()
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

--[[ User Data Methods ]] do

	--- @param userObject any? [Default: `nil`]
	--- @param user integer? [Default: `0`]
	function INSTANCE:SetUserData( userObject, user )
		self.MUserObject = userObject
		self.MUserData = user
	end

	function INSTANCE:GetUserData()
		typecheck.NotImplementedError()
	end

	function INSTANCE:PeekUserObject()
		typecheck.NotImplementedError()
	end
end


function INSTANCE:AttachToObject()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekParentObject()
	typecheck.NotImplementedError()
end

function INSTANCE:GetParentBone()
	typecheck.NotImplementedError()
end

function INSTANCE:ApplyAutoPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:AddToScene()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveFromScene()
	typecheck.NotImplementedError()
end

function INSTANCE:IsInScene()
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

function INSTANCE:PeekCullableWrapper()
	typecheck.NotImplementedError()
end

function INSTANCE:SetCullableWrapper()
	typecheck.NotImplementedError()
end
