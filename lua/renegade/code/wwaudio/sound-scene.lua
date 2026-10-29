-- Based on SoundSceneClass within Code/WWAudio/SoundScene.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class SoundSceneClass
--- @field Instance SoundSceneInstance The metatable used by SoundSceneInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SoundSceneClass"

--- @class SoundSceneInstance
--- @field Static SoundSceneClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SoundScene" )
INSTANCE.Class = "SoundSceneInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSoundScene = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type SaveLoadSystemClass
	local saveLoadSystemClass = CNC.Import( "code/wwsaveload/save-load.lua" )

	--- @type Listener3dClass
	local listener3dClass = CNC.Import( "code/wwaudio/listener-3d.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Chunk IDs ]] do

	local enumBuilder = enumBuilderClass.New()

	STATIC.ChunkIds = {
		CHUNKID_VARIABLES			= enumBuilder:Set( 0x00000100 ),
		CHUNKID_STATIC_SOUNDS		= enumBuilder:Next(),
		CHUNKID_DYNAMIC_SOUNDS		= enumBuilder:Next(),
	}

	STATIC.VarIds = {
		VARID_MIN_DIM = enumBuilder:Set( 0x01 ),
		VARID_MAX_DIM = enumBuilder:Next(),
	}
end

--[[ Static Functions and Variables ]] do

    --- @class SoundSceneClass

    --- Creates a new SoundSceneInstance
    --- @return SoundSceneInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SoundScene" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SoundSceneInstance, `false` otherwise
    function STATIC.IsSoundScene( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSoundScene and true or false
    end

    typecheck.RegisterType( "SoundSceneInstance", STATIC.IsSoundScene )
end


--- @class SoundSceneInstance
--- @field Listener Listener3dInstance
--- @field SecondListener Listener3dInstance
--- @field LastSoundsAudible AudibleSoundListInstance
--- @field DynamicSounds SoundListInstance
--- @field StaticSounds SoundListInstance
--- @field LogicalSounds LogicalSoundListInstance
--- @field SingleShotLogicalSounds LogicalSoundListInstance
--- @field LogicalListeners LogicalListenerListInstance
--- @field ListenerCullingSystem DynamicSoundCullInstance
--- @field LogicalCullingSystem DynamicSoundCullInstance
--- @field DynamicCullingSystem DynamicSoundCullInstance
--- @field StaticCullingSystem StaticSoundCullInstance
--- @field MinExtents Vector
--- @field MaxExtents Vector
--- @field _IsBatchMode boolean

function INSTANCE:Renegade_SoundScene()
	self.Listener = nil
	self.SecondListener = nil
	self.MinExtents = Vector( -500. -500, -500 )
	self.MaxExtents = Vector( 500, 500, 500 )
	self._IsBatchMode = false

	self.Listener = listener3dClass.New()
	-- Omitted repartitioning culling system
end

function INSTANCE:_Renegade_SoundScene()
	typecheck.NotImplementedError()
end

--- @param minDimension Vector
--- @param maxDimension Vector
function INSTANCE:RePartition( minDimension, maxDimension )
	-- Omitted repartitioning culling systems

	self.MinExtents = minDimension
	self.MaxExtents = maxDimension
end

function INSTANCE:CollectLogicalSounds()
	typecheck.NotImplementedError()
end

function INSTANCE:AttachListenerToObject()
	typecheck.NotImplementedError()
end

function INSTANCE:SetListenerPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetListenerPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:SetListenerTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:GetListenerTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:Peek2NdListener()
	typecheck.NotImplementedError()
end

function INSTANCE:Set2NdListener()
	typecheck.NotImplementedError()
end

function INSTANCE:FlushScene()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateSound()
	typecheck.NotImplementedError()
end

function INSTANCE:AddSound()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveSound()
	typecheck.NotImplementedError()
end

function INSTANCE:AddStaticSound()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveStaticSound()
	typecheck.NotImplementedError()
end

function INSTANCE:AddLogicalSound()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveLogicalSound()
	typecheck.NotImplementedError()
end

function INSTANCE:AddLogicalListener()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveLogicalListener()
	typecheck.NotImplementedError()
end

--- @param csave ChunkSaveInstance
--- @return boolean
function INSTANCE:SaveStatic( csave )
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:LoadStatic( cload )
	self._IsBatchMode = true

	while cload:OpenChunk() do
		local id = cload:CurChunkId()
		if id == STATIC.ChunkIds.CHUNKID_STATIC_SOUNDS then
			self:LoadStaticSounds( cload )

		elseif id == STATIC.ChunkIds.CHUNKID_VARIABLES then
			-- "Read all the variables from their micro-chunks"
			while cload:OpenMicroChunk() do
				local microId = cload:CurMicroChunkId()
				chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_MIN_DIM, "Vector3", self, "MinExtents" )
				chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_MAX_DIM, "Vector3", self, "MaxExtents" )

				cload:CloseMicroChunk()
			end
		end

		cload:CloseChunk()
	end

	self:RePartition( self.MinExtents, self.MaxExtents )
	
	
	
	-- Omitted call to OnFrameUpdate
	-- self:OnFrameUpdate( 0 )

	
	self._IsBatchMode = false
	return true
end

--- @param csave ChunkSaveInstance
--- @return boolean
function INSTANCE:SaveDynamic( csave )
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:LoadDynamic( cload )
	return true
end

function INSTANCE:IsBatchMode()
	typecheck.NotImplementedError()
end

function INSTANCE:SetBatchMode()
	typecheck.NotImplementedError()
end

function INSTANCE:IsSoundInScene()
	typecheck.NotImplementedError()
end

function INSTANCE:OnFrameUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:Initialize()
	typecheck.NotImplementedError()
end

function INSTANCE:IsLogicalSoundInScene()
	typecheck.NotImplementedError()
end

function INSTANCE:SaveStaticSounds()
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
function INSTANCE:LoadStaticSounds( cload )
	while cload:OpenChunk() do
		-- "Load this sound from the chunk (if possible)"
		local factory = saveLoadSystemClass.FindPersistFactory( cload:CurChunkId() )
		if factory ~= nil then
			local soundObject = factory:Load( cload ) --[[@as AudibleSoundInstance]]
			if soundObject ~= nil then
				soundObject:AddToScene( true )
			end
		end

		cload:CloseChunk()
	end
end

function INSTANCE:CollectAudibleSounds()
	typecheck.NotImplementedError()
end
