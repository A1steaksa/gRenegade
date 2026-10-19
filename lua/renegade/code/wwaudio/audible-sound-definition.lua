-- Based on AudibleSoundDefinitionClass within Code/WWAudio/AudibleSound.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class AudibleSoundDefinitionClass : DefinitionClass
--- @field Instance AudibleSoundDefinitionInstance The metatable used by AudibleSoundDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AudibleSoundDefinitionClass"

--- @class AudibleSoundDefinitionInstance : DefinitionInstance
--- @field Static AudibleSoundDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AudibleSoundDefinition : Renegade_Definition" )
INSTANCE.Class = "AudibleSoundDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAudibleSoundDefinition = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class AudibleSoundDefinitionClass

    --- Creates a new AudibleSoundDefinitionInstance
    --- @return AudibleSoundDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_AudibleSoundDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AudibleSoundDefinitionInstance, `false` otherwise
    function STATIC.IsAudibleSoundDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAudibleSoundDefinition and true or false
    end

    typecheck.RegisterType( "AudibleSoundDefinitionInstance", STATIC.IsAudibleSoundDefinition )
end


--- @class AudibleSoundDefinitionInstance
--- @field Priority number
--- @field Volume number
--- @field VolumeRandomizer number
--- @field Pan number
--- @field LoopCount integer
--- @field VirtualChannel integer
--- @field DropOffRadius number
--- @field MaxVolRadius number
--- @field Is3d boolean
--- @field Filename string
--- @field Type integer
--- @field DisplayText string
--- @field StartOffset number
--- @field PitchFactor number
--- @field PitchFactorRandomizer number
--- @field LogicalTypeMask integer
--- @field LogicalNotifyDelay number
--- @field LogicalDropOffRadius number
--- @field CreateLogical boolean
--- @field AttenuationSphereColor Vector

function INSTANCE:Renegade_AudibleSoundDefinition()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_AudibleSoundDefinition()
	typecheck.NotImplementedError()
end

function INSTANCE:GetClassId()
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

function INSTANCE:Create()
	typecheck.NotImplementedError()
end

--- @param classIdHint integer
--- @return AudibleSoundInstance
function INSTANCE:CreateSound( classIdHint )
	typecheck.NotImplementedError()
end

function INSTANCE:InitializeFromSound()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFilename()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDisplayText()
	typecheck.NotImplementedError()
end

function INSTANCE:GetMaxVolRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:GetSphereColor()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVolumeRandomizer()
	typecheck.NotImplementedError()
end

function INSTANCE:GetStartOffset()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPitchFactor()
	typecheck.NotImplementedError()
end

function INSTANCE:GetPitchFactorRandomizer()
	typecheck.NotImplementedError()
end

function INSTANCE:GetVirtualChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVolume()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVolumeRandomizer()
	typecheck.NotImplementedError()
end

function INSTANCE:SetMaxVolRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:SetDropOffRadius()
	typecheck.NotImplementedError()
end

function INSTANCE:SetStartOffset()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPitchFactor()
	typecheck.NotImplementedError()
end

function INSTANCE:SetPitchFactorRandomizer()
	typecheck.NotImplementedError()
end

function INSTANCE:SetVirtualChannel()
	typecheck.NotImplementedError()
end

function INSTANCE:CreateLogical()
	typecheck.NotImplementedError()
end

function INSTANCE:SaveVariables()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadVariables()
	typecheck.NotImplementedError()
end
