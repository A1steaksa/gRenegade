-- Based on ArmedGameObj within Code/Combat/armedgameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PhysicalEntityClass
local PARENT = CNC.Import( "code/combat/physical-entity.lua" )

--- @class ArmedEntityClass : PhysicalEntityClass
--- @field Instance ArmedEntityInstance The metatable used by ArmedEntityInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ArmedEntityClass"
--- @class ArmedEntityInstance : PhysicalEntityInstance
--- @field Static ArmedEntityClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ArmedEntity : Renegade_PhysicalEntity" )
INSTANCE.Class = "ArmedEntityInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsArmedEntity = true


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

    --- @class ArmedEntityClass

    --- Creates a new ArmedEntityInstance
    --- @vararg any
    --- @return ArmedEntityInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_ArmedEntity", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ArmedEntityInstance, `false` otherwise
    function STATIC.IsArmedEntity( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsArmedEntity and true or false
    end

    typecheck.RegisterType( "ArmedEntityInstance", STATIC.IsArmedEntity )
end


--- @class ArmedEntityInstance

--- Constructs a new ArmedEntityInstance
--- @vararg any
function INSTANCE:Renegade_ArmedEntity( ... )
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
