-- Acts as a parent class to enums that require a lot of automatic value manipulation

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class EnumBuilderClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "EnumBuilder"

--- @class EnumBuilderInstance
local INSTANCE = robustclass.Register( "Renegade_EnumBuilder" )
INSTANCE.IsEnumBuilder = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC

--[[ Static Functions and Variables ]] do

    --- @class EnumBuilderClass

    --- Creates a new EnumBaseInstance
    --- @return EnumBuilderInstance
    function STATIC.New()
        return robustclass.New( "Renegade_EnumBuilder" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) EnumBuilderInstance, `false` otherwise
    function STATIC.IsEnumBuilderInstance( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsEnumBuilderInstance and true or false
    end

    typecheck.RegisterType( "EnumBuilderInstance", STATIC.IsEnumBuilderInstance )
end

--- @class EnumBuilderInstance
--- @field NextId integer The ID that will be assigned next

function INSTANCE:Renegade_EnumBuilder()
    INSTANCE.NextId = 0
end

--- @return integer # The ID that should be used by the next enumeration
function INSTANCE:Next()
    local id = INSTANCE.NextId
    INSTANCE.NextId = id + 1
    return id
end

--- @param newId integer The new starting ID
--- @return integer # The new ID to allow for changing the next ID number and assigning that ID to an enumeration
function INSTANCE:Set( newId )
    INSTANCE.NextId = newId
    return self:Next()
end