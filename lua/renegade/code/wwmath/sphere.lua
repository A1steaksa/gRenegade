-- Based on SphereClass within Code/WWMath/sphere.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SphereClass
--- @field instance SphereInstance The metatable used by SphereInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "SphereClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class SphereInstance
--- @field Static SphereClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Sphere" )
INSTANCE.Class = "SphereInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSphere = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class SphereClass

    --- Creates a new SphereInstance
    --- @vararg any
    --- @return SphereInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Sphere", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SphereInstance, `false` otherwise
    function STATIC.IsSphere( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSphere and true or false
    end

    typecheck.RegisterType( "SphereInstance", STATIC.IsSphere )
end


--- @class SphereInstance

--- Constructs a new SphereInstance
--- @vararg any
function INSTANCE:Renegade_Sphere( ... )
    local args = { ... }
    local argCount = select( "#", ... )

    
end
