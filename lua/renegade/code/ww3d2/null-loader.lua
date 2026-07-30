-- Based on NullLoaderClass within Code/ww3d2/nullrobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeLoaderClass
local prototypeLoaderClass = CNC.Import( "code/ww3d2/prototype-loader.lua" )

--- @class NullLoaderClass : PrototypeLoaderClass
--- @field Instance NullLoaderInstance The metatable used by NullLoaderInstance
local STATIC = CNC.CreateExport( prototypeLoaderClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "NullLoaderClass"

--- @class NullLoaderInstance : PrototypeLoaderInstance
--- @field Static NullLoaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_NullLoader : Renegade_PrototypeLoader" )
INSTANCE.Class = "NullLoaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsNullLoader = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )
--#endregion

--#region Imported Enums

	local w3dChunkTypesEnum = w3dFileIds.W3D_CHUNK_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class NullLoaderClass

    --- Creates a new NullLoaderInstance
    --- @return NullLoaderInstance
    function STATIC.New()
        return robustclass.New( "Renegade_NullLoader" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) NullLoaderInstance, `false` otherwise
    function STATIC.IsNullLoader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsNullLoader and true or false
    end

    typecheck.RegisterType( "NullLoaderInstance", STATIC.IsNullLoader )
end


--- @class NullLoaderInstance

function INSTANCE:Renegade_NullLoader()
    prototypeLoaderClass.Instance.Renegade_PrototypeLoader( self )
end

--- @return integer
function INSTANCE:ChunkType()
   return w3dChunkTypesEnum.W3D_CHUNK_NULL_OBJECT
end

--- @param cload ChunkLoadInstance
--- @return PrototypeInstance?
function INSTANCE:LoadW3d( cload )
    typecheck.NotImplementedError()
end
