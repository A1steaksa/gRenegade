-- Based on PowerUpGameObj within Code/Combat/powerup.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type SimpleGameObjectClass
local simpleGameObjectClass = CNC.Import( "code/combat/simple-game-object.lua" )

--- @class PowerUpGameObjectClass : SimpleGameObjectClass
--- @field Instance PowerUpGameObjectInstance The metatable used by PowerUpGameObjectInstance
local STATIC = CNC.CreateExport( simpleGameObjectClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PowerUpGameObjectClass"

--- @class PowerUpGameObjectInstance : SimpleGameObjectInstance
--- @field Static PowerUpGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PowerUpGameObject : Renegade_SimpleGameObject" )
INSTANCE.Class = "PowerUpGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPowerUpGameObject = true

--#region Exported Enums
    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- @enum PowerUpState
    STATIC.STATE = {
        STATE_BECOMING_IDLE = enumBuilder:Set( 0 ),
        STATE_IDLING        = enumBuilder:Next(),
        STATE_GRANTING      = enumBuilder:Next(),
        STATE_EXPIRING      = enumBuilder:Next(),
    }
     local powerUpStateEnum = STATIC.STATE
--#endregion

--#region Imports

	--- @type SimplePersistFactoryClass
	local simplePersistFactoryClass = CNC.Import( "code/wwsaveload/simple-persist-factory.lua" )

	--- @type CombatChunkIdClass
	local combatChunkIdClass = CNC.Import( "code/combat/combat-chunk-id.lua" )

	--- @type PhysicalGameObjectClass
	local physicalGameObjectClass = CNC.Import( "code/combat/physical-game-object.lua" )

	--- @type BaseGameObjectClass
	local baseGameObjectClass = CNC.Import( "code/combat/base-game-object.lua" )

	--- @type CombatManagerClass
	local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

	--- @type GameObjectManagerClass
	local gameObjectManagerClass = CNC.Import( "code/combat/game-object-manager.lua" )

	--- @type CollisionTypeClass
	local collisionTypeClass = CNC.Import( "code/ww3d2/collision-types.lua" )

	--- @type PhysicsAABoxIntersectionTestClass
	local physicsAABoxIntersectionTestClass = CNC.Import( "code/wwphys/physics-aa-box-intersection-test.lua" )
--#endregion


--#region Imported Enums

	local collisionGroupTypeEnum = physicalGameObjectClass.COLLISION_GROUP_TYPE
--#endregion


--[[ Chunk IDs ]] do

    enumBuilder = enumBuilderClass.New()

    STATIC.ChunkIds = {
        CHUNKID_PARENT    = enumBuilder:Set( 927991635 ),
        CHUNKID_VARIABLES = enumBuilder:Next(),
        CHUNKID_WEAPONBAG = enumBuilder:Next(),

        MICROCHUNKID_STATE           = enumBuilder:Set( 1 ),
        MICROCHUNKID_STATE_END_TIMER = enumBuilder:Next()
    }
end


--[[ Static Functions and Variables ]] do

    --- @class PowerUpGameObjectClass

    --- Creates a new PowerUpGameObjectInstance
    --- @return PowerUpGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PowerUpGameObject" )
    end

    function STATIC.StaticConstructor()
        STATIC.PowerUpGameObjectPersistFactory = simplePersistFactoryClass.New( STATIC, combatChunkIdClass.CHUNKID_GAME_OBJECT_POWERUP )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PowerUpGameObjectInstance, `false` otherwise
    function STATIC.IsPowerUpGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPowerUpGameObject and true or false
    end

    typecheck.RegisterType( "PowerUpGameObjectInstance", STATIC.IsPowerUpGameObject )

    --- @param provider ArmedGameObjectInstance
    --- @return PowerUpGameObjectInstance
    function STATIC.CreateBackpack( provider )
        typecheck.NotImplementedError()
    end
end


--- @class PowerUpGameObjectInstance
--- @field IdleSoundObject AudibleSoundInstance
--- @field State integer
--- @field StateEndTimer number
--- @field WeaponBag WeaponBagInstance "For backpacks, which can hold multiple weapons and ammo"

function INSTANCE:Renegade_PowerUpGameObject()
    simpleGameObjectClass.Instance.Renegade_SimpleGameObject( self )

    self.IdleSoundObject = nil
    self.State = powerUpStateEnum.STATE_BECOMING_IDLE
    self.WeaponBag = nil

    -- self:SetAppPacketType( appPacketTypeEnum.APPPACKETTYPE_POWERUP )
end

function INSTANCE:_Renegade_PowerUpGameObject()
    -- "Cleanup the idle sound"
    if self.IdleSoundObject ~= nil then
        self.IdleSoundObject:RemoveFromScene()
    end
end


--[[ Definitions ]] do

    --- @param definition PowerUpGameObjectDefinitionInstance?
    --- @param connectedEntity Entity
    function INSTANCE:Init( definition, connectedEntity )
        if definition == nil then
            definition = self:GetDefinition()
        end

        simpleGameObjectClass.Instance.Init( self, definition, connectedEntity )

        -- "Only collide with terrain!"
        self:PeekPhysicalObject():SetCollisionGroup( collisionGroupTypeEnum.TERRAIN_ONLY_COLLISION_GROUP )
    end

    --- @return PowerUpGameObjectDefinitionInstance
    function INSTANCE:GetDefinition()
        return baseGameObjectClass.Instance.GetDefinition( self ) --[[@as PowerUpGameObjectDefinitionInstance]]
    end
end


--[[ Save/Load/Construction Factory ]] do

    --- @param csave ChunkSaveInstance
    --- @return boolean
    function INSTANCE:Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    --- @return boolean
    function INSTANCE:Load( cload )
        typecheck.NotImplementedError()
    end

    function INSTANCE:OnPostLoad()
        simpleGameObjectClass.Instance.OnPostLoad( self )
        -- "MOVED"
        self:PeekPhysicalObject():SetCollisionGroup( collisionGroupTypeEnum.UNCOLLIDEABLE_GROUP )
        if self:PeekPhysicalObject():AsMoveablePhysics() then
            self:PeekPhysicalObject():AsMoveablePhysics():SetGravityMultiplier( 0 )
        end

        -- "This allows the idle sound and animation to start after loading"
        if self.State == powerUpStateEnum.STATE_IDLING then
            self.State = powerUpStateEnum.STATE_BECOMING_IDLE
        end
    end

    --- @return PersistFactoryInstance
    function INSTANCE:GetFactory()
        typecheck.NotImplementedError()
    end
end

--[[ Think ]] do

    function INSTANCE:Think()
        simpleGameObjectClass.Instance.Think( self )

        -- "Make sure the powerup is playing its correct animation and sound"
        self:UpdateState()

        -- "
        -- If this powerup isn't currently granting itself to a player, then check
        -- to see if it should!
        --
        -- The server grants the prize, but allow the client to destroy
        -- the powerup before being instructed to do so, 
        -- so that this doesn't lag
        -- "
        if combatManagerClass.IAmServer() and self.State ~= powerUpStateEnum.STATE_GRANTING then

            -- "Check my bounding box for collisions with Soldiers"
            local model = self:PeekModel()
            if not model then
                section.Error( self, ": ", self.Class, ": Think: No model was found" )
                return
            end
            local box = model:GetBoundingBox()

            for _, object in ipairs( gameObjectManagerClass.GetSmartGameObjectList() ) do
                local soldier = object:AsSoldierGameObject()

                if object:AsVehicleGameObject() then
                    typecheck.NotImplementedError()
                end

                if soldier ~= nil and soldier:WantsPowerups() then

                    local test = physicsAABoxIntersectionTestClass.New( box, collisionGroupTypeEnum.DEFAULT_COLLISION_GROUP, collisionTypeClass.COLLISION_TYPE_PHYSICAL )

                    local soldierPhysicalObject = object:PeekPhysicalObject()

                    section.Print( "Soldier Physical Object: ", soldierPhysicalObject )

                    local result = soldierPhysicalObject:IntersectionTest( test )
                    if result then
                        self:Grant( soldier ) -- "Don't grant any more"
                        break
                    end
                end
            end
        end
    end

    --- @param object SmartGameObjectInstance
    function INSTANCE:Grant( object )
        typecheck.NotImplementedError()
    end
end

--[[ Type Identification ]] do

    --- @return PowerUpGameObjectInstance
    function INSTANCE:AsPowerUpGameObject()
        return self
    end
end

--[[ Network Support ]] do

    function INSTANCE:IsAlwaysDirty()
        return false
    end
end


--- @return string
function INSTANCE:GetDescription()
    typecheck.NotImplementedError()
end

function INSTANCE:Expire()
    typecheck.NotImplementedError()
end

--- @param state PowerUpState
function INSTANCE:SetState( state )
    if state ~= self.State then
        self.State = state
        self.StateEndTimer = 0

        if self.State == powerUpStateEnum.STATE_GRANTING then
            -- "Stop the idling sound (if necessary)"
            if self.IdleSoundObject ~= nil then
                self.IdleSoundObject:RemoveFromScene()
                self.IdleSoundObject:Stop()
            end

            -- "Play the grant sound (if exists)"
            if self:GetDefinition().GrantSoundId ~= 0 then
                wwAudioClass.GetInstance():CreateInstantSound( self:GetDefinition().GrantSoundId, self:GetTransform() )
            end

            -- "Play the grant animation (if exists)"
            if self:GetDefinition().GrantAnimationName:len() > 0 then
                -- TODO: Implement grant animation
            end
        end
    end
end

function INSTANCE:UpdateState()
    if self.State == powerUpStateEnum.STATE_IDLING then
        return

    elseif self.State == powerUpStateEnum.STATE_BECOMING_IDLE then

        -- "Start playing the idle sound"
        if self:GetDefinition().IdleSoundId ~= 0 then
            if self.IdleSoundObject == nil then
                self.IdleSoundObject = wwAudioClass:GetInstance():CreateContinuousSound( self:GetDefinition().IdleSoundId )
            end
            if self.IdleSoundObject ~= nil then
                self.IdleSoundObject:SetTransform( self:GetTransform() )
                self.IdleSoundObject:AddToScene( true )
            end
        end

        -- "Start playing the idle animation"
        if self:GetDefinition().IdleAnimationName:len() > 0 then
            self:SetAnimation( self:GetDefinition().IdleAnimationName, true )
        end

        self.State = powerUpStateEnum.STATE_IDLING
        return

    elseif self.State == powerUpStateEnum.STATE_GRANTING then

        -- "  
        -- If the granting animation has finished, then change to another state
        -- (or remove the powerup from the world)  
        -- "
        self.StateEndTimer = self.StateEndTimer - FrameTime()
        if self.StateEndTimer <= 0 then
            if self:GetDefinition().Persistent then
                self:SetState( powerUpStateEnum.STATE_BECOMING_IDLE )
            else
                self:SetDeletePending()
            end
        end
        return

    elseif self.State == powerUpStateEnum.STATE_EXPIRING then
        -- "  
        -- If the granting animation has finished, then change to another state
        -- (or remove the powerup from the world)
        -- "
        self.StateEndTimer = self.StateEndTimer - FrameTime()
        if self.StateEndTimer <= 0 then
            self:SetDeletePending()
        end
        return
    end
end
