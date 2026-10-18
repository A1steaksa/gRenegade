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

	--- @type WaveFileLib
	local waveFileLib = CNC.Import( "client/cl_wave.lua" )
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

			local parsedWave = waveFileLib.ParseImaAdpcmWaveFile( self.Buffer )
			self.DecodedSamples = waveFileLib.DecodeWave( parsedWave )
			self:DetermineStats( parsedWave )
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
