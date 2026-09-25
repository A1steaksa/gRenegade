-- Based on AggregateLoaderClass within Code/ww3d2/agg_def.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PrototypeLoaderClass
local prototypeLoaderClass = CNC.Import( "code/ww3d2/prototype-loader.lua" )

--- @class AggregateLoaderClass : PrototypeLoaderClass
--- @field Instance AggregateLoaderInstance The metatable used by AggregateLoaderInstance
local STATIC = CNC.CreateExport( prototypeLoaderClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AggregateLoaderClass"

--- @class AggregateLoaderInstance : PrototypeLoaderInstance
--- @field Static AggregateLoaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_AggregateLoader : Renegade_PrototypeLoader" )
INSTANCE.Class = "AggregateLoaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsAggregateLoader = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )

	--- @type AggregateDefinitionClass
	local aggregateDefinitionClass = CNC.Import( "code/ww3d2/aggregate-definition.lua" )

	--- @type WW3dErrorTypes
	local wW3dErrorTypes = CNC.Import( "code/ww3d2/w3d-errors.lua" )

	--- @type AggregatePrototypeClass
	local aggregatePrototypeClass = CNC.Import( "code/ww3d2/aggregate-prototype.lua" )

	--- @type AggregateLoaderClass
	local aggregateLoaderClass = CNC.Import( "code/ww3d2/aggregate-loader.lua" )
--#endregion

--#region Imported Enums

	local w3dChunkTypeEnum = w3dFileIds.W3D_CHUNK_TYPE
	local wW3dErrorTypeEnum = wW3dErrorTypes.WW3D_ERROR_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class AggregateLoaderClass

    

    --- Creates a new AggregateLoaderInstance
    --- @return AggregateLoaderInstance
    function STATIC.New()
        return robustclass.New( "Renegade_AggregateLoader" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) AggregateLoaderInstance, `false` otherwise
    function STATIC.IsAggregateLoader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsAggregateLoader and true or false
    end

    typecheck.RegisterType( "AggregateLoaderInstance", STATIC.IsAggregateLoader )

    function STATIC.StaticConstructor()
        STATIC.AggregateLoader = aggregateLoaderClass.New()
    end
end


--- @class AggregateLoaderInstance

function INSTANCE:Renegade_AggregateLoader()
    prototypeLoaderClass.Instance.Renegade_PrototypeLoader( self )
end

--- @return W3dChunkType
function INSTANCE:ChunkType()
    return w3dChunkTypeEnum.W3D_CHUNK_AGGREGATE
end

--- @param cload ChunkLoadInstance
--- @return PrototypeInstance?
function INSTANCE:LoadW3d( cload )
    -- "Assume failure"
    --- @type AggregatePrototypeInstance?
    local prototype = nil

    -- "Create a definition object"
    --- @type AggregateDefinitionInstance?
    local definition = aggregateDefinitionClass.New()
    if definition ~= nil then
        -- "Ask the definition object to load the aggregate data"
        if definition:LoadW3d( cload ) ~= wW3dErrorTypeEnum.WW3D_ERROR_OK then
            -- "Error! Free the definition"
            definition = nil
        else
            -- "Success!  Create a prototype from the definition"
            prototype = aggregatePrototypeClass.New( definition )
        end
    end

    -- "Return a pointer to the prototype"
    return prototype
end
