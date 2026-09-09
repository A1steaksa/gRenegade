-- Based on TextureLoader within Code/ww3d2/textureloader.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class TextureLoaderClass
--- @field Instance TextureLoaderInstance The metatable used by TextureLoaderInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TextureLoaderClass"

--- @class TextureLoaderInstance
--- @field Static TextureLoaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_TextureLoader" )
INSTANCE.Class = "TextureLoaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsTextureLoader = true

--#region Exported Enums

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
	local enumBuilder = enumBuilderClass.New()

	--- @enum TaskType
	STATIC.TASK_TYPE = {
		TASK_NONE      = enumBuilder:Set( 0 ),
		TASK_THUMBNAIL = enumBuilder:Next(),
		TASK_LOAD 	   = enumBuilder:Next()
	}
    local taskTypeEnum = STATIC.TASK_TYPE

    --- @enum StateType
    STATIC.STATE_TYPE = {
        STATE_NONE = enumBuilder:Set( 0 ),

        STATE_LOAD_BEGUN    = enumBuilder:Next(),
        STATE_LOAD_MIPMAP   = enumBuilder:Next(),
        STATE_LOAD_COMPLETE = enumBuilder:Next(),

        STATE_COMPLETE = enumBuilder:Next(),
    }
    local stateTypeEnum = STATIC.STATE_TYPE

    --- @enum PriorityType
    STATIC.PRIORITY_TYPE = {
        PRIORITY_LOW  = enumBuilder:Set( 0 ),
        PRIORITY_HIGH = enumBuilder:Next()
    }
    local priorityTypeEnum = STATIC.PRIORITY_TYPE

--#endregion

--#region Imports

	--- @type TextureClass
	local textureClass = CNC.Import( "code/ww3d2/texture.lua" )

	--- @type TextureLoadTaskClass
	local textureLoadTaskClass = CNC.Import( "code/ww3d2/texture-load-task.lua" )

	--- @type FileFactoryClass
	local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )

	--- @type DDSFileClass
	local dDSFileClass = CNC.Import( "code/ww3d2/dds-file.lua" )

	--- @type WW3dFileFormatIds
	local wW3dFileFormatIds = CNC.Import( "code/ww3d2/ww3d-format.lua" )
--#endregion

--#region Imported Enums

	local wW3dFormatEnum = wW3dFileFormatIds.WW3D_FORMAT
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class TextureLoaderClass
	--- @field TextureLoadSuspended boolean
	--- @field FreeList TextureLoadTaskInstance[]
	--- @field ForegroundQueue TextureLoadTaskInstance[]
	--- @field BackgroundQueue TextureLoadTaskInstance[]

    --- Creates a new TextureLoaderInstance
    --- @return TextureLoaderInstance
    function STATIC.New()
        return robustclass.New( "Renegade_TextureLoader" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) TextureLoaderInstance, `false` otherwise
    function STATIC.IsTextureLoader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsTextureLoader and true or false
    end

    typecheck.RegisterType( "TextureLoaderInstance", STATIC.IsTextureLoader )

	function STATIC.StaticConstructor()
		STATIC.FreeList        = {}
		STATIC.ForegroundQueue = {}
		STATIC.BackgroundQueue = {}
	end

	function STATIC.Init()
		typecheck.NotImplementedError()
	end

	function STATIC.Deinit()
		typecheck.NotImplementedError()
	end

	--- @param fileName string
	--- @param reduction integer
	--- @param isCompressed boolean
	--- @return boolean success, integer width, integer height, WW3dFormat format, integer mipCount
	function STATIC.GetTextureInformation( fileName, reduction, isCompressed )
		local width, height, format, mipCount

		-- Omitted thumbnail stuff for now

		if isCompressed then
			local ddsFile = dDSFileClass.New( fileName, reduction )

			if not ddsFile:IsAvailable() then
				return false, 0, 0, wW3dFormatEnum.WW3D_FORMAT_UNKNOWN, 0
			end

			-- "Destination size will be the next power of two square from the larger width and height..."
			width = ddsFile:GetWidth( 1 )
			height = ddsFile:GetHeight( 1 )
			format = ddsFile:GetFormat()
			mipCount = ddsFile:GetMipLevelCount()
			return true, width, height, format, mipCount
		end

		typecheck.NotImplementedError()
	end

	--- @param width integer
	--- @param height integer
	--- @return integer width, integer height 
	function STATIC.ValidateTextureSize( width, height )
		-- Omitted retrieving D3DCAPS

		local powerOfTwoWidth = 1
		while powerOfTwoWidth < width do
			powerOfTwoWidth = bit.lshift( powerOfTwoWidth, 1 )
		end

		local powerOfTwoHeight = 1
		while powerOfTwoHeight < height do
			powerOfTwoHeight = bit.lshift( powerOfTwoHeight, 1 )
		end

		-- Omitting max texture size for now

		if powerOfTwoWidth > powerOfTwoHeight then
			while powerOfTwoWidth / powerOfTwoHeight > 8 do
				powerOfTwoHeight = powerOfTwoHeight * 2
			end
		else
			while powerOfTwoHeight / powerOfTwoWidth > 8 do
				powerOfTwoWidth = powerOfTwoWidth * 2
			end
		end

		return powerOfTwoWidth, powerOfTwoHeight
	end

	--- @param texture TextureInstance|string
	--- @return IMaterial
	function STATIC.LoadThumbnail( texture )
		typecheck.AssertArgType( INSTANCE.Class, 1, texture, { "string", "TextureInstance" }  )

		if typecheck.IsOfType( texture, "string" ) then
			--- @cast texture string

			typecheck.NotImplementedError()

		elseif typecheck.IsOfType( texture, "TextureInstance" ) then
			--- @cast texture TextureInstance

			-- "Load thumbnail texture"
			local material = STATIC.LoadThumbnail( texture:GetFullPath() )

			-- "Apply thumbnail to texture"
			texture:ApplyNewSurface( material, false )

			return material
		end
	end

	function STATIC.LoadSurfaceImmediate()
		typecheck.NotImplementedError()
	end

	--- @param texture TextureInstance
	function STATIC.RequestThumbnail( texture )
		-- Omitted thread locking

		-- "Has a Direct3D texture already been loaded?"
		if texture:PeekSourceMaterial() then
			return
		end

		local task = texture.ThumbnailLoadTask

		-- "Load the thumbnail immediately"
		STATIC.LoadThumbnail( texture )

		-- "Clear any pending thumbnail load"
		if task then
			table.RemoveByValue( STATIC.ForegroundQueue, task )
		end

		-- Ommitted non-DX8 thread code path
	end

	--- @param texture TextureInstance
	function STATIC.RequestBackgroundLoading( texture )
		typecheck.NotImplementedError()
	end

	--- @param texture TextureInstance
	function STATIC.RequestForegroundLoading( texture )
		-- Omitted grabbing foreground lock

		-- "Has the texture already been loaded?"
		if texture:IsInitialized() then
			return
		end

		-- Because we don't have threads in Lua and we espcially don't have whatever a DX8 thread is, we're going to
		-- omit the non-DX8 thread code because that seems like it stalls loading until later and I'd prefer to load immediately if I can

		local task = texture.TextureLoadTask
		local taskThumb = texture.ThumbnailLoadTask

		-- "Since we're in the DX8 thread, we can load the entire texture right now."

		-- "If we have a thumbnail task waiting, kill it."
		if taskThumb then
			table.RemoveByValue( STATIC.ForegroundQueue, taskThumb )
			taskThumb:Destroy()
		end

		if task then
			-- "We need to remove the task from any queue, since we're going to finish it up right now."

			-- Omitted halting background thread
			table.RemoveByValue( STATIC.ForegroundQueue, task )
			table.RemoveByValue( STATIC.BackgroundQueue, task )
		else
			-- "Since the task manages all the state associated with loading a texture, we temporarily create one."
			task = textureLoadTaskClass.Create( texture, taskTypeEnum.TASK_LOAD, priorityTypeEnum.PRIORITY_HIGH )
		end

		-- "Finish loading the task and destroy it"
		task:FinishLoad()
		task:Destroy()
	end

	function STATIC.FlushPendingLoadTasks()
		typecheck.NotImplementedError()
	end

	function STATIC.Update( callback )
		if STATIC.TextureLoadSuspended then
			return
		end

		-- Omitted thread locking as we don't have threads

		-- Omitted getting system time

		-- "While we have tasks on the foreground queue"
		local task = table.remove( STATIC.ForegroundQueue, 1 ) --[[@as TextureLoadTaskInstance]]
		while task ~= nil do
			-- Omitted network update

			-- "Dispatch to proper task handler"
			local taskType = task:GetType()

			if taskType == taskTypeEnum.TASK_THUMBNAIL then
				STATIC.ProcessForegroundThumbnail( task )
			elseif taskType == taskTypeEnum.TASK_LOAD then
				STATIC.ProcessForegroundLoad( task )
			end

			task = table.remove( STATIC.ForegroundQueue, 1 )
		end

		-- Omitted invalidating unused textures
		-- What's the worst that could happen?
		-- textureClass.InvalidateOldUnusedTextures( 0 )
	end

	function STATIC.IsDx8Thread()
		typecheck.NotImplementedError()
	end

	function STATIC.SuspendTextureLoad()
		typecheck.NotImplementedError()
	end

	function STATIC.ContinueTextureLoad()
		typecheck.NotImplementedError()
	end

	--- @param task TextureLoadTaskInstance
	function STATIC.ProcessForegroundLoad( task )
		-- "Is high-priority task?"
		if task:GetPriority() == priorityTypeEnum.PRIORITY_HIGH then
			task:FinishLoad()
			task:Destroy()
			return
		end

		-- "Otherwise, must be a low-priority task."

		local state = task:GetState()
		if state == stateTypeEnum.STATE_NONE then
			STATIC.BeginLoadAndQueue( task )

		elseif state == stateTypeEnum.STATE_LOAD_MIPMAP then
			task:EndLoad()
			task:Destroy()
		end
	end

	--- @param task TextureLoadTaskInstance
	function STATIC.ProcessForegroundThumbnail( task )
		local state = task:GetState()
		if state == stateTypeEnum.STATE_NONE then
			STATIC.LoadThumbnail( task:PeekTexture() )
		elseif state == stateTypeEnum.STATE_COMPLETE then
			task:Destroy()
		end
	end

	--- @param task TextureLoadTaskInstance
	function STATIC.BeginLoadAndQueue( task )
		if task:BeginLoad() then
			-- "  
			-- Add to front of background queue.
			-- This means the background load thread will service tasks in LIFO (last in, first out) order.
			--
			-- NOTE: This was how the old code did it, with a comment that mentioned good reasons for doing
			-- so, without actually listing the reasons.  I suspect it has something to do with visually 
			-- important textures, like those in the foreground, starting their load last.
			--  " 
			table.insert( STATIC.BackgroundQueue, 1, task )
		else
			-- "Unable to load."
			task:ApplyMissingTexture()
			task:Destroy()
		end
	end
end
