-- This is a library for parsing IMA ADPCM encoded WAVE files and decoding them into 16 bit samples

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class WaveFileLib
local LIB = CNC.CreateExport()
LIB.Class = "WaveFileLib"
local isHotload = not table.IsEmpty( LIB )

--#region Exported Enums
--#endregion

--#region Imports

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )

	--- @type SoundBufferClass
	local soundBufferClass = CNC.Import( "code/wwaudio/sound-buffer.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
	local waveFormatEnum = soundBufferClass.WAVE_FORMAT
--#endregion

--- @class ImaAdpcmDecoderState
--- @field previousPredictedSample integer
--- @field previousStepSizeIndex integer

--- @class WaveFileLib

LIB.IndexTable = {
    -1, -1, -1, -1, 2, 4, 6, 8,
    -1, -1, -1, -1, 2, 4, 6, 8
}

LIB.StepSizeTable = {
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


function LIB.StaticConstructor()

    --[[ WAVE File ]] do

        --- @class WaveFile
        --- @field RiffHeader WaveHeaderChunk
        --- @field FormatChunk WaveFormatChunk|WaveFormatExChunk

        --- "The header used by every chunk within a RIFF file (including the root chunk)"
        --- @class ChunkHeader
        --- @field ChunkId integer
        --- @field ChunkSize integer
        deserializeLib.RegisterComplexDataType( "ChunkHeader", {
            { Name = "ChunkId", DataType = fundamentalDataTypeEnum.UInt32 },
            { Name = "ChunkSize", DataType = fundamentalDataTypeEnum.UInt32 },
        } )

        --- @class WaveHeaderChunk
        --- @field Header ChunkHeader
        --- @field FileTypeChunkId integer
        deserializeLib.RegisterComplexDataType( "WaveHeaderChunk", {
            { Name = "Header", 			DataType = "ChunkHeader" },
            { Name = "FileTypeChunkId", DataType = fundamentalDataTypeEnum.UInt32 }
        } )

        --- Credit: https://web.archive.org/web/20260116114137/https://wiki.multimedia.cx/index.php/WAVEFORMAT
        --- @class WaveFormatChunk
        --- @field Header ChunkHeader
        --- @field AudioFormat integer
        --- @field ChannelCount integer
        --- @field Frequency integer
        --- @field BytesPerSecond integer
        --- @field BytesPerBlock integer
        --- @field BitsPerSample integer
        deserializeLib.RegisterComplexDataType( "WaveFormatChunk", {
            { Name = "Header", DataType = "ChunkHeader" },

            -- Common Fields
            { Name = "AudioFormat",    DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "ChannelCount",   DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Frequency", 	  DataType = fundamentalDataTypeEnum.UInt32 },
            { Name = "BytesPerSecond", DataType = fundamentalDataTypeEnum.UInt32 },
            { Name = "BytesPerBlock",  DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "BitsPerSample",  DataType = fundamentalDataTypeEnum.UInt16 },
        } )

        --- Credit: https://web.archive.org/web/20260116114137/https://wiki.multimedia.cx/index.php/WAVEFORMATEX
        --- @class WaveFormatExChunk
        --- @field Header ChunkHeader
        --- @field AudioFormat integer
        --- @field ChannelCount integer
        --- @field Frequency integer
        --- @field BytesPerSecond integer
        --- @field BytesPerBlock integer
        --- @field BitsPerSample integer
        --- @field ExtraDataSize integer
        --- @field ExtraData string
        deserializeLib.RegisterComplexDataType( "WaveFormatExChunk", {
            { Name = "Header", DataType = "ChunkHeader" },

            -- Common Fields
            { Name = "AudioFormat",    DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "ChannelCount",   DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Frequency", 	  DataType = fundamentalDataTypeEnum.UInt32 },
            { Name = "BytesPerSecond", DataType = fundamentalDataTypeEnum.UInt32 },
            { Name = "BytesPerBlock",  DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "BitsPerSample",  DataType = fundamentalDataTypeEnum.UInt16 },

            -- Format-Specific Fields
            { Name = "ExtraDataSize",  DataType = fundamentalDataTypeEnum.UInt16 }
            -- ExtraData field is omitted as its length is not fixed
        } )
    end


    --[[ IMA ADPCM WAVE File ]] do

        --- @class WaveFactChunk
        --- @field Header ChunkHeader
        --- @field SampleCount integer
        deserializeLib.RegisterComplexDataType( "WaveFactChunk", {
            { Name = "Header", 		DataType = "ChunkHeader" },
            { Name = "SampleCount", DataType = fundamentalDataTypeEnum.UInt32 }
        } )

        --- @class ImaAdpcmEncodedDataBlock
        --- @field InitialPredictor integer
        --- @field InitialIndex integer
        --- @field Reserved integer
        --- @field Samples string
        deserializeLib.RegisterComplexDataType( "ImaAdpcmEncodedDataBlock", {
            { Name = "InitialPredictor", DataType = fundamentalDataTypeEnum.Int16 },
            { Name = "InitialIndex",     DataType = fundamentalDataTypeEnum.UInt8 },
            { Name = "Reserved",         DataType = fundamentalDataTypeEnum.UInt8 },
            -- Samples field is omitted as its length is not fixed
        } )

        --- @class ImaAdpcmWaveDataChunk
        --- @field Header ChunkHeader
        --- @field Blocks ImaAdpcmEncodedDataBlock[]
        deserializeLib.RegisterComplexDataType( "ImaAdpcmWaveDataChunk", {
            { Name = "Header",	DataType = "ChunkHeader" },
            -- Blocks field is omitted as its length is not fixed
        } )

        --- @class ImaAdpcmWaveFile : WaveFile
        --- @field FactChunk WaveFactChunk
        --- @field DataChunk ImaAdpcmWaveDataChunk
        deserializeLib.RegisterComplexDataType( "ImaAdpcmWaveFile", {
            { Name = "WaveHeader",	DataType = "WaveHeaderChunk" },
            { Name = "FormatChunk",	DataType = "WaveFormatExChunk" },
            { Name = "FactChunk",	DataType = "WaveFactChunk" },
            { Name = "DataChunk",	DataType = "ImaAdpcmWaveDataChunk" },
        } )
    end

    --[[ PCM WAVE File ]] do

        --- @class PcmWaveDataChunk
        --- @field Header ChunkHeader
        --- @field Data string
        deserializeLib.RegisterComplexDataType( "PcmWaveDataChunk", {
            { Name = "Header",	DataType = "ChunkHeader" },
            -- Data field is omitted as its length is not fixed
        } )

        --- @class PcmWaveFile : WaveFile
        --- @field DataChunk PcmWaveDataChunk
        deserializeLib.RegisterComplexDataType( "ImaAdpcmWaveFile", {
            { Name = "WaveHeader",	DataType = "WaveHeaderChunk" },
            { Name = "FormatChunk",	DataType = "WaveFormatChunk" },
            { Name = "DataChunk",	DataType = "PcmWaveDataChunk" },
        } )

    end




end

--- @private
--- @param interleaved string
--- @return string leftChannel, string rightChannel
function LIB.DeinterleaveImaData( interleaved )
    local leftChannel, rightChannel = {}, {}

    if interleaved:len() % 2 ~= 0 then
        section.Error( "Interleaved stereo buffer length must be even" )
    end

    local perChannelLength = interleaved:len() / 2

    local interleavedIndex = 1
    for i = 1, perChannelLength do
        leftChannel[i] = interleaved[interleavedIndex]
        interleavedIndex = interleavedIndex + 1

        rightChannel[i] = interleaved[interleavedIndex]
        interleavedIndex = interleavedIndex + 1
    end

    return table.concat( leftChannel ), table.concat( rightChannel )
end

--- @private
--- @param leftChannelSamples string
--- @param rightChannelSamples string
--- @return string
function LIB.InterleaveStereo( leftChannelSamples, rightChannelSamples )
    if leftChannelSamples:len() ~= rightChannelSamples:len() then
        section.Error( "Stereo audio channels must be the same length.  Left len: ", leftChannelSamples:len(), ", Right len: ", rightChannelSamples:len() )
    end

    local output = {}

    local outputIndex = 1
    for sampleIndex = 1, leftChannelSamples:len() do
        output[outputIndex] = leftChannelSamples[sampleIndex]
        outputIndex = outputIndex + 1

        output[outputIndex] = rightChannelSamples[sampleIndex]
        outputIndex = outputIndex + 1
    end

    return table.concat( output )
end

--- @param waveFile WaveFile
--- @return string
function LIB.DecodeWave( waveFile )
    local format = waveFile.FormatChunk.AudioFormat
    if format == waveFormatEnum.WAVE_FORMAT_IMA_ADPCM then
        return LIB.DecodeImaAdpcmWaveFile( waveFile --[[@as ImaAdpcmWaveFile]] )
    elseif format == waveFormatEnum.WAVE_FORMAT_PCM then
        typecheck.NotImplementedError()
    else
        section.Error( "Format ", format, " is not yet supported." )
    end
end

--- @param waveFile ImaAdpcmWaveFile
--- @return string
function LIB.DecodeImaAdpcmWaveFile( waveFile )
    local channelCount = waveFile.FormatChunk.ChannelCount
    if channelCount ~= 1 and channelCount ~= 2 then
        section.Error( "Only mono and stereo WAVE files are supported.  Channel count was: ", channelCount )
    end

    local outputBuffer = {}

    for blockIndex, block in ipairs( waveFile.DataChunk.Blocks ) do
        -- Mono
        if channelCount == 1 then
            outputBuffer[#outputBuffer + 1] = LIB.DecodeImaAdpcmSamples( block.Samples, block.InitialPredictor, block.InitialIndex )

        -- Stereo
        else
            -- Pull channels apart
            local leftEncodedSamples, rightEncodedSamples = LIB.DeinterleaveImaData( block.Samples )

            -- Decode channels
            local leftDecodedSamples = LIB.DecodeImaAdpcmSamples( leftEncodedSamples, block.InitialPredictor, block.InitialIndex )
            local rightDecodedSamples = LIB.DecodeImaAdpcmSamples( rightEncodedSamples, block.InitialPredictor, block.InitialIndex )

            -- Put channels back together
            local interleavedDecodedSamples = LIB.InterleaveStereo( leftDecodedSamples, rightDecodedSamples )

            outputBuffer[#outputBuffer + 1] = interleavedDecodedSamples
        end
    end

    local decodedSamples = table.concat( outputBuffer )
    return decodedSamples
end

--- @private
--- @param sampleBytes string
--- @param initialPredictor integer
--- @param initialIndex integer
--- @return string
function LIB.DecodeImaAdpcmSamples( sampleBytes, initialPredictor, initialIndex )
    local outputBuffer = {}

    --- @type ImaAdpcmDecoderState
    local state = {
        previousPredictedSample = initialPredictor,
        previousStepSizeIndex = initialIndex
    }

    do -- The initial predictor is itself a sample so we need to add that to the output buffer 
        local decodedLowByte = bit.band( initialPredictor, 0xFF )
        local decodedHighByte = bit.band( bit.rshift( initialPredictor, 8 ), 0xFF )
        outputBuffer[#outputBuffer + 1] = string.char( decodedLowByte, decodedHighByte )
    end

    for codedByteIndex = 1, sampleBytes:len() do
        local codedByte = sampleBytes:byte( codedByteIndex, codedByteIndex )

        for nibbleIndex = 1, 2 do
            -- Get the coded 4 bit sample from this coded sample
            -- Note that nibble order here is: n1n0 n3n2 n5n4 ...
            local codedSample
            if nibbleIndex == 1 then
                codedSample = bit.band( codedByte, 0xF )
            else
                codedSample = bit.band( bit.rshift( codedByte, 4 ), 0xF )
            end

            local decodedSample = LIB.DecodeImaAdpcmNibble( codedSample, state )

            local decodedLowByte = bit.band( decodedSample, 0xFF )
            local decodedHighByte = bit.band( bit.rshift( decodedSample, 8 ), 0xFF )
            outputBuffer[#outputBuffer + 1] = string.char( decodedLowByte, decodedHighByte )
        end
    end

    -- section.Print()

	return table.concat( outputBuffer )
end

--- Credit to: https://gist.github.com/aquagoose/526a2d6bc829f39a01d29dc2de0b8146
--- @private
--- @param nibble integer The 4-bit ADPCM data in sign-magnitude format
--- @param state ImaAdpcmDecoderState The previous values of the predicted sample and quantizer step size index
function LIB.DecodeImaAdpcmNibble( nibble, state )
    local predictedSample = state.previousPredictedSample
    local index = state.previousStepSizeIndex

    local step = LIB.StepSizeTable[index + 1]

    local sign = bit.band( nibble, 8 )
    local delta = bit.band( nibble, 7 )
    local diff = bit.rshift( step, 3 )

    if bit.band( delta, 4 ) == 4 then
        diff = diff + step
    end
    if bit.band( delta, 2 ) == 2 then
        diff = diff + bit.rshift( step, 1 )
    end
    if bit.band( delta, 1 ) == 1 then
        diff = diff + bit.rshift( step, 2 )
    end

    if sign ~= 0 then
        predictedSample = predictedSample - diff
    else
        predictedSample = predictedSample + diff
    end

    predictedSample = math.Clamp( predictedSample, -32768, 32767 )

    index = index + LIB.IndexTable[nibble + 1]
    index = math.Clamp( index, 0, 88 )

    state.previousPredictedSample = predictedSample
    state.previousStepSizeIndex = index

    return predictedSample
end


--- @param bytes string
--- @return WaveFile
function LIB.DeserializeWaveFile( bytes )

    file.Write( "wave_bytes.txt", bytes )

    local format = deserializeLib.DeserializeFundamentalDataType( fundamentalDataTypeEnum.UInt16, bytes:sub( 21, 22 ) )

    if format == waveFormatEnum.WAVE_FORMAT_IMA_ADPCM then
        return LIB.DeserializeImaAdpcmWaveFile( bytes )
    elseif format == waveFormatEnum.WAVE_FORMAT_PCM then
        return LIB.DeserializePcmWaveFile( bytes )
    else
        section.Error( "Wave format ", format, " is not currently supported." )
    end
end

--- @param bytes string
--- @return PcmWaveFile
function LIB.DeserializePcmWaveFile( bytes )
    -- Wave Header Chunk
    local waveHeaderLength = deserializeLib.GetComplexDataTypeSize( "WaveHeaderChunk" )
    local waveHeaderBytes = bytes:sub( 1, waveHeaderLength )
    bytes = bytes:sub( waveHeaderLength + 1 )
    local waveHeader = deserializeLib.DeserializeComplexDataType( "WaveHeaderChunk", waveHeaderBytes )
    assert( waveHeader ~= nil )

    -- Wave Format Chunk
    local formatChunkLength = deserializeLib.GetComplexDataTypeSize( "WaveFormatChunk" )
    local formatChunkBytes = bytes:sub( 1, formatChunkLength )
    bytes = bytes:sub( formatChunkLength + 1 )
    local formatChunk = deserializeLib.DeserializeComplexDataType( "WaveFormatChunk", formatChunkBytes )
    assert( formatChunk ~= nil )

    -- PCM Wave Data Chunk
    local dataChunkLength = deserializeLib.GetComplexDataTypeSize( "PcmWaveDataChunk" )
    local dataChunkBytes = bytes:sub( 1, dataChunkLength )
    bytes = bytes:sub( dataChunkLength + 1 )
    local dataChunk = deserializeLib.DeserializeComplexDataType( "PcmWaveDataChunk", dataChunkBytes )
    assert( dataChunk ~= nil )

    dataChunk.Data = bytes:sub( 1, dataChunk.Header.ChunkSize )

    --- @type PcmWaveFile
    local waveFile = {
        RiffHeader = waveHeader,
        FormatChunk = formatChunk,
        DataChunk = dataChunk
    }

    return waveFile
end

--- @param bytes string
--- @return ImaAdpcmWaveFile
function LIB.DeserializeImaAdpcmWaveFile( bytes )
    -- Wave Header Chunk
    local waveHeaderLength = deserializeLib.GetComplexDataTypeSize( "WaveHeaderChunk" )
    local waveHeaderBytes = bytes:sub( 1, waveHeaderLength )
    bytes = bytes:sub( waveHeaderLength + 1 )
    local waveHeader = deserializeLib.DeserializeComplexDataType( "WaveHeaderChunk", waveHeaderBytes )
    assert( waveHeader ~= nil )

    -- Wave Format Ex Chunk
    local formatExChunkLength = deserializeLib.GetComplexDataTypeSize( "WaveFormatExChunk" )
    local formatExChunkBytes = bytes:sub( 1, formatExChunkLength )
    bytes = bytes:sub( formatExChunkLength + 1 )
    local formatExChunk = deserializeLib.DeserializeComplexDataType( "WaveFormatExChunk", formatExChunkBytes )
    assert( formatExChunk ~= nil )

    -- Wave Format Ex Chunk - Wave Format Ex - ExtraData
    local extraData = bytes:sub( 1, formatExChunk.ExtraDataSize )
    bytes = bytes:sub( formatExChunk.ExtraDataSize + 1 )
    formatExChunk.ExtraData = extraData

    -- Wave Fact Chunk
    local factChunkLength = deserializeLib.GetComplexDataTypeSize( "WaveFactChunk" )
    local factChunkBytes = bytes:sub( 1, factChunkLength )
    bytes = bytes:sub( factChunkLength + 1 )
    local factChunk = deserializeLib.DeserializeComplexDataType( "WaveFactChunk", factChunkBytes )
    assert( factChunk ~= nil )

    -- Wave Data Chunk
    local dataChunkLength = deserializeLib.GetComplexDataTypeSize( "ImaAdpcmWaveDataChunk" )
    local dataChunkBytes = bytes:sub( 1, dataChunkLength )
    bytes = bytes:sub( dataChunkLength + 1 )
    local dataChunk = deserializeLib.DeserializeComplexDataType( "ImaAdpcmWaveDataChunk", dataChunkBytes )
    assert( dataChunk ~= nil )

    -- Wave Data Chunk - Blocks
    local encodedDataBlockLengthWithoutSamples = deserializeLib.GetComplexDataTypeSize( "ImaAdpcmEncodedDataBlock" )
    -- "Samples" field isn't included in the calculated size and needs to be added
    local encodedDataBlockByteCount = formatExChunk.BytesPerBlock - 4
    local encodedDataBlockLengthWithSamples = encodedDataBlockLengthWithoutSamples + encodedDataBlockByteCount
    local encodedDataBlockCount = dataChunk.Header.ChunkSize / encodedDataBlockLengthWithSamples

    dataChunk.Blocks = {}
    for encodedDataBlockIndex = 1, encodedDataBlockCount do
        -- Data Block Header
        local encodedDataBlockHeaderBytes = bytes:sub( 1, encodedDataBlockLengthWithoutSamples )
        bytes = bytes:sub( encodedDataBlockLengthWithoutSamples + 1 )
        local encodedDataBlock = deserializeLib.DeserializeComplexDataType( "ImaAdpcmEncodedDataBlock", encodedDataBlockHeaderBytes )
        assert( encodedDataBlock ~= nil )

        -- Data Block Samples
        local samples = bytes:sub( 1, encodedDataBlockByteCount )
        bytes = bytes:sub( encodedDataBlockByteCount + 1 )
        encodedDataBlock.Samples = samples

        dataChunk.Blocks[#dataChunk.Blocks + 1] = encodedDataBlock
    end

    --- @type ImaAdpcmWaveFile
    local waveFile = {
        RiffHeader = waveHeader,
        FormatChunk = formatExChunk,
        FactChunk = factChunk,
        DataChunk = dataChunk
    }

    return waveFile
end