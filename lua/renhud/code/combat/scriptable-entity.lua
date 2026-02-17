-- Based on ScriptableGameObj within Code/Combat/scriptablegameobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type BaseEntityClass
local PARENT = CNC.Import( "code/combat/base-entity.lua" )

--- @class ScriptableEntityClass : BaseEntityClass
--- @field Instance ScriptableEntityInstance The metatable used by ScriptableEntityInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ScriptableEntityClass"
--- @class ScriptableEntityInstance : BaseEntityInstance
--- @field Static ScriptableEntityClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ScriptableEntity : Renegade_BaseEntity" )
INSTANCE.Class = "ScriptableEntityInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsScriptableEntity = true


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

    --- @class ScriptableEntityClass

    --- Creates a new ScriptableEntityInstance
    --- @vararg any
    --- @return ScriptableEntityInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ScriptableEntity", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ScriptableEntityInstance, `false` otherwise
    function STATIC.IsScriptableEntity( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsScriptableEntity and true or false
    end

    typecheck.RegisterType( "ScriptableEntityInstance", STATIC.IsScriptableEntity )
end


--- @class ScriptableEntityInstance

--- Constructs a new ScriptableEntityInstance
--- @vararg any
function INSTANCE:Renegade_ScriptableEntity( ... )
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
