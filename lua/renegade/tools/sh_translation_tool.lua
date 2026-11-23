--- @class Renegade
local CNC = CNC_RENEGADE

--- @class TranslationTool
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TranslationTool"

if not CLIENT then return end

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ToolsLib
	local toolsLib = CNC.Import( "sh_tools.lua" )

	--- @type TranslateDbClass
	local translateDbClass = CNC.Import( "code/wwtranslatedb/translate-db.lua" )

	--- @type FileFactoryClass
	local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

	--- @type FileClass
	local fileClass = CNC.Import( "code/wwlib/file.lua" )

	--- @type SaveLoadSystemClass
	local saveLoadSystemClass = CNC.Import( "code/wwsaveload/save-load.lua" )

	--- @type ChunkLoadClass
	local chunkLoadClass = CNC.Import( "code/wwlib/chunk-load.lua" )
--#endregion

--#region Imported Enums

	local fileRightsEnum = fileClass.FILE_RIGHTS
--#endregion


--- @class TranslationToolState
--- @field X integer
--- @field Y integer


--- @class TranslationTool
--- @field State TranslationToolState
--- @field Frame HotloadableDFrame
--- @field MainPanel DPanel
--- @field Tabs DPropertySheet
--- @field LoadFileButton DButton

--- @param previousState TranslationToolState
--- @return HotloadableDFrame
function STATIC.OpenTool( previousState )
    local state
    if previousState == nil then
        state = {
            X = 0, Y = 0
        }
    else
        state = previousState
    end
    STATIC.State = state

    local width = 800
    local height = 700

    STATIC.Frame = vgui.Create( "HotloadableDFrame" )
    STATIC.Frame:SetTitle( "Translation Tool" )
    STATIC.Frame:SetSize( width, height )
    STATIC.Frame:SetSizable( true )
    STATIC.Frame:SetPos( ScrW() / 5 - width / 2, ScrH() / 2 )
    STATIC.Frame:MakePopup()

    -- Main Panel
    STATIC.MainPanel = vgui.Create( "DPanel", STATIC.Frame )
    STATIC.MainPanel:Dock( FILL )

    -- Rebuild Table Button
    STATIC.RebuildTableButton = vgui.Create( "DButton", STATIC.MainPanel )
    STATIC.RebuildTableButton:SetHeight( 75 )
    STATIC.RebuildTableButton:Dock( BOTTOM )
    STATIC.RebuildTableButton:SetText( "(Re)Build Table" )
    STATIC.RebuildTableButton.DoClick = STATIC.PopulateCategories

    -- Load Button
    STATIC.LoadFileButton = vgui.Create( "DButton", STATIC.MainPanel )
    STATIC.LoadFileButton:SetHeight( 75 )
    STATIC.LoadFileButton:Dock( BOTTOM )
    STATIC.LoadFileButton:SetText( "Load File" )
    STATIC.LoadFileButton.DoClick = STATIC.LoadTranslationStrings

    if state ~= nil then
        STATIC.Frame:SetPos( state.X, state.Y )
    end

    function STATIC.Frame:ExportState()
        state.X = self:GetX()
        state.Y = self:GetY()

        return state
    end

    return STATIC.Frame
end

function STATIC.LoadTranslationStrings()

    translateDbClass.Shutdown()

    local STRINGS_FILENAME = "strings.tdb"

    translateDbClass.Initialize()
    local file = fileFactoryClass.TheFileFactory:GetFile( STRINGS_FILENAME )
    if file == nil then
        section.Error( "Strings file not found" )
    end
    --- @cast file FileInstance

    file:Open( fileRightsEnum.READ ) -- "Open or the file"
    if file:IsAvailable() then

        local cload = chunkLoadClass.New( file ) -- "Load the database"
        saveLoadSystemClass.Load( cload )
    end
    file:Close() -- "Close the file"
    fileFactoryClass.TheFileFactory:ReturnFile( file )

    STATIC.PopulateCategories()
end

function STATIC.PopulateCategories()
    -- (Re)Create the tabs panel
    if STATIC.Tabs ~= nil then STATIC.Tabs:Remove() end
    STATIC.Tabs = vgui.Create( "DPropertySheet", STATIC.MainPanel )
    STATIC.Tabs:Dock( FILL )

    -- Add each category
    for _, category in ipairs( translateDbClass.CategoryList ) do
        local tab = vgui.Create( "DPanel", STATIC.Tabs )
        STATIC.Tabs:AddSheet( category:GetName(), tab )

        local objectList = vgui.Create( "DListView", tab )
        objectList:Dock( FILL )
        objectList:SetMultiSelect( false )
        objectList:AddColumn( "ID (string)" )
        objectList:AddColumn( "ID (numeric)" )
        objectList:AddColumn( "Sound ID" )
        objectList:AddColumn( "English Text" )
        objectList:AddColumn( "Translated Text" )

        for _, object in ipairs( translateDbClass.ObjectList ) do
            if object:GetCategoryId() == category:GetId() then

                local englishString = object:GetEnglishString()
                local translatedString = object:GetString()

                englishString = englishString:Replace( "\n", "\\n" )
                translatedString = translatedString:Replace( "\n", "\\n" )

                objectList:AddLine( object:GetIdDesc(), object:GetId(), object:GetSoundId(), englishString, translatedString )
            end
        end
    end
end

toolsLib.RegisterTool( "ren_translation_tool", STATIC.OpenTool )

