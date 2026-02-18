-- Based on ScriptableGameObj within Code/Combat/scriptablegameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type BaseGameObjectClass
local PARENT = CNC.Import( "code/combat/base-game-object.lua" )

--- @class ScriptableGameObjectClass : BaseGameObjectClass
--- @field Instance ScriptableGameObjectInstance The metatable used by ScriptableGameObjectInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ScriptableGameObjectClass"
--- @class ScriptableGameObjectInstance : BaseGameObjectInstance
--- @field Static ScriptableGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ScriptableGameObject : Renegade_BaseGameObject" )
INSTANCE.Class = "ScriptableGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsScriptableGameObject = true



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

    --- @class ScriptableGameObjectClass

    --- Creates a new ScriptableGameObjectInstance
    --- @vararg any
    --- @return ScriptableGameObjectInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ScriptableGameObject", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ScriptableGameObjectInstance, `false` otherwise
    function STATIC.IsScriptableGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsScriptableGameObject and true or false
    end

    typecheck.RegisterType( "ScriptableGameObjectInstance", STATIC.IsScriptableGameObject )
end


--- @class ScriptableGameObjectInstance

--- Constructs a new ScriptableGameObjectInstance
--- @vararg any
function INSTANCE:Renegade_ScriptableGameObject( ... )
    local args = { ... }
    local argCount = select( "#", ... )

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
