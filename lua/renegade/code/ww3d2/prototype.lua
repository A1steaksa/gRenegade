-- Based on PrototypeClass within Code/ww3d2/proto.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class PrototypeClass
--- @field Instance PrototypeInstance The metatable used by PrototypeInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "PrototypeClass"

--- @class PrototypeInstance
--- @field Static PrototypeClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Prototype" )
INSTANCE.Class = "PrototypeInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPrototype = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type MeshLoaderClass
	local meshLoaderClass = CNC.Import( "code/ww3d2/mesh-loader.lua" )

	--- @type HModelLoaderClass
	local hModelLoaderClass = CNC.Import( "code/ww3d2/h-model-loader.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class PrototypeClass
    --- @field MeshLoader MeshLoaderInstance

    --- Creates a new PrototypeInstance
    --- @return PrototypeInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Prototype" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PrototypeInstance, `false` otherwise
    function STATIC.IsPrototype( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPrototype and true or false
    end

    typecheck.RegisterType( "PrototypeInstance", STATIC.IsPrototype )

    function STATIC.StaticConstructor()
        STATIC.MeshLoader = meshLoaderClass.New()
        STATIC.HModelLoader = hModelLoaderClass.New()
    end
end


--- "  
--- This class is a generic interface to a render object prototype.  
--- The asset manager will store a these and use them whenever the
--- user wants to create an instance of a named render object.
--- Some simple render objects will be created through cloning.  In
--- that case, their associated prototype simply stores an object and
--- clones it whenever the Create method is called.  More complex
--- composite render objects will be created from a "blueprint" object.  
--- Basically this class simply associates a name with a render object 
--- creation function.  
--- "
--- @class PrototypeInstance

--- @param that PrototypeInstance?
function INSTANCE:Renegade_Prototype( that )
    -- Omitted setting the next hash
end

function INSTANCE:_Renegade_Prototype()
	-- Empty in the original code
end

--- @return string
function INSTANCE:GetName()
    CNC.VirtualFunction()
end

--- @return integer
function INSTANCE:GetClassId()
	CNC.VirtualFunction()
end

--- @return RenderObjectInstance
function INSTANCE:Create()
    CNC.VirtualFunction()
end
