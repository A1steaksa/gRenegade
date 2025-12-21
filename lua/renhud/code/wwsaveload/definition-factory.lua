-- Based on DefinitionFactoryClass within Code/wwsaveload/definitionfactory.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DefinitionFactoryClass
--- @field instance DefinitionFactoryInstance The metatable used by DefinitionFactoryInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "DefinitionFactoryClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class DefinitionFactoryInstance
--- @field Static DefinitionFactoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DefinitionFactory" )
INSTANCE.Class = "DefinitionFactoryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDefinitionFactory = true


--#region Exported Enums
--#endregion


--#region Imports

    --- @type DefinitionFactoryManagerClass
    local definitionFactoryManager = CNC.Import( "renhud/code/wwsaveload/definition-factory-manager.lua" )
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- "  
    --- Definition factories act as virtual constructors for object definitions.
    --- They are responsible for creating new definitions for a particular class of objects.  
    --- "
    --- @class DefinitionFactoryClass

    --- Creates a new DefinitionFactoryInstance
    --- @vararg any
    --- @return DefinitionFactoryInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DefinitionFactory" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DefinitionFactoryInstance, `false` otherwise
    function STATIC.IsDefinitionFactory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDefinitionFactory and true or false
    end

    typecheck.RegisterType( "DefinitionFactoryInstance", STATIC.IsDefinitionFactory )
end

--- @class DefinitionFactoryInstance

--- Constructs a new DefinitionFactoryInstance
function INSTANCE:Renegade_DefinitionFactory()
    definitionFactoryManager.RegisterFactory( self )
end

--- @return DefinitionInstance
function INSTANCE:Create()
end

--- @return string
function INSTANCE:GetName()
end

--- @return integer
function INSTANCE:GetClassId()
end

--- @return boolean
function INSTANCE:IsDisplayed()
end


