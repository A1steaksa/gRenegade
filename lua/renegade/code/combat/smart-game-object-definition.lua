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
local INSTANCE = robustclass.Register( "Renegade_SmartGameObjectDefinitionClass : Renegade_ArmedGameObjectDefinitionClass" )
INSTANCE.Class = "SmartGameObjectDefinitionInstance"
INSTANCE.IsSmartGameObjectDefinitionClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC

--#region Imports

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
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
        return robustclass.New( "Renegade_SmartGameObjectDefinitionClass", ... )
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
function INSTANCE:Renegade_SmartGameObjectDefinitionClass()
    self.SightRange = 0
    self.SightArc = math.rad( 0 )
    self.ListenerScale = 1
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )

    Section.Start( "Loading " .. INSTANCE.Class )

    local ids = STATIC.ChunkIds
    local dataTypeEnum = STATIC.DATA_TYPE

    while cload:OpenChunk() do
        local chunkId = cload:CurChunkId()

        if chunkId == STATIC.ChunkIds.CHUNKID_DEF_ARMEDGAMEOBJ_PARENT then
            PARENT.Instance.Load( self, cload )
        elseif chunkId == STATIC.ChunkIds.CHUNKID_DEF_VARIABLES then
            while cload:OpenMicroChunk() do
                local didRead =
                    self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SIGHT_RANGE, dataTypeEnum.Float, "SightRange" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_SIGHT_ARC, dataTypeEnum.Float, "SightArc" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_LISTENER_SCALE, dataTypeEnum.Float, "ListenerScale" )
                    or self:ReadMicroChunkWWString( cload, ids.LEGACY_MICROCHUNKID_DEF_INFO_ICON_TEXTURE_FILENAME, "InfoIconTextureFilename" )
                    or self:ReadMicroChunk( cload, ids.MICROCHUNKID_DEF_IS_STEALTH_UNIT, dataTypeEnum.Boolean, "IsStealthUnit" )

                if not didRead then
                    Section.Print( "Unrecognized " .. INSTANCE.Class .. " Variable Chunk ID", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end
        else
            Section.Print( "Unrecognized " .. INSTANCE.Class .. " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    Section.End()

    return true
end