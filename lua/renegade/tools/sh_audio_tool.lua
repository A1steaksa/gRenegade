--- @class Renegade
local CNC = CNC_RENEGADE

--- @class AudioTool
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AudioTool"

if not CLIENT then return end

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ToolsLib
	local toolsLib = CNC.Import( "sh_tools.lua" )

	--- @type FileClass
	local fileClass = CNC.Import( "code/wwlib/file.lua" )

	--- @type Ww3dAssetManagerClass
	local ww3dAssetManagerClass = CNC.Import( "code/ww3d2/ww3d-asset-manager.lua" )

	--- @type SoundBufferClass
	local soundBufferClass = CNC.Import( "code/wwaudio/sound-buffer.lua" )

	--- @type FileFactoryClass
	local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )
--#endregion

--#region Imported Enums
--#endregion

--- @class AudioToolFrame : HotloadableDFrame
--- @field MainPanel DPanel
--- @field FileProperties DProperties
--- @field PlayButton DButton

--- @class AudioTool
--- @field X integer
--- @field Y integer
--- @field Width integer
--- @field Height integer
--- @field Frame AudioToolFrame
--- @field LoadedSound SoundBufferInstance
--- @field FileName string

STATIC.DefaultFileName = "m00evan_dsgn0057i1evan_snd.wav"

--- @param fileName string
function STATIC.LoadFile( fileName )
    if STATIC.FileName == nil then return end

    local wavFile = fileFactoryClass.TheFileFactory:GetFile( fileName )
    if wavFile == nil or not wavFile:IsAvailable() then
        return
    end

    STATIC.LoadedSound = soundBufferClass.New()
    STATIC.LoadedSound:LoadFromFile( STATIC.FileName )

    STATIC.PopulateFileInfo()
end

function STATIC.PopulateFileInfo()
    if STATIC.LoadedSound == nil then
        section.Warn( "AudioTool - Can't populate file info without a loaded sound" )
        return
    end

    STATIC.Frame.FileProperties:Clear()

    -- Base keys
    for key, value in pairs( STATIC.LoadedSound ) do
        if istable( value ) then
            continue
        end

        local row = STATIC.Frame.FileProperties:CreateRow( "SoundBufferInstance", key )

        row:Setup( "Generic" )
        row:SetValue( value )
    end

    -- Table keys
    for tableName, tbl in pairs( STATIC.LoadedSound ) do
        if not istable( tbl ) then
            continue
        end

        for k, v in pairs( tbl ) do
            local row = STATIC.Frame.FileProperties:CreateRow( tableName, k )
            row:Setup( "Generic" )
            row:SetValue( v )
        end
    end

    STATIC.Frame.PlayButton:SetEnabled( true )
end


--[[ Labeled Text Entry ]] do

    --- @class LabeledTextEntry : DPanel
    --- @field Label DLabel
    --- @field TextEntry DTextEntry
    local PANEL = {}
    vgui.Register( "LabeledTextEntry", PANEL, "DPanel" )

    function PANEL:Init()

        self:DockMargin( 0, 0, 0, 0 )
        self:DockPadding( 2, 2, 2, 2 )
        self:SetHeight( 30 )

        self.Label = vgui.Create( "DLabel", self )
        self.Label:Dock( LEFT )
        self.Label:SetDark( true )
        self.Label:DockMargin( 10, 0, 0, 0 )

        self.TextEntry = vgui.Create( "DTextEntry", self )
        self.TextEntry:Dock( FILL )
    end

    --- @param text string
    function PANEL:SetLabelText( text )
        self.Label:SetText( text )
    end

    --- @return string
    function PANEL:GetLabelText()
        return self.Label:GetText()
    end

    --- @param text string
    function PANEL:SetTextEntryText( text )
        self.TextEntry:SetValue( text )
    end

    --- @return string
    function PANEL:GetTextEntryText()
        return self.TextEntry:GetValue()
    end
end



--- @return HotloadableDFrame
function STATIC.OpenTool()
    local width = 600
    local height = 600

    if STATIC.Frame ~= nil then
        if not IsValid( STATIC.Frame ) then
            STATIC.Frame = nil
        else
            STATIC.Frame:Close()
        end
    end

    STATIC.Frame = vgui.Create( "HotloadableDFrame" ) --[[@as AudioToolFrame]]

    STATIC.Frame:SetTitle( "Audio Tool" )
    STATIC.Frame:SetSize( width, height )
    STATIC.Frame:SetPos( ScrW() / 5 - width / 2, ScrH() / 2 )
    STATIC.Frame:MakePopup()
    STATIC.Frame:SetSizable( true )

    local menuBar = vgui.Create( "DMenuBar", STATIC.Frame )
    menuBar:DockMargin( -3, -6, -3, 0 )

    STATIC.Frame.MainPanel = vgui.Create( "DPanel", STATIC.Frame )
    STATIC.Frame.MainPanel:Dock( FILL )


    --[[ File Loading ]] do
        local fileLoadingPanel = vgui.Create( "LabeledTextEntry", STATIC.Frame.MainPanel )
        fileLoadingPanel:Dock( TOP )

        fileLoadingPanel:SetLabelText( "File Name" )
        fileLoadingPanel:SetTextEntryText( STATIC.DefaultFileName )

        local loadFileButton = vgui.Create( "DButton", STATIC.Frame.MainPanel )
        loadFileButton:Dock( TOP )
        loadFileButton:SetText( "Load File" )
        loadFileButton:DockMargin( 0, 5, 0, 10 )
        loadFileButton:SetHeight( 35 )
        
        function loadFileButton:DoClick()
            STATIC.FileName = fileLoadingPanel.TextEntry:GetValue()
            STATIC.LoadFile( STATIC.FileName )
        end
    end

    STATIC.Frame.FileProperties = vgui.Create( "DProperties", STATIC.Frame.MainPanel )
    STATIC.Frame.FileProperties:Dock( FILL )

    STATIC.Frame.PlayButton = vgui.Create( "DButton", STATIC.Frame.MainPanel )
    STATIC.Frame.PlayButton:Dock( BOTTOM )
    STATIC.Frame.PlayButton:SetHeight( 75 )
    STATIC.Frame.PlayButton:SetText( "Play" )
    STATIC.Frame.PlayButton:SetEnabled( false )

    function STATIC.Frame.PlayButton:DoClick()
        section.Print( "Playing sound..." )
        local soundName = "a1_renegade_testsound" .. math.floor( CurTime() )
        sound.Generate( soundName, STATIC.LoadedSound.Rate, STATIC.LoadedSound.Duration, STATIC.LoadedSound.DecodedSamples )
        surface.PlaySound( soundName )
    end

    if STATIC.X ~= nil and STATIC.Y ~= nil then
        STATIC.Frame:SetPos( STATIC.X, STATIC.Y )
        STATIC.Frame:SetSize( STATIC.Width, STATIC.Height )
        if STATIC.LoadedSound ~= nil then
            STATIC.PopulateFileInfo()
        end
    end

    function STATIC.Frame:ExportState()
        STATIC.X = STATIC.Frame:GetX()
        STATIC.Y = STATIC.Frame:GetY()
        STATIC.Width = STATIC.Frame:GetWide()
        STATIC.Height = STATIC.Frame:GetTall()
    end

    STATIC.LoadFile( STATIC.FileName )

    return STATIC.Frame
end

toolsLib.RegisterTool( "ren_audio_tool", STATIC.OpenTool )