-- Based on WW3D within Code/ww3d2/ww3d.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class WW3dClass
local STATIC = CNC.CreateExport()
STATIC.Class = "WW3dClass"
local isHotload = not table.IsEmpty( STATIC )

--- @type WW3dClass

STATIC.DefaultNativeScreenSize = 1.0
STATIC._IsScreenUvBiased = true

--- @param isBiased boolean `true` if 2D rendering should be biased, `false` otherwise
function STATIC.SetScreenUvBias( isBiased )
    STATIC._IsScreenUvBiased = isBiased
end

--- @return boolean `true` if 2D rendering should be biased, `false` otherwise
function STATIC.IsScreenUvBiased()
    return STATIC._IsScreenUvBiased and true or false
end

--[[ Texture Reduction ]] do

    function STATIC.GetDefaultNativeScreenSize()
        return STATIC.DefaultNativeScreenSize
    end
end

--[[ Rendering Functions ]] do

    --- "  
    --- Each frame should be bracketed by a Begin_Render and End_Render call.  Between these two calls you will
    --- normally render scenes.  The render function which accepts a single render object is implemented for
    --- special cases like generating a shadow texture for an object.  Basically this function will have the
    --- entire scene rendering overhead.  
    --- "  

    --- @param
    --- @return 
    function STATIC.BeginRender()
        typecheck.NotImplementedError()
    end

    --- @param
    --- @return 
    function STATIC.Render()
        typecheck.NotImplementedError()
    end

    --- @param
    --- @return 
    function STATIC.Flush()
        typecheck.NotImplementedError()
    end

    --- @param
    --- @return 
    function STATIC.EndRender()
        typecheck.NotImplementedError()
    end

    --- @param
    --- @return 
    function STATIC.FlipToPrimary()
        typecheck.NotImplementedError()
    end


end