-- Based on ScriptClass within Code/Combat/scriptevents.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type GameObjectObserverClass
local gameObjectObserverClass = CNC.Import( "code/combat/game-object-observer.lua" )

--- @class ScriptClass : GameObjectObserverClass
--- @field Instance ScriptInstance The metatable used by ScriptInstance
local STATIC = CNC.CreateExport( gameObjectObserverClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ScriptClass"
--- @class ScriptInstance : GameObjectObserverInstance
--- @field Static ScriptClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Script : Renegade_GameObjectObserver" )
INSTANCE.Class = "ScriptInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsScript = true


--[[ Static Functions and Variables ]] do

    --- @class ScriptClass

    --- Creates a new ScriptInstance
    --- @return ScriptInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Script" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ScriptInstance, `false` otherwise
    function STATIC.IsScript( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsScript and true or false
    end

    typecheck.RegisterType( "ScriptInstance", STATIC.IsScript )
end


--- @class ScriptInstance

function INSTANCE:Renegade_Script()
    gameObjectObserverClass.Instance.Renegade_GameObjectObserver( self )
end

function INSTANCE:_Renegade_Script()
    typecheck.NotImplementedError()
end

--- @return GameObjectInstance
function INSTANCE:Owner()
end

-- Omitted GetOwnerPointer function

--- @param param string
function INSTANCE:SetParametersString( param )
end

--- @return string
function INSTANCE:GetParametersString()
end


--[[ Save / Load Specific Script ]] do

    --- @param saver ScriptSaverInstance
    --- @return boolean
    function INSTANCE:Save( saver )
        typecheck.NotImplementedError()
    end

    --- @param loader ScriptLoaderInstance
    --- @return boolean
    function INSTANCE:Load( loader )
        typecheck.NotImplementedError()
    end
end
