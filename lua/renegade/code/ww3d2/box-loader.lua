-- Based on BoxLoaderClass within Code/ww3d2/boxrobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeLoaderClass
local prototypeLoaderClass = CNC.Import( "code/ww3d2/prototype-loader.lua" )

--- @class BoxLoaderClass : PrototypeLoaderClass
--- @field Instance BoxLoaderInstance The metatable used by BoxLoaderInstance
local STATIC = CNC.CreateExport( prototypeLoaderClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BoxLoaderClass"

--- @class BoxLoaderInstance : PrototypeLoaderInstance
--- @field Static BoxLoaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BoxLoader : Renegade_PrototypeLoader" )
INSTANCE.Class = "BoxLoaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBoxLoader = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )

	--- @type BoxPrototypeClass
	local boxPrototypeClass = CNC.Import( "code/ww3d2/box-prototype.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class BoxLoaderClass

    --- Creates a new BoxLoaderInstance
    --- @return BoxLoaderInstance
    function STATIC.New()
        return robustclass.New( "Renegade_BoxLoader" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BoxLoaderInstance, `false` otherwise
    function STATIC.IsBoxLoader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBoxLoader and true or false
    end

    typecheck.RegisterType( "BoxLoaderInstance", STATIC.IsBoxLoader )
end

--- "Loader for boxes"
--- @class BoxLoaderInstance

function INSTANCE:Renegade_BoxLoader()
    prototypeLoaderClass.Instance.Renegade_PrototypeLoader( self )
end

--- @return W3dChunkType
function INSTANCE:ChunkType()
    return w3dFileIds.W3D_CHUNK_TYPE.W3D_CHUNK_BOX
end

--- @param cload ChunkLoadInstance
--- @return PrototypeInstance?
function INSTANCE:LoadW3d( cload )
    local box = cload:ReadStruct( "W3dBoxStruct" )
    --- @cast box W3dBoxStruct
    return boxPrototypeClass.New( box )
end
