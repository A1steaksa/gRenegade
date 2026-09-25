-- Based on Font3DInstanceClass within Code/ww3d2/font3d.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class Font3dClass
--- @field instance Font3dInstance The metatable used by Font3dInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "Font3dClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class Font3dInstance
--- @field Static Font3dClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Font3d" )
INSTANCE.Class = "Font3dInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsFont3d = true


--#region Imports

    --- @type Font3dDataClass
    local font3dDataClass = CNC.Import( "code/ww3d2/font-3d-data.lua" )

    --- @type RectClass
    local rectClass = CNC.Import( "code/wwmath/rect.lua" )
--#endregion


--[[ Static Functions and Variables ]] do

    --- Creates a new Font3dInstance
    --- @param fontMaterial IMaterial
    --- @return Font3dInstance
    function STATIC.New( fontMaterial )
        return robustclass.New( "Renegade_Font3d", fontMaterial )
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) Font3dInstance, `false` otherwise
    function STATIC.IsFont3d( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsFont3d and true or false
    end

    typecheck.RegisterType( "Font3dInstance", STATIC.IsFont3d )
end


--- Constructs a new Font3dInstance
--- @param fontMaterial IMaterial
function INSTANCE:Renegade_Font3d( fontMaterial )
    self.ScaledSpacingTable = {}
    self.ScaledWidthTable = {}

    self.MonoSpacing = 0
    self.Scale = 1
    self.InterCharSpacing = 1

    self.FontData = font3dDataClass.New( self, fontMaterial )
    self.SpaceWidth = self.FontData:GetCharWidth( "H" ) / 2

    self:BuildCachedTables()
end

--- @return IMaterial
function INSTANCE:PeekMaterial()
    return self.FontData:PeekMaterial()
end

--- @param spacing integer The spacing between characters, in pixels, when drawn at a scale of 1
function INSTANCE:SetInterCharSpacing( spacing )
    self.InterCharSpacing = math.floor( spacing )
    self:BuildCachedTables()
end

function INSTANCE:SetMonoSpaced()
    self.MonoSpacing = self.FontData:GetCharWidth( "W" ) + 1
    self:BuildCachedTables()
end

function INSTANCE:SetProportional()
    self.MonoSpacing = 0
    self:BuildCachedTables()
end

--- @param scale number
function INSTANCE:SetScale( scale )
    self.Scale = scale
    self:BuildCachedTables()
end

--- @return integer # The spacing between characters, in pixels, when drawn at a scale of 1
function INSTANCE:GetInterCharSpacing()
    return self.InterCharSpacing
end

--- @param char string
--- @return number
function INSTANCE:GetCharWidth( char )
    return self.ScaledWidthTable[ char ]
end

--- @param char string
--- @return number
function INSTANCE:GetCharSpacing( char )
    return self.ScaledSpacingTable[ char ]
end

--- @return number
function INSTANCE:GetCharHeight()
    return self.ScaledHeight
end

--- @param text string
--- @return number
function INSTANCE:GetStringWidth( text )
    local width = 0

    for _, char in ipairs( string.Explode( "", text ) ) do
        width = width + self:GetCharSpacing( char )
    end

    return width
end

--- @param char string
--- @return RectInstance
function INSTANCE:GetCharUv( char )
    return rectClass.New(
        self.FontData:GetCharUOffset( char ),
        self.FontData:GetCharVOffset( char ),
        self.FontData:GetCharUOffset( char ) + self.FontData:GetCharUWidth( char ),
        self.FontData:GetCharVOffset( char ) + self.FontData:GetCharVHeight()
    )
end

--- [[ Private ]]

--- @class Font3dInstance
--- @field FontData Font3dDataInstance
--- @field private SpaceWidth number The unscaled width of a space, in pixels [Default: 1/2 'H' width]
--- @field private InterCharSpacing number The unscaled width between characters, in pixels
--- @field private MonoSpacing number The unscaled width between monospaced characters, in pixels (Set to `0` to disable monospacing)
--- @field private ScaledWidthTable number[] The scaled cache of character widths, in pixels
--- @field private ScaledSpacingTable number[] The scaled cache of character spacing, in pixels
--- @field private ScaledHeight number The scaled height of characters, in pixels

function INSTANCE:BuildCachedTables()
    for i = 0, 255 do
        local char = string.char( i )
        local width = self.FontData:GetCharWidth( char )
        local isSpace = char == " "
        if isSpace then
            width = self.SpaceWidth
        end

        self.ScaledWidthTable[char] = math.floor( self.Scale * width )

        if self.MonoSpacing ~= 0 then
            self.ScaledSpacingTable[char] = math.floor( self.Scale * self.MonoSpacing )
        else
            local effectiveWidth = width + ( isSpace and 0 or self.InterCharSpacing )

            self.ScaledSpacingTable[char] = math.floor( self.Scale * effectiveWidth )
        end
    end

    self.ScaledHeight = math.floor( self.Scale * self.FontData:GetCharHeight() )
end