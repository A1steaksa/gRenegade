-- Based on BaseGameObj within Code/Combat/basegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local PARENT = CNC.Import( "code/wwsaveload/persist.lua" )

--- @class BaseEntityClass : PersistClass
--- @field Instance BaseEntityInstance The metatable used by BaseEntityInstance
local STATIC = CNC.CreateExport( PARENT )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "BaseEntityClass"

--- @class BaseEntityInstance : PersistInstance
--- @field Static BaseEntityClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BaseEntity : Renegade_Persist" )
INSTANCE.Class = "BaseEntityInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBaseEntity = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion



--[[ Static Functions and Variables ]] do

    --- @class BaseEntityClass

    --- Creates a new BaseEntityInstance
    --- @vararg any
    --- @return BaseEntityInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_BaseEntity", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BaseEntityInstance, `false` otherwise
    function STATIC.IsBaseEntity( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBaseEntity and true or false
    end

    typecheck.RegisterType( "BaseEntityInstance", STATIC.IsBaseEntity )
end


--- @class BaseEntityInstance
--- @field Entity Entity The Garry's Mod Entity that this Renegade Entity represents
--- @field Definition BaseEntityDefInstance "Member data"
--- @field _IsPostThinkAllowed boolean "This is used to prevent postthinking before a think call"
--- @field _EnableCinematicFreeze boolean "This keeps certain object alive during cinematic freeze"

--- Constructs a new BaseEntityInstance
--- @vararg any
function INSTANCE:Renegade_BaseEntity( ... )
    local args = { ... }
    local argCount = select( "#", ... )

end

--[[ Definitions ]] do

    --- @param
    --- @return
    function INSTANCE:Init()
        typecheck.NotImplementedError()
    end

    --- @param
    --- @return
    function INSTANCE:GetDefinition()
        typecheck.NotImplementedError()
    end
end


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


--[[ Thinking ]] do

    function INSTANCE:Think()
        self.IsPostThinkAllowed = true
    end

    function INSTANCE:PostThink()
    end
end


--- @return boolean
function INSTANCE:IsHibernating()
    return false
end


--[[ Type Identification ]] do

    --- @return PhysicalEntityInstance
    function INSTANCE:AsPhysicalEntity()
        return NULL
    end

    --- @return VehicleEntityInstance
    function INSTANCE:AsVehicleEntity()
        return NULL
    end

    --- @return SmartEntityInstance
    function INSTANCE:AsSmartEntity()
        return NULL
    end

    --- @return ScriptableEntityInstance
    function INSTANCE:AsScriptableEntity()
        return NULL
    end
end

--- @return boolean
function INSTANCE:IsPostThinkAllowed()
    return self._IsPostThinkAllowed
end

--- @param isEnabled boolean
function INSTANCE:EnableCinematicFreeze( isEnabled )
    self._EnableCinematicFreeze = isEnabled
end

--- @return boolean
function INSTANCE:IsCinematicFreezeEnabled()
    return self._EnableCinematicFreeze
end
