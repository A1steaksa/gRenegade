-- Based on SmartGameObj within Code/Combat/smartgameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type ArmedGameObjectClass
local PARENT = CNC.Import( "code/combat/armed-game-object.lua" )

--- @class SmartGameObjectClass : ArmedGameObjectClass
--- @field Instance SmartGameObjectInstance The metatable used by SmartGameObjectInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "SmartGameObjectClass"
--- @class SmartGameObjectInstance : ArmedGameObjectInstance
--- @field Static SmartGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SmartGameObject : Renegade_ArmedGameObject" )
INSTANCE.Class = "SmartGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSmartGameObject = true



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

    --- @class SmartGameObjectClass

    --- Creates a new SmartGameObjectInstance
    --- @vararg any
    --- @return SmartGameObjectInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_SmartGameObject", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SmartGameObjectInstance, `false` otherwise
    function STATIC.IsSmartGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSmartGameObject and true or false
    end

    typecheck.RegisterType( "SmartGameObjectInstance", STATIC.IsSmartGameObject )
end


--- @class SmartGameObjectInstance

--- Constructs a new SmartGameObjectInstance
--- @vararg any
function INSTANCE:Renegade_SmartGameObject( ... )
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
