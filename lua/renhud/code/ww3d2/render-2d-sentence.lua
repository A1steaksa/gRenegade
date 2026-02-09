-- Based on Render2DSentenceClass within Code/ww3d2/render2dsentence.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type Render2dTextClass
local PARENT = CNC.Import( "code/ww3d2/render-2d-text.lua" )

--- @class Render2dSentenceClass : Render2dTextClass
--- @field Instance Render2dSentenceInstance The metatable used by Render2dSentenceInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "Render2dSentenceClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class Render2dSentenceInstance : Render2dTextInstance
--- @field Static Render2dSentenceClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Render2dSentence : Renegade_Render2dText" )
INSTANCE.Class = "Render2dSentenceInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsRender2dSentence = true


--#region Exported Enums
--#endregion


--#region Imports
--#endregion


--#region Imported Enums
--#endregion

--[[
    Note to maintainers:
    In an effort to improve text readability while maintaining the intended look of the game's text,
    the Render2DSentenceClass has been changed significantly to use font atlases from FontsLib.
    
    The idea being that the atlases are generated to appear as they would at the approximately
    800x600 resolution the original developers were using when laying out the interface.
    Those low resolution atlas characters are then drawn at the resolution-dependant size that the
    original game's Render2DSentenceClass would normally draw text at.
--]]

--[[ Static Functions and Variables ]] do

    --- @class Render2dSentenceClass

    --- Creates a new Render2dSentenceInstance
    --- @vararg any
    --- @return Render2dSentenceInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Render2dSentence" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) Render2dSentenceInstance, `false` otherwise
    function STATIC.IsRender2dSentence( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsRender2dSentence and true or false
    end

    typecheck.RegisterType( "Render2dSentenceInstance", STATIC.IsRender2dSentence )
end


--- @class Render2dSentenceInstance
--- @field SentenceData SentenceDataInstance[]
--- @field PendingSurfaces PendingSurfaceInstance[]
--- @field Renderers RendererDataInstance[]
--- @field PreAllocatedRenderers RendererDataInstance[] "Use this with Renderers at first"
--- @field Font FontCharsInstance
--- @field BaseLocation Vector
--- @field TextureOffset Vector
--- @field TextureStartX integer
--- @field CurrTextureSize integer
--- @field TextureSizeHint integer
--- @field CurSurface SurfaceInstance
--- @field Monospaced boolean
--- @field Tabstop number
--- @field ClipRect RectInstance
--- @field CurTexture ITexture
--- @field Shader ShaderInstance

--- Constructs a new Render2dSentenceInstance
--- @vararg any
function INSTANCE:Renegade_Render2dSentence()
    
end

function INSTANCE:Render()
    typecheck.NotImplementedError()
end

function INSTANCE:Reset()
    typecheck.NotImplementedError()
end

function INSTANCE:ResetPolys()
    typecheck.NotImplementedError()
end

--- @return FontCharsInstance
function INSTANCE:PeekFont()
    return self.Font
end

--- @param font FontCharsInstance
function INSTANCE:SetFont( font )
    typecheck.NotImplementedError()
end

--- @param location Vector
function INSTANCE:SetBaseLocation( location )
    typecheck.NotImplementedError()
end

--- @param stop number
function INSTANCE:SetTabStop( stop )
    typecheck.NotImplementedError()
end


--[[ Shader Modification Support ]] do

    function INSTANCE:MakeAdditive()
        typecheck.NotImplementedError()
    end

    --- @return ShaderInstance
    function INSTANCE:GetShader()
        return self.Shader
    end

    --- @param shader ShaderInstance
    function INSTANCE:SetShader( shader )
        typecheck.NotImplementedError()
    end
end

--- @param text string
--- @param rowCount integer
--- @return Vector
function INSTANCE:GetFormattedTextExtents( text, rowCount )
    typecheck.NotImplementedError()
end

--- @param text string
--- @param rowIndex integer?
--- @return Vector
function INSTANCE:FindRowStart( text, rowIndex )
    typecheck.NotImplementedError()
end


--[[ Sentence Control ]] do

    --- @param text string
    function INSTANCE:BuildSentence( text )
        typecheck.NotImplementedError()
    end

    --- @param color Color? [Default: White]
    function INSTANCE:DrawSentence( color )
        if not color then color = Color( 255, 255, 255, 255 ) end

        typecheck.NotImplementedError()
    end
end

--[[ Texture Hint ]] do

    --- @param hint integer
    function INSTANCE:SetTextureSizeHint( hint )
        self.TextureSizeHint = hint
    end

    --- @return integer
    function INSTANCE:GetTextureSizeHint()
        return self.TextureSizeHint
    end

    --- @param shouldBeMonospaced boolean
    function INSTANCE:SetMonoSpaced( shouldBeMonospaced )
        self.Monospaced = shouldBeMonospaced
    end

    --- @param alpha number
    function INSTANCE:ForceAlpha( alpha )
        typecheck.NotImplementedError()
    end
end

--- @private
function INSTANCE:ResetSentenceData()
    typecheck.NotImplementedError()
end

--- @private
function INSTANCE:BuildTextures()
    typecheck.NotImplementedError()
end

--- @private
function INSTANCE:RecordSentenceChunk()
    typecheck.NotImplementedError()
end

--- @private
--- @param text string
function INSTANCE:AllocateNewSurface( text )
    typecheck.NotImplementedError()
end

--- @private
function INSTANCE:ReleasePendingSurfaces()
    typecheck.NotImplementedError()
end

