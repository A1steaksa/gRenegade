-- Based on CCameraProfileClass within Code/Combat/ccamera.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class CommandoCameraProfileClass
--- @field instance CommandoCameraProfileInstance The metatable used by CommandoCameraProfileInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "CommandoCameraProfileClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class CommandoCameraProfileInstance
--- @field Static CommandoCameraProfileClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_CommandoCameraProfile" )
INSTANCE.Class = "CommandoCameraProfileInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsCommandoCameraProfile = true


--[[ Static Functions and Variables ]] do

    --- @class CommandoCameraProfile
    --- @field ProfileHash table<string, CommandoCameraProfileInstance> Key: name, Value: profile

    STATIC.ProfileHash = {}

    --- Creates a new CommandoCameraProfileInstance
    --- @vararg any
    --- @return CommandoCameraProfileInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_CommandoCameraProfile", ... )
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) CommandoCameraProfileInstance, `false` otherwise
    function STATIC.IsCommandoCameraProfile( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsCommandoCameraProfile and true or false
    end

    typecheck.RegisterType( "CommandoCameraProfileInstance", STATIC.IsCommandoCameraProfile )

    function STATIC.Init()
        typecheck.NotImplementedError( "Init" )
    end

    --- @param name string
    --- @return CommandoCameraProfileInstance
    function STATIC.Find( name )
        return STATIC.ProfileHash[ name:lower() ]
    end
end


--- @class CommandoCameraProfileInstance

--- Constructs a new CommandoCameraProfileInstance
--- @vararg any
function INSTANCE:Renegade_CommandoCameraProfile( ... )
    local args = { ... }
    local argCount = select( "#", ... )

    typecheck.AssertArgCount( INSTANCE.Class, argCount )
end

--- @param amount number
function INSTANCE:SetZoom( amount )
    typecheck.NotImplementedError( "SetZoom" )
end

--- @return number
function INSTANCE:GetZoom()
    typecheck.NotImplementedError( "GetZoom" )
end

--- @param height number
function INSTANCE:SetHeight( height )
    typecheck.NotImplementedError( "SetHeight" )
end

--- @return number
function INSTANCE:GetHeight()
    typecheck.NotImplementedError( "GetHeight" )
end

--- @param distance number
function INSTANCE:SetDistance( distance )
    typecheck.NotImplementedError( "SetDistance" )
end

--- @return number
function INSTANCE:GetDistance()
    typecheck.NotImplementedError( "GetDistance" )
end

--- @return number
function INSTANCE:GetFov()
    return self.Fov
end

--- @return number
function INSTANCE:GetViewTilt()
    return self.ViewTilt
end

--- @return number
function INSTANCE:GetTranslationTilt()
    return self.TranslationTilt
end

--- @return number
function INSTANCE:GetTiltTweak()
    return self.TiltTweak
end

--- [[ Protected ]]

--- @class CommandoCameraProfileInstance
--- @field protected Fov number "Field of view for the camera"
--- @field protected Height number "Height above the origin of 'focus' object"
--- @field protected ViewTilt number "Default tilt of the camera"
--- @field protected TiltTweak number "Default tilt tweak of the camera"
--- @field protected TranslationTilt number "Tilt of translation vector for the camera (off of the z axis)"
--- @field protected Distance number "How far back the camera wants to be normally"
--- @field protected Lag Vector "The camera lag"
--- @field protected _ProfilesInitted boolean

INSTANCE._ProfilesInitted = false

--- @param a CommandoCameraProfileInstance
--- @param b CommandoCameraProfileInstance
--- @param lerp number
--- @protected
function INSTANCE:Lerp( a, b, lerp )
    typecheck.NotImplementedError( "Lerp" )
end