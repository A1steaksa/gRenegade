-- Based on DefenseObjectDefClass within Code/Combat/damage.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DefenseObjectDefinitionClass
--- @field instance DefenseObjectDefinitionInstance The metatable used by DefenseObjectDefinitionInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "DefenseDefinitionClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class DefenseObjectDefinitionInstance
--- @field Static DefenseObjectDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DefenseObjectDefinition" )
INSTANCE.Class = "DefenseDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDefenseDefinition = true


--#region Exported Enums

--#endregion


--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type ArmorWarheadManagerClass
	local armorWarheadManagerClass = CNC.Import( "code/combat/armor-warhead-manager.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion


--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        DEFENSEOBJECTDEF_CHUNK_VARIABLES            = enumBuilder:Set( 7311607 ),

        DEFENSEOBJECTDEF_VARIABLE_HEALTH            = enumBuilder:Set( 0x00 ),
        DEFENSEOBJECTDEF_VARIABLE_HEALTHMAX         = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SKIN              = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTH    = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTHMAX = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SHIELDTYPE        = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_DAMAGE_POINTS     = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_DEATH_POINTS      = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class DefenseObjectDefinitionClass

    --- Creates a new DefenseObjectDefinitionInstance
    --- @return DefenseObjectDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DefenseObjectDefinition")
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) DefenseObjectDefinitionInstance, `false` otherwise
    function STATIC.IsDefenseDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDefenseDefinition and true or false
    end

    typecheck.RegisterType( "DefenseObjectDefinitionInstance", STATIC.IsDefenseDefinition )
end

--- > "  
--- > This class is meant to be a component of a definition class for a game or physics
--- > object which contains a [Defense].  Use the associated macro to make all of
--- > the member variables editable in your class.  
--- > "
--- @class DefenseObjectDefinitionInstance
--- @field Health number
--- @field HealthMax number
--- @field Skin ArmorType
--- @field ShieldStrength number
--- @field ShieldStrengthMax number
--- @field ShieldType ArmorType
--- @field DamagePoints number
--- @field DeathPoints number

--- Constructs a new DefenseObjectDefinitionInstance
--- @vararg any
function INSTANCE:Renegade_DefenseObjectDefinition()
    self.Health = 100.0
    self.HealthMax = 100.0
    self.Skin = 0
    self.ShieldStrength = 0
    self.ShieldStrengthMax = 0
    self.ShieldType = 0
    self.DamagePoints = 0
    self.DeathPoints = 0
end

--- @param csave ChunkSaveInstance
function INSTANCE:Save( csave )
    typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )
    local ids = STATIC.ChunkIds

    --- @class DefenseObjectDefinitionLoadReadIds
    --- @field SkinSaveId integer
    --- @field ShieldSaveId integer
    local readIds = {}

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.DEFENSEOBJECTDEF_CHUNK_VARIABLES then
            while cload:OpenMicroChunk() do
                chunkIOClass.ReadSafeMicroChunk( cload, ids.DEFENSEOBJECTDEF_VARIABLE_HEALTH,            fundamentalDataTypeEnum.Float,    self,       "Health" )
                chunkIOClass.ReadSafeMicroChunk( cload, ids.DEFENSEOBJECTDEF_VARIABLE_HEALTHMAX,         fundamentalDataTypeEnum.Float,    self,       "HealthMax" )
                chunkIOClass.ReadMicroChunk(     cload, ids.DEFENSEOBJECTDEF_VARIABLE_SKIN,              fundamentalDataTypeEnum.Int,      readIds,    "SkinSaveId" )
                chunkIOClass.ReadSafeMicroChunk( cload, ids.DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTH,    fundamentalDataTypeEnum.Float,    self,       "ShieldStrength" )
                chunkIOClass.ReadSafeMicroChunk( cload, ids.DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTHMAX, fundamentalDataTypeEnum.Float,    self,       "ShieldStrengthMax" )
                chunkIOClass.ReadMicroChunk(     cload, ids.DEFENSEOBJECTDEF_VARIABLE_SHIELDTYPE,        fundamentalDataTypeEnum.Int,      readIds,    "ShieldSaveId" )
                chunkIOClass.ReadSafeMicroChunk( cload, ids.DEFENSEOBJECTDEF_VARIABLE_DAMAGE_POINTS,     fundamentalDataTypeEnum.Float,    self,       "DamagePoints" )
                chunkIOClass.ReadSafeMicroChunk( cload, ids.DEFENSEOBJECTDEF_VARIABLE_DEATH_POINTS,      fundamentalDataTypeEnum.Float,    self,       "DeathPoints" )

                cload:CloseMicroChunk()
            end
        else
            section.Print( "Unrecognized " .. INSTANCE.Class .. " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    -- Omitted ArmorWarheadManagerClass armor
    self.Skin       = armorWarheadManagerClass.FindArmorSaveId( readIds.SkinSaveId )
    self.ShieldType = armorWarheadManagerClass.FindArmorSaveId( readIds.ShieldSaveId )

    return true
end
