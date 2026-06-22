-- Based on DialogueClass within Code/Combat/dialogue.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class DialogueClass
--- @field Instance DialogueInstance The metatable used by DialogueInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "DialogueClass"

--- @class DialogueInstance
--- @field Static DialogueClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Dialogue" )
INSTANCE.Class = "DialogueInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsDialogue = true

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum DialogEvents
    STATIC.DIALOG_EVENTS = {
        DIALOG_ON_TAKE_DAMAGE_FROM_FRIEND  = enumBuilder:Set( 0 ),
        DIALOG_ON_TAKE_DAMAGE_FROM_ENEMY   = enumBuilder:Next(),
        DIALOG_ON_DAMAGE_FRIEND            = enumBuilder:Next(),
        DIALOG_ON_DAMAGE_ENEMY             = enumBuilder:Next(),
        DIALOG_ON_KILLED_FRIEND            = enumBuilder:Next(),
        DIALOG_ON_KILLED_ENEMY             = enumBuilder:Next(),
        DIALOG_ON_SAW_FRIEND               = enumBuilder:Next(),
        DIALOG_ON_SAW_ENEMY                = enumBuilder:Next(),
        DIALOG_ON_OBSOLETE_01              = enumBuilder:Next(),
        DIALOG_ON_OBSOLETE_02              = enumBuilder:Next(),
        DIALOG_ON_DIE                      = enumBuilder:Next(),
        DIALOG_ON_POKE_IDLE                = enumBuilder:Next(),
        DIALOG_ON_POKE_SEARCH              = enumBuilder:Next(),
        DIALOG_ON_POKE_COMBAT              = enumBuilder:Next(),
        DIALOG_STATE_FROM_IDLE_TO_COMBAT   = enumBuilder:Next(),
        DIALOG_STATE_FROM_IDLE_TO_SEARCH   = enumBuilder:Next(),
        DIALOG_STATE_FROM_SEARCH_TO_COMBAT = enumBuilder:Next(),
        DIALOG_STATE_FROM_SEARCH_TO_IDLE   = enumBuilder:Next(),
        DIALOG_STATE_FROM_COMBAT_TO_SEARCH = enumBuilder:Next(),
        DIALOG_STATE_FROM_COMBAT_TO_IDLE   = enumBuilder:Next(),
        DIALOG_MAX                         = enumBuilder:Next(),
    }
    local dialogEventsEnum = STATIC.DIALOG_EVENTS

--#endregion

--#region Imports

	--- @type DialogueOptionClass
	local dialogueOptionClass = CNC.Import( "code/combat/dialogue-option.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[ Chunk IDs ]] do

    STATIC.ChunkIds = {
        CHUNKID_OPTION_VARIABLES   = enumBuilder:Set( 0x08040528 ),

        CHUNKID_DIALOGUE_VARIABLES = enumBuilder:Set( 0x08040529 ),
        CHUNKID_DIALOGUE_OPTION    = enumBuilder:Next(),

        VARID_DIALOGUE_SILENCE   = enumBuilder:Set( 0 ),
    }
end


--[[ Static Functions and Variables ]] do

    --- @class DialogueClass

    --- Creates a new DialogueInstance
    --- @return DialogueInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Dialogue" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) DialogueInstance, `false` otherwise
    function STATIC.IsDialogue( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsDialogue and true or false
    end

    typecheck.RegisterType( "DialogueInstance", STATIC.IsDialogue )
end


--- @class DialogueInstance
--- @field OptionList DialogueOptionInstance[]
--- @field SilenceWeight number

--- @param src DialogueInstance?
function INSTANCE:Renegade_Dialogue( src )
    self.SilenceWeight = 1

    -- ( src: DialogueInstance )
    if src ~= nil then
        self.SilenceWeight = src.SilenceWeight
        self.OptionList    = src.OptionList
    end
end

function INSTANCE:_Renegade_Dialogue()
    self:FreeOptions()
end

--- @return DialogueOptionInstance[]
function INSTANCE:GetOptionList()
    return self.OptionList
end

function INSTANCE:FreeOptions()
    self.OptionList = {}
end

--- @return number
function INSTANCE:GetSilenceWeight()
	return self.SilenceWeight
end

--- @param weight number
function INSTANCE:SetSilenceWeight( weight )
	self.SilenceWeight = weight
end

--- @return integer
function INSTANCE:GetConversation()
    local conversationId = 0

    -- "Make a number we can use to index linearly into the option list to determine which one to use"
    local total = self.SilenceWeight
    for index = 1, #self.OptionList do
        total = total + self.OptionList[index]:GetWeight()
    end

    -- "Choose a random value in this linear range"
    local value = math.Rand( 0, total )

    -- "Now find the object this value cooresponds to"
    local count = self.SilenceWeight
    local index = 1
    while value >= count and index <= #self.OptionList do
        conversationId = self.OptionList[index]:GetConversationId()
        count = count + self.OptionList[index]:GetWeight()

        index = index + 1
    end

    return conversationId
end

--- @param csave ChunkSaveInstance
function INSTANCE:Save( csave )
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
function INSTANCE:Load( cload )
    self:FreeOptions()

    local ids = STATIC.ChunkIds

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == ids.CHUNKID_DIALOGUE_VARIABLES then
            self:LoadVariables( cload )

        elseif chunkId == ids.CHUNKID_DIALOGUE_OPTION then
            -- "Create a new option object and add it to the list"
            local option = dialogueOptionClass.New()
            option:Load( cload )
            self.OptionList[#self.OptionList+1] = option
        end

        cload:CloseChunk()
    end
end

--- @param cload ChunkLoadInstance
function INSTANCE:LoadVariables( cload )
    local ids = STATIC.ChunkIds
    -- "Loop through all the microchunks that define the variables"
    while cload:OpenMicroChunk() do
        chunkIOClass.ReadMicroChunk( cload, ids.VARID_DIALOGUE_SILENCE, fundamentalDataTypeEnum.Float, self, "SilenceWeight" )

        cload:CloseMicroChunk()
    end
end
