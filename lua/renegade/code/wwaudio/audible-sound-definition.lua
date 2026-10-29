-- Based on AudibleSoundDefinitionClass within Code/WWAudio/AudibleSound.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class AudibleSoundDefinitionClass : DefinitionClass
--- @field Instance AudibleSoundDefinitionInstance The metatable used by AudibleSoundDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AudibleSoundDefinitionClass"

--- @class AudibleSoundDefinitionInstance : DefinitionInstance
--- @field Static AudibleSoundDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AudibleSoundDefinition : Renegade_Definition" )
INSTANCE.Class = "AudibleSoundDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAudibleSoundDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type WWAudioClass
	local wWAudioClass = CNC.Import( "code/wwaudio/ww-audio.lua" )

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SimpleDefinitionFactoryClass
	local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

	--- @type SoundChunkIds
	local soundChunkIds = CNC.Import( "code/wwaudio/sound-chunk-ids.lua" )

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type AudibleSoundClass
	local audibleSoundClass = CNC.Import( "code/wwaudio/audible-sound.lua" )

	--- @type RenderObjectClass
	local renderObjectClass = CNC.Import( "code/ww3d2/render-object.lua" )

	--- @type DefinitionClassIds
	local definitionClassIds = CNC.Import( "code/wwsaveload/definition-class-ids.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
	local soundChunkIdEnum = soundChunkIds.SOUND_CHUNK_ID
	local soundTypeEnum = audibleSoundClass.SOUND_TYPE
	local soundClassIdEnum = wWAudioClass.SOUND_CLASSID
--#endregion


--[[ Chunk IDs ]] do

	local enumBuilder = enumBuilderClass.New()

	STATIC.ChunkIds = {
		CHUNKID_VARIABLES	= 0x00000100,
		CHUNKID_BASE_CLASS	= 0x00000200,
	}

	STATIC.VarIds = {
	VARID_UNUSED1			= enumBuilder:Set( 0x01 ),
	VARID_UNUSED2			= enumBuilder:Next(),
	VARID_PRIORITY			= enumBuilder:Next(),
	VARID_VOLUME			= enumBuilder:Next(),
	VARID_PAN				= enumBuilder:Next(),
	VARID_LOOP_COUNT		= enumBuilder:Next(),
	VARID_DROP_OFF			= enumBuilder:Next(),
	VARID_MAX_VOL			= enumBuilder:Next(),
	VARID_TYPE				= enumBuilder:Next(),
	VARID_IS3D				= enumBuilder:Next(),
	VARID_FILENAME			= enumBuilder:Next(),
	VARID_DISPLAY_TEXT		= enumBuilder:Next(),
	VARID_LOGICAL_MASK		= enumBuilder:Next(),
	VARID_LOGICAL_DELAY		= enumBuilder:Next(),
	VARID_CREATE_LOGICAL	= enumBuilder:Next(),
	VARID_LOGICAL_DROP_OFF	= enumBuilder:Next(),
	VARID_SPHERE_COLOR		= enumBuilder:Next(),
	VARID_START_OFFSET		= enumBuilder:Next(),
	VARID_PITCH_FACTOR		= enumBuilder:Next(),
	VARID_PITCH_FACTOR_RND	= enumBuilder:Next(),
	VARID_VOLUME_RND		= enumBuilder:Next(),
	VARID_VIRTUAL_CHANNEL	= enumBuilder:Next(),
	}
end


--[[ Static Functions and Variables ]] do

    --- @class AudibleSoundDefinitionClass

    --- Creates a new AudibleSoundDefinitionInstance
    --- @return AudibleSoundDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_AudibleSoundDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AudibleSoundDefinitionInstance, `false` otherwise
    function STATIC.IsAudibleSoundDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAudibleSoundDefinition and true or false
    end

    typecheck.RegisterType( "AudibleSoundDefinitionInstance", STATIC.IsAudibleSoundDefinition )

	function STATIC.StaticConstructor()
        STATIC.AudibleSoundDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, soundChunkIds.CLASSID_SOUND_DEF, "Sound" )
        STATIC.AudibleSoundDefinitionPersistFactory = simplePersistFactoryClass.New( STATIC, soundChunkIdEnum.CHUNKID_SOUND_DEF )
    end
end


--- @class AudibleSoundDefinitionInstance
--- @field Priority number
--- @field Volume number
--- @field VolumeRandomizer number
--- @field Pan number
--- @field LoopCount integer
--- @field VirtualChannel integer
--- @field DropOffRadius number
--- @field MaxVolRadius number
--- @field Is3d boolean
--- @field Filename string
--- @field Type SoundType
--- @field DisplayText string
--- @field StartOffset number
--- @field PitchFactor number
--- @field PitchFactorRandomizer number
--- @field LogicalTypeMask integer
--- @field LogicalNotifyDelay number
--- @field LogicalDropOffRadius number
--- @field _CreateLogical boolean
--- @field AttenuationSphereColor Vector

function INSTANCE:Renegade_AudibleSoundDefinition()
	self.Priority = 0.5
	self.Volume = 1.0
	self.Pan = 0.5
	self.LoopCount = 1
	self.DropOffRadius = 40.0
	self.LogicalDropOffRadius = -1.0
	self.MaxVolRadius = 20.0
	self.Is3d = true
	self.Type = soundTypeEnum.TYPE_SOUND_EFFECT
	self.LogicalTypeMask = 0
	self.LogicalNotifyDelay = 2
	self._CreateLogical = false
	self.AttenuationSphereColor = Vector( 0, 0.75, 0.75 )
	self.StartOffset = 0
	self.PitchFactor = 1.0
	self.PitchFactorRandomizer = 0.0
	self.VolumeRandomizer = 0.0
	self.VirtualChannel = 0
end

function INSTANCE:_Renegade_AudibleSoundDefinition()
	typecheck.NotImplementedError()
end

--- @return RenderObjectClassId
function INSTANCE:GetClassId()
	return definitionClassIds.CLASS_ID.SOUND
end

--- @return PersistFactoryInstance
function INSTANCE:GetFactory()
	return STATIC.AudibleSoundDefinitionPersistFactory
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
	local returnValue = true

	while cload:OpenChunk() do
		local id = cload:CurChunkId()
		if id == STATIC.ChunkIds.CHUNKID_VARIABLES then
			returnValue = returnValue and INSTANCE.LoadVariables( self, cload )
		elseif id == STATIC.ChunkIds.CHUNKID_BASE_CLASS then
			returnValue = returnValue and definitionClass.Instance.Load( self, cload )
		end
		cload:CloseChunk()
	end

	return returnValue
end

--- @return PersistInstance
function INSTANCE:Create()
	return self:CreateSound( soundClassIdEnum.CLASSID_3D )
end

--- @param classIdHint SoundClassId
--- @return AudibleSoundInstance
function INSTANCE:CreateSound( classIdHint )
	local newSound

	-- "If this is a relative path, strip it off and assume the current directory is set correctly."
	local fileName = self.Filename
	local slashIndex = textUtils.LastIndexOf( self.Filename, "\\" )
	if slashIndex and #fileName > 2 then
		fileName = fileName:sub( slashIndex + 1 )
	end

	section.Print( "Creating audible sound for file '", fileName, "'" )

	-- "Should we create a 2D or 3D sound?"
	if self.Is3d and classIdHint ~= soundClassIdEnum.CLASSID_2D then
		newSound = wWAudioClass.GetInstance():Create3dSound( fileName, classIdHint )
	else
		newSound = wWAudioClass.GetInstance():CreateSoundEffect( fileName )
	end

	-- "Did we successfully create the sound?"
	if newSound ~= nil then

		-- "Configure the sound"
		newSound:SetType( self.Type --[[@as SoundType]] )
		newSound:SetPriority( self.Priority )
		newSound:SetLoopCount( self.LoopCount )
		newSound:SetDropOffRadius( self.DropOffRadius )
		newSound:SetDefinition( self )
		newSound:SetStartOffset( self.StartOffset )
		newSound:SetVirtualChannel( self.VirtualChannel )

		-- "Randomize the volume and pitch as necessary"
		local volume = self.Volume
		if self.VolumeRandomizer ~= 0 then
			volume = volume + math.Rand( -self.VolumeRandomizer, self.VolumeRandomizer )
		end

		local pitchFactor = self.PitchFactor
		if self.PitchFactor ~= 0 then
			pitchFactor = pitchFactor + math.Rand( -self.PitchFactorRandomizer, self.PitchFactorRandomizer )
		end

		-- "Set the volume and pitch"
		newSound:SetVolume( volume )
		newSound:SetPitchFactor( pitchFactor )

		if newSound:AsSound3dClass() then
			--- @cast newSound Sound3dInstance
			newSound:SetMaxVolRadius( self.MaxVolRadius )
		end
	end

	return newSound
end

function INSTANCE:InitializeFromSound()
	typecheck.NotImplementedError()
end

--- @return string
function INSTANCE:GetFilename()
	return self.Filename
end

function INSTANCE:GetDisplayText()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaxVolRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSphereColor()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVolumeRandomizer()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStartOffset()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPitchFactor()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPitchFactorRandomizer()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVirtualChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVolumeRandomizer()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMaxVolRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:SetStartOffset()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPitchFactor()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPitchFactorRandomizer()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVirtualChannel()
	typecheck.NotImplementedError()
end

--- @return LogicalSoundInstance?
function INSTANCE:CreateLogical()
	local logicalSound

	if self._CreateLogical then
		typecheck.NotImplementedError()
	end

	return logicalSound
end

function INSTANCE:SaveVariables()
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:LoadVariables( cload )
	-- "Loop through all the microchunks that define the variables"
	while cload:OpenMicroChunk() do
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_PRIORITY, fundamentalDataTypeEnum.Float, self, "Priority" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_VOLUME, fundamentalDataTypeEnum.Float, self, "Volume" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_PAN, fundamentalDataTypeEnum.Float, self, "Pan" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_LOOP_COUNT, fundamentalDataTypeEnum.Int, self, "LoopCount" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_DROP_OFF, fundamentalDataTypeEnum.Float, self, "DropOffRadius" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_MAX_VOL, fundamentalDataTypeEnum.Float, self, "MaxVolRadius" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_TYPE, fundamentalDataTypeEnum.Int, self, "Type" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_IS3D, fundamentalDataTypeEnum.Boolean, self, "Is3d" )
		chunkIOClass.ReadMicroChunkString( cload, STATIC.VarIds.VARID_FILENAME, self, "Filename" )
		chunkIOClass.ReadMicroChunkString( cload, STATIC.VarIds.VARID_DISPLAY_TEXT, self, "DisplayText" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_LOGICAL_MASK, fundamentalDataTypeEnum.Int, self, "LogicalTypeMask" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_LOGICAL_DELAY, fundamentalDataTypeEnum.Float, self, "LogicalNotifyDelay" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_CREATE_LOGICAL, fundamentalDataTypeEnum.Boolean, self, "_CreateLogical" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_LOGICAL_DROP_OFF, fundamentalDataTypeEnum.Float, self, "LogicalDropOffRadius" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_SPHERE_COLOR, "Vector3", self, "AttenuationSphereColor" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_START_OFFSET, fundamentalDataTypeEnum.Float, self, "StartOffset" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_PITCH_FACTOR, fundamentalDataTypeEnum.Float, self, "PitchFactor" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_PITCH_FACTOR_RND, fundamentalDataTypeEnum.Float, self, "PitchFactorRandomizer" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_VOLUME_RND, fundamentalDataTypeEnum.Float, self, "VolumeRandomizer" )
		chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_VIRTUAL_CHANNEL, fundamentalDataTypeEnum.Int, self, "VirtualChannel" )

		cload:CloseMicroChunk()
	end

	return true
end
