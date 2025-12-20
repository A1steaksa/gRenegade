-- Based on PhysicalGameObjDef within Code/Combat/Physicalgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type DamageableEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/damageable-entity-def.lua" )

--- @class PhysicalEntityDefClass : DamageableEntityDefClass
local STATIC = CNC.CreateExport( PARENT )
local CLASS = "PhysicalEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class PhysicalEntityDefInstance : DamageableEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_PhysicalEntityDefClass : Renegade_DamageableEntityDefClass" )
INSTANCE.IsPhysicalEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC

--#region Imports

    --- @type ScriptableEntityDefClass
    local scriptableEntityDefClass = CNC.Import( "renhud/code/combat/scriptable-entity-def.lua" )

    --- @type DefenseEntityDefClass
    local defenseEntityDefClass = CNC.Import( "renhud/code/combat/defense-entity-def.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum.lua" )

    --- @type RadarManagerClass
    local radarClass = CNC.Import( "renhud/client/code/combat/radar.lua" )
--#endregion


--#region Imported Enums

    local blipShapeTypeEnum = radarClass.BLIP_SHAPE_TYPE
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_DEF_VARIABLES						= enumBuilder:Set( 909991657 ),
        LEGACY_CHUNKID_DEF_PARENT_OLD               = enumBuilder:Next(),
        XXXCHUNKID_DEF_PARENT_OLD_OLD               = enumBuilder:Next(),
        LEGACY_CHUNKID_DEF_DEFENSEOBJECTDEF         = enumBuilder:Next(),
        CHUNKID_DEF_PARENT                          = enumBuilder:Next(),

        MICROCHUNKID_DEF_TYPE						= enumBuilder:Set( 1 ),
        MICROCHUNKID_DEF_BULLSEYE_OFFSET_Z          = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_DEFAULT_GANG            = enumBuilder:Next(),
        MICROCHUNKID_DEF_BLIP_TYPE                  = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_MODEL_NAME              = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_HEALTH                  = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_HEALTH_MAX              = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_SKIN                    = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_SHIELD_STRENGTH         = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_SHIELD_STRENGTH_MAX     = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_SHIELD_TYPE             = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_LISTEN_RANGE            = enumBuilder:Next(),
        XXX_MICROCHUNKID_DEF_SCRIPT_NAME            = enumBuilder:Next(),
        XXX_MICROCHUNKID_DEF_SCRIPT_PARAMETERS      = enumBuilder:Next(),
        XXXMICROCHUNKID_DEF_POSITION                = enumBuilder:Next(),
        MICROCHUNKID_DEF_FACING                     = enumBuilder:Next(),
        MICROCHUNKID_DEF_ANIMATION                  = enumBuilder:Next(),
        MICROCHUNKID_DEF_PHYS_ID                    = enumBuilder:Next(),
        LEGACY_MICROCHUNKID_DEF_DEFAULT_PLAYER_TYPE = enumBuilder:Next(),
        MICROCHUNKID_DEF_KILLED_EXPLOSION           = enumBuilder:Next(),
        LEGACY_MICROCHUNKID_DEF_TRANSLATED_NAME_ID  = enumBuilder:Next(),
        MICROCHUNKID_DEF_DEFAULT_HIBERNATION_ENABLE = enumBuilder:Next(),
        MICROCHUNKID_DEF_ALLOW_INNATE_CONVERSATIONS = enumBuilder:Next(),
        MICROCHUNKID_DEF_ORATOR_TYPE                = enumBuilder:Next(),
        MICROCHUNKID_DEF_USE_CREATION_EFFECT        = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class PhysicalEntityDefClass

    --- Creates a new PhysicalEntityDefClass
    --- @vararg any
    --- @return PhysicalEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_PhysicalEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicalEntityDefInstance, `false` otherwise
    function STATIC.IsPhysicalEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicalEntityDefClass and true or false
    end

    typecheck.RegisterType( "PhysicalEntityDefInstance", STATIC.IsPhysicalEntityDefClass )
end


--- @class PhysicalEntityDefInstance
--- @field Type integer
--- @field RadarBlipType BlipShapeType
--- @field BullseyeOffsetZ number
--- @field Animation string
--- @field PhysDefId integer
--- @field KilledExplosion integer
--- @field DefaultHibernationEnable boolean
--- @field AllowInnateConversations boolean
--- @field OratorType integer
--- @field UseCreationEffect boolean

--- Constructs a new PhysicalEntityDefInstance
function INSTANCE:Renegade_PhysicalEntityDefClass()
    self.Type = 0
    self.BullseyeOffsetZ = 0.0
    self.RadarBlipType = blipShapeTypeEnum.None
    self.PhysDefId = 0
    self.KilledExplosion = 0
    self.OratorType = 999 -- See "Code/Combat/oratortypes.h" for source
    self.DefaultHibernationEnable = true
    self.AllowInnateConversations = false
    self.UseCreationEffect = false
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )
    Section.Start( "Loading " .. CLASS )

    local ids = STATIC.ChunkIds
    local dataTypeEnum = STATIC.DATA_TYPE

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.LEGACY_CHUNKID_DEF_PARENT_OLD then
            scriptableEntityDefClass.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_PARENT then
            PARENT.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_VARIABLES then
            while cload:OpenMicroChunk() do
                local didRead =
                    self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_TYPE, dataTypeEnum.Int, "Type" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_BULLSEYE_OFFSET_Z, dataTypeEnum.Float, "BullseyeOffsetZ" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_BLIP_TYPE, dataTypeEnum.Int, "RadarBlipType" )
                    or self:ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_ANIMATION, "Animation" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_PHYS_ID, dataTypeEnum.Int, "PhysDefID" )
                    or self:ReadMicroChunk( cload, ids.LEGACY_MICROCHUNKID_DEF_DEFAULT_PLAYER_TYPE, dataTypeEnum.Int, "DefaultPlayerType" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_KILLED_EXPLOSION, dataTypeEnum.Int, "KilledExplosion" )
                    or self:ReadMicroChunk( cload, ids.LEGACY_MICROCHUNKID_DEF_TRANSLATED_NAME_ID, dataTypeEnum.Int, "TranslatedNameID" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_DEFAULT_HIBERNATION_ENABLE, dataTypeEnum.Boolean, "DefaultHibernationEnable" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ALLOW_INNATE_CONVERSATIONS, dataTypeEnum.Boolean, "AllowInnateConversations" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ORATOR_TYPE, dataTypeEnum.Int, "OratorType" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_USE_CREATION_EFFECT, dataTypeEnum.Boolean, "UseCreationEffect" )

                if not didRead then
                    Section.Print( "Unrecognized " .. CLASS .. " Variable Chunk ID", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end
        elseif chunkId == ids.LEGACY_CHUNKID_DEF_DEFENSEOBJECTDEF then
            defenseEntityDefClass.Instance.Load( self, cload )

        else
            Section.Print( "Unrecognized " .. CLASS .. " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    Section.End()

    return true
end

--- @return boolean wasValid, string? errorMessage
function INSTANCE:IsValidConfig()
    local returnValue = false

    --- @type DefinitionInstance
    local physDef = definitionManagerClass.FindDefinition( self.PhysDefId )

    if physDef then
        returnValue = physDef
    end

    return returnValue
end

--- @return integer
function INSTANCE:GetPhysDefId()
    return self.PhysDefId
end

--- @return integer
function INSTANCE:GetOratorType()
    return self.OratorType
end
