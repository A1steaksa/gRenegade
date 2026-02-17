-- Based on PhysicalGameObj within Code/Combat/physicalgameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DamageableEntityClass
local PARENT = CNC.Import( "code/combat/damageable-entity.lua" )

--- @class PhysicalEntityClass : DamageableEntityClass
--- @field Instance PhysicalEntityInstance The metatable used by PhysicalEntityInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicalEntityClass"
--- @class PhysicalEntityInstance : DamageableEntityInstance
--- @field Static PhysicalEntityClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PhysicalEntity : Renegade_DamageableEntity" )
INSTANCE.Class = "PhysicalEntityInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysicalEntity = true


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

    --- @class PhysicalEntityClass

    --- Creates a new PhysicalEntityInstance
    --- @vararg any
    --- @return PhysicalEntityInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_PhysicalEntity", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicalEntityInstance, `false` otherwise
    function STATIC.IsPhysicalEntity( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicalEntity and true or false
    end

    typecheck.RegisterType( "PhysicalEntityInstance", STATIC.IsPhysicalEntity )
end


--- @class PhysicalEntityInstance

--- Constructs a new PhysicalEntityInstance
--- @vararg any
function INSTANCE:Renegade_PhysicalEntity( ... )
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
