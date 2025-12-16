-- Based on PostLoadableClass within Code/wwsaveload/postloadable.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class PostLoadableClass
--- @field instance PostLoadableInstance The metatable used by PostLoadableInstance
local STATIC = CNC.CreateExport()
local CLASS = "PostLoadableInstance"
local isHotload = not table.IsEmpty( STATIC )

--- @class PostLoadableInstance
--- @field Static PostLoadableClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_PostLoadable" )
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsPostLoadable = true


--[[ Static Functions and Variables ]] do

    --- "  
    --- PostLoadableClass allows a lower level for non-Persist objects to [OnPostLoad]
    --- without requiring [GetFactory] or other requirements of PersistClass.  Objects
    --- derived from this class can be added to the post-load list in the SaveLoadSystem  
    --- "  
    --- @class PostLoadableClass

    --- Creates a new PostLoadableInstance
    --- @vararg any
    --- @return PostLoadableInstance
    function STATIC.New()
        return robustclass.New( "Renegade_PostLoadable" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) PostLoadableInstance, `false` otherwise
    function STATIC.IsPostLoadable( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsPostLoadable and true or false
    end

    typecheck.RegisterType( "PostLoadableInstance", STATIC.IsPostLoadable )
end


--- @class PostLoadableInstance
--- @field private _IsPostLoadRegistered boolean

--- Constructs a new PostLoadableInstance
function INSTANCE:Renegade_PostLoadable()
    self._IsPostLoadRegistered = false
end

function INSTANCE:OnPostLoad()
end

--- @return boolean
function INSTANCE:IsPostLoadRegistered()
    return self._IsPostLoadRegistered
end

--- @param isRegistered boolean
function INSTANCE:SetPostLoadRegistered( isRegistered )
    self._IsPostLoadRegistered = isRegistered
end
