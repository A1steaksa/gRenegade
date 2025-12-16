-- Based on SaveLoadSubSystemClass within Code/wwsaveload/saveloadsubsystem.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class SaveLoadSubSystemClass
--- @field instance SaveLoadSubSystemInstance The metatable used by SaveLoadSubSystemInstance
local STATIC = CNC.CreateExport()
local CLASS = "SaveLoadSubSystemInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class SaveLoadSubSystemInstance
--- @field Static SaveLoadSubSystemClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_SaveLoadSubSystem" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsSaveLoadSubSystem = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums

    --- @type SaveLoadSystemClass
    local saveLoadSystemClass = CNC.Import( "renhud/code/wwsaveload/save-load.lua" )
--#endregion


--[[ Static Functions and Variables ]] do

    --- "  
    --- Each `SaveLoadSubSystem` will automatically be registered with the `SaveLoadSystem` at construction time.
    --- The plan is to have a single static instance of each sub-system so that it automatically registers when
    --- the global constructors are executed.  
    --- "
    --- 
    --- "  
    --- When an application wants to create a file it does so by asking the SaveLoadSystem to save the particular
    --- set of SaveLoadSubSystems that contain that data.  
    --- "  
    --- @class SaveLoadSubSystemClass

    --- Creates a new SaveLoadSubSystemInstance
    --- @return SaveLoadSubSystemInstance
    function STATIC.New()
        return robustclass.New( "Renegade_SaveLoadSubSystem" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) SaveLoadSubSystemInstance, `false` otherwise
    function STATIC.IsSaveLoadSubSystem( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsSaveLoadSubSystem and true or false
    end

    typecheck.RegisterType( "SaveLoadSubSystemInstance", STATIC.IsSaveLoadSubSystem )
end


--- @class SaveLoadSubSystemInstance
--- @field NextSubSystem SaveLoadSubSystemInstance "Managed by SaveLoadSystem"

--- Constructs a new SaveLoadSubSystemInstance
--- @vararg any
function INSTANCE:Renegade_SaveLoadSubSystem()
    self.NextSubSystem = nil

    -- "All Sub-Systems are automatically registered with the SaveLoadSystem"
    saveLoadSystemClass.RegisterSubSystem( self )
end

--- @return integer
function INSTANCE:ChunkId()
    return 0
end

--- @return boolean
function INSTANCE:ContainsData()
    return true
end

--- @param csave ChunkSaveInstance
--- @return boolean
function INSTANCE:Save( csave )
    return false
end

--- @param cload ChunkLoadInstance
--- @return boolean
function INSTANCE:Load( cload )
    return false
end

--- @return string
function INSTANCE:Name()
    return ""
end
