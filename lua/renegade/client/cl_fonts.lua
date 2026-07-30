--- @class Renegade
local CNC = CNC_RENEGADE

-- A library supporting the creation of font atlases from OS fonts
--- @class FontsLib
local LIB = CNC.CreateExport()
LIB.Class = "FontsLib"
local isHotload = not table.IsEmpty( LIB )


--#region Imports

    --- @type Render2dClass
    local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )

    --- @type FontCharsClass
    local fontCharsClass = CNC.Import( "code/ww3d2/font-chars.lua" )

    --- @type Font3dClass
    local font3dClass = CNC.Import( "code/ww3d2/font-3d.lua" )
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

    --- @private
    --- Where, relative to the `garrysmod/dataTbl` folder, font atlas images should be saved and loaded
    LIB.FontAtlasSaveLocation = "renegade/font-atlases/"
end

--- @class FontAtlasData
--- @field Font3dInstance Font3dInstance
--- @field CreatedFontName string? Only populated if this atlas was generated instead of loaded from a file
--- @field RenderTarget ITexture? Only populated if this atlas was generated instead of loaded from a file
--- @field Material IMaterial
--- @field Name string
--- @field PointSize number
--- @field IsBold boolean
--- @field InterCharSpacing integer

--- @private
--- A map of [string: System Font Name][integer: Point Size][boolean: Is Bold?] -> FontAtlasData
--- @type table<string, table<integer, table<boolean, FontAtlasData>>>
LIB.FontAtlasData = {}

--- @return FontAtlasData[]
function LIB.GetAllFontAtlasData()
    local result = {}

    for _, pointSizes in pairs( LIB.FontAtlasData ) do
        for _, boldnesses in pairs( pointSizes ) do
            for _, fontAtlasData in pairs( boldnesses ) do
                result[#result+1] = fontAtlasData
            end
        end
    end

    return result
end

--- @param fontName string
--- @param pointSize number
--- @param isBold boolean
--- @return FontAtlasData? `nil` if the font has not been loaded
function LIB.GetFontAtlasData( fontName, pointSize, isBold )
    local pointSizes = LIB.FontAtlasData[fontName]
    if not pointSizes then
        return nil
    end

    local boldnesses = pointSizes[pointSize]
    if not boldnesses then
        return nil
    end

    return boldnesses[isBold]
end

--- @param fontName string
--- @param pointSize number
--- @param isBold boolean
--- @param fontData FontAtlasData
function LIB.SetFontAtlasData( fontName, pointSize, isBold, fontData )
    local pointSizes = LIB.FontAtlasData[fontName]
    if not pointSizes then
        pointSizes = {}
        LIB.FontAtlasData[fontName] = pointSizes
    end

    local boldnesses = pointSizes[pointSize]
    if not boldnesses then
        boldnesses = {}
        pointSizes[pointSize] = boldnesses
    end

    boldnesses[isBold] = fontData
end

--- Formats given font information into a unique name
--- @param fontName string
--- @param pointSize number
--- @param isBold boolean
--- @return string # The file name (excluding the file extension) an atlas should be saved under for the given input
function LIB.FormatFontAtlasName( fontName, pointSize, isBold )
    local cleanedFontName = string.Replace( fontName, " ", "-" )
    return string.format( "renegade_%s_%d%s", cleanedFontName, pointSize, isBold and "_bold" or "" )
end

--- Formats given font information into a file path relative to the data folder and ending in `.png`
--- @param fontName string
--- @param pointSize number
--- @param isBold boolean
--- @return string
function LIB.FormatAtlasFilePath( fontName, pointSize, isBold )
    local atlasName = LIB.FormatFontAtlasName( fontName, pointSize, isBold )
    return LIB.FontAtlasSaveLocation .. atlasName .. ".png"
end

--- @param fontName string
--- @param pointSize integer
--- @param isBold boolean
function LIB.SaveFontAtlas( fontName, pointSize, isBold )
    local fontAtlasData = LIB.GetFontAtlasData( fontName, pointSize, isBold )
    if not fontAtlasData then
        section.Error( "Can't find font data to save for: ", fontName, " ", pointSize, " pt ", isBold and "bold" or "regular" )
    end
    --- @cast fontAtlasData FontAtlasData

    local renderTarget = fontAtlasData.RenderTarget
    if not renderTarget then
        section.Error( "Can't save Render Target for font that was loaded from a file: ", fontName, " ", pointSize, " pt ", isBold and "bold" or "regular" )
    end
    --- @cast renderTarget ITexture

    -- Get the Render Target's image data
    render.PushRenderTarget( renderTarget )
    local imageData = render.Capture( {
        format = "png",
        x = 0,
        y = 0,
        w = renderTarget:Width(),
        h = renderTarget:Height(),
        alpha = true
    } )
    render.PopRenderTarget()

    -- Ensure the font atlas directory exists
    file.CreateDir( LIB.FontAtlasSaveLocation )

    if not imageData then
        section.Print( "Skipping saving empty atlas: ", fontName, " ", pointSize, " pt, ", ( isBold and "bold" or "regular" ) )
        return
    end

    -- Write the image data to a file
    local filePath = LIB.FormatAtlasFilePath( fontName, pointSize, isBold )
    file.Write( filePath, imageData )
end

--- @param fontName string
--- @param pointSize integer
--- @param isBold boolean
--- @return FontAtlasData
function LIB.LoadFontAtlas( fontName, pointSize, isBold, interCharSpacing )
    local filePath = "data/" .. LIB.FormatAtlasFilePath( fontName, pointSize, isBold )
    local loadedMaterial = Material( filePath, "" )
    local font3dInstance = font3dClass.New( loadedMaterial )
    font3dInstance:SetInterCharSpacing( interCharSpacing )

    local fontAtlasData = LIB.GetFontAtlasData( fontName, pointSize, isBold ) or {}
    fontAtlasData = {
        Name = fontName,
        PointSize = pointSize,
        IsBold = isBold,
        InterCharSpacing = interCharSpacing,
        Font3dInstance = font3dInstance,
        Material = loadedMaterial
    }
    LIB.SetFontAtlasData( fontName, pointSize, isBold, fontAtlasData )

    return fontAtlasData
end

--- Retrieves an existing atlas-based font if one exists or creates one if it does not
--- @param fontName string
--- @param pointSize integer
--- @param isBold boolean
--- @param interCharSpacing integer
--- @return Font3dInstance
function LIB.GetOrCreateFontAtlas( fontName, pointSize, isBold, interCharSpacing )
    -- Use already-loaded font data if it's available
    local fontAtlasData = LIB.GetFontAtlasData( fontName, pointSize, isBold )
    if fontAtlasData then
        if fontAtlasData.Font3dInstance then
            return fontAtlasData.Font3dInstance
        else
            section.Error( "Font data exists but isn't populated" )
        end
    end

    -- Use existing atlas images from the disk if they're available
    local atlasPath = LIB.FormatAtlasFilePath( fontName, pointSize, isBold )
    if file.Exists( atlasPath, "DATA" ) then
        fontAtlasData = LIB.LoadFontAtlas( fontName, pointSize, isBold, interCharSpacing )
        section.Print( "Loaded atlas from '", atlasPath, "' - ", fontAtlasData.Material:GetName() )
        return fontAtlasData.Font3dInstance
    end

    --- If nothing is already available, create a new font atlas
    return LIB.CreateFontAtlas( fontName, pointSize, isBold, interCharSpacing )
end


--- Creates a font atlas for a given font configuration
--- Note: The font atlas is populated in the following frame and will be empty until then
--- @param fontName string
--- @param pointSize integer
--- @param isBold boolean
--- @param interCharSpacing integer
--- @return Font3dInstance
function LIB.CreateFontAtlas( fontName, pointSize, isBold, interCharSpacing )
    -- Register this font with Garry's Mod so we can draw it
    local createdFontName = LIB.FormatFontAtlasName( fontName, pointSize, isBold )
    local fontChars = fontCharsClass.New()
    fontChars:InitializeGdiFont( fontName, pointSize, isBold )

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
        RT_SIZE_LITERAL,
        MATERIAL_RT_DEPTH_NONE,
        bit.bor(
            1, -- TEXTUREFLAGS_POINTSAMPLE
            512 -- TEXTUREFLAGS_NOMIP
        ),
        0,
        IMAGE_FORMAT_RGBA8888
    )

    if createdFontName:StartsWith( "renegade_Regatta-Condensed-LET" ) then

        section.Print(
            pointSize, " pt | ",
            "char: ",  maxCharWidth, " x ", maxCharHeight, " | ",
            "attempt: ", atlasWidth, " x ", atlasHeight, " | ",
            "actual: ", atlasRenderTarget:Width(), " x ", atlasRenderTarget:Height(), " | ",
            createdFontName
        )


    end

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

    -- Adjust the scale of the font to compensate for the screen's DPI
    -- In the original code this is done within FontCharsClass::Create_GDI_Font but
    -- it's being done here so we can use the original font size to create the atlas
    -- and then draw that atlas at a larger size to get the pixelated text I crave
    font3d.Scale = 1.75

    -- Store the new font data
    LIB.SetFontAtlasData( fontName, pointSize, isBold, {
        Name = fontName,
        PointSize = pointSize,
        IsBold = isBold,
        InterCharSpacing = interCharSpacing,
        Font3dInstance = font3d,
        CreatedFontName = createdFontName,
        RenderTarget = atlasRenderTarget,
        Material = atlasMaterial,
    } )

    -- Export the atlas as a file so we can re-use it next time
    LIB.SaveFontAtlas( fontName, pointSize, isBold )

    return font3d
end

if isHotload then
    -- RunConsoleCommand( "ren_debug_cycle_refresh" )
end