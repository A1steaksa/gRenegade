-- Based on DamageableGameObj within Code/Combat/damageablegameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ScriptableGameObjectClass
local PARENT = CNC.Import( "code/combat/scriptable-game-object.lua" )

--- @class DamageableGameObjectClass : ScriptableGameObjectClass
--- @field Instance DamageableGameObjectInstance The metatable used by DamageableGameObjectInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DamageableGameObjectClass"
--- @class DamageableGameObjectInstance : ScriptableGameObjectInstance
--- @field Static DamageableGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DamageableGameObject : Renegade_ScriptableGameObject" )
INSTANCE.Class = "DamageableGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDamageableGameObject = true



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

    --- @class DamageableGameObjectClass

    --- Creates a new DamageableGameObjectInstance
    --- @vararg any
    --- @return DamageableGameObjectInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_DamageableGameObject", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DamageableGameObjectInstance, `false` otherwise
    function STATIC.IsDamageableGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDamageableGameObject and true or false
    end

    typecheck.RegisterType( "DamageableGameObjectInstance", STATIC.IsDamageableGameObject )
end


--- @class DamageableGameObjectInstance

--- Constructs a new DamageableGameObjectInstance
--- @vararg any
function INSTANCE:Renegade_DamageableGameObject( ... )
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
