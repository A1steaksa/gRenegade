-- Based on DamageableGameObjDef within Code/Combat/damageablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type ScriptableEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/scriptable-entity-def.lua" )

--- @class DamageableEntityDefClass : ScriptableEntityDefClass
local STATIC = CNC.CreateExport( PARENT )
STATIC.Class = "DamageableEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class DamageableEntityDefInstance: ScriptableEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_DamageableEntityDefClass : Renegade_ScriptableEntityDefClass" )
INSTANCE.Class = "DamageableEntityDefInstance"
INSTANCE.IsDamageableEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--#region Imports

    --- @type ScriptableEntityDefClass
    local scriptableEntityDefClass = CNC.Import( "renhud/code/combat/scriptable-entity-def.lua" )

    --- @type DefenseEntityDefClass
    local defenseEntityDefClass = CNC.Import( "renhud/code/combat/defense-entity-def.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum.lua" )

    --- @type PlayerType
    local playerType = CNC.Import( "renhud/code/combat/player-type.lua" )
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

    --- @class DamageableEntityDefClass

    --- Creates a new DamageableEntityDefClass
    --- @vararg any
    --- @return DamageableEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_DamageableEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DamageableEntityDefInstance, `false` otherwise
    function STATIC.IsDamageableEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDamageableEntityDefClass and true or false
    end

    typecheck.RegisterType( "DamageableEntityDefInstance", STATIC.IsDamageableEntityDefClass )
end


--- @class DamageableEntityDefInstance
--- @field DefenseEntityDef DefenseEntityDefClass
--- @field InfoIconMaterial IMaterial
--- @field TranslatedNameId integer
--- @field EncyclopediaType EncyclopediaTypeEnum
--- @field EncyclopediaId integer
--- @field NotTargetable boolean
--- @field DefaultPlayerType integer

--- Constructs a new DamageableEntityDefInstance
function INSTANCE:Renegade_DamageableEntityDefClass()
    self.TranslatedNameId = 0
    -- self.EncyclopediaType = encyclopediaTypeEnum.Unknown
    self.EncyclopediaId = 0
    self.DefaultPlayerType = playerTypeEnum.Neutral
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )
    Section.Start( "Loading " .. INSTANCE.Class )

    local ids = STATIC.ChunkIds
    local dataTypeEnum = STATIC.DATA_TYPE

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.CHUNKID_DEF_PARENT then
            scriptableEntityDefClass.Instance.Load( self, cload )

        elseif chunkId == ids.CHUNKID_DEF_VARIABLES then
            Section.Start( INSTANCE.Class .. " Variables Start" )

            while cload:OpenMicroChunk() do
                local didRead =
                    self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_TRANSLATED_NAME_ID, dataTypeEnum.Int, "TranslatedNameId" )
                    or self:ReadMicroChunkWWString( cload, ids.MICROCHUNKID_DEF_INFO_ICON_TEXTURE_FILENAME, "InfoIconTextureFilename" )
				    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ENCY_TYPE, dataTypeEnum.Int, "EncyclopediaType" )
				    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_ENCY_ID, dataTypeEnum.Int, "EncyclopediaId" )
				    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_NOT_TARGETABLE, dataTypeEnum.Boolean, "NotTargetable" )
				    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_DEFAULT_PLAYER_TYPE, dataTypeEnum.Int, "DefaultPlayerType" )

                if not didRead then
                    Section.Print( "Unrecognized " .. INSTANCE.Class .. " Variable Chunk ID", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end

            Section.End()

        elseif chunkId == ids.CHUNKID_DEF_DEFENSEOBJECTDEF then
            defenseEntityDefClass.Instance.Load( self, cload )

        else
            Section.Print( "Unrecognized " .. INSTANCE.Class .. " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    Section.End()

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

--- @return DefenseEntityDefClass
function INSTANCE:GetDefenseEntityDef()
    return self.DefenseEntityDef
end

--[[ Accessors (Added as needed) ]] do

    --- @return PlayerTypeEnum
    function INSTANCE:GetDefaultPlayerType()
        return self.DefaultPlayerType
    end
end