-- Based on HTreeManagerClass within Code/ww3d2/htreemgr.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class HTreeManagerClass
--- @field Instance HTreeManagerInstance The metatable used by HTreeManagerInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "HTreeManagerClass"

--- @class HTreeManagerInstance
--- @field Static HTreeManagerClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_HTreeManager" )
INSTANCE.Class = "HTreeManagerInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsHTreeManager = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type HTreeClass
	local hTreeClass = CNC.Import( "code/ww3d2/h-tree.lua" )
--#endregion

--#region Imported Enums

	local hTreeLoadResultEnum = hTreeClass.H_TREE_LOAD_RESULT
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class HTreeManagerClass

    --- Creates a new HTreeManagerInstance
    --- @return HTreeManagerInstance
    function STATIC.New()
        return robustclass.New( "Renegade_HTreeManager" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) HTreeManagerInstance, `false` otherwise
    function STATIC.IsHTreeManager( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsHTreeManager and true or false
    end

    typecheck.RegisterType( "HTreeManagerInstance", STATIC.IsHTreeManager )
end


--- @class HTreeManagerInstance
--- @field Trees HTreeInstance[]
--- @field TreeHash {[string]: HTreeInstance}

function INSTANCE:Renegade_HTreeManager()
    self.Trees = {}
    self.TreeHash = {}
end

function INSTANCE:_Renegade_HTreeManager()
    self:Free()
end

--- "Load a hierarchy tree from a file"
--- @param cload ChunkLoadInstance
--- @return integer
function INSTANCE:LoadTree( cload )
	local newTree = hTreeClass.New()

    if newTree == nil then
        return 1
    end

    if newTree:LoadW3d( cload ) ~= hTreeLoadResultEnum.OK then
        -- "Load failed, delete and return error"
        return 1
    elseif self:GetTreeId( newTree:GetName() ) ~= -1 then
        -- "Tree with this name already exists, reject it!"
        return 1
    else
        -- "Ok, accept this hierarchy tree!"
        self.Trees[#self.Trees+1] = newTree

        -- "Insert to hash table for fast name based search"
        local name = newTree:GetName()
        section.Warn( "Name: '", name, "' " )
        local lowerCaseName = newTree:GetName():lower()
        self.TreeHash[lowerCaseName] = newTree
    end
    return 0
end

--- @return integer
function INSTANCE:NumTrees()
	return #self.Trees
end

--- "get a pointer to the specified hierarchy tree"
--- @param name string
--- @return HTreeInstance?
--- @overload fun( id: integer ): HTreeInstance?
function INSTANCE:GetTree( name )
    typecheck.AssertArgType( INSTANCE.Class, 1, name, { "string", "number" } )

    -- ( name: string ): HTreeInstance?
    if isstring( name ) then
        return self.TreeHash[name:lower()]

    -- ( id: integer ): HTreeInstance?
    else
        local id = name --[[@as integer]]
        if id >= 1 and id <= self:NumTrees() then
            return self.Trees[id]
        else
            return nil
        end
    end
end

function INSTANCE:GetTreeHandle()
    -- Never implemented in the original code
	typecheck.NotImplementedError()
end

--- "De-allocates all hierarchy trees currently loaded"
function INSTANCE:FreeAllTrees()
    self.TreeHash = {}
    self.Trees = {}
end

--- "Look up the ID of a named hierarchy tree"
--- @param name string
--- @return integer
function INSTANCE:GetTreeId( name )
	for i = 1, #self.Trees do
        if self.Trees[i] and name == self.Trees[i]:GetName() then
            return i
        end
    end
    return -1
end

--- "Look up the name of a id'd hierarchy tree"
--- @param id integer
--- @return string
function INSTANCE:GetTreeName( id )
    if id <= self:NumTrees() and self.Trees[id] then
        if self.Trees[id] then
            return self.Trees[id]:GetName()
        end
    end
end

--- "De-allocate all memory in use"
function INSTANCE:Free()
    self:FreeAllTrees()
end
