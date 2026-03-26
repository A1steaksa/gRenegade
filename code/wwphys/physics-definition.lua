-- Based on PhysDefClass within Code/wwphys/phys.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DefinitionClass
local definitionClass = CNC.Import( "code/wwsaveload/definition.lua" )

--- @class PhysicsDefinitionClass : DefinitionClass
--- @field Instance PhysicsDefinitionInstance The metatable used by PhysicsDefinitionInstance
local STATIC = CNC.CreateExport( definitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicsDefinitionClass"

--- @class PhysicsDefinitionInstance : DefinitionInstance
--- @field Static PhysicsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PhysicsDefinition" )
INSTANCE.Class = "PhysicsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysicsDefinition = true


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class PhysicsDefinitionClass

    --- Creates a new PhysicsDefinitionInstance
    --- @return PhysicsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PhysicsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicsDefinitionInstance, `false` otherwise
    function STATIC.IsPhysicsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicsDefinition and true or false
    end

    typecheck.RegisterType( "PhysicsDefinitionInstance", STATIC.IsPhysicsDefinition )
end


--- @class PhysicsDefinitionInstance
--- @field ModelName any
--- @field IsPreLit any


function INSTANCE:Renegade_PhysicsDefinition()
    typecheck.NotImplementedError()
end


--[[ From PersistClass ]] do

    function INSTANCE:Save()
        typecheck.NotImplementedError()
    end

    function INSTANCE:Load()
        typecheck.NotImplementedError()
    end
end


--[[ PhysDef Type Filtering Mechanism ]] do

    function INSTANCE:GetTypeName()
        typecheck.NotImplementedError()
    end

    function INSTANCE:IsType()
        typecheck.NotImplementedError()
    end
end


--[[ Validation Methods ]] do

    function INSTANCE:IsValidConfig()
        typecheck.NotImplementedError()
    end
end


--[[ Accessors ]] do

    function INSTANCE:GetModelName()
        typecheck.NotImplementedError()
    end

    function INSTANCE:GetIsPreLit()
        typecheck.NotImplementedError()
    end
end
