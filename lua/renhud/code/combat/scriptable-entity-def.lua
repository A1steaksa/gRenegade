-- Based on ScriptableGameObjDef within Code/Combat/scriptablegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type BaseEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/base-entity-def.lua" )

--- @class ScriptableEntityDefClass : BaseEntityDefInstance
local STATIC = CNC.CreateExport()
local CLASS = "ScriptableEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class ScriptableEntityDefInstance : BaseEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_ScriptableEntityDefClass : Renegade_BaseEntityDefClass" )
INSTANCE.IsScriptableEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--[[ Static Functions and Variables ]] do

    --- @class ScriptableEntityDefClass

    --- Creates a new ScriptableEntityDefClass
    --- @vararg any
    --- @return ScriptableEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ScriptableEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ScriptableEntityDefInstance, `false` otherwise
    function STATIC.IsScriptableEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsScriptableEntityDefClass and true or false
    end

    typecheck.RegisterType( "ScriptableEntityDefInstance", STATIC.IsScriptableEntityDefClass )
end


--- @class ScriptableEntityDefInstance

--- Constructs a new ScriptableEntityDefInstance
function INSTANCE:Renegade_ScriptableEntityDefClass()
end

--- @return boolean wasValid, string? errorMessage
function INSTANCE:IsValidConfig()
    typecheck.NotImplementedError()
end