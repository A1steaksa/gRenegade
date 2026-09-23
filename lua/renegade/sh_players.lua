-- Create and manages Soldier GameObjects for Players

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class PlayerLib
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PlayerLib"

--#region Exported Enums
--#endregion

--#region Imports

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

	--- @type RenderInfoClass
	local renderInfoClass = CNC.Import( "code/ww3d2/render-info.lua" )

	--- @type CombatManagerClass
	local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

	--- @type GameObjectManagerClass
	local gameObjectManagerClass = CNC.Import( "code/combat/game-object-manager.lua" )
--#endregion

--#region Imported Enums
--#endregion


--- @class PlayerLib

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

if not CLIENT then return end

function STATIC.RenderPlayerSoldiers()
	local renderInfo = renderInfoClass.New( combatManagerClass.GetCamera() )

	for ply, soldier in pairs( STATIC.PlayerSoldiers ) do
		local physicsObject = soldier.PhysicsObject
		if physicsObject == nil then return end

		local model = physicsObject.Model
		if model == nil then return end

		model:SetLodLevel( 4 )
		model:Render( renderInfo )
	end
end

function STATIC.SuppressDefaultPlayerRendering( ply )
	local soldier = STATIC.GetPlayerSoldier( ply )
	if soldier == nil then return end

	local physicsObject = soldier.PhysicsObject
	if physicsObject == nil then return end

	local model = physicsObject.Model
	if model == nil then return end

	return true
end

hook.Add( "PrePlayerDraw", "A1_Renegade_RenderPlayerSoldiers", STATIC.SuppressDefaultPlayerRendering )

hook.Add( "PostDrawTranslucentRenderables", "A1_Renegade_RenderPlayerSoldiers", STATIC.RenderPlayerSoldiers )
