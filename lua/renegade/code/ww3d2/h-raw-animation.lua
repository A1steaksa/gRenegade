-- Based on HRawAnimClass within Code/ww3d2/hrawanim.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type HAnimationClass
local hAnimationClass = CNC.Import( "code/ww3d2/h-animation.lua" )

--- @class HRawAnimationClass : HAnimationClass
--- @field Instance HRawAnimationInstance The metatable used by HRawAnimationInstance
local STATIC = CNC.CreateExport( hAnimationClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HRawAnimationClass"

--- @class HRawAnimationInstance : HAnimationInstance
--- @field Static HRawAnimationClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HRawAnimation : Renegade_HAnimation" )
INSTANCE.Class = "HRawAnimationInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHRawAnimation = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type HAnimationManagerClass
	local hAnimationManagerClass = CNC.Import( "code/ww3d2/h-animation-manager.lua" )

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )

	--- @type Ww3dAssetManagerClass
	local ww3dAssetManagerClass = CNC.Import( "code/ww3d2/ww3d-asset-manager.lua" )

	--- @type MotionChannelClass
	local motionChannelClass = CNC.Import( "code/ww3d2/motion-channel.lua" )
--#endregion

--#region Imported Enums

	local hRawAnimationLoadResultEnum = hAnimationManagerClass.H_RAW_ANIMATION_LOAD_RESULT
	local w3dChunkTypeEnum = w3dFileIds.W3D_CHUNK_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HRawAnimationClass

    --- Creates a new HRawAnimationInstance
    --- @return HRawAnimationInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HRawAnimation" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HRawAnimationInstance, `false` otherwise
    function STATIC.IsHRawAnimation( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHRawAnimation and true or false
    end

    typecheck.RegisterType( "HRawAnimationInstance", STATIC.IsHRawAnimation )
end

--- @class NodeMotionStruct
--- @field X MotionChannelInstance
--- @field Y MotionChannelInstance
--- @field Z MotionChannelInstance
--- @field XR MotionChannelInstance
--- @field YR MotionChannelInstance
--- @field ZR MotionChannelInstance
--- @field Q MotionChannelInstance
--- @field Visibility BitChannelInstance

--- @class HRawAnimationInstance
--- @field Name string
--- @field HierarchyName string
--- @field NumFrames integer
--- @field NumNodes integer
--- @field FrameRate number
--- @field NodeMotion NodeMotionStruct[]

function INSTANCE:Renegade_HRawAnimation()
	self.NumFrames = 0
	self.NumNodes = 0
	self.FrameRate = 0
	self.NodeMotion = nil
	self.Name = ""
	self.HierarchyName = ""
end

function INSTANCE:_Renegade_HRawAnimation()
	self:Free()
end

--- "Loads hierarchy animation from a file"
--- @param cload ChunkLoadInstance
--- @return HRawAnimationLoadResult
function INSTANCE:LoadW3d( cload )
	local pre30 = false

	-- "First make sure we release any memory in use"
	self:Free()

	-- "Open the first chunk, it should be the animation header"
	if not cload:OpenChunk() then
		return hRawAnimationLoadResultEnum.LOAD_ERROR
	end

	if cload:CurChunkId() ~= w3dChunkTypeEnum.W3D_CHUNK_ANIMATION_HEADER then
		section.Warn( INSTANCE.Class, " - LoadW3d - ERROR: Expected Animation Header!" )
	end

	local animationHeader = cload:ReadStruct( "W3dAnimHeaderStruct" )
	if animationHeader == nil then
		return hRawAnimationLoadResultEnum.LOAD_ERROR
	end

	cload:CloseChunk()

	-- "
	-- Check if the animation version is pre-3.0.  If so, we need to add 1 to all of the bone indexes.
	-- In version 3.0 onward, all htree's use bone 0 as the root node.
	-- "
	if animationHeader.Version < w3dFileIds.W3D_MAKE_VERSION( 3, 0 ) then
		pre30 = true
	end

	self.Name = animationHeader.HierarchyName .. "." .. animationHeader.Name

	-- "TSS chasing crash bug 05/26/99"
	assert( self.HierarchyName ~= nil )
	assert( animationHeader.HierarchyName ~= nil )
	-- assert( self.HierarchyName:len() > 0 )
	self.HierarchyName = animationHeader.HierarchyName

	local basePose = ww3dAssetManagerClass.GetInstance():GetHTree( self.HierarchyName )
	if basePose == nil then
		self:Free()
		return hRawAnimationLoadResultEnum.LOAD_ERROR
	end
	self.NumNodes = basePose:NumPivots()

	self.NumFrames = animationHeader.NumFrames
	self.FrameRate = animationHeader.FrameRate

	self.NodeMotion = classUtils.InitializeTypeArray( "NodeMotionStruct", self.NumNodes )

	-- "Now, read in all of the other chunks (motion channels)."
	--- @type MotionChannelInstance
	local newChannel
	--- @type BitChannelInstance
	local newBitChannel
	--- @type boolean
	local didSucceed
	while cload:OpenChunk() do
		local id = cload:CurChunkId()

		if id == w3dChunkTypeEnum.W3D_CHUNK_ANIMATION_CHANNEL then
			didSucceed, newChannel = self:ReadChannel( cload, pre30 )


		elseif id == w3dChunkTypeEnum.W3D_CHUNK_BIT_CHANNEL then

		end

		cload:CloseChunk()
	end

	return hRawAnimationLoadResultEnum.OK
end

--- @return string
function INSTANCE:GetName()
	return self.Name
end

--- @return string
function INSTANCE:GetHName()
	return self.HierarchyName
end

--- @return integer
function INSTANCE:GetNumFrames()
	return self.NumFrames
end

--- @return number
function INSTANCE:GetFrameRate()
	return self.FrameRate
end

--- @return number
function INSTANCE:GetTotalTime()
	return self.NumFrames / self.FrameRate
end

--- "Returns the translation vector for the given fr"
--- @param translation Vector The Vector where the translation will be put
--- @param pivotIndex integer
--- @param frame number
function INSTANCE:GetTranslation( translation, pivotIndex, frame )
	local motion = self.NodeMotion[pivotIndex]

	if motion.X == nil and motion.Y == nil and motion.Z == nil then
		translation:SetUnpacked( 0, 0, 0 )
	end

	local frame0 = math.floor( frame )
	local frame1 = frame0 + 1

	local ratio = frame - frame0

	if frame1 >= self.NumFrames then
		frame1 = 0
	end

	local translation0 = Vector( 0.0, 0.0, 0.0 )
	if motion.X ~= nil then
		motion.X:GetVector( frame0, translation0, 1 )
	end

	if motion.Y ~= nil then
		motion.Y:GetVector( frame0, translation0, 2 )
	end

	if motion.Z ~= nil then
		motion.Z:GetVector( frame0, translation0, 3 )
	end

	if ratio == 0.0 then
		translation:Set( translation0 )
	end

	local translation1 = Vector( 0.0, 0.0, 0.0 )
	if motion.X ~= nil then
		motion.X:GetVector( frame1, translation1, 1 )
	end

	if motion.Y ~= nil then
		motion.Y:GetVector( frame1, translation1, 2 )
	end

	if motion.Z ~= nil then
		motion.Z:GetVector( frame1, translation1, 3 )
	end

	translation:Set( LerpVector( ratio, translation0, translation1 ) )
end

--- @param pivotIndex integer
--- @param frame number
--- @return QuaternionInstance
function INSTANCE:GetOrientation( pivotIndex, frame )
	local frame0 = math.floor( frame ) -- Omitted -0.499999 as it seemed to be causing problems with the frame number
	local frame1 = frame0 + 1

	local ratio = frame - frame0
	assert( ratio >= -wWMathClass.EPSILON and ratio < 1.0 + wWMathClass.EPSILON )

	if frame1 >= self.NumFrames then
		frame1 = 0
	end

	local nodeMotionQuaternion = self.NodeMotion[pivotIndex].Q

	local values = {}

	local q0 = quaternionClass.New( true )
	if nodeMotionQuaternion ~= nil then
		nodeMotionQuaternion:GetVector( frame0, values )
		q0:Set( values[1], values[2], values[3], values[4] )
	end

	if ratio == 0.0 then
		return q0
	end

	local q1 = quaternionClass.New( true )
	if nodeMotionQuaternion ~= nil then
		nodeMotionQuaternion:GetVector( frame1, values )
		q1:Set( values[1], values[2], values[3], values[4] )
	end

	return quaternionClass.Slerp( q0, q1, ratio )
end

--- "Returns the transform matrix for the given frame"
--- @param pivotIndex integer
--- @param frame number
--- @return Matrix3dInstance
function INSTANCE:GetTransform( pivotIndex, frame )
	local motion = self.NodeMotion[pivotIndex]

	local frame0 = math.floor( frame ) -- Omitted -0.499999 as it seemed to be causing problems with the frame number
	local frame1 = frame0 + 1

	local ratio = frame - frame0
	assert( ratio >= -wWMathClass.EPSILON and ratio < 1.0 + wWMathClass.EPSILON )

	if frame1 >= self.NumFrames then
		frame1 = 0
	end

	local vals = {}

	local q0 = quaternionClass.New( true )
	if self.NodeMotion[pivotIndex].Q ~= nil then
		self.NodeMotion[pivotIndex].Q:GetVector( frame0, vals )
		q0:Set( vals[1], vals[2], vals[3], vals[4] )
	end

	local matrix
	if ratio == 0.0 then
		matrix = quaternionClass.BuildMatrix3d( q0 )
		local row = matrix.Row
		if motion.X ~= nil then
			motion.X:GetVector( frame0, row[1][4] )
		end

		if motion.Y ~= nil then
			motion.Y:GetVector( frame0, row[2][4] )
		end

		if motion.Z ~= nil then
			motion.Z:GetVector( frame0, row[3][4] )
		end

		return matrix
	end

	local q1 = quaternionClass.New( true )
	if self.NodeMotion[pivotIndex].Q ~= nil then
		self.NodeMotion[pivotIndex].Q:GetVector( frame1, vals )
		q1:Set( vals[1], vals[2], vals[3], vals[4] )
	end

	local q = quaternionClass.FastSlerp( q0, q1, ratio )
	matrix = quaternionClass.BuildMatrix3d( q )

	local translation0 = Vector( 0.0, 0.0, 0.0 )
	if motion.X ~= nil then
		motion.X:GetVector( frame0, translation0 )
	end

	if motion.Y ~= nil then
		motion.Y:GetVector( frame0, translation0 )
	end

	if motion.Z ~= nil then
		motion.Z:GetVector( frame0, translation0 )
	end

	local translation1 = Vector( 0.0, 0.0, 0.0 )
	if motion.X ~= nil then
		motion.X:GetVector( frame1, translation1 )
	end

	if motion.Y ~= nil then
		motion.Y:GetVector( frame1, translation1 )
	end

	if motion.Z ~= nil then
		motion.Z:GetVector( frame1, translation1 )
	end

	local transform = LerpVector( ratio, translation0, translation1 )

	matrix:SetTranslation( transform )

	return matrix
end

--- "Return visibility state for given pivot/frame"
--- @param pivotIndex integer
--- @param frame number
--- @return boolean
function INSTANCE:GetVisibility( pivotIndex, frame )
	if self.NodeMotion[pivotIndex].Visibility ~= nil then
		return self.NodeMotion[pivotIndex].Visibility:GetBit( frame ) == 1
	end

	-- "Default to always visible..."
	return true
end

function INSTANCE:IsNodeMotionPresent()
	typecheck.NotImplementedError()
end

--- @return integer
function INSTANCE:GetNumPivots()
	return self.NumNodes
end

function INSTANCE:HasXTranslation()
	typecheck.NotImplementedError()
end

function INSTANCE:HasYTranslation()
	typecheck.NotImplementedError()
end

function INSTANCE:HasZTranslation()
	typecheck.NotImplementedError()
end

function INSTANCE:HasRotation()
	typecheck.NotImplementedError()
end

function INSTANCE:HasVisibility()
	typecheck.NotImplementedError()
end

--- "De-allocates all memory in use"
function INSTANCE:Free()
	if self.NodeMotion ~= nil then
		self.NodeMotion = nil
	end
end

--- @param cload ChunkLoadInstance
--- @param pre30 boolean
--- @return boolean, MotionChannelInstance
function INSTANCE:ReadChannel( cload, pre30 )
	local newChannel = motionChannelClass.New()
	local result = newChannel:LoadW3d( cload )

	if result and pre30 then
		newChannel:SetPivot( newChannel:GetPivot() + 1 )
	end

	return result, newChannel
end

--- "Adds a motion channel to the animation"
--- @param newChannel MotionChannelInstance
function INSTANCE:AddChannel( newChannel )
	local index = newChannel:GetPivot()
	local channelType = newChannel:GetType()

	if channelType == animationChannelEnum.ANIM_CHANNEL_X then
		self.NodeMotion[index].X = newChannel
	elseif channelType == animationChannelEnum.ANIM_CHANNEL_Y then
		self.NodeMotion[index].Y = newChannel
	elseif channelType == animationChannelEnum.ANIM_CHANNEL_Z then
		self.NodeMotion[index].Z = newChannel
	elseif channelType == animationChannelEnum.ANIM_CHANNEL_XR then
		self.NodeMotion[index].XR = newChannel
	elseif channelType == animationChannelEnum.ANIM_CHANNEL_YR then
		self.NodeMotion[index].YR = newChannel
	elseif channelType == animationChannelEnum.ANIM_CHANNEL_ZR then
		self.NodeMotion[index].ZR = newChannel
	elseif channelType == animationChannelEnum.ANIM_CHANNEL_Q then
		self.NodeMotion[index].Q = newChannel
	end
end

--- "Read a bit channel from the file"
--- @param cload ChunkLoadInstance
--- @return boolean, BitChannelInstance
function INSTANCE:ReadBitChannel( cload, pre30 )
	local newChannel = bitChannelClass.New()
	local result = newChannel:LoadW3d( cload )

	if result and pre30 then
		newChannel.PivotIndex = newChannel.PivotIndex + 1
	end

	return result, newChannel
end

--- @param newChannel BitChannelInstance
function INSTANCE:AddBitChannel( newChannel )
	typecheck.NotImplementedError()
end
