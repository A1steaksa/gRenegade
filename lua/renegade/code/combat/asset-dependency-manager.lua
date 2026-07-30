-- Based on AssetDependencyManager within Code/Combat/assetdep.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class AssetDependencyManagerClass
--- @field Instance AssetDependencyManagerInstance The metatable used by AssetDependencyManagerInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AssetDependencyManagerClass"

--- @class AssetDependencyManagerInstance
--- @field Static AssetDependencyManagerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AssetDependencyManager" )
INSTANCE.Class = "AssetDependencyManagerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAssetDependencyManager = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )

	--- @type FileFactoryClass
	local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

	--- @type FileClass
	local fileClass = CNC.Import( "code/wwlib/file.lua" )

	--- @type ChunkLoadClass
	local chunkLoadClass = CNC.Import( "code/wwlib/chunk-load.lua" )

	--- @type Ww3dAssetManagerClass
	local ww3dAssetManagerClass = CNC.Import( "code/ww3d2/ww3d-asset-manager.lua" )
--#endregion

--#region Imported Enums

	local fileRightsEnum = fileClass.FILE_RIGHTS
--#endregion


--[[ Chunk IDs ]] do

    STATIC.ChunkIds = {
        CHUNKID_FILE_LIST 	 = 0x04020527,

		VARID_ASSET_FILENAME = 0x01,
    }
end


--[[ Static Functions and Variables ]] do

    --- @class AssetDependencyManagerClass

	STATIC.ALWAYS_FILENAME = "always.dep"
	STATIC.DEP_EXTENSION = ".dep"

    --- Creates a new AssetDependencyManagerInstance
    --- @return AssetDependencyManagerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_AssetDependencyManager" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AssetDependencyManagerInstance, `false` otherwise
    function STATIC.IsAssetDependencyManager( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAssetDependencyManager and true or false
    end

    typecheck.RegisterType( "AssetDependencyManagerInstance", STATIC.IsAssetDependencyManager )


	function STATIC.SaveAlwaysDependencies( path, assetList )
		typecheck.NotImplementedError()
	end

	function STATIC.SaveLevelDependencies( fullPath, assetList )
		typecheck.NotImplementedError()
	end

	function STATIC.SaveDependencies( csave, assetList )
		typecheck.NotImplementedError()
	end

	--- @param levelName string
	function STATIC.LoadLevelAssets( levelName )
		-- "Strip the extension (if necessary)"
		local baseName = levelName
		local extensionIndex = textUtils.LastIndexOf( baseName, "." )
		if extensionIndex ~= nil and baseName:len() > 4 then
			baseName = baseName:sub( 1, baseName:len() - 4 )
		end

		-- "Build a filename from the level name and load the assets from it."
		local fileName = baseName .. STATIC.DEP_EXTENSION
		STATIC.LoadAssets( fileName )
	end

	function STATIC.LoadAlwaysAssets()
		-- "Load the4 assets from the always file"
		STATIC.LoadAssets( STATIC.ALWAYS_FILENAME )
	end

	--- @overload fun( fileName: string )
	--- @overload fun( cload: ChunkLoadInstance )
	function STATIC.LoadAssets( arg )
		typecheck.AssertArgType( STATIC.Class, 1, arg, { "string", "ChunkLoadInstance" } )

		--- ( fileName: string )
		if typecheck.IsOfType( arg, "string" ) then

			local fileName = arg --[[@as string]]

			-- "Get a pointer to the file object"
			local file = fileFactoryClass.TheFileFactory:GetFile( fileName )
			if file ~= nil then
				if file:IsAvailable() then
					-- "Open the file"
					file:Open( fileRightsEnum.READ )

					-- "Load the asset dependencies from the file"
					local cload = chunkLoadClass.New( file )
					STATIC.LoadAssets( cload )

					-- "Close the file"
					file:Close()
				else
					section.Warn( "AssetDependencyManager Failed to find ", fileName )
				end

				fileFactoryClass.TheFileFactory:ReturnFile( file )
			end
			return

		--- ( cload: ChunkLoadInstance )
		else

			local cload = arg --[[@as ChunkLoadInstance]]

			local ids = STATIC.ChunkIds

			cload:OpenChunk()
			assert( cload:CurChunkId() == ids.CHUNKID_FILE_LIST )
			if cload:CurChunkId() == ids.CHUNKID_FILE_LIST then

				--- "
				--- Read the filename of each asset from the chunk and
				--- load its assets into the asset manager.
				--- "
				section.Start( "(Not Actually) Loading assets" )
				local assetCount = 0
				while cload:OpenMicroChunk() do
					if cload:CurMicroChunkId() == ids.VARID_ASSET_FILENAME then
						-- "Read the filename from the chunk"
						local size = cload:CurMicroChunkLength()
						local _, fileName = cload:Read( size )
						if fileName == nil then
							section.Warn( "AssetDependencyManager Failed to read file name from chunk" )
						end

						assetCount = assetCount + 1

						-- "Determine what the render object name should be from the filename"
						local renderObjectName = STATIC.AssetNameFromFileName( fileName )
						--- Omitted save load status class
						-- saveLoadStatusClass.SetStatusText( fileName, 1 )

						-- "Load the assets from this file into the asset manager"
						if ww3dAssetManagerClass.GetInstance():RenderObjectExists( renderObjectName ) == false then
							ww3dAssetManagerClass.GetInstance():Load3dAssets( fileName )
						end
					else
						section.Warn( "Unexpected chunk ID ", cload:CurMicroChunkId(), " found while preloading assets." )
					end

					cload:CloseMicroChunk()
				end
				section.End( "(Fake) Loaded ", assetCount, " assets" )
			end

			cload:CloseChunk()
		end
	end

	--- @param path string?
	--- @return string?
	function STATIC.GetFileNameFromPath( path )
		if path == nil then return end

		-- "Find the last occurance of the directory deliminator"
		local lastOccurranceIndex = textUtils.LastIndexOf( path, "/" )

		if lastOccurranceIndex ~= nil then
			-- "Increment past the directory deliminator"
			return path:sub( lastOccurranceIndex + 1 )
		else
			return path
		end
	end

	--- @param fileName string?
	--- @return string?
	function STATIC.AssetNameFromFileName( fileName )
		-- "Get the filename from this path"
		local assetName = STATIC.GetFileNameFromPath( fileName )

		-- "Find and strip off the extension (if it exists)"
		local extensionIndex = textUtils.LastIndexOf( assetName, "." )
		if extensionIndex ~= nil then
			assetName = assetName:sub( 1, extensionIndex - 1 )
		end

		return assetName
	end
end


--- @class AssetDependencyManagerInstance
