-- Based on ObjectiveManager in Code/Combat/objectives.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ObjectiveManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "ObjectiveManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums

    --- @enum ObjectiveType
    STATIC.OBJECTIVE_TYPE = {
        Primary    = 1, -- Code in code/combat/objective.lua relies on this specific value
        Secondary  = 2,
        Tertiary   = 3
    }
    local objectiveTypeEnum = STATIC.OBJECTIVE_TYPE

    --- @enum ObjectiveStatus
    STATIC.OBJECTIVE_STATUS = {
        IsPending    = 0,
        Accomplished = 1,
        Failed       = 2,
        Hidden       = 3
    }
    local objectiveStatusEnum = STATIC.OBJECTIVE_STATUS
--#endregion


--#region Imports

    --- @type ObjectiveClass
    local objectiveClass = CNC.Import( "renhud/code/combat/objective.lua" )

    --- @type TranslateDbClass
    local translateDbClass = CNC.Import( "renhud/code/wwtranslatedb/translatedb.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "renhud/code/combat/combat-manager.lua" )

    --- @type HudClass
    local hudClass = CNC.Import( "renhud/code/combat/hud.lua" )
--#endregion


--- @class ObjectiveManagerClass
--- @field protected ObjectiveList ObjectiveInstance[]
--- @field private Viewer ObjectiveViewer
--- @field private HudUpdate boolean
--- @field private NumSpecifiedTertiaryObjectives integer

function STATIC.Init()
    --STATIC.Viewer:Initialize()
    STATIC.HudUpdate = true
    STATIC.NumSpecifiedTertiaryObjectives = 0
end

function STATIC.Shutdown()
    --STATIC.Viewer:Shutdown()
    STATIC.Reset()
end

function STATIC.Reset()
    STATIC.HudUpdate = true
    STATIC.ObjectiveList = {}
end

--- @param deltaTime number
function STATIC.Update( deltaTime )
    local objectiveList = STATIC.ObjectiveList
    for i = 1, #objectiveList do
        local objective = objectiveList[i]
        if ( objective.Status ~= objectiveStatusEnum.Hidden ) then
            objective.Age = objective.Age + deltaTime
        end
    end
end

--- @param id integer
--- @param type ObjectiveType
--- @param status ObjectiveStatus
--- @param shortDescriptionId string|integer
--- @param longDescriptionId string|integer
--- @param descriptionSoundFilename string?
function STATIC.AddObjective( id, type, status, shortDescriptionId, longDescriptionId, descriptionSoundFilename )
    -- Skip duplicate objectives
    if STATIC.FindObjective( id ) then
        Section.Error( "Adding a duplicate objective ID" )
        return
    end

    local objective = STATIC.AddLoadableObjective()
    objective.Id = id
    objective.Type = type
    objective.Status = status
    objective.ShortDescriptionId = shortDescriptionId
    objective.LongDescriptionId = longDescriptionId
    objective.DescriptionSoundFilename = descriptionSoundFilename

    -- "Update our EVA message window"
    if status ~= objectiveStatusEnum.Hidden then
        local description = translateDbClass.GetString( shortDescriptionId )
        local formatString = translateDbClass.GetString( "IDS_OBJ_NEW_OBJ" )

        local message = string.format( formatString, objective:TypeToName(), description )
        -- combatManagerClass.GetMessageWindow():AddMessage( message, objective:TypeToBaseColor() )

        hudClass.AddObjective( type )
    end

    --STATIC.Viewer:Update()
    STATIC.HudUpdate = true
end

--- @param id integer
function STATIC.RemoveObjective( id )
    local objective = STATIC.FindObjective( id )
    if objective then
        local formatString = translateDbClass.GetString( "IDS_OBJ_CANCELLED" )
        local message = string.format( formatString, objective:TypeToName() )
        combatManagerClass:GetMessageWindow():AddMessage( message, objective:TypeToBaseColor() )

        table.RemoveByValue( STATIC.ObjectiveList, objective )
    else
        Section.Error( "Objective not found to delete with ID: ", id )
    end

    --STATIC.Viewer:Update()
    STATIC.HudUpdate = true
end

--- @param id integer
--- @param status ObjectiveStatus
function STATIC.SetObjectiveStatus( id, status )
    local objective = STATIC.FindObjective( id )
    if objective then
        -- Status was hidden and now isn't
        local isUnhiding = ( objective.Status == objectiveStatusEnum.Hidden ) and ( status ~= objectiveStatusEnum.Hidden )

        objective.Status = status

        objective:UpdateEntityBlip()

        if isUnhiding then
            objective.Age = 0 -- "Reset age"
        end

        -- "Special case changing an objective from hidden to pending" 
        -- "(note: for a completed objective, we display the normal message even if it was hidden)."
        local message
        if isUnhiding and status ~= objectiveStatusEnum.Accomplished then
            local description = translateDbClass.GetString( objective.ShortDescriptionId )
            local formatString = translateDbClass.GetString( "IDS_OBJ_NEW_OBJ" )
            message = string.format( formatString, objective:TypeToName(), description )

            hudClass.AddObjective( objective.Type )
        else
            if objective.Status ~= objectiveStatusEnum.Hidden then
                local formatString = translateDbClass.GetString( "IDS_OBJ_STATUS_CHANGED" )
                message = string.format( formatString, objective:TypeToName(), objective:StatusToName() )
            end
        end

        combatManagerClass.GetMessageWindow():AddMessage( message, objective:TypeToBaseColor() )
    else
        Section.Print( "Objective not found to set status" )
    end

    STATIC.SortObjectives()
    --STATIC.Viewer:Update()
    STATIC.HudUpdate = true
end

--- @param id integer
--- @param type ObjectiveType
function STATIC.ChangeObjectiveType( id, type )
    local objective = STATIC.FindObjective( id )
    if objective then
        objective.Type = type
        objective:UpdateEntityBlip()
    else
        Section.Print( "Objective not found to change type" )
    end

    --STATIC.Viewer:Update()
    STATIC.HudUpdate = true
end

--- @param id integer
--- @param ent Entity
--- @overload fun( id: integer, position: Vector )
function STATIC.SetObjectiveRadarBlip( id, ent )
    local pos
    if isvector( ent ) then
        pos = ent --[[@as Vector]]
        ent = NULL
    end

    local objective = STATIC.FindObjective( id )
    if objective then
        objective:SetEntity( ent )

        if pos then
            objective.Position = pos
            objective.DrawBlip = true
        end
    else
        Section.Print( "Objective not found to set radar blip with id: ", id )
    end
end

--- @param id integer
--- @param priority number
--- @param material IMaterial
--- @param messageId integer
--- @param position Vector?
function STATIC.SetObjectiveHudInfo( id, priority, material, messageId, position )
    local objective = STATIC.FindObjective( id )
    if objective then
        objective.HudPriority = priority
        objective.HudPogMaterial = material
        objective.HudMessageStringId = messageId
        if position then
            objective.Position = position
        end

        STATIC.SortObjectives()
        STATIC.HudUpdate = true
    end
end

--- @return integer
function STATIC.GetObjectiveCount()
    local objectiveList = STATIC.ObjectiveList
    if not objectiveList then
        STATIC.ObjectiveList = {}
        return 0
    end

    return #objectiveList
end

--- @param index integer
--- @return ObjectiveInstance?
function STATIC.GetObjective( index )
    local objectiveList = STATIC.ObjectiveList
    if not objectiveList or #objectiveList == 0 then
        STATIC.ObjectiveList = {}
    end

    return STATIC.ObjectiveList[index]
end


--[[ Viewer ]] do

    --- @return boolean
    function STATIC.IsViewerDisplayed()
        --return STATIC.Viewer.IsDisplayed()
        typecheck.NotImplementedError( STATIC.Class )
    end

    --- @param shouldDisplayViewer boolean
    --- @return boolean
    function STATIC.DisplayViewer( shouldDisplayViewer )
        --STATIC.Viewer:Display( shouldDisplayViewer )
        typecheck.NotImplementedError( STATIC.Class )
    end

    function STATIC.PageDownViewer()
        --STATIC.Viewer:PageDown()
        typecheck.NotImplementedError( STATIC.Class )
    end

    function STATIC.RenderViewer()
        --STATIC.Viewer:Render()
        typecheck.NotImplementedError( STATIC.Class )
    end

    function STATIC.ReloadViewer()
        --STATIC.Viewer:Initialize()
        typecheck.NotImplementedError( STATIC.Class )
    end
end


--- @param type ObjectiveType
function STATIC.GetNumObjectives( type )
    local count = 0
    local objectiveList = STATIC.ObjectiveList
    for i = 1, #objectiveList do
        local objective = objectiveList[i]
        if ( objective.Type == type ) and ( objective.Status ~= objectiveStatusEnum.Hidden ) then
            count = count + 1
        end
    end

    if type == objectiveTypeEnum.Tertiary then
        if count < STATIC.NumSpecifiedTertiaryObjectives then
            count = STATIC.NumSpecifiedTertiaryObjectives
        end
    end

    return count
end

--- @param type ObjectiveType
function STATIC.GetNumCompletedObjectives( type )
    local count = 0
    local objectiveList = STATIC.ObjectiveList
    for i = 1, #objectiveList do
        local objective = objectiveList[i]
        if ( objective.Type == type ) and ( objective.Status ~= objectiveStatusEnum.Accomplished ) then
            count = count + 1
        end
    end

    return count
end

--- @param count integer
function STATIC.SetNumSpecifiedTertiaryObjectives( count )
    STATIC.NumSpecifiedTertiaryObjectives = count
end


--[[ HUD Interface ]] do

    --- @return integer
    function STATIC.GetNumHudObjectives()
        -- "Assume the pendings are first, in priority order"
        local count = 0
        local objectiveList = STATIC.ObjectiveList
        for i = 0, #objectiveList do
            local objective = objectiveList[i]
            if ( objective.Status == objectiveStatusEnum.IsPending ) and ( objective.HudPriority > 0 ) then
                count = count + 1
            end
        end

        return count
    end

    --- @param index integer
    --- @return IMaterial
    function STATIC.GetHudObjectivesPogMaterial( index )
        return STATIC.ObjectiveList[index].HudPogMaterial
    end

    --- @param index integer
    --- @return string
    function STATIC.GetHudObjectivesMessage( index )
        local messageId = STATIC.ObjectiveList[index].HudMessageStringId
        return translateDbClass.GetString( messageId )
    end

    --- @param index integer
    --- @return Vector
    function STATIC.GetHudObjectivesLocation( index )
        return STATIC.ObjectiveList[index]:GetPosition()
    end

    --- @param index integer
    --- @return number
    function STATIC.GetHudObjectivesAge( index )
        return STATIC.ObjectiveList[index].Age
    end

    --- @return boolean
    function STATIC.AreHudObjectivesChanged()
        return STATIC.HudUpdate
    end

    function STATIC.ClearHudObjectivesChanged()
        STATIC.HudUpdate = false
    end
end


--- @protected
--- @return ObjectiveInstance
function STATIC.AddLoadableObjective()
    local objective = objectiveClass.New()
    STATIC.ObjectiveList[#STATIC.ObjectiveList + 1] = objective
    return objective
end

--- @protected
--- @param id integer
--- @return ObjectiveInstance?
function STATIC.FindObjective( id )
    local objectiveList = STATIC.ObjectiveList
    for i = 1, #objectiveList do
        local objective = objectiveList[i]
        if objective.Id == id then
            return objective
        end
    end
end

--- @private
--- @param a ObjectiveInstance
--- @param b ObjectiveInstance
--- @return boolean
function STATIC.ObjectiveSortCallback( a, b )
    -- "Sort first on status, low first"
    if a.Status < b.Status then
        return false
    end
    if a.Status > b.Status then
        return true
    end

    -- "Sort next on priority, high first"
    if ( a.HudPriority or 0 ) > ( b.HudPriority or 0 ) then
        return false
    end
    if ( a.HudPriority or 0 ) < ( b.HudPriority or 0 ) then
        return true
    end

    return false -- The original code returns 0 which we can't replicate here
end

--- @private
function STATIC.SortObjectives()
    table.sort( STATIC.ObjectiveList, STATIC.ObjectiveSortCallback )
end