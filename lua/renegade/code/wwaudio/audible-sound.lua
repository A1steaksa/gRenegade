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

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type SaveLoadSystemClass
	local saveLoadSystemClass = CNC.Import( "code/wwsaveload/save-load.lua" )

	--- @type AudioCallbackClass
	local audioCallbackClass = CNC.Import( "code/wwaudio/audio-callback.lua" )
--#endregion

--#region Imported Enums

	local soundChunkIdEnum = soundChunkIds.SOUND_CHUNK_ID
	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
	local audioCallbackEventEnum = audioCallbackClass.AUDIO_CALLBACK_EVENT
--#endregion

--[[ Chunk IDs and Var IDs ]] do

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES	= enumBuilder:Set( 0x00000100 ),
        CHUNKID_BASE_CLASS	= enumBuilder:Next(),
    }

    STATIC.VarIds = {
        VARID_STATE					= enumBuilder:Set( 0x01 ),
        VARID_TYPE					= enumBuilder:Next(),

        VARID_PRIORITY				= enumBuilder:Next(),
        VARID_VOLUME				= enumBuilder:Next(),
        VARID_PAN					= enumBuilder:Next(),
        VARID_LOOP_COUNT			= enumBuilder:Next(),
        VARID_LOOPS_LEFT			= enumBuilder:Next(),
        VARID_SOUND_LENGTH			= enumBuilder:Next(),
        VARID_CURR_POS				= enumBuilder:Next(),
        VARID_TRANSFORM				= enumBuilder:Next(),
        VARID_PREV_TRANSFORM		= enumBuilder:Next(),
        VARID_IS_CULLED				= enumBuilder:Next(),
        VARID_IS_DIRTY				= enumBuilder:Next(),
        VARID_DROP_OFF				= enumBuilder:Next(),
        VARID_FILENAME				= enumBuilder:Next(),
        VARID_THIS_PTR				= enumBuilder:Next(),
        VARID_START_OFFSET			= enumBuilder:Next(),
        VARID_LISTENER_TRANSFORM	= enumBuilder:Next(),
        VARID_PITCH_FACTOR			= enumBuilder:Next(),
        VARID_PITCH_FACTOR_RND		= enumBuilder:Next(),
        VARID_VOLUME_RND			= enumBuilder:Next(),
        VARID_VIRTUAL_CHANNEL		= enumBuilder:Next(),
    }
end

--[[ Static Functions and Variables ]] do

    --- @class AudibleSoundClass
    --- @field GeneratedSounds {[string]: boolean} To avoid trying to generate a sound twice

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
        STATIC.GeneratedSounds = {}

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
--- @field Buffer SoundBufferInstance?
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
--- @field LogicalSound LogicalSoundInstance?

--- @param src AudibleSoundInstance?
function INSTANCE:Renegade_AudibleSound( src )
    soundSceneObjectClass.Instance.Renegade_SoundSceneObject( self )

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
    soundSceneObjectClass.Instance._Renegade_SoundSceneObject( self )

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

--- @return boolean
function INSTANCE:Play()
    -- Omitted verifying playability

    -- Omitted allocating a new handle from miles

    -- "Is the sound already playing?"
    if self.State ~= soundStateEnum.STATE_PLAYING then
        -- "Let the audio system know this sound is playing"
        wWAudioClass.GetInstance():AddToPlaylist( self )
        self.State     = soundStateEnum.STATE_PLAYING
        self.Timestamp = CurTime()
        self.LoopsLeft = self.LoopCount

        --[[ Playing Source Engine Sound ]] do
            if CLIENT then
                local buffer = self.Buffer
                if buffer == nil then
                    section.Error()
                end
                --- @cast buffer SoundBufferInstance

                local soundName = string.lower( "Renegade_" .. buffer:GetFilename() )

                if STATIC.GeneratedSounds[soundName] == nil then
                    STATIC.GeneratedSounds[soundName] = true

                    sound.Generate( soundName, buffer.Rate, buffer.Duration, buffer.DecodedSamples )
                end

                local radius = self:GetDropOffRadius()

                local level = 75
                local pitch = self:GetPitchFactor() * 100
                local volume = self:GetVolume()
                local dsp = 0

                local pos = self:GetPosition() + Vector( 0, 0, 1 )

                sound.Play( soundName, pos, level, pitch, volume, dsp )
            end
        end

        -- "If we have a valid handle, then start playing the sample"
        if self.SoundHandle ~= nil then
            self.SoundHandle:Play()
        end

        self.CurrentPosition = self.StartOffset + self.Length
        if self.CurrentPosition > 0 then
            self:Seek( self.CurrentPosition )
        end

        -- "Fire an event"
        self:OnEvent( audioCallbackEventEnum.EVENT_SOUND_STARTED )

        -- "Create the associate logical sound (if necessary)"
        if self.LogicalSound == nil and self.Definition ~= nil then
            self.LogicalSound = self.Definition:CreateLogical()
        end

        -- "Add this logical sound to the scene"
        if self.LogicalSound ~= nil then
            typecheck.NotImplementedError()
        end

        -- "Should we send off the text notification?"
        if self.IsCulled == false and self.Definition ~= nil then
            local text = self.Definition:GetDisplayText()
            wWAudioClass.GetInstance():FireTextCallback( self, text )
        end
    end

    return true
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
        -- self:FreeMilesHandle()
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

--- @param milliseconds integer
function INSTANCE:Seek( milliseconds )
    if milliseconds >= 0 and milliseconds < self.Length then
        -- "Record our new position and recalculate the 'starting' timestamp from this information"
        self.CurrentPosition = milliseconds
        if self.State == soundStateEnum.STATE_PLAYING then
            self.Timestamp = CurTime() - self.CurrentPosition
        end

        -- "Update the actual sound data if we are playing the sound"
        typecheck.NotImplementedError()
    end
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

--- @return integer
function INSTANCE:GetVirtualChannel()
    return self.VirtualChannel
end

--- @param channel integer
function INSTANCE:SetVirtualChannel( channel )
    self.VirtualChannel = channel
end

--- @return string?
function INSTANCE:GetFilename()
    if self.Buffer ~= nil then
        return self.Buffer:GetFilename()
    end
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

--- @return number
function INSTANCE:GetVolume()
    return self.Volume
end

--- @param volume number
function INSTANCE:SetVolume( volume )
    self:InternalSetVolume( math.Clamp( volume, 0.0, 1.0 ) )
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

--[[ Priority Control ]] do

    --- @return number
    function INSTANCE:GetPriority()
        return self.Priority
    end

    --- @return number
    function INSTANCE:PeekPriority()
        return self.Priority
    end

    --- @param priority number? [Default: `0.5`]
    function INSTANCE:SetPriority( priority )
        if priority == nil then priority = 0.5 end

        -- "Cache the normalized priority"
        self.Priority = math.Clamp( priority, 0, 1.0 )
    end

    --- @return number
    function INSTANCE:GetRuntimePriority()
        return self.RuntimePriority
    end

    --- @param priority number
    function INSTANCE:SetRuntimePriority( priority )
        self.RuntimePriority = priority
    end
end


function INSTANCE:GetPlaybackRate()
    typecheck.NotImplementedError()
end

function INSTANCE:SetPlaybackRate()
    typecheck.NotImplementedError()
end

--- @return number
function INSTANCE:GetPitchFactor()
    return self.PitchFactor
end

--- @param factor number
function INSTANCE:SetPitchFactor( factor )
    self.PitchFactor = factor

    -- Omitted sound handle 
end


--[[ Buffer Position Manipulation ]] do

    --- @return integer
    function INSTANCE:GetDuration()
        return self.Length
    end

    --- @return integer
    function INSTANCE:GetPlayPosition()
        return self.CurrentPosition
    end

    --- @param pos integer
    function INSTANCE:SetPlayPosition( pos )
        if pos <= 1 then
            -- Assume it's a percentage float
            self:Seek( pos * self.Length )
        else
            self:Seek( pos )
        end
    end

    --- @param offset number
    function INSTANCE:SetStartOffset( offset )
        self.StartOffset = offset
    end

    --- @return number
    function INSTANCE:GetStartOffset()
        return self.StartOffset
    end
end

--- @param pos Vector
function INSTANCE:SetPosition( pos )
    self.Transform:SetTranslation( pos )
end

--- @return Vector
function INSTANCE:GetPosition()
    return self.Transform:GetTranslation()
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

--- @param radius number? [Default: `1`]
function INSTANCE:SetDropOffRadius( radius )
    if radius == nil then radius = 1 end

    self.DropOffRadius = radius
    self:SetDirty()
end

--- @return number
function INSTANCE:GetDropOffRadius()
    return self.DropOffRadius
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


--[[ Definition Management ]] do

    --- @param definition AudibleSoundDefinitionInstance
    function INSTANCE:SetDefinition( definition )
        self.Definition = definition
    end

    --- @return AudibleSoundDefinitionInstance
    function INSTANCE:GetDefinition()
        return self.Definition
    end
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

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )

    --- @type {FileName: string}
    local varTable = {}

    while cload:OpenChunk() do
        if cload:CurChunkId() == STATIC.ChunkIds.CHUNKID_BASE_CLASS then
            soundSceneObjectClass.Instance.Load( self, cload )

        elseif cload:CurChunkId() == STATIC.ChunkIds.CHUNKID_VARIABLES then
            local ids = STATIC.VarIds
            local types = fundamentalDataTypeEnum
            -- "Read all the variables from their micro-chunks"
            while cload:OpenMicroChunk() do
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_STATE,                types.Int,     self, "State" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_TYPE,                 types.Int,     self, "Type" )

                chunkIOClass.ReadMicroChunk( cload, ids.VARID_PRIORITY,             types.Float,   self, "Priority" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_VOLUME,               types.Float,   self, "Volume" )

                chunkIOClass.ReadMicroChunk( cload, ids.VARID_PAN, 					types.Float,   self, "Pan" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_LOOP_COUNT, 			types.Int,     self, "LoopCount" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_LOOPS_LEFT, 			types.Int,     self, "LoopsLeft" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_SOUND_LENGTH, 		types.Int,     self, "Length" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_CURR_POS, 			types.Int,     self, "CurrentPosition" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_TRANSFORM, 			"Matrix3d", self, "Transform" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_PREV_TRANSFORM, 		"Matrix3d", self, "PreviousTransform" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_IS_CULLED, 			types.Boolean, self, "IsCulled" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_IS_DIRTY, 			types.Boolean, self, "Dirty" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_DROP_OFF, 			types.Float,   self, "DropOffRadius" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_START_OFFSET, 		types.Float,   self, "StartOffset" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_PITCH_FACTOR, 		types.Float,   self, "PitchFactor" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_LISTENER_TRANSFORM, 	"Matrix3d", self, "ListenerTransform" )
                chunkIOClass.ReadMicroChunk( cload, ids.VARID_VIRTUAL_CHANNEL, 		types.Int,     self, "VirtualChannel" )

                chunkIOClass.ReadMicroChunkWWString( cload, ids.VARID_FILENAME, varTable, "FileName" )

                if cload:CurMicroChunkId() == ids.VARID_THIS_PTR then
                    local oldPointer = cload:ReadFundamentalDataType( fundamentalDataTypeEnum.Pointer )
                    saveLoadSystemClass.RegisterPointer( oldPointer, self )
                end

                cload:CloseMicroChunk()
            end
        end

        cload:CloseChunk()
    end

    -- "Reconstruct the sound buffer we had before we saved"
    if varTable.FileName:len() > 0 then
        local is3d = ( self:AsSound3dClass() ~= nil )
        local buffer = wWAudioClass.GetInstance():GetSoundBuffer( varTable.FileName, is3d )
        self:SetBuffer( buffer )
    end

    return true
end

function INSTANCE:DetermineRealVolume()
    typecheck.NotImplementedError()
end

--- @param volume number
function INSTANCE:InternalSetVolume( volume )
    self.Volume = math.Clamp( volume, 0.0, 1.0 )

    -- Omitted some Miles stuff
end

function INSTANCE:UpdateFade()
    typecheck.NotImplementedError()
end

--- @return boolean
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

    --- @param buffer SoundBufferInstance?
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
        -- self:InitializeMilesHandle()

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
