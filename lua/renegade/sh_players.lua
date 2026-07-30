-- Creates Soldier GameObjects for Players as they spawn

--- @class Renegade
local CNC = CNC_RENEGADE

--#region Imports

	--- @type SoldierGameObjectClass
	local soldierGameObjectClass = CNC.Import( "code/combat/soldier-game-object.lua" )

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )
--#endregion

--#region Imported Enums
--#endregion


hook.Add( "PlayerInitialSpawn", "A1_Renegade_Debug_CreatePlayerSoldiers", function( ply )

	section.Print( "Creating Soldier for Player ", ply:Nick() )

	local definitionId = 81930232

	local definition = definitionManagerClass.FindDefinition( definitionId ) --[[@as SoldierGameObjectDefinitionInstance]]
	if definition == nil then
		section.Error( "Unable to find definition ID ", definitionId, " to create player soldiers " )
		return
	end

    local soldier = soldierGameObjectClass.New()
	soldier:Init( definition, ply )
	soldier:SetControlOwner( ply:IsBot() and -1 or 1 )
end )