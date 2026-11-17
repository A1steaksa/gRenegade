-- Based on TdbCategoryClass within Code/wwtranslatedb/tdbcategory.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local persistClass = CNC.Import( "code/wwsaveload/persist.lua" )

--- @class TdbCategoryClass : PersistClass
--- @field Instance TdbCategoryInstance The metatable used by TdbCategoryInstance
local STATIC = CNC.CreateExport( persistClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TdbCategoryClass"

--- @class TdbCategoryInstance : PersistInstance
--- @field Static TdbCategoryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_TdbCategory : Renegade_Persist" )
INSTANCE.Class = "TdbCategoryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsTdbCategory = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type TranslateDbIdsClass
	local translateDbIdsClass = CNC.Import( "code/wwtranslatedb/translate-db-ids.lua" )

	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

local enumBuilder = enumBuilderClass.New()

--[[ Chunk IDs ]] do

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES	= enumBuilder:Set( 0x11221022 ),
        CHUNKID_BASE_CLASS	= enumBuilder:Next(),
    }
end

--[[ Var IDs ]] do

    STATIC.VarIds = {
        VARID_ID	= enumBuilder:Set( 0x01 ),
        VARID_NAME	= enumBuilder:Next()
    }
end


--[[ Static Functions and Variables ]] do

    --- @class TdbCategoryClass

    -- Originally from Code/wwtranslatedb/tdbcategories.h which only contains this `0` value
    STATIC.CATEGORY_DEFAULT = 0

    --- Creates a new TdbCategoryInstance
    --- @return TdbCategoryInstance
    function STATIC.New()
        return robustclass.New( "Renegade_TdbCategory" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) TdbCategoryInstance, `false` otherwise
    function STATIC.IsTdbCategory( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsTdbCategory and true or false
    end

    typecheck.RegisterType( "TdbCategoryInstance", STATIC.IsTdbCategory )

    function STATIC.StaticConstructor()
        STATIC.TdbCategoryPersistFactory = simplePersistFactoryClass.New( STATIC, translateDbIdsClass.ChunkIds.CHUNKID_TDBCATEGORY )
    end
end


--- @class TdbCategoryInstance
--- @field Name string
--- @field Id integer

function INSTANCE:Renegade_TdbCategory()
    self.Id = STATIC.CATEGORY_DEFAULT
end

function INSTANCE:_Renegade_TdbCategory()
    -- Empty in the original code.
end


--[[ From PersistClass ]] do

    --- @return PersistFactoryInstance
    function INSTANCE:GetFactory()
        return STATIC.TdbCategoryPersistFactory
    end

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:Load( cload )
        local ids = STATIC.ChunkIds

        while cload:OpenChunk() do
            local id = cload:CurChunkId()
            if id == ids.CHUNKID_BASE_CLASS then
                persistClass.Instance.Load( self, cload )

            elseif id == ids.CHUNKID_VARIABLES then
                self:LoadVariables( cload )
            end

            cload:CloseChunk()
        end

        return true
    end
end


--[[ Copy Methods ]] do

    --- @return TdbCategoryInstance
    function INSTANCE:Clone()
        typecheck.NotImplementedError()
    end
end


--[[ TDBCategoryClass Specific ]] do

    --- @return string
    function INSTANCE:GetName()
        return self.Name
    end

    --- @param name string
    function INSTANCE:SetName( name )
        self.Name = name
    end

    --- @return integer
    function INSTANCE:GetId()
        return self.Id
    end

    --- @param id integer
    function INSTANCE:SetId( id )
        self.Id = id
    end
end


--- @param csave ChunkSaveInstance
function INSTANCE:SaveVariables( csave )
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
function INSTANCE:LoadVariables( cload )
    while cload:OpenMicroChunk() do
        chunkIOClass.ReadMicroChunk( cload, STATIC.VarIds.VARID_ID, fundamentalDataTypeEnum.UInt32, self, "Id" )
        chunkIOClass.ReadMicroChunkWWString( cload, STATIC.VarIds.VARID_NAME, self, "Name" )

        cload:CloseMicroChunk()
    end
end
