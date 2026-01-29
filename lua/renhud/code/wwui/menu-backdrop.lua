-- Based on MenuBackDropClass within Code/wwui/menubackdrop.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class MenuBackdropClass
--- @field instance MenuBackdropInstance The metatable used by MenuBackdropInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "MenuBackdropClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class MenuBackdropInstance
--- @field Static MenuBackdropClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MenuBackdrop" )
INSTANCE.Class = "MenuBackdropInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMenuBackdrop = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class MenuBackdropClass

    --- Creates a new MenuBackdropInstance
    --- @return MenuBackdropInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MenuBackdrop" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MenuBackdropInstance, `false` otherwise
    function STATIC.IsMenuBackdrop( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMenuBackdrop and true or false
    end

    typecheck.RegisterType( "MenuBackdropInstance", STATIC.IsMenuBackdrop )
end


--- @class MenuBackdropInstance
--- @field Scene SimpleSceneInstance
--- @field Camera CameraInstance
--- @field AnimationName string
--- @field Model RenderObjectInstance
--- @field Anim AnimInstance
--- @field ClearScreen boolean

--- Constructs a new MenuBackdropInstance
function INSTANCE:Renegade_MenuBackdrop()
    self.Scene = nil
    self.Camera = nil
    self.Model = nil
    self.Anim = nil
    self.ClearScreen = true

    -- "Create a scene to use for the background"

    -- "Create a single scene light"
        -- "Configure the light"
        -- "Add this light to the scene"

    -- "Create a camera to use in background-scene"

    -- "Configure the view plane"

    -- "Set the clip planes"
end


--[[ Display Methods ]] do

    function INSTANCE:Render()
        typecheck.NotImplementedError()
    end
end


--[[ Configuration ]] do

    --- @param name string
    function INSTANCE:SetModel( name )
        typecheck.NotImplementedError()
    end

    --- @param
    function INSTANCE:RemoveModel()
        typecheck.NotImplementedError()
    end

    --- @param animName string
    function INSTANCE:SetAnimation( animName )
        typecheck.NotImplementedError()
    end

    --- @param percent number
    function INSTANCE:SetAnimationPercentage( percent )
        typecheck.NotImplementedError()
    end
end


--- @param shouldClear boolean
function INSTANCE:ClearScreen( shouldClear )
    self.ClearScreen = shouldClear
end


--[[ Accessors ]] do

    --- @return SimpleSceneInstance
    function INSTANCE:PeekScene()
        return self.Scene
    end

    --- @return CameraInstance
    function INSTANCE:PeekCamera()
        return self.Camera
    end

    --- @return RenderObjectInstance
    function INSTANCE:PeekModel()
        return self.Model
    end
end


function INSTANCE:PlayAnimation()
    typecheck.NotImplementedError()
end
