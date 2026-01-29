-- Based on Objective within Code/Combat/objectives.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- An objective that will appear in multiple places on the HUD
--- @class ObjectiveClass
--- @field Instance ObjectiveInstance The metatable used by ObjectiveInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "ObjectiveClass"
local isHotload = not table.IsEmpty( STATIC )

--- An objective that will appear in multiple places on the HUD
--- @class ObjectiveInstance
--- @field Static ObjectiveClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Objective" )
INSTANCE.Class = "ObjectiveInstance"
INSTANCE.IsObjective = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC


--#region Imports

    --- @type ObjectiveManagerClass
    local objectiveManagerClass = CNC.Import( "renhud/code/combat/objective-manager.lua" )

    --- @type GlobalSettingsClass
    local globalSettingsClass = CNC.Import( "renhud/code/combat/global-settings.lua" )

    --- @type TranslateDbClass
    local translateDbClass = CNC.Import( "renhud/code/wwtranslatedb/translatedb.lua" )

    --- @type RadarManagerClass
    local radarManagerClass = CNC.Import( "renhud/code/combat/radar.lua" )

    --- @type RadarBlipsLib
    local radarBlipsLib = CNC.Import( "renhud/client/cl_radar-blips.lua" )
--#endregion


--#region Imported Enums

    local blipColorTypeEnum     = radarManagerClass.BLIP_COLOR_TYPE
    local blipShapeTypeEnum     = radarManagerClass.BLIP_SHAPE_TYPE
    local objectiveTypeEnum     = objectiveManagerClass.OBJECTIVE_TYPE
    local objectiveStatusEnum   = objectiveManagerClass.OBJECTIVE_STATUS
--#endregion


--[[ Chunk IDs ]] do

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum-builder.lua" )

    local builder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES   = builder:Set( 629001440 ),
        CHUNKID_OBJECT      = builder:Next(),

        MICROCHUNKID_ID                     = builder:Set( 1 ),
        MICROCHUNKID_TYPE                   = builder:Next(),
        MICROCHUNKID_STATUS                 = builder:Next(),
        MICROCHUNKID_DESCRIPTION            = builder:Next(),
        MICROCHUNKID_DESCRIPTION_SOUND      = builder:Next(),
        XXXMICROCHUNKID_RADAR_MARKER_ID     = builder:Next(),
        MICROCHUNKID_DESCRIPTION_ID         = builder:Next(),
        MICROCHUNKID_DRAW_BLIP              = builder:Next(),
        MICROCHUNKID_POSITION               = builder:Next(),
        MICROCHUNKID_LONG_DESCRIPTION_ID    = builder:Next(),
        MICROCHUNKID_AGE                    = builder:Next(),
        MICROCHUNKID_HUD_POG_TEXTURE_NAME   = builder:Next(),
        MICROCHUNKID_HUD_MESSAGE_STRING_ID  = builder:Next(),
        MICROCHUNKID_HUD_PRIORITY           = builder:Next(),
        MICROCHUNKID_HUD_AGE                = builder:Next(),
    }
end


--[[ Static Functions and Variables ]] do

    STATIC.Red      = Color( 255,   0,   0 )
    STATIC.Green    = Color(   0, 255,   0 )
    STATIC.Yellow   = Color( 255, 255,   0 )
    STATIC.Grey     = Color( 255 * 0.8, 255 * 0.8, 255 * 0.8 )

    --- Creates a new ObjectiveInstance
    --- @vararg any
    --- @return ObjectiveInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Objective", ... )
    end

    ---@param arg any
    ---@return boolean `true` if the passed argument is a(n) ObjectiveInstance, `false` otherwise
    function STATIC.IsObjective( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsObjective and true or false
    end

    typecheck.RegisterType( "ObjectiveInstance", STATIC.IsObjective )
end

--- @class ObjectiveInstance
--- @field Id integer
--- @field Type integer
--- @field Status integer
--- @field LongDescriptionId string|integer
--- @field ShortDescriptionId string|integer
--- @field DescriptionSoundFilename string?
--- @field HudPogMaterial IMaterial
--- @field HudMessageStringId integer
--- @field HudPriority number
--- @field DrawBlip boolean
--- @field Position Vector
--- @field BlipIntensity number
--- @field Entity Entity
--- @field Age number
--- @field BaseColor Color Added as stand-ins for a function-static variable
--- @field TypeColor Color Added as stand-ins for a function-static variable

-- TODO: Make this configurable
local completedObjectiveDimmingMultiplier = 0.6

--- Constructs a new Objective
function INSTANCE:Renegade_Objective()
    self.Id                 = 0
    self.Type               = 0
    self.Status             = 0
    self.DrawBlip           = false
    self.Position           = Vector( 0, 0, 0 )
    self.BlipIntensity      = 0
    self.HudMessageStringId = 0
    self.LongDescriptionId  = 0
    self.ShortDescriptionId = 0
    self.HudPriotity        = 0
    self.Age                = 0
end

--- @param csave ChunkSaveInstance
function INSTANCE:Save( csave )
    typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
function INSTANCE:Load( cload )
    typecheck.NotImplementedError()
end

--- @return Color
function INSTANCE:TypeToColor()

    STATIC.TypeColor = STATIC.TypeColor or Color( 255, 255, 255 )
    STATIC.TypeColor = self:TypeToBaseColor()

    -- "Dim the colors if this objective has been accomplished"
    if self.Status == objectiveStatusEnum.Accomplished then
        local color = STATIC.TypeColor
        color.r = color.r * completedObjectiveDimmingMultiplier
        color.g = color.g * completedObjectiveDimmingMultiplier
        color.b = color.b * completedObjectiveDimmingMultiplier
    end

    return STATIC.TypeColor
end

--- @return Color
function INSTANCE:TypeToBaseColor()
    STATIC.BaseColor = STATIC.BaseColor or Color( 255, 255, 255 )

    if globalSettingsClass then
        local newColor

        if self.Type == objectiveTypeEnum.Primary then
            newColor = globalSettingsClass.Colors.PrimaryObjective
        elseif self.Type == objectiveTypeEnum.Secondary then
            newColor = globalSettingsClass.Colors.SecondaryObjective
        elseif self.Type == objectiveTypeEnum.Tertiary then
            newColor = globalSettingsClass.Colors.TertiaryObjective
        end

        STATIC.BaseColor = Color( newColor.r, newColor.g, newColor.b, newColor.a )
    end

    return STATIC.BaseColor
end

--- @return string
function INSTANCE:TypeToName()
    if self.Type == objectiveTypeEnum.Primary then
        return translateDbClass.GetString( "IDS_MENU_TEXT145" )
    elseif self.Type == objectiveTypeEnum.Secondary then
        return translateDbClass.GetString( "IDS_MENU_TEXT113" )
    elseif self.Type == objectiveTypeEnum.Tertiary then
        return translateDbClass.GetString( "IDS_MENU_TERTIARY" )
    else
        return translateDbClass.GetString( "IDS_LOCALE_UNKNOWN" )
    end
end

--- @return string
function INSTANCE:StatusToName()
    if self.Status == objectiveStatusEnum.Accomplished then
        return translateDbClass.GetString( "IDS_MENU_OBJ_ACCOMPLISHED" )
    elseif self.Status == objectiveStatusEnum.Failed then
        return translateDbClass.GetString( "IDS_MENU_OBJ_FAILED" )
    elseif self.Status == objectiveStatusEnum.Hidden then
        return translateDbClass.GetString( "IDS_MENU_OBJ_HIDDEN" )
    else
        return translateDbClass.GetString( "IDS_MENU_OBJ_PENDING" )
    end
end

--- @return Color
function INSTANCE:StatusToColor()
    if self.Status == objectiveStatusEnum.IsPending then
        return STATIC.Green
    elseif self.Status == objectiveStatusEnum.Accomplished then
        return STATIC.Yellow
    elseif self.Status == objectiveStatusEnum.Failed then
        return STATIC.Red
    elseif self.Status == objectiveStatusEnum.Hidden then
        return STATIC.Grey
    else
        return STATIC.Green
    end
end

--- @return integer
function INSTANCE:RadarBlipColorType()
    -- I am incredibly suspiscious of this enum math
    return self.Type - objectiveTypeEnum.Primary + blipColorTypeEnum.PrimaryObjective
end

--- @param ent Entity
function INSTANCE:SetEntity( ent )
    if IsValid( ent ) then
        radarBlipsLib.ResetRadarBlipShapeType( ent )
        radarBlipsLib.ResetRadarBlipColorType( ent )
    end
    self.Entity = ent
    self:UpdateEntityBlip()
end

function INSTANCE:UpdateEntityBlip()
    local ent = self.Entity
    if not IsValid( ent ) then return end
    if self.Status == objectiveStatusEnum.IsPending then
        radarBlipsLib.SetRadarBlipShapeType( ent, blipShapeTypeEnum.Objective )
        radarBlipsLib.SetRadarBlipColorType( ent, self:RadarBlipColorType() )
    else
        radarBlipsLib.ResetRadarBlipShapeType( ent )
        radarBlipsLib.ResetRadarBlipColorType( ent )
    end
end

--- @return Vector
function INSTANCE:GetPosition()
    -- Use Entity position if available
    if IsValid( self.Entity ) then
        return self.Entity:GetPos()
    end
    return self.Position
end