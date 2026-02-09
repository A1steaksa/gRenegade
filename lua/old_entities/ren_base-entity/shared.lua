-- Based on BaseGameObj within Code/Combat/basegameobj.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type PersistClass
local PARENT = CNC.Import( "renhud/code/wwsaveload/persist.lua" )

--- @class BaseEntityClass : PersistClass
local STATIC = CNC.CreateExport( PARENT )

--- @class BaseEntityInstance : Entity, PersistInstance
--- @field BaseClass Entity
local ENT = ENT --[[@as Entity]]

--#region Imports

    --- @type DefinitionManagerClass
    local definitionManagerClass = CNC.Import( "renhud/code/wwsaveload/definition-manager.lua" )

    --- @type BaseEntityDefClass
    local baseEntityDefClass = CNC.Import( "renhud/code/combat/base-entity-def.lua" )

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "renhud/sh_enum-builder.lua" )
--#endregion

--[[ Chunk IDs ]] do

    local builder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_VARIABLES = builder:Set( 910991407 ),

        XXX_MICROCHUNKID_DESTROY_TYPE           = builder:Set( 1 ),
        MICROCHUNKID_DEFINITION_ID              = builder:Next(),
        MICROCHUNKID_INSTANCE_ID                = builder:Next(),
        MICROCHUNKID_IS_PENDING_DELETE          = builder:Next(),
        MICROCHUNKID_ENABLE_CINEMATIC_FREEZE    = builder:Next(),
    }
end

--[[ Garry's Mod Entity Setup ]] do

    ENT.Type = "anim"
    ENT.Base = "base_anim"
    ENT.Author = "A1steaksa"
    ENT.Category = "C&C Renegade"
    ENT.Spawnable = false
end

--- @class BaseEntityInstance
--- Original:
--- @field Definition BaseEntityDefInstance
--- @field _IsPostThinkAllowed boolean "This is used to prevent postthinking before a think call"
--- @field _EnableCinematicFreeze boolean "This keeps certain object alive during cinematic freeze"
---
--- Additions:
--- @field DefinitionName string The name of the definition to be loaded into this Entity when it spawns
--- @field Model string The path of the model this Entity should use.

--[[ Constructor and Destructor ]] do

    --- Called just before `ENT:Init()` when this Entity is created and is the appropriate place to put elements from C++ constructors
    function ENT:RenConstructor()
        self._IsPostThinkAllowed = false
        self._EnableCinematicFreeze = true

        -- Omitted GameObjManager or EntityManagerClass logic
        -- entityManagerClass.Add( self )
    end
end

--[[ Save & Load ]] do

    --- These functions are inherited from the persist class in the original code

    --- @param save ChunkSaveInstance
    --- @return boolean
    function ENT:Save( save )
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function ENT:Load( cload )
        local id = 0

        local ids = STATIC.ChunkIds

        cload:OpenChunk()
        while cload:OpenMicroChunk() do
            local microChunkId = cload:CurMicroChunkId()

            if microChunkId == ids.MICROCHUNKID_IS_PENDING_DELETE then
                typecheck.NotImplementedError()
            elseif microChunkId == ids.MICROCHUNKID_INSTANCE_ID then
                typecheck.NotImplementedError()
            elseif microChunkId == ids.MICROCHUNKID_DEFINITION_ID then
                typecheck.NotImplementedError()
            else
                self:ReadMicroChunk( cload, ids.MICROCHUNKID_ENABLE_CINEMATIC_FREEZE, STATIC.DATA_TYPE.Boolean, "EnableCinematicFreeze" )
            end

            cload:CloseMicroChunk()
        end
        cload:CloseChunk()

        -- Skipping setting the network ID

        return true
    end
end

--[[ Definitions ]] do

    --- The Renegade Entity Init function
    --- @param definition BaseEntityDefInstance?
    function ENT:Init( definition )

        Section.Print( "Base init ran with def: ", definition )
        if not definition then return end

        self.Definition = definition

        Section.Print( "Did parent setup work? ", type( self.ReadMicroChunk ) == "function" and "Yes!" or "Nope" )
    end

    --- @return BaseEntityDefInstance
    function ENT:GetDefinition()
        return self.Definition
    end

    --- The Garry's Mod Entity init function  
    --- Calls ENT:Init() as its final action
    function ENT:Initialize()
        if SERVER then
            self:SetModel( self.Model or "models/Gibs/HGIBS.mdl" )
            self:PhysicsInit( SOLID_VPHYSICS )
            self:SetMoveType( MOVETYPE_VPHYSICS )
            self:SetSolid( SOLID_VPHYSICS )

            self:SetUseType( SIMPLE_USE )

            local phys = self:GetPhysicsObject()
            if phys:IsValid() then
                phys:Wake()
            end

            self:SetSaveValue( "m_takedamage", 2 ) -- 2 is DAMAGE_YES
        end

        -- Call our pretend C++ constructor
        self:RenConstructor()

        -- Load the definition
        if not self.DefinitionName then
            Section.Error(
                "Definition name is missing from '",
                self.PrintName or "unnamed",
                "' Entity during initialization."
            )
        end
        local definition = definitionManagerClass.FindNamedDefinition( self.DefinitionName ) --[[@as BaseEntityDefInstance]]

        Section.Print( "Calling base init with definition name '", self.DefinitionName, "' and definition: '", tostring( definition ), "'" )

        -- Call the Renegade Init function last
        self:Init( definition )
    end
end


--[[ Thinking ]] do

    --- @private
    --- The Garry's Mod Think function  
    --- Calls `ENT:RenThink()` then `ENT:PostThink()`  
    --- Should **not** be overridden by child classes.
    function ENT:Think()
        self:RenThink()
        self:PostThink()
    end

    --- The Think function for Renegade Entities
    function ENT:RenThink()
        self._IsPostThinkAllowed = true
    end

    --- Called after the `ENT:RenThink()` function
    function ENT:PostThink()
    end
end

--[[ Hibernation ]] do

    --- @return boolean
    function ENT:IsHibernating()
        return false
    end
end

--[[ Type identification ]] do

    --- @return PhysicalEntityInstance
    function ENT:AsPhysicalEntity()
        return NULL --[[@as PhysicalEntityInstance]]
    end

    --- @return VehicleEntityInstance
    function ENT:AsVehicleEntity()
        return NULL --[[@as VehicleEntityInstance]]
    end

    --- @return SmartEntityInstance
    function ENT:AsSmartEntity()
        return NULL --[[@as SmartEntityInstance]]
    end

    --- @return ScriptableEntityInstance
    function ENT:AsScriptableEntity()
        return NULL --[[@as ScriptableEntityInstance]]
    end
end

--- @return boolean
function ENT:IsPostThinkAllowed()
    return self._IsPostThinkAllowed
end

--- @param isFrozen boolean
function ENT:EnableCinematicFreeze( isFrozen )
    self._EnableCinematicFreeze = isFrozen
end

--- @return boolean
function ENT:IsCinematicFreezeEnabled()
    return self._EnableCinematicFreeze
end