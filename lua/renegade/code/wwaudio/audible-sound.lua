-- Based on AudibleSoundClass within Code/WWAudio/AudibleSound.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SoundSceneObjectClass
local soundSceneObjectClass = CNC.Import( "code/wwaudio/sound-scene-object.lua" )

--- @class AudibleSoundClass : SoundSceneObjectClass
--- @field Instance AudibleSoundInstance The metatable used by AudibleSoundInstance
local STATIC = CNC.CreateExport( soundSceneObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AudibleSoundClass"

--- @class AudibleSoundInstance : SoundSceneObjectInstance
--- @field Static AudibleSoundClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AudibleSound : Renegade_SoundSceneObject" )
INSTANCE.Class = "AudibleSoundInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAudibleSound = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class AudibleSoundClass

    --- Creates a new AudibleSoundInstance
    --- @return AudibleSoundInstance
    function STATIC.New()
        return robustclass.New( "Renegade_AudibleSound" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AudibleSoundInstance, `false` otherwise
    function STATIC.IsAudibleSound( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAudibleSound and true or false
    end

    typecheck.RegisterType( "AudibleSoundInstance", STATIC.IsAudibleSound )
end


--- @class AudibleSoundInstance
--- @field MSoundHandle SoundHandleInstance
--- @field MTimestamp integer
--- @field MState SoundStateInstance
--- @field MType SoundTypeInstance
--- @field MFadeType FadeTypeInstance
--- @field MFadeTimer integer
--- @field MFadeTime integer
--- @field MVirtualChannel integer
--- @field MBuffer SoundBufferInstance
--- @field MRuntimePriority number
--- @field MPriority number
--- @field MVolume number
--- @field MRealVolume number
--- @field MPan number
--- @field MLoopCount integer
--- @field MLoopsLeft integer
--- @field MLength integer
--- @field MCurrentPosition integer
--- @field MStartOffset number
--- @field MPitchFactor number
--- @field MListenerTransform Matrix3dInstance
--- @field MTransform Matrix3dInstance
--- @field MPreviousTransform Matrix3dInstance
--- @field MIsCulled boolean
--- @field MBDirty boolean
--- @field MDropOffRadius number
--- @field MPConvertedFormat AudibleSoundInstance
--- @field MDefinition AudibleSoundDefinitionInstance
--- @field MLogicalSound LogicalSoundInstance

function INSTANCE:Renegade_AudibleSound()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_AudibleSound()
	typecheck.NotImplementedError()
end

function INSTANCE:GetClassId()
	typecheck.NotImplementedError()
end

function INSTANCE:GetType()
	typecheck.NotImplementedError()
end

function INSTANCE:SetType()
	typecheck.NotImplementedError()
end

function INSTANCE:AsAudibleSoundClass()
	typecheck.NotImplementedError()
end

function INSTANCE:OnFrameUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:Play()
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

function INSTANCE:FadeOut()
	typecheck.NotImplementedError()
end

function INSTANCE:FadeIn()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTimestamp()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVirtualChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVirtualChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFilename()
	typecheck.NotImplementedError()
end

function INSTANCE:IsPlaying()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPan()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPan()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLoopCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLoopsLeft()
	typecheck.NotImplementedError()
end

function INSTANCE:SetLoopCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPriority()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekPriority()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPriority()
	typecheck.NotImplementedError()
end

function INSTANCE:GetRuntimePriority()
	typecheck.NotImplementedError()
end

function INSTANCE:SetRuntimePriority()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPlaybackRate()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPlaybackRate()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPitchFactor()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPitchFactor()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDuration()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPlayPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPlayPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:SetStartOffset()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStartOffset()
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

function INSTANCE:AddToScene()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveFromScene()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDirty()
	typecheck.NotImplementedError()
end

function INSTANCE:IsDirty()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDefinition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDefinition()
	typecheck.NotImplementedError()
end

function INSTANCE:ReSync()
	typecheck.NotImplementedError()
end

function INSTANCE:FreeConversion()
	typecheck.NotImplementedError()
end

function INSTANCE:ConvertToFiltered()
	typecheck.NotImplementedError()
end

function INSTANCE:AsConvertedFormat()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFactory()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:DetermineRealVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:InternalSetVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateFade()
	typecheck.NotImplementedError()
end

function INSTANCE:VerifyPlayability()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:FreeMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:InitializeMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:AllocateMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:GetBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:RestartLoop()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdatePlayPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:OnLoopEnd()
	typecheck.NotImplementedError()
end
