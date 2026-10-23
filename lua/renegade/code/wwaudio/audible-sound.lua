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

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	local enumBuilder = enumBuilderClass.New()

	--- @enum SoundType
	STATIC.SOUND_TYPE = {
		TYPE_MUSIC 			= enumBuilder:Set( 0 ),
		TYPE_SOUND_EFFECT	= enumBuilder:Next(),
		TYPE_DIALOG			= enumBuilder:Next(),
		TYPE_CINEMATIC		= enumBuilder:Next(),
		TYPE_COUNT 			= enumBuilder:Next(),
	}
	local soundTypeEnum = STATIC.SOUND_TYPE

	--- @enum SoundState
	STATIC.SOUND_STATE = {
		STATE_STOPPED 	= enumBuilder:Set( 0 ),
		STATE_PLAYING	= enumBuilder:Next(),
		STATE_PAUSED	= enumBuilder:Next(),
		STATE_COUNT		= enumBuilder:Next(),
	}
	local soundStateEnum = STATIC.SOUND_STATE

	--- @enum FadeType
	STATIC.FADE_TYPE = {
		FADE_NONE = enumBuilder:Set( 0 ),
		FADE_IN = enumBuilder:Next(),
		FADE_OUT = enumBuilder:Next(),
	}
	local fadeTypeEnum = STATIC.FADE_TYPE
--#endregion

--#region Imports

	--- @type Matrix3dClass
	local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )

	--- @type WWAudioClass
	local wWAudioClass = CNC.Import( "code/wwaudio/ww-audio.lua" )

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SoundChunkIds
	local soundChunkIds = CNC.Import( "code/wwaudio/sound-chunk-ids.lua" )
--#endregion

--#region Imported Enums

	local soundChunkIdEnum = soundChunkIds.SOUND_CHUNK_IDS
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class AudibleSoundClass

	STATIC.INFINITE_LOOPS = 0

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

	function STATIC.StaticConstructor()
        STATIC.AudibleSoundPersistFactory = simplePersistFactoryClass.New( STATIC, soundChunkIdEnum.CHUNKID_AUDIBLE_SOUND )
    end
end

--- @class AudibleSoundInstance
--- @field SoundHandle CSoundPatch
--- @field Timestamp integer
--- @field State SoundState
--- @field Type SoundType
--- @field FadeType FadeType
--- @field FadeTimer integer
--- @field FadeTime integer
--- @field VirtualChannel integer
--- @field Buffer SoundBufferInstance
--- @field RuntimePriority number
--- @field Priority number
--- @field Volume number
--- @field RealVolume number
--- @field Pan number
--- @field LoopCount integer
--- @field LoopsLeft integer
--- @field Length integer
--- @field CurrentPosition integer
--- @field StartOffset number
--- @field PitchFactor number
--- @field ListenerTransform Matrix3dInstance
--- @field Transform Matrix3dInstance
--- @field PreviousTransform Matrix3dInstance
--- @field IsCulled boolean
--- @field Dirty boolean
--- @field DropOffRadius number
--- @field ConvertedFormat AudibleSoundInstance
--- @field Definition AudibleSoundDefinitionInstance
--- @field LogicalSound LogicalSoundInstance

--- @param src AudibleSoundInstance?
function INSTANCE:Renegade_AudibleSound( src )
	self.Priority = 0.5
	self.RuntimePriority = 0
	self.SoundHandle = nil
	self.Length = 0
	self.CurrentPosition = 0
	self.Timestamp = 0
	self.State = soundStateEnum.STATE_STOPPED
	self.Buffer = nil
	self.Volume = 1.0
	self.RealVolume = 1.0
	self.Pan = 0.5
	self.LoopCount = 1
	self.LoopsLeft = 0
	self.Type = soundTypeEnum.TYPE_SOUND_EFFECT
	self.FadeType = fadeTypeEnum.FADE_NONE
	self.FadeTimer = 0
	self.FadeTime = 0
	self.VirtualChannel = 0
	self.Dirty = true
	self.DropOffRadius = 1
	self.IsCulled = true
	self.ConvertedFormat = nil
	self.PreviousTransform = matrix3dClass.New( true )
	self.Transform = matrix3dClass.New( true )
	self.ListenerTransform = matrix3dClass.New( true )
	self.Definition = nil
	self.LogicalSound = nil
	self.StartOffset = 0
	self.PitchFactor = 1.0

	if src then
		typecheck.NotImplementedError()
	end
end

function INSTANCE:_Renegade_AudibleSound()
	typecheck.NotImplementedError()
end

function INSTANCE:GetClassId()
	typecheck.NotImplementedError()
end

--- @return SoundType
function INSTANCE:GetType()
	return self.Type
end

--- @param type SoundType
function INSTANCE:SetType( type )
	self.Type = type
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

--- @param removeFromPlaylist boolean? [Default: `true`]
function INSTANCE:Stop( removeFromPlaylist )
	if removeFromPlaylist == nil then removeFromPlaylist = true end

	-- "Assume failure"
	local returnValue = false

	if self.State == soundStateEnum.STATE_PAUSED or self.State == soundStateEnum.STATE_PLAYING then
		-- "Actually stop the sample from playing"
		if self.SoundHandle ~= nil then
			self.SoundHandle:Stop()
		end

		-- "Free up the handle we have been using"
		self:FreeMilesHandle()
		self.State = soundStateEnum.STATE_STOPPED
		returnValue = true

		-- "Reset some of the playing attributes"
		self.Timestamp = 0
		self.CurrentPosition = 0

		-- "Remove the sound from the current playlist"
		if removeFromPlaylist then
			wWAudioClass.GetInstance():RemoveFromPlaylist( self )
		end

	end

	return returnValue
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

--- @param count integer
function INSTANCE:SetLoopCount( count )

	-- "Cache the loop count"
	self.LoopCount = count

	-- Omitted setting the loop count in Miles
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

--- @param transform Matrix3dInstance
function INSTANCE:SetTransform( transform )
	-- "Update our internal transform"
	self.PreviousTransform = self.Transform
	self.Transform = transform
	self:SetDirty()
end

function INSTANCE:GetTransform()
	typecheck.NotImplementedError()
end

--- @param culled boolean
function INSTANCE:CullSound( culled )
	-- "Is our state changing?"
	if culled ~= self.IsCulled then
		self.IsCulled = culled

		if self.IsCulled then
			self:FreeMilesHandle()
		else
			self:AllocateMilesHandle()
		end
	end
end

function INSTANCE:IsSoundCulled()
	typecheck.NotImplementedError()
end

--- @param startPlaying boolean
function INSTANCE:AddToScene( startPlaying )
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

--[[ Update Methods ]] do

	--- @param dirty boolean? [Default: `true`]
	function INSTANCE:SetDirty( dirty )
		if dirty == nil then dirty = true end

		self.Dirty = dirty
	end

	--- @return boolean
	function INSTANCE:IsDirty()
		return self.Dirty
	end
end


function INSTANCE:SetDefinition()
	typecheck.NotImplementedError()
end

--- @return AudibleSoundDefinitionInstance
function INSTANCE:GetDefinition()
	return self.Definition
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

--[[ Buffer Information ]] do

	--- @return SoundBufferInstance
	function INSTANCE:GetBuffer()
		return self.Buffer
	end

	--- @return SoundBufferInstance
	function INSTANCE:PeekBuffer()
		return self.Buffer
	end

	--- @param buffer SoundBufferInstance
	function INSTANCE:SetBuffer( buffer )
		self.Buffer = buffer

		-- "Stop playing if necessary"
		local resume = false
		if self.State == soundStateEnum.STATE_PLAYING then
			resume = self:Stop( false )
		end

		-- "Get the time (in ms) that this buffer will play for..."
		if self.Buffer ~= nil then
			self.Length = self.Buffer:GetDuration()
		end

		-- "Reinitialize the handle with this new data"
		self:InitializeMilesHandle()

		-- "Resume playing if necessary"
		if resume then
			self:Play()
		end
	end
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
