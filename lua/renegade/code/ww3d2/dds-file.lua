-- Based on DDSFileClass within Code/ww3d2/ddsfile.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class DDSFileClass
--- @field Instance DDSFileInstance The metatable used by DDSFileInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DDSFileClass"

--- @class DDSFileInstance
--- @field Static DDSFileClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DDSFile" )
INSTANCE.Class = "DDSFileInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDDSFile = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type WW3dFileFormatIds
	local wW3dFileFormatIds = CNC.Import( "code/ww3d2/ww3d-format.lua" )

	--- @type FileFactoryClass
	local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

	--- @type FormatConverterLib
	local formatConverterLib = CNC.Import( "code/ww3d2/format-converter.lua" )

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )

	--- @type ClassUtils
	local classUtils = CNC.Import( "sh_class-utils.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
	local wW3dFormatEnum = wW3dFileFormatIds.WW3D_FORMAT
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class DDSFileClass

    --- Creates a new DDSFileInstance
	--- @param fileName string
	--- @param reduction integer
    --- @return DDSFileInstance
    function STATIC.New( fileName, reduction )
        return robustclass.New( "Renegade_DDSFile", fileName, reduction )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DDSFileInstance, `false` otherwise
    function STATIC.IsDDSFile( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDDSFile and true or false
    end

    typecheck.RegisterType( "DDSFileInstance", STATIC.IsDDSFile )

	function STATIC.StaticConstructor()

		--- "  
		--- This structure represents the old DX7 color key structure. It is needed
		--- LegacyDDSURFACEDESC which is needed when loading DDS files. DO NOT MODIFY!  
		--- "  
		--- @class LegacyDDColorKey
		--- @field ColorSpaceLowValue integer
		--- @field ColorSpaceHighValue integer
		deserializeLib.RegisterComplexDataType( "LegacyDDColorKey", {
			{ Name = "ColorSpaceLowValue",  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "ColorSpaceHighValue", DataType = fundamentalDataTypeEnum.UInt32 },
		} )

		--- "  
		--- This structure represents the old DX7 pixel format structure. It is needed
		--- LegacyDDSURFACEDESC which is needed when loading DDS files. DO NOT MODIFY!  
		--- "  
		--- @class LegacyDDPixelFormat
		--- @field Size integer
		--- @field Flags integer
		--- @field FourCC integer
		--- Union{
		--- 	@field RgbBitCount integer
		--- 	@field YUVBitCount integer
		--- 	@field ZBufferBitDepth integer
		--- 	@field AlphaBitDepth integer
		--- 	@field LuminanceBitCount integer
		--- 	@field BumpBitCount integer
		--- }
		--- Union{
		--- 	@field RBitMask integer
		--- 	@field YBitMask integer
		--- 	@field StencilBitDepth integer
		--- 	@field LuminanceBitMask integer
		--- 	@field BumpDuBitMask integer
		--- }
		--- Union{
		--- 	@field GBitMask integer
		--- 	@field UBitMask integer
		--- 	@field ZBitMask integer
		--- 	@field BumpDvBitMask integer
		--- }
		--- Union{
		--- 	@field BBitMask integer
		--- 	@field VBitMask integer
		--- 	@field StencilBitMask integer
		--- 	@field BumpLuminanceBitMask integer
		--- }
		--- Union{
		--- 	@field RgbAlphaBitMask integer
		--- 	@field YUVAlphaBitMask integer
		--- 	@field LuminanceAlphaBitMask integer
		--- 	@field RgbZBitMask integer
		--- 	@field YUVZBitMask integer
		--- }
		deserializeLib.RegisterComplexDataType( "LegacyDDPixelFormat", {
			{ Name = "Size",   DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Flags",  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "FourCC", DataType = fundamentalDataTypeEnum.UInt32 },
			{ Union = {
				{ Name = "RgbBitCount",       DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "YUVBitCount",       DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "ZBufferBitDepth",   DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "AlphaBitDepth",     DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "LuminanceBitCount", DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "BumpBitCount",      DataType = fundamentalDataTypeEnum.UInt32 },
			} },
			{ Union = {
				{ Name = "RBitMask",         DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "YBitMask",         DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "StencilBitDepth",  DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "LuminanceBitMask", DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "BumpDuBitMask",    DataType = fundamentalDataTypeEnum.UInt32 },
			} },
			{ Union = {
				{ Name = "GBitMask",      DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "UBitMask",      DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "ZBitMask",      DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "BumpDvBitMask", DataType = fundamentalDataTypeEnum.UInt32 },
			} },
			{ Union = {
				{ Name = "BBitMask",             DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "VBitMask",             DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "StencilBitMask",       DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "BumpLuminanceBitMask", DataType = fundamentalDataTypeEnum.UInt32 },
			} },
			{ Union = {
				{ Name = "RgbAlphaBitMask",       DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "YUVAlphaBitMask",       DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "LuminanceAlphaBitMask", DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "RgbZBitMask",           DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "YUVZBitMask",           DataType = fundamentalDataTypeEnum.UInt32 },
			} },
		} )

		--- "  
		--- This structure represents the old DX7 CAPS2 structure. It is needed
		--- LegacyDDSURFACEDESC which is needed when loading DDS files. DO NOT MODIFY!  
		--- "  
		--- @class LegacyDDSCaps2
		--- @field Caps integer
		--- @field Caps2 integer
		--- @field Caps3 integer
		--- @field Caps4 integer
		deserializeLib.RegisterComplexDataType( "LegacyDDSCaps2", {
			{ Name = "Caps",   DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Caps2",  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Caps3",  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Caps4",  DataType = fundamentalDataTypeEnum.UInt32 },
		} )

		--- @class LegacyDDSurfaceDescription2
		--- @field Size integer
		--- @field Flags integer
		--- @field Height integer
		--- @field Width integer
		--- Union {
		---		@field Pitch integer
		---		@field LinearSize integer
		--- }
		--- @field BackBufferCount integer
		--- Union {
		---		@field MipMapCount integer
		---		@field RefreshRate integer
		--- }
		--- @field AlphaBitDepth integer
		--- @field Reserved integer
		--- @field Surface any
		--- Union {
		---		@field CKDestinationOverlay LegacyDDColorKey
		---		@field EmptyFaceColor integer
		--- }
		--- @field CKDestinationBlt LegacyDDColorKey
		--- @field CKSourceOverlay LegacyDDColorKey
		--- @field CKSourceBlt LegacyDDColorKey
		--- @field PixelFormat LegacyDDPixelFormat
		--- @field Caps LegacyDDSCaps2
		--- @field TextureStage integer
		deserializeLib.RegisterComplexDataType( "LegacyDDSurfaceDescription2", {
			{ Name = "Size",   DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Flags",  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Height", DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Width",  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Union = {
				{ Name = "Pitch",      DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "LinearSize", DataType = fundamentalDataTypeEnum.UInt32 },
			} },
			{ Name = "BackBufferCount", DataType = fundamentalDataTypeEnum.UInt32 },
			{ Union = {
				{ Name = "MipMapCount", DataType = fundamentalDataTypeEnum.UInt32 },
				{ Name = "RefreshRate", DataType = fundamentalDataTypeEnum.UInt32 },
			} },
			{ Name = "AlphaBitDepth", DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Reserved",      DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Surface",       DataType = fundamentalDataTypeEnum.Pointer },
			{ Union = {
				{ Name = "CKDestinationOverlay", DataType = "LegacyDDColorKey" },
				{ Name = "EmptyFaceColor",       DataType = fundamentalDataTypeEnum.UInt32 },
			} },
			{ Name = "CKDestinationBlt", DataType = "LegacyDDColorKey" },
			{ Name = "CKSourceOverlay",  DataType = "LegacyDDColorKey" },
			{ Name = "CKSourceBlt",      DataType = "LegacyDDColorKey" }, --72
			{ Name = "PixelFormat",      DataType = "LegacyDDPixelFormat" },-- 100
			{ Name = "Caps",             DataType = "LegacyDDSCaps2" },-- 116
			{ Name = "TextureStage",     DataType = fundamentalDataTypeEnum.UInt32 }, -- 120
		} )
	end

	--- "For some reason DX-Tex tool doesn't fill the surface size field, so we need to calculate it..."
	--- @param width integer
	--- @param height integer
	--- @param format WW3dFormat
	--- @return integer
	function STATIC.CalculateDxtcSurfaceSize( width, height, format )
		local levelSize = ( width / 4 ) * ( height / 4)

		if format == wW3dFormatEnum.WW3D_FORMAT_DXT1 then
			levelSize = levelSize * 8
		elseif format == wW3dFormatEnum.WW3D_FORMAT_DXT2
			or format == wW3dFormatEnum.WW3D_FORMAT_DXT3
			or format == wW3dFormatEnum.WW3D_FORMAT_DXT4
			or format == wW3dFormatEnum.WW3D_FORMAT_DXT5
		then
			levelSize = levelSize * 16
		end

		return levelSize
	end

	--- @param color1 integer
	--- @param color2 integer
	--- @param rel integer
	--- @return integer
	function STATIC.CombineColors( color1, color2, rel )
		local redBlueMask = 0x00ff00ff
		local greenMask   = 0x0000ff00

		local rel2 = 255 - rel

		local redBlueColor1 = bit.band( color1, redBlueMask )
		redBlueColor1 = redBlueColor1 * rel

		local redBlueColor2 = bit.band( color2, redBlueMask )
		redBlueColor2 = redBlueColor2 * rel2

		redBlueColor1 = redBlueColor1 + redBlueColor2
		redBlueColor1 = bit.rshift( redBlueColor1, 8 )
		redBlueColor1 = bit.band( redBlueColor1, redBlueMask )

		local greenColor1 = bit.band( color1, greenMask )
		greenColor1 = greenColor1 * rel

		local greenColor2 = bit.band( color2, greenMask )
		greenColor2 = greenColor2 * rel2

		greenColor1 = greenColor1 + greenColor2
		greenColor1 = bit.rshift( greenColor1, 8 )
		greenColor1 = bit.band( greenColor1, greenMask )

		local result = bit.bor( redBlueColor1, greenColor1 )

		return result
	end

	--- @param rgb integer
	--- @return integer
	function STATIC.RGB565ToARGB8888( rgb )
		local rgba = 0

		rgba = bit.bor( rgba, bit.lshift( bit.band( rgb, 0x001F ), 3 ) )
		rgba = bit.bor( rgba, bit.lshift( bit.band( rgb, 0x07E0 ), 5 ) )
		rgba = bit.bor( rgba, bit.lshift( bit.band( rgb, 0xF800 ), 8 ) )
		return rgba
	end
end


--- @class DDSFileInstance
--- @field Width integer
--- @field Height integer
--- @field FullWidth integer
--- @field FullHeight integer
--- @field MipLevels integer
--- @field DateTime integer
--- @field ReductionFactor integer
--- @field DdsMemory string
--- @field Format WW3dFormat
--- @field LevelSizes integer[]
--- @field LevelOffsets integer[]
--- @field SurfaceDescription LegacyDDSurfaceDescription2
--- @field Name string

--- @param name string
--- @param reductionFactor integer
function INSTANCE:Renegade_DDSFile( name, reductionFactor )

	self.DdsMemory = nil
	self.Width = 0
	self.Height = 0
	self.FullWidth = 0
	self.FullHeight = 0
	self.LevelSizes = nil
	self.LevelOffsets = nil
	self.MipLevels = 0
	self.ReductionFactor = reductionFactor
	self.Format = wW3dFormatEnum.WW3D_FORMAT_UNKNOWN
	self.DateTime = 0

	-- "The name could be given in .tga or .dds format, so ensure we're opening .dds..."
	self.Name = name
	local len = self.Name:len()
	self.Name = self.Name:SetChar( len - 2, "d" )
	self.Name = self.Name:SetChar( len - 1, "d" )
	self.Name = self.Name:SetChar( len - 0, "s" )

	local file = fileFactoryClass.TheFileFactory:GetFile( self.Name )
	if not file:IsAvailable() then
		return
	end

	file:Open()
	self.DateTime = file:GetDateTime()
	local header = file:Read( 4 )
	-- "Now, we read [LegacyDDSurfaceDescription2] defining the compressed data"
	local byteCountToRead = deserializeLib.GetComplexDataTypeSize( "LegacyDDSurfaceDescription2" )

	local readBytes, readByteCount = file:Read( byteCountToRead )

	if readByteCount ~= byteCountToRead then
		section.Error( "Tried to read ", byteCountToRead, " bytes from ", file:FileName(), " but only got ", readByteCount, " bytes" )
		return
	end

	self.SurfaceDescription = deserializeLib.Deserialize( "LegacyDDSurfaceDescription2", readBytes )

	-- "Verify the structure size matches the read size"
	if readByteCount ~= self.SurfaceDescription.Size then
		section.Error( "Loading ", name, " failed while deserializing LegacyDDSurfaceDescription2. Tried to read ", byteCountToRead, " bytes, got ", readByteCount, " bytes, but needed ", self.SurfaceDescription.Size, " bytes." )
		return
	end

	self.Format = formatConverterLib.D3dFormatToWW3dFormat( self.SurfaceDescription.PixelFormat.FourCC )
	assert(
	       self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT1
		or self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT2
		or self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT3
		or self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT4
		or self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT5
	)

	self.MipLevels = self.SurfaceDescription.MipMapCount
	if self.MipLevels == 0 then
		self.MipLevels = 1
	end

	if self.MipLevels > self.ReductionFactor then
		self.MipLevels = self.MipLevels - self.ReductionFactor
	else
		self.MipLevels = 1
		self.ReductionFactor = self.ReductionFactor - self.MipLevels
	end

	-- "Drop the two lowest miplevels!"
	if self.MipLevels > 2 then
		self.MipLevels = self.MipLevels - 2
	else
		self.MipLevels = 1
	end

	self.FullWidth  = self.SurfaceDescription.Width
	self.FullHeight = self.SurfaceDescription.Height
	self.Width  = bit.rshift( self.SurfaceDescription.Width,  self.ReductionFactor )
	self.Height = bit.rshift( self.SurfaceDescription.Height, self.ReductionFactor )

	local levelSize = STATIC.CalculateDxtcSurfaceSize( self.SurfaceDescription.Width, self.SurfaceDescription.Height, self.Format )
	local levelOffset = 1

	self.LevelSizes   = classUtils.InitializeTypeArray( fundamentalDataTypeEnum.Int, self.MipLevels )
	self.LevelOffsets = classUtils.InitializeTypeArray( fundamentalDataTypeEnum.Int, self.MipLevels )

	for level = 1, self.ReductionFactor do
		-- "If surface is bigger than one block (8 opr 16 bytes)..."
		if levelSize > 16 then
			levelSize = levelSize / 4
		end
	end

	for level = 1, self.MipLevels do
		self.LevelSizes[level] = levelSize
		self.LevelOffsets[level] = levelOffset
		levelOffset = levelOffset + levelSize

		--- "If surface is bigger than one block (8 opr 16 bytes)..."
		if levelSize > 16 then
			levelSize = levelSize / 4
		end
	end

	-- Add in reading the rest of the bytes also

	file:Close()
end

function INSTANCE:_Renegade_DDSFile()
	typecheck.NotImplementedError()
end

--- @param level integer
--- @return integer
function INSTANCE:GetWidth( level )
	assert( level <= self.MipLevels, "Level " .. level .. " is not less than or equal to MipLevels " .. self.MipLevels )

	local width = bit.rshift( self.Width, level - 1 )
	if width < 4 then
		width = 4
	end
	return width
end

--- @param level integer
--- @return integer
function INSTANCE:GetHeight( level )
	assert( level <= self.MipLevels )

	local height = bit.rshift( self.Height, level - 1 )
	if height < 4 then
		height = 4
	end
	return height
end

--- "Get the width of level 0 of non-reduced texture"
--- @return integer
function INSTANCE:GetFullWidth()
	return self.FullWidth
end

--- "Get the height of level 0 of non-reduced texture"
--- @return integer
function INSTANCE:GetFullHeight()
	return self.FullHeight
end

--- @return integer
function INSTANCE:GetDateTime()
	return self.DateTime
end

--- @return integer
function INSTANCE:GetMipLevelCount()
	return self.MipLevels
end

--- Replaces "Get_Memory_Pointer"
--- @param level integer
--- @return integer index
function INSTANCE:GetMemoryIndex( level )
	return self.LevelOffsets[level]
end

--- @param level integer
--- @return integer
function INSTANCE:GetLevelSize( level )
	assert( level <= self.MipLevels )
	return self.LevelSizes[level]
end

--- @return WW3dFormat
function INSTANCE:GetFormat()
	return self.Format
end

--- "  
--- Copy one mipmap level of texture to a memory surface.  
--- Surface type conversion is performed if the destination is of different format.  
--- Scaling will be done one of these days as well. Conversions between different types of compressed
--- surfaces are not performed and scaling of compressed surfaces is also not possible.    
--- "  
--- @param level integer
--- @param destinationFormat WW3dFormat
--- @param width integer
--- @param height integer
--- @param renderTarget ITexture
function INSTANCE:CopyLevelToSurface( level, destinationFormat, width, height, renderTarget )
	local containsAlpha = false

	render.PushRenderTarget( renderTarget )
	cam.Start2D()
	render.OverrideAlphaWriteEnable( true, true )
	render.Clear( 0, 0, 0, 0, true, true )

	render.OverrideBlend( false )

	for y = 0, height - 1, 4 do
		for x = 0, width - 1, 4 do
			local blockContainsAlpha = self:Get4X4Block( level, x, y, destinationFormat )
			containsAlpha = containsAlpha or blockContainsAlpha
		end
	end

	render.OverrideAlphaWriteEnable( false, false )
	cam.End2D()
	render.PopRenderTarget()

	if self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT1 and containsAlpha then
		section.Warn( "DXT1 format should not contain alpha information - file ", self.Name )
	end
end

--- @param x integer
--- @param y integer
--- @return integer
function INSTANCE:GetPixel( x, y )
	typecheck.NotImplementedError()
end

--- @param argb integer
--- @return Color
local function argbToColor( argb )
	local alpha = bit.band( argb, 0xFF000000 )
	alpha = bit.rshift( alpha, 8 * 3 )

	local red = bit.band( argb, 0x00FF0000 )
	red = bit.rshift( red, 8 * 2 )

	local green = bit.band( argb, 0x0000FF00 )
	green = bit.rshift( green, 8 * 1 )

	local blue = bit.band( argb, 0x000000FF )

	return Color( red, green, blue, alpha )
end

--- @param x integer
--- @param y integer
--- @param colorInt integer
local function drawPixel( x, y, colorInt )
	local color = argbToColor( colorInt )

	surface.SetDrawColor( color )
	surface.DrawRect( x, y, 1, 1 )
end

--- @param level integer
--- @param sourceX integer
--- @param sourceY integer
--- @param destinationFormat WW3dFormat
--- @return boolean containsAlpha
function INSTANCE:Get4X4Block( level, sourceX, sourceY, destinationFormat )

	-- "Verify the block alignment"
	assert( bit.band( sourceX, 3 ) == 0, "SourceX: " .. sourceX )
	assert( bit.band( sourceY, 3 ) == 0 )

	-- "Verify level"
	assert( level < self.MipLevels )

	-- "Verify coordinate bounds"
	local width  = self:GetWidth( level )
	local height = self:GetHeight( level )
	assert( sourceX <= width, "SourceX: " .. sourceX .. ", level: " .. level .. ", width: " .. self:GetWidth( level ) )
	assert( sourceY <= height, "SourceY: " .. sourceY .. ", level: " .. level .. ", height: " .. self:GetHeight( level )  )

	if self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT1 then
		local blockMemoryIndex = self:GetMemoryIndex( level ) + ( sourceX / 4 ) * 8 + ( ( sourceY / 4 ) * ( width / 4 ) ) * 8
		if blockMemoryIndex + 3 > self.DdsMemory:len() then
			section.Warn( "Skipping getPixel because index ", blockMemoryIndex, " is beyond the DDS memory's max length of ", #self.DdsMemory )
		end

		local blockMemory0String = self.DdsMemory:sub( blockMemoryIndex + 0, blockMemoryIndex + 1 )
		local blockMemory2String = self.DdsMemory:sub( blockMemoryIndex + 2, blockMemoryIndex + 3 )

		local blockMemory0 = deserializeLib.DeserializeUInt16( blockMemory0String )
		local blockMemory2 = deserializeLib.DeserializeUInt16( blockMemory2String )

		local color0 = STATIC.RGB565ToARGB8888( blockMemory0 )
		local color1 = STATIC.RGB565ToARGB8888( blockMemory2 )

		-- "Even if we don't support alpha, decompression is different if source has alpha"
		local destinationPixel = 0
		if color0 > color1 then
			for y = 0, 3 do
				local lineIndex = blockMemoryIndex + 4 + y
				local line = string.byte( self.DdsMemory, lineIndex, lineIndex )
				for x = 0, 3 do
					local lineBand = bit.band( line, 3 )

					if lineBand == 0 then
						destinationPixel = bit.bor( color0, 0xFF000000 )
					elseif lineBand == 1 then
						destinationPixel = bit.bor( color1, 0xFF000000 )
					elseif lineBand == 2 then
						destinationPixel = bit.bor( STATIC.CombineColors( color1, color0, 85 ), 0xFF000000 )
					elseif lineBand == 3 then
						destinationPixel = bit.bor( STATIC.CombineColors( color0, color1, 85 ), 0xFF000000 )
					end

					line = bit.rshift( line, 2 )

					drawPixel( sourceX + x, sourceY + y, destinationPixel )
				end
			end

			return false -- "No alpha found in the block"
		else
			local containsAlpha = false
			for y = 0, 3 do
				local lineIndex = blockMemoryIndex + 4 + y
				local line = deserializeLib.DeserializeUInt16( self.DdsMemory:sub( lineIndex, lineIndex + 1 ) )
				for x = 0, 3 do
					local lineBand = bit.band( line, 3 )

					if lineBand == 0 then
						destinationPixel = bit.bor( color0, 0xFF000000 )
					elseif lineBand == 1 then
						destinationPixel = bit.bor( color1, 0xFF000000 )
					elseif lineBand == 2 then
						destinationPixel = bit.bor( STATIC.CombineColors( color1, color0, 128 ), 0xFF000000 )
					elseif lineBand == 3 then
						destinationPixel = 0x00000000
						containsAlpha = true
					end

					line = bit.rshift( line, 2 )

					drawPixel( sourceX + x, sourceY + y, destinationPixel )
				end
			end

			return containsAlpha -- "Alpha block...?"
		end
	
	elseif self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT2 then
		return false
	elseif self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT3 then
		return false
	elseif self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT4 then
		return false
	elseif self.Format == wW3dFormatEnum.WW3D_FORMAT_DXT5 then
		-- "Init alphas"
		local alphaBlockIndex = self:GetMemoryIndex( level ) + ( sourceX / 4 ) * 16 + ( ( sourceY / 4 ) * ( width / 4 ) ) * 16
		local alphaBlock = self.DdsMemory:sub( alphaBlockIndex )

		local alphas = {}
		alphas[1] = deserializeLib.DeserializeUInt8( alphaBlock:sub( 1, 1 ) )
		alphas[2] = deserializeLib.DeserializeUInt8( alphaBlock:sub( 2, 2 ) )

		-- "8-alpha or 6-alpha block?"
		if alphas[1] > alphas[2] then
			alphas[3] = ( 6 * alphas[1] + 1 * alphas[2] + 3 ) / 7 -- "Bit code 010"
			alphas[4] = ( 5 * alphas[1] + 2 * alphas[2] + 3 ) / 7 -- "Bit code 011"
			alphas[5] = ( 4 * alphas[1] + 3 * alphas[2] + 3 ) / 7 -- "Bit code 100"
			alphas[6] = ( 3 * alphas[1] + 4 * alphas[2] + 3 ) / 7 -- "Bit code 101"
			alphas[7] = ( 2 * alphas[1] + 5 * alphas[2] + 3 ) / 7 -- "Bit code 110"
			alphas[8] = ( 1 * alphas[1] + 6 * alphas[2] + 3 ) / 7 -- "Bit code 111"
		else
			alphas[3] = ( 4 * alphas[1] + 1 * alphas[2] + 2 ) / 5 -- "Bit code 010"
			alphas[4] = ( 3 * alphas[1] + 2 * alphas[2] + 2 ) / 5 -- "Bit code 011"
			alphas[5] = ( 2 * alphas[1] + 3 * alphas[2] + 2 ) / 5 -- "Bit code 100"
			alphas[6] = ( 1 * alphas[1] + 4 * alphas[2] + 2 ) / 5 -- "Bit code 101"
			alphas[7] = 0                                         -- "Bit code 110"
			alphas[8] = 255                                       -- "Bit code 111"
		end

		-- "Init colors"
		local colorBlockIndex = alphaBlockIndex + 8
		local colorBlock0String = self.DdsMemory:sub( colorBlockIndex + 0, colorBlockIndex + 1 )
		local colorBlock2String = self.DdsMemory:sub( colorBlockIndex + 2, colorBlockIndex + 3 )
		local colorBlock0 = deserializeLib.DeserializeUInt16( colorBlock0String )
		local colorBlock2 = deserializeLib.DeserializeUInt16( colorBlock2String )
		local color0 = STATIC.RGB565ToARGB8888( colorBlock0 )
		local color1 = STATIC.RGB565ToARGB8888( colorBlock2 )

		local destinationPixel = 0
		local bitIndex = 0
		local containsAlpha = 0xFF

		local alphaIndices = {}
		local alphaIndicesIndex = 1

		-- A bit mask for the rightmost three bits
		local threeBitMask = 0x7

		for a = 0, 1 do
			local alphaBlock3 = ( alphaBlock:byte( 3, 3 ) )
			local alphaBlock4 = ( alphaBlock:byte( 4, 4 ) )
			local alphaBlock5 = ( alphaBlock:byte( 5, 5 ) )

			alphaIndices[alphaIndicesIndex + 0] = 1 + bit.band( alphaBlock3, threeBitMask )
			alphaIndices[alphaIndicesIndex + 1] = 1 + bit.band( bit.rshift( alphaBlock3, 3 ), threeBitMask )
			alphaIndices[alphaIndicesIndex + 2] = 1 +  bit.bor( bit.rshift( alphaBlock3, 6 ), bit.lshift( bit.band( alphaBlock4, 1 ), 2 ) )
			alphaIndices[alphaIndicesIndex + 3] = 1 + bit.band( bit.rshift( alphaBlock4, 1 ), threeBitMask )
			alphaIndices[alphaIndicesIndex + 4] = 1 + bit.band( bit.rshift( alphaBlock4, 4 ), threeBitMask )
			alphaIndices[alphaIndicesIndex + 5] = 1 +  bit.bor( bit.rshift( alphaBlock4, 7 ), bit.lshift( bit.band( alphaBlock5, 3 ), 1 ) )
			alphaIndices[alphaIndicesIndex + 6] = 1 + bit.band( bit.rshift( alphaBlock5, 2 ), threeBitMask )
			alphaIndices[alphaIndicesIndex + 7] = 1 + bit.rshift( alphaBlock5, 5 )

			alphaIndicesIndex = alphaIndicesIndex + 8
			alphaBlockIndex = alphaBlockIndex + 3
			alphaBlock = self.DdsMemory:sub( alphaBlockIndex )
		end

		alphaIndicesIndex = 1
		for y = 0, 3 do
			local lineIndex = colorBlockIndex + 4 + y
			local line = string.byte( self.DdsMemory, lineIndex, lineIndex )
			for x = 0, 3 do
				local alphaValue = alphas[alphaIndices[alphaIndicesIndex]]
				alphaIndicesIndex = alphaIndicesIndex + 1
				containsAlpha = bit.band( containsAlpha, alphaValue )
				alphaValue = bit.lshift( alphaValue, 24 )

				-- "Extract color"
				local lineBand = bit.band( line, 3 )
				if lineBand == 0 then
					destinationPixel = bit.bor( color0, alphaValue )
				elseif lineBand == 1 then
					destinationPixel = bit.bor( color1, alphaValue )
				elseif lineBand == 2 then
					destinationPixel = bit.bor( STATIC.CombineColors( color1, color0, 85 ), alphaValue )
				elseif lineBand == 3 then
					destinationPixel = bit.bor( STATIC.CombineColors( color0, color1, 85 ), alphaValue )
				end

				line = bit.rshift( line, 2 )

				drawPixel( sourceX + x, sourceY + y, destinationPixel )

				bitIndex = bitIndex + 3
			end
		end

	end

	return false
end

--- @return boolean success
function INSTANCE:Load()
	if self.DdsMemory then
		return false
	end

	if not self.LevelSizes or not self.LevelOffsets then
		return false
	end

	local file = fileFactoryClass.TheFileFactory:GetFile( self.Name )
	if not file:IsAvailable() then
		return false
	end

	file:Open()

	
	-- "Data size is file size minus the header and info block"
	local headerSize = 4
	local size = file:Size() - self.SurfaceDescription.Size - headerSize

	-- "Skip mip levels if reduction factor is not zero"
	local levelSize = STATIC.CalculateDxtcSurfaceSize( self.SurfaceDescription.Width, self.SurfaceDescription.Height, self.Format )
	local skippedOffset = 0


	-- for i = 0, self.ReductionFactor do
	-- 	skippedOffset = skippedOffset + levelSize
	-- 	size = size - levelSize
	-- 	-- "If surface is bigger than one block (8 or 16)..."
	-- 	if levelSize > 16 then
	-- 		levelSize = levelSize / 4
	-- 	end
	-- end

	-- "Skip the header and info block and possible unused mip levels"
	local seekSize = file:Seek( self.SurfaceDescription.Size + headerSize + skippedOffset )
	assert( seekSize == self.SurfaceDescription.Size + headerSize + skippedOffset )

	if tobool( size ) then
		-- "Allocate memory for the data excluding the headers"
		-- "Read data"
		local readBytes, readByteCount = file:Read( size )

		self.DdsMemory = readBytes
		-- "Verify we got all the data"
		assert( readByteCount == size )
	end
	file:Close()

	return true
end

--- @return boolean
function INSTANCE:IsAvailable()
	return not not tobool( self.LevelSizes )
end
