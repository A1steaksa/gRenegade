-- Based on ControlDefinitionStruct within Code/wwui/dialogparser.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ControlDefinitionClass
--- @field instance ControlDefinitionInstance The metatable used by ControlDefinitionInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "ControlDefinitionClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class ControlDefinitionInstance
--- @field Static ControlDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_ControlDefinition" )
INSTANCE.Class = "ControlDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsControlDefinition = true

--#region Imports

    --- @type DialogParserClass
    local dialogParserClass = CNC.Import( "code/wwui/control-definition.lua" )
--#endregion


--#region Imported Enums

    local controlTypeEnum = dialogParserClass.CONTROL_TYPE
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class ControlDefinitionClass

    --- Creates a new ControlDefinitionInstance
    --- @return ControlDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_ControlDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ControlDefinitionInstance, `false` otherwise
    function STATIC.IsControlDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsControlDefinition and true or false
    end

    typecheck.RegisterType( "ControlDefinitionInstance", STATIC.IsControlDefinition )
end


--- @class ControlDefinitionInstance
--- @field Id integer
--- @field Type ControlType
--- @field Style integer
--- @field X integer
--- @field Y integer
--- @field CX integer
--- @field CY integer
--- @field Title string

--- Constructs a new ControlDefinitionInstance
--- @vararg any
function INSTANCE:Renegade_ControlDefinition()
    self.Id   = 0
    self.Type = controlTypeEnum.Button
    self.X    = 0
    self.Y    = 0
    self.CX   = 0
    self.CY   = 0
end
