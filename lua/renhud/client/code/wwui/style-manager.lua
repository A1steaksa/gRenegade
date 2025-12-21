-- Based on StyleMgrClass within Code/wwui/stylemgr.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class StyleManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "StyleManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums

    --- @enum FontStyle
    STATIC.FONT_STYLE = {
        Title             = 0,
        LgControls        = 1,
        Controls          = 2,
        Lists             = 3,
        Tooltips          = 4,
        Menu              = 5,
        SmMenu            = 6,
        Header            = 7,
        BigHeader         = 8,
        Credits           = 9,
        CreditsBold       = 10,
        IngameTxt         = 11,
        IngameBigTxt      = 12,
        IngameSubtitleTxt = 13,
        IngameHeaderTxt   = 14
    }
    local fontStyleEnum = STATIC.FONT_STYLE

    --- @enum Justification
    STATIC.JUSTIFICATION = {
        Left    = 0,
        Right   = 1,
        Center  = 2
    }
    local justificationEnum = STATIC.JUSTIFICATION

    --- @enum EventAudio
    STATIC.EVENT_AUDIO = {
        MouseClick = 0,
        MouseOver  = 1,
        MenuBack   = 2,
        Popup      = 3,
        AudioMax   = 4
    }
    local eventAudioEnum = STATIC.EVENT_AUDIO
--#endregion


--#region Imports

    --- @type Render2dClass
    local render2d = CNC.Import( "renhud/client/code/ww3d2/render-2d.lua" )

    --- @type FontsLib
    local fontsLib = CNC.Import( "renhud/client/cl_fonts.lua" )
--#endregion


--[[ Default Fonts ]] do

    --- @class FontDescription
    --- @field Name string
    --- @field PointSize integer
    --- @field InterCharSpacing integer
    --- @field IsBold boolean

    --- The amount to multiply Renegade font point sizes by to convert them to the same visual size in Garry's Mod
    --- This value was determined by experimentation and is not yet understood.
    local sizeMultipler = 1.75

    --- The font defaults as found in stylemgr.cpp and, seemingly identically, in data/stylemgr.ini
    --- @type FontDescription[]
    STATIC.DefaultFonts = {
        [ fontStyleEnum.Title            ] = { Name = "Regatta Condensed LET", PointSize = math.floor( sizeMultipler * 52 ), InterCharSpacing = 2, IsBold = false },
        [ fontStyleEnum.LgControls       ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 12 ), InterCharSpacing = 2, IsBold = true  },
        [ fontStyleEnum.Controls         ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 8  ), InterCharSpacing = 2, IsBold = true  },
        [ fontStyleEnum.Lists            ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 8  ), InterCharSpacing = 2, IsBold = false },
        [ fontStyleEnum.Tooltips         ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 8  ), InterCharSpacing = 2, IsBold = false },
        [ fontStyleEnum.Menu             ] = { Name = "Regatta Condensed LET", PointSize = math.floor( sizeMultipler * 32 ), InterCharSpacing = 2, IsBold = false },
        [ fontStyleEnum.SmMenu           ] = { Name = "Regatta Condensed LET", PointSize = math.floor( sizeMultipler * 20 ), InterCharSpacing = 2, IsBold = false },
        [ fontStyleEnum.Header           ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 9  ), InterCharSpacing = 2, IsBold = true  },
        [ fontStyleEnum.BigHeader        ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 12 ), InterCharSpacing = 2, IsBold = true  },
        [ fontStyleEnum.Credits          ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 10 ), InterCharSpacing = 2, IsBold = false },
        [ fontStyleEnum.CreditsBold      ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 10 ), InterCharSpacing = 2, IsBold = true  },
        [ fontStyleEnum.IngameTxt        ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 8  ), InterCharSpacing = 2, IsBold = false },
        [ fontStyleEnum.IngameBigTxt     ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 16 ), InterCharSpacing = 2, IsBold = false },
        [ fontStyleEnum.IngameSubtitleTxt] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 14 ), InterCharSpacing = 2, IsBold = false },
        [ fontStyleEnum.IngameHeaderTxt  ] = { Name = "Arial MT",              PointSize = math.floor( sizeMultipler * 9  ), InterCharSpacing = 2, IsBold = true  },
    }
end


--[[ Static Functions and Variables ]] do

    --[[ Initialization ]] do

        function STATIC.Initialize()
            -- Compute font scale for this resolution
            local screenRes = render2d.GetScreenResolution()
            STATIC.ScaleX = screenRes:Width() / 800
            STATIC.ScaleY = screenRes:Height() / 600

            -- Create font atlases for the default fonts
            for _, fontDescription in pairs( STATIC.DefaultFonts ) do
                if not fontsLib.IsFontCreated( fontDescription ) then
                    fontsLib.QueueRenegadeFontCreation( fontDescription )
                end
            end

            -- Not loading backdrop here because I don't need it (yet?)
        end

        --- @param fileName string
        function STATIC.InitializeFromIni( fileName )
            typecheck.NotImplementedError( "InitializeFromIni" )
        end

        function STATIC.Shutdown()
            typecheck.NotImplementedError( "Shutdown" )
        end
    end

    --[[ Font methods ]] do

        --- @param style FontStyle
        --- @return FontCharsInstance
        function STATIC.GetFont( style )
            typecheck.NotImplementedError( "GetFont" )
        end

        --- @param style FontStyle
        --- @return Font3dInstance
        function STATIC.PeekFont( style )
            -- Pull the font from the cache
            local cachedFont = STATIC.FontStyleToFont3d[ style ]

            -- If this font isn't already cached, cache it
            if not cachedFont then
                local fontDescription = STATIC.DefaultFonts[ style ]
                if not fontsLib.IsFontCreated( fontDescription ) then
                    typecheck.Error( STATIC.Class, "PeekFont",
                        "Unable to peek un-created font: '" .. fontDescription.Name .. "', size: " ..fontDescription.PointSize .. ", boldness:" .. tostring( fontDescription.IsBold )
                    )
                end

                STATIC.FontStyleToFont3d[ style ] = fontsLib.GetCreatedFont( fontDescription )
                cachedFont = STATIC.FontStyleToFont3d[ style ]
            end

            return cachedFont
        end

        --- @param renderer Render2dTextInstance
        --- @param style FontStyle
        function STATIC.AssignFont( renderer, style )
            typecheck.NotImplementedError( "AssignFont" )
        end
    end

    --[[ Sound methods ]] do

        --- @param event EventAudio
        function STATIC.PlaySound( event )
            typecheck.NotImplementedError( "PlaySound" )
        end
    end

    --[[ Configuration methods ]] do

        --- @param renderer Render2dTextInstance
        function STATIC.ConfigureRenderer( renderer )
            typecheck.NotImplementedError( "ConfigureRenderer" )
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
            return STATIC.TabGlowColor
        end
    end

    --[[ Text support ]] do

        --- @overload fun( text: string, renderer:Render2dTextInstance, textColor: Color, shadowColor: Color, rect: RectInstance, doShadow: boolean?, doClip: boolean, justify: Justification?, isVCentered: boolean? )
	    --- @overload fun( text: string, renderer:Render2dTextInstance, rect:RectInstance, doShadow: boolean?, doClip: boolean?, justify: Justification?, isEnabled:boolean?, isVCentered: boolean? )
        function STATIC.RenderText( ... )
            local args = { ... }
            local argCount = select( "#", ... )

            typecheck.NotImplementedError( "RenderText" )
        end

        --- @param text string
        --- @param renderer Render2dTextInstance
        --- @param rect RectInstance
        function STATIC.RenderTitleText( text, renderer, rect )
            typecheck.NotImplementedError( "RenderTitleText" )
        end

        --- @overload fun( text: string, renderer: Render2dTextInstance, textColor: Color, shadowColor: Color, rect: RectInstance, doShadow: boolean?, doVCenter: boolean? )
        --- @overload fun( text: string, renderer: Render2dTextInstance, rect: RectInstance, doShadow: boolean?, doVCenter: boolean?, isEnabled: boolean? )
        function STATIC.RenderWrappedText( ... )
            local args = { ... }
            local argCount = select( "#", ... )

            typecheck.NotImplementedError( "RenderWrappedText" )
        end

        --- @overload fun( text: string, renderer: Render2dTextInstance, rect: RectInstance, doShadow: boolean?, doVCenter: boolean?, isEnabled:boolean?, justify: Justification? )
        --- @overload fun( text: string, renderer: Render2dTextInstance, textColor: Color, shadowColor: Color, rect: RectInstance, doShadow: boolean?, doVCenter: boolean?, justify: Justification? )
        function STATIC.RenderWrappedTextEx( ... )
            local args = { ... }
            local argCount = select( "#", ... )

            typecheck.NotImplementedError( "RenderWrappedTextEx" )
        end
    end

    --[[ Hilight support ]] do

        --- @param renderer Render2dTextInstance
        function STATIC.ConfigureHilighter( renderer )
            typecheck.NotImplementedError( "ConfigureHilighter" )
        end

        --- @param renderer Render2dTextInstance
        --- @param rect RectInstance
        function STATIC.RenderHilight( renderer, rect )
            typecheck.NotImplementedError( "RenderHilight" )
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
            typecheck.NotImplementedError( "RenderGlow" )
        end
    end


    --- [[ Private ]]

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
    --- @field private Fonts FontCharsInstance[]
    --- @field private ScaleX number
    --- @field private ScaleY number
    --- @field private FontFileList string[]
    --- @field private EventAudioList string[]

    --- @private
    --- A map of FONT_STYLE to its matching Font3dInstance
    --- @type table<FontStyle, Font3dInstance>
    STATIC.FontStyleToFont3d = {}
end