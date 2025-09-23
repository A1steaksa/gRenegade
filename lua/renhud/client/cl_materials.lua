-- Handles loading materials

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class MaterialsLib
local LIB = CNC.CreateExport()
local CLASS = "MaterialsLib"
local isHotload = not table.IsEmpty( LIB )

--- @private
--- @type table<string, IMaterial>
LIB.LoadedMaterials = {}

--- Loads and caches a given png material within `materials/renhud/`
--- @param shortPath string The path to the material, excluding the renhud folder and the .png extension.
function LIB.LoadMaterial( shortPath )
    -- Handle paths starting with a slash
    local startsWithSlash = string.StartsWith( shortPath, "/" ) or string.StartsWith( shortPath, "\\" )
    if startsWithSlash then
        shortPath = string.Right( shortPath, string.len( shortPath ) - 1 )
    end

    local cachedValue = LIB.LoadedMaterials[ shortPath ]

    -- Load the material if it isn't already cached
    if not cachedValue then
        local filepath = "renhud/" .. shortPath .. ".png"

        local loadedMaterial = Material( filepath, "" )
        loadedMaterial:SetInt( "$gammacolorread", 1 )   -- Disables SRGB conversion of color texture read.  Credit: Noaccess
        loadedMaterial:SetInt( "$linearwrite", 1 )      -- Disables SRGB conversion of shader results.      Credit: Noaccess

        LIB.LoadedMaterials[ shortPath ] = loadedMaterial
        cachedValue = loadedMaterial
    end

    return cachedValue
end

CNC.LoadMaterial = LIB.LoadMaterial