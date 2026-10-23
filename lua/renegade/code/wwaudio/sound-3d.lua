-- Based on Sound3DClass within Code/WWAudio/Sound3D.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type AudibleSoundClass
local audibleSoundClass = CNC.Import( "code/wwaudio/audible-sound.lua" )

--- @class Sound3dClass : AudibleSoundClass
--- @field Instance Sound3dInstance The metatable used by Sound3DInstance
local STATIC = CNC.CreateExport( audibleSoundClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "Sound3dClass"

--- @class Sound3dInstance : AudibleSoundInstance
--- @field Static Sound3dClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Sound3d : Renegade_AudibleSound" )
INSTANCE.Class = "Sound3dInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSound3D = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SoundChunkIds
	local soundChunkIds = CNC.Import( "code/wwaudio/sound-chunk-ids.lua" )
--#endregion

--#region Imported Enums

	local soundChunkIdEnum = soundChunkIds.SOUND_CHUNK_IDS
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class Sound3dClass

    --- Creates a new Sound3DInstance
    --- @return Sound3dInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Sound3d" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) Sound3DInstance, `false` otherwise
    function STATIC.IsSound3d( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSound3D and true or false
    end

    typecheck.RegisterType( "Sound3dInstance", STATIC.IsSound3d )

	function STATIC.StaticConstructor()
        STATIC.Sound3dPersistFactory = simplePersistFactoryClass.New( STATIC, soundChunkIdEnum.CHUNKID_SOUND3D )
    end
end


--- @class Sound3dInstance
--- @field IsTransformInitted boolean
--- @field AutomaticallyCalculateVelocity boolean
--- @field CurrentVelocity Vector
--- @field MaxVolRadius number
--- @field _IsStatic boolean
--- @field LastUpdate integer

function INSTANCE:Renegade_Sound3d()
	self.AutomaticallyCalculateVelocity = true
	self.CurrentVelocity = Vector( 0, 0, 0 )
	self.MaxVolRadius = 0
	self.LastUpdate = 0
	self._IsStatic = false
	self.IsTransformInitted = false
end

function INSTANCE:_Renegade_Sound3d()
	typecheck.NotImplementedError()
end

function INSTANCE:GetClassId()
	typecheck.NotImplementedError()
end

function INSTANCE:MakeStatic()
	typecheck.NotImplementedError()
end

function INSTANCE:IsStatic()
	typecheck.NotImplementedError()
end

function INSTANCE:AsSound3dcLass()
	typecheck.NotImplementedError()
end

function INSTANCE:Play()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPriority()
	typecheck.NotImplementedError()
end

function INSTANCE:AddToScene()
	typecheck.NotImplementedError()
end

function INSTANCE:RemoveFromScene()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:SetListenerTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:GetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateMilesTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:AutoCalcVelocity()
	typecheck.NotImplementedError()
end

function INSTANCE:IsAutoCalcVelocityOn()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMaxVolRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaxVolRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFactory()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

function INSTANCE:Load()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekCullableWrapper()
	typecheck.NotImplementedError()
end

function INSTANCE:SetCullableWrapper()
	typecheck.NotImplementedError()
end

function INSTANCE:OnFrameUpdate()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateEdgeVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:InitializeMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:AllocateMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:OnLoopEnd()
	typecheck.NotImplementedError()
end
