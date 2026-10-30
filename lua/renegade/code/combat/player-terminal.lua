-- Based on PlayerTerminalClass within Code/Combat/playerterminal.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class PlayerTerminalClass
--- @field Instance PlayerTerminalInstance The metatable used by PlayerTerminalInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PlayerTerminalClass"

--- @class PlayerTerminalInstance
--- @field Static PlayerTerminalClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PlayerTerminal" )
INSTANCE.Class = "PlayerTerminalInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPlayerTerminal = true

--#region Exported Enums

    --- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum PlayerTerminalType
    STATIC.PLAYER_TERMINAL_TYPE = {
        TYPE_NONE   = enumBuilder:Set( -1 ),
        TYPE_GDI    = enumBuilder:Set( 0 ),
        TYPE_NOD    = enumBuilder:Next(),
        TYPE_MUTANT = enumBuilder:Next()
    }
    local playerTerminalTypeEnum = STATIC.PLAYER_TERMINAL_TYPE
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class PlayerTerminalClass
	--- @field TheInstance PlayerTerminalInstance

    --- Creates a new PlayerTerminalInstance
    --- @return PlayerTerminalInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PlayerTerminal" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PlayerTerminalInstance, `false` otherwise
    function STATIC.IsPlayerTerminal( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPlayerTerminal and true or false
    end

    typecheck.RegisterType( "PlayerTerminalInstance", STATIC.IsPlayerTerminal )

    function STATIC.StaticConstructor()
        STATIC.TheInstance = STATIC.New()
    end

	function STATIC.GetInstance()
        return STATIC.TheInstance
	end
end


--- @class PlayerTerminalInstance

function INSTANCE:_Renegade_PlayerTerminal()
    -- Empty in the original code
end

--- @param player SoldierGameObjectInstance
--- @param type PlayerTerminalType
function INSTANCE:DisplayTerminal( player, type )
	-- Empty in the original code
end

--- @param player SoldierGameObjectInstance
function INSTANCE:DisplayDefaultTerminalForPlayer( player )
	-- Empty in the original code
end
