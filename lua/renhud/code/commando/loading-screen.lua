-- Based on LoadingScreenClass within Code/Commando/combatgmode.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class LoadingScreenClass
--- @field instance LoadingScreenInstance The metatable used by LoadingScreenInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "LoadingScreenClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class LoadingScreenInstance
--- @field Static LoadingScreenClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_LoadingScreen" )
INSTANCE.Class = "LoadingScreenInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsLoadingScreen = true


--#region Exported Enums
--#endregion


--#region Imports

    --- @type MenuBackdropClass
    local menuBackdropClass = CNC.Import( "renhud/code/wwui/menu-backdrop.lua" )

    --- @type CombatManagerClass
    local combatManagerclass = CNC.Import( "renhud/code/combat/combat-manager.lua" )

    --- @type CampaignManagerClass
    local campaignManagerClass = CNC.Import( "renhud/code/commando/campaign.lua" )

    --- @type StyleManagerClass
    local styleManagerClass = CNC.Import( "renhud/code/wwui/style-manager.lua" )

    --- @type Render2dTextClass
    local render2dTextClass = CNC.Import( "renhud/code/ww3d2/render-2d-text.lua" )
--#endregion


--#region Imported Enums

    local fontStyleEnum = styleManagerClass.FONT_STYLE
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class LoadingScreenClass

    --- This is a magic number unexplained in the original code
    local total = 18

    STATIC.PredictedPercentages = {
        [0] =  0.1 / total,
        [1] =  0.2 / total,
        [2] =  0.3 / total,
        [3] =  0.7 / total,
        [4] =  3.8 / total,
        [5] = 15.5 / total,
        [6] = 17.6 / total,
    }


    --- Creates a new LoadingScreenInstance
    --- @return LoadingScreenInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_LoadingScreen" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) LoadingScreenInstance, `false` otherwise
    function STATIC.IsLoadingScreen( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsLoadingScreen and true or false
    end

    typecheck.RegisterType( "LoadingScreenInstance", STATIC.IsLoadingScreen )
    
end


--- @class LoadingScreenInstance
--- @field Backdrop MenuBackdropInstance
--- @field BackdropText Render2dTextInstance
--- @field BackdropText2 Render2dTextInstance "The BIG text"
--- @field LoadTime number
--- @field LoadPercentage number
--- @field LoadPercentageDrawn number
--- @field LoadPercentageClamp number
--- @field LoadPercentageRate number

--- Constructs a new LoadingScreenInstance
function INSTANCE:Renegade_LoadingScreen()
    local color = Color( 255, 255, 255, 255 )

    -- Omitted backdrop text texture size hint

    self.LoadTime            = 0.001
    self.LoadPercentage      = 0
    self.LoadPercentageDrawn = 0
    self.LoadPercentageRate  = 0

    self.Backdrop = menuBackdropClass.New()

    local font = styleManagerClass.PeekFont( fontStyleEnum.IngameTxt )
    if not font then Section.Error( "Unable to retrieve loading screen font" ) end
    --- @cast font Font3dInstance
    self.BackdropText  = render2dTextClass.New( font )

    font = styleManagerClass.PeekFont( fontStyleEnum.IngameBigTxt )
    if not font then Section.Error( "Unable to retrieve loading screen font" ) end
    --- @cast font Font3dInstance
    self.BackdropText2 = render2dTextClass.New( font )

    Section.Start( "Parsing loading screen description" )

    -- "Parse Descriptions"
    local count = campaignManagerClass.GetBackdropDescriptionCount()

    Section.Print( "Backdrop Description Count: ", count )

    -- Omitted most of the code
    Section.Print( "Loading screen unfinished" )

    for i = 0, count do
        local read = campaignManagerClass.GetBackdropDescription( i ) or ""

        local description = read:Trim()
        local lowerDescription = description:lower()

        Section.Print( "'", description, "'" )

        -- "Parse Big Translated Text"
        if lowerDescription == "text2" then
            description = description:Right( string.len( description ) - 5 )
            Section.Print( "Was text2: '", description, "'" )
        end




















    end

    Section.End()

    -- Omitted resetting saveloadstatus status count
end

--- @param state integer The stage of the loading process from `0` through `6`
--- @return number # A percentage from `0` through `1` 
function INSTANCE:GetPredictedPercentage( state )
    local result = STATIC.PredictedPercentages[ state ]

    if not result then
        return 1
    end

    return result
end

--- @param updateNetwork boolean? [Default: `false`]
function INSTANCE:Render( updateNetwork )
    if updateNetwork == nil then updateNetwork = false end

    local frameTime = FrameTime()

    self.LoadTime = self.LoadTime + frameTime

    -- Omitting begin render

    self.Backdrop:Render()
    self.BackdropText:Render()
    self.BackdropText2:Render()

    STATIC.LastCount = STATIC.LastCount or -1
    STATIC.LastPercentDrawn = STATIC.LastPercentDrawn or -1
    if STATIC.LastCount ~= combatManagerclass.GetLoadProgress() then
        STATIC.LastCount = combatManagerclass.GetLoadProgress()
        self.LoadPercentage = self:GetPredictedPercentage( STATIC.LastCount )
        self.LoadPercentageRate = self.LoadPercentage / self.LoadTime
        self.LoadPercentageClamp = self:GetPredictedPercentage( STATIC.LastCount + 1 )
    end

    self.LoadPercentage = self.LoadPercentage + self.LoadPercentageRate * frameTime
    self.LoadPercentage = math.Clamp( self.LoadPercentage, 0, self.LoadPercentageClamp )
    self.LoadPercentageDrawn = self.LoadPercentageDrawn + ( self.LoadPercentage - self.LoadPercentageDrawn ) * 0.1
    self.Backdrop:SetAnimationPercentage( self.LoadPercentageDrawn )
    if SERVER and STATIC.LastPercentDrawn ~= self.LoadPercentageDrawn then
        STATIC.LastPercentDrawn = self.LoadPercentageDrawn
        Section.Print( string.format( "Load %d%% complete", self.LoadPercentageDrawn * 100 ) )
    end

    -- Omitting end render
end