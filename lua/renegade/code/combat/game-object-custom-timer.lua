-- Based on GameObjCustomTimerClass within Code/Combat/scriptablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GameObjectCustomTimerClass
--- @field Instance GameObjectCustomTimerInstance The metatable used by GameObjectCustomTimerInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "GameObjectCustomTimerClass"
--- @class GameObjectCustomTimerInstance
--- @field Static GameObjectCustomTimerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_GameObjectCustomTimer" )
INSTANCE.Class = "GameObjectCustomTimerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsGameObjectCustomTimer = true



--#region Imports
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--#region Imported Enums
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_PLACEHOLDER = enumBuilder:Set( 0 ),
        CHUNKID_PLACEHOLDER = enumBuilder:Next(),
    }
end



--[[ Static Functions and Variables ]] do

    --- @class GameObjectCustomTimerClass

    --- Creates a new GameObjectCustomTimerInstance
    --- @param sender ScriptableGameObjectInstance? [Default: nil]
    --- @param time number? [Default: 0]
    --- @param type integer? [Default: 0]
    --- @param param integer? [Default: 0]
    --- @return GameObjectCustomTimerInstance
    function STATIC.New( sender, time, type, param )
        return robustclass.New( "Renegade_GameObjectCustomTimer", sender, time, type, param )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) GameObjectCustomTimerInstance, `false` otherwise
    function STATIC.IsGameObjectCustomTimer( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsGameObjectCustomTimer and true or false
    end

    typecheck.RegisterType( "GameObjectCustomTimerInstance", STATIC.IsGameObjectCustomTimer )
end


--- @class GameObjectCustomTimerInstance
--- @field RemainingTime number
--- @field Sender GameObjectInstance
--- @field Type integer
--- @field Param integer

--- Constructs a new GameObjectCustomTimerInstance
--- @param sender ScriptableGameObjectInstance? [Default: nil]
--- @param time number? [Default: 0]
--- @param type integer? [Default: 0]
--- @param param integer? [Default: 0]
function INSTANCE:Renegade_GameObjectCustomTimer( sender, time, type, param )
    self.RemainingTime = time  or 0
    self.Type          = type  or 0
    self.Param         = param or 0

    if sender then
        self.Sender = sender
    end
end


--[[ Save / Load ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:Load( cload )
        typecheck.NotImplementedError()
    end
end

--- @return boolean
function INSTANCE:Update()
    self.RemainingTime = self.RemainingTime - FrameTime()
    return self.RemainingTime <= 0
end

--- @return boolean
function INSTANCE:Expired()
    return self.RemainingTime <= 0
end
