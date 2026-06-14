-- Based on PhysicalGameObjDef within Code/Combat/physicalgameobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DamageableGameObjectDefinitionClass
local damageableGameObjectDefinitionClass = CNC.Import( "code/combat/damageable-game-object-definition.lua" )

--- @class PhysicalGameObjectDefinitionClass : DamageableGameObjectDefinitionClass
--- @field Instance PhysicalGameObjectDefinitionInstance The metatable used by PhysicalGameObjectDefinitionInstance
local STATIC = CNC.CreateExport( damageableGameObjectDefinitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicalGameObjectDefinitionClass"

--- @class PhysicalGameObjectDefinitionInstance : DamageableGameObjectDefinitionInstance
--- @field Static PhysicalGameObjectDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PhysicalGameObjectDefinition : Renegade_DamageableGameObjectDefinition" )
INSTANCE.Class = "PhysicalGameObjectDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysicalGameObjectDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type DefinitionManagerClass
    local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

    --- @type OratorTypeClass
    local oratorTypeClass = CNC.Import( "code/combat/orator-types.lua" )
--#endregion


--#region Imported Enums

    local oratorTypeEnum = oratorTypeClass.ORATOR_TYPE
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class PhysicalGameObjectDefinitionClass

    --- Creates a new PhysicalGameObjectDefinitionInstance
    --- @return PhysicalGameObjectDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PhysicalGameObjectDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicalGameObjectDefinitionInstance, `false` otherwise
    function STATIC.IsPhysicalGameObjectDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicalGameObjectDefinition and true or false
    end

    typecheck.RegisterType( "PhysicalGameObjectDefinitionInstance", STATIC.IsPhysicalGameObjectDefinition )
end


--- @class PhysicalGameObjectDefinitionInstance
--- @field Type integer
--- @field RadarBlipType integer
--- @field BullseyeOffsetZ number
--- @field Animation string
--- @field PhysicsDefinitionId integer
--- @field KilledExplosion integer
--- @field DefaultHibernationEnable boolean
--- @field AllowInnateConversations boolean
--- @field OratorType integer
--- @field UseCreationEffect boolean

function INSTANCE:Renegade_PhysicalGameObjectDefinition()
    self.Type = 0
    self.BullseyeOffsetZ = 0
    self.RadarBlipType = 0
    self.PhysicsDefinitionId = 0
    self.KilledExplosion = 0
    self.OratorType = oratorTypeEnum.ORATOR_TYPE_START - 1
    self.DefaultHibernationEnable = true
    self.AllowInnateConversations = false
    self.UseCreationEffect = false
end

--- @param csave ChunkSaveInstance
--- @return boolean
function INSTANCE:Save( csave )
    typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    local ids = STATIC.ChunkIds
    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()
        if chunkId == ids.LEGACY_CHUNKID_DEF_PARENT_OLD then
            scriptableGameObjectDefinitionClass.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_PARENT then
            damageableGameObjectDefinitionClass.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_VARIABLES then
            while cload:OpenMicroChunk() do

                local didRead = (
                       chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_TYPE,                       fundamentalDataTypeEnum.Int,       self, "Type" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_BULLSEYE_OFFSET_Z,          fundamentalDataTypeEnum.Float,     self, "BullseyeOffsetZ" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_BLIP_TYPE,                  fundamentalDataTypeEnum.Int,       self, "RadarBlipType" )
                    or chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_ANIMATION, self, "Animation" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_PHYS_ID,                    fundamentalDataTypeEnum.Int,       self, "PhysicsDefinitionId" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.LEGACY_MICROCHUNKID_DEF_DEFAULT_PLAYER_TYPE, fundamentalDataTypeEnum.Int,       self, "DefaultPlayerType" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_KILLED_EXPLOSION,           fundamentalDataTypeEnum.Int,       self, "KilledExplosion" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.LEGACY_MICROCHUNKID_DEF_TRANSLATED_NAME_ID,  fundamentalDataTypeEnum.Int,       self, "TranslatedNameId" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_DEFAULT_HIBERNATION_ENABLE, fundamentalDataTypeEnum.Boolean,   self, "DefaultHibernationEnable" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ALLOW_INNATE_CONVERSATIONS, fundamentalDataTypeEnum.Boolean,   self, "AllowInnateConversations" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ORATOR_TYPE,                fundamentalDataTypeEnum.Int,       self, "OratorType" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_USE_CREATION_EFFECT,        fundamentalDataTypeEnum.Boolean,   self, "UseCreationEffect" )
                )

                if not didRead then
                    section.Warn( "Unrecognized PhysicalDef Variable Chunk ID: ", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end

        elseif chunkId == ids.LEGACY_CHUNKID_DEF_DEFENSEOBJECTDEF then
            defenseObjectDefinitionClass.instance.Load( self --[[@as DefenseObjectDefinitionInstance]], cload )

        else
            section.Warn( "Unrecognized PhysicalGameObjDef Chunk ID: ", chunkId )
        end

        cload:CloseChunk()
    end

    return true
end

--- @return boolean, string?
function INSTANCE:IsValidConfig()
    local returnValue = false
    local message

    local physicsDefinition = definitionManagerClass.FindDefinition( self.PhysicsDefinitionId )
    if physicsDefinition then
        returnValue, message = physicsDefinition:IsValidConfig()
    else
        message = "Can't find physics object definition"
    end

    return returnValue, message
end

--- @return integer
function INSTANCE:GetPhysicsDefinitionId()
    return self.PhysicsDefinitionId
end

--- @return integer
function INSTANCE:GetOratorType()
    return self.OratorType
end
