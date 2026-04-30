--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ClassUtils
local LIB = {}
LIB.Class = "ClassUtils"

--- A placeholder function to be used in place of a function body when declaring a virtual function that
--- should never be called directly and should instead always be overridden by child classes. 
function LIB.VirtualFunction()
    section.Error( "This function is virtual and should always be replaced" )
end

CNC.VirtualFunction = LIB.VirtualFunction