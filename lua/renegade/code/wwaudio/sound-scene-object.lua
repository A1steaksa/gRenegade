-- Based on SoundSceneObjClass within Code/WWAudio/SoundSceneObj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

--- @class SoundSceneObjectClass : PersistClass
--- @field Instance SoundSceneObjectInstance The metatable used by SoundSceneObjectInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SoundSceneObjectClass"

--- @class SoundSceneObjectInstance : PersistInstance
--- @field Static SoundSceneObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SoundSceneObject : Renegade_Persist" )
INSTANCE.Class = "SoundSceneObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSoundSceneObject = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type PersistClass
	local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

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

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
	local audioCallbackEventEnum = audioCallbackClass.AUDIO_CALLBACK_EVENT
--#endregion


--[[ Chunk IDs ]] do

	local enumBuilder = enumBuilderClass.New()

	STATIC.ChunkIds = {
		CHUNKID_VARIABLES	= enumBuilder:Set( 0x03270459 ),
		CHUNKID_BASE_CLASS	= enumBuilder:Next(),
	}

	STATIC.VarIds = {
		VARID_ATTACHED_OBJ	= enumBuilder:Set( 0x01 ),
		VARID_ATTACHED_BONE	= enumBuilder:Next(),
		VARID_USER_DATA		= enumBuilder:Next(),
		VARID_USER_OBJ		= enumBuilder:Next(),
		VARID_ID			= enumBuilder:Next(),
	}
end


--[[ Static Functions and Variables ]] do

    --- @class SoundSceneObjectClass
	--- @field GlobalSoundList SoundSceneObjectInstance[]

	STATIC.NextAvailableId = 1000000000

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

	function STATIC.StaticConstructor()
		STATIC.GlobalSoundList = {}
	end

	--- @param soundObject SoundSceneObjectInstance
	function STATIC.RegisterSoundObject( soundObject )
		local id = soundObject.Id

		-- "Special case a non-ID"
		if id == 0 then
			STATIC.GlobalSoundList[1] = soundObject
		else
			-- Check to ensure the object isn't already in the list
			local existingKey = table.KeyFromValue( STATIC.GlobalSoundList, soundObject )
			if existingKey == nil then
				-- "Insert the object into the list"
				STATIC.GlobalSoundList[#STATIC.GlobalSoundList] = soundObject
			end
		end
	end

	function STATIC.UnregisterSoundObject()
		typecheck.NotImplementedError()
	end

	function STATIC.FindSoundObject( id )
		typecheck.NotImplementedError()
	end
end


--- @class SoundSceneObjectInstance
--- @field Scene SoundSceneInstance
--- @field PhysicsWrapper SoundCullObjectInstance
--- @field Callback AudioCallbackInstance
--- @field RegisteredEvents AudioCallbackEvent
--- @field Id integer
--- @field AttachedObject RenderObjectInstance
--- @field AttachedBone integer
--- @field UserData integer
--- @field UserObject any

function INSTANCE:Renegade_SoundSceneObject()
	self.Scene = nil
	self.PhysicsWrapper = nil
	self.Callback = nil
	self.AttachedObject = nil
	self.UserData = 0
	self.UserObject = nil
	self.Id = 0
	self.RegisteredEvents = nil

	self.Id = STATIC.NextAvailableId
	STATIC.NextAvailableId = STATIC.NextAvailableId + 1

	STATIC.RegisterSoundObject( self )
end

function INSTANCE:_Renegade_SoundSceneObject()
	typecheck.NotImplementedError()
end

--- @return Sound3dInstance?
function INSTANCE:AsSound3dClass()
	return nil
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

--[[ Identification Methods ]] do

	--- @return integer
	function INSTANCE:GetId()
		return self.Id
	end

	--- @param id integer
	function INSTANCE:SetId( id )
		typecheck.NotImplementedError()
	end
end


function INSTANCE:OnFrameUpdate()
	typecheck.NotImplementedError()
end

--- @param event AudioCallbackEvent
--- @param param1 integer
--- @param param2 integer
function INSTANCE:OnEvent( event, param1, param2 )
	if self.Callback ~= nil and tobool( bit.band( self.RegisteredEvents, event ) ) then
		if event == audioCallbackEventEnum.EVENT_SOUND_STARTED then
			self.Callback:OnSoundStarted( self )
		elseif event == audioCallbackEventEnum.EVENT_SOUND_ENDED then
			self.Callback:OnSoundEnded( self )
		elseif event == audioCallbackEventEnum.EVENT_LOGICAL_HEARD then
			self.Callback:OnLogicalHeard( param1, param2 )
		end
	end
end

function INSTANCE:RegisterCallback()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveCallback()
	typecheck.NotImplementedError()
end

--- @param pos Vector
function INSTANCE:SetPosition( pos )
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

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
	local varTable = { id = 0 }

	while cload:OpenChunk() do

		local id = cload:CurChunkId()

		if id == STATIC.ChunkIds.CHUNKID_BASE_CLASS then
			persistClass.Instance.Load( self, cload )

		elseif id == STATIC.ChunkIds.CHUNKID_VARIABLES then
			-- "Read all the variables from their micro-chunks"
			while cload:OpenMicroChunk() do
				local microChunkId = cload:CurMicroChunkId()
				chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_ATTACHED_OBJ, fundamentalDataTypeEnum.Pointer, self, "AttachedObject" )
				chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_ATTACHED_BONE, fundamentalDataTypeEnum.Int, self, "AttachedBone" )
				chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_USER_DATA, fundamentalDataTypeEnum.UInt32, self, "UserData" )
				chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_USER_OBJ, fundamentalDataTypeEnum.Pointer, self, "UserObject" )
				chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_ID, fundamentalDataTypeEnum.UInt32, self, "Id" )
				cload:CloseMicroChunk()
			end
		end
		cload:CloseChunk()
	end

	-- "Set the ID (this will cause the sound object to be re-inserted in the master sorted list)"
	if varTable.id ~= 0 then
		self:SetId( varTable.id )
	end

	-- Ommit setting an ID

	if self.AttachedObject ~= nil and self.AttachedObject ~= 0 then
		saveLoadSystemClass.RequestRefCountedPointerRemap( self.AttachedObject )
	end

	return true
end

function INSTANCE:PeekCullableWrapper()
	typecheck.NotImplementedError()
end

function INSTANCE:SetCullableWrapper()
	typecheck.NotImplementedError()
end
