-- Based on DialogueOptionClass within Code/Combat/dialogue.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class DialogueOptionClass
--- @field Instance DialogueOptionInstance The metatable used by DialogueOptionInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DialogueOptionClass"

--- @class DialogueOptionInstance
--- @field Static DialogueOptionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_DialogueOption" )
INSTANCE.Class = "DialogueOptionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDialogueOption = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion


--[[ Chunk IDs ]] do

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        VARID_WEIGHT             = enumBuilder:Set( 0 ),
        XXX_VARID_REMARK_TEXT_ID = enumBuilder:Next(),
        VARID_CONVERSATION_ID    = enumBuilder:Next(),
    }
end

--[[ Static Functions and Variables ]] do

    --- @class DialogueOptionClass

    STATIC.CHUNKID_OPTION_VARIABLES = 0x08040528

    --- Creates a new DialogueOptionInstance
    --- @return DialogueOptionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_DialogueOption" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DialogueOptionInstance, `false` otherwise
    function STATIC.IsDialogueOption( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDialogueOption and true or false
    end

    typecheck.RegisterType( "DialogueOptionInstance", STATIC.IsDialogueOption )
end


--- @class DialogueOptionInstance
--- @field Weight number
--- @field ConversationId integer

--- @param src DialogueOptionInstance?
function INSTANCE:Renegade_DialogueOption( src )
    self.Weight = 1
    self.ConversationID = 0

    -- ( src: DialogueOptionInstance )
    if src ~= nil then
        self.Weight = src.Weight
        self.ConversationID = src.ConversationID
    end
end

function INSTANCE:_Renegade_DialogueOption()
    -- Empty in the original code
end

--- @return integer
function INSTANCE:GetConversationId()
	return self.ConversationID
end

--- @return number
function INSTANCE:GetWeight()
    return self.Weight
end

--- @param id integer
function INSTANCE:SetConversationId( id )
	self.ConversationID = id
end

--- @param weight number
function INSTANCE:SetWeight( weight )
	self.Weight = weight
end

--- @param csave ChunkSaveInstance
function INSTANCE:Save( csave )
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
function INSTANCE:Load( cload )
    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()
        if chunkId == STATIC.CHUNKID_OPTION_VARIABLES then
            self:LoadVariables( cload )
        end

        cload:CloseChunk()
    end
end

--- @param cload ChunkLoadInstance
function INSTANCE:LoadVariables( cload )
    local ids = STATIC.ChunkIds
    -- "Loop through all the microchunks that define the variables"
    while cload:OpenMicroChunk() do
        chunkIOClass.ReadMicroChunk( cload, ids.VARID_WEIGHT,          fundamentalDataTypeEnum.Float, self, "Weight" )
        chunkIOClass.ReadMicroChunk( cload, ids.VARID_CONVERSATION_ID, fundamentalDataTypeEnum.Float, self, "ConversationId" )

        cload:CloseMicroChunk()
    end
end
