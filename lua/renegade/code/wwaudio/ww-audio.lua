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

--#endregion

--#region Imports

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

	--- @type DefinitionClassIds
	local definitionClassIds = CNC.Import( "code/wwsaveload/definition-class-ids.lua" )
--#endregion

--#region Imported Enums

	local classIdEnum = definitionClassIds.CLASS_ID
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class WWAudioClass
	--- @field TheInstance WWAudioInstance
	--- @field TimerSyncEvent HandleInstance

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
--- @field MPlaybackRate integer
--- @field MPlaybackBits integer
--- @field MPlaybackStereo boolean
--- @field MMusicVolume number
--- @field MSoundVolume number
--- @field MRealMusicVolume number
--- @field MRealSoundVolume number
--- @field MDialogVolume number
--- @field MCinematicVolume number
--- @field MMax2dsAmples integer
--- @field MMax3dsAmples integer
--- @field MMax2dbUfferSize integer
--- @field MMax3dbUfferSize integer
--- @field MUpdateTimer HtimerInstance
--- @field MIsMusicEnabled boolean
--- @field MIsDialogEnabled boolean
--- @field MIsCinematicSoundEnabled boolean
--- @field MAreSoundEffectsEnabled boolean
--- @field MAreNewSoundsEnabled boolean
--- @field MFileFactory FileFactoryInstance
--- @field MBackgroundMusic AudibleSoundInstance
--- @field MBackgroundMusicName string
--- @field MCachedIsMusicEnabled boolean
--- @field MCachedIsDialogEnabled boolean
--- @field MCachedIsCinematicSoundEnabled boolean
--- @field MCachedAreSoundEffectsEnabled boolean
--- @field MEosCallbackList AudioCallbackListClassLPFNEOSCALLBACKInstance
--- @field MTextCallbackList AudioCallbackListClassLPFNTEXTCALLBACKInstance
--- @field MSoundScene SoundSceneInstance
--- @field MCurrPage SoundPageInstance
--- @field MPageStack SoundPageInstance[]
--- @field MDriver2d HdigdriverInstance
--- @field MDriver3d HproviderInstance
--- @field MDriver3dpSeudo HproviderInstance
--- @field MReverbFilter HproviderInstance
--- @field MDriver3dlIst DriverInfoStructInstance[]
--- @field MDriver3dnAme string
--- @field MSpeakerType integer
--- @field M2dsAmpleHandles HsampleInstance[]
--- @field M3dsAmpleHandles H3dsampleInstance[]
--- @field MPlaylist AudibleSoundInstance[]
--- @field MCompletedSounds AudibleSoundInstance[]
--- @field MVirtualChannels AudibleSoundInstance[]
--- @field MCachedBuffers CacheEntryStructInstance[]
--- @field MMaxCacheSize integer
--- @field MCurrentCacheSize integer
--- @field MLogicalTypes LogicalTypeStructInstance[]
--- @field MEffectsLevel number
--- @field MReverbRoomType integer
--- @field MNonDialogFadeTime number
--- @field MFadeType FadeTypeInstance
--- @field MFadeTimer number
--- @field AudioIni IniInstance
--- @field MForceDisable boolean

--- @param lite boolean? [Default: `false`]
function INSTANCE:Renegade_WWAudio( lite )
	if lite == nil then lite = false end

	typecheck.NotImplementedError()
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
		typecheck.NotImplementedError()

	-- ( stereo: boolean?, bits: integer?, hertz: integer? )
	else
		local stereo = args[1] or true
		local bits   = args[2] or 16
		local hertz  = args[3] or 44100

		typecheck.NotImplementedError()
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

function INSTANCE:SetSoundEffectsVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSoundEffectsVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMusicVolume()
	typecheck.NotImplementedError()
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

function INSTANCE:CreateSoundEffect()
	typecheck.NotImplementedError()
end

function INSTANCE:CreateSoundEffect()
	typecheck.NotImplementedError()
end

function INSTANCE:Create3dSound()
	typecheck.NotImplementedError()
end

function INSTANCE:Create3dSound()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBackgroundMusic()
	typecheck.NotImplementedError()
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

--- @param definitionId integer
--- @param transformationMatrix Matrix3dInstance
--- @param userObject any
--- @param userData integer
--- @param classIdHint integer
function INSTANCE:CreateInstantSound( definitionId, transformationMatrix, userObject, userData, classIdHint )
	
	local soundId = 0

	-- "Create an instance of the sound and play it"
	local sound = self:CreateSound( definitionId, userObject, userData, classIdHint )
	if sound ~= nil then
		
	end
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

function INSTANCE:GetSoundScene()
	typecheck.NotImplementedError()
end

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

function INSTANCE:RemoveFromPlaylist()
	typecheck.NotImplementedError()
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

function INSTANCE:IsDisabled()
	typecheck.NotImplementedError()
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

function INSTANCE:InternalSetSoundEffectsVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:InternalSetMusicVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSoundBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:FindCachedBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:CreateSoundBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:CacheBuffer()
	typecheck.NotImplementedError()
end

function INSTANCE:FreeCacheSpace()
	typecheck.NotImplementedError()
end
