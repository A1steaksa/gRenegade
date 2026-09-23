-- Based on TimeCodedMotionChannelClass within var/home/JSchneider/Projects/LuaRenegadePort/C&amp;C Renegade/Code/ww3d2/motchan.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class TimeCodedMotionChannelClass
--- @field Instance TimeCodedMotionChannelInstance The metatable used by TimeCodedMotionChannelInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TimeCodedMotionChannelClass"

--- @class TimeCodedMotionChannelInstance
--- @field Static TimeCodedMotionChannelClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_TimeCodedMotionChannel" )
INSTANCE.Class = "TimeCodedMotionChannelInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsTimeCodedMotionChannel = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
	local animationChannelEnum = w3dFileIds.ANIMATION_CHANNEL
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class TimeCodedMotionChannelClass

    --- Creates a new TimeCodedMotionChannelInstance
    --- @return TimeCodedMotionChannelInstance
    function STATIC.New()
        return robustclass.New( "Renegade_TimeCodedMotionChannel" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) TimeCodedMotionChannelInstance, `false` otherwise
    function STATIC.IsTimeCodedMotionChannel( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsTimeCodedMotionChannel and true or false
    end

    typecheck.RegisterType( "TimeCodedMotionChannelInstance", STATIC.IsTimeCodedMotionChannel )
end

--- "  
--- [TimeCodedMotionChannelInstance] is used to store motion.  
--- Motion data is broken into separate channels for X, Y, Z, and orientation.    
--- Then if any of the channels are empty, they don't have to be stored.  
--- The X,Y,Z channels all contain one-dimensional vectors and the
--- orientation channel contains four-dimensional vectors (quaternions).  
--- "  
--- @class TimeCodedMotionChannelInstance
--- @field PivotIndex integer
--- @field Type integer
--- @field VectorLength integer
--- @field PacketSize integer
--- @field NumTimeCodes integer
--- @field LastTimeCodeIndex integer
--- @field CachedIndex integer
--- @field Data integer[][]

function INSTANCE:Renegade_TimeCodedMotionChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_TimeCodedMotionChannel()
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:LoadW3d( cload )
    local size = cload:CurChunkLength()
    local dataSize = size - deserializeLib.GetDataTypeSize( "W3dTimeCodedAnimChannelStruct" )

    local channel = cload:ReadStruct( "W3dTimeCodedAnimChannelStruct" )
    if channel == nil then
        return false
    end

    self.NumTimeCodes = channel.NumTimeCodes
    self.VectorLength = channel.VectorLength
    self.Type = channel.Flags
    self.PivotIndex = channel.Pivot
    self.PacketSize = self.VectorLength + 1
    self.CachedIndex = 0
    self.LastTimeCodeIndex = ( self.NumTimeCodes - 1 ) * self.PacketSize

    self.Data = {}
    self.Data[1] = channel.Data[1]

    local readByteCount, readBytes = cload:Read( dataSize )
    if readByteCount ~= dataSize or readBytes == nil then
        return false
    end

    table.Add( self.Data, deserializeLib.DeserializeArray( fundamentalDataTypeEnum.UInt32, readBytes ) )

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

--- @param frame integer
--- @param setVector number[]
function INSTANCE:GetVector( frame, setVector )
    local timeCoded0 = frame

    local pivotIndex = self:GetIndex( timeCoded0 )
    local pivot2Index

    if pivotIndex == self.NumTimeCodes * self.PacketSize then
        local frm = self.Data[pivotIndex + 1]
        for i = 1, self.VectorLength do
            setVector[i] = frm[i]
        end

        return
    else
        pivot2Index = pivotIndex + self.PacketSize
    end

    local time = self.Data[pivot2Index][1]

    if tobool( bit.band( time, w3dFileIds.W3D_TIMECODED_BINARY_MOVEMENT_FLAG ) ) then
        local frm = self.Data[pivotIndex + 1]
        local result = {}
        for i = 1, self.VectorLength do
            result[i] = frm[i]
        end

        return result
    end

    local time1 = bit.band( self.Data[pivotIndex][1], bit.bnot( w3dFileIds.W3D_TIMECODED_BINARY_MOVEMENT_FLAG ) )
    local time2 = bit.band( time, bit.bnot( w3dFileIds.W3D_TIMECODED_BINARY_MOVEMENT_FLAG ) )

    local ratio = ( frame - time1 ) / ( time2 - time1 )

    local frame1 = self.Data[pivotIndex + 1]
    local frame2 = self.Data[pivot2Index + 1]

    for i = 1, self.VectorLength do
        setVector[i] = Lerp( frame1[i], frame2[i], ratio )
    end
end

--- @param frame number
function INSTANCE:GetQuatVector( frame )
	typecheck.NotImplementedError()
end

function INSTANCE:Free()
	typecheck.NotImplementedError()
end

--- "Returns an 'identity' vector (not really... hmm...)"
--- @param setVector number[]
function INSTANCE:SetIdentity( setVector )
    if self.Type == animationChannelEnum.ANIM_CHANNEL_Q then
        setVector[1] = 0.0
        setVector[2] = 0.0
        setVector[3] = 0.0
        setVector[4] = 0.0
    else
        setVector[1] = 0.0
    end
end

--- "Returns packet index"
--- @param timeCode integer
--- @return integer
function INSTANCE:GetIndex( timeCode )
	local time = bit.band( self.Data[self.CachedIndex], bit.bnot( w3dFileIds.W3D_TIMECODED_BINARY_MOVEMENT_FLAG ) )

    if timeCode >= time then
        -- "Possibly in the current packet"

        -- "Special case for end packets"
        if self.CachedIndex == self.LastTimeCodeIndex then return self.CachedIndex end
        time = bit.band( self.Data[self.CachedIndex + self.PacketSize], bit.bnot( w3dFileIds.W3D_TIMECODED_BINARY_MOVEMENT_FLAG ) )
        if timeCode < time then return self.CachedIndex end

        -- "Do one time look-ahead before reverting to a search"
        self.CachedIndex = self.CachedIndex + self.PacketSize
        if self.CachedIndex == self.LastTimeCodeIndex then return self.CachedIndex end
        time = bit.band( self.Data[self.CachedIndex + self.PacketSize], bit.bnot( w3dFileIds.W3D_TIMECODED_BINARY_MOVEMENT_FLAG ) )
        if timeCode < time then return self.CachedIndex end
    end

    self.CachedIndex = self:BinarySearchIndex( timeCode )

    return self.CachedIndex
end

--- @param timeCode integer
--- @return integer packedIndex
function INSTANCE:BinarySearchIndex( timeCode )
    local leftIndex = 1
    local rightIndex = self.NumTimeCodes - 1

    local index = self.LastTimeCodeIndex

    -- "Special case last packet"
    local time = bit.band( self.Data[index], bit.bnot( w3dFileIds.W3D_TIMECODED_BINARY_MOVEMENT_FLAG ) )
    if timeCode >= time then return index end

    local dx
    while true do
        dx = rightIndex - leftIndex

        dx = bit.rshift( dx, 1 ) -- "Divide by 2"

        dx = dx + leftIndex

        index = dx * self.PacketSize

        time = bit.band( self.Data[index], bit.bnot( w3dFileIds.W3D_TIMECODED_BINARY_MOVEMENT_FLAG ) )

        if timeCode < time then
            rightIndex = dx
            continue
        end

        time = bit.band( self.Data[index + self.PacketSize], bit.bnot( w3dFileIds.W3D_TIMECODED_BINARY_MOVEMENT_FLAG ) )

        if timeCode < time then return index end

        if tobool( bit.bxor( leftIndex, dx ) ) then
            leftIndex = dx
            continue
        end

        leftIndex = leftIndex + 1
    end

    assert( false )
    return 0
end
