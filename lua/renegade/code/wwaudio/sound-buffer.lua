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

	function STATIC.StaticConstructor()

		--- @class WaveHeader
		--- @field Riff string This should always contain the exact string "RIFF"
		--- @field Size integer The overall file size
		--- @field FileTypeHeader string This should always contain the exact string "WAVE"
		--- @field FormatChunkMarker string This should always contain the exact string "fmt" followed by a null character
		--- @field FormatDataLength integer The length of the preceeding fields.  Should probably be 16
		--- @field FormatType integer Should probably be 1 (PCM)
		--- @field ChannelCount integer The number of audio channels in the file
		--- @field SampleRate integer Must be either 11025, 22050, or 44100
		--- @field BytesPerSecond integer `(SampleRate * BitsPerSample * Channels)/8`
		--- @field StereoMonoSplit integer I don't know: `(BitsPerSample * Channels) / 8.1` - 8 bit mono2 - 8 bit stereo/16 bit mono4 - 16 bit stereo
		--- @field BitsPerSample integer
		--- @field DataChunkHeader string This should always contain the exact string "data"
		--- @field DataSize integer The number of bytes in the data section

		deserializeLib.RegisterComplexDataType( "WaveHeader", {
			{ Name = "Riff", 			  DataType = fundamentalDataTypeEnum.String, Length = 4 },
			{ Name = "Size", 			  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "FileTypeHeader", 	  DataType = fundamentalDataTypeEnum.String, Length = 4 },
			{ Name = "FormatChunkMarker", DataType = fundamentalDataTypeEnum.String, Length = 4 },
			{ Name = "FormatDataLength",  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "FormatType",  	  DataType = fundamentalDataTypeEnum.UInt16 },
			{ Name = "ChannelCount",  	  DataType = fundamentalDataTypeEnum.UInt16 },
			{ Name = "SampleRate",  	  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "BytesPerSecond", 	  DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "StereoMonoSplit",	  DataType = fundamentalDataTypeEnum.UInt16 },
			{ Name = "BitsPerSample", 	  DataType = fundamentalDataTypeEnum.UInt16 },
			{ Name = "DataChunkHeader",   DataType = fundamentalDataTypeEnum.String, Length = 4 },
			{ Name = "DataSize",		  DataType = fundamentalDataTypeEnum.UInt32 }
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
--- @field Header WaveHeader
--- @field Data string

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

function INSTANCE:DecodeAdpcm()
	local input = self.Data -- "Input buffer pointer"
	local outBuffer = {}
	local sign -- "Current ADPCM sign bit"
	local delta -- "Current ADPCM output value"
	local step -- "Stepsize"
	local predictedValue
	local predictedValueDifference -- "Current change ito [predictedValue]"
	local index -- "Current step change index"

	predictedValue = 0
	index = 0
	step = STATIC.StepSizeTable[index + 1]

	for byteIndex = 1, input:len() do
		local byte = input:byte( byteIndex, byteIndex )
		for nibbleIndex = 1, 0, -1 do

			-- "Step 1 - Get the delta value"
			-- Left nibble
			if nibbleIndex == 0 then
				delta = bit.band( bit.rshift( byte, 4 ), 0xF )
			-- Right nibble
			else
				delta = bit.band( byte, 0xF )
			end

			-- "Step 2 - Find new index value (for later)"
			index = index + STATIC.IndexTable[delta + 1]
			if index < 0 then index = 0 end
			if index > 88 then index = 88 end

			-- "Step 3 - Separate sign and magniture"
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
			if predictedValue > 32767 then
				predictedValue = 32767
			elseif predictedValue < -32768 then
				predictedValue = -32768
			end

			index = math.Clamp( index, 1, #STATIC.StepSizeTable - 1 )

			-- "Step 6 - Update step value"
			step = STATIC.StepSizeTable[index + 1]

			-- "Step 7 - Output value"

			--- Convert the 16 bit sample into two 8 bit chars
			local highByte = bit.band( bit.rshift( predictedValue, 8 ), 255 )
			local lowByte  = bit.band( predictedValue, 255 )

			local unsignedPredictedValue = (
				highByte * 0x100 +
				lowByte
			)

			highByte = bit.band( bit.rshift( unsignedPredictedValue, 8 ), 255 )
			lowByte  = bit.band( unsignedPredictedValue, 255 )

			outBuffer[#outBuffer + 1] = string.char( lowByte, highByte )
		end
	end

	self.Data = table.concat( outBuffer )
end

--- Ensures that the audio data is 16 bit
function INSTANCE:ConvertTo16Bit()
	local originalData = self.Data
	if self.Bits == 16 then return end

	local convertedData = {}

	local shiftTo16BitAmount = 16 - self.Bits

	local samplesPerByte = ( 8 / self.Bits )

	-- Create a mask so we can extract each sample's bits from the byte it's in
	local sampleMask = 0
	for i = 1, self.Bits do
		sampleMask = bit.bor( sampleMask, bit.lshift( 1, i - 1 ) )
	end

	for byteIndex = 1, originalData:len() do
		local byte = string.byte( originalData, byteIndex, byteIndex )

		for sampleIndex = 1, samplesPerByte do
			-- Extract the next sample from this byte, isolate it, and convert it to be 16 bits
			local sampleShiftCount = ( sampleIndex - 1 ) * self.Bits
			local shiftedSample = bit.rshift( byte, sampleShiftCount )
			local maskedSample = bit.band( shiftedSample, sampleMask )
			local completeSample = bit.lshift( maskedSample, shiftTo16BitAmount )

			--- Convert the 16 bit sample into two 8 bit chars
			local rightByte = bit.band( completeSample, 255 )
			local leftByte  = bit.band( bit.rshift( completeSample, 8 ), 255 )

			convertedData[#convertedData + 1] = string.char( rightByte )
			convertedData[#convertedData + 1] = string.char( leftByte )
		end
	end

	self.Data = table.concat( convertedData )
end

--- @param file string|FileInstance
--- @return boolean
function INSTANCE:LoadFromFile( file )
	typecheck.AssertArgType( INSTANCE.Class, 1, file, { "string", "BufferedFileInstance" } )

	if isstring( file ) then
		local fileName = file --[[@as string]]

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
		--- @cast file FileInstance

		-- "Assume failure"
		local returnValue = false

		-- "Start from scratch"
		self:FreeBuffer()
		self:SetFilename( file:FileName() )

		-- "Open the file if necessary"
		local weOpened = false
		if file:IsOpen() == false then
			weOpened = file:Open() == true
		end

		-- "Determine the size of the buffer"
		self.Length = file:Size()
		assert( self.Length > 0 )
		if self.Length > 0 then
			-- "Allocate a new buffer of the correct length and read the contents of the file into the buffer"
			local readBytes, readByteCount = file:Read( self.Length )
			self.Buffer = readBytes
			returnValue = readByteCount == self.Length

			-- "If we failed, free the buffer"
			if returnValue == false then
				self:FreeBuffer()
			end

			self:DetermineStats( self.Buffer )

			self:DecodeAdpcm()
		end

		-- "Close the file if necessary"
		if weOpened then
			file:Close()
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

--- @param buffer string
function INSTANCE:DetermineStats( buffer )
	self.Duration = 0
	self.Rate = 0
	self.Channels = 0
	self.Bits = 0
	self.Type = waveFormatEnum.WAVE_FORMAT_IMA_ADPCM

	-- "Attempt to get statistical information about this sound"
	local info = deserializeLib.Deserialize( "WaveHeader", self.Buffer )

	-- "Cache this information"
	self.Rate = info.SampleRate
	self.Channels = info.ChannelCount
	self.Bits = info.BitsPerSample
	self.Type = info.FormatType

	-- "Determine how long this sound will play for"
	local bytesSec = bit.rshift( self.Channels * self.Rate * self.Bits, 3 )
	self.Duration = ( self.Length / bytesSec )

	-- Extract the data portion while we still have the info object
	self.Header = info
	self.Data = self.Buffer:sub( 45, 45 + info.DataSize )
end

if isHotload then
	STATIC.StaticConstructor()
	toolsLib.HotloadTool( "ren_audio_tool" )
end
