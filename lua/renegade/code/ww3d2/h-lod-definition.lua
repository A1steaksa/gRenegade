-- Based on HLodDefClass within Code/ww3d2/hlod.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class HLodDefinitionClass
--- @field Instance HLodDefinitionInstance The metatable used by HLodDefinitionInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HLodDefinitionClass"

--- @class HLodDefinitionInstance
--- @field Static HLodDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HLodDefinition" )
INSTANCE.Class = "HLodDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHLodDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type WW3dErrorTypes
	local wW3dErrorTypes = CNC.Import( "code/ww3d2/w3d-errors.lua" )

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )

	--- @type SubObjectArrayClass
	local subObjectArrayClass = CNC.Import( "code/ww3d2/sub-object-array.lua" )
--#endregion

--#region Imported Enums

	local wW3dErrorTypeEnum = wW3dErrorTypes.WW3D_ERROR_TYPE
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HLodDefinitionClass

    --- Creates a new HLodDefinitionInstance
    --- @return HLodDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HLodDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HLodDefinitionInstance, `false` otherwise
    function STATIC.IsHLodDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHLodDefinition and true or false
    end

    typecheck.RegisterType( "HLodDefinitionInstance", STATIC.IsHLodDefinition )
end


--- @class HLodDefinitionInstance
--- @field Name string
--- @field HierarchyTreeName string
--- @field LodCount integer
--- @field Lod SubObjectArrayInstance[]
--- @field Aggregates SubObjectArrayInstance
--- @field ProxyArray any

--- @param srcLod HLodInstance?
function INSTANCE:Renegade_HLodDefinition( srcLod )
    self.Name = nil
    self.HierarchyTreeName = nil
    self.LodCount = 0
    self.Lod = nil
    self.ProxyArray = nil

    self.Aggregates = subObjectArrayClass.New()

    -- ( srcLod: HLodInstance )
    if srcLod ~= nil then
        INSTANCE.Initialize( self, srcLod )
    end
end

function INSTANCE:_Renegade_HLodDefinition()
    self:Free()
end

--- "Loads this HLodDef from a W3d File"
--- @param cload ChunkLoadInstance
--- @return WW3dErrorType
function INSTANCE:LoadW3d( cload )
	-- "First, make sure we release any memory in use"
    self:Free()

    if self:ReadHeader( cload ) == false then
        return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
    end

    -- "Loop through all the LODs and read the info from its chunk"
    for iLod = 1, self.LodCount do
        -- "Open the next chunk, it should be a LOD struct"
        if not cload:OpenChunk() then
            return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
        end

        if cload:CurChunkId() ~= w3dFileIds.W3D_CHUNK_TYPE.W3D_CHUNK_HLOD_LOD_ARRAY then
            -- "ERROR: Expected LOD struct!"
            return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
        end

        self.Lod[iLod]:LoadW3d( cload )

        -- "Close-out the chunk"
        cload:CloseChunk()
    end

    -- "Parse the rest of the chunks"
    local ids = w3dFileIds.W3D_CHUNK_TYPE
    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()
        if chunkId == ids.W3D_CHUNK_HLOD_AGGREGATE_ARRAY then
            self.Aggregates:LoadW3d( cload )
        elseif chunkId == ids.W3D_CHUNK_HLOD_PROXY_ARRAY then
            self:ReadProxyArray( cload )
        end
        cload:CloseChunk()
    end

    return wW3dErrorTypeEnum.WW3D_ERROR_OK
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

--- @return string
function INSTANCE:GetName()
    return self.Name
end

function INSTANCE:Initialize()
	typecheck.NotImplementedError()
end

function INSTANCE:SaveHeader()
	typecheck.NotImplementedError()
end

function INSTANCE:SaveLodArray()
	typecheck.NotImplementedError()
end

function INSTANCE:SaveAggregateArray()
	typecheck.NotImplementedError()
end

function INSTANCE:Free()
    if self.Name then
        self.Name = nil
    end

    if self.HierarchyTreeName then
        self.HierarchyTreeName = nil
    end

    if self.Lod then
        self.Lod = nil
    end
    self.LodCount = 0

    self.ProxyArray = nil
end

--- "loads the HLodDef header from a W3d file"
--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:ReadHeader( cload )
    -- "Open the first chunk, it should be the LOD header"
    if not cload:OpenChunk() then
        return false
    end

    if cload:CurChunkId() ~= w3dFileIds.W3D_CHUNK_TYPE.W3D_CHUNK_HLOD_HEADER then
        -- "ERROR: Expected HLOD Header!"
        return false
    end

    local header = cload:ReadStruct( "W3dHLodHeaderStruct" )
    if header == nil then
        return false
    end
    cload:CloseChunk()

    -- "Copy the name into our internal variable"
    self.Name = header.Name
    self.HierarchyTreeName = header.HierarchyName
    self.LodCount = header.LodCount
    self.Lod = {}
    for i = 1, self.LodCount do
        self.Lod[i] = subObjectArrayClass.New()
    end
    return true
end

function INSTANCE:ReadProxyArray()
	typecheck.NotImplementedError()
end
