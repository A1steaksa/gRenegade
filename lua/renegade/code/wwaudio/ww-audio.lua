-- Based on WWAudioClass within Code/WWAudio/WWAudio.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class WWAudioClass
--- @field Instance WWAudioInstance The metatable used by WWAudioInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "WWAudioClass"

--- @class WWAudioInstance
--- @field Static WWAudioClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_WWAudio" )
INSTANCE.Class = "WWAudioInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsWWAudio = true

--#region Exported Enums

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	local enumBuilder = enumBuilderClass.New()

	--- @enum SoundClassId
	STATIC.SOUND_CLASSID = {
		CLASSID_UNKNOWN 	= enumBuilder:Set( 0 ),
		CLASSID_2D			= enumBuilder:Next(),
		CLASSID_3D			= enumBuilder:Next(),
		CLASSID_LISTENER	= enumBuilder:Next(),
		CLASSID_PSEUDO3D	= enumBuilder:Next(),
		CLASSID_2DTRIGGER	= enumBuilder:Next(),
		CLASSID_LOGICAL		= enumBuilder:Next(),
		CLASSID_FILTERED	= enumBuilder:Next(),
		CLASSID_COUNT		= enumBuilder:Next(),
	}
	local soundClassIdEnum = STATIC.SOUND_CLASSID

	--- @enum SoundPage
	STATIC.SOUND_PAGE = {
		PAGE_PRIMARY 	= enumBuilder:Set( 0 ),
		PAGE_SECONDARY	= enumBuilder:Next(),
		PAGE_TERTIARY	= enumBuilder:Next(),
		PAGE_COUNT		= enumBuilder:Next(),
	}
	local soundPageEnum = STATIC.SOUND_PAGE
--#endregion

--#region Imports

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

	--- @type DefinitionClassIds
	local definitionClassIds = CNC.Import( "code/wwsaveload/definition-class-ids.lua" )

	--- @type AudibleSoundClass
	local audibleSoundClass = CNC.Import( "code/wwaudio/audible-sound.lua" )

	--- @type SoundBufferClass
	local soundBufferClass = CNC.Import( "code/wwaudio/sound-buffer.lua" )

	--- @type UnitConversionLib
	local unitConversionLib = CNC.Import( "sh_unit-conversion.lua" )

	--- @type SoundLib
	local soundLib = CNC.Import( "sh_sound.lua" )

	--- @type SoundSceneClass
	local soundSceneClass = CNC.Import( "code/wwaudio/sound-scene.lua" )

	--- @type ClassUtils
	local classUtils = CNC.Import( "sh_class-utils.lua" )
--#endregion

--#region Imported Enums

	local classIdEnum = definitionClassIds.CLASS_ID
	local fadeTypeEnum = audibleSoundClass.FADE_TYPE
	local soundTypeEnum = audibleSoundClass.SOUND_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class WWAudioClass
	--- @field TheInstance WWAudioInstance
	--- @field TimerSyncEvent HandleInstance

	--- @type {[string]: SoundBufferInstance}
	STATIC.LoadedSoundBuffers = {}

	--[[ Default Values ]] do

		STATIC.DEF_2D_SAMPLE_COUNT		= 16
		STATIC.DEF_3D_SAMPLE_COUNT		= 16
		STATIC.DEF_MUSIC_VOL			= 1.0
		STATIC.DEF_SFX_VOL				= 1.0
		STATIC.DEF_DIALOG_VOL			= 1.0
		STATIC.DEF_CINEMATIC_VOL		= 1.0
		STATIC.DEF_FADE_TIME			= 0.5
		STATIC.DEF_CACHE_SIZE			= 1024
		STATIC.DEF_MAX_2D_BUFFER_SIZE	= 20000
		STATIC.DEF_MAX_3D_BUFFER_SIZE	= 100000
	end

    --- Creates a new WWAudioInstance
    --- @return WWAudioInstance
    function STATIC.New()
        return robustclass.New( "Renegade_WWAudio" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) WWAudioInstance, `false` otherwise
    function STATIC.IsWWAudio( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsWWAudio and true or false
    end

    typecheck.RegisterType( "WWAudioInstance", STATIC.IsWWAudio )

	function STATIC.StaticConstructor()
		STATIC.TheInstance = STATIC.New()
	end

	--- @return WWAudioInstance
	function STATIC.GetInstance()
		return STATIC.TheInstance
	end

	function STATIC.FileOpenCallback()
		typecheck.NotImplementedError()
	end

	function STATIC.FileCloseCallback()
		typecheck.NotImplementedError()
	end

	function STATIC.FileSeekCallback()
		typecheck.NotImplementedError()
	end

	function STATIC.FileReadCallback()
		typecheck.NotImplementedError()
	end
end


--- @class WWAudioInstance
--- @field PlaybackRate integer
--- @field PlaybackBits integer
--- @field PlaybackStereo boolean
--- @field MusicVolume number
--- @field SoundVolume number
--- @field RealMusicVolume number
--- @field RealSoundVolume number
--- @field DialogVolume number
--- @field CinematicVolume number
--- @field Max2dSamples integer
--- @field Max3dSamples integer
--- @field Max2dbUfferSize integer
--- @field Max3dBufferSize integer
--- @field UpdateTimer HtimerInstance
--- @field IsMusicEnabled boolean
--- @field IsDialogEnabled boolean
--- @field IsCinematicSoundEnabled boolean
--- @field _AreSoundEffectsEnabled boolean
--- @field AreNewSoundsEnabled boolean
--- @field FileFactory FileFactoryInstance
--- @field BackgroundMusic AudibleSoundInstance?
--- @field BackgroundMusicName string?
--- @field CachedIsMusicEnabled boolean
--- @field CachedIsDialogEnabled boolean
--- @field CachedIsCinematicSoundEnabled boolean
--- @field CachedAreSoundEffectsEnabled boolean
--- @field EosCallbackList {[integer]: fun( soundObject: SoundSceneObjectInstance, userParameters: integer )}
--- @field TextCallbackList AudioCallbackListClassLPFNTEXTCALLBACKInstance
--- @field SoundScene SoundSceneInstance
--- @field CurrPage SoundPage
--- @field PageStack SoundPage[]
--- @field Driver2d HdigdriverInstance
--- @field Driver3d HproviderInstance
--- @field Driver3dpSeudo HproviderInstance
--- @field ReverbFilter HproviderInstance
--- @field Driver3dlIst DriverInfoStructInstance[]
--- @field Driver3dnAme string
--- @field SpeakerType integer
--- @field M2dsAmpleHandles HsampleInstance[]
--- @field M3dsAmpleHandles H3dsampleInstance[]
--- @field Playlist AudibleSoundInstance[][]
--- @field CompletedSounds AudibleSoundInstance[]
--- @field VirtualChannels AudibleSoundInstance[]
--- @field CachedBuffers {[string]: SoundBufferInstance}
--- @field MaxCacheSize integer
--- @field CurrentCacheSize integer
--- @field LogicalTypes LogicalTypeStructInstance[]
--- @field EffectsLevel number
--- @field ReverbRoomType integer
--- @field NonDialogFadeTime number
--- @field FadeType FadeType
--- @field FadeTimer number
--- @field AudioIni IniInstance
--- @field ForceDisable boolean

--- @param lite boolean? [Default: `false`]
function INSTANCE:Renegade_WWAudio( lite )
	if lite == nil then lite = false end

	self.Driver2d = nil
	self.Driver3d = nil
	self.PlaybackRate = 44100
	self.PlaybackBits = 16
	self.PlaybackStereo = true
	self.SpeakerType = 0
	self.ReverbFilter = nil
	self.UpdateTimer = -1
	self.Driver3dpSeudo = nil
	self.MusicVolume = STATIC.DEF_MUSIC_VOL
	self.SoundVolume = STATIC.DEF_SFX_VOL
	self.RealMusicVolume = STATIC.DEF_MUSIC_VOL
	self.RealSoundVolume = STATIC.DEF_SFX_VOL
	self.MaxCacheSize = STATIC.DEF_CACHE_SIZE * 1024
	self.CurrentCacheSize = 0
	self.Max2dSamples = STATIC.DEF_2D_SAMPLE_COUNT
	self.Max3dSamples = STATIC.DEF_3D_SAMPLE_COUNT
	self.Max2dbUfferSize = STATIC.DEF_MAX_2D_BUFFER_SIZE
	self.Max3dBufferSize = STATIC.DEF_MAX_3D_BUFFER_SIZE
	self.SoundScene = nil
	self.IsMusicEnabled = true
	self.IsDialogEnabled = true
	self.IsCinematicSoundEnabled = true
	self._AreSoundEffectsEnabled = true
	self.FileFactory = nil
	self.EffectsLevel = 0
	self.CurrPage = soundPageEnum.PAGE_PRIMARY
	self.AreNewSoundsEnabled = true
	self.BackgroundMusic = nil
	self.ReverbRoomType = ENVIRONMENT_GENERIC
	self.NonDialogFadeTime = STATIC.DEF_FADE_TIME
	self.FadeType = fadeTypeEnum.FADE_NONE
	self.FadeTimer = 0
	self.CachedIsMusicEnabled = true
	self.CachedIsDialogEnabled = true
	self.CachedIsCinematicSoundEnabled = true
	self.CachedAreSoundEffectsEnabled = true
	self.AudioIni = nil

	self.Playlist = {}
	for i = 1, soundPageEnum.PAGE_COUNT do
		self.Playlist[i] = {}
	end

	self.ForceDisable = lite

	-- Omitting Miles startup

	STATIC.TheInstance = self
	-- Omitted timer sync event

	-- "Set some default values"
	self:SetSoundEffectsVolume()
	self:SetMusicVolume()

	-- "Allocate the virtual channels"
	self.VirtualChannels = {}

	-- "Create a new sound scene to manage our 3D sounds..."
	if not lite then
		self.SoundScene = soundSceneClass.New()
	end

	self.Max3dBufferSize = self.Max3dBufferSize * 2.0
end

function INSTANCE:_Renegade_WWAudio()
	typecheck.NotImplementedError()
end

---	"  
--- Note:  After call Initialize() you can begin using the library, you don't
--- need to explicity call Open_2D_Device() or Select_3D_Device().  
--- Those methods were provided as a means of opening devices other than the default.  
---
---	The Initialize() method defaults to a stereo, 16bit, 44100hz 2D DirectSound
--- driver and a RSX 3D provider.  If RSX isn't available, it trys A3D, then
---	EAX, then D3DSound, then whatever driver is first available.
--- "  
--- @overload fun( stereo: boolean?, bits: integer?, hertz: integer? )
--- @overload fun( registrySubkeyName: string )
function INSTANCE:Initialize( ... )
	local args = { ... }
	local argCount = select( "#", args )

	-- ( registrySubkeyName: string )
	if isstring( args[1] ) then

		-- I don't think any of this actually applies to Lua...

	-- ( stereo: boolean?, bits: integer?, hertz: integer? )
	else
		local stereo = args[1] or true
		local bits   = args[2] or 16
		local hertz  = args[3] or 44100

		-- I don't think any of this actually applies to Lua...
	end
end

function INSTANCE:Shutdown()
	typecheck.NotImplementedError()
end

function INSTANCE:Get2dDriver()
	typecheck.NotImplementedError()
end

function INSTANCE:Get3dDriver()
	typecheck.NotImplementedError()
end

function INSTANCE:Get3dDriverName()
	typecheck.NotImplementedError()
end

function INSTANCE:GetReverbFilter()
	typecheck.NotImplementedError()
end

function INSTANCE:Open2dDevice()
	typecheck.NotImplementedError()
end

function INSTANCE:Close2dDevice()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPlaybackRate()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPlaybackBits()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPlaybackStereo()
	typecheck.NotImplementedError()
end

function INSTANCE:Get3dDeviceCount()
	typecheck.NotImplementedError()
end

function INSTANCE:Get3dDevice()
	typecheck.NotImplementedError()
end

function INSTANCE:Is3dDeviceAvailable()
	typecheck.NotImplementedError()
end

function INSTANCE:Find3dDevice()
	typecheck.NotImplementedError()
end

function INSTANCE:Select3dDevice()
	typecheck.NotImplementedError()
end

function INSTANCE:Select3dDevice()
	typecheck.NotImplementedError()
end

function INSTANCE:Close3dDevice()
	typecheck.NotImplementedError()
end

function INSTANCE:SetSpeakerType()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSpeakerType()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadFromRegistry()
	typecheck.NotImplementedError()
end

function INSTANCE:SaveToRegistry()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadDefaultVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetFileFactory()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMax2dSampleCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMax2dSampleCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAvail2dSampleCount()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMax3dSampleCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMax3dSampleCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetAvail3dSampleCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetEffectsLevel()
	typecheck.NotImplementedError()
end

function INSTANCE:GetReverbRoomType()
	typecheck.NotImplementedError()
end

function INSTANCE:SetReverbRoomType()
	typecheck.NotImplementedError()
end

--- @param volume number? [Default: `STATIC.DEF_SFX_VOL`]
function INSTANCE:SetSoundEffectsVolume( volume )
	if volume == nil then volume = STATIC.DEF_SFX_VOL end

	self.RealSoundVolume = volume
	self.RealSoundVolume = math.min( 1.0, self.RealSoundVolume )
	self.RealSoundVolume = math.max( 0.0, self.RealSoundVolume )

	self:InternalSetSoundEffectsVolume( self.RealSoundVolume )
end

function INSTANCE:GetSoundEffectsVolume()
	typecheck.NotImplementedError()
end

--- @param volume number? [Default: `STATIC.DEF_MUSIC_VOL`]
function INSTANCE:SetMusicVolume( volume )
	if volume == nil then volume = STATIC.DEF_MUSIC_VOL end

	self.RealMusicVolume = volume
	self.RealMusicVolume = math.min( 1.0, self.RealMusicVolume )
	self.RealMusicVolume = math.max( 0.0, self.RealMusicVolume )

	self:InternalSetMusicVolume( self.RealMusicVolume )
end

function INSTANCE:GetMusicVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDialogVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDialogVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetCinematicVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:GetCinematicVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:AllowSoundEffects()
	typecheck.NotImplementedError()
end

function INSTANCE:AreSoundEffectsOn()
	typecheck.NotImplementedError()
end

function INSTANCE:AllowMusic()
	typecheck.NotImplementedError()
end

function INSTANCE:IsMusicOn()
	typecheck.NotImplementedError()
end

function INSTANCE:AllowDialog()
	typecheck.NotImplementedError()
end

function INSTANCE:IsDialogOn()
	typecheck.NotImplementedError()
end

function INSTANCE:AllowCinematicSound()
	typecheck.NotImplementedError()
end

function INSTANCE:IsCinematicSoundOn()
	typecheck.NotImplementedError()
end

function INSTANCE:EnableNewSounds()
	typecheck.NotImplementedError()
end

function INSTANCE:AreNewSoundsEnabled()
	typecheck.NotImplementedError()
end

function INSTANCE:TempDisableAudio()
	typecheck.NotImplementedError()
end

function INSTANCE:OnFrameUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:RegisterEosCallback()
	typecheck.NotImplementedError()
end

function INSTANCE:UnRegisterEosCallback()
	typecheck.NotImplementedError()
end

function INSTANCE:RegisterTextCallback()
	typecheck.NotImplementedError()
end

function INSTANCE:UnRegisterTextCallback()
	typecheck.NotImplementedError()
end

function INSTANCE:FireTextCallback()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSoundCached()
	typecheck.NotImplementedError()
end

--- @param file FileInstance
--- @param stringId string
--- @return AudibleSoundInstance
function INSTANCE:CreateSoundEffect( file, stringId )

	-- "Create a new sound object"
	local soundObject = audibleSoundClass.New()
	if self:IsDisabled() == false then
		-- "Try to find the buffer in our cache, otherwise create a new buffer."
		local buffer = self:GetSoundBuffer( file, stringId, false )

		-- "Pass the actual sound data onto the sound object"
	end

	-- "Return a pointer to the sound effect"
	return soundObject
end


--- @return Sound3dInstance
function INSTANCE:Create3dSound()
	typecheck.NotImplementedError()
end

--[[ Background Music Support ]] do

	--- @param fileName string?
	function INSTANCE:SetBackgroundMusic( fileName )
		if self.BackgroundMusic ~= nil then
			self.BackgroundMusic:Stop()
		end

		self.BackgroundMusicName = fileName
		if fileName ~= nil then
			-- "Create the sound"
			self.BackgroundMusic = self:CreateSoundEffect( fileName )
			if self.BackgroundMusic ~= nil then
				-- "Configure the sound and start playing it"
				self.BackgroundMusic:SetPriority( 1.0 )
				self.BackgroundMusic:SetRuntimePriority( 1.0 )
				self.BackgroundMusic:SetLoopCount( INFINITE_LOOPS )
				self.BackgroundMusic:SetType( audibleSoundClass.SOUND_TYPE.TYPE_MUSIC )
				self.BackgroundMusic:CullSound( false )
				self.BackgroundMusic:Play()
			end
		end
	end

	function INSTANCE:FadeBackgroundMusic()
		typecheck.NotImplementedError()
	end

	function INSTANCE:GetBackgroundMusicName()
		typecheck.NotImplementedError()
	end

	function INSTANCE:PeekBackgroundMusic()
		typecheck.NotImplementedError()
	end
end


function INSTANCE:CreateLogicalSound()
	typecheck.NotImplementedError()
end

function INSTANCE:CreateLogicalListener()
	typecheck.NotImplementedError()
end

function INSTANCE:AddLogicalType()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetLogicalTypes()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLogicalTypeCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetLogicalType()
	typecheck.NotImplementedError()
end

--- @param definitionId integer|string
--- @param transform Matrix3dInstance|Vector
--- @param userObject any
--- @param userData integer
--- @param classIdHint integer
function INSTANCE:CreateInstantSound( definitionId, transform, userObject, userData, classIdHint )

	-- Omitting this function's original contents to try to use Source's audio system early

	section.Print( "Creating sound for ", type( definitionId ), " definition ID ", definitionId )

	local definition
	if isstring( definition ) then
		--- @cast definitionId string
		definition = definitionManagerClass.FindTypedDefinition( definitionId, classIdEnum.SOUND, true )
	else
		--- @cast definitionId integer
		definition = definitionManagerClass.FindDefinition( definitionId )
	end
	assert( definition ~= nil )

	local pos
	if isvector( transform ) then
		--- @cast transform Vector
		pos = transform
	else
		--- @cast transform Matrix3dInstance
		pos = transform:GetTranslation()
	end

	if SERVER then
		soundLib.PlaySound( definition.Id, pos, classIdHint )
	else
		-- "Make sure this is really a sound definition"
		assert( definition:GetClassId() == classIdEnum.SOUND )
		if definition:GetClassId() == classIdEnum.SOUND then
			local soundDefinition = definition --[[@as AudibleSoundDefinitionInstance]]

			local fileName = soundDefinition:GetFilename()
			local soundName = "Renegade_" .. fileName

			if STATIC.LoadedSoundBuffers[fileName] == nil then
				local soundBuffer = soundBufferClass.New()
				soundBuffer:LoadFromFile( fileName )
				STATIC.LoadedSoundBuffers[fileName] = soundBuffer
				sound.Generate( soundName, soundBuffer.Rate, soundBuffer.Duration, soundBuffer.DecodedSamples )
			end

			-- How far the sound should be heard in decibels
			-- Needs some kind of 
			local level = math.Clamp(
				soundDefinition.DropOffRadius * unitConversionLib.MetersToSource,
				20, 180
			)

			section.Print( "Level is ", level )

			local pitch = 100 --soundDefinition:GetPitchFactor()
			local volume = 1 --soundDefinition:GetVolume()
			local dsp = 0

			sound.Play( soundName, pos, level, pitch, volume, dsp )
		end
	end

	if definition ~= nil then
	end

	-- Omitting return value here because nothing seems to really be using it
	-- Scripts may use it, but nothing else does at this point and a return value here complicates the Renegade -> Source step
end

function INSTANCE:CreateContinuousSound()
	typecheck.NotImplementedError()
end

--- @param definitionId integer|string
--- @param userObject any? [Default: `nil`]
--- @param userData integer? [Default: `0`]
--- @param classIdHint integer? [Default: `CLASSID_3D`]
--- @return AudibleSoundInstance?
function INSTANCE:CreateSound( definitionId, userObject, userData, classIdHint )
	if userData == nil then userData = 0 end
	if classIdHint == nil then classIdHint = soundClassIdEnum.CLASSID_3D end
	typecheck.AssertArgType( INSTANCE.Class, 1, definitionId, { "string", "number" }  )

	local sound = nil

	-- "Find the definition"
	local definition
	if isstring( definition ) then
		--- @cast definitionId string
		definition = definitionManagerClass.FindTypedDefinition( definitionId, classIdEnum.SOUND, true )
	else
		--- @cast definitionId integer
		definition = definitionManagerClass.FindDefinition( definitionId )
	end

	if definition ~= nil then
		-- "Make sure this is really a sound definition"
		assert( definition:GetClassId() == classIdEnum.SOUND )
		if definition:GetClassId() == classIdEnum.SOUND then
			local soundDefinition = definition --[[@as AudibleSoundDefinitionInstance]]

			-- "Create an instance of the sound"
			sound = soundDefinition:CreateSound( classIdHint )
			if sound ~= nil then
				sound:SetUserData( userObject, userData )
			end
		end
	end

	return sound
end

function INSTANCE:FindSoundObject()
	typecheck.NotImplementedError()
end

--- @return SoundSceneInstance
function INSTANCE:GetSoundScene()
	return self.SoundScene
end

--[[ Cache Methods ]] do

	function INSTANCE:SetCacheSize()
		typecheck.NotImplementedError()
	end

	function INSTANCE:GetCacheSize()
		typecheck.NotImplementedError()
	end

	function INSTANCE:GetCurrentCacheSize()
		typecheck.NotImplementedError()
	end

	function INSTANCE:FlushCache()
		typecheck.NotImplementedError()
	end
end


function INSTANCE:SetMax2dSoundBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMax3dSoundBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:SimplePlay2dSoundEffect()
	typecheck.NotImplementedError()
end

function INSTANCE:AddToPlaylist()
	typecheck.NotImplementedError()
end

--- @param soundObject AudibleSoundInstance
--- @return boolean
function INSTANCE:RemoveFromPlaylist( soundObject )
	local returnValue = false

	if soundObject ~= nil then
		-- "Loop through all the entries in the playlist"
		for page = 1, soundPageEnum.PAGE_COUNT do
			if returnValue == true then break end

			for index = 1, #self.Playlist[page] do
				if returnValue == true then break end
				-- "Is this the entry we are looking for?"
				if tobool( soundObject == self.Playlist[page][index] ) then
					-- "Add this sound to the 'completed' list"
					self.CompletedSounds[#self.CompletedSounds + 1] = soundObject
					returnValue = true
				end
			end
		end

		-- "Notify any callbacks that this sound is ending..."
		if soundObject:GetLoopCount() ~= audibleSoundClass.INFINITE_LOOPS then
			typecheck.NotImplementedError()
		end
	end

	return returnValue
end

function INSTANCE:GetPlaylistCount()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPlaylistEntry()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekPlaylistEntry()
	typecheck.NotImplementedError()
end

function INSTANCE:FlushPlaylist()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSoundInPlaylist()
	typecheck.NotImplementedError()
end

function INSTANCE:AcquireVirtualChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:ReleaseVirtualChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:SetActiveSoundPage()
	typecheck.NotImplementedError()
end

function INSTANCE:GetActiveSoundPage()
	typecheck.NotImplementedError()
end

function INSTANCE:PushActiveSoundPage()
	typecheck.NotImplementedError()
end

function INSTANCE:PopActiveSoundPage()
	typecheck.NotImplementedError()
end

function INSTANCE:FadeNonDialogIn()
	typecheck.NotImplementedError()
end

function INSTANCE:FadeNonDialogOut()
	typecheck.NotImplementedError()
end

function INSTANCE:SetNonDialogFadeTime()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDigitalCpuPercent()
	typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:IsDisabled()
	STATIC._FirstTime = STATIC._FirstTime or true
	STATIC._Disabled = STATIC._Disabled or false

	if STATIC._FirstTime then
		STATIC._FirstTime = false

		-- "Read the disabled key from the registry"
		-- Omitted reading from registry
	end

	return ( STATIC._Disabled or self.ForceDisable )
end

function INSTANCE:Get2dSampleCount()
	typecheck.NotImplementedError()
end

function INSTANCE:Get3dSampleCount()
	typecheck.NotImplementedError()
end

function INSTANCE:Peek2dSample()
	typecheck.NotImplementedError()
end

function INSTANCE:Peek3dSample()
	typecheck.NotImplementedError()
end

function INSTANCE:FreeCompletedSounds()
	typecheck.NotImplementedError()
end

function INSTANCE:Build3dDriverList()
	typecheck.NotImplementedError()
end

function INSTANCE:Free3dDriverList()
	typecheck.NotImplementedError()
end

function INSTANCE:ReprioritizePlaylist()
	typecheck.NotImplementedError()
end

function INSTANCE:Validate3dSoundBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFile()
	typecheck.NotImplementedError()
end

function INSTANCE:ReturnFile()
	typecheck.NotImplementedError()
end

function INSTANCE:Allocate2dHandles()
	typecheck.NotImplementedError()
end

function INSTANCE:Release2dHandles()
	typecheck.NotImplementedError()
end

function INSTANCE:Allocate3dHandles()
	typecheck.NotImplementedError()
end

function INSTANCE:Release3dHandles()
	typecheck.NotImplementedError()
end

function INSTANCE:Get2dSample()
	typecheck.NotImplementedError()
end

function INSTANCE:Get3dSample()
	typecheck.NotImplementedError()
end

function INSTANCE:GetListenerHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:ReAssign2dHandles()
	typecheck.NotImplementedError()
end

function INSTANCE:ReAssign3dHandles()
	typecheck.NotImplementedError()
end

function INSTANCE:Remove2dSoundHandles()
	typecheck.NotImplementedError()
end

function INSTANCE:Remove3dSoundHandles()
	typecheck.NotImplementedError()
end

function INSTANCE:IsOkToGiveHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateFade()
	typecheck.NotImplementedError()
end

--- @param volume number
function INSTANCE:InternalSetSoundEffectsVolume( volume )
	self.SoundVolume = math.Clamp( volume, 0.0, 1.0 )

	-- "Update all the currently playing 'Sound Effects' to reflect this new volume"
	for index = 1, #self.Playlist[self.CurrPage + 1] do
		local soundObject = self.Playlist[self.CurrPage][index] --[[@as AudibleSoundInstance]]
		if soundObject:GetType() == soundTypeEnum.TYPE_SOUND_EFFECT then
			soundObject:UpdateVolume()
		end
	end
end

--- @param volume number
function INSTANCE:InternalSetMusicVolume( volume )
	self.MusicVolume = math.Clamp( volume, 0.0, 1.0 )

	-- "Update all currently playing music to reflect this new volume"
	for index = 1, #self.Playlist[self.CurrPage + 1] do
		local soundObject = self.Playlist[self.CurrPage][index] --[[@as AudibleSoundInstance]]
		if soundObject:GetType() == soundTypeEnum.TYPE_MUSIC then
			soundObject:UpdateVolume()
		end
	end
end

--- @param file FileInstance
--- @param stringId string
--- @param is3d boolean
--- @return SoundBufferInstance
function INSTANCE:GetSoundBuffer( file, stringId, is3d )
	-- "Try to find the buffer in our cache, otherwise create a new buffer."
	local buffer = self:FindCachedBuffer( stringId )
	if buffer == nil then
		buffer = self:CreateSoundBuffer( file, stringId, is3d )
	end

	return buffer
end

--- @param stringId string
--- @return SoundBufferInstance?
function INSTANCE:FindCachedBuffer( stringId )
	typecheck.NotImplementedError()
end

--- @return SoundBufferInstance
function INSTANCE:CreateSoundBuffer(  )
	typecheck.NotImplementedError()
end

function INSTANCE:CacheBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:FreeCacheSpace()
	typecheck.NotImplementedError()
end
