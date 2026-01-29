--- @class Renegade
local CNC = CNC_RENEGADE

-- A library supporting the creation of font atlases from OS fonts
--- @class FontsLib
local LIB = CNC.CreateExport()
LIB.Class = "FontsLib"
local isHotload = not table.IsEmpty( LIB )


--#region Imports

    --- @type FontCharsClass
    local fontCharsClass = CNC.Import( "renhud/code/ww3d2/font-chars.lua" )

    --- @type Font3dClass
    local font3dClass = CNC.Import( "renhud/code/ww3d2/font-3d.lua" )
--#endregion


--[[ Configuration ]] do

    --- @private
    --- The byte in the ASCII char range that font atlas rendering range starts at
    LIB.FontAtlasStartChar = 33

    --- @private
    --- The byte in the ASCII char range that font atlas rendering range stops at
    LIB.FontAtlasEndChar = 127

    --- @private
    --- The width and height, in number of characters, of font atlases
    LIB.FontAtlasGridSize = Vector( 16, 16 )

    --- @private
    --- What color text should be when it is rendered to a new font atlas
    LIB.FontAtlasTextColor = Color( 255, 255, 255, 255 )
end

--- @private
--- All of the font atlases that have been created and their corresponding Font3dInstance
--- A map of [string: System Font Name][integer: Point Size][boolean: Is Bold?] -> Font3dInstance
--- @type table<string, table<integer, table<boolean, Font3dInstance>>>
LIB.CreatedFonts = {}


--- @private
--- A queue of the Garry's Mod font names that need to have atlases created for them in the next batch of conversions
--- @type string[]
LIB.FontsToCreate = {}


--- @class FontDebugData
--- @field CreatedFontName string
--- @field RenderTarget ITexture
--- @field Name string
--- @field PointSize number
--- @field IsBold boolean
--- @field InterCharSpacing integer

--- A map of Garry's Mod font names to their corresponding font atlas Render Target
--- @type FontDebugData[]
LIB.FontRenderTargets = LIB.FontRenderTargets or {}

--- @param font FontDescription
--- @return boolean
function LIB.IsFontCreated( font )
    local fontsWithName = LIB.CreatedFonts[font.Name]
    if not fontsWithName then return false end

    local fontsWithSize = fontsWithName[font.PointSize]
    if not fontsWithSize then return false end

    local fontWithBold = fontsWithSize[font.IsBold]
    if not fontWithBold then return false end

    return true
end

--- Retrieves an existing font
--- @param font FontDescription
--- @return Font3dInstance
function LIB.GetCreatedFont( font )
    local fontsWithName = LIB.CreatedFonts[font.Name]
    if not fontsWithName then
        Section.Error( "Unable to find Renegade font named '", font.Name, "'" )
    end

    local fontsWithSize = fontsWithName[font.PointSize]
    if not fontsWithSize then
        Section.Error( "Unable to find Renegade font named '", font.Name, "' and size ", font.PointSize )
    end

    local fontWithBold = fontsWithSize[font.IsBold]
    if not fontWithBold then
        Section.Error(
            "Unable to find Renegade font named '", font.Name, "', ",
            "size ", font.PointSize, "', ",
            "and ", ( font.IsBold and "bold" or "regular" ), " font weight"
        )
    end

    return fontWithBold
end

--- Creates a font atlas for a given font configuration  
--- Note: The font atlas is populated in the following frame and will be empty until then
--- @param name string
--- @param pointSize integer
--- @param isBold boolean
--- @param interCharSpacing integer
--- @return Font3dInstance
function LIB.CreateFont( name, pointSize, isBold, interCharSpacing )
    -- Register this font with Garry's Mod so we can draw it
    local fontChars = fontCharsClass.New()
    local createdFontName = fontChars:InitializeGdiFont( name, pointSize, isBold )
    surface.SetFont( createdFontName )

    -- Find the font's widest character width and height
    local maxCharWidth, maxCharHeight = 0, 0
    for byte = LIB.FontAtlasStartChar, LIB.FontAtlasEndChar do
        local char = string.char( byte )

        local charWidth, charHeight = surface.GetTextSize( char )

        maxCharWidth = ( charWidth > maxCharWidth ) and charWidth or maxCharWidth
        maxCharHeight = ( charHeight > maxCharHeight ) and charHeight or maxCharHeight
    end

    -- Adjust the maximum size slightly as a safety margin
    maxCharWidth = maxCharWidth + 2
    maxCharHeight = maxCharHeight + 2

    -- Create a Render Target to store the font atlas
    local atlasWidth = maxCharWidth * LIB.FontAtlasGridSize.x
    local atlasHeight = maxCharHeight * LIB.FontAtlasGridSize.y
    local atlasRenderTarget = GetRenderTargetEx(
        "RENEGADE_FONT-ATLAS-RT_" .. createdFontName,
        atlasWidth, atlasHeight,
        RT_SIZE_OFFSCREEN,
        MATERIAL_RT_DEPTH_NONE,
        bit.bor(
            1, -- TEXTUREFLAGS_POINTSAMPLE
            512 -- TEXTUREFLAGS_NOMIP
        ),
        0,
        IMAGE_FORMAT_RGBA8888
    )

    --[[ Populate Atlas ]] do

        local color = LIB.FontAtlasTextColor
        surface.SetTextColor( color.r, color.g, color.b, color.a )

        render.PushRenderTarget( atlasRenderTarget )
        cam.Start2D()

        render.Clear( 0, 0, 0, 0 )

        render.OverrideColorWriteEnable( true, true )
        render.OverrideAlphaWriteEnable( true, true )
        render.OverrideBlend( false )

        -- Draw each character onto the Render Target
        for byte = LIB.FontAtlasStartChar, LIB.FontAtlasEndChar do
            local char = string.char( byte )

            -- The position of this character within the atlas's grid
            local gridX = ( byte % LIB.FontAtlasGridSize.x )
            local gridY = math.floor( byte / LIB.FontAtlasGridSize.y )

            -- The top-left corner of this character's cell on the grid
            local charOriginX = gridX * maxCharWidth
            local charOriginY = gridY * maxCharHeight

            local charWidth, charHeight = surface.GetTextSize( char )

            -- Draw the character in the center of its grid cell
            local charDrawX = math.floor( charOriginX + ( maxCharWidth  / 2 ) - ( charWidth  / 2 ) )
            local charDrawY = math.floor( charOriginY + ( maxCharHeight / 2 ) - ( charHeight / 2 ) )

            surface.SetTextPos( charDrawX, charDrawY )
            surface.DrawText( char )
        end

        render.OverrideColorWriteEnable( false, false )
        render.OverrideAlphaWriteEnable( false, false )

        cam.End2D()
        render.PopRenderTarget()
    end

    -- The IMaterial that will be used by a Render2dTextInstance to draw this font
    local atlasMaterial = CreateMaterial( "RENEGADE_FONT-ATLAS-MAT_" .. createdFontName, "UnlitGeneric", {
        ["$basetexture"]    = atlasRenderTarget:GetName(),
        ["$translucent"]    = 1,
        ["$gammacolorread"] = 1,    -- Disables SRGB conversion of color texture read.  Credit: Noaccess
        ["$linearwrite"]    = 1,    -- Disables SRGB conversion of shader results.      Credit: Noaccess
        ["$vertexcolor"]    = 1
    } )

    -- This font3d will ultimately be used to set the font of a Render2dTextInstance
    local font3d = font3dClass.New( atlasMaterial )
    font3d:SetInterCharSpacing( interCharSpacing )

    --[[ Store the New Font ]] do

        local matchingNames = LIB.CreatedFonts[name]
        if not matchingNames then
            LIB.CreatedFonts[name] = {}
            matchingNames = LIB.CreatedFonts[name]
        end

        local matchingSizes = matchingNames[pointSize]
        if not matchingSizes then
            matchingNames[pointSize] = {}
            matchingSizes = matchingNames[pointSize]
        end

        LIB.CreatedFonts[name][pointSize][isBold] = font3d
    end

    LIB.FontRenderTargets[#LIB.FontRenderTargets + 1] = {
        CreatedFontName = createdFontName,
        RenderTarget = atlasRenderTarget,
        Name = name, 
        PointSize = pointSize,
        IsBold = isBold,
        InterCharSpacing = interCharSpacing
    }

    return font3d
end