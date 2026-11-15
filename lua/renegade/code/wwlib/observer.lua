-- Based on Observer within Code/wwlib/Notify.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class ObserverClass
--- @field Instance ObserverInstance The metatable used by ObserverInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "ObserverClass"

--- @class ObserverInstance
--- @field Static ObserverClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Observer" )
INSTANCE.Class = "ObserverInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsObserver = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ClassUtils
	local classUtils = CNC.Import( "sh_class-utils.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class ObserverClass

    --- Creates a new ObserverInstance
    --- @return ObserverInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Observer" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ObserverInstance, `false` otherwise
    function STATIC.IsObserver( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsObserver and true or false
    end

    typecheck.RegisterType( "ObserverInstance", STATIC.IsObserver )
end


--- @class ObserverInstance
--- @field Notifiers NotifierInstance[]

function INSTANCE:Renegade_Observer()
    self.Notifiers = {}
end

function INSTANCE:_Renegade_Observer()
    self:StopObserving()
end

--- "! Handle event notification"
--- @param event any
function INSTANCE:HandleNotification( event )
    classUtils.VirtualFunction()
end

--- "! Notifier has ended notification of this event"
--- @param notifier NotifierInstance
function INSTANCE:NotificationEnded( notifier )
    table.RemoveByValue( self.Notifiers, notifier )
end

--- "! Request notification of this event"
--- @param notifier NotifierInstance
function INSTANCE:NotifyMe( notifier )
    notifier:AddObserver( self )
end

--- "! Stop observing event"
function INSTANCE:StopObserving()
    while #self.Notifiers > 0 do
        local notifier = self.Notifiers[#self.Notifiers]
        assert( notifier ~= nil, "ERROR: NULL pointer in collection." )
        notifier:RemoveObserver()
        self.Notifiers[#self.Notifiers] = nil
    end
end
