-- Based on Notifier within Code/wwlib/Notify.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class NotifierClass
--- @field Instance NotifierInstance The metatable used by NotifierInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "NotifierClass"

--- @class NotifierInstance
--- @field Static NotifierClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Notifier" )
INSTANCE.Class = "NotifierInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsNotifier = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class NotifierClass

    --- Creates a new NotifierInstance
    --- @return NotifierInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Notifier" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) NotifierInstance, `false` otherwise
    function STATIC.IsNotifier( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsNotifier and true or false
    end

    typecheck.RegisterType( "NotifierInstance", STATIC.IsNotifier )
end


--- @class NotifierInstance
--- @field Observers ObserverInstance[] "! Observer collection"

function INSTANCE:Renegade_Notifier()
    self.Observers = {}
end

function INSTANCE:_Renegade_Notifier()
    for index = #self.Observers, 1, -1 do
        self.Observers[index]:NotificationEnded( self )
    end
end

--- "! Send notification to all observers of this event."
--- @param event any
function INSTANCE:NotifyObservers( event )
    for index = 1, #self.Observers do
        self.Observers[index]:HandleNotification( event )
    end
end

--- "! Add an observer of this event"
--- @param observer ObserverInstance
function INSTANCE:AddObserver( observer )
	observer.Notifiers[#observer.Notifiers+1] = self
    self.Observers[#self.Observers+1] = observer
end

--- "! Remove an observer of this event"
--- @param observer ObserverInstance
function INSTANCE:RemoveObserver( observer )
    if table.HasValue( self.Observers, observer ) then
        observer:NotificationEnded( self )
        table.RemoveByValue( self.Observers, observer )
    end
end

--- @return boolean
function INSTANCE:HasObservers()
	return #self.Observers ~= 0
end
