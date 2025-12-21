-- Based on SimpleDefinitionFactoryClass within Code/wwsaveload/simpledefinitionfactory.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionFactoryClass
local PARENT = CNC.Import( "renhud/code/wwsaveload/definition-factory.lua" )

--- @class SimpleDefinitionFactoryClass : DefinitionFactoryClass
--- @field instance SimpleDefinitionFactoryInstance The metatable used by SimpleDefinitionFactoryInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "SimpleDefinitionFactoryClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class SimpleDefinitionFactoryInstance : DefinitionFactoryInstance
--- @field Static SimpleDefinitionFactoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SimpleDefinitionFactory : Renegade_DefinitionFactory" )
INSTANCE.Class = "SimpleDefinitionFactoryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSimpleDefinitionFactory = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class SimpleDefinitionFactoryClass

    --- The template data stored prior to instantiation
    --- @class SimpleDefinitionFactoryTemplateData
    --- @field _Class DefinitionClass
    --- @field ChunkId integer
    --- @field Name string
    STATIC.TemplateData = {}

    --- Creates a new SimpleDefinitionFactoryInstance
    --- @param class DefinitionClass
    --- @param classId integer
    --- @param name string
    --- @param isDisplayed boolean? [Default: true]
    --- @return SimpleDefinitionFactoryInstance
    function STATIC.New( class, classId, name, isDisplayed )
        STATIC.TemplateData.Class = class
        STATIC.TemplateData.ClassId = classId
        STATIC.TemplateData.Name = name

        return robustclass.New( "Renegade_SimpleDefinitionFactory", isDisplayed )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SimpleDefinitionFactoryInstance, `false` otherwise
    function STATIC.IsSimpleDefinitionFactory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSimpleDefinitionFactory and true or false
    end

    typecheck.RegisterType( "SimpleDefinitionFactoryInstance", STATIC.IsSimpleDefinitionFactory )
end


--- @class SimpleDefinitionFactoryInstance
--- @field IsDisplayed boolean
--- @field Class DefinitionClass
--- @field ClassId integer
--- @field Name string

--- Constructs a new SimpleDefinitionFactoryInstance
--- @param isDisplayed boolean? [Default: true]
--- @param class DefinitionClass
--- @param classId integer
--- @param name string
function INSTANCE:Renegade_SimpleDefinitionFactory( isDisplayed, class, classId, name )
    self.IsDisplayed = isDisplayed or true
    self._Class = class
    self.ClassId = classId
    self.Name = name
end

--- @return DefinitionInstance
function INSTANCE:Create()
    return self:GetClass().New()
end

--- @return DefinitionClass
function INSTANCE:GetClass()
    -- Load from the template data if it's accessed before the constructor
    if not self._Class then
        self._Class = STATIC.TemplateData.Class
    end

    return self._Class
end

--- @return string
function INSTANCE:GetName()
    -- Load from the template data if it's accessed before the constructor
    if not self.Name then
        self.Name = STATIC.TemplateData.Name
    end

    return self.Name
end

--- @return integer
function INSTANCE:GetClassId()
    -- Load from the template data if it's accessed before the constructor
    if not self.ClassId then
        self.ClassId = STATIC.TemplateData.ClassId
    end

    return self.ClassId
end
