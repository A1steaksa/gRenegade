-- Based on StyleMgrClass within Code/wwui/stylemgr.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class StyleManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "StyleManagerClass"
local isHotload = not table.IsEmpty( STATIC )

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum FontStyle
    STATIC.FONT_STYLE = {
        Title             = enumBuilder:Set( 0 ),
        LgControls        = enumBuilder:Next(),
        Controls          = enumBuilder:Next(),
        Lists             = enumBuilder:Next(),
        Tooltips          = enumBuilder:Next(),
        Menu              = enumBuilder:Next(),
        SmMenu            = enumBuilder:Next(),
        Header            = enumBuilder:Next(),
        BigHeader         = enumBuilder:Next(),
        Credits           = enumBuilder:Next(),
        CreditsBold       = enumBuilder:Next(),
        IngameTxt         = enumBuilder:Next(),
        IngameBigTxt      = enumBuilder:Next(),
        IngameSubtitleTxt = enumBuilder:Next(),
        IngameHeaderTxt   = enumBuilder:Next(),
    }
    local fontStyleEnum = STATIC.FONT_STYLE

    --- @enum Justification
    STATIC.JUSTIFICATION = {
        Left    = enumBuilder:Set( 0 ),
        Right   = enumBuilder:Next(),
        Center  = enumBuilder:Next(),
    }
    local justificationEnum = STATIC.JUSTIFICATION

    --- @enum EventAudio
    STATIC.EVENT_AUDIO = {
        MouseClick = enumBuilder:Set( 0 ),
        MouseOver  = enumBuilder:Next(),
        MenuBack   = enumBuilder:Next(),
        Popup      = enumBuilder:Next(),
        AudioMax   = enumBuilder:Next(),
    }
    local eventAudioEnum = STATIC.EVENT_AUDIO
--#endregion


--#region Imports

    --- @type IniClass
    local iniClass = CNC.Import( "code/wwlib/ini.lua" )

    --- @type Render2dClass
    local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )

    --- @type FontsLib
    local fontsLib = CNC.Import( "client/cl_fonts.lua" )

    --- @type FileFactoryClass
    local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )
--#endregion


--[[ Default Fonts ]] do

    --- @class FontDescription
    --- @field Name string
    --- @field PointSize integer
    --- @field InterCharSpacing integer
    --- @field IsBold boolean

    --- The amount to multiply Renegade font point sizes by to convert them to the same visual size in Garry's Mod
    --- This value was determined by experimentation and is not yet understood.
    STATIC.FontSizeMultipler = 1.75

    --- How many extra pixels of space to border each character on font atlases with 
    STATIC.DefaultInterCharSpacing = 2
end


--- @class StyleManagerClass
--- @field private BackdropMaterial IMaterial
--- @field private TitleColor Color
--- @field private TitleHilightColor Color
--- @field private TitleShadowColor Color
--- @field private TextColor Color
--- @field private TextShadowColor Color
--- @field private LineColor Color
--- @field private BkColor Color
--- @field private DisabledTextColor Color
--- @field private DisabledTextShadowColor Color
--- @field private DisabledLineColor Color
--- @field private DisabledBkColor Color
--- @field private HilightColor Color
--- @field private TabTextColor Color
--- @field private TabGlowColor Color
--- @field private ScaleX number
--- @field private ScaleY number
--- @field private FontFileList string[]
--- @field private EventAudioList string[]

--- @private
--- A map of FONT_STYLE to its matching Font3dInstance
--- @type table<FontStyle, Font3dInstance>
STATIC.Fonts = {}

STATIC.FONT_FILE_SECTION = "Font File List"
STATIC.FONT_NAME_SECTION = "Font Names"
STATIC.FONT_INI_ENTRIES = {
    "FONT_TITLE",
    "FONT_LG_CONTROLS",
    "FONT_CONTROLS",
    "FONT_LISTS",
    "FONT_TOOLTIPS",
    "FONT_MENU",
    "FONT_SM_MENU",
    "FONT_HEADER",
    "FONT_BIG_HEADER",
    "FONT_CREDITS",
    "FONT_CREDITS_BOLD",
    "FONT_INGAME_TXT",
    "FONT_INGAME_BIG_TXT",
    "FONT_INGAME_SUBTITLE_TXT",
    "FONT_INGAME_HEADER_TXT"
}

--[[ Initialization ]] do

    function STATIC.Initialize()
        -- This is never used in the original code
        typecheck.NotImplementedError()
    end

    --- @param fileName string
    function STATIC.InitializeFromIni( fileName )
        -- Omitted shutdown

        -- "Compute the scale"
        local screenResolution = render2dClass.GetScreenResolution()
        STATIC.ScaleX = screenResolution:Width() / 800.0
        STATIC.ScaleY = screenResolution:Height() / 600

        -- "Get the INI file"
        --- @type IniInstance
        local iniFile
        local fileObject = fileFactoryClass.TheFileFactory:GetFile( fileName )
        if fileObject ~= nil and fileObject:IsAvailable() then
            iniFile = iniClass.New( fileObject )
            fileFactoryClass.TheFileFactory:ReturnFile( fileObject )
        end

        if iniFile == nil then
            section.Error( "Unable to create ini loader for file: '", fileName, "'" )
            return
        end

        -- Omitted loading fonts into Windows

        -- "Read information about each font and load it into the system"
        local count = table.Count( STATIC.FONT_STYLE )
        for index = 1, count do
            -- "Read information about this font"
            local fontEntry = iniFile:GetString( STATIC.FONT_NAME_SECTION, STATIC.FONT_INI_ENTRIES[index] )

            -- "Parse the information"
            local splitEntry = fontEntry:Split( "," ) --[[@as string[] ]]
            local fontName = splitEntry[1]:Trim()
            local fontSize = splitEntry[2]:Trim()
            local fontBold = splitEntry[3]:Trim()

            local isBold = ( fontBold == "1" )

            -- "Scale the point size to fit this resolution"
            local pointSize = math.floor( tonumber( fontSize ) * STATIC.FontSizeMultipler ) --[[@as number]] -- * STATIC.ScaleY

            -- "Remove bold from "small" fonts if they're scaled down"
            pointSize = math.max( pointSize, 8.0 )
            if pointSize < 10.0 and STATIC.ScaleY < 1.0 then
                isBold = false
            end

            STATIC.Fonts[index - 1] = fontsLib.GetOrCreateFontAtlas(
                fontName,
                pointSize,
                isBold,
                STATIC.DefaultInterCharSpacing
            )
        end
    end
end


--[[ Font methods ]] do

    --- @param style FontStyle
    --- @return FontCharsInstance
    function STATIC.GetFont( style )
        -- Barely used in the original code
        typecheck.NotImplementedError()
    end

    --- @param style FontStyle
    --- @return Font3dInstance?
    function STATIC.PeekFont( style )
        -- Pull the font from the cache
        local cachedFont = STATIC.Fonts[ style ]

        -- If this font isn't already cached, cache it
        if not cachedFont then
            local font = STATIC.Fonts[ style ]
            if not font then
                section.Error( "Could not peek font that does not exist: ", style )
            end
            STATIC.Fonts[ style ] = font
            cachedFont = STATIC.Fonts[ style ]
        end

        return cachedFont
    end

    --- @param renderer Render2dTextInstance
    --- @param style FontStyle
    function STATIC.AssignFont( renderer, style )
        typecheck.NotImplementedError()
    end
end


--[[ Sound methods ]] do

    --- @param event EventAudio
    function STATIC.PlaySound( event )
        typecheck.NotImplementedError()
    end
end


--[[ Configuration methods ]] do

    --- @param renderer Render2dTextInstance
    function STATIC.ConfigureRenderer( renderer )
        typecheck.NotImplementedError()
    end
end


--[[ Scale support ]] do

    --- @return number
    function STATIC.GetXScale()
        return STATIC.ScaleX
    end

    --- @return number
    function STATIC.GetYScale()
        return STATIC.ScaleY
    end
end


--[[ Color methods ]] do

    --- @return Color
    function STATIC.GetTextColor()
        return STATIC.TextColor
    end

    --- @return Color
    function STATIC.GetTextShadowColor()
        return STATIC.TextShadowColor
    end

    --- @return Color
    function STATIC.GetDisabledTextColor()
        return STATIC.DisabledTextColor
    end

    --- @return Color
    function STATIC.GetDisabledTextShadowColor()
        return STATIC.DisabledTextShadowColor
    end

    --- @return Color
    function STATIC.GetLineColor()
        return STATIC.LineColor
    end

    --- @return Color
    function STATIC.GetBkColor()
        return STATIC.BkColor
    end

    --- @return Color
    function STATIC.GetDisabledLineColor()
        return STATIC.DisabledLineColor
    end

    --- @return Color
    function STATIC.GetDisabledBkColor()
        return STATIC.DisabledBkColor
    end

    --- @return Color
    function STATIC.GetTabTextColor()
        return STATIC.TabTextColor
    end

    --- @return Color
    function STATIC.GetTabGlowColor()
        return STATIC.TabGlowColor
    end
end


--[[ Backdrop support ]] do

    --- @param renderer Render2dTextInstance
    --- @param rect RectInstance
    function STATIC.RenderBackdrop( renderer, rect )
        typecheck.NotImplementedError()
    end
end


--[[ Text support ]] do

    --- @overload fun( text: string, renderer:Render2dTextInstance, textColor: Color, shadowColor: Color, rect: RectInstance, doShadow: boolean?, doClip: boolean, justify: Justification?, isVCentered: boolean? )
    --- @overload fun( text: string, renderer:Render2dTextInstance, rect:RectInstance, doShadow: boolean?, doClip: boolean?, justify: Justification?, isEnabled:boolean?, isVCentered: boolean? )
    function STATIC.RenderText( ... )
        local args = { ... }
        local argCount = select( "#", ... )

        typecheck.NotImplementedError()
    end

    --- @param text string
    --- @param renderer Render2dTextInstance
    --- @param rect RectInstance
    function STATIC.RenderTitleText( text, renderer, rect )
        typecheck.NotImplementedError()
    end

    --- @overload fun( text: string, renderer: Render2dTextInstance, textColor: Color, shadowColor: Color, rect: RectInstance, doShadow: boolean?, doVCenter: boolean? )
    --- @overload fun( text: string, renderer: Render2dTextInstance, rect: RectInstance, doShadow: boolean?, doVCenter: boolean?, isEnabled: boolean? )
    function STATIC.RenderWrappedText( ... )
        local args = { ... }
        local argCount = select( "#", ... )

        typecheck.NotImplementedError()
    end

    --- @overload fun( text: string, renderer: Render2dTextInstance, rect: RectInstance, doShadow: boolean?, doVCenter: boolean?, isEnabled:boolean?, justify: Justification? )
    --- @overload fun( text: string, renderer: Render2dTextInstance, textColor: Color, shadowColor: Color, rect: RectInstance, doShadow: boolean?, doVCenter: boolean?, justify: Justification? )
    function STATIC.RenderWrappedTextEx( ... )
        local args = { ... }
        local argCount = select( "#", ... )

        typecheck.NotImplementedError()
    end
end


--[[ Hilight support ]] do

    --- @param renderer Render2dTextInstance
    function STATIC.ConfigureHilighter( renderer )
        typecheck.NotImplementedError()
    end

    --- @param renderer Render2dTextInstance
    --- @param rect RectInstance
    function STATIC.RenderHilight( renderer, rect )
        typecheck.NotImplementedError()
    end
end


--[[ Text "glow" support ]] do

    --- @param text string
    --- @param renderer Render2dTextInstance
    --- @param rect RectInstance
    --- @param radiusX integer
    --- @param radiusY integer
    --- @param color Color
    --- @param justify Justification
    function STATIC.RenderGlow( text, renderer, rect, radiusX, radiusY, color, justify )
        typecheck.NotImplementedError()
    end
end
