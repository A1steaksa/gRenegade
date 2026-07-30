-- Based on W3dUtilityClass within Code/ww3d2/w3d_util.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class W3dUtilityClass
--- @field Instance W3dUtilityInstance The metatable used by W3dUtilityInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "W3dUtilityClass"

--- @class W3dUtilityInstance
--- @field Static W3dUtilityClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_W3dUtility" )
INSTANCE.Class = "W3dUtilityInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsW3dUtility = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type ShaderClass
	local shaderClass = CNC.Import( "code/ww3d2/shader.lua" )
--#endregion

--#region Imported Enums

	local fogFuncEnum = shaderClass.FOG_FUNC
	local colorMaskEnum = shaderClass.COLOR_MASK
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class W3dUtilityClass

    --- Creates a new W3dUtilityInstance
    --- @return W3dUtilityInstance
    function STATIC.New()
        return robustclass.New( "Renegade_W3dUtility" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) W3dUtilityInstance, `false` otherwise
    function STATIC.IsW3dUtility( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsW3dUtility and true or false
    end

    typecheck.RegisterType( "W3dUtilityInstance", STATIC.IsW3dUtility )

	function STATIC.ConvertVector()
		typecheck.NotImplementedError()
	end

	function STATIC.ConvertQuaternion()
		typecheck.NotImplementedError()
	end

	function STATIC.ConvertColor()
		typecheck.NotImplementedError()
	end

	function STATIC.ConvertColor()
		typecheck.NotImplementedError()
	end

	--- @param struct W3dShaderStruct
	--- @return ShaderInstance
	function STATIC.ConvertShader( struct )
		local shader = shaderClass.New()

		shader:SetDepthCompare( struct.DepthCompare )
		shader:SetDepthMask( struct.DepthMask )
		shader:SetColorMask( colorMaskEnum.Enable )
		shader:SetDstBlendFunc( struct.DestBlend )
		shader:SetFogFunc( fogFuncEnum.Disable )
		shader:SetPrimaryGradient( struct.PriGradient )
		shader:SetSecondaryGradient( struct.SecGradient )
		shader:SetSrcBlendFunc( struct.SrcBlend )
		shader:SetMaterialing( struct.Texturing )
		shader:SetAlphaTest( struct.AlphaTest )
		shader:SetPostDetailColorFunc( struct.DetailColorFunc )
		shader:SetPostDetailAlphaFunc( struct.DetailAlphaFunc )

		return shader
	end
end


--- @class W3dUtilityInstance
