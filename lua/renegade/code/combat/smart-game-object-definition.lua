-- Based on SmartGameObjDef within Code/Combat/smartgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type ArmedGameObjectDefinitionClass
local armedGameObjectDefinitionClass = CNC.Import( "code/combat/armed-game-object-definition.lua" )

--- @class SmartGameObjectDefinitionClass : ArmedGameObjectDefinitionClass
local STATIC = CNC.CreateExport( armedGameObjectDefinitionClass )
STATIC.Class = "SmartGameObjectDefinitionClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class SmartGameObjectDefinitionInstance : ArmedGameObjectDefinitionInstance
local INSTANCE = robustclass.Register( "Renegade_SmartGameObjectDefinition : Renegade_ArmedGameObjectDefinition" )
INSTANCE.Class = "SmartGameObjectDefinitionInstance"
INSTANCE.IsSmartGameObjectDefinitionClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC

--#region Imports

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

--[[ Chunk IDs ]] do

    local enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        XXX_CHUNKID_DEF_PHYSICALGAMEOBJ_PARENT              = enumBuilder:Set( 909991656 ),
        CHUNKID_DEF_VARIABLES                               = enumBuilder:Next(),
        CHUNKID_DEF_ARMEDGAMEOBJ_PARENT                     = enumBuilder:Next(),

        MICROCHUNKID_DEF_SIGHT_RANGE                        = enumBuilder:Set( 9 ),
        MICROCHUNKID_DEF_SIGHT_ARC                          = enumBuilder:Next(),
        MICROCHUNKID_DEF_LISTENER_SCALE                     = enumBuilder:Set( 17 ),
        LEGACY_MICROCHUNKID_DEF_INFO_ICON_TEXTURE_FILENAME  = enumBuilder:Next(),
        MICROCHUNKID_DEF_IS_STEALTH_UNIT                    = enumBuilder:Next(),
    }
end

--[[ Static Functions and Variables ]] do

    --- @class SmartGameObjectDefinitionClass

    --- Creates a new SmartGameObjectDefinitionClass
    --- @vararg any
    --- @return SmartGameObjectDefinitionClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_SmartGameObjectDefinition", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SmartGameObjectDefinitionInstance, `false` otherwise
    function STATIC.IsSmartGameObjectDefinitionClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSmartGameObjectDefinitionClass and true or false
    end

    typecheck.RegisterType( "SmartGameObjectDefinitionInstance", STATIC.IsSmartGameObjectDefinitionClass )
end


--- @class SmartGameObjectDefinitionInstance
--- @field SightRange number
--- @field SightArc number
--- @field ListenerScale number
--- @field IsStealthUnit boolean

--- Constructs a new SmartGameObjectDefinitionInstance
function INSTANCE:Renegade_SmartGameObjectDefinition()
    armedGameObjectDefinitionClass.Instance.Renegade_ArmedGameObjectDefinition( self )

    self.SightRange = 0
    self.SightArc = math.rad( 0 )
    self.ListenerScale = 1
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )
    local ids = STATIC.ChunkIds

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == STATIC.ChunkIds.CHUNKID_DEF_ARMEDGAMEOBJ_PARENT then
            armedGameObjectDefinitionClass.Instance.Load( self, cload )
        elseif chunkId == STATIC.ChunkIds.CHUNKID_DEF_VARIABLES then
            while cload:OpenMicroChunk() do
                local didRead =
                    chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SIGHT_RANGE, fundamentalDataTypeEnum.Float, self, "SightRange" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SIGHT_ARC, fundamentalDataTypeEnum.Float, self, "SightArc" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_LISTENER_SCALE, fundamentalDataTypeEnum.Float, self, "ListenerScale" )
                    or chunkIOClass.ReadMicroChunkWWString( cload, ids.LEGACY_MICROCHUNKID_DEF_INFO_ICON_TEXTURE_FILENAME, self, "InfoIconTextureFilename" )
                    or chunkIOClass.ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_IS_STEALTH_UNIT, fundamentalDataTypeEnum.Boolean, self, "IsStealthUnit" )

                if not didRead then
                    section.Print( "Unrecognized " .. INSTANCE.Class .. " Variable Chunk ID", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end
        else
            section.Print( "Unrecognized " .. INSTANCE.Class .. " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    return true
end