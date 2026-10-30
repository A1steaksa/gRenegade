-- Based on RenegadePlayerTerminalClass within Code/Commando/renegadeplayerterminal.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PlayerTerminalClass
local playerTerminalClass = CNC.Import( "code/combat/player-terminal.lua" )

--- @class RenegadePlayerTerminalClass : PlayerTerminalClass
--- @field Instance RenegadePlayerTerminalInstance The metatable used by RenegadePlayerTerminalInstance
local STATIC = CNC.CreateExport( playerTerminalClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "RenegadePlayerTerminalClass"

--- @class RenegadePlayerTerminalInstance : PlayerTerminalInstance
--- @field Static RenegadePlayerTerminalClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_RenegadePlayerTerminal : Renegade_PlayerTerminal" )
INSTANCE.Class = "RenegadePlayerTerminalInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsRenegadePlayerTerminal = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type CNCPurchaseMainMenuClass
	local cNCPurchaseMainMenuClass = CNC.Import( "code/commando/cnc-purchase-main-menu.lua" )

	--- @type PlayerTypeClass
	local playerTypeClass = CNC.Import( "code/combat/player-type.lua" )

	--- @type PlayerTerminalClass
	local playerTerminalClass = CNC.Import( "code/combat/player-terminal.lua" )

	--- @type PurchaseSettingsDefinitionClass
	local purchaseSettingsDefinitionClass = CNC.Import( "code/combat/purchase-settings-definition.lua" )
--#endregion

--#region Imported Enums

	local playerTypeEnum = playerTypeClass.PLAYER_TYPE_ENUM
	local playerTerminalTypeEnum = playerTerminalClass.PLAYER_TERMINAL_TYPE
	local purchaseSettingsTeamEnum = purchaseSettingsDefinitionClass.PURCHASE_SETTINGS_TEAM
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class RenegadePlayerTerminalClass

    --- Creates a new RenegadePlayerTerminalInstance
    --- @return RenegadePlayerTerminalInstance
    function STATIC.New()
        return robustclass.New( "Renegade_RenegadePlayerTerminal" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) RenegadePlayerTerminalInstance, `false` otherwise
    function STATIC.IsRenegadePlayerTerminal( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsRenegadePlayerTerminal and true or false
    end

    typecheck.RegisterType( "RenegadePlayerTerminalInstance", STATIC.IsRenegadePlayerTerminal )
end


--- @class RenegadePlayerTerminalInstance

function INSTANCE:Renegade_RenegadePlayerTerminal()
    STATIC.TheInstance = self
end

function INSTANCE:_Renegade_RenegadePlayerTerminal()
	STATIC.TheInstance = nil
end

--- @param player SoldierGameObjectInstance
--- @param type PlayerTerminalType
function INSTANCE:DisplayTerminal( player, type )
    if player == nil or player:GetPlayerData() == nil then
        return
    end

    -- "Check to ensure this player can access the given terminal"
    if player:GetPlayerType() == playerTypeEnum.GDI and type == playerTerminalTypeEnum.TYPE_GDI then
        self:ShowTerminalDialog( purchaseSettingsTeamEnum.TEAM_GDI )
    elseif player:GetPlayerType() == playerTypeEnum.Nod and type == playerTerminalTypeEnum.TYPE_NOD then
        self:ShowTerminalDialog( purchaseSettingsTeamEnum.TEAM_NOD )
    elseif type == playerTerminalTypeEnum.TYPE_MUTANT then
        -- "Determine what player terminal to display -- GDI mutant or NOD mutant"
        if player:GetPlayerType() == playerTypeEnum.GDI then
            self:ShowTerminalDialog( purchaseSettingsTeamEnum.TEAM_MUTANT_GDI )
        else
            self:ShowTerminalDialog( purchaseSettingsTeamEnum.TEAM_MUTANT_NOD )
        end
    else
        -- "Display a dialog to the user telling them they don't have access to this terminal."
    end
end

--- @param player SoldierGameObjectInstance
function INSTANCE:DisplayDefaultTerminalForPlayer( player )
    if player == nil or player:GetPlayerData() == nil then
        return
    end

    if player:GetPlayerType() == playerTypeEnum.GDI then
        self:ShowTerminalDialog( purchaseSettingsTeamEnum.TEAM_GDI )
    elseif player:GetPlayerType() == playerTypeEnum.Nod then
        self:ShowTerminalDialog( purchaseSettingsTeamEnum.TEAM_NOD )
    end
end

--- @param team PurchaseSettingsTeam
function INSTANCE:ShowTerminalDialog( team )
    -- "Configure the team setting for the dialog"
    local dialog = cNCPurchaseMainMenuClass.New()
    dialog:SetTeam( team )

    -- "Show the dialog"
    dialog:StartDialog()
end
