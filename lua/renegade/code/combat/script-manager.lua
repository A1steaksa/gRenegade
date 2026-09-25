-- Based on ScriptManager within Code/Combat/scripts.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ScriptManagerClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ScriptManagerClass"


--#region Imports
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
--#endregion


--#region Imported Enums
--#endregion

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_SCRIPT_ENTRY  = enumBuilder:Set( 131001134 ),
        CHUNKID_SCRIPT_HEADER = enumBuilder:Next(),
        CHUNKID_SCRIPT_DATA   = enumBuilder:Next(),

        MICROCHUNKID_NAME                   = enumBuilder:Set( 1 ),
        MICROCHUNKID_PARAM                  = enumBuilder:Next(),
        MICROCHUNKID_GAME_OBJ_OBSERVER_PTR  = enumBuilder:Next(),
        MICROCHUNKID_OWNER_PTR              = enumBuilder:Next(),
        MICROCHUNKID_ID                     = enumBuilder:Next(),
    }
end


--- @class ScriptManagerClass
--- @field _EnableScriptCreation boolean

function STATIC.Init()
    typecheck.NotImplementedError()
end

function STATIC.Shutdown()
    typecheck.NotImplementedError()
end

--- "Create a script.  Add to the active list"
--- @param scriptName string
--- @return ScriptInstance
function STATIC.CreateScript( scriptName )
    typecheck.NotImplementedError()
end

--- "Add Script to the Destroy List"
--- @param script ScriptInstance
function STATIC.RequestDestroyScript( script )
    typecheck.NotImplementedError()
end

--- @param
function STATIC.DestroyPending()
    typecheck.NotImplementedError()
end


--[[ Save / Load ]] do

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
end

--- @param isScriptCreationEnabled boolean
function STATIC.EnableScriptCreation( isScriptCreationEnabled )
    STATIC._EnableScriptCreation = isScriptCreationEnabled
end

--- @param dllFileName string
function STATIC.LoadScripts( dllFileName )
    typecheck.NotImplementedError()
end