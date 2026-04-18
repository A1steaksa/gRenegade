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
-- Recursively deep-copies a class node and its entire BaseClass chain,
-- giving each node its own isolated table and metatable so that nothing
-- in the copy shares identity with the original registered classes.
-- This means mutations made while chaining (e.g. setting BaseClass or
-- metatable.__index to the next node) can never corrupt the originals.
local function deepCopyClassNode( src )

	local copy    = TableCopy( src )
	local copy_mt = TableCopy( getmetatable( src ) )

	setmetatable( copy, copy_mt )

	-- Self-referential __index: point to the copy, not the original.
	copy.__index = copy

	-- Recursively deep-copy the BaseClass chain so no node is shared.
	if ( copy.BaseClass ) then

		local baseCopy    = deepCopyClassNode( copy.BaseClass )
		copy.BaseClass    = baseCopy
		copy_mt.__index   = baseCopy

	end

	return copy, copy_mt

end

local function inherit( class_t, inheritances )

	local BaseClassFormer
	local BaseClassFormer_mt

	for baseclassname in strgmatch( inheritances, '([%w_]+),? ?' ) do

		local baseclass_t = FindMetaTable( baseclassname )

		if ( baseclass_t ) then

			-- Deep-copy the entire BaseClass chain of this ancestor so that
			-- no part of the copy is shared with the original registered class
			-- or with any previously built chain. A shallow TableCopy is not
			-- sufficient: it leaves BaseClass and metatable.__index pointing at
			-- the same tables as the original, so chaining mutations (setting
			-- BaseClassFormer.BaseClass = nextCopy) would corrupt the originals
			-- and break inheritance for every other class that extends them.
			local BaseClassLatter, BaseClassLatter_mt = deepCopyClassNode( baseclass_t )

			-- Strip registry-identity fields that must not bleed into the child.
			BaseClassLatter.__tostring = nil
			BaseClassLatter.MetaName   = nil
			BaseClassLatter.MetaID     = nil

			if ( BaseClassFormer ) then

				BaseClassFormer.BaseClass  = BaseClassLatter
				BaseClassFormer_mt.__index = BaseClassLatter

				BaseClassFormer    = BaseClassLatter
				BaseClassFormer_mt = BaseClassLatter_mt

			else

				class_t.BaseClass  = BaseClassLatter
				BaseClassFormer    = BaseClassLatter
				BaseClassFormer_mt = BaseClassLatter_mt

			end

		else
			ErrorNoHalt( 'unknown inheritance \'', baseclassname, '\' for the \'', class_t.ClassName, '\' class\n' )
		end

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

	FIX (Bug 1 — primary): The original code used a local `ignite` variable
	assignment (`ignite = true`) at the end of the function to signal that
	subsequent recursive calls should fire base-class constructors. Because Lua
	passes primitives by value, this assignment only mutated the local copy and
	never propagated back to the caller, so `ignite` was always nil/falsy on
	every call. As a result, ConstructorLatter (the base-class constructor) was
	*never* called, silently swallowing all base-class constructors.

	The fix uses a strict caller-fires design: `construct` is responsible only
	for firing the constructors of ancestors of `class_t`, never `class_t`'s
	own constructor. That responsibility belongs exclusively to the caller one
	level up — either the next `construct` frame or `robustclass.Create` for
	the derived class itself. This guarantees each constructor fires exactly
	once in base-first, derived-last order with no duplication.

	Execution trace for C : B : A, called as construct(pObj, C, "C"):
	  construct(pObj, C,  "C")   — recurses into B
	    construct(pObj, B,  "B") — recurses into A
	      construct(pObj, A,  "A") — no BaseClass, returns immediately
	    fires A["A"](pObj)         — A's constructor (called by B's frame)
	    fires B["B"](pObj)         — B's constructor (called by B's frame)
	  fires C["C"](pObj)           — C's constructor (called by Create)
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function construct( pObj, class_t, classname, ... )

	-- Walk down to the deepest ancestor first.
	local baseclass_t = class_t.BaseClass

	if ( baseclass_t ) then

		local baseclassname = baseclass_t.ClassName

		construct( pObj, baseclass_t, baseclassname, ... )

		-- Fire every ancestor's constructor on the way back up. This frame is
		-- responsible for calling baseclass_t's constructor; the frame above us
		-- will call class_t's constructor, and so on up to Create().
		local Constructor = baseclass_t[ baseclassname ]

		if ( Constructor ) then
			Constructor( pObj, ... )
		end

	end

	-- Deliberately no call to class_t[classname] here. The caller is always
	-- responsible for firing the constructor of the class it just recursed into.
	-- For the outermost call that caller is robustclass.Create, which fires the
	-- derived class's constructor explicitly after construct() returns.

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

	FIX (Bug 1 — same pattern): Identical ignite-flag bug as in construct().
	Applies the same caller-fires design: destruct() fires all ancestor
	destructors in base-first order; robustclass.Delete fires the derived
	class's own destructor last, mirroring construction order in reverse is
	conventional but here we preserve the original base-first intent.
–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––]]
local function destruct( pObj, class_t, classname )

	local baseclass_t = class_t.BaseClass

	if ( baseclass_t ) then

		local baseclassname = baseclass_t.ClassName

		destruct( pObj, baseclass_t, baseclassname )

		-- Fire the base-class destructor on the way back up.
		local Destructor = baseclass_t[ '_' .. baseclassname ]

		if ( Destructor ) then
			Destructor( pObj )
		end

	end

	-- No call to class_t['_'..classname] here; Delete() handles that.

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