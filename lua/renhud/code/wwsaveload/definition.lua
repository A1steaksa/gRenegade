-- Based on DefinitionClass within Code/wwsaveload/definition.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- Parent
--- @type PersistClass
local parent = CNC.Import( "renhud/code/wwsaveload/persist.lua" )

--- @class DefinitionClass : PersistClass
local STATIC = CNC.CreateExport( parent )
local CLASS = "DefinitionInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class DefinitionInstance : PersistInstance
local INSTANCE = robustclass.Register( "Renegade_Definition : Renegade_Persist" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDefinition = true


--#region Imports

    --- @type DefinitionManagerClass
    local definitionManagerClass = CNC.Import( "renhud/code/wwsaveload/definition-manager.lua" )
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class DefinitionClass

    --[[ Internal Chunk IDs ]] do

        STATIC.CHUNKID_VARIABLES = 0x00000100
    end

    --[[ Micro-Chunk IDs ]] do

        STATIC.VARID_INSTANCEID     = 0x01
        STATIC.XXX_VARID_PARENTID   = STATIC.VARID_INSTANCEID   + 1
        STATIC.VARID_NAME           = STATIC.XXX_VARID_PARENTID + 1
    end

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

--[[ Save & Load ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        local retVal = true

        csave:BeginChunk( STATIC.CHUNKID_VARIABLES )
        retVal = retVal and self:SaveVariables( csave )
        csave:EndChunk()

        return retVal
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean `true`
    function INSTANCE:Load( cload )
        Section.Start( CLASS .. " Load Start" )

        local retVal = true

        while cload:OpenChunk() do
            local chunkId = cload:CurChunkId()

            if chunkId == STATIC.CHUNKID_VARIABLES then
                self:LoadVariables( cload )
            end

            cload:CloseChunk()
        end

        Section.End()

        return retVal
    end

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:SaveVariables( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:LoadVariables( cload )

        Section.Start( "Loading Variables..." )

        local retVal = true

        -- "Loop through all the microchunks that define the variables"
        while cload:OpenMicroChunk() do
            self:ReadMicroChunk( cload, STATIC.VARID_INSTANCEID, STATIC.DATA_TYPE.UInt32, "Id" )
            self:ReadMicroChunkWWString( cload, STATIC.VARID_NAME, "Name" )

            cload:CloseMicroChunk()
        end

        Section.End()

        return retVal
    end
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
        if self.DefinitionManagerLink ~= -1 then
            Section.Print( "Register definition!" )
            definitionManagerClass.UnregisterDefinition( self )
            definitionManagerClass.RegisterDefinition( self )
        else
            Section.Print( "I'll never register a definition, dad!" )
        end
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