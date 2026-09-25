-- Based on ScriptSaver within Code/Combat/scripts.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ScriptSaverClass
--- @field Instance ScriptSaverInstance The metatable used by ScriptSaverInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ScriptSaverClass"
--- @class ScriptSaverInstance
--- @field Static ScriptSaverClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ScriptSaver" )
INSTANCE.Class = "ScriptSaverInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsScriptSaver = true



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

    --- @class ScriptSaverClass

    --- Creates a new ScriptSaverInstance
    --- @vararg any
    --- @return ScriptSaverInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ScriptSaver", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ScriptSaverInstance, `false` otherwise
    function STATIC.IsScriptSaver( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsScriptSaver and true or false
    end

    typecheck.RegisterType( "ScriptSaverInstance", STATIC.IsScriptSaver )
end


--- @class ScriptSaverInstance

--- Constructs a new ScriptSaverInstance
--- @vararg any
function INSTANCE:Renegade_ScriptSaver( ... )
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
