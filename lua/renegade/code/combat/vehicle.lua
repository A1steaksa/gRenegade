-- Based on VehicleGameObj within Code/Combat/vehicle.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SmartGameObjectClass
local smartGameObjectClass = CNC.Import( "code/combat/smart-game-object.lua" )

--- @class VehicleGameObjectClass : SmartGameObjectClass
--- @field Instance VehicleGameObjectInstance The metatable used by VehicleGameObjectInstance
local STATIC = CNC.CreateExport( smartGameObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "VehicleGameObjectClass"
--- @class VehicleGameObjectInstance : SmartGameObjectInstance
--- @field Static VehicleGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_VehicleGameObject : Renegade_SmartGameObject" )
INSTANCE.Class = "VehicleGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsVehicleGameObject = true


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum PlaceholderName
    STATIC.PLACEHOLDER_NAME = {
        PLACEHOLDER = enumBuilder:Set( 0 ),
        PLACEHOLDER = enumBuilder:Next(),
    }
    local placeholderEnum = STATIC.PLACEHOLDER_NAME
--#endregion


--#region Imports
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

    --- @class VehicleGameObjectClass

    --- Creates a new VehicleGameObjectInstance
    --- @return VehicleGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_VehicleGameObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) VehicleGameObjectInstance, `false` otherwise
    function STATIC.IsVehicleGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsVehicleGameObject and true or false
    end

    typecheck.RegisterType( "VehicleGameObjectInstance", STATIC.IsVehicleGameObject )
end


--- @class VehicleGameObjectInstance

--- Constructs a new VehicleGameObjectInstance
function INSTANCE:Renegade_VehicleGameObject()
    smartGameObjectClass.Instance.Renegade_SmartGameObject( self )

    typecheck.NotImplementedError()
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
