-- Based on ScriptLoader within Code/Combat/scripts.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ScriptLoaderClass
--- @field Instance ScriptLoaderInstance The metatable used by ScriptLoaderInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ScriptLoaderClass"
--- @class ScriptLoaderInstance
--- @field Static ScriptLoaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ScriptLoader" )
INSTANCE.Class = "ScriptLoaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsScriptLoader = true



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

    --- @class ScriptLoaderClass

    --- Creates a new ScriptLoaderInstance
    --- @vararg any
    --- @return ScriptLoaderInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ScriptLoader", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ScriptLoaderInstance, `false` otherwise
    function STATIC.IsScriptLoader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsScriptLoader and true or false
    end

    typecheck.RegisterType( "ScriptLoaderInstance", STATIC.IsScriptLoader )
end


--- @class ScriptLoaderInstance

--- Constructs a new ScriptLoaderInstance
--- @vararg any
function INSTANCE:Renegade_ScriptLoader( ... )
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
