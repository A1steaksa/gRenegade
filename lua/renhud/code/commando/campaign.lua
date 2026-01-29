-- Based on CampaignManager within Code/Commando/campaign.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class CampaignManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "CampaignManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums
--#endregion


--#region Imports

    --- @type GodClass
    local godClass = CNC.Import( "renhud/code/commando/god.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "renhud/code/combat/combat-manager.lua" )

    --- @type RenegadeDialogManagerClass
    local renegadeDialogManagerClass = CNC.Import( "renhud/code/commando/renegade-dialog-manager.lua" )

    --- @type AssetsClass
    local assetsClass = CNC.Import( "renhud/code/combat/assets.lua" )

    --- @type BackdropDescriptionClass
    local backdropDescriptionClass = CNC.Import( "renhud/code/commando/backdrop-description.lua" )
--#endregion


--#region Imported Enums

    local locationEnum = renegadeDialogManagerClass.LOCATION
--#endregion


--- "  
--- CampaignManager is responsible for controlling the flow of missions and sub-states through the playing of a campaign.  
--- It is also the main entry point for single mission, and multi-play sessions.
--- "  
--- @class CampaignManagerClass
--- @field private State integer
--- @field private BackdropIndex integer

--- @type BackdropDescriptionInstance[]
STATIC.BackdropDescriptions = {}

STATIC.State = 0
STATIC.BackdropIndex = 0

STATIC.CAMPAIGN_INI_FILENAME = "data/renegade/always_dat/campaign.ini.txt"
STATIC.SECTION_CAMPAIGN      = "Campaign"
STATIC.NOT_IN_CAMPAIGN_STATE = -10
STATIC.REPLAY_LEVEL          = -11
STATIC.REPLAY_SCORE          = -12

--- @type string[]
STATIC.CampaignFlowDescriptions = {}

function STATIC.Init()
    STATIC.State = STATIC.NOT_IN_CAMPAIGN_STATE
    STATIC.BackdropIndex = 0

    -- "Load CAMPAIGN.INI to get campain flow"
    local campaignIni = assetsClass.GetIni( STATIC.CAMPAIGN_INI_FILENAME )
    if not campaignIni then
        Section.Error( "CampaignManagerClass.Init - Unable to load '", STATIC.CAMPAIGN_INI_FILENAME, "'" )
    end

    Section.Start( "Loading Campaign Flow" )
    local count = campaignIni:EntryCount( STATIC.SECTION_CAMPAIGN )
    for entry = 0, count do
        local entryName = campaignIni:GetEntry( STATIC.SECTION_CAMPAIGN, entry )
        if not entryName then continue end

        local description = campaignIni:GetString( STATIC.SECTION_CAMPAIGN, entryName )
        STATIC.CampaignFlowDescriptions[#STATIC.CampaignFlowDescriptions + 1] = description

        Section.Print( entry, ": ", description )
    end
    Section.End()

    -- "Load Backdrop Descriptions"
    -- "Load the first 100, because 90-95 are multiplay.. :)"
    Section.Start( "Loading Backdrop Descriptions" )
    for state = 0, 100 do
        local sectionName = string.format( "Backdrop%d", state )
        local count = campaignIni:EntryCount( sectionName )
        if count == 0 then continue end

        Section.Start( "Section: ", sectionName )

        local index = #STATIC.BackdropDescriptions
        local backdropDescription = backdropDescriptionClass.New()
        STATIC.BackdropDescriptions[index] = backdropDescription
        backdropDescription.State = state

        for entry = 0, count do
            local entryName = campaignIni:GetEntry( sectionName, entry )
            if not entryName then continue end

            local description = campaignIni:GetString( sectionName, entryName )
            backdropDescription.Lines[#backdropDescription.Lines + 1] = description

            Section.Print( description )
        end

        Section.End( "Loaded ", #backdropDescription.Lines, " lines" )
    end
    Section.End()
end

function STATIC.Shutdown()
    table.Empty( STATIC.CampaignFlowDescriptions )
end

--- @param csave ChunkSaveInstance
--- @return boolean
function STATIC.Save( csave )
    typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function STATIC.Load( cload )
    typecheck.NotImplementedError()
end

--- @param difficulty integer
function STATIC.StartCampoaign( difficulty )
    STATIC.State = -1
    STATIC.BackdropIndex = 0

    -- "Why was this commented out???"
    combatManagerClass.SetDifficultyLevel( difficulty )

    local diffString = string.format( "difficulty %d", difficulty )
    -- Omitted setting diffulty with console function manager

    godClass.ResetInventory()

    STATIC.Continue()
end

--- @param success boolean? [Default: `true`]
function STATIC.Continue( success )
    if success == nil then success = true end

    STATIC.BackdropIndex = 0

    if STATIC.State == STATIC.REPLAY_LEVEL then
        typecheck.NotImplementedError()
    end

    if (
        STATIC.State == STATIC.NOT_IN_CAMPAIGN_STATE
        or STATIC.State == STATIC.REPLAY_SCORE
        or ( STATIC.State >= #STATIC.CampaignFlowDescriptions - 1 )
    ) then
        typecheck.NotImplementedError()
    end

    STATIC.State = STATIC.State + 1

    local stateDescription = STATIC.CampaignFlowDescriptions[STATIC.State]

    if stateDescription:StartsWith( "Message " ) then
        typecheck.NotImplementedError()
    elseif stateDescription:StartsWith( "Score" ) then
        typecheck.NotImplementedError()
    elseif stateDescription:StartsWith( "Level " ) then
        typecheck.NotImplementedError()
    elseif stateDescription:StartsWith( "Movie " ) then
        typecheck.NotImplementedError()
    else
        Section.Error( "Failed to parse campaign description: ", stateDescription )
        STATIC.State = STATIC.NOT_IN_CAMPAIGN_STATE
        renegadeDialogManagerClass.GotoLocation( locationEnum.LOC_MAIN_MENU )
    end

end

function STATIC.Reset()
    STATIC.State = STATIC.NOT_IN_CAMPAIGN_STATE
end

--- @return integer
function STATIC.GetBackdropDescriptionCount()
    if table.Count( STATIC.BackdropDescriptions ) > 0 then
        return table.Count( STATIC.BackdropDescriptions[STATIC.BackdropIndex].Lines )
    end

    return 0
end

--- @param index integer
--- @return string
function STATIC.GetBackdropDescription( index )
    local backdropDescription = STATIC.BackdropDescriptions[STATIC.BackdropIndex]
    return backdropDescription.Lines[index]
end

--- @param stateNumber integer
function STATIC.SelectBackdropNumber( stateNumber )
    typecheck.NotImplementedError()
end

--- @param type integer
function STATIC.SelectBackdropNumberByMpType( type )
    typecheck.NotImplementedError()
end

--- @param missionName string
--- @param difficulty integer
function STATIC.ReplayLevel( missionName, difficulty )
    typecheck.NotImplementedError()
end