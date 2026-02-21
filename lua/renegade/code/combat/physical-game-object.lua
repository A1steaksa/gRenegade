-- Based on PhysicalGameObj within Code/Combat/physicalgameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DamageableGameObjectClass
local PARENT = CNC.Import( "code/combat/damageable-game-object.lua" )

--- @class PhysicalGameObjectClass : DamageableGameObjectClass
--- @field Instance PhysicalGameObjectInstance The metatable used by PhysicalGameObjectInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicalGameObjectClass"
--- @class PhysicalGameObjectInstance : DamageableGameObjectInstance
--- @field Static PhysicalGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PhysicalGameObject : Renegade_DamageableGameObject" )
INSTANCE.Class = "PhysicalGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysicalGameObject = true



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

    --- @class PhysicalGameObjectClass

    --- Creates a new PhysicalGameObjectInstance
    --- @vararg any
    --- @return PhysicalGameObjectInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_PhysicalGameObject", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicalGameObjectInstance, `false` otherwise
    function STATIC.IsPhysicalGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicalGameObject and true or false
    end

    typecheck.RegisterType( "PhysicalGameObjectInstance", STATIC.IsPhysicalGameObject )
end


--- @class PhysicalGameObjectInstance

--- Constructs a new PhysicalGameObjectInstance
--- @vararg any
function INSTANCE:Renegade_PhysicalGameObject( ... )
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
