-- Based on SoundPseudo3DClass within Code/WWAudio/SoundPseudo3D.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type Sound3dClass
local sound3DClass = CNC.Import( "code/wwaudio/sound-3d.lua" )

--- @class SoundPseudo3DClass : Sound3dClass
--- @field Instance SoundPseudo3DInstance The metatable used by SoundPseudo3DInstance
local STATIC = CNC.CreateExport( sound3DClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SoundPseudo3DClass"

--- @class SoundPseudo3DInstance : Sound3dInstance
--- @field Static SoundPseudo3DClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SoundPseudo3D : Renegade_Sound3d" )
INSTANCE.Class = "SoundPseudo3DInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSoundPseudo3D = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type SoundChunkIds
	local soundChunkIds = CNC.Import( "code/wwaudio/sound-chunk-ids.lua" )

	--- @type WWAudioClass
	local wWAudioClass = CNC.Import( "code/wwaudio/ww-audio.lua" )
--#endregion

--#region Imported Enums

	local soundChunkIdEnum = soundChunkIds.SOUND_CHUNK_ID
	local soundClassIdEnum = wWAudioClass.SOUND_CLASSID
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class SoundPseudo3DClass

    --- Creates a new SoundPseudo3DInstance
    --- @return SoundPseudo3DInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SoundPseudo3D" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SoundPseudo3DInstance, `false` otherwise
    function STATIC.IsSoundPseudo3D( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSoundPseudo3D and true or false
    end

    typecheck.RegisterType( "SoundPseudo3DInstance", STATIC.IsSoundPseudo3D )

	function STATIC.StaticConstructor()
        STATIC.PseudoSound3dPersistFactory = simplePersistFactoryClass.New( STATIC, soundChunkIdEnum.CHUNKID_PSEUDO_SOUND3D )
    end
end


--- @class SoundPseudo3DInstance

function INSTANCE:Renegade_SoundPseudo3D()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_SoundPseudo3D()
	typecheck.NotImplementedError()
end

--- @return SoundClassId
function INSTANCE:GetClassId()
	return soundClassIdEnum.CLASSID_PSEUDO3D
end

function INSTANCE:AsSoundPseudo3dcLass()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdateVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetListenerTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPosition()
	typecheck.NotImplementedError()
end

function INSTANCE:SetTransform()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVelocity()
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

function INSTANCE:UpdatePseudoVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:UpdatePseudoPan()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFactory()
	typecheck.NotImplementedError()
end

function INSTANCE:OnFrameUpdate()
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

function INSTANCE:FreeMilesHandle()
	typecheck.NotImplementedError()
end

function INSTANCE:OnLoopEnd()
	typecheck.NotImplementedError()
end
