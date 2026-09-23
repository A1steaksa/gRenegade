--- @class Renegade
local CNC = CNC_RENEGADE

--- @class TextureTool
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TextureTool"

if not CLIENT then return end

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ToolsLib
	local toolsLib = CNC.Import( "sh_tools.lua" )

	--- @type PlayerLib
	local playerLib = CNC.Import( "sh_players.lua" )

	--- @type WW3dFileFormatIds
	local wW3dFileFormatIds = CNC.Import( "code/ww3d2/ww3d-format.lua" )

	--- @type DDSFileClass
	local dDSFileClass = CNC.Import( "code/ww3d2/dds-file.lua" )
--#endregion

--#region Imported Enums

	local wW3dFormatEnum = wW3dFileFormatIds.WW3D_FORMAT
--#endregion


--- @class TextureToolState
--- @field X number
--- @field Y number


--- @class TextureTool

--- @param previousState TextureToolState
--- @return HotloadableDFrame
function STATIC.OpenTool( previousState )
    local frame = vgui.Create( "HotloadableDFrame" )
    frame:SetTitle( "Texture Tool " )
    frame:SetSize( 1200, 600 )
    frame:Center()
    frame:MakePopup()

    local renderTarget = GetRenderTarget( "ren_texture_tool_rt", 256, 256 )
    local rtMaterial = CreateMaterial( "ren_texture_tool_mat", "UnlitGeneric", {
        ["$basetexture"] = renderTarget:GetName(),
        ["$translucent"] = 1
    } )

    local textureDisplayPanel = frame:Add( "DPanel" )
    textureDisplayPanel:Dock( FILL )
    function textureDisplayPanel:Paint( width, height )
        local zoom = 10
        local pan = Vector(0, 0 )

        render.PushFilterMag( TEXFILTER.POINT )

        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.SetMaterial( rtMaterial )
        surface.DrawTexturedRectUV( pan.x, pan.y, renderTarget:Width() * zoom, renderTarget:Height() * zoom, 0, 0, 1, 1 )

        render.PopFilterMag()
    end

    local startButton = frame:Add( "DButton" )
    startButton:SetText( "Start" )
    startButton:Dock( BOTTOM )
    function startButton:DoClick()
        local fileName = "c_glasses2.dds"
        local file = dDSFileClass.New( fileName, 0 )
        file:Load()

        render.PushRenderTarget( renderTarget )
        render.Clear( 255, 0, 255, 0 )
        render.PopRenderTarget()

        local width, height = file:GetWidth( 1 ), file:GetHeight( 1 )

        file:CopyLevelToSurface( 1, wW3dFormatEnum.WW3D_FORMAT_A8R8G8B8, width, height, renderTarget )
    end

    if previousState ~= nil then
        frame:SetPos( previousState.X, previousState.Y )

        startButton:DoClick()
    end

    --- @return TextureToolState
    function frame:ExportState()
        return {
            X = self:GetX(),
            Y = self:GetY(),
        }
    end

    return frame
end

toolsLib.RegisterTool( "ren_texture_tool", STATIC.OpenTool )