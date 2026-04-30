-- Based on Straw within Code/wwlib/straw.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class StrawClass
--- @field Instance StrawInstance The metatable used by StrawInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "StrawClass"

--- @class StrawInstance
--- @field Static StrawClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Straw" )
INSTANCE.Class = "StrawInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsStraw = true

--#region Exported Enums
--#endregion

--#region Imports

    --- @type StrawClass
    local strawClass = CNC.Import( "code/wwlib/straw.lua" )
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class StrawClass

    --- Creates a new StrawInstance
    --- @return StrawInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Straw" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) StrawInstance, `false` otherwise
    function STATIC.IsStraw( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsStraw and true or false
    end

    typecheck.RegisterType( "StrawInstance", STATIC.IsStraw )
end


--- "  
--- This is a demand driven data carrier. It will retrieve the byte request by passing
--- the request down the chain (possibly processing on the way) in order to fulfill the
--- data request. Without being derived, this class merely passes the data through. Derived
--- versions are presumed to modify the data in some useful way or monitor the data
--- flow.  
--- "
--- @class StrawInstance
--- @field ChainTo StrawInstance?
--- @field ChainFrom StrawInstance?

function INSTANCE:Renegade_Straw()
    self.ChainTo = nil
    self.ChainFrom = nil
end

--- "Destructor for a straw segment."
function INSTANCE:_Renegade_Straw()
    if self.ChainTo ~= nil then
        self.ChainTo.ChainFrom = self.ChainFrom
    end
    if self.ChainFrom ~= nil then
        self.ChainFrom:GetFrom( self.ChainTo )
    end

    self.ChainFrom = nil
    self.ChainTo = nil
end

--- "Connect one straw segment to another"
--- @param straw StrawInstance? "...the straw segment that data will be fetched from"
function INSTANCE:GetFrom( straw )
    if self.ChainTo ~= straw then
        if straw ~= nil and straw.ChainFrom ~= nil then
            straw.ChainFrom:GetFrom( nil )
            straw.ChainFrom = nil
        end

        if self.ChainTo ~= nil then
            self.ChainTo.ChainFrom = nil
        end

        self.ChainTo = straw
        if self.ChainTo ~= nil then
            self.ChainTo.ChainFrom = self
        end
    end
end

--- @param slen integer
--- @return integer readByteCount, string buffer
function INSTANCE:Get( slen )
    if self.ChainTo ~= nil then
        local readByteCount, buffer = self.ChainTo:Get( slen )
        return readByteCount, buffer
    end

    return 0, ""
end
