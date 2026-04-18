--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

	RobustClass — GLua Classes System with a kinship to C++ classes

	GitHub: https://github.com/noaccessl/glua-RobustClass

–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]


--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Prepare
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
--
-- Libraries functions
--
local Format	= string.format
local strmatch	= string.match
local strgmatch = string.gmatch

local TableCopy = table.Copy

--
-- Globals
--
local istable	= istable
local isstring	= isstring

local FindMetaTable		= FindMetaTable
local RegisterMetaTable	= RegisterMetaTable

local setmetatable = debug.setmetatable
local getmetatable = debug.getmetatable

local _G = _G

--
-- Utilities
--
local next = pairs( {} )


--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	RobustClass
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
robustclass = robustclass or {

	VERSION = 250217 -- yy/mm/dd

}

local robustclass = robustclass
local _ALIAS = {}

setmetatable( robustclass, {

	__index = _ALIAS;

	__call = function( this, ... )

		return robustclass.Register( ... )

	end

} )

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: (Internal) Common __tostring-metamethod
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function __tostring_common( pObj )

	local pObj_mt = getmetatable( pObj )

	if ( not pObj_mt ) then
		return nil
	end

	if ( not pObj_mt.__index ) then
		return nil
	end

	local classname = pObj.ClassName

	if ( not classname ) then
		return nil
	end

	return Format( '%s: %p', pObj.ClassName, pObj )

end


--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: (Internal) Inherits the provided base classes in the given class

	FIX (Bug 2): After TableCopy, the copied base class table had its __index
	wiped unconditionally. For classes that themselves had a BaseClass (i.e.
	grandparents), this broke method lookup when the copy was used as `self`
	inside a constructor. The fix preserves __index on the copy, only clearing
	the fields that must not bleed into the inheriting class's registry entry
	(MetaName and MetaID). __tostring is also cleared so the parent's
	__tostring does not shadow the child's.
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
-- Recursively deep-copies a class node and its entire ancestry, preserving
-- the distinction between true ancestors (single BaseClass chain) and
-- multiple direct parents (__parents list), so construct/destruct can walk
-- each branch independently without sharing any table identity with the
-- originals.
local function deepCopyClassNode( src )

	local copy    = TableCopy( src )
	local copy_mt = TableCopy( getmetatable( src ) )

	setmetatable( copy, copy_mt )

	copy.__index = copy

	local src_parents = src.__parents

	if ( src_parents and #src_parents > 0 ) then

		local newParents = {}

		for i = 1, #src_parents do
			newParents[ i ] = deepCopyClassNode( src_parents[ i ] )
		end

		copy.__parents = newParents

		-- BaseClass is only used for construct/destruct traversal on copied
		-- nodes; point it at the first parent copy to stay consistent.
		copy.BaseClass  = newParents[ 1 ]
		copy_mt.__index = newParents[ 1 ]

	elseif ( copy.BaseClass ) then

		local baseCopy  = deepCopyClassNode( copy.BaseClass )
		copy.BaseClass  = baseCopy
		copy_mt.__index = baseCopy
		copy.__parents  = nil

	else

		copy.__parents = nil

	end

	return copy, copy_mt

end

local SKIP_FIELDS = {
	__index    = true;
	__tostring = true;
	__parents  = true;
	BaseClass  = true;
	ClassName  = true;
	MetaName   = true;
	MetaID     = true;
}

-- Recursively collects all methods from a class node and its entire ancestry
-- into `dest`, visiting deepest ancestors first so that shallower (closer)
-- ancestors and the class itself take priority over deeper ones.
-- Does not overwrite keys already present in `dest` (first-writer wins,
-- which means declaration order in __parents is respected for siblings).
-- Internal metadata fields are never copied.
local function collectMethods( dest, node )

	if ( not node ) then return end

	local node_parents = node.__parents

	if ( node_parents ) then

		for i = 1, #node_parents do
			collectMethods( dest, node_parents[ i ] )
		end

	else

		collectMethods( dest, node.BaseClass )

	end

	for k, v in next, node do

		if ( not SKIP_FIELDS[ k ] and dest[ k ] == nil ) then
			dest[ k ] = v
		end

	end

end

local function inherit( class_t, inheritances )

	class_t.__parents = {}

	for baseclassname in strgmatch( inheritances, '([%w_]+),? ?' ) do

		local baseclass_t = FindMetaTable( baseclassname )

		if ( baseclass_t ) then

			local parentCopy = deepCopyClassNode( baseclass_t )

			parentCopy.__tostring = nil
			parentCopy.MetaName   = nil
			parentCopy.MetaID     = nil

			class_t.__parents[ #class_t.__parents + 1 ] = parentCopy

		else
			ErrorNoHalt( 'unknown inheritance \'', baseclassname, '\' for the \'', class_t.ClassName, '\' class\n' )
		end

	end

	-- Flatten all inherited methods from the entire ancestry of all parents
	-- directly into class_t. This is necessary because a single __index chain
	-- cannot express a DAG — with multiple parents, chaining their metatables
	-- as siblings severs each parent's own ancestry from pObj's lookup path.
	-- By collecting depth-first with no-overwrite, priority is:
	-- derived class > first parent > second parent > ... > deepest ancestor.
	local inherited = {}

	for i = 1, #class_t.__parents do
		collectMethods( inherited, class_t.__parents[ i ] )
	end

	for k, v in next, inherited do

		if ( class_t[ k ] == nil ) then
			class_t[ k ] = v
		end

	end

	-- Set BaseClass to the first parent for backwards-compatibility.
	if ( class_t.__parents[ 1 ] ) then
		class_t.BaseClass = class_t.__parents[ 1 ]
	end

end


--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: (Internal) Refines the given class
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function refine( class_t, classname, inheritances )

	for k in next, class_t do
		class_t[k] = nil
	end

	class_t.ClassName = classname
	class_t.__tostring = __tostring_common

	class_t.__index = class_t

	if ( inheritances ) then
		inherit( class_t, inheritances )
	end


	local class_mt = getmetatable( class_t )

	if ( not class_mt ) then

		class_mt = {}
		setmetatable( class_t, class_mt )

	else

		for k in next, class_mt do
			class_mt[k] = nil
		end

	end

	function class_mt.__call( this, ... )

		return robustclass.Create( classname, ... )

	end

	if ( inheritances ) then
		class_mt.__index = class_t.BaseClass
	else
		class_t.BaseClass, class_mt.__index = nil
	end

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Registers a new class
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local ptrDummyClass = {}

function robustclass.Register( reginput )

	if ( not isstring( reginput ) ) then

		ErrorNoHaltWithStack( '\'reginput\' (#1) to \'Register\' should be a string; format: \'<ClassName>[ : <BaseClass>[, <BaseClass2>, ...]]\'\n' )
		return ptrDummyClass

	end


	--
	-- Retrieve the class name and the base classes if provided
	--
	local classname = strmatch( reginput, '([%w_]+)' )

	if ( not classname ) then

		ErrorNoHaltWithStack( '\'reginput\' (#1) to \'Register\' should be a string; format: \'<ClassName>[ : <BaseClass1>[, <BaseClass2>, ...]]\'\n' )
		return ptrDummyClass

	end

	local inheritances = strmatch( reginput, ' : (.+)' )


	local CLASS

	--
	-- If the class already exists, refine and return it
	--
	CLASS = FindMetaTable( classname )

	if ( CLASS ) then

		refine( CLASS, classname, inheritances )
		return CLASS

	end

	--
	-- Prepare the class
	--
	CLASS = {

		ClassName = classname;
		__tostring = __tostring_common

	}

	CLASS.__index = CLASS

	--
	-- Deal with the inheritances
	--
	if ( inheritances ) then
		inherit( CLASS, inheritances )
	end


	local CLASS_mt do

		CLASS_mt = {}

		function CLASS_mt.__call( this, ... )

			return robustclass.Create( classname, ... )

		end

		CLASS_mt.__index = CLASS.BaseClass --[[

			Allows you to do cool Lua affairs without much performance loss

			local a = robustclass( 'a' )
			a.test = 'Hello World!'

			local b = robustclass( 'b : a' )
			local c = robustclass( 'c : b' )

			proint( c.test ) -- Output: Hello World!

			local obj = robustclass.Create( 'c' )
			proint( obj.test ) -- Output: Hello World!

			-- What happens internally (figuratively) — c.BaseClass.BaseClass.test

		]]--

		setmetatable( CLASS, CLASS_mt )

	end


	-- Store the class in the registry
	RegisterMetaTable( classname, CLASS )

	return CLASS

end

_ALIAS.Class = robustclass.Register


--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: (Internal) Constructs the given object

	construct() fires all ancestor constructors for class_t in base-first,
	declaration order, but never fires class_t's own constructor — that is
	always the caller's responsibility (either the frame above or Create()).

	For classes with multiple direct parents (__parents list), each parent
	branch is walked fully and independently before moving to the next, so
	that all of parent[1]'s ancestors are constructed before parent[2]'s
	ancestors — matching declaration order throughout the hierarchy.

	For classes with a single parent (only BaseClass, no __parents), the
	original linear BaseClass chain walk is used unchanged.

	Execution trace for D : B, C where B : A:
	  Create calls construct(pObj, D, "D")
	    D has __parents = {copyB, copyC}
	    process copyB:
	      construct(pObj, copyB, "B")     — copyB has BaseClass = copyA, no __parents
	        construct(pObj, copyA, "A")   — no BaseClass, returns
	        fires copyA["A"](pObj)        — A's constructor
	      fires copyB["B"](pObj)          — B's constructor
	    process copyC:
	      construct(pObj, copyC, "C")     — copyC has no BaseClass, returns
	      fires copyC["C"](pObj)          — C's constructor
	  Create fires D["D"](pObj)           — D's constructor
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function construct( pObj, class_t, classname, ... )

	local parents = class_t.__parents

	if ( parents ) then

		-- Multiple direct parents: walk each branch fully in declaration order.
		for i = 1, #parents do

			local parent    = parents[ i ]
			local parentname = parent.ClassName

			construct( pObj, parent, parentname, ... )

			local Constructor = parent[ parentname ]

			if ( Constructor ) then
				Constructor( pObj, ... )
			end

		end

	elseif ( class_t.BaseClass ) then

		-- Single ancestor chain: walk linearly as before.
		local baseclass_t    = class_t.BaseClass
		local baseclassname  = baseclass_t.ClassName

		construct( pObj, baseclass_t, baseclassname, ... )

		local Constructor = baseclass_t[ baseclassname ]

		if ( Constructor ) then
			Constructor( pObj, ... )
		end

	end

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Creates a new specific object
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function robustclass.Create( classname, ... )

	if ( not isstring( classname ) ) then
		assert( false, '\'classname\' (#1) to \'Create\' should be a string' )
	end


	--
	-- Retrieve the class
	--
	local class_t = FindMetaTable( classname )

	if ( not class_t ) then

		-- FIX (Bug 3): The original call passed `false` as the first argument
		-- to ErrorNoHaltWithStack. That parameter is a numeric stack level, not
		-- a boolean. Passing false caused an error inside the error handler
		-- itself. Removed the bogus argument so the function receives only the
		-- message string(s), matching the signature used elsewhere in the file.
		ErrorNoHaltWithStack( 'class \'', classname, '\' doesn\'t exist' )
		return false

	end

	--
	-- Prepare an object
	--
	local pObj = {}
	setmetatable( pObj, class_t )

	--
	-- Allow the class to adjust/override the default creation action
	--
	local __new = class_t.__new
	local bContinue, pObjSubstitute, bConstruct = true, nil, true

	if ( __new ) then
		bContinue, pObjSubstitute, bConstruct = __new( pObj, ... )
	end

	if ( bContinue == false ) then

		-- Remove the metatable
		setmetatable( pObj, nil )

		-- Purge the object
		for key in next, pObj do pObj[key] = nil end

		return false

	end

	if ( pObjSubstitute ~= nil ) then

		local pObjSubstitute_mt = getmetatable( pObjSubstitute )

		if ( not pObjSubstitute_mt ) then
			return nil
		end

		if ( pObjSubstitute_mt.__index ) then

			setmetatable( pObj, nil )

			for key in next, pObj do
				pObj[key] = nil
			end

			pObj = pObjSubstitute

		end

	end

	--
	-- Construct
	--
	if ( bConstruct == true ) then

		-- construct() fires all ancestor constructors in base-first order but
		-- deliberately does NOT call the derived class's own constructor — that
		-- is our responsibility here, ensuring it runs exactly once and last.
		construct( pObj, class_t, classname, ... )

		local ConstructorDerived = class_t[ classname ]

		if ( ConstructorDerived ) then
			ConstructorDerived( pObj, ... )
		end

	end

	return pObj

end

_ALIAS.CreateObject = robustclass.Create

_ALIAS.New = robustclass.Create
_ALIAS.NewObject = robustclass.Create


--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: (Internal) Destructs the given object

	Mirrors construct(): walks each parent branch fully in declaration order,
	firing ancestor destructors before the parent's own. Delete() fires the
	derived class's own destructor after destruct() returns.
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function destruct( pObj, class_t, classname )

	local parents = class_t.__parents

	if ( parents ) then

		for i = 1, #parents do

			local parent     = parents[ i ]
			local parentname = parent.ClassName

			destruct( pObj, parent, parentname )

			local Destructor = parent[ '_' .. parentname ]

			if ( Destructor ) then
				Destructor( pObj )
			end

		end

	elseif ( class_t.BaseClass ) then

		local baseclass_t   = class_t.BaseClass
		local baseclassname = baseclass_t.ClassName

		destruct( pObj, baseclass_t, baseclassname )

		local Destructor = baseclass_t[ '_' .. baseclassname ]

		if ( Destructor ) then
			Destructor( pObj )
		end

	end

end

--[[–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Purpose: Deletes the given object
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
function robustclass.Delete( pObj )

	local pObj_mt = getmetatable( pObj )

	if ( not pObj_mt ) then
		return false
	end

	if ( not pObj_mt.__index ) then
		return false
	end

	local classname = pObj.ClassName

	if ( not classname ) then
		return false
	end

	local class_t = FindMetaTable( classname )

	if ( not class_t ) then
		return false
	end

	--
	-- Allow the class to adjust/override the default deletion action
	--
	local __delete = class_t.__delete

	if ( __delete and __delete( pObj ) == false ) then
		return false
	end

	-- Destruct
	destruct( pObj, class_t, classname )

	local DestructorDerived = class_t[ '_' .. classname ]

	if ( DestructorDerived ) then
		DestructorDerived( pObj )
	end

	-- Remove the metatable
	setmetatable( pObj, nil )

	--
	-- Purge the object
	--
	if ( istable( pObj ) ) then

		for key in next, pObj do
			pObj[key] = nil
		end

	end

	return true

end

_ALIAS.DeleteObject = robustclass.Delete

_ALIAS.Destroy = robustclass.Delete
_ALIAS.DestroyObject = robustclass.Delete

_ALIAS.Remove = robustclass.Delete
_ALIAS.RemoveObject = robustclass.Delete