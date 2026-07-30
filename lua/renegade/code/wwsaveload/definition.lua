-- Based on DefinitionClass within Code/wwsaveload/definition.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

--- @class DefinitionClass : PersistClass
local STATIC = CNC.CreateExport( persistClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DefinitionClass"

--- @class DefinitionInstance : PersistInstance
local INSTANCE = robustclass.Register( "Renegade_Definition : Renegade_Persist" )
INSTANCE.Class = "DefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDefinition = true


--#region Imports

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type DefinitionManagerClass
	local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion


--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES = enumBuilder:Set( 0x00000100 )
    }
end


--[[ Micro-Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.MicroChunkIds = {
        VARID_INSTANCEID     = enumBuilder:Set( 0x01 ),
        XXX_VARID_PARENTID   = enumBuilder:Next(),
        VARID_NAME           = enumBuilder:Next(),
    }
end


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
    persistClass.Instance.Renegade_Persist( self )

    self.Id = 0
    self.SaveEnabled = true
    self.DefinitionManagerLink = -1
end

--[[ Save & Load ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        local retVal = true

        csave:BeginChunk( STATIC.ChunkIds.CHUNKID_VARIABLES )
        retVal = retVal and self:SaveVariables( csave )
        csave:EndChunk()

        return retVal
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean `true`
    function INSTANCE:Load( cload )
        local retVal = true

        while cload:OpenChunk() do
            local chunkId = cload:CurChunkId()
            if chunkId == STATIC.ChunkIds.CHUNKID_VARIABLES then
                self:LoadVariables( cload )
            end

            cload:CloseChunk()
        end

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

        local microIds = STATIC.MicroChunkIds

        local retVal = true

        -- "Loop through all the microchunks that define the variables"
        while cload:OpenMicroChunk() do
            chunkIOClass.ReadMicroChunk( cload, microIds.VARID_INSTANCEID, fundamentalDataTypeEnum.UInt32, self, "Id" )
            chunkIOClass.ReadMicroChunkWWString( cload, microIds.VARID_NAME, self, "Name" )

            cload:CloseMicroChunk()
        end

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
            section.Print( "Register definition!" )
            definitionManagerClass.UnregisterDefinition( self )
            definitionManagerClass.RegisterDefinition( self )
        else
            section.Print( "I'll never register a definition, dad!" )
        end
    end


    --- @param connectedEntity Entity
    --- @return PersistInstance?
    function INSTANCE:Create( connectedEntity )
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

    --- @return boolean, string?
    function INSTANCE:IsValidConfig()
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