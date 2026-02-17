-- Based on VehicleGameObj within Code/Combat/vehicle.cpp

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SmartEntityClass
local PARENT = CNC.Import( "code/combat/smart-entity.lua" )

--- @class VehicleEntityClass : SmartEntityClass
--- @field Instance VehicleEntityInstance The metatable used by VehicleEntityInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "VehicleEntityClass"
--- @class VehicleEntityInstance : SmartEntityInstance
--- @field Static VehicleEntityClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_VehicleEntity : Renegade_SmartEntity" )
INSTANCE.Class = "VehicleEntityInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsVehicleEntity = true


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

    --- @class VehicleEntityClass

    --- Creates a new VehicleEntityInstance
    --- @vararg any
    --- @return VehicleEntityInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_VehicleEntity", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) VehicleEntityInstance, `false` otherwise
    function STATIC.IsVehicleEntity( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsVehicleEntity and true or false
    end

    typecheck.RegisterType( "VehicleEntityInstance", STATIC.IsVehicleEntity )
end


--- @class VehicleEntityInstance

--- Constructs a new VehicleEntityInstance
--- @vararg any
function INSTANCE:Renegade_VehicleEntity( ... )
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
