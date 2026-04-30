-- Based on PhysicalGameObj within Code/Combat/physicalgameobj.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type DamageableGameObjectClass
local damageableGameObjectClass = CNC.Import( "code/combat/damageable-game-object.lua" )

--- @type CombatPhysicsObserverClass
local combatPhysicsObserverClass = CNC.Import( "code/combat/combat-physics-observer.lua" )

--- @class PhysicalGameObjectClass : DamageableGameObjectClass, CombatPhysicsObserverClass
--- @field Instance PhysicalGameObjectInstance The metatable used by PhysicalGameObjectInstance
local STATIC = CNC.CreateExport( damageableGameObjectClass, combatPhysicsObserverClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PhysicalGameObjectClass"

--- @class PhysicalGameObjectInstance : DamageableGameObjectInstance, CombatPhysicsObserverInstance
--- @field Static PhysicalGameObjectClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PhysicalGameObject" )
INSTANCE.Class = "PhysicalGameObjectInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPhysicalGameObject = true

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local builder = enumBuilderClass.New()

    --- @enum CollisionGroupType
    STATIC.COLLISION_GROUP_TYPE = {
        DEFAULT_COLLISION_GROUP            = builder:Set( 0 ),  -- "Collides with everything"
        UNCOLLIDEABLE_GROUP                = builder:Next(),    -- "Collides with nothing"
        TERRAIN_ONLY_COLLISION_GROUP       = builder:Next(),    -- "Collides only with terrain"
        BULLET_COLLISION_GROUP             = builder:Next(),    -- "Collides with everything but itself"
        TERRAIN_AND_BULLET_COLLISION_GROUP = builder:Next(),    -- "Collides with terrain and bullets"
        BULLET_ONLY_COLLISION_GROUP        = builder:Next(),    -- "Collides only with bullets"
        SOLDIER_COLLISION_GROUP            = builder:Next(),    -- "Collides with everything (but only soldiers use it)"
        SOLDIER_GHOST_COLLISION_GROUP      = builder:Next(),    -- "Collides with everything but soldiers"
        TERRAIN_COLLISION_GROUP            = builder:Set( 15 ), -- "Terrain must be 15"
    }
    local collisionGroupTypeEnum = STATIC.COLLISION_GROUP_TYPE
--#endregion

--#region Imports

    --- @type PhysicsObserverClass
    local physicsObserverClass = CNC.Import( "code/wwphys/physics-observer.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

    --- @type DefinitionManagerClass
    local definitionManagerClass = CNC.Import( "code/wwsaveload/definition-manager.lua" )

    --- @type BaseGameObjectClass
    local baseGameObjectClass = CNC.Import( "code/combat/base-game-object.lua" )

    --- @type Matrix3dClass
    local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )

    --- @type PlayerTypeClass
    local playerTypeClass = CNC.Import( "code/combat/player-type.lua" )

    --- @type RadarManagerClass
    local radarManagerClass = CNC.Import( "code/combat/radar.lua" )

    --- @type NetworkObjectClass
    local networkObjectClass = CNC.Import( "code/wwnet/network-object.lua" )

    --- @type GameObjectManagerClass
    local gameObjectManagerClass = CNC.Import( "code/combat/game-object-manager.lua" )
--#endregion


--#region Imported Enums

    local expirationReactionTypeEnum = physicsObserverClass.EXPIRATION_REACTION_TYPE
    local playerTypeEnum = playerTypeClass.PLAYER_TYPE_ENUM
    local blipColorTypeEnum = radarManagerClass.BLIP_COLOR_TYPE
    local dirtyBitEnum = networkObjectClass.DIRTY_BIT
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class PhysicalGameObjectClass

    --- Creates a new PhysicalGameObjectInstance
    --- @return PhysicalGameObjectInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PhysicalGameObject" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PhysicalGameObjectInstance, `false` otherwise
    function STATIC.IsPhysicalGameObject( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPhysicalGameObject and true or false
    end

    typecheck.RegisterType( "PhysicalGameObjectInstance", STATIC.IsPhysicalGameObject )
end


--- @class PhysicalGameObjectInstance
--- @field ActiveConversation ActiveConversationInstance
--- @field PhysicsObject PhysicsInstance
--- @field AnimationControl AnimationControlInstance
--- @field ServerUpdateSkips any
--- @field HibernationTimer any
--- @field HibernationEnable any
--- @field HostGameObject GameObjectInstance
--- @field HostGameObjectBone any
--- @field RadarBlipShapeType any
--- @field RadarBlipColorType any
--- @field RadarBlipIntensity any
--- @field PendingHostObjectId any
--- @field HudPokableIndicatorEnabled any
--- @field IsInnateConversationsEnabled any

-- "Hibernate after 30 seconds"
local HIBERNATION_DELAY = 30


--[[ Constructor and Destructor ]] do

    function INSTANCE:Renegade_PhysicalGameObject()
        self.PhysicsObject = nil
        self.AnimationControl = nil
        self.HibernationTimer = 0 -- "Start asleep"
        self.HibernationEnable = true
        self.HostGameObjectBone = 0
        self.RadarBlipShapeType = 0
        self.RadarBlipColorType = 0
        self.RadarBlipIntensity = 0
        self.ActiveConversation = nil
        self.PendingHostObjectId = 0
        self.HudPokableIndicatorEnabled = false
        self.IsInnateConversationsEnabled = true
        self:ResetServerSkips( 255 )
    end

    function INSTANCE:_Renegade_PhysicalGameObject()
        if self.PhysicsObject then
            combatManagerClass.GetScene():RemoveObject( self.PhysicsObject )
        end
    end
end


--[[ Definitions ]] do

    --- @param definition PhysicalGameObjectDefinitionInstance
    --- @param connectedEntity Entity
    function INSTANCE:Init( definition, connectedEntity )
        damageableGameObjectClass.Instance.Init( self, definition )
        self:CopySettings( definition, connectedEntity )

        self:HideMuzzleFlashes()

        -- "If the definition calls for it, add a material effect to the object"
        if definition.UseCreationEffect then
            local physicalObject = self:PeekPhysicalObject()
            if physicalObject then
                -- Omitted transition effect
                -- TODO: Implement transition effect
            end
        end
    end

    --- @param definition PhysicalGameObjectDefinitionInstance
    --- @param connectedEntity Entity
    function INSTANCE:CopySettings( definition, connectedEntity )
        -- "Release our hold on the physics object"
        if self.PhysicsObject then
            -- Omitted original logic
            self:GetConnectedEntity():PhysicsDestroy()
        end

        -- "Set the Physical Object"
        local physicsObjectDefinition = definitionManagerClass.FindDefinition( definition.PhysicsDefinitionId )
        if not physicsObjectDefinition then
            Section.Error( "Could not find definition for " .. definition.PhysicsDefinitionId )
            return
        end

        self.PhysicsObject = physicsObjectDefinition:Create() --[[@as PhysicsInstance]]
        if not self.PhysicsObject then
            section.Error( "Could not create definition instance for " .. definition.PhysicsDefinitionId )
            return
        end

        self.PhysicsObject:SetConnectedEntity( connectedEntity )

        self.PhysicsObject:SetCollisionGroup( collisionGroupTypeEnum.DEFAULT_COLLISION_GROUP )
        self.PhysicsObject:SetObserver( self )
        -- Omitted adding the physics object to the physics scene

        --- "Do we still use this?????"
        -- Omitted setting animation from definition

        self:EnableHibernation( definition.DefaultHibernationEnable )

        self:ResetRadarBlipShapeType()
    end

    --- @param definition PhysicalGameObjectDefinitionInstance
    function INSTANCE:ReInit( definition )
        local transformationMatrix = self:GetTransform()

        -- "Re-initialize the base class"
        damageableGameObjectClass.Instance.ReInit( self, definition )

        -- "Copy any internal settings from the definition"
        self:CopySettings( definition, self:GetConnectedEntity() )

        -- "Restore the necessary settings"
        self:SetTransform( transformationMatrix )
    end

    --- @return PhysicalGameObjectDefinitionInstance
    function INSTANCE:GetDefinition()
        return baseGameObjectClass.Instance.GetDefinition( self ) --[[@as PhysicalGameObjectDefinitionInstance]]
    end
end


--[[ Save / Load ]] do

    --- @param csave ChunkSaveInstance
    function INSTANCE:Save( csave )
        typecheck.NotImplementedError()
    end

    --- @param cload ChunkLoadInstance
    function INSTANCE:Load( cload )
        typecheck.NotImplementedError()
    end

    function INSTANCE:OnPostLoad()
        -- "Plug ourselves back into the physics object as an observer"
        self.PhysicsObject:SetObserver( self )

        self:HideMuzzleFlashes()
        damageableGameObjectClass.Instance.OnPostLoad( self )
    end

    function INSTANCE:Startup()
        -- Empty in the original code
    end
end


--[[ Physics ]] do

    --- @return PhysicsInstance
    function INSTANCE:PeekPhysicalObject()
        return self.PhysicsObject
    end

    function INSTANCE:AttachToObjectBone()
        typecheck.NotImplementedError()
    end

    --- @return boolean
    function INSTANCE:IsAttachedToAnObject()
        return self.HostGameObject ~= nil
    end

    function INSTANCE:TeleportToHostBone()
        typecheck.NotImplementedError()
    end

    --- @param transformationMatrix Matrix3dInstance
    function INSTANCE:SetTransform( transformationMatrix )
        self:PeekPhysicalObject():SetTransform( transformationMatrix )
    end

    --- @return Matrix3dInstance
    function INSTANCE:GetTransform()
        return self:PeekPhysicalObject():GetTransform()
    end

    --- @return Vector
    function INSTANCE:GetPosition()
        return self:PeekPhysicalObject():GetPosition()
    end

    --- @param pos Vector
    function INSTANCE:SetPosition( pos )
        self:PeekPhysicalObject():SetPosition( pos )
    end

    --- @return number
    function INSTANCE:GetFacing()
        return self:PeekPhysicalObject():GetFacing()
    end
end


--[[ Display ]] do

    --- @return RenderObjectInstance?
    function INSTANCE:PeekModel()
        return self:PeekPhysicalObject():PeekModel()
    end

    function INSTANCE:GetAnimationControl()
        return self.AnimationControl
    end

    --- @param animationControl AnimationControlInstance
    function INSTANCE:SetAnimationControl( animationControl )
        self.AnimationControl = animationControl
    end

    --- "Note: Set_Animation calls will force an AnimControl to be created, if needed"
    --- @param animationName string
    --- @param looping boolean? [Default: true]
    --- @param frameOffset number? [Default: 0.0]
    function INSTANCE:SetAnimation( animationName, looping, frameOffset )
        looping = looping or true
        frameOffset = frameOffset or 0.0
    end

    --- @param animationName string
    --- @param frame integer
    function INSTANCE:SetAnimationFrame( animationName, frame )
        typecheck.NotImplementedError()
    end
end


--[[ Targeting ]] do

    --- @return number
    function INSTANCE:GetBullseyeOffsetZ()
        return self:GetDefinition().BullseyeOffsetZ
    end

    --- @return Vector
    function INSTANCE:GetBullseyePosition()
        return self:GetPosition()
    end

    --- @param string string
    function INSTANCE:GetInformation( string )
        typecheck.NotImplementedError()
    end
end


--[[ Damage ]] do

    --- @param damager OffenseObjectInstance
    --- @param scale number? [Default: 1.0]
    --- @param alternateSkin integer? [Default: -1]
    function INSTANCE:ApplyDamage( damager, scale, alternateSkin )
        scale = scale or 1.0
        alternateSkin = alternateSkin or -1

        -- "If this damage is allowed"
        if not combatManagerClass.CanDamage( damager:GetOwner(), self ) then
            return
        end

        damageableGameObjectClass.Instance.ApplyDamage( self, damager, scale )
    end

    --- @param damager OffenseObjectInstance
    --- @param scale number
    --- @param direction Vector? [Default: Vector(0,0,0)]
    --- @param collisionBoxName string? [Default: None]
    function INSTANCE:ApplyDamageExtended( damager, scale, direction, collisionBoxName )
        -- This isn't very "extended" of them
        self:ApplyDamage( damager, scale )
    end

    --- @param damager OffenseObjectInstance
    function INSTANCE:CompletelyDamaged( damager )
        if self:GetDefinition().KilledExplosion ~= 0 then
            local pos = self:GetPosition()

            -- "Build a transform with the same heading as the object"
            local zRotation = self:GetTransform():GetZRotation()
            local transformationMatrix = matrix3dClass.New( pos )
            transformationMatrix:RotateZ( zRotation )

            -- "Create the explosion"
            explosionManagerClass.CreateExplosionat( self:GetDefinition().KilledExplosion, transformationMatrix, damager:GetOwner() )

            -- "Reveal this object to the player's encyclopedia"
            if damager:GetOwner() == combatManagerClass.GetTheStar() then
                encyclopediaManagerClass.RevealObject( self )
            end
        end
        self:SetDeletePending()
    end

    --- @return boolean
    function INSTANCE:IsSoft()
        return self.DefenseObject:IsSoft()
    end

    --- @return boolean
    function INSTANCE:TakesExplosionDamage()
        return true
    end
end


--[[ Game Object Type ]] do

    --- @return integer
    function INSTANCE:GetType()
        return self:GetDefinition().Type
    end
end


--[[ Thinking ]] do

    function INSTANCE:PostThink()
        if self.AnimationControl then
            -- "For some reason??  Some vehicles come in with an anim control, but not model in the anim control."
            if self:GetAnimationControl() and not self:GetAnimationControl():PeekModel() then
                self:GetAnimationControl():SetModel( self:PeekModel() )
            end
        end

        -- "Handle Pending Host"
        if self.PendingHostObjectId ~= 0 then
            self:ResetHibernating()
            self.HostGameObject = gameObjectManagerClass.FindPhysicalGameObject( self.PendingHostObjectId )
            self:SetObjectDirtyBit( dirtyBitEnum.BIT_RARE, true )
            if self.HostGameObject then
                -- "Found em"
                self.PendingHostObjectId = 0
            end
        end

        -- "If host bone controlled"
        if self.HostGameObject then
            self:TeleportToHostBone()
        end

        damageableGameObjectClass.Instance.PostThink( self )

        if self.HibernationEnable and self.HibernationTimer > 0 then
            self.HibernationTimer = self.HibernationTimer - FrameTime()

            if self.HibernationTimer <= 0 then
                self:BeginHibernation()
            end
        end

        if self.AnimationControl then
            local animComplete = self.AnimationControl:IsComplete()

            -- "Update the animation control"
            self.AnimationControl:Update( FrameTime() )

            if not animComplete and self.AnimationControl:IsComplete() then
                -- "We just completed.  Return animation complete IF this is not a smart obj with animation action"
                if self:AsSmartGameObject() or not self:AsSmartGameObject():GetAction():IsAnimating() then
                    local observerList = self:GetObservers()
                    for index = 1, #observerList do
                        observerList[index]:AnimationComplete( self, self.AnimationControl:GetAnimationName() )
                    end
                end
            end
        end
    end
end


--[[ Collision ]] do

    --- @param group CollisionGroupType
    function INSTANCE:SetCollisionGroup( group )
        self:PeekPhysicalObject():SetCollisionGroup( group )
    end

    --- @param observedObject PhysicsInstance
    --- @return ExpirationReactionType
    function INSTANCE:ObjectExpired( observedObject )
        self:SetDeletePending()
        return expirationReactionTypeEnum.EXPIRATION_APPROVED
    end
end


--[[ Type Identification ]] do

    --- @return PhysicalGameObjectInstance?
    function INSTANCE:AsPhysicalGameObject()
        return self
    end

    --- "Re-implement for [CombatPhysicsObserverClass]"
    --- @return DamageableGameObjectInstance?
    function INSTANCE:AsDamageableGameObject()
        return self
    end

    --- @return SoldierGameObjectInstance?
    function INSTANCE:AsSoldierGameObject()
        return nil
    end

    --- @return PowerUpGameObjectInstance?
    function INSTANCE:AsPowerUpGameObject()
        return nil
    end

    --- @return VehicleGameObjectInstance?
    function INSTANCE:AsVehicleGameObject()
        return nil
    end

    --- @return C4GameObjectInstance?
    function INSTANCE:AsC4GameObject()
        return nil
    end

    --- @return BeaconGameObjectInstance?
    function INSTANCE:AsBeaconGameObject()
        return nil
    end

    --- @return ArmedGameObjectInstance?
    function INSTANCE:AsArmedGameObject()
        return nil
    end

    --- @return CinematicGameObjectInstance?
    function INSTANCE:AsCinematicGameObject()
        return nil
    end

    --- @return SimpleGameObjectInstance?
    function INSTANCE:AsSimpleGameObject()
        return nil
    end
end


--[[ Network Diagnostics ]] do

    --- @return integer
    function INSTANCE:GetServerSkips()
        return self.ServerUpdateSkips
    end

    --- @param value integer
    function INSTANCE:ResetServerSkips( value )
        self.ServerUpdateSkips = value
    end

    function INSTANCE:IncrementServerSkips()
        if self.ServerUpdateSkips < 254 then
            self.ServerUpdateSkips = self.ServerUpdateSkips + 1
        end
    end
end


--[[ Hibernation ]] do

    --- @return boolean
    function INSTANCE:IsHibernating()
        return self.HibernationTimer <= 0
    end

    --- @param isHibernationEnabled boolean
    function INSTANCE:EnableHibernation( isHibernationEnabled )
        self.HibernationEnable = isHibernationEnabled
        if self:IsHibernating() then
            self.HibernationTimer = 1
        end
    end

    function INSTANCE:ResetHibernating()
        -- "Notify the object that is has just finished hibernating"
        if self:IsHibernating() then
            self:EndHibernation()
        end

        self.HibernationTimer = math.min( HIBERNATION_DELAY, self.HibernationTimer + FrameTime() * 2 )
    end

    function INSTANCE:DoNotHibernate()
        if self.HibernationTimer < 1 then
            self.HibernationTimer = 1
        end
    end

    function INSTANCE:BeginHibernation()
        -- Omitted debug printing
    end

    function INSTANCE:EndHibernation()
        -- Omitted debug printing
    end
end


--[[ Radar Blips ]] do

    --- @return integer
    function INSTANCE:GetRadarBlipShapeType()
        return self.RadarBlipShapeType
    end

    --- @param blipShapeType integer    
    function INSTANCE:SetRadarBlipShapeType( blipShapeType )
        self.RadarBlipShapeType = blipShapeType
    end

    function INSTANCE:ResetRadarBlipShapeType()
        self.RadarBlipShapeType = self:GetDefinition().RadarBlipType
    end

    --- @return integer
    function INSTANCE:GetRadarBlipColorType()
        return self.RadarBlipColorType
    end

    --- @param blipColorType integer
    function INSTANCE:SetRadarBlipColorType( blipColorType )
        self.RadarBlipColorType = blipColorType
    end

    STATIC.RadarBlipColorTypes = {
        [playerTypeEnum.Spectator] = blipColorTypeEnum.Neutral,
        [playerTypeEnum.Mutant   ] = blipColorTypeEnum.Mutant,
        [playerTypeEnum.Neutral  ] = blipColorTypeEnum.Neutral,
        [playerTypeEnum.Renegade ] = blipColorTypeEnum.Renegade,
        [playerTypeEnum.Nod      ] = blipColorTypeEnum.Nod,
        [playerTypeEnum.GDI      ] = blipColorTypeEnum.GDI,
        [playerTypeEnum.Combine  ] = blipColorTypeEnum.Combine,
        [playerTypeEnum.Rebels   ] = blipColorTypeEnum.Rebels,
        [playerTypeEnum.BlackMesa] = blipColorTypeEnum.BlackMesa,
        [playerTypeEnum.HECU     ] = blipColorTypeEnum.HECU,
        [playerTypeEnum.Aperture ] = blipColorTypeEnum.Aperture,
    }

    function INSTANCE:ResetRadarBlipColorType()
        local playerType = self:GetPlayerType()
        self.RadarBlipColorType = (
            STATIC.RadarBlipColorTypes[playerType]
            or
            blipColorTypeEnum.Neutral
        )
    end

    --- @return number
    function INSTANCE:GetRadarBlipIntensity()
        return self.RadarBlipIntensity
    end

    --- @param newIntensity number 
    function INSTANCE:SetRadarBlipIntensity( newIntensity )
        self.RadarBlipIntensity = newIntensity
    end
end


--[[ Network Support ]] do

    function INSTANCE:ExportCreation()
        typecheck.NotImplementedError()
    end

    function INSTANCE:ImportCreation()
        typecheck.NotImplementedError()
    end

    function INSTANCE:ExportRare()
        typecheck.NotImplementedError()
    end

    function INSTANCE:ImportRare()
        typecheck.NotImplementedError()
    end

    function INSTANCE:ExportFrequent()
        typecheck.NotImplementedError()
    end

    function INSTANCE:ImportFrequent()
        typecheck.NotImplementedError()
    end

    --- @return integer
    function INSTANCE:GetVisId()
        local physicsObject = self:PeekPhysicalObject()

        -- "Do we have a physics object we can use?"
        if physicsObject then
            return physicsObject:GetVisObjectId()
        end

        return -1
    end

    --- @return boolean, Vector 
    function INSTANCE:GetWorldPosition()
        return true, self:GetPosition()
    end
end


--[[ Conversation Support ]] do

    --- @return boolean
    function INSTANCE:AreInnateConversationsEnabled()
        return self:GetDefinition().AllowInnateConversations and self.IsInnateConversationsEnabled
    end

    --- @param shouldEnableInnateConversations boolean
    function INSTANCE:EnableInnateConversations( shouldEnableInnateConversations )
        self.IsInnateConversationsEnabled = shouldEnableInnateConversations
    end

    --- @return boolean
    function INSTANCE:IsInConversation()
        return self.ActiveConversation ~= nil
    end

    --- @param conversation ActiveConversationInstance
    function INSTANCE:SetConversation( conversation )
        self.ActiveConversation = conversation
    end
end

--- @param hide boolean
function INSTANCE:HideMuzzleFlashes( hide )
    -- TODO: Implement muzzle flash hide/show
end

--- @param isHudPokableIndicatorEnabled boolean
function INSTANCE:EnableHudPokableIndicator( isHudPokableIndicatorEnabled )
    self.HudPokableIndicatorEnabled = isHudPokableIndicatorEnabled
    self:SetObjectDirtyBit( networkObjectClass.DIRTY_BIT.BIT_RARE, true )
end

--- @return boolean
function INSTANCE:IsHudPokableIndicatorEnabled()
    return self.HudPokableIndicatorEnabled
end

--- @param id integer
function INSTANCE:SetPlayerType( id )
    damageableGameObjectClass.Instance.SetPlayerType( self, id )

    self:ResetRadarBlipColorType()
end


--[[ Physics Observer Support ]] do

    --- @param observedObject PhysicsInstance
    --- @param shatteredObject PhysicsInstance
    --- @param surfaceType integer
    function INSTANCE:ObjectShatteredSomething( observedObject, shatteredObject, surfaceType )
        local transformationMatrix = observedObject:GetTransform()

        surfaceEffectsManagerClass.ApplyEffect(
            surfaceType,
            hitterTypeBulletEnum.HITTER_TYPE_BULLET,
            transformationMatrix,
            nil,
            nil,
            false, -- "No decals"
            false  -- "No emitter"
        )
    end
end
