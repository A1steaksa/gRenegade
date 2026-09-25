-- Based on SubObjectArrayClass within Code/ww3d2/hlod.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class SubObjectArrayClass
--- @field Instance SubObjectArrayInstance The metatable used by SubObjectArrayInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SubObjectArrayClass"

--- @class SubObjectArrayInstance
--- @field Static SubObjectArrayClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SubObjectArray" )
INSTANCE.Class = "SubObjectArrayInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSubObjectArray = true

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

    --- @class SubObjectArrayClass

    --- Creates a new SubObjectArrayInstance
    --- @return SubObjectArrayInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SubObjectArray" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SubObjectArrayInstance, `false` otherwise
    function STATIC.IsSubObjectArray( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSubObjectArray and true or false
    end

    typecheck.RegisterType( "SubObjectArrayInstance", STATIC.IsSubObjectArray )
end


--- "
--- Describes a level-of-detail in an HLod object.  Note that this is
--- a render object which will be exploded when the HLod is constructed (its
--- sub-objects, if any, will be placed into the HLod).
--- "
--- @class SubObjectArrayInstance
--- @field MaxScreenSize number
--- @field ModelCount integer
--- @field ModelName string[] "Array of model names"
--- @field BoneIndex integer[] "Array of bone indices"

function INSTANCE:Renegade_SubObjectArray()
    self.MaxScreenSize = w3dFileIds.NO_MAX_SCREEN_SIZE
    self.ModelCount = 0
    self.ModelName = nil
    self.BoneIndex = nil
end

function INSTANCE:_Renegade_SubObjectArray()
    self:Reset()
end

--- "Release the contents of this array"
function INSTANCE:Reset()
    if self.ModelName ~= nil then
        self.ModelName = nil
    end

    if self.BoneIndex ~= nil then
        self.BoneIndex = nil
    end

    self.ModelCount = 0
end

--- "LodArray load function"
--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:LoadW3d( cload )
    -- "Open the first chunk, it should be a Lod Array Header"
    if not cload:OpenChunk() then
        return false
    end

    if cload:CurChunkId() ~= w3dChunkTypeEnum.W3D_CHUNK_HLOD_SUB_OBJECT_ARRAY_HEADER then
        return false
    end

    local header = cload:ReadStruct( "W3dHLodArrayHeaderStruct" )
    if header == nil then
        return false
    end

    if not cload:CloseChunk() then
        return false
    end

    self.ModelCount = header.ModelCount
    self.MaxScreenSize = header.MaxScreenSize
    self.ModelName = {}
    self.BoneIndex = {}

    -- "Read each sub object definition"
    for iModel = 1, self.ModelCount do
        if not cload:OpenChunk() then
            return false
        end

        if cload:CurChunkId() ~= w3dChunkTypeEnum.W3D_CHUNK_HLOD_SUB_OBJECT then
            return false
        end

        local subObjectDefinition = cload:ReadStruct( "W3dHLodSubObjectStruct" )
        if subObjectDefinition == nil then
            return false
        end

        if not cload:CloseChunk() then
            return false
        end

        self.ModelName[iModel] = subObjectDefinition.Name
        self.BoneIndex[iModel] = subObjectDefinition.BoneIndex
    end

    return true
end

function INSTANCE:SaveW3d()
	typecheck.NotImplementedError()
end
