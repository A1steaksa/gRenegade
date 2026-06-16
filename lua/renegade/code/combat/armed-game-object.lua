-- Based on ArmedGameObj within Code/Combat/armedgameobj.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PhysicalGameObjectClass
local physicalGameObjectClass = CNC.Import( "code/combat/physical-game-object.lua" )

--- @class ArmedGameObjectClass : PhysicalGameObjectClass
--- @field Instance ArmedGameObjectInstance The metatable used by ArmedGameObjectInstance
local STATIC = CNC.CreateExport( physicalGameObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ArmedGameObjectClass"
--- @class ArmedGameObjectInstance : PhysicalGameObjectInstance
--- @field Static ArmedGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ArmedGameObject : Renegade_PhysicalGameObject" )
INSTANCE.Class = "ArmedGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsArmedGameObject = true



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

    --- @class ArmedGameObjectClass

    --- Creates a new ArmedGameObjectInstance
    --- @return ArmedGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ArmedGameObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ArmedGameObjectInstance, `false` otherwise
    function STATIC.IsArmedGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsArmedGameObject and true or false
    end

    typecheck.RegisterType( "ArmedGameObjectInstance", STATIC.IsArmedGameObject )
end


--- @class ArmedGameObjectInstance

--- Constructs a new ArmedGameObjectInstance
function INSTANCE:Renegade_ArmedGameObject()
    physicalGameObjectClass.Instance.Renegade_PhysicalGameObject( self )
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
