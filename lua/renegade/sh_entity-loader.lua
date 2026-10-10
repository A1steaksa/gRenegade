-- This library registers Entities based on Renegade definition IDs

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class EntityLoader
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "EntityLoader"

--- @class DefaultRenegadeEntityDefinition
--- @field PrintName string
--- @field ClassName string
--- @field DefinitionId integer

--- The Renegade definition IDs that will have an Entity registered for them automatically
--- @type DefaultRenegadeEntityDefinition[]
STATIC.DefaultEntityDefinitions = {
    -- Health
    { PrintName = "Large Health Kit",  ClassName = "p_health3", DefinitionId = 1663 },
    { PrintName = "Medium Health Kit", ClassName = "p_health2", DefinitionId = 1667 },
    { PrintName = "Box of Bandages",   ClassName = "p_health1", DefinitionId = 1665 },

    -- Armor
    { PrintName = "Large Armor",  ClassName = "p_armor3", DefinitionId = 3669 },
    { PrintName = "Medium Armor", ClassName = "p_armor2", DefinitionId = 3666 },
    { PrintName = "Small Armor",  ClassName = "p_armor1", DefinitionId = 3663 },

    -- Keycards
    { PrintName = "Level 1 Keycard", ClassName = "p_key1", DefinitionId = 81950037 },
    { PrintName = "Level 2 Keycard", ClassName = "p_key2", DefinitionId = 81950038 },
    { PrintName = "Level 3 Keycard", ClassName = "p_key3", DefinitionId = 81950039 },

    -- Special
    -- { PrintName = "Data Disc", ClassName = "p_disc", DefinitionId = 81950099 }, -- Requires some kind of special vertex material mapper
}

--- @param printName string
--- @param className string
--- @param definitionId integer
function STATIC.RegisterEntity( printName, className, definitionId )
    local ENT = {}
    ENT.Base = "ren_base"
    ENT.PrintName = printName
    ENT.Category = "C&C Renegade"
    ENT.Spawnable = true

    ENT.DefinitionId = definitionId

    scripted_ents.Register( ENT, className )
end

function STATIC.RegisterDefaultEntities()
    for _, definition in ipairs( STATIC.DefaultEntityDefinitions ) do
        STATIC.RegisterEntity( definition.PrintName, definition.ClassName, definition.DefinitionId )
    end
    if CLIENT then
        RunConsoleCommand( "spawnmenu_reload" )
    end
end

hook.Add( "Renegade_PostGameInit", "A1_Renegade_SetupEntities", STATIC.RegisterDefaultEntities )
if isHotload then STATIC.RegisterDefaultEntities() end