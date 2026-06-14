-- Based on GroundStateStruct within Code/wwwphys/phys3.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class GroundStateClass
--- @field Instance GroundStateInstance The metatable used by GroundStateInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "GroundStateClass"

--- @class GroundStateInstance
--- @field Static GroundStateClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_GroundState" )
INSTANCE.Class = "GroundStateInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsGroundState = true


--#region Exported Enums
--#endregion


--#region Imports

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )
--#endregion


--#region Imported Enums

	local w3dSurfaceTypesEnum = w3dFileIds.W3D_SURFACE_TYPES
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class GroundStateClass

    --- Creates a new GroundStateInstance
    --- @return GroundStateInstance
    function STATIC.New()
        return robustclass.New( "Renegade_GroundState" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) GroundStateInstance, `false` otherwise
    function STATIC.IsGroundState( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsGroundState and true or false
    end

    typecheck.RegisterType( "GroundStateInstance", STATIC.IsGroundState )
end


--- @class GroundStateInstance
--- @field IsDirty boolean "Data contained within is invalid"
--- @field OnGround boolean "Indicates whether the object is "on the ground"
--- @field OnDynamicObject boolean "Must 'dirty' the groundstate at end of frame if we're on a [dynamic object]"
--- @field SurfaceType integer "Surface type the object is resting on"
--- @field Height number "Our height above the ground"
--- @field Normal Vector "Normal for the surface"
--- @field Down Vector "Slide direction for the surface"
--- @field GroundObject PhysicsInstance "...the object we are on"
--- @field GroundRenderObject RenderObjectInstance

--- Constructs a new GroundStateInstance
function INSTANCE:Renegade_GroundState()
    self.IsDirty = true
    self.OnGround = false
    self.OnDynamicObject = false
    self.SurfaceType = w3dSurfaceTypesEnum.SURFACE_TYPE_DEFAULT
    self.Height = 0.0
    self.Normal = Vector( 0, 0, 1 )
    self.Down = Vector( 1, 0, 0 )
    self.GroundObject = nil
    self.GroundRenderObject = nil

    self:Reset()
end

function INSTANCE:Reset()
    self.IsDirty = true
    self.OnGround = false
    self.OnDynamicObject = false
    self.SurfaceType = w3dSurfaceTypesEnum.SURFACE_TYPE_DEFAULT
    self.Height = 0.0
    self.Normal = Vector( 0, 0, 1 )
    self.Down = Vector( 1, 0, 0 )
    self.GroundObject = nil
    self.GroundRenderObject = nil
end

--- @param test PhysicsAABoxCollisionTestInstance
--- @param height number
function INSTANCE:InitFromCollisionResult( test, height )
    typecheck.NotImplementedError()
end