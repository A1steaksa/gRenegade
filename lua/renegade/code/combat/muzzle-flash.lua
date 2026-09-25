-- Based on MuzzleFlashClass within Code/Combat/weapons.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MuzzleFlashClass
--- @field Instance MuzzleFlashInstance The metatable used by MuzzleFlashInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MuzzleFlashClass"

--- @class MuzzleFlashInstance
--- @field Static MuzzleFlashClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MuzzleFlash" )
INSTANCE.Class = "MuzzleFlashInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMuzzleFlash = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class MuzzleFlashClass

    --- Creates a new MuzzleFlashInstance
    --- @return MuzzleFlashInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MuzzleFlash" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MuzzleFlashInstance, `false` otherwise
    function STATIC.IsMuzzleFlash( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMuzzleFlash and true or false
    end

    typecheck.RegisterType( "MuzzleFlashInstance", STATIC.IsMuzzleFlash )
end


--- @class MuzzleFlashInstance
--- @field MuzzleA0bOne integer
--- @field MuzzleA1bOne integer
--- @field Rotation number
--- @field Model any
--- @field LastFlashA0 boolean
--- @field LastFlashA1 boolean

function INSTANCE:Renegade_MuzzleFlash()
	typecheck.NotImplementedError()
end

function INSTANCE:_Renegade_MuzzleFlash()
	typecheck.NotImplementedError()
end

function INSTANCE:Init()
	typecheck.NotImplementedError()
end

function INSTANCE:Update()
	typecheck.NotImplementedError()
end
