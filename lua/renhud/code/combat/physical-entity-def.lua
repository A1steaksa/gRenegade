-- Based on PhysicalGameObjDef within Code/Combat/Physicalgameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

-- Parent Class
--- @type DamageableEntityDefClass
local PARENT = CNC.Import( "renhud/code/combat/damageable-entity-def.lua" )

--- @class PhysicalEntityDefClass : DamageableEntityDefClass
local STATIC = CNC.CreateExport( PARENT )
local CLASS = "PhysicalEntityDefClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class PhysicalEntityDefInstance : DamageableEntityDefInstance
local INSTANCE = robustclass.Register( "Renegade_PhysicalEntityDefClass : Renegade_DamageableEntityDefClass" )
INSTANCE.IsPhysicalEntityDefClass = true
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC

--#region Imports

    --- @type RadarManagerClass
    local radarClass = CNC.Import( "renhud/client/code/combat/radar.lua" )
--#endregion


--#region Imported Enums

    local blipShapeTypeEnum = radarClass.BLIP_SHAPE_TYPE
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class PhysicalEntityDefClass

    --- Creates a new PhysicalEntityDefClass
    --- @vararg any
    --- @return PhysicalEntityDefClass
    function STATIC.New( ... )
        return robustclass.New( "Renegade_PhysicalEntityDefClass", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicalEntityDefInstance, `false` otherwise
    function STATIC.IsPhysicalEntityDefClass( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicalEntityDefClass and true or false
    end

    typecheck.RegisterType( "PhysicalEntityDefInstance", STATIC.IsPhysicalEntityDefClass )
end


--- @class PhysicalEntityDefInstance
--- @field Type integer
--- @field RadarBlipType BlipShapeType
--- @field BullseyeOffsetZ number
--- @field Animation string
--- @field PhysDefId integer
--- @field KilledExplosion integer
--- @field DefaultHibernationEnable boolean
--- @field AllowInnateConversations boolean
--- @field OratorType integer
--- @field UseCreationEffect boolean

--- Constructs a new PhysicalEntityDefInstance
function INSTANCE:Renegade_PhysicalEntityDefClass()
    self.Type = 0
    self.BullseyeOffsetZ = 0.0
    self.RadarBlipType = blipShapeTypeEnum.None
    self.PhysDefId = 0
    self.KilledExplosion = 0
    self.OratorType = 999 -- See "Code/Combat/oratortypes.h" for source
    self.DefaultHibernationEnable = true
    self.AllowInnateConversations = false
    self.UseCreationEffect = false
end

--- @return boolean wasValid, string? errorMessage
function INSTANCE:IsValidConfig()
    local returnValue = false

    --- @type DefinitionInstance
    local physDef = definitionManagerClass.FindDefinition( self.PhysDefId )

    if physDef then
        returnValue = physDef
    end

    return returnValue
end

--- @return integer
function INSTANCE:GetPhysDefId()
    return self.PhysDefId
end

--- @return integer
function INSTANCE:GetOratorType()
    return self.OratorType
end
