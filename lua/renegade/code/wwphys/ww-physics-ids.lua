-- Based on the enums within Code/wwphys/wwphysids.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class WWPhysicsIds
local STATIC = CNC.CreateExport()


--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type SaveLoadIds
	local saveLoadIds = CNC.Import( "code/wwsaveload/save-load-ids.lua" )

    --- @type DefinitionClassIds
    local definitionClassIds = CNC.Import( "code/wwsaveload/definition-class-ids.lua" )
--#endregion

--#region Imported Enums

    local saveLoadIds = saveLoadIds.ChunkIds
    local classIds = definitionClassIds.CLASS_ID
--#endregion

--#region Exported Enums

    local enumBuilder = enumBuilderClass.New()

    --- "  
    --- Persist Factory ID's for WWPHYS
    --- NOTE: It is important that *NONE* of these ID's are ever changed!
    --- "  
    --- @enum WWPhysicsFactoryId
    STATIC.WW_PHYSICS_FACTORY_ID = {
        -- "Sub-System chunk id's"
        PHYSICS_CHUNKID_STATIC_DATA_SUBSYSTEM    = enumBuilder:Set( saveLoadIds.CHUNKID_WWPHYS_BEGIN ),
        PHYSICS_CHUNKID_STATIC_OBJECTS_SUBSYSTEM = enumBuilder:Next(),
        PHYSICS_CHUNKID_DYNAMIC_DATA_SUBSYSTEM   = enumBuilder:Set( saveLoadIds.CHUNKID_WWPHYS_BEGIN + 0x50 ),

        -- "Individual persist object chunk Id's"
        PHYSICS_CHUNKID_DECORATIONPHYS      = enumBuilder:Set( saveLoadIds.CHUNKID_WWPHYS_BEGIN + 0x100 ),
        PHYSICS_CHUNKID_HUMANPHYS           = enumBuilder:Next(),
        PHYSICS_CHUNKID_LIGHTPHYS           = enumBuilder:Next(),
        PHYSICS_CHUNKID_MOTORCYCLE          = enumBuilder:Next(),
        PHYSICS_CHUNKID_MOTORVEHICLE        = enumBuilder:Next(),
        PHYSICS_CHUNKID_PHYS3               = enumBuilder:Next(),
        PHYSICS_CHUNKID_PROJECTILE          = enumBuilder:Next(),
        PHYSICS_CHUNKID_RENDEROBJPHYS       = enumBuilder:Next(),
        PHYSICS_CHUNKID_RIGIDBODY           = enumBuilder:Next(),
        PHYSICS_CHUNKID_STATICPHYS          = enumBuilder:Next(),
        PHYSICS_CHUNKID_WHEELEDVEHICLE      = enumBuilder:Next(),
        PHYSICS_CHUNKID_STATICANIMPHYS      = enumBuilder:Next(),
        PHYSICS_CHUNKID_TIMEDDECORATIONPHYS = enumBuilder:Next(),
        PHYSICS_CHUNKID_VEHICLEPHYS         = enumBuilder:Next(),
        PHYSICS_CHUNKID_TRACKEDVEHICLE      = enumBuilder:Next(),
        PHYSICS_CHUNKID_VTOLVEHICLE         = enumBuilder:Next(),
        PHYSICS_CHUNKID_WAYPATH             = enumBuilder:Next(),
        PHYSICS_CHUNKID_WAYPOINT            = enumBuilder:Next(),
        PHYSICS_CHUNKID_DYNAMICANIMPHYS     = enumBuilder:Next(),
        PHYSICS_CHUNKID_SHAKEABLESTATICPHYS = enumBuilder:Next(),
        PHYSICS_CHUNKID_ACCESSIBLEPHYS      = enumBuilder:Next(),

        -- "Definition object chunk id's"
        PHYSICS_CHUNKID_DECOPHYSDEF            = enumBuilder:Set( saveLoadIds.CHUNKID_WWPHYS_BEGIN + 0x500 ),
        PHYSICS_CHUNKID_HUMANPHYSDEF           = enumBuilder:Next(),
        PHYSICS_CHUNKID_LIGHTPHYSDEF           = enumBuilder:Next(),
        PHYSICS_CHUNKID_MOTORCYCLEDEF          = enumBuilder:Next(),
        PHYSICS_CHUNKID_MOTORVEHICLEDEF        = enumBuilder:Next(),
        PHYSICS_CHUNKID_PHYS3DEF               = enumBuilder:Next(),
        PHYSICS_CHUNKID_PROJECTILEDEF          = enumBuilder:Next(),
        PHYSICS_CHUNKID_RIGIDBODYDEF           = enumBuilder:Next(),
        PHYSICS_CHUNKID_STATICPHYSDEF          = enumBuilder:Next(),
        PHYSICS_CHUNKID_WHEELEDVEHICLEDEF      = enumBuilder:Next(),
        PHYSICS_CHUNKID_STATICANIMPHYSDEF      = enumBuilder:Next(),
        PHYSICS_CHUNKID_TIMEDDECOPHYSDEF       = enumBuilder:Next(),
        PHYSICS_CHUNKID_VEHICLEPHYSDEF         = enumBuilder:Next(),
        PHYSICS_CHUNKID_TRACKEDVEHICLEDEF      = enumBuilder:Next(),
        PHYSICS_CHUNKID_VTOLVEHICLEDEF         = enumBuilder:Next(),
        PHYSICS_CHUNKID_DYNAMICANIMPHYSDEF     = enumBuilder:Next(),
        PHYSICS_CHUNKID_SHAKEABLESTATICPHYSDEF = enumBuilder:Next(),
        PHYSICS_CHUNKID_ACCESSIBLEPHYSDEF      = enumBuilder:Next(),

        -- "External persist object chunk id's"
        PHYSICS_CHUNKID_DOORPHYS             = enumBuilder:Set( saveLoadIds.CHUNKID_WWPHYS_BEGIN + 0xA00 ),
        PHYSICS_CHUNKID_ELEVATORPHYS         = enumBuilder:Next(),
        PHYSICS_CHUNKID_DAMAGEABLESTATICPHYS = enumBuilder:Next(),
        PHYSICS_CHUNKID_BUILDINGAGGREGATE    = enumBuilder:Next(),

        -- "External persist object def chunk id's"
        PHYSICS_CHUNKID_DOORPHYSDEF             = enumBuilder:Set( saveLoadIds.CHUNKID_WWPHYS_BEGIN + 0xC00 ),
        PHYSICS_CHUNKID_ELEVATORPHYSDEF         = enumBuilder:Next(),
        PHYSICS_CHUNKID_DAMAGEABLESTATICPHYSDEF = enumBuilder:Next(),
        PHYSICS_CHUNKID_BUILDINGAGGREGATEDEF    = enumBuilder:Next(),
    }

    --- "DefinitionClass ClassID's for WWPHYS"
    --- @enum WWPhysicsDefinitionId
    STATIC.WW_PHYSICS_DEFINITION_ID = {
        CLASSID_DECOPHYSDEF            = enumBuilder:Set( classIds.PHYSICS ),
        CLASSID_HUMANPHYSDEF           = enumBuilder:Next(),
        CLASSID_MOTORCYCLEDEF          = enumBuilder:Next(),
        CLASSID_MOTORVEHICLEDEF        = enumBuilder:Next(),
        CLASSID_PHYS3DEF               = enumBuilder:Next(),
        CLASSID_RIGIDBODYDEF           = enumBuilder:Next(),
        CLASSID_WHEELEDVEHICLEDEF      = enumBuilder:Next(),
        CLASSID_STATICPHYSDEF          = enumBuilder:Next(),
        CLASSID_STATICANIMPHYSDEF      = enumBuilder:Next(),
        CLASSID_PROJECTILEDEF          = enumBuilder:Next(),
        CLASSID_TIMEDDECOPHYSDEF       = enumBuilder:Next(),
        CLASSID_VEHICLEPHYSDEF         = enumBuilder:Next(),
        CLASSID_TRACKEDVEHICLEDEF      = enumBuilder:Next(),
        CLASSID_VTOLVEHICLEDEF         = enumBuilder:Next(),
        CLASSID_DYNAMICANIMPHYSDEF     = enumBuilder:Next(),
        CLASSID_SHAKEABLESTATICPHYSDEF = enumBuilder:Next(),
        CLASSID_ACCESSIBLEPHYSDEF      = enumBuilder:Next(),

        -- "External"
        CLASSID_DOORPHYSDEF             = enumBuilder:Set( classIds.PHYSICS + 0x80 ),
        CLASSID_ELEVATORPHYSDEF         = enumBuilder:Next(),
        CLASSID_DAMAGEABLESTATICPHYSDEF = enumBuilder:Next(),
        CLASSID_BUILDINGAGGREGATEDEF    = enumBuilder:Next(),
    }
--#endregion
