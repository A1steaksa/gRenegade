-- Based on SmartGameObjDef within Code/Combat/smartgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type ArmedEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/armed-entity-def.lua" )

--- @class SmartEntityDefClass : ArmedEntityDefClass
local STATIC = CNC.CreateExport( PARENT )
local CLASS = "SmartEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class SmartEntityDefInstance : ArmedEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_SmartEntityDefClass : Renegade_ArmedEntityDefClass" )
INSTANCE.IsSmartEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC

--#region Imports

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum.lua" )
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

    --- @class SmartEntityDefClass

    --- Creates a new SmartEntityDefClass
    --- @vararg any
    --- @return SmartEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_SmartEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SmartEntityDefInstance, `false` otherwise
    function STATIC.IsSmartEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSmartEntityDefClass and true or false
    end

    typecheck.RegisterType( "SmartEntityDefInstance", STATIC.IsSmartEntityDefClass )
end


--- @class SmartEntityDefInstance
--- @field SightRange number
--- @field SightArc number
--- @field ListenerScale number
--- @field IsStealthUnit boolean

--- Constructs a new SmartEntityDefInstance
function INSTANCE:Renegade_SmartEntityDefClass()
    self.SightRange = 0
    self.SightArc = math.rad( 0 )
    self.ListenerScale = 1
end

--- @param cload ChunkLoadInstance
--- @return boolean true
function INSTANCE:Load( cload )

    Section.Start( CLASS .. " Load Start" )

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
                    Section.Print( "Unrecognized " .. CLASS .. " Variable Chunk ID", cload:CurMicroChunkId() )
                end

                cload:CloseMicroChunk()
            end
        else
            Section.Print( "Unrecognized " .. CLASS .. " Chunk ID", cload:CurChunkId() )
        end

        cload:CloseChunk()
    end

    Section.End()

    return true
end