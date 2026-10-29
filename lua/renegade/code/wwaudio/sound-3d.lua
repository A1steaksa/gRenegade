-- Based on Sound3DClass within Code/WWAudio/Sound3D.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type AudibleSoundClass
local audibleSoundClass = CNC.Import( "code/wwaudio/audible-sound.lua" )

--- @class Sound3dClass : AudibleSoundClass
--- @field Instance Sound3dInstance The metatable used by Sound3DInstance
local STATIC = CNC.CreateExport( audibleSoundClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "Sound3dClass"

--- @class Sound3dInstance : AudibleSoundInstance
--- @field Static Sound3dClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Sound3d : Renegade_AudibleSound" )
INSTANCE.Class = "Sound3dInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSound3D = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SoundChunkIds
	local soundChunkIds = CNC.Import( "code/wwaudio/sound-chunk-ids.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type AudibleSoundClass
	local audibleSoundClass = CNC.Import( "code/wwaudio/audible-sound.lua" )

	--- @type WWAudioClass
	local wWAudioClass = CNC.Import( "code/wwaudio/ww-audio.lua" )
--#endregion

--#region Imported Enums

	local soundChunkIdEnum = soundChunkIds.SOUND_CHUNK_ID
	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
	local soundStateEnum = audibleSoundClass.SOUND_STATE
--#endregion

--[[ Chunk IDs ]] do

	local enumBuilder = enumBuilderClass.New()

	STATIC.ChunkIds = {
		CHUNKID_VARIABLES  = enumBuilder:Set( 0x11090955 ),
		CHUNKID_BASE_CLASS = enumBuilder:Next(),
	}

	STATIC.VarIds = {
		VARID_AUTO_CALC_VEL	 = enumBuilder:Set( 0x01 ),
		VARID_CURR_VEL		 = enumBuilder:Next(),
		VARID_XXX1			 = enumBuilder:Next(),
		VARID_XXX2			 = enumBuilder:Next(),
		VARID_MAX_VOL_RADIUS = enumBuilder:Next(),
		VARID_IS_STATIC		 = enumBuilder:Next(),
	}
end

--[[ Static Functions and Variables ]] do

    --- @class Sound3dClass

    --- Creates a new Sound3DInstance
    --- @return Sound3dInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Sound3d" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) Sound3DInstance, `false` otherwise
    function STATIC.IsSound3d( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSound3D and true or false
    end

    typecheck.RegisterType( "Sound3dInstance", STATIC.IsSound3d )

	function STATIC.StaticConstructor()
        STATIC.Sound3dPersistFactory = simplePersistFactoryClass.New( STATIC, soundChunkIdEnum.CHUNKID_SOUND3D )
    end
end


--- @class Sound3dInstance
--- @field IsTransformInitted boolean
--- @field AutomaticallyCalculateVelocity boolean
--- @field CurrentVelocity Vector
--- @field MaxVolumeRadius number
--- @field _IsStatic boolean
--- @field LastUpdate integer

function INSTANCE:Renegade_Sound3d()
	audibleSoundClass.Instance.Renegade_AudibleSound( self )

	self.AutomaticallyCalculateVelocity = true
	self.CurrentVelocity = Vector( 0, 0, 0 )
	self.MaxVolumeRadius = 0
	self.LastUpdate = 0
	self._IsStatic = false
	self.IsTransformInitted = false
end

function INSTANCE:_Renegade_Sound3d()
	audibleSoundClass.Instance._Renegade_AudibleSound( self )

	typecheck.NotImplementedError()
end

function INSTANCE:GetClassId()
	typecheck.NotImplementedError()
end

function INSTANCE:MakeStatic()
	typecheck.NotImplementedError()
end

function INSTANCE:IsStatic()
	typecheck.NotImplementedError()
end

--- @return Sound3dInstance?
function INSTANCE:AsSound3dClass()
	return self
end

--- @param allocateHandle boolean
--- @return boolean
function INSTANCE:Play( allocateHandle )
	if self.State ~= soundStateEnum.STATE_PLAYING then
		self.LastUpdate = CurTime()
	end

	-- "Allow the base class to process this call"

	return audibleSoundClass.Instance.Play( self )
end

function INSTANCE:GetPriority()
	typecheck.NotImplementedError()
end

--- @param startPlaying boolean
function INSTANCE:AddToScene( startPlaying )
	local scene = wWAudioClass.GetInstance():GetSoundScene()
	if ( scene ~= nil ) and ( self.Scene == nil ) then
		-- "Determine what culling system this sound belongs to"
		if self._IsStatic then
			-- Omitting adding sounds to scenes
			-- scene:AddStaticSound( self, startPlaying )
		else
			-- Omitting adding sounds to scenes
			-- scene:AddSound( self, startPlaying )
		end
		self.Scene = scene
	end
end

function INSTANCE:RemoveFromScene()
	typecheck.NotImplementedError()
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

function INSTANCE:SetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateMilesTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:AutoCalcVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:IsAutoCalcVelocityOn()
	typecheck.NotImplementedError()
end

--- @param radius number
function INSTANCE:SetMaxVolRadius( radius )
	self.MaxVolumeRadius = radius
	self:SetDirty()

	-- Omitted Miles handle stuff
end

function INSTANCE:GetMaxVolRadius()
	typecheck.NotImplementedError()
end

--- @param radius number
function INSTANCE:SetDropOffRadius( radius )
	self.DropOffRadius = radius
	self:SetDirty()

	-- Omitted Miles stuff 
end

--- @return number
function INSTANCE:GetDropOffRadius()
	return self.DropOffRadius
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
	while cload:OpenChunk() do
		if cload:CurChunkId() == STATIC.ChunkIds.CHUNKID_BASE_CLASS then
			audibleSoundClass.Instance.Load( self, cload )

		elseif cload:CurChunkId() == STATIC.ChunkIds.CHUNKID_VARIABLES then
			-- "Read all the variables from their micro-chunks"
			local varIds = STATIC.VarIds
			while cload:OpenMicroChunk() do
				chunkIOClass.ReadMicroChunk( cload, varIds.VARID_AUTO_CALC_VEL, fundamentalDataTypeEnum.Boolean, self, "AutomaticallyCalculateVelocity" )
				chunkIOClass.ReadMicroChunk( cload, varIds.VARID_CURR_VEL, "Vector3", self, "CurrentVelocity" )
				chunkIOClass.ReadMicroChunk( cload, varIds.VARID_MAX_VOL_RADIUS, fundamentalDataTypeEnum.Float, self, "MaxVolumeRadius" )
				chunkIOClass.ReadMicroChunk( cload, varIds.VARID_IS_STATIC, fundamentalDataTypeEnum.Boolean, self, "_IsStatic" )

				cload:CloseMicroChunk()
			end
		end

		cload:CloseChunk()
	end

	return true
end

function INSTANCE:PeekCullableWrapper()
	typecheck.NotImplementedError()
end

function INSTANCE:SetCullableWrapper()
	typecheck.NotImplementedError()
end

function INSTANCE:OnFrameUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateEdgeVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:InitializeMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:AllocateMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:OnLoopEnd()
	typecheck.NotImplementedError()
end
