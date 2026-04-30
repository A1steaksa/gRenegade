-- Based on DamageableGameObjDef within Code/Combat/damageablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type ScriptableGameObjectDefinitionClass
local PARENT = CNC.Import( "code/combat/scriptable-game-object-definition.lua" )

--- @class DamageableGameObjectDefinitionClass : ScriptableGameObjectDefinitionClass
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "DamageableGameObjectDefinitionClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class DamageableGameObjectDefinitionInstance: ScriptableGameObjectDefinitionInstance
local INSTANCE = robustclass.Register( "Renegade_DamageableGameObjectDefinitionClass : Renegade_ScriptableGameObjectDefinitionClass" )
INSTANCE.Class = "DamageableGameObjectDefinitionInstance"
INSTANCE.IsDamageableGameObjectDefinitionClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--#region Imports

    --- @type ScriptableGameObjectDefinitionClass
    local scriptableGameObjectDefinitionClass = CNC.Import( "code/combat/scriptable-game-object-definition.lua" )

    --- @type DefenseObjectDefinitionClass
    local defenseGameObjectDefinitionClass = CNC.Import( "code/combat/defense-game-object-definition.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    --- @type PlayerTypeClass
    local playerType = CNC.Import( "code/combat/player-type.lua" )
--#endregion


--#region Imported Enums

    local playerTypeEnum = playerType.PLAYER_TYPE_ENUM
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

    --- Creates a new DamageableGameObjectDefinitionClass
    --- @vararg any
    --- @return DamageableGameObjectDefinitionClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_DamageableGameObjectDefinitionClass", ... )
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
function INSTANCE:Renegade_DamageableGameObjectDefinitionClass()
    self.TranslatedNameId = 0
    -- self.EncyclopediaType = encyclopediaTypeEnum.Unknown
    self.EncyclopediaId = 0
    self.DefaultPlayerType = playerTypeEnum.Neutral
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )
    section.Start( "Loading " .. INSTANCE.Class )

    local ids = STATIC.ChunkIds
    local dataTypeEnum = STATIC.DATA_TYPE

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.CHUNKID_DEF_PARENT then
            scriptableGameObjectDefinitionClass.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_VARIABLES then
            section.Start( INSTANCE.Class .. " Variables Start" )

            while cload:OpenMicroChunk() do
                local didRead =
                    self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_TRANSLATED_NAME_ID, dataTypeEnum.Int, "TranslatedNameId" )
                    or self:ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_INFO_ICON_TEXTURE_FILENAME, "InfoIconTextureFilename" )
				    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ENCY_TYPE, dataTypeEnum.Int, "EncyclopediaType" )
				    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ENCY_ID, dataTypeEnum.Int, "EncyclopediaId" )
				    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_NOT_TARGETABLE, dataTypeEnum.Boolean, "NotTargetable" )
				    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_DEFAULT_PLAYER_TYPE, dataTypeEnum.Int, "DefaultPlayerType" )

                if not didRead then
                    section.Print( "Unrecognized " .. INSTANCE.Class .. " Variable Chunk ID", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end

            section.End()

        elseif chunkId == ids.CHUNKID_DEF_DEFENSEOBJECTDEF then
            defenseGameObjectDefinitionClass.Instance.Load( self, cload )

        else
            section.Print( "Unrecognized " .. INSTANCE.Class .. " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    section.End()

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

--- @return DefenseObjectDefinitionClass
function INSTANCE:GetDefenseObjectDefinition()
    return self.DefenseObjectDefinition
end

--[[ Accessors (Added as needed) ]] do

    --- @return PlayerTypeEnum
    function INSTANCE:GetDefaultPlayerType()
        return self.DefaultPlayerType
    end
end