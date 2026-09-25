-- Based on BitChannelClass within var/home/JSchneider/Projects/LuaRenegadePort/C&amp;C Renegade/Code/ww3d2/motchan.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class BitChannelClass
--- @field Instance BitChannelInstance The metatable used by BitChannelInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BitChannelClass"

--- @class BitChannelInstance
--- @field Static BitChannelClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BitChannel" )
INSTANCE.Class = "BitChannelInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBitChannel = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class BitChannelClass

    --- Creates a new BitChannelInstance
    --- @return BitChannelInstance
    function STATIC.New()
        return robustclass.New( "Renegade_BitChannel" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BitChannelInstance, `false` otherwise
    function STATIC.IsBitChannel( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBitChannel and true or false
    end

    typecheck.RegisterType( "BitChannelInstance", STATIC.IsBitChannel )

    function STATIC.StaticConstructor()

        deserializeLib.RegisterComplexDataType( "BitChannelInstance", {
			{ Name = "PivotIndex",     DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "Type",           DataType = fundamentalDataTypeEnum.UInt32 },
			{ Name = "VectorLength",   DataType = fundamentalDataTypeEnum.Int },

            { Name = "ValueOffset",    DataType = fundamentalDataTypeEnum.Float },
            { Name = "ValueScale",     DataType = fundamentalDataTypeEnum.Float },
            { Name = "CompressedData", DataType = fundamentalDataTypeEnum.Pointer },

            { Name = "Data",           DataType = fundamentalDataTypeEnum.Pointer },
            { Name = "FirstFrame",     DataType = fundamentalDataTypeEnum.Int },
            { Name = "LastFrame",      DataType = fundamentalDataTypeEnum.Int },
		} )
    end
end


--- @class BitChannelInstance
--- @field PivotIndex integer
--- @field Type integer
--- @field DefaultValue boolean
--- @field FirstFrame integer
--- @field LastFrame integer
--- @field Bits integer[]

function INSTANCE:Renegade_BitChannel()
    self.PivotIndex = 1
    self.Type = 0
    self.DefaultValue = false
    self.FirstFrame = -1
    self.LastFrame = -1
    self.Bits = nil
end

function INSTANCE:_Renegade_BitChannel()
	typecheck.NotImplementedError()
end

--- "Read a bit channel from a w3d chunk"
--- @param cload ChunkLoadInstance
function INSTANCE:LoadW3d( cload )
    self:Free()

    local chunkSize = cload:CurChunkLength()

    local channel = cload:ReadStruct( "W3dBitChannelStruct" )
    if channel == nil then
        return false
    end

    self.FirstFrame = channel.FirstFrame
    self.LastFrame = channel.LastFrame

	typecheck.NotImplementedError()
end

--- @return integer
function INSTANCE:GetType()
    return self.Type
end

--- @return integer
function INSTANCE:GetPivot()
    return self.PivotIndex
end

--- @param frame integer
--- @return boolean
function INSTANCE:GetBit( frame )
	if frame < self.FirstFrame or frame >= self.LastFrame then
        return self.DefaultValue
    else
        local bitValue = frame - self.FirstFrame

        local mask = bit.lshift( 1, bitValue % 8 )
        return bit.band( self.Bits[ bitValue/8 ], mask ) ~= 0
    end
end

function INSTANCE:Free()
    self.Bits = nil
end
