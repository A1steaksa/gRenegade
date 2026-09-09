-- Based on TextureLoadTaskClass within Code/ww3d2/textureloader.h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Omitted parent class 'TextureLoadTaskListNodeClass' because I don't think it's necessary

--- @class TextureLoadTaskClass
--- @field Instance TextureLoadTaskInstance The metatable used by TextureLoadTaskInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TextureLoadTaskClass"

--- @class TextureLoadTaskInstance
--- @field Static TextureLoadTaskClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_TextureLoadTask" )
INSTANCE.Class = "TextureLoadTaskInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsTextureLoadTask = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type WW3dFileFormatIds
	local wW3dFileFormatIds = CNC.Import( "code/ww3d2/ww3d-format.lua" )

	--- @type TextureLoaderClass
	local textureLoaderClass = CNC.Import( "code/ww3d2/texture-loader.lua" )

	--- @type TextureClass
	local textureClass = CNC.Import( "code/ww3d2/texture.lua" )

	--- @type FormatConverterLib
	local formatConverterLib = CNC.Import( "code/ww3d2/format-converter.lua" )

	--- @type DDSFileClass
	local dDSFileClass = CNC.Import( "code/ww3d2/dds-file.lua" )
--#endregion

--#region Imported Enums

	local wW3dFormatEnum = wW3dFileFormatIds.WW3D_FORMAT
	local taskTypeEnum = textureLoaderClass.TASK_TYPE
	local priorityTypeEnum = textureLoaderClass.PRIORITY_TYPE
	local stateTypeEnum = textureLoaderClass.STATE_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class TextureLoadTaskClass

    --- Creates a new TextureLoadTaskInstance
    --- @return TextureLoadTaskInstance
    function STATIC.New()
        return robustclass.New( "Renegade_TextureLoadTask" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) TextureLoadTaskInstance, `false` otherwise
    function STATIC.IsTextureLoadTask( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsTextureLoadTask and true or false
    end

    typecheck.RegisterType( "TextureLoadTaskInstance", STATIC.IsTextureLoadTask )

	--- @param texture TextureInstance
	--- @param type TaskType
	--- @param priority PriorityType
	--- @return TextureLoadTaskInstance
	function STATIC.Create( texture, type, priority )
		-- "Recycle or create a new texture load task with the given type and priority, then associate the texture with the task."

		-- "Pull a load task from front of free list"
		local task = table.remove( textureLoaderClass.FreeList, 1 )

		-- "If no tasks on free list, allocate a new task"
		if task == nil then
			task = STATIC.New()
		end

		task:Init( texture, type, priority )

		return task
	end

	function STATIC.DeleteFreePool()
		typecheck.NotImplementedError()
	end
end


--- @class TextureLoadTaskInstance
--- @field Texture TextureInstance
--- @field RenderTarget ITexture
--- @field Format WW3dFormat
--- @field Width integer
--- @field Height integer
--- @field MipLevelCount integer
--- @field Reduction integer
--- @field LockedSurfacePointer string[]
--- @field LockedSurfacePitch integer[]
--- @field Type TaskType
--- @field Priority PriorityType
--- @field State StateType

function INSTANCE:Renegade_TextureLoadTask()
	self.Texture = nil
	self.RenderTarget = nil
	self.Format = wW3dFormatEnum.WW3D_FORMAT_UNKNOWN
	self.Width = 0
	self.Height = 0
	self.MipLevelCount = 0
	self.Reduction = 0
	self.Type = taskTypeEnum.TASK_NONE
	self.Priority = priorityTypeEnum.PRIORITY_LOW
	self.State = stateTypeEnum.STATE_NONE

	self.LockedSurfacePointer = {}
	self.LockedSurfacePitch = {}

	-- "  
	-- Because texture load tasks are pooled, the constructor and destructor don't need to do much.
	-- The work of attaching a task to a texture is is done by Init() and Deinit().
	-- "  
	for i = 1, textureClass.MIP_COUNT_TYPE.MIP_LEVELS_MAX do
		self.LockedSurfacePointer[i] = nil
		self.LockedSurfacePitch[i] = 0
	end
end

function INSTANCE:_Renegade_TextureLoadTask()
	self:Deinit()
end

function INSTANCE:Destroy()
	self:Deinit()
end

--- @param texture TextureInstance
--- @param type TaskType
--- @param priority PriorityType
function INSTANCE:Init( texture, type, priority )
	self.Texture = texture

	-- "Make sure texture has a filename."
	assert( self.Texture:GetFullPath() ~= "" )

	self.Type = type
	self.Priority = priority
	self.State = stateTypeEnum.STATE_NONE

	-- Omitted initializing D3DTexture
	-- self.D3dTexture = d3dTextureClass.New()

	self.Format = self.Texture:GetTextureFormat()
	self.Width = 0
	self.Height = 0
	self.MipLevelCount = self.Texture.MipLevelCount
	self.Reduction = self.Texture:GetReduction()

	for i = 1, textureClass.MIP_COUNT_TYPE.MIP_LEVELS_MAX do
		self.LockedSurfacePointer[i] = nil
		self.LockedSurfacePitch[i] = 0
	end

	if self.Type == taskTypeEnum.TASK_THUMBNAIL then
		self.Texture.ThumbnailLoadTask = self
	elseif self.Type == taskTypeEnum.TASK_LOAD then
		self.Texture.TextureLoadTask = self
	end
end

function INSTANCE:Deinit()
	-- This function intentionally empty
end

--- @return TaskType
function INSTANCE:GetType()
	return self.Type
end

--- @return PriorityType
function INSTANCE:GetPriority()
	return self.Priority
end

--- @return StateType
function INSTANCE:GetState()
	return self.State
end

--- @return WW3dFormat
function INSTANCE:GetFormat()
	return self.Format
end

--- @return integer
function INSTANCE:GetWidth()
	return self.Width
end

--- @return integer
function INSTANCE:GetHeight()
	return self.Height
end

--- @return integer
function INSTANCE:GetMipLevelCount()
	return self.MipLevelCount
end

--- @return integer
function INSTANCE:GetReduction()
	return self.Reduction
end

--- @param level integer
--- @return string
function INSTANCE:GetLockedSurfacePointer( level )
	typecheck.NotImplementedError()
end

--- @param level integer
--- @return integer
function INSTANCE:GetLockedSurfacePitch( level )
	typecheck.NotImplementedError()
end

--- @return TextureInstance
function INSTANCE:PeekTexture()
	return self.Texture
end

--- @return D3dTextureInstance
function INSTANCE:PeekD3dTexture()
	return self.RenderTarget
end

--- @param type TaskType
function INSTANCE:SetType( type )
	self.Type = type
end

--- @param priority PriorityType
function INSTANCE:SetPriority( priority )
	self.Priority = priority
end

--- @param state StateType
function INSTANCE:SetState( state )
	self.State = state
end

--- @return boolean
function INSTANCE:BeginLoad()
	local loaded = false

	-- "If allowed, begin a compressed load"
	if self.Texture:IsCompressionAllowed() then
		loaded = self:BeginCompressedLoad()
	end

	-- "Otherwise, begin an uncompressed load"
	if not loaded then
		loaded = self:BeginUncompressedLoad()
	end

	-- "If not loaded, abort."
	if not loaded then
		return false
	end

	-- "Lock surfaces in preparation for copy"
	self:LockSurfaces()

	self.State = stateTypeEnum.STATE_LOAD_BEGUN

	return true
end

--- "  
--- Load mipmap levels to a pre-generated and locked texture object based on information in load task object.  
--- Try loading from a DDS file first and if that fails try a TGA.
--- "  
--- @return boolean
function INSTANCE:Load()
	local loaded = false

	-- "If allowed, try to load compressed mipmaps"
	if self.Texture:IsCompressionAllowed() then
		loaded = self:LoadCompressedMipmap()
	end

	-- "Otherwise, load uncompressed mipmaps"
	if not loaded then
		loaded = self:LoadUncompressedMipmap()
	end

	self.State = stateTypeEnum.STATE_LOAD_MIPMAP

	return loaded
end

function INSTANCE:EndLoad()
	self:UnlockSurfaces()
	self:Apply( true )

	self.State = stateTypeEnum.STATE_LOAD_COMPLETE
end

function INSTANCE:FinishLoad()
	if self.State == stateTypeEnum.STATE_NONE then
		if not self:BeginLoad() then
			self:ApplyMissingTexture()
			return
		end

		self:Load()
		self:EndLoad()

	elseif self.State == stateTypeEnum.STATE_LOAD_BEGUN then
		self:Load()
		self:EndLoad()

	elseif self.State == stateTypeEnum.STATE_LOAD_MIPMAP then
		self:EndLoad()
	end
end

function INSTANCE:ApplyMissingTexture()
	typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:BeginCompressedLoad()
	local success, originalWidth, originalHeight, originalFormat, originalMipCount = textureLoaderClass.GetTextureInformation( self.Texture:GetFullPath(), self:GetReduction(), true )

	if not success then
		return false
	end

	-- "Destination size will be the next power of two square from the larger width and height..."
	local width  = originalWidth
	local height = originalHeight
	width, height = textureLoaderClass.ValidateTextureSize( width, height )

	-- "If the size doesn't match, try and see if texture reduction would help... (mainly for cases where loaded texture is larger than hardware limit)"
	if width ~= originalWidth or height ~= originalHeight then
		-- Omitted code here
		-- I don't know that it's useful
	end

	self.Width  = width
	self.Height = height
	self.Format = originalFormat -- Omitted call to GetValidTextureFormat because I don't want to deal with it right now

	local textureFlags = 32768
	local renderTargetFlags = 0

	if CLIENT then
		self.RenderTarget = GetRenderTargetEx(
			"ren_" .. self.Texture:GetTextureName(),
			self.Width,
			self.Height,
			RT_SIZE_NO_CHANGE,
			MATERIAL_RT_DEPTH_NONE,
			textureFlags,
			renderTargetFlags,
			IMAGE_FORMAT_RGBA8888
		)
	end

	-- Omitted changing mip levels

	return true
end

--- @return boolean
function INSTANCE:BeginUncompressedLoad()
	typecheck.NotImplementedError()
end

--- @return boolean
function INSTANCE:LoadCompressedMipmap()
	local ddsFile = dDSFileClass.New( self.Texture:GetFullPath(), self:GetReduction() )

	-- "If we can't load from file, indicate [error]"
	if not ddsFile:IsAvailable() or not ddsFile:Load() then
		return false
	end

	local width  = self:GetWidth()
	local height = self:GetHeight()

	ddsFile:CopyLevelToSurface(
		1,
		self:GetFormat(),
		width,
		height,
		self.RenderTarget
	)

	return true
end

--- @return boolean
function INSTANCE:LoadUncompressedMipmap()
	typecheck.NotImplementedError()
end

function INSTANCE:LockSurfaces()
	-- This function intentionally empty
end

function INSTANCE:UnlockSurfaces()
	-- This function intentionally empty
end

--- @param initialize boolean
function INSTANCE:Apply( initialize )
	assert( self.RenderTarget ~= nil )

	-- Omitted checking mip level locks

	self.Texture:ApplyNewSurface( self.RenderTarget, initialize )

	self.RenderTarget = nil
end
