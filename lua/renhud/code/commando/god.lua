-- Based on cGod within Code/Commando/god.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GodClass
local STATIC = CNC.CreateExport()
STATIC.Class = "GodClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--- @class GodClass
--- @field State integer
--- @field LevelStartInventory InventoryInstance

function STATIC.Think()
    typecheck.NotImplementedError()
end

--- @param clientId integer
--- @param name string
--- @param teamChoice integer
--- @param clanId integer
--- @param isInvulnerable boolean? [Default: `false`]
function STATIC.CreatePlayer( clientId, name, teamChoice, clanId, isInvulnerable )
    if isInvulnerable == nil then isInvulnerable = false end

    typecheck.NotImplementedError()
end

function STATIC.CreateAiPlayer()
    typecheck.NotImplementedError()
end

--- @param pos Vector
function STATIC.CreateGrunt( pos )
    typecheck.NotImplementedError()
end

function STATIC.Reset()
    typecheck.NotImplementedError()
end

function STATIC.StarKilled()
    typecheck.NotImplementedError()
end

function STATIC.Respawn()
    typecheck.NotImplementedError()
end

function STATIC.Restart()
    typecheck.NotImplementedError()
end

function STATIC.LoadGame()
    typecheck.NotImplementedError()
end

function STATIC.MissionFailed()
    typecheck.NotImplementedError()
end

function STATIC.Exit()
    typecheck.NotImplementedError()
end

--- @param csave ChunkSaveInstance
--- @return boolean
function STATIC.Save( csave )
    typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function STATIC.Load( cload )
    typecheck.NotImplementedError()
end

--- @param soldier SoldierEntityInstance
function STATIC.StoreInventory( soldier )
    typecheck.NotImplementedError()
end

--- @param soldier SoldierEntityInstance
function STATIC.RestoreInventory( soldier )
    typecheck.NotImplementedError()
end

function STATIC.ResetInventory()
    typecheck.NotImplementedError()
end

--- @overload fun( clientId: integer, playerType: integer ): SoldierEntityInstance
--- @overload fun( player: Player ): SoldierEntityInstance
function STATIC.CreateCommando( ... )
    typecheck.NotImplementedError()
end
