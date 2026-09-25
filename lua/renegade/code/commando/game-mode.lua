-- Based on GameModeClass within Code/Commando/gamemode.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GameModeClass
--- @field instance GameModeInstance The metatable used by GameModeInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "GameModeClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class GameModeInstance
--- @field Static GameModeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_GameMode" )
INSTANCE.Class = "GameModeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsGameMode = true


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum GameModeState
    STATIC.GAME_MODE_STATE = {
        GAME_MODE_ACTIVE           = enumBuilder:Set( 0 ),
        GAME_MODE_INACTIVE         = enumBuilder:Next(),
        GAME_MODE_INACTIVE_PENDING = enumBuilder:Next(),
        GAME_MODE_SUSPENDED        = enumBuilder:Next(),
    }
    local gameModeStateEnum = STATIC.GAME_MODE_STATE
--#endregion

--[[ Static Functions and Variables ]] do

    ---"  
    --- Game modes are objects to manager each of the game's modes and sub-modes.
    --- Primarily, each object will provide an Initializing routine to allow it to allocate any
    --- required rresources, a Shutdown routine to allow it to free said resources, and a Think 
    --- routine, whiuch will be called each time through the main loop, allowing the mode to 
    --- perform any necessary periodic tasks.
    ---   
    --- Each mode can be Activated, Deactivated, Suspected, or Resumed  
    ---"  
    --- @class GameModeClass

    --- Creates a new GameModeInstance
    --- @return GameModeInstance
    function STATIC.New()
        return robustclass.New( "Renegade_GameMode" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) GameModeInstance, `false` otherwise
    function STATIC.IsGameMode( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsGameMode and true or false
    end

    typecheck.RegisterType( "GameModeInstance", STATIC.IsGameMode )
end


--- @class GameModeInstance
--- @field protected State GameModeState

--- Constructs a new GameModeInstance
function INSTANCE:Renegade_GameMode()
    -- "Starts off inactive"
    self.State = gameModeStateEnum.GAME_MODE_INACTIVE
end

--- @return GameModeState
function INSTANCE:GetState()
    return self.State
end

--- "Activates the mode"
function INSTANCE:Activate()
    if self.State == gameModeStateEnum.GAME_MODE_INACTIVE then
        self:Init()
        self.State = gameModeStateEnum.GAME_MODE_ACTIVE
    end

    if self.State == gameModeStateEnum.GAME_MODE_INACTIVE_PENDING then
        self.State = gameModeStateEnum.GAME_MODE_ACTIVE
    end
end

--- "Deactivates the mode (don't shutdown until safe)"
function INSTANCE:Deactivate()
    if not self:IsInactive() then
        self.State = gameModeStateEnum.GAME_MODE_INACTIVE_PENDING
    end
end

--- "Shutdown if requested"
function INSTANCE:SafelyDeactivate()
    if self.State == gameModeStateEnum.GAME_MODE_INACTIVE_PENDING then
        self:Shutdown()
        self.State = gameModeStateEnum.GAME_MODE_INACTIVE
    end
end

--- "Suspends the mode from thinking, but does not deactivate it"
function INSTANCE:Suspend()
    if self.State == gameModeStateEnum.GAME_MODE_ACTIVE then
        self.State = gameModeStateEnum.GAME_MODE_SUSPENDED
    end
end

--- "Resumes a suspended mode"
function INSTANCE:Resume()
    if self.State == gameModeStateEnum.GAME_MODE_SUSPENDED then
        self.State = gameModeStateEnum.GAME_MODE_ACTIVE
    end
end

--- @return boolean
function INSTANCE:IsInactive()
    return (
        ( self.State == gameModeStateEnum.GAME_MODE_INACTIVE )
        or ( self.State == gameModeStateEnum.GAME_MODE_INACTIVE_PENDING )
    )
end

--- @return boolean
function INSTANCE:IsSuspended()
    return ( self.State == gameModeStateEnum.GAME_MODE_SUSPENDED )
end

--- @return boolean
function INSTANCE:IsActive()
    return ( self.State == gameModeStateEnum.GAME_MODE_ACTIVE )
end


--[[ The Virtual Functions ]] do

    --- "The name of this mode"
    --- @return string
    function INSTANCE:Name()
        return ""
    end

    -- "Called when the mode is activated"
    function INSTANCE:Init()
    end

    -- "Called when the mode is deactivated"
    function INSTANCE:Shutdown()
    end

    -- "Called each time through the main loop to draw if not inactive"
    function INSTANCE:Render()
    end

    -- "Called each time through the main loop to think if not inactive"
    function INSTANCE:Think()
    end
end
