-- Based on HModelLoaderClass within Code/ww3d2/proto.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeLoaderClass
local prototypeLoaderClass = CNC.Import( "code/ww3d2/prototype-loader.lua" )

--- @class HModelLoaderClass : PrototypeLoaderClass
--- @field Instance HModelLoaderInstance The metatable used by HModelLoaderInstance
local STATIC = CNC.CreateExport( prototypeLoaderClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HModelLoaderClass"

--- @class HModelLoaderInstance : PrototypeLoaderInstance
--- @field Static HModelLoaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HModelLoader : Renegade_PrototypeLoader" )
INSTANCE.Class = "HModelLoaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHModelLoader = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HModelLoaderClass

    --- Creates a new HModelLoaderInstance
    --- @return HModelLoaderInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HModelLoader" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HModelLoaderInstance, `false` otherwise
    function STATIC.IsHModelLoader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHModelLoader and true or false
    end

    typecheck.RegisterType( "HModelLoaderInstance", STATIC.IsHModelLoader )
end


--- @class HModelLoaderInstance

function INSTANCE:ChunkType()
	typecheck.NotImplementedError()
end

function INSTANCE:LoadW3d()
	typecheck.NotImplementedError()
end
