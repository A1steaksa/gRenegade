-- Based on DamageableGameObj within Code/Combat/damageablegameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ScriptableEntityClass
local PARENT = CNC.Import( "code/combat/scriptable-entity.lua" )

--- @class DamageableEntityClass : ScriptableEntityClass
--- @field Instance DamageableEntityInstance The metatable used by DamageableEntityInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DamageableEntityClass"
--- @class DamageableEntityInstance : ScriptableEntityInstance
--- @field Static DamageableEntityClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DamageableEntity : Renegade_ScriptableEntity" )
INSTANCE.Class = "DamageableEntityInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDamageableEntity = true


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

    --- @class DamageableEntityClass

    --- Creates a new DamageableEntityInstance
    --- @vararg any
    --- @return DamageableEntityInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_DamageableEntity", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DamageableEntityInstance, `false` otherwise
    function STATIC.IsDamageableEntity( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDamageableEntity and true or false
    end

    typecheck.RegisterType( "DamageableEntityInstance", STATIC.IsDamageableEntity )
end


--- @class DamageableEntityInstance

--- Constructs a new DamageableEntityInstance
--- @vararg any
function INSTANCE:Renegade_DamageableEntity( ... )
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
