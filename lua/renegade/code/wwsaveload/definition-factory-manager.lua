-- Based on DefinitionFactoryMgrClass within Code/wwsafeload/definitionfactorymgr.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class DefinitionFactoryManagerClass
local STATIC = CNC.CreateExport()
STATIC.Class = "DefinitionFactoryManagerClass"
local isHotload = not table.IsEmpty( STATIC )


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--- @class DefinitionFactoryManagerClass

--- @type DefinitionFactoryInstance[]
STATIC.RegisteredFactories = {}

--- @overload fun( classId: integer ): DefinitionFactoryInstance
--- @overload fun( name: string ): DefinitionFactoryInstance
function STATIC.FindFactory( arg )
    typecheck.NotImplementedError()
end

--- @param factory DefinitionFactoryInstance
function STATIC.RegisterFactory( factory )
    STATIC.LinkFactory( factory )
end

--- @param factory DefinitionFactoryInstance
function STATIC.UnregisterFactory( factory )
    STATIC.UnlinkFactory( factory )
end

--- @param factory DefinitionFactoryInstance
function STATIC.LinkFactory( factory )
    -- "Adding this factory in front of the current head of the list"
    STATIC.RegisteredFactories[#STATIC.RegisteredFactories + 1] = factory
end

--- @param factory DefinitionFactoryInstance
function STATIC.UnlinkFactory( factory )
    table.RemoveByValue( STATIC.RegisteredFactories, factory )
end