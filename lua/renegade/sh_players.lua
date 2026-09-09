-- Create and manages Soldier GameObjects for Players

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class PlayerManager
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PlayerManager"

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SoldierGameObjectClass
	local soldierGameObjectClass = CNC.Import( "code/combat/soldier-game-object.lua" )

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

	--- @type UnitConversionLib
	local unitConversionLib = CNC.Import( "sh_unit-conversion.lua" )

	--- @type QuaternionClass
	local quaternionClass = CNC.Import( "code/wwmath/quaternion.lua" )

	--- @type RenderInfoClass
	local renderInfoClass = CNC.Import( "code/ww3d2/render-info.lua" )

	--- @type CombatManagerClass
	local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

	--- @type GameObjectManagerClass
	local gameObjectManagerClass = CNC.Import( "code/combat/game-object-manager.lua" )

	--- @type Ww3dAssetManagerClass
	local ww3dAssetManagerClass = CNC.Import( "code/ww3d2/ww3d-asset-manager.lua" )

	--- @type HAnimationManagerClass
	local hAnimationManagerClass = CNC.Import( "code/ww3d2/h-animation-manager.lua" )

	--- @type ToolsLib
	local toolsLib = CNC.Import( "sh_tools.lua" )

	--- @type PlayerManagerClass
	local playerManagerClass = CNC.Import( "code/commando/player-manager.lua" )

	--- @type FileFactoryClass
	local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )

	--- @type FileClass
	local fileClass = CNC.Import( "code/wwlib/file.lua" )

	--- @type CrcClass
	local crcClass = CNC.Import( "code/wwlib/real-crc.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type DDSFileClass
	local dDSFileClass = CNC.Import( "code/ww3d2/dds-file.lua" )

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )

	--- @type WW3dFileFormatIds
	local wW3dFileFormatIds = CNC.Import( "code/ww3d2/ww3d-format.lua" )
--#endregion

--#region Imported Enums

	local fileRightsEnum = fileClass.FILE_RIGHTS
	local wW3dFormatEnum = wW3dFileFormatIds.WW3D_FORMAT
--#endregion


--- @class PlayerManager

--- @type {[Player]: SoldierGameObjectInstance}
STATIC.PlayerSoldiers = STATIC.PlayerSoldiers or {}

--- @param ply Player
--- @return SoldierGameObjectInstance?
function STATIC.InitPlayerSoldier( ply )
	-- Don't create duplicates
	if STATIC.GetPlayerSoldier( ply ) ~= nil then
		return
	end

	section.Print( "Creating Soldier for Player '", ply, "'" )

	-- Some humanoid definition
	local definitionId = 81930240

	local definition = definitionManagerClass.FindDefinition( definitionId ) --[[@as SoldierGameObjectDefinitionInstance]]
	if definition == nil then
		section.Error( "Unable to find definition ID ", definitionId, " to create player soldiers " )
		return
	end

	local physDefinition = definitionManagerClass.FindDefinition( definition.PhysicsDefinitionId ) --[[@as PhysicsDefinitionInstance]]
	if physDefinition == nil then
		section.Error( "Unable to find physics definition ID ", definition.PhysicsDefinitionId, " to modify player soldier's model" )
		return
	end

	-- I think this definition's model is fucked up so swap it
	-- physDefinition.ModelName = "characters\\nod rocket trooper sf\\c_ag_nod_rsold.w3d"

	section.Start( "Creating a soldier for ", ply:Nick() )

	local soldier = definition:Create( ply ) --[[@as SoldierGameObjectInstance]]
	soldier:SetControlOwner( ply:IsBot() and -1 or 1 )

	STATIC.PlayerSoldiers[ply] = soldier

	section.End()

	return soldier
end

--- @param ply Player
--- @return SoldierGameObjectInstance?
function STATIC.GetPlayerSoldier( ply )
	return STATIC.PlayerSoldiers[ ply ]
end

--- @param soldier SoldierGameObjectInstance
--- @return Player?
function STATIC.GetSoldierPlayer( soldier )
	return table.KeyFromValue( STATIC.PlayerSoldiers, soldier )
end

--- @param ply Player
function STATIC.RemovePlayerSoldier( ply )
	local soldier = STATIC.PlayerSoldiers[ply]
	gameObjectManagerClass.Remove( soldier )
	STATIC.PlayerSoldiers[ply] = nil
end

if SERVER then
	-- Create SoldierGameObjects for players as they spawn for the first time
	hook.Add( "PlayerInitialSpawn", "A1_Renegade_CreatePlayerSoldiers", STATIC.InitPlayerSoldier )

	-- Remove SoldierGameObjects for players as they disconnect
	hook.Add( "PlayerDisconnected", "A1_Renegade_RemovePlayerSoldiers", STATIC.RemovePlayerSoldier )
end

-- Create a SoldierGameObject for each player when the server starts or when the client finishes loading
hook.Add( "Renegade_PostGameInit", "A1_Renegade_CreatePlayerSoldiers", function()
	for _, ply in player.Iterator() do
		STATIC.InitPlayerSoldier( ply )
	end
end )


if CLIENT then
	concommand.Add( "ren_definition_explorer", function()

		local frame = vgui.Create( "DFrame" )
		frame:SetTitle( "Definition Explorer" )
		frame:SetSize( 1200, 600 )
		frame:Center()
		frame:MakePopup()

		local menuBar = vgui.Create( "DMenuBar", frame )
		menuBar:DockMargin( -3, -6, -3, 0 )

		local list = frame:Add( "DListView" )
		list:Dock( FILL )
		list:AddColumn( "ID" )
		list:AddColumn( "Type" )
		list:AddColumn( "Name" )
		list:AddColumn( "Path" )

		--[[ Definition Type Filter ]] do

			-- Get each unique definition class
			local definitionClasses = {}
			for id, definition in pairs( definitionManagerClass.IdToDefinition ) do
				if definitionClasses[definition.Class] == nil then
					definitionClasses[definition.Class] = true
				end
			end

			local definitionTypeMenu = menuBar:AddMenu( "Definition Type" ) --[[@as DMenu]]

			-- The "None" option should re-populate the list with all definitions
			definitionTypeMenu:AddOption( "None", function()
				list:Clear()

				for _, definition in pairs( definitionManagerClass.IdToDefinition ) do
					list:AddLine( definition.Id, definition.Class, definition.Name )
				end
			end )

			-- Add each unique definiiton class to the list and make selecting them re-populate the list with only 
			-- definitions matching that class
			for definitionClass, _ in pairs( definitionClasses ) do
				--- @param panel DMenuOption
				definitionTypeMenu:AddOption( definitionClass, function( panel )
					list:Clear()

					for _, definition in pairs( definitionManagerClass.IdToDefinition ) do
						if definition.Class == panel:GetText() then
							local path = nil
							if definition.Class == "HumanPhysicsDefinitionInstance" then
								--- @cast definition HumanPhysicsDefinitionInstance
								path = definition.ModelName
							end

							local line = list:AddLine( definition.Id, definition.Class, definition.Name, path ) --[[@as DListView_Line]]

							line.OnSelect = function( self )
								local soldier = STATIC.GetPlayerSoldier( LocalPlayer() )
								if soldier == nil then return end

								local definition = definitionManagerClass.FindDefinition( definition.Id )
								if definition == nil then return end

								if definition.Class ~= "SoldierGameObjectDefinitionInstance" then
									return
								end

								SetClipboardText( tostring( definition.Id ) )

								--- @cast definition SoldierGameObjectDefinitionInstance
								soldier:ReInit( definition )
							end
						end
					end
				end )
			end
		end
	end )

	STATIC.FailedPlayerInit = {}

	hook.Add( "PrePlayerDraw", "A1_Renegade_Debug_DrawPlayerSoldiers", function( ply )
		if not CNC.HasPostGameInit then return end

		if STATIC.FailedPlayerInit[ply] ~= nil then return end

		local soldier = STATIC.GetPlayerSoldier( ply )
		if soldier == nil then
			soldier = STATIC.InitPlayerSoldier( ply )

			if soldier == nil then
				section.Error( "Failed to initialize SoldierGameObject for player: '", ply:Nick()(), "'" )

				STATIC.FailedPlayerInit[ply] = true
			end
		end
		--- @cast soldier SoldierGameObjectInstance

		local soldierPhys = soldier.PhysicsObject:AsHumanPhysics()
		if soldierPhys == nil then
			return
		end

		if not IsValid( soldier:GetConnectedEntity() ) then
			return
		end

		local model = soldierPhys:GetModel()
		if model == nil then
			return
		end

		model:SetLodLevel( 3 )

		model:Render( renderInfoClass.New( combatManagerClass.GetCamera() ) )

		return true
	end )
end

if not CLIENT then return end

--- @class TextureToolState
--- @field X number
--- @field Y number

toolsLib.RegisterTool(
	"ren_texture_tool",

	--- @param previousState TextureToolState
	function( previousState )
		local frame = vgui.Create( "HotloadableDFrame" )
		frame:SetTitle( "Texture Tool " )
		frame:SetSize( 1200, 600 )
		frame:Center()
		frame:MakePopup()

		local renderTarget = GetRenderTarget( "ren_texture_tool_rt", 256, 256 )
		local rtMaterial = CreateMaterial( "ren_texture_tool_mat", "UnlitGeneric", {
			["$basetexture"] = renderTarget:GetName()
		} )

		local textureDisplayPanel = frame:Add( "DPanel" )
		textureDisplayPanel:Dock( FILL )
		function textureDisplayPanel:Paint( width, height )
			local zoom = 1
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
			
			local fileName = "c_gdi_gr1_body.dds"
			local file = dDSFileClass.New( fileName, 0 )
			file:Load()

			render.PushRenderTarget( renderTarget )
			render.Clear( 255, 0, 255, 0 )
			render.PopRenderTarget()

			file:CopyLevelToSurface( 1, wW3dFormatEnum.WW3D_FORMAT_A8R8G8B8, file:GetWidth( 1 ), file:GetHeight( 1 ), renderTarget )
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
)

toolsLib.RegisterTool(
	"ren_definition_explorer",

	function( previousState )

		local frame = vgui.Create( "HotloadableDFrame" )
		frame:SetTitle( "Definition Explorer" )
		frame:SetSize( 1200, 600 )
		frame:Center()
		frame:MakePopup()

		local menuBar = vgui.Create( "DMenuBar", frame )
		menuBar:DockMargin( -3, -6, -3, 0 )

		local list = frame:Add( "DListView" )
		list:Dock( FILL )
		list:AddColumn( "ID" )
		list:AddColumn( "Type" )
		list:AddColumn( "Name" )
		list:AddColumn( "Path" )

		--[[ Definition Type Filter ]] do

			-- Get each unique definition class
			local definitionClasses = {}
			for id, definition in pairs( definitionManagerClass.IdToDefinition ) do
				if definitionClasses[definition.Class] == nil then
					definitionClasses[definition.Class] = true
				end
			end

			local definitionTypeMenu = menuBar:AddMenu( "Definition Type" ) --[[@as DMenu]]

			-- The "None" option should re-populate the list with all definitions
			definitionTypeMenu:AddOption( "None", function()
				list:Clear()

				for _, definition in pairs( definitionManagerClass.IdToDefinition ) do
					list:AddLine( definition.Id, definition.Class, definition.Name )
				end
			end )

			-- Add each unique definiiton class to the list and make selecting them re-populate the list with only 
			-- definitions matching that class
			for definitionClass, _ in pairs( definitionClasses ) do
				--- @param panel DMenuOption
				definitionTypeMenu:AddOption( definitionClass, function( panel )
					list:Clear()

					for _, definition in pairs( definitionManagerClass.IdToDefinition ) do
						if definition.Class == panel:GetText() then
							local path = nil
							if definition.Class == "HumanPhysicsDefinitionInstance" then
								--- @cast definition HumanPhysicsDefinitionInstance
								path = definition.ModelName
							end

							local line = list:AddLine( definition.Id, definition.Class, definition.Name, path ) --[[@as DListView_Line]]

							line.OnSelect = function( self )
								local soldier = STATIC.GetPlayerSoldier( LocalPlayer() )
								if soldier == nil then return end

								local definition = definitionManagerClass.FindDefinition( definition.Id )
								if definition == nil then return end

								if definition.Class ~= "SoldierGameObjectDefinitionInstance" then
									return
								end

								--- @cast definition SoldierGameObjectDefinitionInstance
								soldier:ReInit( definition )
							end
						end
					end
				end )
			end
		end

		return frame
end )