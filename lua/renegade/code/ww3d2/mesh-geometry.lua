-- Based on MeshGeometryClass within Code/ww3d2/meshgeometry.h

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class MeshGeometryClass
--- @field Instance MeshGeometryInstance The metatable used by MeshGeometryInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "MeshGeometryClass"

--- @class MeshGeometryInstance
--- @field Static MeshGeometryClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_MeshGeometry" )
INSTANCE.Class = "MeshGeometryInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsMeshGeometry = true

--#region Exported Enums

    --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

	local enumBuilder = enumBuilderClass.New()

	--- @enum MeshGeometryFlagsType
	STATIC.MESH_GEOMETRY_FLAGS_TYPE = {
		DIRTY_BOUNDS   = 0x00000001,
		DIRTY_PLANES   = 0x00000002,
		DIRTY_VNORMALS = 0x00000004,
		SORT                    = 0x00000010,
		DISABLE_BOUNDING_BOX    = 0x00000020,
		DISABLE_BOUNDING_SPHERE = 0x00000040,
		DISABLE_PLANE_EQ        = 0x00000080,
		TWO_SIDED               = 0x00000100,
		ALIGNED     = 0x00000200,
		SKIN        = 0x00000400,
		ORIENTED    = 0x00000800,
		CAST_SHADOW = 0x00001000,
		PRELIT_MASK                   = 0x0000E000,
		PRELIT_VERTEX                 = 0x00002000,
		PRELIT_LIGHTMAP_MULTI_PASS    = 0x00004000,
		PRELIT_LIGHTMAP_MULTI_TEXTURE = 0x00008000,
		ALLOW_NPATCHES = 0x00010000,
	}
	local meshGeometryFlagsTypeEnum = STATIC.MESH_GEOMETRY_FLAGS_TYPE
--#endregion

--#region Imports

	--- @type SphereClass
	local sphereClass = CNC.Import( "code/wwmath/sphere.lua" )

	--- @type W3dFileIds
	local w3dFileIds = CNC.Import( "code/ww3d2/w3d-file.lua" )

	--- @type WW3dErrorTypes
	local wW3dErrorTypes = CNC.Import( "code/ww3d2/w3d-errors.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type Vector4Class
	local vector4Class = CNC.Import( "code/wwmath/vector4.lua" )
--#endregion

--#region Imported Enums

	local w3dChunkTypesEnum = w3dFileIds.W3D_CHUNK_TYPE
	local wW3dErrorTypeEnum = wW3dErrorTypes.WW3D_ERROR_TYPE
	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--[[
	Porting Notes:
	Omitting sort level for now as I don't know that it's relevant in Lua
--]]

--[[ Static Functions and Variables ]] do

    --- @class MeshGeometryClass

	--- @type Vector4[]
	STATIC.PlaneEqArray = {}

    --- Creates a new MeshGeometryInstance
    --- @return MeshGeometryInstance
    function STATIC.New( that )
        return robustclass.New( "Renegade_MeshGeometry" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) MeshGeometryInstance, `false` otherwise
    function STATIC.IsMeshGeometry( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsMeshGeometry and true or false
    end

    typecheck.RegisterType( "MeshGeometryInstance", STATIC.IsMeshGeometry )
end


--- "This class encapsulates the geometry data for a triangle mesh."  
--- This is also the connection point where Renegade W3D meshes are replaced with Source MDL meshes
--- @class MeshGeometryInstance
--- @field SourceModelPath string The path of the `.mdl` file for this mesh
--- @field MeshName string
--- @field UserText string
--- @field Flags integer
--- @field W3dAttributes integer
--- @field PolygonCount integer
--- @field VertexCount integer
--- @field Polygons Vector[]
--- @field Vertex Vector[]
--- @field VertexNorm Vector[]
--- @field PlaneEq Vector4[]
--- @field VertexShadeIdx integer[]
--- @field VertexBoneLink integer[]
--- @field PolygonSurfaceType integer[]
--- @field BoundBoxMin Vector
--- @field BoundBoxMax Vector
--- @field BoundSphereCenter Vector
--- @field BoundSphereRadius number
--- @field CullTree AABTreeInstance

--- @param that MeshGeometryInstance?
function INSTANCE:Renegade_MeshGeometry( that )
	self.MeshName = nil
	self.UserText = nil
	self.Flags = 0
	self.W3dAttributes = 0
	self.PolygonCount = 0
	self.VertexCount = 0
	self.Polygons = nil
	self.PolygonSurfaceType = nil
	self.Vertex = nil
	self.VertexNorm = nil
	self.PlaneEq = nil
	self.VertexShadeIdx = nil
	self.VertexBoneLink = nil
	self.BoundBoxMin = Vector( 0, 0, 0 )
	self.BoundBoxMax = Vector( 1, 1, 1 )
	self.BoundSphereCenter = Vector( 0, 0, 0 )
	self.BoundSphereRadius = 1
	self.CullTree = nil

	-- ( that: MeshGeometryInstance )
	if that ~= nil then
		typecheck.AssertArgType( self.Class, 1, that, "MeshGeometryInstance" )

		typecheck.NotImplementedError()
	end
end

function INSTANCE:_Renegade_MeshGeometry()
	typecheck.NotImplementedError()
end

--- "Releases current resources and allocates space if need"
--- @param polygonCount integer
--- @param vertexCount integer
function INSTANCE:ResetGeometry( polygonCount, vertexCount )
	-- "Release everything we have and reset to initial state"
	self.Flags = 0
	self.PolygonCount = 0
	self.VertexCount = 0
	self.SortLevel = w3dFileIds.SORT_LEVEL_NONE

	self.PolygonCount = polygonCount
	self.VertexCount = vertexCount

	-- "Allocate new geometry arrays"
	self.Polygons = {}
	self.PolygonSurfaceType = {}
	self.Vertex = {}
	self.VertexNorm = {}
end


--[[ Source Model Path ]] do

	--- @param path string
	function INSTANCE:SetSourceModelPath( path )
		if self.SourceModelPath == path then
			return
		end

		self.SourceModelPath = path

		
	end

	--- @return string
	function INSTANCE:GetSourceModelPath()
		return self.SourceModelPath
	end
end

--[[ Name ]] do

	--- @return string?
	function INSTANCE:GetName()
		if self.MeshName then
			return self.MeshName
		end
	end

	--- @param newName string
	function INSTANCE:SetName( newName )
		if newName then
			self.MeshName = newName
		end
	end
end


--[[ User Text ]] do

	--- @return string
	function INSTANCE:GetUserText()
		typecheck.NotImplementedError()
	end

	--- @param userText string
	function INSTANCE:SetUserText( userText )
		typecheck.NotImplementedError()
	end
end


--[[ Flags ]] do

	--- @param flag MeshGeometryFlagsType
	--- @param onOff boolean
	function INSTANCE:SetFlag( flag, onOff )
		if onOff then
			self.Flags = bit.bor( self.Flags, flag )
		else
			self.Flags = bit.band( self.Flags, bit.bnot( flag ) )
		end
	end

	--- @param flag MeshGeometryFlagsType
	--- @return integer
	function INSTANCE:GetFlag( flag )
		return bit.band( self.Flags, flag )
	end
end


--[[ Sort Level ]] do

	--- @param level integer
	function INSTANCE:SetSortLevel( level )
		self.SortLevel = level
	end

	--- @return integer
	function INSTANCE:GetSortLevel()
		return self.SortLevel
	end
end


--[[ Getters ]] do

	--- @return integer
	function INSTANCE:GetPolygonCount()
		return self.PolygonCount
	end

	--- @return integer
	function INSTANCE:GetVertexCount()
		return self.VertexCount
	end

	--- @return Vector[]
	function INSTANCE:GetPolygonArray()
		return self:GetPolys()
	end

	--- @return Vector[]
	function INSTANCE:GetVertexArray()
		return self.Vertex
	end

	--- @return Vector[]
	function INSTANCE:GetVertexNormalArray()
		typecheck.NotImplementedError()
	end

	--- @param create boolean? [Default: true]
	--- @return Vector4Instance[]
	function INSTANCE:GetPlaneArray( create )
		create = ( ( create == nil ) and true or create )

		typecheck.NotImplementedError()
	end

	--- @param create boolean? [Default: true]
	--- @return integer[]?
	function INSTANCE:GetVertexShadeIndexArray( create )
		create = ( ( create == nil ) and true or create )

		return self:GetShadeIndices( create )
	end

	--- @return integer[]?
	function INSTANCE:GetVertexBoneLinks()
		return self:GetBoneLinks()
	end

	--- @return integer[]
	function INSTANCE:GetPolygonSurfaceTypeArray()
		return self.PolygonSurfaceType
	end

	--- @param polygonIndex integer
	--- @return integer
	function INSTANCE:GetPolygonSurfaceType( polygonIndex )
		assert( self.PolygonSurfaceType ~= nil )
		assert( polygonIndex >= 0 and polygonIndex < self.PolygonCount )
		local type = self.PolygonSurfaceType
		return type[polygonIndex]
	end

	--- @return AABoxInstance
	function INSTANCE:GetBoundingBox()
		typecheck.NotImplementedError()
	end

	--- "Get the bounding sphere"
	--- @return SphereInstance
	function INSTANCE:GetBoundingSphere()
		return sphereClass.New( self.BoundSphereCenter, self.BoundSphereRadius )
	end
end

--- @param pidx integer
--- @return PlaneInstance
function INSTANCE:ComputePlane( pidx )
	typecheck.NotImplementedError()
end

--- "Exposed culling support"
--- @return boolean
function INSTANCE:HasCullTree()
	return self.CullTree ~= nil
end

function INSTANCE:GenerateRigidApt( ... )
	typecheck.NotImplementedError()
end

--- @param worldBox OBBoxInstance
--- @param apt integer[]
--- @param worldVertexLocations Vector[]
function INSTANCE:GenerateSkinApt( worldBox, apt, worldVertexLocations )
	typecheck.NotImplementedError()
end

--- "Containment"
--- @param point Vector
--- @return boolean
function INSTANCE:Contains( point )
	typecheck.NotImplementedError()
end


--[[ Ray Casting and Intersection ]] do

	--- @param rayTest RayCollisionTestInstance
	function INSTANCE:CastRay( rayTest )
		typecheck.NotImplementedError()
	end

	--- @param boxTest AABoxIntersectionTestInstance
	function INSTANCE:CastAABox( boxTest )
		typecheck.NotImplementedError()
	end

	--- @param boxTest OBBoxIntersectionTestInstance
	function INSTANCE:CastOBBox( boxTest )
		typecheck.NotImplementedError()
	end

	--- @param boxTest OBBoxIntersectionTestInstance
	function INSTANCE:IntersectOBBox( boxTest )
		typecheck.NotImplementedError()
	end

	--- "  
	--- This function analyses the transform passed into it to call various optimized functions if
	--- the transform is identity or a simple rotation about the Z-axis. Otherwise it transforms
	--- boxtest into object space, performs an oob cast and transforms the result back.
	--- "  
	--- @param boxTest AABoxCollisionTestInstance
	--- @param transform Matrix3dInstance
	--- @return boolean
	function INSTANCE:CastWorldSpaceAaBox( boxTest, transform )
		typecheck.NotImplementedError()
	end
end

--- "  
--- W3D File Format support.  
--- Note that derived classes have to override these functions completely
--- so that they can handle their extra chunks.  Using these functions you
--- could load mesh data out of a W3D file while ignoring all materials,
--- textures, etc.  
--- "  
--- @param cload ChunkLoadInstance
--- @return WW3dErrorType
function INSTANCE:LoadW3d( cload )
	-- "
	-- This function will initialize this [MeshGeometryInstance] from the contents of a W3D file.
	-- Note that derived classes need to completely replace this function; only re-using the individual
	-- chunk handling functions.
	-- "

	-- "Open the first chunk, it should be the mesh header"
	cload:OpenChunk()

	if cload:CurChunkId() ~= w3dChunkTypesEnum.W3D_CHUNK_MESH_HEADER3 then
		section.Warn( "Old format mesh mesh, no longer supported." )
		goto Error
	end

	typecheck.NotImplementedError()

	::Error::
	return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
end

--- @param scale Vector
function INSTANCE:Scale( scale )
	typecheck.NotImplementedError()
end


--[[ Internal Accessor Functions ]] do

	--- @protected
	--- @return Vector[]
	function INSTANCE:GetPolys()
		return self.Polygons
	end

	--- @protected
	--- @return Vector[]
	function INSTANCE:GetVertexNormals()
		return self.VertexNorm
	end

	--- @protected
	--- @param create boolean? [Default: true]
	--- @return integer[]?
	function INSTANCE:GetShadeIndices( create )
		create = ( ( create == nil ) and true or create )

		if create and not self.VertexShadeIdx then
			self.VertexShadeIdx = {}
		end

		if self.VertexShadeIdx then
			return self.VertexShadeIdx
		end
	end

	--- "Get the plane array memory (internal)"
	--- @protected
	--- @param create boolean? [Default: true]
	--- @return Vector4Instance[]
	function INSTANCE:GetPlanes( create )
		create = ( ( create == nil ) and true or create )
		return STATIC.PlaneEqArray
	end

	--- @protected
	--- @param create boolean? [Default: true]
	--- @return integer[]?
	function INSTANCE:GetBoneLinks( create )
		create = ( ( create == nil ) and true or create )

		if create and not self.VertexBoneLink then
			self.VertexBoneLink = {}
		end

		if self.VertexBoneLink then
			return self.VertexBoneLink
		end
	end
end


--[[ Utility Functions ]] do

	--- @protected
	--- @param startPoint Vector
	--- @param axisDirection integer
	--- @param flags integer
	--- @return integer
	function INSTANCE:CastSemiInfiniteAxisAlignedRay( startPoint, axisDirection, flags )
		typecheck.NotImplementedError()
	end


	--[[ AABoxes ]] do

		--- @protected
		--- @param boxTest AABoxCollisionTestInstance
		--- @param transform Vector
		--- @return boolean
		function INSTANCE:CastAABoxIdentity( boxTest, transform )
			typecheck.NotImplementedError()
		end

		--- @protected
		--- @param boxTest AABoxCollisionTestInstance
		--- @param transform Vector
		--- @return boolean
		function INSTANCE:CastAABoxZ90( boxTest, transform )
			typecheck.NotImplementedError()
		end

		--- @protected
		--- @param boxTest AABoxCollisionTestInstance
		--- @param transform Vector
		--- @return boolean
		function INSTANCE:CastAABoxZ180( boxTest, transform )
			typecheck.NotImplementedError()
		end

		--- @protected
		--- @param boxTest AABoxCollisionTestInstance
		--- @param transform Vector
		--- @return boolean
		function INSTANCE:CastAABoxZ270( boxTest, transform )
			typecheck.NotImplementedError()
		end
	end


	--[[ Brute Force ]] do

		--- @protected
		--- @param localTest OBBoxIntersectionTestInstance
		--- @return boolean
		function INSTANCE:IntersectOBBoxBruteForce( localTest )
			typecheck.NotImplementedError()
		end

		--- @protected
		--- @param rayTest RayCollisionTestInstance
		--- @return boolean
		function INSTANCE:CastRayBruteForce( rayTest )
			typecheck.NotImplementedError()
		end

		--- @protected
		--- @param boxTest AABoxCollisionTestInstance
		--- @return boolean
		function INSTANCE:CastAABoxBruteForce( boxTest )
			typecheck.NotImplementedError()
		end

		--- @protected
		--- @param boxTest OBBoxCollisionTestInstance
		--- @return boolean
		function INSTANCE:CastOBBoxBruteForce( boxTest )
			typecheck.NotImplementedError()
		end
	end
end


--[[ Recompute Dirty Normals and Volumes ]] do

	--- @protected
	--- @param array Vector4[]
	function INSTANCE:ComputePlaneEquations( array )
		typecheck.NotImplementedError()
	end

	--- @protected
	--- @param array Vector[]
	function INSTANCE:ComputeVertexNormals( array )
		typecheck.NotImplementedError()
	end

	--- @protected
	--- @param verts Vector[]
	function INSTANCE:ComputeBounds( verts )
		typecheck.NotImplementedError()
	end

	--- @protected
	function INSTANCE:GenerateCullingTree()
		typecheck.NotImplementedError()
	end
end


--[[ W3D Chunk Reading ]] do

	--- @protected
	--- @param cload ChunkLoadInstance
	--- @return WW3dErrorType
	function INSTANCE:ReadChunks( cload )
		typecheck.NotImplementedError()
	end

	--- @protected
	--- @param cload ChunkLoadInstance
	--- @return WW3dErrorType
	function INSTANCE:ReadVertices( cload )
		local loc = self.Vertex

		local expectedVertexCount = self:GetVertexCount()

		for i = 1, expectedVertexCount do
			local vert = cload:ReadStruct( "W3dVectorStruct" )
			if not vert then
				return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
			end

			loc[i] = Vector( vert.X, vert.Y, vert.Z )
		end

		return wW3dErrorTypeEnum.WW3D_ERROR_OK
	end

	--- @protected
	--- @param cload ChunkLoadInstance
	--- @return WW3dErrorType
	function INSTANCE:ReadVertexNormals( cload )
		local modelNormals = self:GetVertexNormals()

		for i = 1, self.VertexCount do
			local normal = cload:ReadStruct( "W3dVectorStruct" )
			if not normal then
				return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
			end

			modelNormals[i] = Vector( normal.X, normal.Y, normal.Z )
		end

		return wW3dErrorTypeEnum.WW3D_ERROR_OK
	end

	--- @protected
	--- @param cload ChunkLoadInstance
	--- @return WW3dErrorType
	function INSTANCE:ReadTriangles( cload )
		-- "Cache pointers to various arrays in the surrender mesh"
		local polys = self:GetPolys()
		self:SetFlag( meshGeometryFlagsTypeEnum.DIRTY_PLANES, false )
		local planes = self:GetPlanes()
		local surfaceTypes = self:GetPolygonSurfaceTypeArray()

		-- "Read in each polygon one by one"
		for i = 1, self:GetPolygonCount() do
			local triangle = cload:ReadStruct( "W3dTriStruct" )
			if not triangle then
				return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
			end

			-- "Set the vertex indicies"
			polys[i] = Vector(
				triangle.Vindex[1],
				triangle.Vindex[2],
				triangle.Vindex[3]
			)

			-- "Set the normal"
			planes[i] = vector4Class.New(
				triangle.Normal.X,
				triangle.Normal.Y,
				triangle.Normal.Z,
				-triangle.Distance
			)

			-- "Set the surface type"
			surfaceTypes[i] = triangle.Attributes
		end

		return wW3dErrorTypeEnum.WW3D_ERROR_OK
	end

	--- @protected
	--- @param cload ChunkLoadInstance
	--- @return WW3dErrorType
	function INSTANCE:ReadUserText( cload )
		typecheck.NotImplementedError()
	end

	--- @protected
	--- @param cload ChunkLoadInstance
	--- @return WW3dErrorType
	function INSTANCE:ReadVertexInfluences( cload )
		typecheck.NotImplementedError()
	end

	--- @protected
	--- @param cload ChunkLoadInstance
	--- @return WW3dErrorType
	function INSTANCE:ReadVertexShadeIndices( cload )
		local shadeIndices = self:GetShadeIndices( true )

		for i = 1, self:GetVertexCount() do
			local shadeIndex = cload:ReadFundamentalDataType( fundamentalDataTypeEnum.UInt32 )
			if shadeIndex == nil then
				return wW3dErrorTypeEnum.WW3D_ERROR_LOAD_FAILED
			end
			shadeIndices[i] = shadeIndex
		end

		return wW3dErrorTypeEnum.WW3D_ERROR_OK
	end

	--- @protected
	--- @param cload ChunkLoadInstance
	--- @return WW3dErrorType
	function INSTANCE:ReadAABTree( cload )
		typecheck.NotImplementedError()
	end
end
