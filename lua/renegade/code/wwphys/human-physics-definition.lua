-- Based on HumanPhysDefClass within Code/wwphys/humanphys.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type Physics3DefinitionClass
local physics3DefinitionClass = CNC.Import( "code/wwphys/physics-3-definition.lua" )

--- @class HumanPhysicsDefinitionClass : Physics3DefinitionClass
--- @field Instance HumanPhysicsDefinitionInstance The metatable used by HumanPhysicsDefinitionInstance
local STATIC = CNC.CreateExport( physics3DefinitionClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HumanPhysicsDefinitionClass"

--- @class HumanPhysicsDefinitionInstance : Physics3DefinitionInstance
--- @field Static HumanPhysicsDefinitionClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HumanPhysicsDefinition : Renegade_Physics3Definition" )
INSTANCE.Class = "HumanPhysicsDefinitionInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHumanPhysicsDefinition = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type SimpleDefinitionFactoryClass
	local simpleDefinitionFactoryClass = CNC.Import( "code/wwsaveload/simple-definition-factory.lua" )

	--- @type WWPhysicsIds
	local wWPhysicsIds = CNC.Import( "code/wwphys/ww-physics-ids.lua" )

	--- @type Physics3DefinitionClass
	local physics3DefinitionClass = CNC.Import( "code/wwphys/physics-3-definition.lua" )

	--- @type HumanPhysicsClass
	local humanPhysicsClass = CNC.Import( "code/wwphys/human-physics.lua" )
--#endregion

--#region Imported Enums

	local wWPhysicsFactoryIdEnum = wWPhysicsIds.WW_PHYSICS_FACTORY_ID
	local wWPhysicsDefinitionIdEnum = wWPhysicsIds.WW_PHYSICS_DEFINITION_ID
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HumanPhysicsDefinitionClass

    STATIC.HUMANPHYSDEF_CHUNK_PHYS3DEF = 0x00516000 -- "phys3def data (parent class)"

    --- Creates a new HumanPhysicsDefinitionInstance
    --- @return HumanPhysicsDefinitionInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HumanPhysicsDefinition" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HumanPhysicsDefinitionInstance, `false` otherwise
    function STATIC.IsHumanPhysicsDefinition( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHumanPhysicsDefinition and true or false
    end

    typecheck.RegisterType( "HumanPhysicsDefinitionInstance", STATIC.IsHumanPhysicsDefinition )

    function STATIC.StaticConstructor()
        STATIC.HumanPhysicsDefinitionFactory = simplePersistFactoryClass.New( STATIC, wWPhysicsFactoryIdEnum.PHYSICS_CHUNKID_HUMANPHYSDEF )
        STATIC.HumanPhysicsDefinitionDefinitionFactory = simpleDefinitionFactoryClass.New( STATIC, wWPhysicsDefinitionIdEnum.CLASSID_HUMANPHYSDEF, "Human" )
    end
end


--- @class HumanPhysicsDefinitionInstance

function INSTANCE:Renegade_HumanPhysicsDefinition()
    -- Empty in the original code
end

--- @return integer
function INSTANCE:GetClassId()
    return wWPhysicsDefinitionIdEnum.CLASSID_HUMANPHYSDEF
end

--- @param connectedEntity Entity
--- @return PersistInstance
function INSTANCE:Create( connectedEntity )
    local object = humanPhysicsClass.New()
    object:Init( self, connectedEntity )
    return object
end

function INSTANCE:GetTypeName()
	typecheck.NotImplementedError()
end

function INSTANCE:IsType()
	typecheck.NotImplementedError()
end

function INSTANCE:GetFactory()
	typecheck.NotImplementedError()
end

function INSTANCE:Save()
	typecheck.NotImplementedError()
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    while cload:OpenChunk() do
        if cload:CurChunkId() == STATIC.HUMANPHYSDEF_CHUNK_PHYS3DEF then
            physics3DefinitionClass.Instance.Load( self, cload )
        else
            section.Warn( "Unhandled Chunk ID: ", cload:CurChunkId() )
        end
        cload:CloseChunk()
    end
    return true
end
