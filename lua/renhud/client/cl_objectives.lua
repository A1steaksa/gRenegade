--- Manages objectives within Garry's Mod for the Renegade HUD

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ObjectivesLib
local LIB = CNC.CreateExport()
LIB.Class = "ObjectivesLib"
local isHotload = not table.IsEmpty( LIB )


--#region Imports

    --- @type ObjectiveManagerClass
    local objectiveManagerClass = CNC.Import( "renhud/client/code/combat/objective-manager.lua" )

    --- @type TranslationLib
    local translationLib = CNC.Import( "renhud/client/cl_translation.lua" )
--#endregion


--#region Imported Enums

    local languageEnum = translationLib.LANGUAGE
    local objTypeEnum = objectiveManagerClass.OBJECTIVE_TYPE
    local objStatusEnum = objectiveManagerClass.OBJECTIVE_STATUS
--#endregion


--[[ Helicopter Test Objective  ]] do

    LIB.NextId = 0

    --- @return integer
    function LIB.GetNextId()
        local id = LIB.NextId
        LIB.NextId = LIB.NextId + 1
        return id
    end

    translationLib.RegisterString( languageEnum.English, "IDS_Enc_ObjTitle_Secondary_M04_03",
        "Destroy Apache"
    )

    translationLib.RegisterString( languageEnum.English, "IDS_Enc_Obj_Secondary_M04_03",
        "A Nod Apache is patrolling the outside of the ship. Locate the Apache and destroy it."
    )

    --- @private
    --- @param ent Entity
    function LIB.EntitySpawned( ent )
        local class = ent:GetClass()
        if class == "npc_helicopter" then

            local id = LIB.GetNextId()

            objectiveManagerClass.AddObjective( id, objTypeEnum.Primary, objStatusEnum.IsPending,
                "IDS_Enc_ObjTitle_Secondary_M04_03",
                "IDS_Enc_Obj_Secondary_M04_03",
                nil
            )
            objectiveManagerClass.SetObjectiveRadarBlip( id, ent )

            ent.ObjectiveId = id
        end
    end
    hook.Add( "OnEntityCreated", "A1_Renegade_ObjectiveLib_EntitySpawned", LIB.EntitySpawned )

    function LIB.EntityRemoved( ent, isFullUpdate )
        local id = ent.ObjectiveId
        if not id then return end

        objectiveManagerClass.SetObjectiveStatus( id, objStatusEnum.Accomplished )
    end
    hook.Add( "EntityRemoved", "A1_Renegade_ObjectiveLib_EntityRemoved", LIB.EntityRemoved )
end
