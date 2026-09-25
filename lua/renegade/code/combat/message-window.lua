-- Based on MessageWindowClass within Code/Combat/messagewindow.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class MessageWindowClass
--- @field instance MessageWindowInstance The metatable used by MessageWindowInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "MessageWindowClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class MessageWindowInstance
--- @field Static MessageWindowClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MessageWindow" )
INSTANCE.Class = "MessageWindowInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMessageWindow = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class MessageWindowClass

    --- Creates a new MessageWindowInstance
    --- @return MessageWindowInstance
    function STATIC.New()
        return robustclass.New( "Renegade_MessageWindow" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MessageWindowInstance, `false` otherwise
    function STATIC.IsMessageWindow( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMessageWindow and true or false
    end

    typecheck.RegisterType( "MessageWindowInstance", STATIC.IsMessageWindow )
end


--- @class MessageWindowInstance
--- @field private DecayTime integer
--- @field private TextWindow TextWindowInstance
--- @field private IconRenderer Render2dInstance
--- @field private CurrentRect RectInstance
--- @field private HeadModel RenderObjectInstance
--- @field private Scene SimpleSceneInstance
--- @field private Camera CameraInstance
--- @field private IsRectangleDirty boolean
--- @field private MessageLog string[]
--- @field private MessageLogColor Color[]

--- Constructs a new MessageWindowInstance
function INSTANCE:Renegade_MessageWindow()
end

--[[ Initialization ]] do

    function INSTANCE:Initialize()
        typecheck.NotImplementedError()
    end

    function INSTANCE:Shutdown()
        typecheck.NotImplementedError()
    end
end

--[[ Content Control ]] do

    --- @param message string
    --- @param color Color? [Default: Color( 0, 230, 51 )]
    --- @param ent SmartGameObjectInstance? [Default: NULL]
    --- @param decayTime number? [Default: 0]
    function INSTANCE:AddMessage( message, color, ent, decayTime )
        if not color then color = Color( 0, 0.9 * 255, 0.2 * 255 ) end
        if not ent then ent = NULL end
        if not decayTime then decayTime = 0 end

        typecheck.NotImplementedError()
    end

    function INSTANCE:Clear()
        typecheck.NotImplementedError()
    end
end

--[[ Render Methods ]] do

    function INSTANCE:OnFrameUpdate()
        typecheck.NotImplementedError()
    end

    function INSTANCE:Render()
        typecheck.NotImplementedError()
    end
end

--[[ Visibility Control ]] do

    --- @return boolean
    function INSTANCE:HasData()
        typecheck.NotImplementedError()
    end

    --- @param shouldDisplay boolean
    function INSTANCE:ForceDisplay( shouldDisplay )
        typecheck.NotImplementedError()
    end
end

--[[ Display Rectangle Control ]] do

    function INSTANCE:UpdateWindowRectangle()
        typecheck.NotImplementedError()
    end

    function INSTANCE:ResetCurrentRect()
        typecheck.NotImplementedError()
    end

    --- @param isDirty boolean
    function INSTANCE:SetWindowDirty( isDirty )
        self.IsRectangleDirty = isDirty
    end
end

--[[ Decay Control ]] do

    --- @return integer
    function INSTANCE:GetDecayTime()
        return self.DecayTime
    end

    --- @param time integer
    function INSTANCE:SetDecayTime( time )
        self.DecayTime = time
    end
end

--[[ Message Log Support ]] do

    function INSTANCE:ClearLog()
        self.MessageLog = {}
        self.MessageLogColor = {}
    end

    --- @return integer
    function INSTANCE:GetLogCount()
        return #self.MessageLog
    end

    --- @param index integer
    --- @return string
    function INSTANCE:GetLogEntry( index )
        return self.MessageLog[index]
    end

    --- @param index integer
    --- @return Color
    function INSTANCE:GetLogColor( index )
        return self.MessageLogColor[index]
    end
end
