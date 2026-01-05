-- Creates and manages ladders attached to Entities

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class LadderBuilderClass
--- @field instance LadderBuilderInstance The metatable used by LadderBuilderInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "LadderBuilderClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class LadderBuilderInstance
--- @field Static LadderBuilderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_LadderBuilder" )
INSTANCE.Class = "LadderBuilderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsLadderBuilder = true


--[[
    Notes to maintainers:
    Ladders are defined by top and bottom points in world-space and cannot actually be parented to Entities.
    (Moving the points while a Player is on the ladder just makes them fall off of it)
    To work around this, I'm going to try to disable ladders whenever their parent Entity is unfrozen, then
    re-position the top and bottom points and re-enable the ladder when it is frozen again.

--]]


--[[ Static Functions and Variables ]] do

    --- @class LadderBuilderClass

    --- Half of the length, width, and height of the AABB for the top and bottom of a ladder
    STATIC.LadderRadius     = Vector( 16, 16, 36 )

    --- Half of the length, width, and height of the AABB for ladder dismounts
    STATIC.DismountRadius   = Vector( 16, 16, 5 )

    --- A mapping of Entity IDs to their LadderBuilderInstance
    --- @type table<integer, LadderBuilderInstance>
    STATIC.EntityToBuilder = STATIC.EntityToBuilder or {}

    --- Creates a new LadderBuilderInstance
    --- @param parent Entity The parent of the ladder
    --- @return LadderBuilderInstance
    function STATIC.New( parent )
        return robustclass.New( "Renegade_LadderBuilder", parent )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) LadderBuilderInstance, `false` otherwise
    function STATIC.IsLadderBuilder( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsLadderBuilder and true or false
    end

    typecheck.RegisterType( "LadderBuilderInstance", STATIC.IsLadderBuilder )

    --- @param ladderBuilder LadderBuilderInstance
    function STATIC.RegisterLadderBuilder( ladderBuilder )
        STATIC.EntityToBuilder[ladderBuilder.Parent:EntIndex()] = ladderBuilder
    end

    --- @param ladderBuilder LadderBuilderInstance
    function STATIC.UnregisterLadderBuilder( ladderBuilder )
        -- It's possible that the parent Entity may have been removed already, so find the builder by value rather than key
        table.RemoveByValue( STATIC.EntityToBuilder, ladderBuilder )
    end

    --- @param parent Entity
    --- @return LadderBuilderInstance?
    function STATIC.GetLadderBuilder( parent )
        return STATIC.EntityToBuilder[parent:EntIndex()]
    end

    -- Remove ladders from Entities as they are deleted
    hook.Add( "EntityRemoved", "A1_Renegade_RemovePropLadders", function( ent, isFullUpdate )
        -- This shouldn't matter because we're server-only, but just to be safe
        if isFullUpdate then return end

        -- Make sure this Entity actually has ladders
        local builder = STATIC.GetLadderBuilder( ent )
        if not builder then return end

        -- Clean up the Entity's ladders and dismounts
        builder:Remove()
    end )

    --[[ State Management ]] do

        hook.Add( "OnPhysgunPickup", "A1_LadderBuilder_DisableLadders_Grab", function( ply, ent )
            local builder = STATIC.GetLadderBuilder( ent )
            if not builder then return end

            builder:DisableLadders()
        end )

        hook.Add( "PlayerUnfrozeObject", "A1_LadderBuilder_DisableLadders_Reload", function( ply, ent, phys )
            local builder = STATIC.GetLadderBuilder( ent )
            if not builder then return end

            builder:DisableLadders()
        end )

        hook.Add( "PlayerFrozeObject", "A1_LadderBuilder_EnableLadders", function( ply, ent, phys )
            local builder = STATIC.GetLadderBuilder( ent )
            if not builder then return end

            builder:EnableLadders()
        end )
    end
end

--- @class LadderBuilderLadder
--- @field Name string This ladder's unique ID
--- @field Builder LadderBuilderInstance The LadderBuilderInstance that created and maintains this ladder
--- @field TopPos Vector Local to the LadderBuilderInstance's parent Entity
--- @field BottomPos Vector Local to the LadderBuilderInstance's parent Entity
--- @field Entity Entity The `func_useableladder` Entity for this ladder
--- @field DismountEntities Entity[] The `info_ladder_dismount` Entities associated with this ladder

--- @class LadderBuilderInstance
--- @field Parent Entity The Entity this ladder is parented to
--- @field Ladders table<string, LadderBuilderLadder>


--- Constructs a new LadderBuilderInstance
--- @param parent Entity The parent of the ladder
function INSTANCE:Renegade_LadderBuilder( parent )
    self.Ladders = {}
    self.Parent = parent

    STATIC.RegisterLadderBuilder( self )
end

--- Removes this LadderBuilderInstance and all of its ladders and dismounts
function INSTANCE:Remove()
    -- Remove ladders
    for ladderName, _ in pairs( self.Ladders ) do
        self:RemoveLadder( ladderName )
    end

    STATIC.UnregisterLadderBuilder( self )
end

--[[ State Management ]] do
    -- "State" here meaning "whether it is enabled or disabled"

    function INSTANCE:EnableLadders()
        for _, ladder in pairs( self.Ladders ) do
            ladder.Entity:Fire( "Enable" )

            self:UpdateLadder( ladder.Name )
        end
    end

    function INSTANCE:DisableLadders()
        for _, ladder in pairs( self.Ladders ) do
            ladder.Entity:Fire( "Disable" )
        end
    end
end

--[[ Ladders ]] do

    --- @param ladder LadderBuilderLadder
    --- @return string
    function INSTANCE:GetLadderEntityName( ladder )
        return "A1_Renegade_Ladder_" .. self.Parent:EntIndex() .. "_" .. ladder.Name
    end

    --- Creates a new ladder
    --- @param ladderName string The unique identifier that is used to reference this ladder
    --- @param bottomPos Vector The local position of the bottom of the ladder, relative to the ladder's parent
    --- @param topPos Vector The local position of the top of the ladder, relative to the ladder's parent
    function INSTANCE:AddLadder( ladderName, bottomPos, topPos )
        local ladderEnt = ents.Create( "func_useableladder" )
        ladderEnt:Spawn()
        ladderEnt:Activate()

        --- @type LadderBuilderLadder
        local ladder = {
            Name = ladderName,
            Builder = self,
            Entity = ladderEnt,
            TopPos = topPos,
            BottomPos = bottomPos,
            DismountEntities = {}
        }

        ladderEnt:SetName( self:GetLadderEntityName( ladder ) )

        self.Ladders[ladderName] = ladder
    end

    --- Removes a given ladder and all of its dismount points
    --- @param ladderName string The unique identifier of the ladder to be removed
    function INSTANCE:RemoveLadder( ladderName )
        local ladder = self:GetLadder( ladderName )
        if not ladder then
            Section.Error( "Could not find ladder to remove: ", ladderName )
        end
        --- @cast ladder LadderBuilderLadder

        -- Remove dismounts
        for _, dismount in pairs( ladder.DismountEntities ) do
            if IsValid( dismount ) then
                dismount:Remove()
            end
        end
        ladder.DismountEntities = nil

        -- Remove the ladder
        self.Ladders[ladderName].Entity:Remove()

        self.Ladders[ladderName] = nil
    end

    --- @param ladderName string The unique identifier that is used to reference this ladder
    --- @return LadderBuilderLadder
    function INSTANCE:GetLadder( ladderName )
        local ladder = self.Ladders[ladderName]
        if not ladder then
            Section.Error( "Could not find ladder on '", self.Parent, "' with ladder name '", ladderName, "'" )
        end
        return ladder
    end

    --- Updates the position of a ladder's top and bottom to match the values set in the LadderBuilderInstance
    --- @param ladderName string
    function INSTANCE:UpdateLadder( ladderName )
        local ladder = self:GetLadder( ladderName )

        if not ladder then
            Section.Error( "Could not update invalid ladder. Ladder Name: '", ladderName, "'" )
        end

        local ladderEnt = ladder.Entity
        if not IsValid( ladderEnt ) then
            Section.Error( "Could not update invalid ladder Entity. Ladder Name: '", ladderName, "'" )
        end
        --- @cast ladderEnt Entity

        -- Bottom pos
        local bottomWorldPos = self.Parent:LocalToWorld( ladder.BottomPos )
        ladderEnt:SetKeyValue( "point0", tostring( bottomWorldPos ) )

        -- Top pos
        local topWorldPos = self.Parent:LocalToWorld( ladder.TopPos )
        ladderEnt:SetKeyValue( "point1", tostring( topWorldPos ) )

        -- Re-find dismount points
        ladderEnt:Activate()
    end
end

--[[ Dismounts ]] do

    --- Creates a new dismount location for a given ladder
    --- @param ladderName string The unique identifier of the ladder to be removed
    --- @param dismountName string The ladder-unique identifier of the new dismount
    function INSTANCE:AddDismount( ladderName, dismountName, localPos )
        local ladder = self:GetLadder( ladderName )
        local parent = self.Parent

        local dismount = ents.Create( "info_ladder_dismount" )
        dismount:SetPos( parent:LocalToWorld( localPos ) )
        dismount:SetParent( parent )
        dismount:SetKeyValue( "target", self:GetLadderEntityName( ladder ) )
        dismount:Spawn()
        dismount:Activate()

        -- Find the new dismount Entity
        ladder.Entity:Activate()

        ladder.DismountEntities[dismountName] = dismount
    end

    --- @param ladderName string The unique identifier of the ladder to be removed
    --- @param dismountName string The ladder-unique identifier of the new dismount
    function INSTANCE:RemoveDismount( ladderName, dismountName )
        local ladder = self:GetLadder( ladderName )

        local dismount = ladder.DismountEntities[dismountName]
        if not IsValid( dismount ) then
            Section.Error( "Could not find dismount to remove: ", dismountName )
        end

        dismount:Remove()
    end

    --- Retrieves the `info_ladder_dismount` Entity for a given ladder and dismount
    --- @param ladderName string The unique identifier of the ladder to be removed
    --- @param dismountName string The ladder-unique identifier of the dismount
    --- @return Entity
    function INSTANCE:GetDismountEntity( ladderName, dismountName )
        local dismount = self:GetLadder( ladderName ).DismountEntities[dismountName]
        if not IsValid( dismount ) then
            Section.Error( "Could not find dismount on '", self.Parent, "' with ladder name '", ladderName, "' and dismount name '", dismountName, "'" )
        end
        return dismount
    end
end
