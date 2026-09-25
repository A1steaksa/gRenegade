-- Based on PathMgrClass within Code/wwphys/pathmgr.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class PathManagerClass
--- @field Instance PathManagerInstance The metatable used by PathManagerInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PathManagerClass"

--- @class PathManagerInstance
--- @field Static PathManagerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PathManager" )
INSTANCE.Class = "PathManagerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPathManager = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PathManagerClass
	--- @field AvailablePathList DynamicVectorClassPathSolveInstance
	--- @field UsedPathList DynamicVectorClassPathSolveInstance
	--- @field ActivePath PathSolveInstance
	--- @field TicksPerMilliSec Int64Instance

    --- Creates a new PathManagerInstance
    --- @return PathManagerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PathManager" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PathManagerInstance, `false` otherwise
    function STATIC.IsPathManager( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPathManager and true or false
    end

    typecheck.RegisterType( "PathManagerInstance", STATIC.IsPathManager )

	function STATIC.Initialize()
		typecheck.NotImplementedError()
	end

	function STATIC.Shutdown()
		typecheck.NotImplementedError()
	end

	function STATIC.ResolvePaths()
		typecheck.NotImplementedError()
	end

	function STATIC.PeekActivePath()
		typecheck.NotImplementedError()
	end

	function STATIC.Save()
		typecheck.NotImplementedError()
	end

	function STATIC.Load()
		typecheck.NotImplementedError()
	end

	function STATIC.RequestPathObject()
		typecheck.NotImplementedError()
	end

	function STATIC.ReturnPathObject()
		typecheck.NotImplementedError()
	end

	function STATIC.AllocateObjects()
		typecheck.NotImplementedError()
	end

	function STATIC.FreeObjects()
		typecheck.NotImplementedError()
	end

	function STATIC.ActivateNewPriorityPath()
		typecheck.NotImplementedError()
	end
end


--- @class PathManagerInstance
