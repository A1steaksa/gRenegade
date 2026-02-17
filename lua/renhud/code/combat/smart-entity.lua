-- Based on SmartGameObj within Code/Combat/smartgameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ArmedEntityClass
local PARENT = CNC.Import( "code/combat/armed-entity.lua" )

--- @class SmartEntityClass : ArmedEntityClass
--- @field Instance SmartEntityInstance The metatable used by SmartEntityInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SmartEntityClass"
--- @class SmartEntityInstance : ArmedEntityInstance
--- @field Static SmartEntityClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SmartEntity : Renegade_ArmedEntity" )
INSTANCE.Class = "SmartEntityInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSmartEntity = true


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

    --- @class SmartEntityClass

    --- Creates a new SmartEntityInstance
    --- @vararg any
    --- @return SmartEntityInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_SmartEntity", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SmartEntityInstance, `false` otherwise
    function STATIC.IsSmartEntity( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSmartEntity and true or false
    end

    typecheck.RegisterType( "SmartEntityInstance", STATIC.IsSmartEntity )
end


--- @class SmartEntityInstance

--- Constructs a new SmartEntityInstance
--- @vararg any
function INSTANCE:Renegade_SmartEntity( ... )
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
