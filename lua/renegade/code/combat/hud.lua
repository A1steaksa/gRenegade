-- Based on HUDClass within Code/Combat/hud.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class HudClass
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HudClass"


--#region Exported Enums

    --- @enum SeatType
    STATIC.SEAT_TYPE = {
        None      = -1,
        Passenger =  1,
        Driver    =  2,
        Gunner    =  3
    }
    local seatTypeEnum = STATIC.SEAT_TYPE
--#endregion


--#region Imports

    --- @type MaterialsLib
    local materialsLib = CNC.Import( "client/cl_materials.lua" )

    --- @type GlobalSettingsClass
    local globalSettingsClass = CNC.Import( "code/combat/global-settings.lua" )

    --- @type CombatManagerClass
    local combatManagerClass = CNC.Import( "code/combat/combat-manager.lua" )

    --- @type RectClass
    local rectClass = CNC.Import( "code/wwmath/rect.lua" )

    --- @type StyleManagerClass
    local styleManagerClass = CNC.Import( "code/wwui/style-manager.lua" )

    --- @type Render2dClass
    local render2dClass = CNC.Import( "code/ww3d2/render-2d.lua" )

    --- @type Render2dTextClass
    local render2dTextClass = CNC.Import( "code/ww3d2/render-2d-text.lua" )

    --- @type Font3dClass
    local font3dClass = CNC.Import( "code/ww3d2/font-3d.lua" )

    --- @type TranslateDbClass
    local translateDbClass = CNC.Import( "code/wwtranslatedb/translatedb.lua" )

    --- @type ObjectiveManagerClass
    local objManagerClass = CNC.Import( "code/combat/objective-manager.lua" )

    --- @type HudInfoClass
    local hudInfoClass = CNC.Import( "code/combat/hud-info.lua" )

    --- @type PhysicalGameObjectsBridgeClass
    local physObjBridgeClass = CNC.Import( "bridges/sh_physical-game-objects.lua" )

    --- @type BuildingsBridgeClass
    local buildingsBridgeClass = CNC.Import( "bridges/sh_buildings.lua" )

    --- @type Matrix3dClass
    local matrix3dClass = CNC.Import( "code/wwmath/matrix3d.lua" )

    --- @type AABoxClass
    local aABoxClass = CNC.Import( "code/wwmath/aabox.lua" )

    --- @type WWMathClass
    local wWMathClass = CNC.Import( "code/wwmath/wwmath.lua" )

    --- @type PlayerTypeClass
    local playerTypeLib = CNC.Import( "code/combat/player-type.lua" )

    --- @type InfoEntityLib
    local infoEntityLib = CNC.Import( "sh_info-entity.lua" )

    --- @type CameraBridgeClass
    local cameraBridgeClass = CNC.Import( "bridges/sh_camera.lua")

    --- @type RadarManagerClass
    local radarManagerClass = CNC.Import( "code/combat/radar.lua" )
--#endregion


--#region Imported Enums

    local dispositionEnum = infoEntityLib.DISPOSITION
    local playerTypeEnum = playerTypeLib.PLAYER_TYPE_ENUM
    local fontStyleEnum = styleManagerClass.FONT_STYLE
--#endregion


--[[ Load Materials ]] do

    STATIC.Materials = {}

    -- Fonts
    STATIC.Materials.Fonts = {}
    STATIC.Materials.Fonts.Large    = materialsLib.LoadMaterial( "always_dat/font12x16" )
    STATIC.Materials.Fonts.Medium   = materialsLib.LoadMaterial( "always_dat/font12x16" )
    STATIC.Materials.Fonts.Small    = materialsLib.LoadMaterial( "always_dat/font6x8" )

    -- HUD Base
    STATIC.Materials.Hud = {}
    STATIC.Materials.Hud.Main       = materialsLib.LoadMaterial( "always_dat/hud_main" )
    STATIC.Materials.Hud.ChatPBox   = materialsLib.LoadMaterial( "always_dat/hud_chatpbox" )
    STATIC.Materials.Hud.Reticle    = materialsLib.LoadMaterial( "always_dat/hd_reticle" )
    STATIC.Materials.Hud.ReticleHit = materialsLib.LoadMaterial( "always_dat/hd_reticle_hit" )

    -- Objective Pickups
    STATIC.Materials.Pickups = {}
    STATIC.Materials.Pickups.Eva1   = materialsLib.LoadMaterial( "always_dat/p_eva1" )
    STATIC.Materials.Pickups.Eva2   = materialsLib.LoadMaterial( "always_dat/p_eva2" )
    STATIC.Materials.Pickups.CdRom  = materialsLib.LoadMaterial( "always_dat/hud_cd_rom" )

    -- Keycard Pickups
    STATIC.Materials.Pickups.GreenKeycard  = materialsLib.LoadMaterial( "always_dat/hud_keycard_green" )
    STATIC.Materials.Pickups.RedKeycard    = materialsLib.LoadMaterial( "always_dat/hud_keycard_red" )
    STATIC.Materials.Pickups.YellowKeycard = materialsLib.LoadMaterial( "always_dat/hud_keycard_yellow" )

    -- Armor Pickups
    STATIC.Materials.Pickups.Armor1 = materialsLib.LoadMaterial( "always_dat/hud_armor1" )
    STATIC.Materials.Pickups.Armor2 = materialsLib.LoadMaterial( "always_dat/hud_armor2" )
    STATIC.Materials.Pickups.Armor3 = materialsLib.LoadMaterial( "always_dat/hud_armor3" )

    -- Health Pickups
    STATIC.Materials.Pickups.Health1 = materialsLib.LoadMaterial( "always_dat/hud_health1" )
    STATIC.Materials.Pickups.Health2 = materialsLib.LoadMaterial( "always_dat/hud_health2" )
    STATIC.Materials.Pickups.Health3 = materialsLib.LoadMaterial( "always_dat/hud_health3" )

    -- Health and Armor Upgrades
    STATIC.Materials.Pickups.HealthUpgrade = materialsLib.LoadMaterial( "always_dat/hud_hemedal" )
    STATIC.Materials.Pickups.ArmorUpgrade  = materialsLib.LoadMaterial( "always_dat/hud_armedal" )

    -- Team Icons
    STATIC.Materials.TeamIcons = {}
    STATIC.Materials.TeamIcons.None      = materialsLib.LoadMaterial( "always_dat/team-icons/none" )
    STATIC.Materials.TeamIcons.GDI       = materialsLib.LoadMaterial( "always_dat/team-icons/gdi" )
    STATIC.Materials.TeamIcons.Nod       = materialsLib.LoadMaterial( "always_dat/team-icons/nod" )
    STATIC.Materials.TeamIcons.Combine   = materialsLib.LoadMaterial( "always_dat/team-icons/combine" )
    STATIC.Materials.TeamIcons.Rebels    = materialsLib.LoadMaterial( "always_dat/team-icons/rebels" )
    STATIC.Materials.TeamIcons.BlackMesa = materialsLib.LoadMaterial( "always_dat/team-icons/black-mesa" )
    STATIC.Materials.TeamIcons.HECU      = materialsLib.LoadMaterial( "always_dat/team-icons/hecu" )
    STATIC.Materials.TeamIcons.Aperture  = materialsLib.LoadMaterial( "always_dat/team-icons/aperture" )

    -- Seat Icons
    STATIC.Materials.SeatIcons = {}
    STATIC.Materials.SeatIcons[seatTypeEnum.Driver]    = materialsLib.LoadMaterial( "always_dat/hud_driverseat" )
    STATIC.Materials.SeatIcons[seatTypeEnum.Gunner]    = materialsLib.LoadMaterial( "always_dat/hud_gunseat" )
    STATIC.Materials.SeatIcons[seatTypeEnum.Passenger] = materialsLib.LoadMaterial( "always_dat/hud_passseat" )
end

--[[ Load Font3d Instances ]] do

    if CLIENT then
        -- These fonts are provided by `WW3DAssetManager::Get_Instance()->Get_Font3DInstance( tgaFileName )` in the original code
        STATIC.Font3dInstances = {}

        STATIC.Font3dInstances.Large  = font3dClass.New( STATIC.Materials.Fonts.Large  )
        STATIC.Font3dInstances.Medium = font3dClass.New( STATIC.Materials.Fonts.Medium )
        STATIC.Font3dInstances.Small  = font3dClass.New( STATIC.Materials.Fonts.Small  )
    end
end

local INFO_UV_SCALE = Vector( 1 / 256, 1 / 256 )

local RADAR_CENTER_OFFSET = Vector( 55, 78 )

-- "Reticle"
local RETICLE_WIDTH  = ( 64 / 640 )
local RETICLE_HEIGHT = ( 64 / 480 )

local ACT_RELOADING = 183

--- @param renderAvailable boolean
function STATIC.Init( renderAvailable )
    if renderAvailable then
        -- These two function calls are outside of this if statement in the original code
        -- I cannot imagine why it would be intentional to set up reticles and the action bar on the server
        -- If this somehow causes a problem later, just move these two function calls up above the if statement
        STATIC.StatusBarInit()
        STATIC.ReticleInit()

        STATIC.HudEnabled = true

        -- SniperHudClass.Init()
        STATIC.PowerupInit()
        STATIC.WeaponInit()
        -- STATIC.WeaponChartInit()
        STATIC.InfoInit()
        STATIC.DamageInit()

        STATIC.TargetInit()
        infoEntityLib.Init()

        -- STATIC.ObjectiveInit()

        -- STATIC.HudHelpTextInit()

        STATIC.HudInited = true
    end
end

function STATIC.Shutdown()
    if STATIC.HudInited then

        STATIC.ObjectiveShutdown()
        STATIC.TargetShutdown()
        STATIC.DamageShutdown()
        STATIC.InfoShutdown()
        STATIC.WeaponChartShutdown()
        STATIC.WeaponShutdown()
        STATIC.PowerupShutdown()
        STATIC.HudHelpTextShutdown()
        sniperHudClass.Shutdown()

        STATIC.HudInited = false
    end
end

function STATIC.Think()
    if not STATIC.HudInited then return end
    if not STATIC.HudEnabled then return end

    STATIC.InfoUpdate()
    STATIC.PowerupUpdate()
    STATIC.WeaponUpdate()
    -- STATIC.WeaponChartUpdate()
    STATIC.DamageUpdate()

    STATIC.TargetUpdate()

    -- STATIC.ObjectiveUpdate()

    --[[ Radar ]] do
        local transformationMatrix = physObjBridgeClass.GetPlayerTransform():GetInverse()

        -- Omitted vehicle and 2D targetting logic

        local bracketEntity = NULL
        local infoEntity = hudInfoClass:GetInfoEntity()
        if IsValid( infoEntity ) then
            bracketEntity = infoEntity
        end
        radarManagerClass.SetBracketEntity( bracketEntity )
        local radarCenter = STATIC.InfoBase + RADAR_CENTER_OFFSET
        radarManagerClass.Update( transformationMatrix, radarCenter )
    end

    --[[ Reticle ]] do

        local reticleColor = globalSettingsClass.Colors.NoRelation

        -- Check for friendly or enemy targets to change the reticle color
        local targetEntity = hudInfoClass:GetWeaponTargetEntity()
        if IsValid( targetEntity ) and infoEntityLib.HasEntityInfo( targetEntity ) then
            local entityInfo = infoEntityLib.GetEntityInfo( targetEntity ) --[[@as InfoEntityData]]

            if entityInfo.ShouldTarget then
                reticleColor = globalSettingsClass.Colors.Friendly
                if physObjBridgeClass.IsPhysicalGameObject( targetEntity ) then
                    if entityInfo.FeelingTowardPlayer == dispositionEnum.Enemy then
                        reticleColor = globalSettingsClass.Colors.Enemy
                    end
                end
            end
        end

        local weapon = LocalPlayer():GetActiveWeapon()
        if IsValid( weapon ) then
            local isWeaponBusy = (
                not weapon:HasAmmo()
                or ( -- Can have ammo in the magazine, but currently does not
                    weapon:Clip1() <= 0
                    and weapon:GetMaxClip1() > 0
                )
                or weapon:GetInternalVariable( "m_bInReload" )
                or weapon:GetInternalVariable( "m_Activity" ) == ACT_RELOADING
            )

            if isWeaponBusy then
                reticleColor = globalSettingsClass.Colors.ReticleBusy
            end
        end

        local reticleOffset = Vector( 0, 0 ) -- TODO: Implement COMBAT_CAMERA->Get_Camera_Target_2D_Offset();

        STATIC.ReticleRenderer:Reset()
        STATIC.ReticleRenderer:AddQuad( rectClass.New(
            reticleOffset.x - RETICLE_WIDTH  / 2,
            reticleOffset.y - RETICLE_HEIGHT / 2,
            reticleOffset.x + RETICLE_WIDTH  / 2,
            reticleOffset.y + RETICLE_HEIGHT / 2
        ), reticleColor )

        if combatManagerClass.IsGameplayPermitted() then
            STATIC.ReticleRenderer:SetHidden( false )
        else
            STATIC.ReticleRenderer:SetHidden( true )
        end

        -- TODO: Implement the hit reticle

    end
end

function STATIC.Render()

    local camera = combatManagerClass.GetCamera()
    if camera and camera:DrawSniper() then
        sniperHudClass.Render()
    end

    -- "Only render if Combat is active, and Menu ios not, and we have a star who is not sniping"

    if STATIC.IsHudDisplayed() then

        STATIC.PowerupRender()
        STATIC.WeaponRender()
        -- STATIC.WeaponChartRender()
        STATIC.InfoRender()
        STATIC.DamageRender()
        STATIC.TargetRender()

        -- STATIC.HudHelpTextRender()
        -- STATIC.ObjectiveRender()
        radarManagerClass:Render()

        STATIC.ReticleRenderer:Render()
        STATIC.ReticleHitRenderer:Render()
    end
end

--- @return boolean
function STATIC.IsHudDisplayed()
    local combatStar = combatManagerClass.GetTheStar()
    return ( STATIC.HudEnabled and combatStar ~= nil )
    -- return (
    --     and combatStar
    --     and not combatStar:IsDead()
    --     and not combatStar:IsDestroyed()
    -- )
end


function STATIC.Reset()
    STATIC.PowerupReset()
    STATIC.DamageReset()
    STATIC.WeaponReset()
end

--- @param points number
function STATIC.DisplayPoints( points )
    typecheck.NotImplementedError()
end

function STATIC.ToggleHidePoints()
    typecheck.NotImplementedError()
end

--- @return boolean
function STATIC.IsEnabled()
    return STATIC.HudEnabled
end

--- @param isHudEnabled boolean
function STATIC.Enable( isHudEnabled )
    STATIC.HudEnabled = isHudEnabled
end

function STATIC.ForceWeaponChartUpdate()
    typecheck.NotImplementedError()
end

function STATIC.ForceWeaponChartDisplay()
    typecheck.NotImplementedError()
end

--[[ Console Variables ]] do

    local hudEnabledConVar = GetConVar( "ren_hud_enabled" )
    cvars.AddChangeCallback( hudEnabledConVar:GetName(), function( _, _, _ )
        if hudEnabledConVar:GetBool() then
            STATIC.Shutdown()
            STATIC.Enable( true )
        else
            STATIC.Init( CLIENT )
            STATIC.Enable( false )
        end
    end, "Default" )
end

--[[ Powerups ]] do

    --- @class PowerupIcon
    --- @field Name string
    --- @field Number integer
    --- @field Renderer Render2dInstance
    --- @field UV RectInstance
    --- @field IconBox RectInstance
    --- @field Timer number

    local POWERUP_PIXEL_UV_64X64 = rectClass.New( 0, 0, 64, 65 )
    local POWERUP_OFFSET_10X40 = Vector( 10, 40 )

    STATIC.MaxPowerupIcons = 5
    STATIC.PowerupTime = 6
    STATIC.PowerupBoxWidth = 80
    STATIC.PowerupBoxHeight = 55
    STATIC.PowerupPickupAnimationDuration = 1

    STATIC.PowerupBoxUvUpperLeft    = Vector( 50, 1 );
    STATIC.PowerupBoxUvLowerRight   = Vector( 127, 52 );

    STATIC.PowerupBoxBase = Vector( STATIC.PowerupBoxWidth + 6, 112 )
    STATIC.PowerupBoxSpacing = STATIC.PowerupBoxHeight + 10

    --- For weapons, health, and armor pickup notifications
    --- @type table<PowerupIcon>
    STATIC.RightPowerupIconList = STATIC.RightPowerupIconList or {}

    -- For door keys
    --- @type table<PowerupIcon>
    STATIC.LeftPowerupIconList = STATIC.LeftPowerupIconList or {}

    function STATIC.PowerupInit()
        local font = styleManagerClass.PeekFont( fontStyleEnum.IngameTxt )
        STATIC.PowerupTextRenderer = render2dTextClass.New( font )
        STATIC.PowerupTextRenderer:SetCoordinateRange( render2dClass.GetScreenResolution() )
    end

    --- Adds a new powerup to either the left or right powerup list
    --- @param name string
    --- @param number integer
    --- @param material IMaterial
    --- @param pixelUvs RectInstance
    --- @param offset Vector
    --- @param addToRightList boolean
    function STATIC.PowerupAdd( name, number, material, pixelUvs, offset, addToRightList )
        -- Convert pixel UVs to normalized UVs
        local textureSize = material:Width()
        local uvs
        if textureSize > 0 then
            uvs = pixelUvs / textureSize
        end

        --- @type PowerupIcon
        local data = {
            Name = name,
            Number = number,
            Renderer = render2dClass.New(),
            IconBox = rectClass.New( pixelUvs ),
            UV = uvs or pixelUvs,
            Timer = STATIC.PowerupTime
        }

        data.Renderer:SetMaterial( material )
        data.Renderer:SetCoordinateRange( render2dClass.GetScreenResolution() )

        data.IconBox = data.IconBox + offset + Vector( 0, -40.0 ) - data.IconBox:UpperLeft()

        if addToRightList then
            STATIC.RightPowerupIconList[#STATIC.RightPowerupIconList + 1] = data
        else
            STATIC.LeftPowerupIconList[#STATIC.LeftPowerupIconList + 1] = data
        end
    end

    --- Removes all active Powerups from the HUD
    function STATIC.PowerupReset()
        STATIC.LeftPowerupIconList = {}
        STATIC.RightPowerupIconList = {}
    end

    --- Draws either the left or right powerup list
    --- @param frameTime number
    --- @param animationTimer number
    --- @param isRightList boolean
    --- @return number animationTimer
    local function RenderPowerupList( powerupList, frameTime, animationTimer, isRightList )
        -- Remove the bottom of the list after a polite wait
        local listHasPowerups = #powerupList > 0
        if listHasPowerups then
            local isDoneAnimatingListBottom = powerupList[1].Timer < 0
            if  isDoneAnimatingListBottom then
                animationTimer = animationTimer + frameTime
                if animationTimer > STATIC.PowerupPickupAnimationDuration then
                    animationTimer = 0
                    table.remove( powerupList, 1 )
                end
            end
        else
            animationTimer = 0
        end

        local box = rectClass.New( STATIC.PowerupBoxUvUpperLeft, STATIC.PowerupBoxUvLowerRight )
        local start = Vector( ScrW(),  ScrH() ) - STATIC.PowerupBoxBase
        box = box + start - box:LowerLeft()

        if not isRightList then
            box = box - Vector( box.Left - 6, 75 )
        end
        --- @cast box RectInstance

        for index, powerup in ipairs( powerupList ) do
            if index > STATIC.MaxPowerupIcons then break end
            --- @cast powerup PowerupIcon

            powerup.Timer = powerup.Timer - frameTime

            local drawBox = rectClass.New( box )

            --- @type Color, Color
            local green, white

            local isBottomIcon = index == 1
            local isAnimating = animationTimer > 0
            if isBottomIcon and isAnimating then
                local alpha = math.Clamp( 1 - ( animationTimer / STATIC.PowerupPickupAnimationDuration ), 0, 1 ) * 255
                green = Color( 0, 255, 0, alpha )
                white = Color( 255, 255, 255, alpha )
            else
                green = Color( 0, 255, 0, 255 )
                white = Color( 255, 255, 255, 255 )
            end

            local iconBox = powerup.IconBox
            iconBox = iconBox + drawBox:UpperLeft()
            --- @cast iconBox RectInstance

            -- Draw the powerup icon
            do
                local drawColor = isRightList and green or white

                powerup.Renderer:Reset()
                powerup.Renderer:AddQuad( iconBox, powerup.UV, drawColor )
            end

            -- Draw powerup name
            do
                STATIC.PowerupTextRenderer:SetLocation( Vector( drawBox.Left + 1, drawBox.Top + STATIC.PowerupBoxHeight - 15 ) )
                STATIC.PowerupTextRenderer:DrawText( powerup.Name, white )
            end

            -- Draw powerup count
            if isRightList and powerup.Number ~= 0 then
                STATIC.PowerupTextRenderer:SetLocation( Vector( drawBox.Right - 12, drawBox.Top + 1 ) )
                STATIC.PowerupTextRenderer:DrawText( tostring( powerup.Number ) )
            end

            -- Drop remaining icons down
            local isTimeToAnimate = animationTimer > STATIC.PowerupPickupAnimationDuration * 0.5
            if isBottomIcon and isTimeToAnimate then
                box = box + Vector( 0, ( ( 2 * animationTimer / STATIC.PowerupPickupAnimationDuration ) - 1 ) * STATIC.PowerupBoxSpacing )
            end

            box = box - Vector( 0, STATIC.PowerupBoxSpacing )
        end

        return animationTimer
    end

    function STATIC.PowerupUpdate()
        STATIC.PowerupTextRenderer:Reset()

        -- Mimicking the behavior of C++ static variables declared within functions
        STATIC.LeftAnimateTimer = STATIC.LeftAnimateTimer or 0
        STATIC.RightAnimateTimer = STATIC.RightAnimateTimer or 0

        local frameTime = RealFrameTime()

        STATIC.LeftAnimateTimer = RenderPowerupList( STATIC.LeftPowerupIconList, frameTime, STATIC.LeftAnimateTimer, false )
        STATIC.RightAnimateTimer = RenderPowerupList( STATIC.RightPowerupIconList, frameTime, STATIC.RightAnimateTimer, true )
    end

    function STATIC.PowerupRender()

        -- Left powerup list
        for i = 1, #STATIC.LeftPowerupIconList do
            local iconRenderer = STATIC.LeftPowerupIconList[ i ]
            iconRenderer.Renderer:Render()
        end

        -- Right powerup list
        for i = 1, #STATIC.RightPowerupIconList do
            local iconRenderer = STATIC.RightPowerupIconList[ i ]
            iconRenderer.Renderer:Render()
        end

        STATIC.PowerupTextRenderer:Render()
    end

    --- @param id integer
    ---@param rounds integer
    function STATIC.AddPowerupWeapon( id, rounds )
        typecheck.NotImplementedError()
    end

    --- @param id integer
    ---@param rounds integer
    function STATIC.AddPowerupAmmo( id, rounds )
        typecheck.NotImplementedError()
    end

    --- Adds an armor powerup notification
    --- @param strength number The amount of armor gained
    function STATIC.AddShieldGrant( strength )
        local materialName = STATIC.Materials.Pickups.Armor3
        if strength > 75 then
            materialName = STATIC.Materials.Pickups.Armor1
        elseif strength > 30 then
            materialName = STATIC.Materials.Pickups.Armor2
        end

        local powerupName = translateDbClass.GetString( "IDS_Power_up_Armor_00" )

        STATIC.PowerupAdd( powerupName, math.floor( strength ), materialName, POWERUP_PIXEL_UV_64X64, POWERUP_OFFSET_10X40, true )
    end

    --- Adds a health powerup notification
    --- @param amount number
    function STATIC.AddHealthGrant( amount )
        local materialName = STATIC.Materials.Pickups.Health1
        if amount > 75 then
            materialName = STATIC.Materials.Pickups.Health3
        elseif amount > 30 then
            materialName = STATIC.Materials.Pickups.Health2
        end

        local powerupName = translateDbClass.GetString( "IDS_Power_up_Health_00" )

        STATIC.PowerupAdd( powerupName, math.floor( amount ), materialName, POWERUP_PIXEL_UV_64X64, POWERUP_OFFSET_10X40, true )
    end

    --- Adds an armor upgrade powerup notification
    --- @param strength number
    function STATIC.AddShieldUpgradeGrant( strength )
        local powerupName = translateDbClass.GetString( "IDS_Power_up_Armor_Upgrade" )
        STATIC.PowerupAdd( powerupName, math.floor( strength ), STATIC.Materials.Pickups.ArmorUpgrade, POWERUP_PIXEL_UV_64X64, POWERUP_OFFSET_10X40, false )
    end

    --- Adds a health upgrade powerup notification
    --- @param amount number
    function STATIC.AddHealthUpgradeGrant( amount )
        local powerupName = translateDbClass.GetString( "IDS_Power_up_Health_Upgrade" )
        STATIC.PowerupAdd( powerupName, math.floor( amount ), STATIC.Materials.Pickups.HealthUpgrade, POWERUP_PIXEL_UV_64X64, POWERUP_OFFSET_10X40, false )
    end

    --- Adds a security keycard powerup notification
    --- @param key integer
    function STATIC.AddKeyGrant( key )
        local powerupMaterial = STATIC.Materials.Pickups.GreenKeycard
        if key == 3 then
            powerupMaterial = STATIC.Materials.Pickups.RedKeycard
        elseif key == 2 then
            powerupMaterial = STATIC.Materials.Pickups.YellowKeycard
        end

        local powerupName = translateDbClass.GetString( "IDS_Power_up_SecurityCard" )

        STATIC.PowerupAdd( powerupName, 0, powerupMaterial, POWERUP_PIXEL_UV_64X64, POWERUP_OFFSET_10X40, false )
    end

    --- Adds a primary or secondary powerup notification
    --- @param type ObjectiveType
    function STATIC.AddObjective( type )
        if type == objManagerClass.OBJECTIVE_TYPE.Primary then
            local powerupName = translateDbClass.GetString( "IDS_Enc_Obj_Priority_0_Primary" )
            STATIC.PowerupAdd( powerupName, 0, STATIC.Materials.Pickups.Eva1, POWERUP_PIXEL_UV_64X64, POWERUP_OFFSET_10X40, false )
        elseif type == objManagerClass.OBJECTIVE_TYPE.Secondary then
            local powerupName = translateDbClass.GetString( "IDS_Enc_Obj_Priority_0_Secondary" )
            STATIC.PowerupAdd( powerupName, 0, STATIC.Materials.Pickups.Eva2, POWERUP_PIXEL_UV_64X64, POWERUP_OFFSET_10X40, false )
        end
    end

    --- Adds a data disc powerup notification
    function STATIC.AddDataLink()
        local powerupName = translateDbClass.GetString( "IDS_Power_up_DataDisc_01" )
        STATIC.PowerupAdd( powerupName, 0, STATIC.Materials.Pickups.CdRom, POWERUP_PIXEL_UV_64X64, POWERUP_OFFSET_10X40, false )
    end

    --- Adds a data disc powerup notification
    function STATIC.AddMapReveal()
        STATIC.AddDataLink()
    end
end

--[[ Status Bar ]] do

    --- @class HudClass
    --- @field StatusBarRenderer Render2dInstance

    function STATIC.StatusBarInit()
        STATIC.StatusBarRenderer = render2dClass.New()
        STATIC.StatusBarRenderer:SetCoordinateRange( render2dClass.GetScreenResolution() )
    end
end

--[[ Reticles ]] do

    --- @class HudClass
    --- @field ReticleRenderer Render2dInstance
    --- @field ReticleHitRenderer Render2dInstance

    function STATIC.ReticleInit()
        STATIC.ReticleRenderer = render2dClass.New()
        STATIC.ReticleRenderer:SetMaterial( STATIC.Materials.Hud.Reticle )
        STATIC.ReticleRenderer:SetHidden( true )

        STATIC.ReticleHitRenderer = render2dClass.New()
        STATIC.ReticleHitRenderer:SetMaterial( STATIC.Materials.Hud.ReticleHit )
        STATIC.ReticleHitRenderer:SetHidden( true )
    end
end

--[[ Weapon Display ]] do

    --- @class HudClass
    --- @field WeaponBoxRenderer Render2dInstance
    --- @field WeaponImageRenderer Render2dInstance
    --- @field WeaponClipCountRenderer Render2dTextInstance
    --- @field WeaponBase Vector
    --- @field LastHudWeapon Weapon
    --- @field LastVehicleSeat SeatType

    STATIC.LastClipCount        = STATIC.LastClipCount or 0
    STATIC.CenterClipCountTimer = STATIC.CenterClipCountTimer or 0

    STATIC.WeaponBoxUvUpperLeft    = Vector( 0, 0 );
    STATIC.WeaponBoxUvLowerRight   = Vector( 95, 95 );

    -- Manually reformat common weapon names that don't have good print names
    -- Format is [string: weapon class] -> [string: name to display]
    STATIC.PreformattedWeaponNames = {
        ["weapon_crowbar"]      = "Crowbar",
        ["weapon_physcannon"]   = "Gravity Gun",
        ["weapon_physgun"]      = "Physics Gun",
        ["weapon_stunstick"]    = "Stunstick",
        ["weapon_pistol"]       = "9mm Pistol",
        ["weapon_357"]          = ".357 Magnum",
        ["weapon_smg1"]         = "Submachine Gun",
        ["weapon_ar2"]          = "Pulse-Rifle",
        ["weapon_shotgun"]      = "Shotgun",
        ["weapon_crossbow"]     = "Crossbow",
        ["weapon_frag"]         = "Grenade",
        ["weapon_rpg"]          = "RPG",
        ["weapon_slam"]         = "S.L.A.M",
        ["weapon_bugbait"]      = "Bugbait"
    }

    local WEAPON_OFFSET       = Vector( 100, 110 )
    local CLIP_ROUNDS_OFFSET  = Vector( 15, 27 )
    local TOTAL_ROUNDS_OFFSET = Vector( 65, 34 )

    local BULLET_ICON_UV_UL   = Vector( 2, 211 )
    local BULLET_ICON_UV_LR   = Vector( 13, 255 )
    local BULLET_ICON_OFFSET  = Vector( -20, -30 )

    local weaponNameOffset = Vector( 1, 0 )
    local clipCountOffset = Vector( 4, 15 )

    local centerAmmoDisplayTime = GetConVar( "ren_weaponinfo_center_ammo_display_time" )

    function STATIC.WeaponInit()

        local resolution = render2dClass.GetScreenResolution()

        --[[ Weapon Background ]] do
            STATIC.WeaponBoxRenderer = render2dClass.New()
            STATIC.WeaponBoxRenderer:SetMaterial( STATIC.Materials.Hud.Main )
            STATIC.WeaponBoxRenderer:SetCoordinateRange( resolution )

            local boxUv = rectClass.New( STATIC.WeaponBoxUvUpperLeft, STATIC.WeaponBoxUvLowerRight )
            local drawBox = rectClass.New( boxUv )
            boxUv = boxUv / 256
            drawBox = drawBox + Vector( resolution:Width(), resolution:Height() ) - WEAPON_OFFSET - drawBox:UpperLeft()
            --- @cast drawBox RectInstance

            STATIC.WeaponBoxRenderer:AddQuad( drawBox, boxUv )
            STATIC.WeaponBase = drawBox:UpperLeft()
        end

        --[[ Weapon Image ]] do
            STATIC.WeaponImageRenderer = render2dClass.New()
            STATIC.WeaponImageRenderer:SetCoordinateRange( resolution )
        end

        --[[ Weapon Name ]] do
            local font = styleManagerClass.PeekFont( fontStyleEnum.IngameTxt )
            if not font then
                section.Error( "Could not peek font for weapon name on HUD" )
            end
            --- @cast font Font3dInstance

            STATIC.WeaponNameRenderer = render2dTextClass.New( font )
            STATIC.WeaponNameRenderer:SetCoordinateRange( resolution )
        end

        --[[ Weapon Clip Count ]] do
            STATIC.WeaponClipCountRenderer = render2dTextClass.New( STATIC.Font3dInstances.Large )
            STATIC.WeaponClipCountRenderer:SetCoordinateRange( resolution )
        end

        --[[ Reserve Ammo ]] do
            STATIC.WeaponTotalCountRenderer = render2dTextClass.New( STATIC.Font3dInstances.Small )
            STATIC.WeaponTotalCountRenderer:SetCoordinateRange( resolution )
        end

        STATIC.LastHudWeapon = NULL
        STATIC.LastVehicleSeat = seatTypeEnum.None
    end

    function STATIC.WeaponReset()
        STATIC.LastHudWeapon = NULL
        STATIC.LastVehicleSeat = seatTypeEnum.None
    end

    function STATIC.WeaponUpdate()
        -- This function has had to be reorganized to integrate vehicle weapons into the ammo display

        STATIC.WeaponClipCountRenderer:Reset()
        STATIC.WeaponTotalCountRenderer:Reset()

        local combatStar = combatManagerClass.GetTheStar() --[[@as Player]]
        if not IsValid( combatStar ) then return end

        --- @type Vehicle
        local vehicle
        local isGlideVehicle = false
        local inVehicle = combatStar:InVehicle()
        if inVehicle then
            vehicle = combatStar:GetVehicle()

            if Glide then
                local glideVehicle = combatStar:GlideGetVehicle()
                if IsValid( glideVehicle ) then
                    vehicle = glideVehicle
                    isGlideVehicle = true
                end
            end
        end

        --[[ Ammo Counts ]] do

            --- @type integer
            local clipCount

            --- @type integer
            local totalCount

            -- Figure out the total and clip counts
            if inVehicle then
                if isGlideVehicle then
                    -- TODO: Find a performant way to network weapon and ammo info for Glide
                    clipCount = 999
                    totalCount = 999
                else
                    local _, _, count = vehicle:GetAmmo()
                    if count > -1 then
                        clipCount = count
                    else
                        clipCount = 999
                    end

                    totalCount = 999
                end
            else
                local weapon = combatStar:GetActiveWeapon()
                if not IsValid( weapon ) then return end

                local clip1Ammo = math.floor( weapon:Clip1() + 0.5 )
                if clip1Ammo < 0 then
                    clipCount = 999
                else
                    clipCount = clip1Ammo
                end

                local totalClip1Ammo = math.floor( combatStar:GetAmmoCount( weapon:GetPrimaryAmmoType() ) + 0.5 )
                if totalClip1Ammo < 0 then
                    totalCount = 999
                else
                    totalCount = totalClip1Ammo
                end
            end

            local clipCountText = string.format( "%03d", clipCount )
            local totalCountText = string.format( "%03d", totalCount )

            STATIC.WeaponClipCountRenderer:SetLocation( STATIC.WeaponBase + CLIP_ROUNDS_OFFSET )
            STATIC.WeaponClipCountRenderer:DrawText( clipCountText )

            if STATIC.LastClipCount ~= clipCount then
                STATIC.LastClipCount = clipCount
                STATIC.CenterClipCountTimer = centerAmmoDisplayTime:GetFloat()
            end

            if STATIC.CenterClipCountTimer > 0 then
                -- "Also draw the above at the center"
                local centerClipCountOffset = render2dClass.GetScreenResolution():Center()
                centerClipCountOffset.x = centerClipCountOffset.x * 1.5

                local fade = math.Clamp( STATIC.CenterClipCountTimer, 0, 1 )
                local fadeColor = Color( 255, 255, 255, fade * 255 )

                local uv = rectClass.New( BULLET_ICON_UV_UL, BULLET_ICON_UV_LR )
                local draw = rectClass.New( uv )
                uv:ScaleVector( INFO_UV_SCALE )
                draw = draw + centerClipCountOffset + BULLET_ICON_OFFSET - draw:UpperLeft()

                STATIC.InfoRenderer:AddQuad( draw, uv, fadeColor )

                STATIC.WeaponClipCountRenderer:SetLocation( draw:UpperRight() + clipCountOffset )
                STATIC.WeaponClipCountRenderer:DrawText( clipCountText, fadeColor )

                STATIC.CenterClipCountTimer = STATIC.CenterClipCountTimer - FrameTime()
            end

            STATIC.WeaponTotalCountRenderer:SetLocation( STATIC.WeaponBase + TOTAL_ROUNDS_OFFSET )
            STATIC.WeaponTotalCountRenderer:DrawText( totalCountText )
        end

        --[[ Weapon Icon and Name ]] do

            -- "If in vehicle, don't draw the weapon icon and name,"
            -- "draw a seat icon and the vehicle name"
            if combatStar:InVehicle() then
                local vehicle = combatStar:GetVehicle()
                local seat = seatTypeEnum.Passenger

                -- Glide vehicle support
                local isGlideVehicle = false
                if Glide then
                    local playerGlideVehicle = combatStar:GlideGetVehicle()
                    if IsValid( playerGlideVehicle ) then
                        isGlideVehicle = true
                        vehicle = playerGlideVehicle
                    end
                end

                --[[ Determine Seat Type ]] do
                    if isGlideVehicle then
                        -- This is the same check used by Glide internally
                        local isDriver = combatStar:GlideGetSeatIndex() < 2

                        if isDriver then
                            seat = seatTypeEnum.Driver
                        elseif vehicle.crosshair.enabled then
                            seat = seatTypeEnum.Gunner
                        end
                    else
                        seat = seatTypeEnum.Driver
                    end
                end

                if STATIC.LastVehicleSeat ~= seat then
                    STATIC.LastVehicleSeat = seat
                    STATIC.LastHudWeapon = nil -- "Force weapon to re-draw next"

                    STATIC.WeaponImageRenderer:Reset()
                    local fileName = STATIC.Materials.SeatIcons[seat]
                    STATIC.WeaponImageRenderer:SetMaterial( fileName )
                    local offset = Vector( 16, 34 )
                    local iconBox = rectClass.New( 0, 0, 64, 64 )
                    iconBox = iconBox + STATIC.WeaponBase + offset - iconBox:UpperLeft()
                    STATIC.WeaponImageRenderer:AddQuad( iconBox )

                    -- "Draw Name Backdrop"
                    STATIC.WeaponNameRenderer:Reset()
                    local name = infoEntityLib.GetEntityDisplayName( vehicle )
                    local textSize = STATIC.WeaponNameRenderer:GetTextExtents( name )
                    STATIC.WeaponNameRenderer:SetLocation( render2dClass.GetScreenResolution():LowerRight() - textSize )
                    STATIC.WeaponNameRenderer:DrawText( name )
                end
            else
                local weapon = combatStar:GetActiveWeapon()

                if STATIC.LastHudWeapon ~= weapon then
                    STATIC.LastHudWeapon = weapon
                    STATIC.LastVehicleSeat = nil

                    STATIC.WeaponImageRenderer:Reset()
                    STATIC.WeaponNameRenderer:Reset()

                    if IsValid( weapon ) then
                        -- TODO: Weapon icons
                        -- Omitted: Weapon icons
                    end

                    -- "Draw Name Backdrop"
                    -- "Right justify Name"
                    local name = STATIC.PreformattedWeaponNames[ weapon:GetClass() ]
                    if not name then
                        name = language.GetPhrase( weapon:GetPrintName() )
                    end

                    local textSize = STATIC.WeaponNameRenderer:GetTextExtents( name ) + weaponNameOffset
                    STATIC.WeaponNameRenderer:SetLocation( render2dClass.GetScreenResolution():LowerRight() - textSize )
                    STATIC.WeaponNameRenderer:DrawText( name )
                end
            end
        end
    end

    function STATIC.WeaponRender()
        STATIC.WeaponBoxRenderer:Render()
        STATIC.WeaponImageRenderer:Render()
        STATIC.WeaponNameRenderer:Render()
        STATIC.WeaponClipCountRenderer:Render()
        STATIC.WeaponTotalCountRenderer:Render()
    end
end

--[[ Target Info ]] do

    --- @class HudClass
    --- @field TargetRenderer Render2dInstance
    --- @field TargetTeamIconRenderer Render2dInstance
    --- @field TargetBoxRenderer Render2dInstance
    --- @field TargetNameRenderer Render2dTextInstance
    --- @field TargetName string
    --- @field TargetNameLocation Vector

    local TARGET_HEALTH_R_UV_UL = Vector( 20, 165 )
    local TARGET_HEALTH_R_UV_LR = Vector( 96, 173 )

    local HEALTH_BACK_UV_UL = Vector( 183, 241 )
    local HEALTH_BACK_UV_LR = Vector( 186, 248 )

    local TARGET_HEALTH_L_UV_UL = Vector( 0, 165 )
    local TARGET_HEALTH_L_UV_LR = Vector( 20, 181 )

    local TARGET_NAME_UV_UL = Vector( 1, 149 )
    local TARGET_NAME_UV_LR = Vector( 91, 164 )

    local TARGET_ENTERABLE_SIZE = Vector( 32, 32 )
    local TARGET_ENTERABLE_UV_UL = Vector( 45, 209 )
    local TARGET_ENTERABLE_UV_LR = Vector( 51, 215 )
    local TARGET_ENTERABLE_BOUNCE = 4

    local teamIconLookup = {
        [playerTypeEnum.Spectator] = STATIC.Materials.TeamIcons.None,
        [playerTypeEnum.Mutant]    = STATIC.Materials.TeamIcons.None,
        [playerTypeEnum.Neutral]   = STATIC.Materials.TeamIcons.None,
        [playerTypeEnum.Renegade]  = STATIC.Materials.TeamIcons.GDI,
        [playerTypeEnum.Nod]       = STATIC.Materials.TeamIcons.Nod,
        [playerTypeEnum.GDI]       = STATIC.Materials.TeamIcons.GDI,
        [playerTypeEnum.Combine]   = STATIC.Materials.TeamIcons.Combine,
        [playerTypeEnum.Rebels]    = STATIC.Materials.TeamIcons.Rebels,
        [playerTypeEnum.BlackMesa] = STATIC.Materials.TeamIcons.BlackMesa,
        [playerTypeEnum.HECU]      = STATIC.Materials.TeamIcons.HECU,
        [playerTypeEnum.Aperture]  = STATIC.Materials.TeamIcons.Aperture,
    }

    local TEAM_ICON_UV_UL = Vector( 0, 0 )
    local TEAM_ICON_UV_LR = Vector( 18, 15 )
    local TEAM_ICON_UV_SCALE = Vector( 1 / TEAM_ICON_UV_LR.x, 1 / TEAM_ICON_UV_LR.y )

    --- Adjusts the final position of the team icon
    local TEAM_ICON_ADJUST = Vector( 1, 0 )

    function STATIC.TargetInit()
        STATIC.TargetRenderer = render2dClass.New()
        STATIC.TargetRenderer:SetMaterial( STATIC.Materials.Hud.Main )
        STATIC.TargetRenderer:SetCoordinateRange( render2dClass.GetScreenResolution() )

        STATIC.TargetTeamIconRenderer = render2dClass.New()
        STATIC.TargetTeamIconRenderer:SetCoordinateRange( render2dClass.GetScreenResolution() )

        STATIC.TargetBoxRenderer = render2dClass.New()
        STATIC.TargetBoxRenderer:EnableMaterial( false )
        STATIC.TargetBoxRenderer:SetCoordinateRange( render2dClass.GetScreenResolution() )

        local font = styleManagerClass.PeekFont( fontStyleEnum.IngameTxt )
        STATIC.TargetNameRenderer = render2dTextClass.New( font )
        STATIC.TargetNameRenderer:SetCoordinateRange( render2dClass.GetScreenResolution() )

        infoEntityLib.Init()
    end

    function STATIC.TargetShutdown()
        STATIC.TargetRenderer = nil
        STATIC.TargetBoxRenderer = nil
        STATIC.TargetNameRenderer = nil

        infoEntityLib.Shutdown()
    end

    function STATIC.TargetUpdate()
        STATIC.TargetRenderer:Reset()
        STATIC.TargetTeamIconRenderer:Reset()
        STATIC.TargetBoxRenderer:Reset()

        STATIC.BoxZoomSize = STATIC.BoxZoomSize or 0

        hudInfoClass.UpdateInfoEntity()
        local targetEnt = hudInfoClass.GetInfoEntity()

        if not targetEnt or not IsValid( targetEnt ) then
            STATIC.TargetNameRenderer:Reset()
            STATIC.TargetName = ""
            STATIC.TargetNameLocation = Vector( 0, 0 )

            STATIC.BoxZoomSize = 0

            hudInfoClass.SetInfoEntity( NULL )
            return
        end

        -- Wait until we have an EntityInfo to show
        if not infoEntityLib.HasEntityInfo( targetEnt ) then return end
        local entityInfo = infoEntityLib.GetEntityInfo( targetEnt ) --[[@as InfoEntityData]]

        if not entityInfo.ShouldTarget then return end

        local combatStar = combatManagerClass.GetTheStar()
        if not IsValid( combatStar ) then return end

        local physObj = targetEnt:GetPhysicsObject()
        local frameTime = FrameTime()

        STATIC.BoxZoomSize = STATIC.BoxZoomSize + frameTime * 4
        STATIC.BoxZoomSize = math.Clamp( STATIC.BoxZoomSize, 0, 1 )

        local color = globalSettingsClass.Colors.NoRelation
        if physObjBridgeClass.IsPhysicalGameObject( targetEnt ) then
            if physObjBridgeClass.IsTeammate( combatStar, targetEnt ) then
                color = globalSettingsClass.Colors.Friendly
            elseif physObjBridgeClass.IsEnemy( combatStar, targetEnt ) then
                color = globalSettingsClass.Colors.Enemy
            end
        end

        if buildingsBridgeClass.IsBuilding( targetEnt ) then
            if buildingsBridgeClass.IsTeammate( combatStar, targetEnt ) then
                color = globalSettingsClass.Colors.Friendly
            elseif buildingsBridgeClass.IsEnemy( combatStar, targetEnt ) then
                color = globalSettingsClass.Colors.Enemy
            end
        end

        local box = render2dClass.GetScreenResolution()

        if physObj then
            box = STATIC.GetTargetBox( targetEnt )
        else
            -- "Build a box for the buildings"
            box:ScaleRelativeCenter( 0.3 )

            -- "Center on cursor reticle"
            local camera = combatManagerClass.GetCamera()
            local newCenter = camera:GetCameraTarget2dOffset() * 0.5
            newCenter.y = newCenter.y * -1
            newCenter = newCenter + Vector( 0.5, 0.5 )
            newCenter.x = newCenter.x * render2dClass:GetScreenResolution().Right
            newCenter.y = newCenter.y * render2dClass:GetScreenResolution().Bottom
            box = box + newCenter - box:Center()
        end

        -- "Scale the box to let it zoom in"
        if STATIC.BoxZoomSize < 1 then
            box:ScaleRelativeCenter( 1 + ( ( 1 - STATIC.BoxZoomSize ) * 0.3 ) )
        end
        box:SnapToUnits( Vector( 1, 1 ) )

        local res = render2dClass.GetScreenResolution()
        if box.Top < 0 then
            box.Top = 0
        end

        if box.Left < 0 then
            box.Left = 0
        end

        if box.Right > res.Right - 1 then
            box.Right = res.Right - 1
        end

        -- "Leave room for info at the bottom"
        if box.Bottom > res.Bottom - 26 then
            box.Bottom = res.Bottom - 26
        end

        STATIC.TargetBoxEdge( box:UpperLeft(),  box:UpperRight(), color )
        STATIC.TargetBoxEdge( box:UpperLeft(),  box:LowerLeft(),  color )
        STATIC.TargetBoxEdge( box:LowerRight(), box:UpperRight(), color )
        STATIC.TargetBoxEdge( box:LowerRight(), box:LowerLeft(),  color )

        local uv = rectClass.New( TARGET_HEALTH_R_UV_UL, TARGET_HEALTH_R_UV_LR )
        local draw = rectClass.New( uv )
        local draw2

        --[[ Health Bar ]] do

            if entityInfo.ShowHealthBar then
                local healthPercent = entityInfo.HealthPercent

                local healthColor = STATIC.GetHealthColor( healthPercent )

                --[[ Health Background ]] do

                    local black = rectClass.New( HEALTH_BACK_UV_UL, HEALTH_BACK_UV_LR )
                    black:ScaleVector( INFO_UV_SCALE )

                    draw = draw + box:LowerLeft() - draw:UpperLeft() + Vector( 0, 18 )
                    draw = draw + Vector( ( box:Width() - draw:Width() ) / 2 + 2, 0 )

                    draw:Inflate( Vector( 1, 1 ) )
                    STATIC.TargetRenderer:AddQuad( draw, black )
                    draw:Inflate( Vector( -1, -1 ) )
                end

                --[[ Health Bar ]] do

                    uv:ScaleVector( INFO_UV_SCALE )

                    draw.Right = draw.Left + draw:Width() * healthPercent
                    uv.Right = uv.Left + uv:Width() * healthPercent
                    STATIC.TargetRenderer:AddQuad( draw, uv, healthColor )

                    uv:ReplaceVectors( TARGET_HEALTH_L_UV_UL, TARGET_HEALTH_L_UV_LR )
                    draw2 = uv
                end
            end
        end

        --[[ Name ]] do
            --[[ Name Background ]] do

                uv:ReplaceVectors( TARGET_NAME_UV_UL, TARGET_NAME_UV_LR )
                draw = rectClass.New( uv )
                uv:ScaleVector( INFO_UV_SCALE )
                draw = draw + box:LowerLeft() - draw:UpperLeft() + Vector( 0, 1 )
                draw = draw + Vector( (box:Width() - draw:Width() ) / 2 + 10, 0 )
                draw:SnapToUnits( Vector( 1, 1 ) )
                STATIC.TargetRenderer:AddQuad( draw, uv, color )
            end

            --[[ Name Text ]] do

                local name = entityInfo.DisplayName
                local nameLocation = draw:UpperLeft() + Vector( 3, 1 )

                STATIC.TargetNameRenderer:Reset()
                STATIC.TargetName = name
                STATIC.TargetNameLocation = nameLocation
                STATIC.TargetNameRenderer:SetLocation( nameLocation )
                STATIC.TargetNameRenderer:DrawText( name, color )
            end
        end

        --[[ Team Icon ]] do

            local team = entityInfo.TeamToShow
            STATIC.TargetTeamIconRenderer:SetMaterial( teamIconLookup[ team ] )

            uv:ReplaceVectors( TEAM_ICON_UV_UL, TEAM_ICON_UV_LR )

            draw2 = rectClass.New( uv )
            uv:ScaleVector( TEAM_ICON_UV_SCALE )
            draw2 = draw2 + draw:UpperLeft() - draw2:UpperRight() - TEAM_ICON_ADJUST

            STATIC.TargetTeamIconRenderer:AddQuad( draw2, uv )
        end

        --[[ Chevrons ]] do

            if entityInfo.ShowInteractionChevrons then
                local enterableBox = rectClass.New( Vector( 0, 0 ), TARGET_ENTERABLE_SIZE )
                enterableBox = enterableBox + Vector(
                    box:Center().x - enterableBox:Center().x,
                    box.Top - enterableBox.Bottom
                )

                STATIC.EnterableBounce = STATIC.EnterableBounce or 0
                STATIC.EnterableBounce = STATIC.EnterableBounce + FrameTime() * 5
                STATIC.EnterableBounce = wWMathClass.Wrap( STATIC.EnterableBounce, 0, math.rad( 360 ) )
                enterableBox = enterableBox + Vector( 0, TARGET_ENTERABLE_BOUNCE * ( math.sin( STATIC.EnterableBounce ) - 1 ) )

                uv:ReplaceVectors( TARGET_ENTERABLE_UV_UL, TARGET_ENTERABLE_UV_LR )
                uv:ScaleVector( INFO_UV_SCALE )

                color = STATIC.GetHealthColor( 1 )

                -- Top chevron
                enterableBox = enterableBox - Vector( 0, enterableBox:Height() * 0.6 )
                STATIC.TargetRenderer:AddTri(
                    enterableBox:UpperRight(),
                    enterableBox:UpperLeft(),
                    enterableBox:Center(),
                    uv:UpperRight(),
                    uv:UpperLeft(),
                    uv:Center(),
                    color
                )

                -- Middle chevron
                enterableBox = enterableBox + Vector( 0, enterableBox:Height() * 0.6 )
                STATIC.TargetRenderer:AddTri(
                    enterableBox:UpperRight(),
                    enterableBox:UpperLeft(),
                    enterableBox:Center(),
                    uv:UpperRight(),
                    uv:UpperLeft(),
                    uv:Center(),
                    color
                )

                -- Bottom Chevron
                enterableBox = enterableBox + Vector( 0, enterableBox:Height() * 0.6 )
                STATIC.TargetRenderer:AddTri(
                    enterableBox:UpperRight(),
                    enterableBox:UpperLeft(),
                    enterableBox:Center(),
                    uv:UpperRight(),
                    uv:UpperLeft(),
                    uv:Center(),
                    color
                )
            end
        end
    end

    function STATIC.TargetRender()
        -- If we're waiting for the server to provide info on this Entity,
        -- wait for that info before continuing
        if CNC.IsServerEnabled then
            local ent = hudInfoClass.GetInfoEntity()
            if not infoEntityLib.HasEntityInfo( ent ) then
                return
            end
        end
        STATIC.TargetRenderer:Render()
        STATIC.TargetTeamIconRenderer:Render()
        STATIC.TargetBoxRenderer:Render()
        STATIC.TargetNameRenderer:Render()
    end

    --- @param ent Entity
    --- @return RectInstance
    function STATIC.GetTargetBox( ent )

        local top = Vector( 0, 0 )
        local bottom = Vector( 0, 0 )

        if physObjBridgeClass.IsPhysicalGameObject( ent ) then

            -- "tm" here stands for "Transformation Matrix"
            -- "inv" here stands for "Inverse"

            local entBox = infoEntityLib.GetEntityLocalBoundingBox( ent )
            local entTM = physObjBridgeClass.GetTransform( ent )

            local combatCamera = combatManagerClass.GetCamera()
            local cameraTM = combatCamera:GetTransform()
            local cameraPos = cameraTM:GetTranslation()

            local boxViewTM = matrix3dClass.New() --[[@as Matrix3dInstance]]
            boxViewTM:LookAt( cameraPos, entTM * entBox.Center, 0 )
            local boxViewInvTM = boxViewTM:GetOrthogonalInverse()

            local entToBoxViewTM = boxViewInvTM * entTM

            local boxViewBox = aABoxClass.New()
            boxViewBox.Center, boxViewBox.Extent = entToBoxViewTM:TransformCenterExtentAABox( entBox.Center, entBox.Extent )

            local cameraInvTM = cameraTM:GetOrthogonalInverse()
            local boxViewToCameraTM = cameraInvTM * boxViewTM

            local cameraBox = aABoxClass.New() --[[@as AABoxInstance]]
            cameraBox.Center, cameraBox.Extent = boxViewToCameraTM:TransformCenterExtentAABox( boxViewBox.Center, boxViewBox.Extent )

            cameraBox.Extent.z = 0
            local centerTop    = cameraBox.Center - cameraBox.Extent
            local centerBottom = cameraBox.Center + cameraBox.Extent

            local temp = combatCamera:ProjectCameraSpacePoint( centerTop )
            top.x = temp.x
            top.y = temp.y

            temp = combatCamera:ProjectCameraSpacePoint( centerBottom )
            bottom.x = temp.x
            bottom.y = temp.y
        end

        local screen = render2dClass.GetScreenResolution()

        top.x = top.x *  0.5 + 0.5
        top.y = top.y * -0.5 + 0.5
        bottom.x = bottom.x *  0.5 + 0.5
        bottom.y = bottom.y * -0.5 + 0.5

        local temp = top.y
        top.y = bottom.y
        bottom.y = temp

        STATIC.InfoBox = STATIC.InfoBox or rectClass.New()
        STATIC.InfoBox:Replace(
            top.x * screen.Right,
            top.y * screen.Bottom,
            bottom.x * screen.Right,
            bottom.y * screen.Bottom
        )

        return STATIC.InfoBox
    end

    --- @param startPos Vector
    --- @param endPos Vector
    --- @param color Color
    function STATIC.TargetBoxEdge( startPos, endPos, color )
        local percent = 0.2

        local adjustedStart = endPos - startPos
        adjustedStart = adjustedStart * percent
        adjustedStart = adjustedStart + startPos
        STATIC.TargetBoxRenderer:AddLine( startPos, adjustedStart, 2, color )

        local adjustedEnd = startPos - endPos
        adjustedEnd = adjustedEnd * percent
        adjustedEnd = adjustedEnd + endPos
        STATIC.TargetBoxRenderer:AddLine( endPos, adjustedEnd, 2, color )
    end
end

--[[ Health/Armor Info ]] do

    --- @class HudClass
    --- @field InfoRenderer Render2dInstance
    --- @field InfoHealthCountRenderer Render2dTextInstance
    --- @field InfoShieldCountRenderer Render2dTextInstance
    --- @field InfoBase Vector
    --- @field LastHealth number
    --- @field CenterHealthTimer number

    STATIC.InfoBase = STATIC.InfoBase or Vector( 0, 0 )
    STATIC.LastHealth = STATIC.LastHealth or 0
    STATIC.CenterHealthTimer = STATIC.CenterHealthTimer or 0

    -- #region Info Variables

    -- The time, in seconds, that health changes should be drawn on-screen
    local CENTER_HEALTH_TIME    = 2

    -- The offset, in pixels, from the bottom-left corner of the screen where the info display is positioned
    local INFO_OFFSET           = Vector( 7, -179 )

    -- The frame UV and offset values for the static parts of the info display frame
    local infoFrameData = {
        { -- Frame 1 (Radar)
            UpperLeftUv  = Vector( 96, 105 ),
            LowerRightUv = Vector( 214, 255 ),
            Offset       = Vector( -3, -1 )
        },
        { -- Frame 2 (EVA + Top Edge)
            UpperLeftUv  = Vector( 215, 125 ),
            LowerRightUv = Vector( 255, 192 ),
            Offset       = Vector( 114, 57 )
        },
        { -- Frame 3 (Top Edge)
            UpperLeftUv  = Vector( 218, 192 ),
            LowerRightUv = Vector( 255, 201 ),
            Offset       = Vector( 154, 115 ),
        },
        { -- Frame 4 (Top-Right Corner)
            UpperLeftUv  = Vector( 216, 200 ),
            LowerRightUv = Vector( 255, 255 ),
            Offset       = Vector( 191, 115 ),
        },
        { -- Frame 5 (Right Cap)
            UpperLeftUv  = Vector( 80, 203 ),
            LowerRightUv = Vector( 100, 258 ),
            Offset       = Vector( 230, 116 ),
        },
        { -- Frame 6 (Bottom-Left Rounded Corner)
            UpperLeftUv  = Vector( 216, 101 ),
            LowerRightUv = Vector( 240, 125 ),
            Offset       = Vector( 74, 149 ),
        }
    }

    local HEALTH_BACK_UV_UL     = Vector( 183, 241 )
    local HEALTH_BACK_UV_LR     = Vector( 186, 248 )
    local HEALTH_BACK_UL        = Vector( 98, 122 )
    local HEALTH_BACK_LR        = Vector( 224, 168 )

    local GRADIENT_BLACK_UV_UL  = Vector( 3, 135 )
    local GRADIENT_BLACK_UV_LR  = Vector( 44, 144 )

    local HEALTH_TEXT_BACK_UL   = Vector( 77, 124 )
    local HEALTH_TEXT_BACK_LR   = Vector( 163, 150 )

    local HEALTH_UV_UL          = Vector( 94, 52 )
    local HEALTH_UV_LR          = Vector( 249, 100 )
    local HEALTH_OFFSET         = Vector( 73, 121 )

    local SHIELD_UV_UL          = Vector( 66, 97 )
    local SHIELD_UV_LR          = Vector( 96, 132 )
    local SHIELD_OFFSET         = Vector( 211, 140 )

    local KEY_1_UV_UL           = Vector( 30, 180 )
    local KEY_1_UV_LR           = Vector( 57, 197 )
    local KEY_1_OFFSET          = Vector( 32, 134 )

    local KEY_2_UV_UL           = Vector( 0, 181 )
    local KEY_2_UV_LR           = Vector( 30, 197 )
    local KEY_2_OFFSET          = Vector( 41, 140 )

    local KEY_3_UV_UL           = Vector( 69, 133 )
    local KEY_3_UV_LR           = Vector( 97, 149 )
    local KEY_3_OFFSET          = Vector( 50, 148 )

    local HEALTH_CROSS_1_UV_UL  = Vector( 33, 199 )
    local HEALTH_CROSS_1_UV_LR  = Vector( 63, 226 )
    local HEALTH_CROSS_1_OFFSET = Vector( 77, 124 )

    local HEALTH_CROSS_2_UV_UL  = Vector( 33, 228 )
    local HEALTH_CROSS_2_UV_LR  = Vector( 63, 258 )
    local HEALTH_CROSS_2_OFFSET = Vector( 77, 124 )

    local TOTAL_SHIELD_MOVEMENT = 80
    -- #endregion

    --- @param healthPercent number
    --- @return Color
    function STATIC.GetHealthColor( healthPercent )
        local color = globalSettingsClass.Colors.HealthHigh

        if healthPercent <= 0.5 then
            color = globalSettingsClass.Colors.HealthMed
        end

        if healthPercent <= 0.25 then
            color = globalSettingsClass.Colors.HealthLow
        end

        return color
    end

    function STATIC.InfoInit()
        local resolution = render2dClass.GetScreenResolution()

        STATIC.InfoRenderer = render2dClass.New( STATIC.Materials.Hud.Main )
        STATIC.InfoRenderer:SetCoordinateRange( resolution )

        STATIC.InfoHealthCountRenderer = render2dTextClass.New( STATIC.Font3dInstances.Large )
        STATIC.InfoHealthCountRenderer:SetCoordinateRange( resolution )

        STATIC.InfoShieldCountRenderer = render2dTextClass.New( STATIC.Font3dInstances.Small )
        STATIC.InfoShieldCountRenderer:SetCoordinateRange( resolution )

        STATIC.InfoBase = resolution:LowerLeft() + INFO_OFFSET
    end

    function STATIC.InfoUpdateHealthShield()
        local infoRenderer = STATIC.InfoRenderer

        local health = 0
        local healthPercent = 0
        local shield = 0
        local shieldPercent = 0

        local combatStar = LocalPlayer()

        -- Get the player's current health or the health of their vehicle
        if IsValid( combatStar ) then

            health = math.max( combatStar:Health(), 0 )
            healthPercent = math.Clamp( health / combatStar:GetMaxHealth(), 0, 1 )

            shield = math.max( combatStar:Armor(), 0 )
            shieldPercent = math.Clamp( shield / combatStar:GetMaxArmor(), 0, 1 )

            -- Vehicle health
            if combatStar:InVehicle() then
                local vehicle = combatStar:GetVehicle()

                local vehicleHealth = vehicle:Health()
                local vehicleMaxHealth = vehicle:GetMaxHealth()

                if vehicleHealth ~= 0 and vehicleMaxHealth ~= 0 then
                    health = vehicleHealth
                    healthPercent = vehicleHealth / vehicleMaxHealth
                end

                --- Support for Glide vehicles
                if Glide then
                    local glideVehicle = combatStar:GlideGetVehicle()
                    if IsValid( glideVehicle ) then
                        vehicle = glideVehicle
                        health = glideVehicle:GetChassisHealth()
                        local maxHealth = glideVehicle.MaxChassisHealth
                        healthPercent = health / maxHealth
                    end
                end
            end
        end

        --- @type RectInstance, RectInstance, RectInstance, number
        local uv, uv2, draw, intensity

        local frameTime = FrameTime()

        STATIC.LastHealthPercent = STATIC.LastHealthPercent or 0
        STATIC.LastShieldPercent = STATIC.LastShieldPercent or 0

        -- Get the health color
        local colorPercent = math.max( STATIC.LastHealthPercent, healthPercent )
        local healthColor = STATIC.GetHealthColor( colorPercent )

        local healthString = string.format( "%03d", math.floor( health ) )
        local shieldString = string.format( "%03d", math.floor( shield ) )

        --[[ Health Bar ]] do

            uv = rectClass.New( HEALTH_UV_UL, HEALTH_UV_LR )
            draw = rectClass.New( uv )
            uv:ScaleVector( INFO_UV_SCALE )

            --- @type RectInstance
            draw = draw + ( STATIC.InfoBase + HEALTH_OFFSET - draw:UpperLeft() )

            -- Scale bars
            local diff = healthPercent - STATIC.LastHealthPercent
            local maxChange = frameTime
            STATIC.LastHealthPercent = STATIC.LastHealthPercent + math.Clamp( diff, -maxChange, maxChange )
            uv.Right = uv.Left + uv:Width() * STATIC.LastHealthPercent
            draw.Right = draw.Left + draw:Width() * STATIC.LastHealthPercent

            -- Draw the colored health bar
            infoRenderer:AddQuad( draw, uv, healthColor )
        end

        --[[ Health Cross ]] do

            -- Background gradient
            uv = rectClass.New( GRADIENT_BLACK_UV_UL, GRADIENT_BLACK_UV_LR )
            uv:ScaleVector( INFO_UV_SCALE )
            draw = rectClass.New( HEALTH_TEXT_BACK_UL, HEALTH_TEXT_BACK_LR )
            draw = draw + STATIC.InfoBase
            infoRenderer:AddQuad( draw, uv )

            -- Cross icon
            STATIC.HealthCrossFlash = STATIC.HealthCrossFlash or 0
            STATIC.HealthCrossFlash = STATIC.HealthCrossFlash + frameTime * 4

            if STATIC.HealthCrossFlash > 2 then
                STATIC.HealthCrossFlash = STATIC.HealthCrossFlash - 2
            end

            if healthPercent > 0.25 then
                STATIC.HealthCrossFlash = 0
            end

            intensity = STATIC.HealthCrossFlash
            if STATIC.HealthCrossFlash > 1 then
                intensity = 2 - STATIC.HealthCrossFlash
            end

            -- Cross icon fill
            uv = rectClass.New( HEALTH_CROSS_1_UV_UL, HEALTH_CROSS_1_UV_LR )
            draw = rectClass.New( uv )
            uv:ScaleVector( INFO_UV_SCALE )
            draw = draw + ( STATIC.InfoBase + HEALTH_CROSS_1_OFFSET - draw:UpperLeft() )
            infoRenderer:AddQuad( draw, uv, ColorAlpha( healthColor, intensity * 255 ) )

            -- Cross icon outline
            uv2 = rectClass.New( HEALTH_CROSS_2_UV_UL, HEALTH_CROSS_2_UV_LR )
            uv2:ScaleVector( INFO_UV_SCALE )
            infoRenderer:AddQuad( draw, uv2, ColorAlpha( healthColor, ( 1 - intensity ) * 255 ) )
        end

        --[[ Health Number ]] do
            STATIC.InfoHealthCountRenderer:Reset()

            if health < 1 and health > 0 then
                health = 1
            end

            STATIC.InfoHealthCountRenderer:SetLocation( draw:UpperRight() + Vector( 4, 4 ) )
            STATIC.InfoHealthCountRenderer:DrawText( healthString, healthColor )
        end

        --[[ Center Health Number ]] do

            -- Show the center health number if we took damage recently or are low on health
            if health ~= STATIC.LastHealth or healthPercent < 0.25 then
                STATIC.LastHealth = health
                STATIC.CenterHealthTimer = CENTER_HEALTH_TIME
            end

            if STATIC.CenterHealthTimer > 0 then

                local healthCenterOffset = render2dClass.GetScreenResolution():Center()
                healthCenterOffset.x = healthCenterOffset.x * 0.5
                healthCenterOffset.y = healthCenterOffset.y - draw:Height() / 2

                healthCenterOffset = healthCenterOffset - HEALTH_CROSS_1_OFFSET

                local fade = math.Clamp( STATIC.CenterHealthTimer, 0, 1 )

                -- Background gradient
                uv = rectClass.New( GRADIENT_BLACK_UV_UL, GRADIENT_BLACK_UV_LR )
                uv:ScaleVector( INFO_UV_SCALE )
                draw = rectClass.New( HEALTH_TEXT_BACK_UL, HEALTH_TEXT_BACK_LR )
                draw = draw + healthCenterOffset
                infoRenderer:AddQuad( draw, uv, Color( 255, 255, 255, fade * 255 ) )

                -- The center cross
                uv = rectClass.New( HEALTH_CROSS_1_UV_UL, HEALTH_CROSS_1_UV_LR  )
                draw = rectClass.New( uv )
                uv:ScaleVector( INFO_UV_SCALE )
                draw = draw + healthCenterOffset + HEALTH_CROSS_1_OFFSET - draw:UpperLeft()

                -- Cross fill
                infoRenderer:AddQuad( draw, uv, ColorAlpha( healthColor, fade * intensity * 255 ) )

                -- Cross outline
                infoRenderer:AddQuad( draw, uv2, ColorAlpha( healthColor, fade * ( 1 - intensity ) * 255 ) )

                -- Health text
                STATIC.InfoHealthCountRenderer:SetLocation( draw:UpperRight() + Vector( 4, 4 ) )
                STATIC.InfoHealthCountRenderer:DrawText( healthString, ColorAlpha( healthColor, fade * 255 ) )

                STATIC.CenterHealthTimer = STATIC.CenterHealthTimer - frameTime
            end
        end

        --[[ Shield / Armor ]] do
            local diff = shieldPercent - STATIC.LastShieldPercent
            local maxChange = frameTime
            STATIC.LastShieldPercent = STATIC.LastShieldPercent + math.Clamp( diff, -maxChange, maxChange )
            shieldPercent = STATIC.LastShieldPercent
            uv.Right = uv.Left + uv:Width() * shieldPercent
            draw.Right = draw.Left + draw:Width() * shieldPercent

            if shieldPercent > 0 then

                -- Background shields
                local percent = 0
                while percent < shieldPercent do
                    uv = rectClass.New( SHIELD_UV_UL, SHIELD_UV_LR )
                    draw = rectClass.New( uv )

                    uv:ScaleVector( INFO_UV_SCALE )
                    draw = draw + ( STATIC.InfoBase + SHIELD_OFFSET - draw:UpperLeft() )
                    draw = draw + Vector( math.floor(-percent * TOTAL_SHIELD_MOVEMENT ), 0 )
                    infoRenderer:AddQuad( draw, uv )

                    percent = percent + 0.1
                end

                -- Foreground shield
                uv = rectClass.New( SHIELD_UV_UL, SHIELD_UV_LR )
                draw = rectClass.New( uv )
                uv:ScaleVector( INFO_UV_SCALE )
                draw = draw + ( STATIC.InfoBase + SHIELD_OFFSET - draw:UpperLeft() )
                draw = draw + Vector( math.floor( -shieldPercent * TOTAL_SHIELD_MOVEMENT ), 0 )
                infoRenderer:AddQuad( draw, uv )

                STATIC.InfoShieldCountRenderer:Reset()

                STATIC.InfoShieldCountRenderer:SetLocation( draw:UpperLeft() + Vector( 4, 4 ) )
                STATIC.InfoShieldCountRenderer:DrawText( shieldString )

            else
                STATIC.InfoShieldCountRenderer:Reset()
            end
        end
    end

    function STATIC.InfoUpdate()
        local infoRenderer = STATIC.InfoRenderer

        infoRenderer:Reset()

        --[[ Background Frame ]] do
            local uv, draw

            -- Add each frame part
            for _, frameData in ipairs( infoFrameData ) do
                uv = rectClass.New( frameData.UpperLeftUv, frameData.LowerRightUv )
                draw = rectClass.New( uv )

                draw = draw + STATIC.InfoBase + frameData.Offset - draw:UpperLeft()

                uv:ScaleVector( INFO_UV_SCALE )

                infoRenderer:AddQuad( draw, uv )
            end

            -- Add health background
            uv = rectClass.New( HEALTH_BACK_UV_UL, HEALTH_BACK_UV_LR )
            uv:ScaleVector( INFO_UV_SCALE )
            draw = rectClass.New( HEALTH_BACK_UL, HEALTH_BACK_LR )
            draw = draw + STATIC.InfoBase

            infoRenderer:AddQuad( draw, uv )
        end

        STATIC.InfoUpdateHealthShield()

        -- TODO: Keys
    end

    function STATIC.InfoRender()
        STATIC.InfoRenderer:Render()
        STATIC.InfoHealthCountRenderer:Render()
        STATIC.InfoShieldCountRenderer:Render()
    end
end

--[[ Damage Indicator ]] do

    --- @class HudClass
    --- @field DamageRenderer Render2dInstance
    --- @field DamageIndicatorIntensity table<integer, number>
    --- @field DamageIndicatorIntensityChanging boolean
    --- @field DamageIndicatorOrientation boolean

    local damageIndicatorsConVar = GetConVar( "ren_damageindicator_enabled" )

    local DAMAGE_1_UV_UL = Vector( 65, 184 )
    local DAMAGE_1_UV_LR = Vector( 78, 255 )
    local DAMAGE_2_UV_UL = Vector( 200, 3  )
    local DAMAGE_2_UV_LR = Vector( 248, 51 )

    local HORIZ_DAMAGE_SIZE  = Vector( 81,  14  )
    local VERT_DAMAGE_SIZE   = Vector( 15,  78  )
    local HV_DAMAGE_OFFSET   = Vector( 170, 168 )
    local DIAG_DAMAGE_SIZE   = Vector( 53,  59  )
    local DIAG_DAMAGE_OFFSET = Vector( 119, 117 )

    local HORIZ_WIDTH   = HORIZ_DAMAGE_SIZE.x / 640
    local HORIZ_HEIGHT  = HORIZ_DAMAGE_SIZE.y / 480
    local VERT_WIDTH    = VERT_DAMAGE_SIZE.x / 640
    local VERT_HEIGHT   = VERT_DAMAGE_SIZE.y / 480
    local OFFSET_X      = HV_DAMAGE_OFFSET.x / 640
    local OFFSET_Y      = HV_DAMAGE_OFFSET.y / 480

    local DIAG_WIDTH	= DIAG_DAMAGE_SIZE.x / 640
    local DIAG_HEIGHT	= DIAG_DAMAGE_SIZE.y / 480
    local DIAG_OFFSET_X	= DIAG_DAMAGE_OFFSET.x / 640
    local DIAG_OFFSET_Y	= DIAG_DAMAGE_OFFSET.y / 480

    local NUM_DAMAGE_INDICATORS = 8

    function STATIC.DamageReset()
        for i = 0, NUM_DAMAGE_INDICATORS do
            STATIC.DamageIndicatorIntensity[i] = 0
        end
        STATIC.DamageIndicatorIntensityChanging = true
        combatManagerClass.ClearStarDamageDirection()
    end

    function STATIC.DamageInit()
        STATIC.DamageIndicatorIntensity = {}

        STATIC.DamageRenderer = render2dClass.New()
        STATIC.DamageRenderer:SetMaterial( STATIC.Materials.Hud.Main )
        STATIC.DamageRenderer:SetCoordinateRange( render2dClass.GetScreenResolution() )
        STATIC.DamageRenderer:EnableAdditive( true )

        STATIC.DamageReset()
    end

    --- @param index integer
    --- @param startX number
    --- @param startY number
    --- @param endX number
    --- @param endY number
    function STATIC.DamageAddIndicator( index, startX, startY, endX, endY )

        --- @type table<number,Vector>
        local vert = {}
        vert[0] = Vector( startX, startY )
        vert[1] = Vector( startX, endY   )
        vert[2] = Vector( endX,   startY )
        vert[3] = Vector( endX,   endY   )

        if not combatManagerClass.IsFirstPerson() then
            for i = 0, 3 do
                vert[i].x = vert[i].x * math.abs( 1 + vert[i].y ) -- "Skew"
                vert[i].y = vert[i].y / 2                         -- "Squash vertical"
                vert[i].y = vert[i].y + 0.25                      -- "Lower"
            end
        end

        local resolution = render2dClass.GetScreenResolution()

        for i = 0, 3 do
            -- "Numbers are -0.5 to 0.5, switch them to pixels, to match the info_renderer mode"
            vert[i].x = ( vert[i].x + 0.5 ) * resolution:Width()
            vert[i].y = ( vert[i].y + 0.5 ) * resolution:Height()
        end

        --- @type RectInstance
        local uv
        if bit.band( index, 1 ) == 1 then
            uv = rectClass.New( DAMAGE_2_UV_UL, DAMAGE_2_UV_LR )
        else
            uv = rectClass.New( DAMAGE_1_UV_UL, DAMAGE_1_UV_LR )
        end
        uv:ScaleVector( INFO_UV_SCALE )

        local intensity = math.Clamp( STATIC.DamageIndicatorIntensity[index] * 255, 0, 255 )
        local color = Color( intensity, intensity, intensity )

        if index == 3 or index == 4 then
            STATIC.DamageRenderer:AddQuad( vert[1], vert[3], vert[0], vert[2], uv, color )
        elseif index == 5 or index == 6 then
            STATIC.DamageRenderer:AddQuad( vert[0], vert[1], vert[2], vert[3], uv, color )
        elseif index == 7 or index == 0 then
            STATIC.DamageRenderer:AddQuad( vert[2], vert[0], vert[3], vert[1], uv, color )
        elseif index == 1 or index == 2 then
            STATIC.DamageRenderer:AddQuad( vert[3], vert[2], vert[1], vert[0], uv, color )
        end
    end

    function STATIC.DamageUpdate()
        STATIC.DamageRenderer:Reset()

        -- Don't show if damage indicators are disabled
        local areDamageIndicatorsEnabled = damageIndicatorsConVar:GetBool()
        if not areDamageIndicatorsEnabled then return end

        local newDamage = combatManagerClass.GetStarDamageDirection()

        if newDamage ~= 0 then
            STATIC.DamageIndicatorIntensityChanging = true
        end

        local indicatorsMatchPerspective = STATIC.DamageIndicatorOrientation == combatManagerClass.IsFirstPerson()
        if not STATIC.DamageIndicatorIntensityChanging and indicatorsMatchPerspective  then
            return
        end

        STATIC.DamageIndicatorOrientation = combatManagerClass.IsFirstPerson()
        STATIC.DamageIndicatorIntensityChanging = false

        -- "Update the intensities"
        combatManagerClass.ClearStarDamageDirection()

        for i = 0, ( NUM_DAMAGE_INDICATORS - 1 ) do
            -- "Apply new damage"
            local tookDamageInThisDirection = bit.band( newDamage, bit.lshift( 1, i ) ) ~= 0
            if tookDamageInThisDirection then
                STATIC.DamageIndicatorIntensity[i] = 1
                STATIC.DamageIndicatorIntensityChanging = true
            else
                if STATIC.DamageIndicatorIntensity[i] > 0 then
                    STATIC.DamageIndicatorIntensity[i] = STATIC.DamageIndicatorIntensity[i] - FrameTime() -- "and fade it away"
                    STATIC.DamageIndicatorIntensity[i] = math.Clamp( STATIC.DamageIndicatorIntensity[i], 0, 1 )
                    STATIC.DamageIndicatorIntensityChanging = true
                end
            end
        end

        -- "Redraw the indicators"
        STATIC.DamageAddIndicator( 0, -HORIZ_WIDTH / 2,				   -OFFSET_Y - HORIZ_HEIGHT / 2,	  HORIZ_WIDTH / 2,				    -OFFSET_Y + HORIZ_HEIGHT / 2	 )
        STATIC.DamageAddIndicator( 2,  OFFSET_X - VERT_WIDTH / 2,      -VERT_HEIGHT / 2,				  OFFSET_X + VERT_WIDTH / 2,		 VERT_HEIGHT / 2			     )
        STATIC.DamageAddIndicator( 4, -HORIZ_WIDTH / 2,				    OFFSET_Y - HORIZ_HEIGHT / 2,	  HORIZ_WIDTH / 2,				     OFFSET_Y + HORIZ_HEIGHT / 2	 )
        STATIC.DamageAddIndicator( 6, -OFFSET_X - VERT_WIDTH / 2,	   -VERT_HEIGHT / 2,				 -OFFSET_X + VERT_WIDTH / 2,		 VERT_HEIGHT / 2			     )
        STATIC.DamageAddIndicator( 1,  DIAG_OFFSET_X - DIAG_WIDTH / 2, -DIAG_OFFSET_Y - DIAG_HEIGHT / 2,  DIAG_OFFSET_X + DIAG_WIDTH / 2,	-DIAG_OFFSET_Y + DIAG_HEIGHT / 2 )
        STATIC.DamageAddIndicator( 3,  DIAG_OFFSET_X - DIAG_WIDTH / 2,  DIAG_OFFSET_Y - DIAG_HEIGHT / 2,  DIAG_OFFSET_X + DIAG_WIDTH / 2,	 DIAG_OFFSET_Y + DIAG_HEIGHT / 2 )
        STATIC.DamageAddIndicator( 5, -DIAG_OFFSET_X - DIAG_WIDTH / 2,  DIAG_OFFSET_Y - DIAG_HEIGHT / 2, -DIAG_OFFSET_X + DIAG_WIDTH / 2,	 DIAG_OFFSET_Y + DIAG_HEIGHT / 2 )
        STATIC.DamageAddIndicator( 7, -DIAG_OFFSET_X - DIAG_WIDTH / 2, -DIAG_OFFSET_Y - DIAG_HEIGHT / 2, -DIAG_OFFSET_X + DIAG_WIDTH / 2,	-DIAG_OFFSET_Y + DIAG_HEIGHT / 2 )
    end

    function STATIC.DamageRender()
        STATIC.DamageRenderer:Render()
    end
end
