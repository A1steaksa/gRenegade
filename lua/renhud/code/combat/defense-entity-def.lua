-- Based on DefenseObjectDefClass within Code/Combat/damage.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DefenseEntityDefClass
--- @field instance DefenseEntityDefInstance The metatable used by DefenseEntityDefInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "DefenseDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class DefenseEntityDefInstance
--- @field Static DefenseEntityDefClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DefenseEntityDefClass" )
INSTANCE.Class = "DefenseDefInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDefenseDef = true


--#region Exported Enums
--#endregion


--#region Imports

    --- @type ArmorWarheadManagerClass
    local armorWarheadManagerClass = CNC.Import( "renhud/code/combat/armor-warhead-manager.lua" )

    --- @type PersistClass
    local persistClass = CNC.Import( "renhud/code/wwsaveload/persist.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum.lua" )
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        DEFENSEOBJECTDEF_CHUNK_VARIABLES                    = enumBuilder:Set( 7311607 ),

        DEFENSEOBJECTDEF_VARIABLE_HEALTH                    = enumBuilder:Set( 0x00 ),
        DEFENSEOBJECTDEF_VARIABLE_HEALTHMAX                 = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SKIN                      = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTH            = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTHMAX         = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_SHIELDTYPE                = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_DAMAGE_POINTS             = enumBuilder:Next(),
        DEFENSEOBJECTDEF_VARIABLE_DEATH_POINTS              = enumBuilder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class DefenseEntityDefClass

    --- Creates a new DefenseEntityDefInstance
    --- @return DefenseEntityDefInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DefenseDef")
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) DefenseEntityDefInstance, `false` otherwise
    function STATIC.IsDefenseDef( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDefenseDef and true or false
    end

    typecheck.RegisterType( "DefenseEntityDefInstance", STATIC.IsDefenseDef )
end

--- > "  
--- > This class is meant to be a component of a definition class for a game or physics
--- > object which contains a [Defense].  Use the associated macro to make all of
--- > the member variables editable in your class.  
--- > "
--- @class DefenseEntityDefInstance
--- @field Health number
--- @field HealthMax number
--- @field Skin ArmorType
--- @field ShieldStrength number
--- @field ShieldStrengthMax number
--- @field ShieldType ArmorType
--- @field DamagePoints number
--- @field DeathPoints number

--- Constructs a new DefenseEntityDefInstance
--- @vararg any
function INSTANCE:Renegade_DefenseEntityDefClass()
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
    Section.Start( "Loading " .. INSTANCE.Class )

    local ids = STATIC.ChunkIds
    local dataTypeEnum = persistClass.DATA_TYPE
    local persist = persistClass.Instance

    --- @class DefenseEntityDefLoadReadIds
    --- @field SkinSaveId integer
    --- @field ShieldSaveId integer
    local readIds = {}

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.DEFENSEOBJECTDEF_CHUNK_VARIABLES then
            Section.Start( INSTANCE.Class .. " Variables Start" )

            while cload:OpenMicroChunk() do
                persist.ReadSafeMicroChunk( self, cload, ids.DEFENSEOBJECTDEF_VARIABLE_HEALTH, dataTypeEnum.Float, "Health" )
                persist.ReadSafeMicroChunk( self, cload, ids.DEFENSEOBJECTDEF_VARIABLE_HEALTHMAX, dataTypeEnum.Float, "HealthMax" )
                persist.ReadMicroChunk( self, cload, ids.DEFENSEOBJECTDEF_VARIABLE_SKIN, dataTypeEnum.Int, readIds, "SkinSaveId" )
                persist.ReadSafeMicroChunk( self, cload, ids.DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTH, dataTypeEnum.Float, "ShieldStrength" )
                persist.ReadSafeMicroChunk( self, cload, ids.DEFENSEOBJECTDEF_VARIABLE_SHIELDSTRENGTHMAX, dataTypeEnum.Float, "ShieldStrengthMax" )
                persist.ReadMicroChunk( self, cload, ids.DEFENSEOBJECTDEF_VARIABLE_SHIELDTYPE, dataTypeEnum.Int, readIds, "ShieldSaveId" )
                persist.ReadSafeMicroChunk( self, cload, ids.DEFENSEOBJECTDEF_VARIABLE_DAMAGE_POINTS, dataTypeEnum.Float, "DamagePoints" )
                persist.ReadSafeMicroChunk( self, cload, ids.DEFENSEOBJECTDEF_VARIABLE_DEATH_POINTS, dataTypeEnum.Float, "DeathPoints" )

                cload:CloseMicroChunk()
            end

            Section.End()
        else
            Section.Print( "Unrecognized " .. INSTANCE.Class .. " Chunk ID", cload:CurChunkId() )
        end

        Section.End()

        cload:CloseChunk()
    end

    -- Omitted ArmorWarheadManagerClass armor
    -- self.Skin = armorWarheadManagerClass.FindArmorSaveId( readIds.SkinSaveId )
    -- self.ShieldType = armorWarheadManagerClass.FindArmorSaveId( readIds.ShieldSaveId )

    return true
end
