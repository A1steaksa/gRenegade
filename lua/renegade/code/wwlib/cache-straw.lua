-- Based on CacheStraw within Code/wwlib/cstraw.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type StrawClass
local strawClass = CNC.Import( "code/wwlib/straw.lua" )

--- @class CacheStrawClass : StrawClass
--- @field Instance CacheStrawInstance The metatable used by CacheStrawInstance
local STATIC = CNC.CreateExport( strawClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "CacheStrawClass"

--- @class CacheStrawInstance : StrawInstance
--- @field Static CacheStrawClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_CacheStraw : Renegade_Straw" )
INSTANCE.Class = "CacheStrawInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsCacheStraw = true

--#region Exported Enums
--#endregion

--#region Imports
--#endregion

--#region Imported Enums
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class CacheStrawClass

    --- Creates a new CacheStrawInstance
    --- @overload fun( buffer: string ): CacheStrawInstance 
    --- @overload fun( length: integer ): CacheStrawInstance
    --- @overload fun(): CacheStrawInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_CacheStraw", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) CacheStrawInstance, `false` otherwise
    function STATIC.IsCacheStraw( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsCacheStraw and true or false
    end

    typecheck.RegisterType( "CacheStrawInstance", STATIC.IsCacheStraw )
end


--- @class CacheStrawInstance
--- @field Buffer string
--- @field Index integer
--- @field Length integer

--- @param arg1 string | integer | nil
function INSTANCE:Renegade_CacheStraw( arg1 )
    if arg1 == nil then arg1 = 4096 end
    typecheck.AssertArgType( STATIC.Class, 1, arg1, { "string", "number" }  )

    if typecheck.IsOfType( arg1, "string" ) then
        self.Buffer = arg1 --[[@as string]]
        self.Index = 1
        self.Length = 0
    elseif typecheck.IsOfType( arg1, "number" ) then
        self.Buffer = ""
        self.Index = 1
        self.Length = 0
    end
end

--- @param slen integer "The number of data bytes requested"
--- @return integer readByteCount, string buffer
function INSTANCE:Get( slen )
    local total = 0
    local source = ""

    if self:IsValid() and slen > 0 then
        --- "Keep processing the data request until there is no more data to supply or the request has been fulfilled."
        while slen > 0 do
            -- "First try to fetch the data from data previously loaded into the buffer."
            if self.Length > 0 then
                local toCopy = ( self.Length < slen ) and self.Length or slen
                source = source .. self.Buffer:sub( self.Index, self.Index + toCopy - 1 )
                slen = slen - toCopy
                self.Index = self.Index + toCopy
                total = total + toCopy
                self.Length = self.Length - toCopy
                source = source:sub( toCopy )
            end

            if slen == 0 then
                break
            end

            --- "
            --- Since there is more to be fulfilled yet the holding buffer is empty,
            --- refill the buffer with a fresh block of data from the source.
            --- "
            local readByteCount, buffer = strawClass.Instance.Get( self, 4096 )
            self.Length = readByteCount
            self.Index = 1
            self.Buffer = buffer
            if self.Length == 0 then
                break
            end
        end
    end

    return total, source
end

--- @return boolean
function INSTANCE:IsValid()
    return ( self.Buffer ~= nil )
end
