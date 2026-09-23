--- @class Renegade
local CNC = CNC_RENEGADE

--- @class AnimationTool
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "AnimationTool"

if not CLIENT then return end

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ToolsLib
	local toolsLib = CNC.Import( "sh_tools.lua" )

	--- @type FileClass
	local fileClass = CNC.Import( "code/wwlib/file.lua" )

	--- @type WW3dFileFormatIds
	local wW3dFileFormatIds = CNC.Import( "code/ww3d2/ww3d-format.lua" )

	--- @type HumanStateClass
	local humanStateClass = CNC.Import( "code/combat/human-state.lua" )

	--- @type Ww3dAssetManagerClass
	local ww3dAssetManagerClass = CNC.Import( "code/ww3d2/ww3d-asset-manager.lua" )

	--- @type PlayerLib
	local playerLib = CNC.Import( "sh_players.lua" )
--#endregion

--#region Imported Enums

	local humanStateTypeEnum = humanStateClass.HUMAN_STATE_TYPE
	local humanSubStateTypeEnum = humanStateClass.HUMAN_SUB_STATE_TYPE
--#endregion


--- @class AnimationToolState
--- @field X integer
--- @field Y integer
--- @field CameraYaw number
--- @field CameraPitch number
--- @field CameraDistance number
--- @field SelectedState number
--- @field SelectedSubState number
--- @field IsPlaying boolean
--- @field FrameNumber number


--- @class AnimationTool

--- @param previousState AnimationToolState
--- @return HotloadableDFrame
function STATIC.OpenTool( previousState )
    local state
    if previousState == nil then
        state = {
            X = 0, Y = 0,
            CameraYaw = 180,
            CameraPitch = 0,
            CameraDistance = 65
        }
    else
        state = previousState
    end

    local width = 400
    local height = 600

    local frame = vgui.Create( "HotloadableDFrame" )
    frame:SetTitle( "Animation Tool" )
    frame:SetSize( width, height )
    frame:SetPos( ScrW() / 5 - width / 2, ScrH() / 2 )
    frame:MakePopup()

    local menuBar = vgui.Create( "DMenuBar", frame )
    menuBar:DockMargin( -3, -6, -3, 0 )

    local mainPanel = vgui.Create( "DPanel", frame )
    mainPanel:Dock( FILL )

    -- State
    local stateDropdown = vgui.Create( "DComboBox", mainPanel )
    stateDropdown:SetHeight( 30 )
    stateDropdown:SetText( "Soldier State" )
    stateDropdown:Dock( TOP )
    for key, value in pairs( humanStateTypeEnum ) do
        stateDropdown:AddChoice( key, value )
    end

    -- Sub-State
    local subStateDropdown = vgui.Create( "DComboBox", mainPanel )
    subStateDropdown:SetText( "Soldier Sub-State" )
    subStateDropdown:SetHeight( 30 )
    subStateDropdown:Dock( TOP )
    for key, value in pairs( humanSubStateTypeEnum ) do
        subStateDropdown:AddChoice( key, value )
    end

    -- Animation Name Label
    local animationNameLabel = vgui.Create( "DLabel", mainPanel )
    animationNameLabel:Dock( TOP )
    animationNameLabel:SetDark( true )
    animationNameLabel:DockMargin( 10, 10, 0, 0 )
    animationNameLabel:SetText( "Animation: None" )

    -- Pitch
    --- @class DNumSlider
    local pitchSlider = vgui.Create( "DNumSlider", mainPanel )
    pitchSlider:Dock( TOP )
    pitchSlider:SetDark( true )
    pitchSlider:SetText( "Pitch" )
    pitchSlider:SetMin( -45 )
    pitchSlider:SetMax( 45 )
    pitchSlider:SetDecimals( 0 )
    pitchSlider:SetHeight( 40 )
    pitchSlider:DockMargin( 10, 0, 0, 0 )
    pitchSlider:SetValue( state.CameraPitch )

    --- @param value number
    function pitchSlider:OnValueChanged( value )
        state.CameraPitch = value
    end

    -- Yaw
    --- @class DNumSlider
    local yawSlider = vgui.Create( "DNumSlider", mainPanel )
    yawSlider:Dock( TOP )
    yawSlider:SetDark( true )
    yawSlider:SetText( "Yaw" )
    yawSlider:SetMin( 0 )
    yawSlider:SetMax( 360 )
    yawSlider:SetDecimals( 0 )
    yawSlider:SetHeight( 40 )
    yawSlider:DockMargin( 10, 0, 0, 0 )
    yawSlider:SetValue( state.CameraYaw )

    --- @param value number
    function yawSlider:OnValueChanged( value )
        state.CameraYaw = value
    end

    -- Distance
    --- @class DNumSlider
    local distanceSlider = vgui.Create( "DNumSlider", mainPanel )
    distanceSlider:Dock( TOP )
    distanceSlider:SetDark( true )
    distanceSlider:SetText( "Distance" )
    distanceSlider:SetMin( 0 )
    distanceSlider:SetMax( 200 )
    distanceSlider:SetDecimals( 0 )
    distanceSlider:SetHeight( 40 )
    distanceSlider:DockMargin( 10, 0, 0, 0 )
    distanceSlider:SetValue( state.CameraDistance )

    --- @param value number
    function distanceSlider:OnValueChanged( value )
        state.CameraDistance = value
    end

    local frameNumber
    do -- Timeline
        local timelinePanel = vgui.Create( "DPanel", mainPanel )
        timelinePanel:DockMargin( 10, 0, 0, 0 )
        timelinePanel:Dock( TOP )
        timelinePanel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )

        local label = vgui.Create( "DLabel", timelinePanel )
        label:Dock( LEFT )
        label:SetDark( true )
        label:SetText( "Frame" )

        frameNumber = vgui.Create( "DNumberScratch", timelinePanel )
        frameNumber:Dock( FILL )
        frameNumber:SetMin( 0 )
        frameNumber:SetMax( 100 )

        local playPauseButton = vgui.Create( "DButton", timelinePanel )
        playPauseButton:Dock( RIGHT )
        playPauseButton:SetText( "Play" )
        function playPauseButton:DoClick()
            if state.IsPlaying ~= nil then
                state.IsPlaying = nil
                self:SetText( "Play" )
            else
                state.IsPlaying = true
                self:SetText( "Pause" )
            end
        end

        function frameNumber:OnValueChanged( newValue )
            local soldier = playerLib.GetPlayerSoldier( LocalPlayer() )

            if soldier == nil then
                section.Warn( "Local player doesn't have a soldier game object!" )
                return
            end

            if soldier.HumanState == nil then
                section.Warn( "Local player doesn't have a HumanState!" )
                return
            end

            soldier.AnimationControl:SetTargetFrame( newValue )
        end

    end

    -- Reset
    local resetButton = vgui.Create( "DButton", mainPanel )
    resetButton:Dock( BOTTOM )
    resetButton:SetText( "Reset Animations System" )
    function resetButton:DoClick()
        local assetManager = ww3dAssetManagerClass.GetInstance()
        local animationManager = assetManager.HAnimationManager
        animationManager:FreeAllAnims()
        animationManager:ResetMissing()

        local soldier = playerLib.GetPlayerSoldier( LocalPlayer() )
        if soldier == nil then
            section.Warn( "Local player doesn't have a soldier game object!" )
            return
        end

        if soldier.HumanState == nil then
            section.Warn( "Local player doesn't have a HumanState!" )
            return
        end

        soldier.HumanState:SetSubState( humanSubStateTypeEnum.SUB_STATE_SLOW )
    end

    -- Apply
    local applyButton = vgui.Create( "DButton", mainPanel )
    applyButton:SetHeight( 75 )
    applyButton:Dock( BOTTOM )
    applyButton:SetText( "Apply" )
    function applyButton:DoClick()
        local soldier = playerLib.GetPlayerSoldier( LocalPlayer() )

        if soldier == nil then
            section.Warn( "Local player doesn't have a soldier game object!" )
            return
        end

        if soldier.HumanState == nil then
            section.Warn( "Local player doesn't have a HumanState!" )
            return
        end

        local stateName, stateValue = stateDropdown:GetSelected()
        local subStateName, subStateValue = subStateDropdown:GetSelected()

        section.Print( "Setting state to ", stateName, " (", stateValue, ") and substate to ", subStateName, " (", subStateValue, ")" )

        soldier.HumanState:SetState( stateValue, subStateValue )
        animationNameLabel:SetText( "Animation: " .. soldier.AnimationControl:GetAnimationName() )
    end

    --- @param ply Player
    --- @param origin Vector
    --- @param angles Angle
    --- @param fov number
    --- @param znear number
    --- @param zfar number
    --- @return CamData
    hook.Add( "CalcView", frame, function( frame, ply, origin, angles, fov, znear, zfar )

        local camYaw = math.rad( state.CameraYaw + 180 )
        local camPitch = math.rad( state.CameraPitch )
        local x = math.cos( camYaw ) * state.CameraDistance
        local y = math.sin( camYaw ) * state.CameraDistance
        local z =  - math.tan( camPitch ) * state.CameraDistance

        origin:Add( Vector( x, y, z ) )
        angles:Add( Angle( -state.CameraPitch, state.CameraYaw, 0 ) )

        --- @type CamData
        return {
            origin = origin,
            angles = angles,
            fov = fov,
            znear = znear,
            zfar = zfar,
            drawviewer = true
        }
    end )

    if previousState ~= nil then
        frame:SetPos( previousState.X, previousState.Y )
        yawSlider:SetValue( previousState.CameraYaw )
        pitchSlider:SetValue( previousState.CameraPitch )
        distanceSlider:SetValue( previousState.CameraDistance )

        if state.SelectedState then
            stateDropdown:ChooseOptionID( state.SelectedState )
        end

        if state.SelectedSubState then
            subStateDropdown:ChooseOptionID( state.SelectedSubState )
        end
    end



    function frame:ExportState()

        state.X = frame:GetX()
        state.Y = frame:GetY()

        state.SelectedState = stateDropdown:GetSelectedID()
        state.SelectedSubState = subStateDropdown:GetSelectedID()

        state.FrameNumber = frameNumber:GetFloatValue()

        return state
    end

    return frame
end

toolsLib.RegisterTool( "ren_animation_tool", STATIC.OpenTool )