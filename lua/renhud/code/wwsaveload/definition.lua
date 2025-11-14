-- Based on DefinitionClass within Code/wwsaveload/definition.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DefinitionClass
local STATIC = CNC.CreateExport()
local CLASS = "DefinitionInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class DefinitionInstance
local INSTANCE = robustclass.Register( "Renegade_Definition" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDefinition = true

--#region Imports
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class DefinitionClass

    --- Creates a new DefinitionInstance
    --- @return DefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Definition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DefinitionInstance, `false` otherwise
    function STATIC.IsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDefinition and true or false
    end

    typecheck.RegisterType( "DefinitionInstance", STATIC.IsDefinition )
end


--- @class DefinitionInstance
--- @field Name string
--- @field Id integer
--- @field GenericUserData integer
--- @field SaveEnabled boolean
--- @field protected DefinitionManagerLink integer

--- Constructs a new DefinitionInstance
function INSTANCE:Renegade_Definition()
    self.Id = 0
    self.SaveEnabled = true
    self.DefinitionManagerLink = -1
end

--[[ Type Identification ]] do

    --- @return integer
    function INSTANCE:GetClassId()
        return 0
    end

    --- @return integer
    function INSTANCE:GetId()
        return self.Id
    end

    --- @param id integer
    function INSTANCE:SetId( id )
        self.Id = id

        -- "
        -- If we are registered with the definition manager, 
        -- then we need to re-link ourselves back into the list
        -- "
        -- if self.DefinitionManagerLink ~= -1 then
        --     definitionManagerClass:UnregisterDefinition( self )
        --     definitionManagerClass:RegisterDefinition( self )
        -- end
    end

    --- @return DefinitionInstance?
    function INSTANCE:Create()
        return nil
    end
end

--[[ Display Name Methods ]] do

    --- @return string
    function INSTANCE:GetName()
        return self.Name
    end

    --- @param newName string
    function INSTANCE:SetName( newName )
        self.Name = newName
    end
end

--[[ Validation Methods ]] do

    --- @param message string
    function INSTANCE:IsValidConfig( message )
        return true
    end
end

--[[ User Data Support ]] do

    --- @return integer
    function INSTANCE:GetUserData()
        return self.GenericUserData
    end

    --- @param data integer
    function INSTANCE:SetUserData( data )
        self.GenericUserData = data
    end
end

--[[ Save Support ]] do

    --- @return boolean
    function INSTANCE:IsSaveEnabled()
        return self.SaveEnabled
    end

    --- @param isEnabled boolean
    function INSTANCE:EnableSave( isEnabled )
        self.SaveEnabled = isEnabled
    end
end