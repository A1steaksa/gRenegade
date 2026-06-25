-- Based on HAnimManagerClass within Code/ww3d2/hanimmgr.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class HAnimationManagerClass
--- @field Instance HAnimationManagerInstance The metatable used by HAnimationManagerInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HAnimationManagerClass"

--- @class HAnimationManagerInstance
--- @field Static HAnimationManagerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HAnimationManager" )
INSTANCE.Class = "HAnimationManagerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHAnimationManager = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )
--#endregion

--#region Imported Enums

	local w3dChunkTypeEnum = w3dFileIds.W3D_CHUNK_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HAnimationManagerClass

    --- Creates a new HAnimationManagerInstance
    --- @return HAnimationManagerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HAnimationManager" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HAnimationManagerInstance, `false` otherwise
    function STATIC.IsHAnimationManager( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end
        return arg.IsHAnimationManager and true or false
    end

    typecheck.RegisterType( "HAnimationManagerInstance", STATIC.IsHAnimationManager )
end


--- @class HAnimationManagerInstance
--- @field AnimationPointerTable table<string, HAnimationInstance|boolean>

function INSTANCE:Renegade_HAnimationManager()
    -- "Create the hash tables"
    self.AnimationPointerTable = {}
end

function INSTANCE:_Renegade_HAnimationManager()
    self:FreeAllAnims()
    self:ResetMissing() -- "Jani: Deleting missing animations as well"

    self.AnimationPointerTable = nil
end

--- "Loads a set of motion data from a file"
--- @param cload ChunkLoadInstance
--- @return integer
function INSTANCE:LoadAnimation( cload )
    local id = cload:CurChunkId()

    if id == w3dChunkTypeEnum.W3D_CHUNK_ANIMATION then
        return self:LoadRawAnimation( cload )

    elseif id == w3dChunkTypeEnum.W3D_CHUNK_COMPRESSED_ANIMATION then
        return self:LoadCompressedAnimation( cload )

    elseif id == w3dChunkTypeEnum.W3D_CHUNK_MORPH_ANIMATION then
        return self:LoadMorphAnimation()
    end

    return 0
end

function INSTANCE:GetAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:PeekAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:AddAnimation()
	typecheck.NotImplementedError()
end

function INSTANCE:FreeAllAnims()
	typecheck.NotImplementedError()
end

function INSTANCE:RegisterMissing()
	typecheck.NotImplementedError()
end

function INSTANCE:IsMissing()
	typecheck.NotImplementedError()
end

function INSTANCE:ResetMissing()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadCompressedAnimation()
	typecheck.NotImplementedError()
end

--- "Load a raw anim"
--- @param cload ChunkLoadInstance
--- @return integer
function INSTANCE:LoadRawAnimation( cload )
	
    local newAnimation = hRawAnimationClass.New()

end

function INSTANCE:LoadMorphAnimation()
	typecheck.NotImplementedError()
end
