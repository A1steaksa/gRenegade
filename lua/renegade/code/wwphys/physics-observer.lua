-- Based on PhysObserverClass within Code/wwphys/physobserver.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class PhysicsObserverClass
--- @field Instance PhysicsObserverInstance The metatable used by PhysicsObserverInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicsObserverClass"
--- @class PhysicsObserverInstance
--- @field Static PhysicsObserverClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PhysicsObserver" )
INSTANCE.Class = "PhysicsObserverInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysicsObserver = true


--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- "  
    --- This is an enumeration of possible replies that an observer can make
    --- when it gets a collision event.  
    --- "
    --- @enum CollisionReactionType
    STATIC.COLLISION_REACTION_TYPE = {
        COLLISION_REACTION_DEFAULT     = enumBuilder:Set( 0 ),
        COLLISION_REACTION_STOP_MOTION = enumBuilder:Next(),
        COLLISION_REACTION_NO_BOUNCE   = enumBuilder:Next(),
    }
    local collisionReactionType = STATIC.COLLISION_REACTION_TYPE

    --- "  
    --- This is an enumeration of the responses that the game object can give
    --- when the physics object it is observing is about to expire  
    --- "
    --- @enum ExpirationReactionType
    STATIC.EXPIRATION_REACTION_TYPE = {
        EXPIRATION_DENIED   = enumBuilder:Set( 0 ),
        EXPIRATION_APPROVED = enumBuilder:Next(),
    }
    local expirationReactionType = STATIC.EXPIRATION_REACTION_TYPE
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion

--- "This structure is simply used to package up the information pertaining to a collision"
--- @class CollisionEventStruct
--- @field OtherObject PhysicsInstance "Set to the other object before given to you"
--- @field CollisionResult CastResultStruct "Actual collision data"
--- @field CollidedRenderObject RenderObjectInstance? "Actual render object collided against (may be [nil]!)"

--[[ Static Functions and Variables ]] do

    --- "  
    --- This class defines the interface for an observer of a physics object.  
    --- Each physics object can have a single observer installed into it which
    --- will be notified when certain things occur.  
    --- "  
    --- @class PhysicsObserverClass

    --- Creates a new PhysicsObserverInstance
    --- @return PhysicsObserverInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PhysicsObserver" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicsObserverInstance, `false` otherwise
    function STATIC.IsPhysicsObserver( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicsObserver and true or false
    end

    typecheck.RegisterType( "PhysicsObserverInstance", STATIC.IsPhysicsObserver )
end


--- @class PhysicsObserverInstance

--- @param event CollisionEventStruct
--- @return CollisionReactionType
function INSTANCE:CollisionOccurred( event )
    return collisionReactionType.COLLISION_REACTION_DEFAULT
end

--- @param observedObject PhysicsInstance
--- @return ExpirationReactionType
function INSTANCE:ObjectExpired( observedObject )
    return expirationReactionType.EXPIRATION_APPROVED
end

--- @param observedObject PhysicsInstance
function INSTANCE:ObjectRemovedFromScene( observedObject )
    -- Empty in the original code
end

--- @param observedObject PhysicsInstance
--- @param shatteredObject PhysicsInstance
--- @param surfaceType integer
function INSTANCE:ObjectShatteredSomething( observedObject, shatteredObject, surfaceType )
    -- Empty in the original code
end