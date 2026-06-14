-- Based on HLodLoaderClass within Code/ww3d2/hlod.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeLoaderClass
local prototypeLoaderClass = CNC.Import( "code/ww3d2/prototype-loader.lua" )

--- @class HLodLoaderClass : PrototypeLoaderClass
--- @field Instance HLodLoaderInstance The metatable used by HLodLoaderInstance
local STATIC = CNC.CreateExport( prototypeLoaderClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HLodLoaderClass"

--- @class HLodLoaderInstance : PrototypeLoaderInstance
--- @field Static HLodLoaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HLodLoader : Renegade_PrototypeLoader" )
INSTANCE.Class = "HLodLoaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHLodLoader = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )

	--- @type HLodDefinitionClass
	local hLodDefinitionClass = CNC.Import( "code/ww3d2/h-lod-definition.lua" )

	--- @type WW3dErrorTypes
	local wW3dErrorTypes = CNC.Import( "code/ww3d2/w3d-errors.lua" )

	--- @type HLodPrototypeClass
	local hLodPrototypeClass = CNC.Import( "code/ww3d2/h-lod-prototype.lua" )

	--- @type HLodLoaderClass
	local hLodLoaderClass = CNC.Import( "code/ww3d2/h-lod-loader.lua" )
--#endregion

--#region Imported Enums

	local wW3dErrorTypeEnum = wW3dErrorTypes.WW3D_ERROR_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HLodLoaderClass

    --- Creates a new HLodLoaderInstance
    --- @return HLodLoaderInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HLodLoader" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HLodLoaderInstance, `false` otherwise
    function STATIC.IsHLodLoader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHLodLoader and true or false
    end

    typecheck.RegisterType( "HLodLoaderInstance", STATIC.IsHLodLoader )

    function STATIC.StaticConstructor()
        STATIC.HLodLoader = hLodLoaderClass.New()
    end
end


--- @class HLodLoaderInstance

--- @return W3dChunkType
function INSTANCE:ChunkType()
    return w3dFileIds.W3D_CHUNK_TYPE.W3D_CHUNK_HLOD
end

--- "Loads an HlodDef from a W3D file"
--- @param cload ChunkLoadInstance
--- @return PrototypeInstance?
function INSTANCE:LoadW3d( cload )
    local definition = hLodDefinitionClass.New()

    if definition == nil then
        return nil
    end

    if definition:LoadW3d( cload ) ~= wW3dErrorTypeEnum.WW3D_ERROR_OK then
        -- "Load failed, delete the model and return an error"
        return nil
    else
        -- "Ok, accept this model!"
        local prototype = hLodPrototypeClass.New( definition )
        return prototype
    end
end
