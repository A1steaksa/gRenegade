-- Based on PrototypeLoaderClass within Code/ww3d2/proto.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class PrototypeLoaderClass
--- @field Instance PrototypeLoaderInstance The metatable used by PrototypeLoaderInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PrototypeLoaderClass"

--- @class PrototypeLoaderInstance
--- @field Static PrototypeLoaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PrototypeLoader" )
INSTANCE.Class = "PrototypeLoaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPrototypeLoader = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PrototypeLoaderClass

    --- Creates a new PrototypeLoaderInstance
    --- @return PrototypeLoaderInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PrototypeLoader" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PrototypeLoaderInstance, `false` otherwise
    function STATIC.IsPrototypeLoader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPrototypeLoader and true or false
    end

    typecheck.RegisterType( "PrototypeLoaderInstance", STATIC.IsPrototypeLoader )
end


--- "  
--- This is the interface for an object which recognizes a certain chunk type in a W3D file and can load  
--- it and create a [PrototypeInstance] for it.  
--- "  
--- @class PrototypeLoaderInstance

function INSTANCE:Renegade_PrototypeLoader()
    -- Empty in the original code
end

function INSTANCE:_Renegade_PrototypeLoader()
    -- Empty in the original code
end

--- @return integer
function INSTANCE:ChunkType()
    CNC.VirtualFunction()
end

--- @param cload ChunkLoadInstance
--- @return PrototypeInstance
function INSTANCE:LoadW3d( cload )
    CNC.VirtualFunction()
end
