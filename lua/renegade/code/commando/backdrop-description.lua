-- Based on BackdropDescriptionStruct within Code/Commando/campaign.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class BackdropDescriptionClass
--- @field instance BackdropDescriptionInstance The metatable used by BackdropDescriptionInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "BackdropDescriptionClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class BackdropDescriptionInstance
--- @field Static BackdropDescriptionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_BackdropDescription" )
INSTANCE.Class = "BackdropDescriptionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsBackdropDescription = true

--[[ Static Functions and Variables ]] do

    --- @class BackdropDescriptionClass

    --- Creates a new BackdropDescriptionInstance
    --- @return BackdropDescriptionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_BackdropDescription" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) BackdropDescriptionInstance, `false` otherwise
    function STATIC.IsBackdropDescription( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsBackdropDescription and true or false
    end

    typecheck.RegisterType( "BackdropDescriptionInstance", STATIC.IsBackdropDescription )
end


--- @class BackdropDescriptionInstance
--- @field State integer
--- @field Lines string[]

--- Constructs a new BackdropDescriptionInstance
function INSTANCE:Renegade_BackdropDescription()
    INSTANCE.State = 0
    INSTANCE.Lines = {}
end
