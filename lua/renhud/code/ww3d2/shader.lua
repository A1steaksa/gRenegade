-- Based on ShaderClass within Code/ww3d2/shader.cpp/h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ShaderClass
--- @field instance ShaderInstance The metatable used by ShaderInstance
local STATIC = CNC.CreateExport()
STATIC.Class = "ShaderClass"
local isHotload = not table.IsEmpty( STATIC )

--- @class ShaderInstance
--- @field Static ShaderClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Shader" )
INSTANCE.Class = "ShaderInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsShader = true


--#region Exported Enums

    --- @enum ShaderShiftConstants
    STATIC.SHADER_SHIFT_CONSTANTS = {
        DepthCompare        = 0,  -- Bit shift for depth comparison setting
        DepthMask           = 3,  -- Bit shift for depth mask setting
        ColorMask           = 4,  -- Bit shift for color mask setting
        DstBlend            = 5,  -- Bit shift for destination blend setting
        Fog                 = 8,  -- Bit shift for fog setting
        PrimaryGradient     = 10, -- Bit shift for primary gradient setting
        SecondaryGradient   = 13, -- Bit shift for secondary gradient setting
        SrcBlend            = 14, -- Bit shift for source blend setting
        Materialing         = 16, -- Bit shift for materialing setting (1 bit)
        NPatchEnable        = 17, -- Bit shift for npatch enabling
        AlphaTest           = 18, -- Bit shift for alpha test setting
        CullMode            = 19, -- Bit shift for cullmode setting
        PostDetailColorFunc = 20, -- Bit shift for post-detail color function setting
        PostDetailAlphaFunc = 24, -- Bit shift for post-detail alpha function setting
    }
    local shaderShiftConstantsEnum = STATIC.SHADER_SHIFT_CONSTANTS

    --- @enum AlphaTest
    STATIC.ALPHA_TEST = {
        Disable = 0, -- Disable alpha testing (default)
        Enable  = 1, -- Enable alpha testing
    }
    local alphaTestEnum = STATIC.ALPHA_TEST

    --- @enum DepthCompare
    STATIC.DEPTH_COMPARE = {
        PassNever    = 0, -- Pass never
        PassLess     = 1, -- Pass if incoming less than stored
        PassEqual    = 2, -- Pass if incoming equal to stored
        PassLEqual   = 3, -- Pass if incoming less than or equal to stored (default)
        PassGreater  = 4, -- Pass if incoming greater than stored
        PassNotEqual = 5, -- Pass if incoming not equal to stored
        PassGEqual   = 6, -- Pass if incoming greater than or equal to stored
        PassAlways   = 7, -- Pass always
    }
    local depthCompareEnum = STATIC.DEPTH_COMPARE

    --- @enum DepthMask
    STATIC.DEPTH_MASK = {
        Disable = 0, -- Disable depth buffer writes
        Enable  = 1, -- Enable depth buffer writes (default)
    }
    local depthMaskEnum = STATIC.DEPTH_MASK

    --- @enum ColorMask
    STATIC.COLOR_MASK = {
        Disable = 0, -- Disable color buffer writes
        Enable  = 1, -- Enable color buffer writes (default)
    }
    local colorMaskEnum = STATIC.COLOR_MASK

    --- @enum DetailAlphaFunc
    STATIC.DETAIL_ALPHA_FUNC = {
        Disable  = 0, -- Local (default)
        Detail   = 1, -- Other
        Scale    = 2, -- Local * other
        InvScale = 3, -- ~(~local * ~other) = local + (1-local)*other
    }
    local detailAlphaFuncEnum = STATIC.DETAIL_ALPHA_FUNC

    --- @enum DetailColorFunc
    STATIC.DETAIL_COLOR_FUNC = {
        Disable     = 0, -- 0000 local (default)
        Detail      = 1, -- 0001 other
        Scale       = 2, -- 0010 local * other
        InvScale    = 3, -- 0011 ~(~local * ~other) = local + (1-local)*other
        Add         = 4, -- 0100 local + other
        Sub         = 5, -- 0101 local - other
        SubR        = 6, -- 0110 other - local
        Blend       = 7, -- 0111 (localAlpha)*local + (~localAlpha)*other
        DetailBlend = 8, -- 1000 (otherAlpha)*local + (~otherAlpha)*other
    }
    local detailColorFuncEnum = STATIC.DETAIL_COLOR_FUNC

    --- @enum CullMode
    STATIC.CULL_MODE = {
        Disable = 0,
        Enable  = 1,
    }
    local cullModeEnum = STATIC.CULL_MODE

    --- @enum NPatch
    STATIC.N_PATCH = {
        Disable  = 0,
        Enable   = 1,
    }
    local nPatchEnum = STATIC.N_PATCH

    --- @enum DstBlendFunc
    STATIC.DST_BLEND_FUNC = {
        Zero             = 0, -- Destination pixel doesn't affect blending (default)
        One              = 1, -- Destination pixel added unmodified
        SrcColor         = 2, -- Destination pixel multiplied by fragment RGB components
        OneMinusSrcColor = 3, -- Destination pixel multiplied by one minus (i.e. inverse) fragment RGB components
        SrcAlpha         = 4, -- Destination pixel multiplied by fragment alpha component
        OneMinusSrcAlpha = 5, -- Destination pixel multiplied by fragment inverse alpha
    }
    local dstBlendFuncEnum = STATIC.DST_BLEND_FUNC

    --- @enum FogFunc
    STATIC.FOG_FUNC = {
        Disable        = 0, -- Don't perform fogging (default)
        Enable         = 1, -- Apply fog, f*fogColor + (1-f)*fragment
        ScaleFragment  = 2, -- Fog scalar value multiplies fragment, (1-f)*fragment
        White          = 3, -- Fog scalar value replaces fragment, f*fogColor
    }
    local fogFuncEnum = STATIC.FOG_FUNC

    --- @enum PrimaryGradient
    STATIC.PRIMARY_GRADIENT = {
        Disable             = 0, -- 000 disable primary gradient (same as OpenGL 'decal' texture blend)
        Modulate            = 1, -- 001 modulate fragment ARGB by gradient ARGB (default)
        Add                 = 2, -- 010 add gradient RGB to fragment RGB, copy gradient A to fragment A
        BumpEnvMap          = 3, -- 011
        BumpEnvMapLuminance = 4, -- 100
        DotPoduct3          = 5, -- 101
    }
    local primaryGradientEnum = STATIC.PRIMARY_GRADIENT

    --- @enum SecondaryGradient
    STATIC.SECONDARY_GRADIENT = {
        Disable = 0, -- Don't draw secondary gradient (default)
        Enable  = 1, -- Add secondary gradient RGB to fragment RGB
    }
    local secondaryGradientEnum = STATIC.SECONDARY_GRADIENT

    --- @enum SrcBlendFunc
    STATIC.SRC_BLEND_FUNC = {
        Zero                = 0, -- Fragment not added to color buffer
        One                 = 1, -- Fragment added unmodified to color buffer (default)
        SrcAlpha            = 2, -- Fragment RGB components multiplied by fragment A
        OneMinusSrcAlpha    = 3, -- Fragment RGB components multiplied by fragment inverse (one minus) A
    }
    local srcBlendFuncEnum = STATIC.SRC_BLEND_FUNC

    --- @enum Materialing
    STATIC.MATERIALING = {
        Disable = 0, -- No materialing (treat fragment initial color as 1,1,1,1)
        Enable  = 1, -- Enable materialing
    }
    local materialingEnum = STATIC.MATERIALING

    --- @enum StaticSortCategory
    STATIC.STATIC_SORT_CATEGORY = {
        Opaque     = 0,
        AlphaTest  = 1,
        Additive   = 2,
        Other      = 3,
    }
    local staticSortCategoryEnum = STATIC.STATIC_SORT_CATEGORY

    --- @enum Mask
    STATIC.MASK = {
        DepthCompare        = bit.lshift( 7,  0  ),  -- Mask for depth comparison setting
        DepthMask           = bit.lshift( 1,  3  ),  -- Mask for depth mask setting
        ColorMask           = bit.lshift( 1,  4  ),  -- Mask for color mask setting
        DstBlend            = bit.lshift( 7,  5  ),  -- Mask for destination blend setting
        Fog                 = bit.lshift( 3,  8  ),  -- Mask for fog setting
        PrimaryGradient     = bit.lshift( 7,  10 ),  -- Mask for primary gradient setting
        SecondaryGradient   = bit.lshift( 1,  13 ),  -- Mask for secondary gradient setting
        SrcBlend            = bit.lshift( 3,  14 ),  -- Mask for source blend setting
        Materialing         = bit.lshift( 1,  16 ),  -- Mask for materialing setting
        NPatchEnable        = bit.lshift( 1,  17 ),  -- Mask for npatch enable
        AlphaTest           = bit.lshift( 1,  18 ),  -- Mask for alpha test enable
        CullMode            = bit.lshift( 1,  19 ),  -- Mask for cullmode setting
        PostDetailColorFunc = bit.lshift( 15, 20 ),  -- Mask for post detail color function setting
        PostDetailAlphaFunc = bit.lshift( 7,  24 ),  -- Mask for post detail alpha function setting
    }
    local maskEnum = STATIC.MASK
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class ShaderClass
    --- @field PolygonCullMode MATERIAL_CULLMODE

    --- Creates a new ShaderInstance
    --- @vararg any
    --- @return ShaderInstance
    function STATIC.New( ... )
        return robustclass.New( "Renegade_Shader", ... )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) ShaderInstance, `false` otherwise
    function STATIC.IsShader( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsShader and true or false
    end

    typecheck.RegisterType( "ShaderInstance", STATIC.IsShader )

    --- @param isBackfaceCullingInverted boolean Enables **C**ounter-**C**lock**W**ise (CCW) culling when inverted or **C**lock**W**ise (CW) culling otherwise
    function STATIC.InvertBackfaceCulling( isBackfaceCullingInverted )
        if isBackfaceCullingInverted then
            STATIC.PolygonCullMode = MATERIAL_CULLMODE_CCW
        else
            STATIC.PolygonCullMode = MATERIAL_CULLMODE_CW
        end
    end

    --- "Is backface culling inverted?"
    --- @return boolean `true` when using **C**ounter-**C**lock**W**ise (CCW) culling, `false` otherwise
    function STATIC.IsBackfaceCullingInverted()
        return STATIC.PolygonCullMode == MATERIAL_CULLMODE_CCW
    end
end


--- @class ShaderInstance
--- @field ShaderBits integer
--- @field DepthCompare DepthCompare
--- @field DepthMask DepthMask
--- @field ColorMask ColorMask
--- @field DstBlendFunc DstBlendFunc
--- @field FogFunc FogFunc
--- @field PrimaryGradient PrimaryGradient
--- @field SecondaryGradient SecondaryGradient
--- @field SrcBlendFunc SrcBlendFunc
--- @field Materialing Materialing
--- @field AlphaTest AlphaTest
--- @field CullMode CullMode
--- @field PostDetailColorFunc DetailAlphaFunc
--- @field PostDetailAlphaFunc DetailColorFunc
--- @field NPatchEnable NPatch

--- Converts Renegade destination blend function enums to their Garry's Mod equivalents
local dstBlendFuncConverter = {
    [dstBlendFuncEnum.Zero            ] = BLEND_ZERO,
    [dstBlendFuncEnum.One             ] = BLEND_ONE,
    [dstBlendFuncEnum.SrcAlpha        ] = BLEND_SRC_ALPHA,
    [dstBlendFuncEnum.SrcColor        ] = BLEND_SRC_COLOR,
    [dstBlendFuncEnum.OneMinusSrcAlpha] = BLEND_ONE_MINUS_SRC_ALPHA,
    [dstBlendFuncEnum.OneMinusSrcColor] = BLEND_ONE_MINUS_SRC_COLOR,
}

--- Converts Renegade source blend function enums to their Garry's Mod equivalents
local srcBlendFuncConverter = {
    [srcBlendFuncEnum.Zero            ] = BLEND_ZERO,
    [srcBlendFuncEnum.One             ] = BLEND_ONE,
    [srcBlendFuncEnum.SrcAlpha        ] = BLEND_SRC_ALPHA,
    [srcBlendFuncEnum.OneMinusSrcAlpha] = BLEND_ONE_MINUS_SRC_ALPHA,
}

--- Constructs a new ShaderInstance
--- @vararg any
function INSTANCE:Renegade_Shader( ... )
    local args = { ... }
    local argCount = select( "#", ... )
    typecheck.AssertArgCount( INSTANCE.Class, argCount, { 0, 1 } )

    --- ()
    if argCount == 0 then
        self:Reset()
        return
    end

    if argCount == 1 then
        local firstArg = args[1]
        typecheck.AssertArgType( INSTANCE.Class, 1, arg, { "ShaderInstance", "number" } )

        --- ( shader: ShaderInstance )
        if typecheck.IsOfType( firstArg, "ShaderInstance" ) then
            self.ShaderBits = ( firstArg --[[@as ShaderInstance]] ).ShaderBits
            return
        --- ( shaderBits: integer )
        else
            self.ShaderBits = firstArg --[[@as number]]
            return
        end
    end
end

--- Applies rendering overrides and settings for this shader  
--- Always be sure to revert these changes after rendering  
--- @see ShaderInstance.Unapply
function INSTANCE:Apply()

    --[[ Blending ]] do

        local dstBlendFunc = dstBlendFuncConverter[ self.DstBlendFunc ]
        local srcBlendFunc = srcBlendFuncConverter[ self.SrcBlendFunc ]
        render.OverrideBlend( true, srcBlendFunc, dstBlendFunc, BLENDFUNC_ADD )
    end

    -- "CULLMODE"
    render.CullMode( self:GetCullMode() and STATIC.PolygonCullMode or MATERIAL_CULLMODE_NONE )
end

--- Removes overrides set by this shader  
--- Always apply shaders before unapplying them  
--- @see ShaderInstance.Apply
function INSTANCE:Unapply()

    -- Cullmode
    render.CullMode( MATERIAL_CULLMODE_CCW )

    --[[ Blending ]] do

        render.OverrideBlend( false )
    end
end

function INSTANCE:Reset()
    self.ShaderBits = 0

    self:SetDepthCompare( depthCompareEnum.PassLEqual )
    self:SetDepthMask( depthMaskEnum.Enable )
    self:SetColorMask( colorMaskEnum.Enable )
    self:SetDstBlendFunc( dstBlendFuncEnum.Zero )
    self:SetFogFunc( fogFuncEnum.Disable )
    self:SetPrimaryGradient( primaryGradientEnum.Modulate )
    self:SetSecondaryGradient( secondaryGradientEnum.Disable )
    self:SetSrcBlendFunc( srcBlendFuncEnum.One )
    self:SetMaterialing( materialingEnum.Disable )
    self:SetAlphaTest( alphaTestEnum.Disable )
    self:SetCullMode( cullModeEnum.Enable )
    self:SetPostDetailColorFunc( detailColorFuncEnum.Disable )
    self:SetPostDetailAlphaFunc( detailAlphaFuncEnum.Disable )
    self:SetNPatchEnable( nPatchEnum.Disable )
end

--[[ Bitflag Getters ]] do

    --- @return DepthCompare
    function INSTANCE:GetDepthCompare()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.DepthCompare ), shaderShiftConstantsEnum.DepthCompare ) --[[@as DepthCompare]]
    end

    --- @return DepthMask
    function INSTANCE:GetDepthMask()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.DepthMask ), shaderShiftConstantsEnum.DepthMask ) --[[@as DepthMask]]
    end

    --- @return ColorMask
    function INSTANCE:GetColorMask()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.ColorMask ), shaderShiftConstantsEnum.ColorMask ) --[[@as ColorMask]]
    end

    --- @return DetailAlphaFunc
    function INSTANCE:GetPostDetailAlphaFunc()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.PostDetailAlphaFunc ), shaderShiftConstantsEnum.PostDetailAlphaFunc ) --[[@as DetailAlphaFunc]]
    end

    --- @return DetailColorFunc
    function INSTANCE:GetPostDetailColorFunc()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.PostDetailColorFunc ), shaderShiftConstantsEnum.PostDetailColorFunc ) --[[@as DetailColorFunc]]
    end

    --- @return AlphaTest
    function INSTANCE:GetAlphaTest()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.AlphaTest ), shaderShiftConstantsEnum.AlphaTest ) --[[@as AlphaTest]]
    end

    --- @return CullMode
    function INSTANCE:GetCullMode()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.CullMode ), shaderShiftConstantsEnum.CullMode ) --[[@as CullMode]]
    end

    --- @return DstBlendFunc
    function INSTANCE:GetDstBlendFunc()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.DstBlend ), shaderShiftConstantsEnum.DstBlend ) --[[@as DstBlendFunc]]
    end

    --- @return FogFunc
    function INSTANCE:GetFogFunc()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.Fog ), shaderShiftConstantsEnum.Fog ) --[[@as FogFunc]]
    end

    --- @return PrimaryGradient
    function INSTANCE:GetPrimaryGradient()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.PrimaryGradient ), shaderShiftConstantsEnum.PrimaryGradient ) --[[@as PrimaryGradient]]
    end

    --- @return SecondaryGradient
    function INSTANCE:GetSecondaryGradient()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.SecondaryGradient ), shaderShiftConstantsEnum.SecondaryGradient ) --[[@as SecondaryGradient]]
    end

    --- @return SrcBlendFunc
    function INSTANCE:GetSrcBlendFunc()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.SrcBlend ), shaderShiftConstantsEnum.SrcBlend ) --[[@as SrcBlendFunc]]
    end

    --- @return Materialing
    function INSTANCE:GetMaterialing()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.Materialing ), shaderShiftConstantsEnum.Materialing ) --[[@as Materialing]]
    end

    --- @return NPatch
    function INSTANCE:GetNPatchEnable()
        return bit.rshift( bit.band( self.ShaderBits, maskEnum.NPatchEnable ), shaderShiftConstantsEnum.NPatchEnable ) --[[@as NPatch]]
    end
end

--[[ Bitflag Setters ]] do

    --- @param flag DepthCompare
    function INSTANCE:SetDepthCompare( flag )
        self.DepthCompare = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.DepthCompare )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.DepthCompare )
        )
    end

    --- @param flag DepthMask
    function INSTANCE:SetDepthMask( flag )
        self.DepthMask = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.DepthMask )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.DepthMask )
        )
    end

    --- @param flag ColorMask
    function INSTANCE:SetColorMask( flag )
        self.ColorMask = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.ColorMask )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.ColorMask )
        )
    end

    --- @param flag DstBlendFunc
    function INSTANCE:SetDstBlendFunc( flag )
        self.DstBlendFunc = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.DstBlend )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.DstBlend )
        )
    end

    --- @param flag SrcBlendFunc
    function INSTANCE:SetSrcBlendFunc( flag )
        self.SrcBlendFunc = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.SrcBlend )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.SrcBlend )
        )
    end

    --- @param flag FogFunc
    function INSTANCE:SetFogFunc( flag )
        self.FogFunc = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.Fog )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.Fog )
        )
    end

    --- @param flag PrimaryGradient
    function INSTANCE:SetPrimaryGradient( flag )
        self.PrimaryGradient = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.PrimaryGradient )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.PrimaryGradient )
        )
    end

    --- @param flag SecondaryGradient
    function INSTANCE:SetSecondaryGradient( flag )
        self.SecondaryGradient = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.SecondaryGradient )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.SecondaryGradient )
        )
    end

    --- @param flag Materialing
    function INSTANCE:SetMaterialing( flag )
        self.Materialing = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.Materialing )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.Materialing )
        )
    end

    --- @param flag AlphaTest
    function INSTANCE:SetAlphaTest( flag )
        self.AlphaTest = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.AlphaTest )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.AlphaTest )
        )
    end

    --- @param flag CullMode
    function INSTANCE:SetCullMode( flag )
        self.CullMode = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.CullMode )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.CullMode )
        )
    end

    --- @param flag DetailColorFunc
    function INSTANCE:SetPostDetailColorFunc( flag )
        self.PostDetailColorFunc = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.PostDetailColorFunc )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.PostDetailColorFunc )
        )
    end

    --- @param flag DetailAlphaFunc
    function INSTANCE:SetPostDetailAlphaFunc( flag )
        self.PostDetailAlphaFunc = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.PostDetailAlphaFunc )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.PostDetailAlphaFunc )
        )
    end

    --- @param flag NPatch
    function INSTANCE:SetNPatchEnable( flag )
        self.NPatchEnable = flag

        self.ShaderBits = bit.band( self.ShaderBits,
            bit.bnot( maskEnum.DepthCompare )
        )
        self.ShaderBits = bit.bor( self.ShaderBits,
            bit.lshift( flag, shaderShiftConstantsEnum.DepthCompare )
        )
    end
end

--- @param mat3 W3dMaterial3Struct
function INSTANCE:InitFromMaterial3( mat3 )
    typecheck.NotImplementedError()
end

--- "Turn on fog for this shader"  
--- "Enable most appropriate fog mode (FOG_ENABLE, FOG_SCALE_FRAGMENT, or FOG_WHITE) for given source and destination blends."
function INSTANCE:EnableFog()
    local sourceBlendFunc = self:GetSrcBlendFunc()

    local destBlendFunc = self:GetDstBlendFunc()

    if sourceBlendFunc == srcBlendFuncEnum.Zero then
        if destBlendFunc == dstBlendFuncEnum.SrcColor then
            self:SetFogFunc( fogFuncEnum.White )
        else
            -- Omitted call to ReportUnableToFog()
        end
        return
    elseif sourceBlendFunc == srcBlendFuncEnum.One then
        local isOpaque   = destBlendFunc == dstBlendFuncEnum.Zero
        local isAdditive = destBlendFunc == dstBlendFuncEnum.One
        local isScreen   = destBlendFunc == dstBlendFuncEnum.OneMinusSrcColor

        if isOpaque then
            self:SetFogFunc( fogFuncEnum.Enable )
        elseif isAdditive or isScreen then
            self:SetFogFunc( fogFuncEnum.ScaleFragment )
        else
            -- Omitted call to ReportUnableToFog()
        end
        return
    elseif sourceBlendFunc == srcBlendFuncEnum.SrcAlpha then
        if destBlendFunc == dstBlendFuncEnum.OneMinusSrcAlpha then
            self:SetFogFunc( fogFuncEnum.Enable )
        else
            -- Omitted call to ReportUnableToFog()
        end
        return
    elseif sourceBlendFunc == srcBlendFuncEnum.OneMinusSrcAlpha then
        if destBlendFunc == dstBlendFuncEnum.SrcAlpha then
            self:SetFogFunc( fogFuncEnum.Enable )
        else
            -- Omitted call to ReportUnableToFog()
        end
        return
    end
end