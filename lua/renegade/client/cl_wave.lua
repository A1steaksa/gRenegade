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
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--- @class ImaAdpcmDecoderState
--- @field previousPredictedSample integer
--- @field previousStepSizeIndex integer

--- @class WaveFileLib

LIB.IndexTable = { 0xFF,
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

--- @param waveFile ImaAdpcmWaveFile
--- @return string
function LIB.DecodeWave( waveFile )
    if waveFile.FormatChunk.Format.AudioFormat ~= 0x11 then
        section.Error( "Only format 0x11 (17) IMA ADPCM WAV is supported." )
    end

    local channelCount = waveFile.FormatChunk.Format.ChannelCount
    if channelCount ~= 1 and channelCount ~= 2 then
        section.Error( "Only mono and stereo WAVE files are supported.  Channel count was: ", channelCount )
    end

    local outputBuffer = {}

    for blockIndex, block in ipairs( waveFile.DataChunk.Blocks ) do
        section.Print( "Block ", blockIndex, ", Initial Predictor: ", block.InitialPredictor, ", Initial Index: ", block.InitialIndex )
        -- Mono
        if channelCount == 1 then
            outputBuffer[#outputBuffer+1] = LIB.DecodeImaAdpcmSamples( block.Samples, block.InitialPredictor, block.InitialIndex )

        -- Stereo
        else
            -- Pull channels apart
            local leftEncodedSamples, rightEncodedSamples = LIB.DeinterleaveImaData( block.Samples )

            -- Decode channels
            local leftDecodedSamples = LIB.DecodeImaAdpcmSamples( leftEncodedSamples, block.InitialPredictor, block.InitialIndex )
            local rightDecodedSamples = LIB.DecodeImaAdpcmSamples( rightEncodedSamples, block.InitialPredictor, block.InitialIndex )

            -- Put channels back together
            local interleavedDecodedSamples = LIB.InterleaveStereo( leftDecodedSamples, rightDecodedSamples )

            outputBuffer[#outputBuffer+1] = interleavedDecodedSamples
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

    local codedByteIndexCountToPrint = 4

    for codedByteIndex = 1, sampleBytes:len() do
        local codedByte = sampleBytes:byte( codedByteIndex, codedByteIndex )

        local shouldPrintCodedIndex = codedByteIndex <= codedByteIndexCountToPrint or codedByteIndex > sampleBytes:len() - codedByteIndexCountToPrint

        local debugText = "Byte " .. codedByteIndex .. ": " .. textUtils.Hex( sampleBytes:sub( codedByteIndex, codedByteIndex ) ) .. " ("

        for nibbleIndex = 1, 2 do
            -- Get the coded 4 bit sample from this coded sample
            -- Note that nibble order here is: n1n0 n3n2 n5n4 ...
            local codedSample
            if nibbleIndex == 1 then
                codedSample = bit.band( codedByte, 0xF )
            else
                codedSample = bit.band( bit.rshift( codedByte, 4 ), 0xF )
            end

            debugText = debugText ..  "N" .. nibbleIndex .. ": " .. textUtils.Hex( string.char( codedSample ) )
            if nibbleIndex == 1 then debugText = debugText .. " " end

            local decodedSample = LIB.DecodeImaAdpcmByte( codedSample, state )

            local decodedLowByte = bit.band( decodedSample, 0xFF )
            local decodedHighByte = bit.band( bit.rshift( decodedSample, 8 ), 0xFF )
            outputBuffer[#outputBuffer + 1] = string.char( decodedLowByte, decodedHighByte )
        end

        debugText = debugText
        .. ") -> "
        .. textUtils.Hex( outputBuffer[#outputBuffer - 1] )
        .. " "
        .. textUtils.Hex( outputBuffer[#outputBuffer - 0] )
        section.PrintWhen( shouldPrintCodedIndex, debugText )
        section.PrintWhen( codedByteIndex == 6, "..." )
    end

    section.Print()

	return table.concat( outputBuffer )
end

--- @private
--- @param code integer The 4-bit ADPCM data in sign-magnitude format
--- @param state ImaAdpcmDecoderState The previous values of the predicted sample and quantizer step size index
function LIB.DecodeImaAdpcmByte( code, state )
    local predictedSample = state.previousPredictedSample
    local index = state.previousStepSizeIndex

    local step = LIB.StepSizeTable[index + 1]

    local difference = bit.rshift( step, 3 )
    if tobool( bit.band( code, 4 ) ) then
        difference = difference + step
    elseif tobool( bit.band( code, 2 ) ) then
        difference = difference + bit.rshift( step, 1 )
    elseif tobool( bit.band( code, 1 ) ) then
        difference = difference + bit.rshift( step, 2 )
    end

    if tobool( bit.band( code, 8 ) ) then
        predictedSample = predictedSample - difference
    else
        predictedSample = predictedSample + difference
    end

    if predictedSample > 32767 then
        predictedSample = 32767
    elseif predictedSample < -32768 then
        predictedSample = -32768
    end

    index = index + LIB.IndexTable[ code + 1 ]

    if index < 0 then
        index = 0
    elseif index > 88 then
        index = 88
    end

    state.previousPredictedSample = predictedSample
    state.previousStepSizeIndex = index

    return predictedSample
end


--- @param bytes string
--- @return ImaAdpcmWaveFile
function LIB.ParseImaAdpcmWaveFile( bytes )
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
        RiffHeader = riffHeader,
        FormatChunk = formatChunk,
        FactChunk = factChunk,
        DataChunk = dataChunk
    }

    return waveFile
end