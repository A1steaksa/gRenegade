-- Based on MotionChannelClass within var/home/JSchneider/Projects/LuaRenegadePort/C&amp;C Renegade/Code/ww3d2/motchan.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MotionChannelClass
--- @field Instance MotionChannelInstance The metatable used by MotionChannelInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MotionChannelClass"

--- @class MotionChannelInstance
--- @field Static MotionChannelClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MotionChannel" )
INSTANCE.Class = "MotionChannelInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMotionChannel = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )
--#endregion

--#region Imported Enums

	local animationChannelEnum = w3dFileIds.ANIMATION_CHANNEL
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MotionChannelClass

    --- Creates a new MotionChannelInstance
    --- @return MotionChannelInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MotionChannel" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MotionChannelInstance, `false` otherwise
    function STATIC.IsMotionChannel( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMotionChannel and true or false
    end

    typecheck.RegisterType( "MotionChannelInstance", STATIC.IsMotionChannel )
end


--- @class MotionChannelInstance
--- @field PivotIndex integer "What pivot is this channel applied to"
--- @field Type integer "What type of channel is this"
--- @field VectorLength integer "Size of each individual vector"
--- @field ValueOffset number
--- @field ValueScale number
--- @field CompressedData integer[]
--- @field Data number[] "Pointer to the raw floating point data"
--- @field FirstFrame integer "First frame which was non-identity"
--- @field LastFrame integer "Last frame which was non-identity"

--- @param dataSize integer
function INSTANCE:DoDataCompression( dataSize )
	return
    -- Omitted this function's body as it seems to be disabled via a return on the first line
end

--- @param frame integer
--- @param setVector Vector|number[] The vector that values will be set into
--- @param vectorIndex integer? [Optional] The index, starting at 1, within the setVector to populate
function INSTANCE:GetVector( frame, setVector, vectorIndex )
    if frame < self.FirstFrame or frame > self.LastFrame then
        self:SetIdentity( setVector )
        return
    else
        local vFrame = frame - self.FirstFrame

        if self.Data then

            -- Load a Vector
            if self.VectorLength == 1 then
                --- @cast setVector Vector

                if vectorIndex == nil then
                    section.Error( "Cannot retrieve vector axis without a vector index value!" )
                    return
                end

                local index = vFrame + 1
                if self.Data[index] ~= nil then
                    setVector[vectorIndex] = self.Data[index]
                end

            -- Load a Quaternion
            elseif self.VectorLength == 4 then
                --- @cast setVector QuaternionInstance

                local baseIndex = vFrame * 4 + 1
                setVector[1] = self.Data[baseIndex + 0]
                setVector[2] = self.Data[baseIndex + 1]
                setVector[3] = self.Data[baseIndex + 2]
                setVector[4] = self.Data[baseIndex + 3]
            else
                section.Error( "Unsupported Vector Length: ", self.VectorLength )
                return
            end
        else
            local scale = self.ValueScale / 65535.0
            for i = 1, self.VectorLength do
                local value = self.CompressedData[vFrame * self.VectorLength + i]
                if value ~= nil then
                    setVector[i] = value * scale + self.ValueOffset
                end
            end
        end
    end
end

function INSTANCE:Renegade_MotionChannel()
    self.PivotIndex = 1
    self.Type = 0
    self.VectorLength = 0
    self.Data = nil
    self.FirstFrame = -1
    self.LastFrame  = -1
    self.CompressedData = nil
    self.ValueScale  = 0.0
    self.ValueOffset = 0.0
end

function INSTANCE:_Renegade_MotionChannel()
    self:Free()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:LoadW3d( cload )
    local chunkSize = cload:CurChunkLength()
    local structSize = deserializeLib.GetComplexDataTypeSize( "W3dAnimChannelStruct" )
    -- "There was a bug in the exporter which saved too much data, so let's try and not load everything."
    local savedDataSize = chunkSize - structSize

    local channel = cload:ReadStruct( "W3dAnimChannelStruct" )
    if channel == nil then
        return false
    end

    self.FirstFrame   = channel.FirstFrame
    self.LastFrame    = channel.LastFrame
    self.VectorLength = channel.VectorLength or 0
    self.Type         = channel.Flags
    self.PivotIndex   = channel.Pivot + 1

    local numFloats = self.LastFrame - self.FirstFrame + 1
    numFloats = numFloats * self.VectorLength
    local dataSize = ( numFloats - 1 ) * 4 -- 4 is sizeof(float)

    self.Data = {}
    self.Data[1] = channel.Data[1]

    local readByteCount, readBytes = cload:Read( dataSize )
    if readByteCount ~= dataSize then
        self:Free()

        return false
    end
    table.Add( self.Data, deserializeLib.DeserializeArray( fundamentalDataTypeEnum.Float32, readBytes --[[@as string]] ) )

    -- "Skip over the extra data at the end of the chunk (saved by an error in the exporter)"
    local bytesToSkip = savedDataSize - dataSize
    if bytesToSkip > 0 then
        cload:Seek( bytesToSkip )
    end

    -- Omitted data compression as it had to effect
    return true
end

--- @return integer
function INSTANCE:GetType()
	return self.Type
end

--- @return integer
function INSTANCE:GetPivot()
    return self.PivotIndex
end

--- @param index integer
function INSTANCE:SetPivot( index )
	self.PivotIndex = index
end

function INSTANCE:Free()
    if self.CompressedData then
        self.CompressedData = nil
    end
    if self.Data then
        self.Data = nil
    end
end

--- @param setVector number[] The vector table that values will be set into
function INSTANCE:SetIdentity( setVector )
    if self.Type == animationChannelEnum.ANIM_CHANNEL_Q then
        setVector[1] = 0.0
        setVector[2] = 0.0
        setVector[3] = 0.0
        setVector[4] = 1.0
    else
        setVector[1] = 0.0
    end
end
