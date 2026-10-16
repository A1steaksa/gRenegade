-- Based on SoundBufferClass within Code/WWAudio/SoundBuffer.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class SoundBufferClass
--- @field Instance SoundBufferInstance The metatable used by SoundBufferInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SoundBufferClass"

--- @class SoundBufferInstance
--- @field Static SoundBufferClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SoundBuffer" )
INSTANCE.Class = "SoundBufferInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSoundBuffer = true

--#region Exported Enums

	--- Enum values based on https://wasapi.dpldocs.info/~master/wasapi.coreaudio.WAVE_FORMAT_DVI_ADPCM.html
	--- @enum WaveFormat
	STATIC.WAVE_FORMAT = {
		WAVE_FORMAT_IMA_ADPCM = 0x0011
	}
	local waveFormatEnum = STATIC.WAVE_FORMAT

--#endregion

--#region Imports

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type FileFactoryClass
	local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

	--- @type ToolsLib
	local toolsLib = CNC.Import( "sh_tools.lua" )

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class SoundBufferClass

	STATIC.IndexTable = {
		-1, -1, -1, -1, 2, 4, 6, 8,
  		-1, -1, -1, -1, 2, 4, 6, 8
	}

	STATIC.StepSizeTable = {
		7, 8, 9, 10, 11, 12, 13, 14, 16, 17,
		19, 21, 23, 25, 28, 31, 34, 37, 41, 45,
		50, 55, 60, 66, 73, 80, 88, 97, 107, 118,
		130, 143, 157, 173, 190, 209, 230, 253, 279, 307,
		337, 371, 408, 449, 494, 544, 598, 658, 724, 796,
		876, 963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066,
		2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358,
		5894, 6484, 7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899,
		15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794, 32767
	}

    --- Creates a new SoundBufferInstance
    --- @return SoundBufferInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SoundBuffer" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SoundBufferInstance, `false` otherwise
    function STATIC.IsSoundBuffer( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSoundBuffer and true or false
    end

    typecheck.RegisterType( "SoundBufferInstance", STATIC.IsSoundBuffer )

	--- @param bytes string
	--- @return ImaAdpcmWaveFile
	function STATIC.ParseImaAdpcmWaveFile( bytes )
		-- Riff Header Chunk
		local riffHeaderLength = deserializeLib.GetComplexDataTypeSize( "RiffHeaderChunk" )
		local riffHeaderBytes = bytes:sub( 1, riffHeaderLength )
		bytes = bytes:sub( riffHeaderLength + 1 )
		local riffHeader = deserializeLib.DeserializeComplexDataType( "RiffHeaderChunk", riffHeaderBytes )
		assert( riffHeader ~= nil )

		-- Wave Format Chunk
		local formatChunkLength = deserializeLib.GetComplexDataTypeSize( "WaveFormatChunk" )
		local formatChunkBytes = bytes:sub( 1, formatChunkLength )
		bytes = bytes:sub( formatChunkLength + 1 )
		local formatChunk = deserializeLib.DeserializeComplexDataType( "WaveFormatChunk", formatChunkBytes )
		assert( formatChunk ~= nil )

		-- Wave Format Chunk - Wave Format Ex
		local waveFormatExLength = deserializeLib.GetComplexDataTypeSize( "WaveFormatEx" )
		local waveFormatExBytes = bytes:sub( 1, waveFormatExLength )
		bytes = bytes:sub( waveFormatExLength + 1 )
		local waveFormatEx = deserializeLib.DeserializeComplexDataType( "WaveFormatEx", waveFormatExBytes )
		assert( waveFormatEx ~= nil )
		formatChunk.Format = waveFormatEx

		-- Wave Format Chunk - Wave Format Ex - ExtraData
		local extraData = bytes:sub( 1, waveFormatEx.ExtraDataSize )
		bytes = bytes:sub( waveFormatEx.ExtraDataSize + 1 )
		waveFormatEx.ExtraData = extraData

		-- Wave Fact Chunk
		local factChunkLength = deserializeLib.GetComplexDataTypeSize( "WaveFactChunk" )
		local factChunkBytes = bytes:sub( 1, factChunkLength )
		bytes = bytes:sub( factChunkLength + 1 )
		local factChunk = deserializeLib.DeserializeComplexDataType( "WaveFactChunk", factChunkBytes )
		assert( factChunk ~= nil )

		-- Wave Data Chunk
		local dataChunkLength = deserializeLib.GetComplexDataTypeSize( "WaveDataChunk" )
		local dataChunkBytes = bytes:sub( 1, dataChunkLength )
		bytes = bytes:sub( dataChunkLength + 1 )
		local dataChunk = deserializeLib.DeserializeComplexDataType( "WaveDataChunk", dataChunkBytes )
		assert( dataChunk ~= nil )

		-- Wave Data Chunk - Blocks
		local encodedDataBlockLengthWithoutSamples = deserializeLib.GetComplexDataTypeSize( "ImaAdpcmEncodedDataBlock" )
		-- "Samples" field isn't included in the calculated size and needs to be added
		local encodedDataBlockByteCount = formatChunk.Format.BytesPerBlock - 4
		local encodedDataBlockLengthWithSamples = encodedDataBlockLengthWithoutSamples + encodedDataBlockByteCount
		local encodedDataBlockCount = dataChunk.Header.ChunkSize / encodedDataBlockLengthWithSamples

		dataChunk.Blocks = {}
		for _ = 1, encodedDataBlockCount do
			local encodedDatablockBytes = bytes:sub( 1, encodedDataBlockLengthWithSamples )
			bytes = bytes:sub( encodedDataBlockLengthWithSamples + 1 )

			-- The first bytes of the encoded data block are the header
			local encodedDataBlock = deserializeLib.DeserializeComplexDataType( "ImaAdpcmEncodedDataBlock", encodedDatablockBytes )
			assert( encodedDataBlock ~= nil )
			encodedDatablockBytes = encodedDatablockBytes:sub( encodedDataBlockLengthWithoutSamples + 1 )

			-- The remaining bytes after the header are the samples
			encodedDataBlock.Samples = encodedDatablockBytes

			dataChunk.Blocks[#dataChunk.Blocks + 1] = encodedDataBlock
		end

		--- @type ImaAdpcmWaveFile
		local waveFile = {
			RiffHeader = riffHeader,
			FormatChunk = formatChunk,
			FactChunk = factChunk,
			DataChunk = dataChunk
		}

		return waveFile
	end

	function STATIC.StaticConstructor()

		--- "The header used by every chunk within a RIFF file (including the root chunk)"
		--- @class RiffChunkHeader
		--- @field ChunkId integer
		--- @field ChunkSize integer
		deserializeLib.RegisterComplexDataType( "RiffChunkHeader", {
			{ Name = "ChunkId", DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "ChunkSize", DataType = fundamentalDataTypeEnum.UInt32 },
		} )

		--- Credit: https://web.archive.org/web/20260116114137/https://wiki.multimedia.cx/index.php/WAVEFORMATEX
		--- @class WaveFormatEx
		--- @field AudioFormat integer
		--- @field ChannelCount integer
		--- @field Frequency integer
		--- @field BytesPerSecond integer
		--- @field BytesPerBlock integer
		--- @field BitsPerSample integer
		--- @field ExtraDataSize integer
		--- @field ExtraData string
		deserializeLib.RegisterComplexDataType( "WaveFormatEx", {
			-- Common Fields
			{ Name = "AudioFormat",    DataType = fundamentalDataTypeEnum.UInt16 },
			{ Name = "ChannelCount",   DataType = fundamentalDataTypeEnum.UInt16 },
			{ Name = "Frequency", 	  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "BytesPerSecond", DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "BytesPerBlock",  DataType = fundamentalDataTypeEnum.UInt16 },

			-- Format-Specific Fields
			{ Name = "BitsPerSample", DataType = fundamentalDataTypeEnum.UInt16 },
			{ Name = "ExtraDataSize", DataType = fundamentalDataTypeEnum.UInt16 }
			-- ExtraData field is omitted as its length is not fixed
		} )

		--- @class RiffHeaderChunk
		--- @field Header RiffChunkHeader
		--- @field FileTypeChunkId integer
		deserializeLib.RegisterComplexDataType( "RiffHeaderChunk", {
			{ Name = "Header", 			DataType = "RiffChunkHeader" },
			{ Name = "FileTypeChunkId", DataType = fundamentalDataTypeEnum.UInt32 }
		} )

		--- @class WaveFormatChunk
		--- @field Header RiffChunkHeader
		--- @field Format WaveFormatEx
		deserializeLib.RegisterComplexDataType( "WaveFormatChunk", {
			{ Name = "Header", DataType = "RiffChunkHeader" },
			-- Format field is omitted as its length is not fixed
		} )

		--- @class WaveFactChunk
		--- @field Header RiffChunkHeader
		--- @field SampleCount integer
		deserializeLib.RegisterComplexDataType( "WaveFactChunk", {
			{ Name = "Header", 		DataType = "RiffChunkHeader" },
			{ Name = "SampleCount", DataType = fundamentalDataTypeEnum.UInt32 }
		} )

		--- @class ImaAdpcmEncodedDataBlock
		--- @field InitialPredictor integer
		--- @field InitialIndex integer
		--- @field Reserved integer
		--- @field Samples string
		deserializeLib.RegisterComplexDataType( "ImaAdpcmEncodedDataBlock", {
			{ Name = "InitialPredictor",	DataType = fundamentalDataTypeEnum.UInt16 },
			{ Name = "InitialIndex", DataType = fundamentalDataTypeEnum.UInt8 },
			{ Name = "Reserved", DataType = fundamentalDataTypeEnum.UInt8 },
			-- Samples field is omitted as its length is not fixed
		} )

		--- @class WaveDataChunk
		--- @field Header RiffChunkHeader
		--- @field Blocks ImaAdpcmEncodedDataBlock[]
		deserializeLib.RegisterComplexDataType( "WaveDataChunk", {
			{ Name = "Header",	DataType = "RiffChunkHeader" },
			-- Blocks field is omitted as its length is not fixed
		} )

		--- @class ImaAdpcmWaveFile
		--- @field RiffHeader RiffHeaderChunk
		--- @field FormatChunk WaveFormatChunk
		--- @field FactChunk WaveFactChunk
		--- @field DataChunk WaveDataChunk
		deserializeLib.RegisterComplexDataType( "ImaAdpcmWaveFile", {
			{ Name = "RiffHeader",	DataType = "RiffHeaderChunk" },
			{ Name = "FormatChunk",	DataType = "WaveFormatChunk" },
			{ Name = "FactChunk",	DataType = "WaveFactChunk" },
			{ Name = "DataChunk",	DataType = "WaveDataChunk" },
		} )
	end
end


--- @class SoundBufferInstance
--- @field Buffer string
--- @field Length integer
--- @field Filename string
--- @field Duration integer
--- @field Rate integer
--- @field Bits integer
--- @field Channels integer
--- @field Type integer
--- @field DecodedSamples string

function INSTANCE:Renegade_SoundBuffer()
	self.Buffer = nil
	self.Length = 0
	self.Filename = nil
	self.Duration = 0
	self.Rate = 0
	self.Bits = 0
	self.Channels = 0
	self.Type = waveFormatEnum.WAVE_FORMAT_IMA_ADPCM
end

function INSTANCE:_Renegade_SoundBuffer()
	self:FreeBuffer()
end

--- @param encodedWave ImaAdpcmWaveFile
function INSTANCE:DecodeAdpcm( encodedWave )

	local outBuffer = {}
	local sign -- "Current ADPCM sign bit"
	local delta -- "Current ADPCM output value"
	local step -- "Stepsize"
	local predictedValue
	local predictedValueDifference -- "Current change ito [predictedValue]"
	local index = 0 -- "Current step change index"

	step = STATIC.StepSizeTable[index + 1]

	for encodedBlockIndex, encodedBlock in ipairs( encodedWave.DataChunk.Blocks ) do
		predictedValue = encodedBlock.InitialPredictor
		index = encodedBlock.InitialIndex
		-- step = STATIC.StepSizeTable[index + 1]

		local samples = encodedBlock.Samples

		for byteIndex = 1, samples:len() do
			local byte = samples:byte( byteIndex, byteIndex )

			for nibbleIndex = 1, 2 do

				-- "Step 1 - Get the delta value"
				if nibbleIndex == 2 then
					-- High nibble
					delta = bit.band( bit.rshift( byte, 4 ), 0xF )
				else
					-- Low nibble
					delta = bit.band( byte, 0xF )
				end

				-- "Step 2 - Find new index value (for later)"
				index = index + STATIC.IndexTable[delta + 1]
				if index < 0 then index = 0 end
				if index > 88 then index = 88 end

				-- "Step 3 - Separate sign and magnitude"
				sign = bit.band( delta, 8 )
				delta = bit.band( delta, 7 )

				-- "Step 4 - Compute difference and new predicted value"
				predictedValueDifference = bit.rshift( step, 3 )
				if bit.band( delta, 4 ) ~= 0 then
					predictedValueDifference = predictedValueDifference + step
				end

				if bit.band( delta, 2 ) ~= 0 then
					predictedValueDifference = predictedValueDifference + bit.rshift( step, 1 )
				end

				if bit.band( delta, 1 ) ~= 0 then
					predictedValueDifference = predictedValueDifference + bit.rshift( step, 2 )
				end

				if sign ~= 0 then
					predictedValue = predictedValue - predictedValueDifference
				else
					predictedValue = predictedValue + predictedValueDifference
				end

				-- "Step 5 - Clamp output value"
				predictedValue = math.Clamp( predictedValue, -32768, 32767  )

				-- "Step 6 - Update step value"
				step = STATIC.StepSizeTable[index + 1]

				-- "Step 7 - Output value"
				local highByte = bit.band( bit.rshift( predictedValue, 8 ), 0xFF )
				local lowByte  = bit.band( predictedValue, 0xFF )

				outBuffer[#outBuffer + 1] = string.char( lowByte, highByte )
			end
		end
	end

	self.Data = table.concat( outBuffer )
end

--- @param fileToLoad string|FileInstance
--- @return boolean
function INSTANCE:LoadFromFile( fileToLoad )
	typecheck.AssertArgType( INSTANCE.Class, 1, fileToLoad, { "string", "BufferedFileInstance" } )

	if isstring( fileToLoad ) then
		local fileName = fileToLoad --[[@as string]]

		-- "Assume failure"
		local returnValue = false

		-- "Param OK?"
		assert( fileName ~= nil )
		if fileName ~= nil then
			-- "Create a file object and pass it onto the appropriate function"
			local file = fileFactoryClass.TheFileFactory:GetFile( fileName )
			if file then
				returnValue = self:LoadFromFile( file )
				fileFactoryClass.TheFileFactory:ReturnFile( file )
			end
		end

		-- "Return the true/false result code"
		return returnValue
	else
		--- @cast fileToLoad FileInstance

		-- "Assume failure"
		local returnValue = false

		-- "Start from scratch"
		self:FreeBuffer()
		self:SetFilename( fileToLoad:FileName() )

		-- "Open the file if necessary"
		local weOpened = false
		if fileToLoad:IsOpen() == false then
			weOpened = fileToLoad:Open() == true
		end

		-- "Determine the size of the buffer"
		self.Length = fileToLoad:Size()
		assert( self.Length > 0 )
		if self.Length > 0 then
			-- "Allocate a new buffer of the correct length and read the contents of the file into the buffer"
			local readBytes, readByteCount = fileToLoad:Read( self.Length )
			self.Buffer = readBytes
			returnValue = readByteCount == self.Length

			-- "If we failed, free the buffer"
			if returnValue == false then
				self:FreeBuffer()
			end

			local parsedWav = STATIC.ParseImaAdpcmWaveFile( self.Buffer )
			self:DetermineStats( parsedWav )
			self:DecodeAdpcm( parsedWav )
		end

		-- "Close the file if necessary"
		if weOpened then
			fileToLoad:Close()
		end

		-- "Return the true/false result code"
		return returnValue
	end
end

--- @param memoryBuffer string
--- @return boolean
function INSTANCE:LoadFromMemory( memoryBuffer )
	typecheck.NotImplementedError()
end

--- @return string
function INSTANCE:GetRawBuffer()
	return self.Buffer
end

--- @return integer
function INSTANCE:GetRawLength()
	return self.Length
end

--- @return string
function INSTANCE:GetFilename()
	return self.Filename
end

--- @param name string
function INSTANCE:SetFilename( name )
	self.Filename = name
end

--- @return integer
function INSTANCE:GetDuration()
	return self.Duration
end

--- @return integer
function INSTANCE:GetRate()
	return self.Rate
end

--- @return integer
function INSTANCE:GetBits()
	return self.Bits
end

--- @return integer
function INSTANCE:GetChannels()
	return self.Channels
end

--- @return integer
function INSTANCE:GetType()
	return self.Type
end

--- @return boolean
function INSTANCE:IsStreaming()
	return false
end

function INSTANCE:FreeBuffer()
	-- "Free the buffer's memory"
	self.Buffer = nil

	-- "Make sure we reset the length"
	self.Length = 0
end

--- @param wave ImaAdpcmWaveFile
function INSTANCE:DetermineStats( wave )
	self.Duration = 0
	self.Rate     = 0
	self.Channels = 0
	self.Bits 	  = 0
	self.Type 	  = waveFormatEnum.WAVE_FORMAT_IMA_ADPCM

	-- "Cache this information"
	self.Rate 	  = wave.FormatChunk.Format.Frequency
	self.Channels = wave.FormatChunk.Format.ChannelCount
	self.Bits 	  = wave.FormatChunk.Format.BitsPerSample
	self.Type 	  = wave.FormatChunk.Format.AudioFormat

	-- "Determine how long this sound will play for"
	local bytesSec = bit.rshift( self.Channels * self.Rate * self.Bits, 3 )
	self.Duration = ( self.Length / bytesSec )
end

if isHotload then
	STATIC.StaticConstructor()
	toolsLib.HotloadTool( "ren_audio_tool" )
end
