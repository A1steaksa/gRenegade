-- Based on DamageableGameObjDef within Code/Combat/damageablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ScriptableGameObjectDefinitionClass
local scriptableGameObjectDefinitionClass = CNC.Import( "code/combat/scriptable-game-object-definition.lua" )

--- @class DamageableGameObjectDefinitionClass : ScriptableGameObjectDefinitionClass
local STATIC = CNC.CreateExport( scriptableGameObjectDefinitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DamageableGameObjectDefinitionClass"

--- @class DamageableGameObjectDefinitionInstance: ScriptableGameObjectDefinitionInstance
local INSTANCE = robustclass.Register( "Renegade_DamageableGameObjectDefinition : Renegade_ScriptableGameObjectDefinition" )
INSTANCE.Class = "DamageableGameObjectDefinitionInstance"
INSTANCE.IsDamageableGameObjectDefinitionClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--#region Imports

	--- @type DefenseObjectDefinitionClass
	local defenseObjectDefinitionClass = CNC.Import( "code/combat/defense-object-definition.lua" )

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type PlayerTypeClass
	local playerTypeClass = CNC.Import( "code/combat/player-type.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion


--#region Imported Enums

	local playerTypeEnum = playerTypeClass.PLAYER_TYPE_ENUM
	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_DEF_PARENT              = enumBuilder:Set( 207011205 ),
        CHUNKID_DEF_VARIABLES           = enumBuilder:Next(),
        CHUNKID_DEF_DEFENSEOBJECTDEF    = enumBuilder:Next(),

        MICROCHUNKID_DEF_TRANSLATED_NAME_ID             = enumBuilder:Set( 1 ),
        MICROCHUNKID_DEF_INFO_ICON_TEXTURE_FILENAME     = enumBuilder:Next(),
        MICROCHUNKID_DEF_ENCY_TYPE                      = enumBuilder:Next(),
        MICROCHUNKID_DEF_ENCY_ID                        = enumBuilder:Next(),
        MICROCHUNKID_DEF_NOT_TARGETABLE                 = enumBuilder:Next(),
        MICROCHUNKID_DEF_DEFAULT_PLAYER_TYPE            = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class DamageableGameObjectDefinitionClass

    --- Creates a new DamageableGameObjectDefinitionInstance
    --- @return DamageableGameObjectDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DamageableGameObjectDefinition")
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DamageableGameObjectDefinitionInstance, `false` otherwise
    function STATIC.IsDamageableGameObjectDefinitionClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDamageableGameObjectDefinitionClass and true or false
    end

    typecheck.RegisterType( "DamageableGameObjectDefinitionInstance", STATIC.IsDamageableGameObjectDefinitionClass )
end


--- @class DamageableGameObjectDefinitionInstance
--- @field DefenseObjectDefinition DefenseObjectDefinitionInstance
--- @field InfoIconMaterial IMaterial
--- @field TranslatedNameId integer
--- @field EncyclopediaType EncyclopediaTypeEnum
--- @field EncyclopediaId integer
--- @field NotTargetable boolean
--- @field DefaultPlayerType integer

--- Constructs a new DamageableGameObjectDefinitionInstance
function INSTANCE:Renegade_DamageableGameObjectDefinition()
    self.TranslatedNameId = 0
    -- self.EncyclopediaType = encyclopediaTypeEnum.Unknown
    self.EncyclopediaId = 0
    self.DefaultPlayerType = playerTypeEnum.Neutral
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )
    local ids = STATIC.ChunkIds
    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.CHUNKID_DEF_PARENT then
            scriptableGameObjectDefinitionClass.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_VARIABLES then
            while cload:OpenMicroChunk() do
                local didRead = (
                       chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_TRANSLATED_NAME_ID,     fundamentalDataTypeEnum.Int,       self, "TranslatedNameId" )
                    or chunkIOClass.ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_INFO_ICON_TEXTURE_FILENAME, self, "InfoIconTextureFilename" )
				    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ENCY_TYPE,              fundamentalDataTypeEnum.Int,       self, "EncyclopediaType" )
				    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ENCY_ID,                fundamentalDataTypeEnum.Int,       self, "EncyclopediaId" )
				    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_NOT_TARGETABLE,         fundamentalDataTypeEnum.Boolean,   self, "NotTargetable" )
				    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_DEFAULT_PLAYER_TYPE,    fundamentalDataTypeEnum.Int,       self, "DefaultPlayerType" )
                )

                if not didRead then
                    section.Warn( "Unrecognized ", INSTANCE.Class, " Variable Chunk ID: ", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end

        elseif chunkId == ids.CHUNKID_DEF_DEFENSEOBJECTDEF then
            defenseObjectDefinitionClass.Instance.Load( self --[[@as DefenseObjectDefinitionInstance]], cload )

        else
            section.Warn( "Unrecognized ", INSTANCE.Class, " Chunk ID: ", chunkId )
        end

        cload:CloseChunk()
    end

    return true
end

--- @return boolean wasValid, string? errorMessage
function INSTANCE:IsValidConfig()
    typecheck.NotImplementedError()
end

--- @return integer
function INSTANCE:GetNameId()
    return self.TranslatedNameId
end

--[[ Encyclopedia Information ]] do

    --- @return EncyclopediaType
    function INSTANCE:GetEncyclopediaType()
        return self.EncyclopediaType
    end

    --- @return integer
    function INSTANCE:GetEncyclopediaId()
        return self.EncyclopediaId
    end
end

--[[ Icon Information ]] do

    --- @return IMaterial
    function INSTANCE:GetIconMaterial()
        return self.InfoIconMaterial
    end
end

--- @return integer
function INSTANCE:GetTranslatedNameId()
    return self.TranslatedNameId
end

--- @return DefenseObjectDefinitionInstance
function INSTANCE:GetDefenseObjectDefinition()
    return self.DefenseObjectDefinition
end

--[[ Accessors (Added as needed) ]] do

    --- @return PlayerTypeEnum
    function INSTANCE:GetDefaultPlayerType()
        return self.DefaultPlayerType
    end
end