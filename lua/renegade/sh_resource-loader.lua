-- This library helps with reading "resources" embedded within PE formatted Windows executable (.exe) files.
-- It's necessary here because Renegade embeds all of its menu and dialog layouts as resources within the game's .exe file.

--- @class Renegade
local CNC = CNC_RENEGADE

--- @class ResourceLoaderLib
local LIB = CNC.CreateExport()
LIB.Class = "ResourceLoaderLib"
local isHotload = not table.IsEmpty( LIB )

--#region Exported Enums

     --- @type EnumBuilderClass
    local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )

    local enumBuilder = enumBuilderClass.New()

    --- Credit: https://learn.microsoft.com/en-us/windows/win32/menurc/resource-types
    --- @enum ResourceType
    LIB.RESOURCE_TYPE = {
        RT_ACCELERATOR  =  9,
        RT_ANICURSOR    = 21,
        RT_ANIICON      = 22,
        RT_BITMAP       =  2,
        RT_CURSOR       =  1,
        RT_DIALOG       =  5,
        RT_DLGINCLUDE   = 17,
        RT_FONT         =  8,
        RT_FONTDIR      =  7,
        RT_GROUP_CURSOR = -1, -- Value set below
        RT_GROUP_ICON   = -1, -- Value set below
        RT_HTML         = 23,
        RT_ICON         =  3,
        RT_MANIFEST     = 24,
        RT_MENU         =  4,
        RT_MESSAGETABLE = 11,
        RT_PLUGPLAY     = 19,
        RT_RCDATA       = 10,
        RT_STRING       =  6,
        RT_VERSION      = 16,
        RT_VXD          = 20,
    }
    local resourceTypeEnum = LIB.RESOURCE_TYPE

    resourceTypeEnum.RT_GROUP_CURSOR = resourceTypeEnum.RT_CURSOR + 11
    resourceTypeEnum.RT_GROUP_ICON = resourceTypeEnum.RT_ICON + 11

    --- Credit: https://learn.microsoft.com/en-us/windows/win32/winmsg/window-styles
    --- @enum WindowStyles
    LIB.WINDOW_STYLES = {
        WS_BORDER           = 0x00800000,
		WS_CAPTION          = 0x00C00000,
		WS_CHILD            = 0x40000000,
		WS_CHILDWINDOW      = 0x40000000,
		WS_CLIPCHILDREN		= 0x02000000,
		WS_CLIPSIBLINGS		= 0x04000000,
		WS_DISABLED			= 0x08000000,
		WS_DLGFRAME			= 0x00400000,
		WS_GROUP			= 0x00020000,
		WS_HSCROLL			= 0x00100000,
		WS_ICONIC			= 0x20000000,
		WS_MAXIMIZE			= 0x01000000,
		WS_MAXIMIZEBOX      = 0x00010000,
		WS_MINIMIZE         = 0x20000000,
		WS_MINIMIZEBOX      = 0x00020000,
		WS_OVERLAPPED       = 0x00000000,
		WS_OVERLAPPEDWINDOW = -1, -- Value set below
		WS_POPUP            = 0x80000000,
		WS_POPUPWINDOW		= -1, -- Value set below
		WS_SIZEBOX          = 0x00040000,
		WS_SYSMENU          = 0x00080000,
		WS_TABSTOP          = 0x00010000,
		WS_THICKFRAME       = 0x00040000,
		WS_TILED            = 0x00000000,
		WS_TILEDWINDOW		= -1, -- Value set below
		WS_VISIBLE          = 0x10000000,
		WS_VSCROLL          = 0x00200000,
    }
    local windowStylesEnum = LIB.WINDOW_STYLES

	windowStylesEnum.WS_OVERLAPPEDWINDOW = bit.bor(
		windowStylesEnum.WS_OVERLAPPED,
		windowStylesEnum.WS_CAPTION,
		windowStylesEnum.WS_SYSMENU,
		windowStylesEnum.WS_THICKFRAME,
		windowStylesEnum.WS_MINIMIZEBOX,
		windowStylesEnum.WS_MAXIMIZEBOX
	)

	windowStylesEnum.WS_POPUPWINDOW = bit.bor(
		windowStylesEnum.WS_POPUP,
		windowStylesEnum.WS_BORDER,
		windowStylesEnum.WS_SYSMENU
	)

	windowStylesEnum.WS_TILEDWINDOW = bit.bor(
		windowStylesEnum.WS_OVERLAPPED,
		windowStylesEnum.WS_CAPTION,
		windowStylesEnum.WS_SYSMENU,
		windowStylesEnum.WS_THICKFRAME,
		windowStylesEnum.WS_MINIMIZEBOX,
		windowStylesEnum.WS_MAXIMIZEBOX
	)
--#endregion

--#region Imports

	--- @type TextUtils
	local textUtils = CNC.Import( "sh_text-utils.lua" )

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type ChunkIOClass
	local chunkIOClass = CNC.Import( "code/wwlib/chunk-io.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
--#endregion

--- @class Resource
--- @field Name string
--- @field Data string

--- @class IMAGE_RESOURCE_DIRECTORY_CONTENT
--- @field NameEntries IMAGE_RESOURCE_DIRECTORY_NAME_ENTRY[]
--- @field IdEntries IMAGE_RESOURCE_DIRECTORY_ID_ENTRY[]

--- @alias ResourceTree table<string, table<ResourceType, table<integer, table<integer, string>>>>


--- @class ResourceLoaderLib
--- @field FileBytes string

--- @type ResourceTree
LIB.ResourceTree = {}

--- @type SECTION_TABLE_HEADER[]
LIB.SectionHeaders = {}

function LIB.StaticConstructor()

	--- @class COFF_FILE_HEADER
	--- @field Machine integer
	--- @field NumberOfSections integer
	--- @field TimeDateStamp integer
	--- @field PointerToSymbolTable integer
	--- @field NumberOfSymbols integer
	--- @field SizeOfOptionalHeader integer
	--- @field Characteristics integer
	deserializeLib.RegisterComplexDataType( "COFF_FILE_HEADER", {
		{ Name = "Machine", 				DataType = fundamentalDataTypeEnum.UInt16  },
		{ Name = "NumberOfSections", 	DataType = fundamentalDataTypeEnum.UInt16 },
		{ Name = "TimeDateStamp",		DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "PointerToSymbolTable",	DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "NumberOfSymbols",		DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "SizeOfOptionalHeader",	DataType = fundamentalDataTypeEnum.UInt16 },
		{ Name = "Characteristics",		DataType = fundamentalDataTypeEnum.UInt16 },
	} )

	--- @class SECTION_TABLE_HEADER
	--- @field Name string
	--- @field VirtualSize integer
	--- @field VirtualAddress integer
	--- @field SizeOfRawData  integer
	--- @field PointerToRawData  integer
	--- @field PointerToRelocations integer
	--- @field PointerToLineNumbers integer
	--- @field NumberOfRelocations integer
	--- @field NumberOfLineNumbers integer
	--- @field Characteristics integer
	deserializeLib.RegisterComplexDataType( "SECTION_TABLE_HEADER", {
		{ Name = "Name",					DataType = fundamentalDataTypeEnum.String, Length = 8 },
		{ Name = "VirtualSize", 			DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "VirtualAddress",			DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "SizeOfRawData",			DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "PointerToRawData",		DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "PointerToRelocations",	DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "PointerToLineNumbers",	DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "NumberOfRelocations",		DataType = fundamentalDataTypeEnum.UInt16 },
		{ Name = "NumberOfLineNumbers",		DataType = fundamentalDataTypeEnum.UInt16 },
		{ Name = "Characteristics",			DataType = fundamentalDataTypeEnum.UInt32 },
	} )

	--- @class IMAGE_RESOURCE_DIRECTORY
	--- @field Characteristics integer
	--- @field TimeDateStamp integer
	--- @field MajorVersion integer
	--- @field MinorVersion integer
	--- @field NumberOfNameEntries integer
	--- @field NumberOfIdEntries integer
	deserializeLib.RegisterComplexDataType( "IMAGE_RESOURCE_DIRECTORY", {
		{ Name = "Characteristics", 		DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "TimeDateStamp", 		DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "MajorVersion", 		DataType = fundamentalDataTypeEnum.UInt16 },
		{ Name = "MinorVersion", 		DataType = fundamentalDataTypeEnum.UInt16 },
		{ Name = "NumberOfNameEntries", 	DataType = fundamentalDataTypeEnum.UInt16 },
		{ Name = "NumberOfIdEntries", 	DataType = fundamentalDataTypeEnum.UInt16 },
	} )

	--- @class IMAGE_RESOURCE_DIRECTORY_NAME_ENTRY
	--- @field NameOffset integer
	--- @field ChildDirectoryOffset integer?
	--- @field DataEntryOffset integer?
	deserializeLib.RegisterComplexDataType( "IMAGE_RESOURCE_DIRECTORY_NAME_ENTRY", {
		{ Name = "Arg", DataType = fundamentalDataTypeEnum.UInt32, ArrayLength = 2 }
	}, function( name, loadedData )
		local args = loadedData["Arg"]
		local arg2 = args[2]

		-- The high bit on the first argument tells us if this is a sub-directory or leaf node
		local highBitMask = bit.lshift( 1, 31 )
		local isDirectory = tobool( bit.band( highBitMask, arg2 ) )

		-- Remove the high bit
		arg2 = bit.band( bit.bnot( highBitMask ), arg2 )

		if isDirectory then
			return {
				NameOffset = args[1],
				ChildDirectoryOffset = arg2
			}
		else
			return {
				NameOffset = args[1],
				DataEntryOffset = arg2
			}
		end
	end )

	--- @class IMAGE_RESOURCE_DIRECTORY_ID_ENTRY
	--- @field ID integer
	--- @field ChildDirectoryOffset integer?
	--- @field DataEntryOffset integer?
	deserializeLib.RegisterComplexDataType( "IMAGE_RESOURCE_DIRECTORY_ID_ENTRY", {
		{ Name = "Arg", DataType = fundamentalDataTypeEnum.UInt32, ArrayLength = 2 }
	}, function( name, loadedData )
		local args = loadedData["Arg"]
		local arg2 = args[2]

		-- The high bit on the first argument tells us if this is a sub-directory or leaf node
		local highBitMask = bit.lshift( 1, 31 )
		local isDirectory = tobool( bit.band( highBitMask, arg2 ) )

		-- Remove the high bit
		arg2 = bit.band( bit.bnot( highBitMask ), arg2 )

		if isDirectory then
			return {
				ID = args[1],
				ChildDirectoryOffset = arg2
			}
		else
			return {
				ID = args[1],
				DataEntryOffset = arg2
			}
		end
	end )

	--- @class IMAGE_RESOURCE_DATA_ENTRY
	--- @field OffsetToData integer
	--- @field Size integer
	--- @field CodePage integer
	--- @field Reserved integer
	deserializeLib.RegisterComplexDataType( "IMAGE_RESOURCE_DATA_ENTRY", {
		{ Name = "OffsetToData", DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "Size", 		DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "CodePage", 	DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "Reserved", 	DataType = fundamentalDataTypeEnum.UInt32 },
	} )

end

function LIB.RunTest()
	LIB.ReadExecutable( "data/renegade/game.exe.txt" )
	LIB.ParseSectionHeaders()
	LIB.ParseResources()
end

function LIB.ReadExecutable( path )
	LIB.FileBytes = file.Read( path, "THIRDPARTY" )
	if LIB.FileBytes == nil then
		section.Error( "Unable to read executable for resource parsing: '", path, "'" )
	end
end

function LIB.ParseSectionHeaders()
	assert( LIB.FileBytes ~= nil )

	local peSignatureAddress = 0x03C + 1 -- Immediately after the MS-DOS stub

	-- This tells us where the PE header actually lives
	local peStartAddress = LIB.ReadDataTypeFromAddress( peSignatureAddress, fundamentalDataTypeEnum.UInt32 ) + 1

	-- Ignore 4 bytes of "PE\0\0" here because I don't want to deal with them right now
	local coffHeaderAddress = peStartAddress + 4

	-- Read the COFF file header
	local coffHeader, optionalHeaderAddress = LIB.ReadDataTypeFromAddress( coffHeaderAddress, "COFF_FILE_HEADER" )

	-- Skip the optional headers
	local sectionTableAddress = optionalHeaderAddress + coffHeader.SizeOfOptionalHeader

	-- Read section headers
	local sectionHeader
	local nextSectionAddress = sectionTableAddress
	for sectionIndex = 1, coffHeader.NumberOfSections do
		sectionHeader, nextSectionAddress = LIB.ReadDataTypeFromAddress( nextSectionAddress, "SECTION_TABLE_HEADER" )
		LIB.SectionHeaders[sectionIndex] = sectionHeader
	end
end

--[[ Getters ]] do

	--- @param name string
	--- @return SECTION_TABLE_HEADER?
	function LIB.GetSectionHeader( name )
		assert( LIB.SectionHeaders ~= nil and #LIB.SectionHeaders > 0 )

		for _, sectionHeader in ipairs( LIB.SectionHeaders ) do
			if sectionHeader.Name == name then
				return sectionHeader
			end
		end
	end
end

--[[ Utils ]] do


	--- @param rva integer
	--- @return integer
	function LIB.RelativeVirtualAddressToFileOffset( rva )
		assert( LIB.SectionHeaders ~= nil and #LIB.SectionHeaders > 0 )

		for sectionIndex, sectionHeader in ipairs( LIB.SectionHeaders ) do
			if ( rva >= sectionHeader.VirtualAddress ) and ( rva < ( sectionHeader.VirtualAddress + sectionHeader.VirtualSize ) ) then
				return sectionHeader.PointerToRawData + ( rva - sectionHeader.VirtualAddress )
			end
		end

		section.Error( "RVA does not appear to belong to any section: ", rva )
		error()
	end

	--- @generic T
	--- @param address integer
	--- @param dataType FundamentalDataType|`T`
	--- @return T|any readDataType
	--- @return integer addressAfterRead The address immediately after the loaded data
	function LIB.ReadDataTypeFromAddress( address, dataType )
		assert( LIB.FileBytes ~= nil )
		assert( address > 0 and address <= #LIB.FileBytes )

		local dataTypeSize = deserializeLib.GetDataTypeSize( dataType )
		local dataTypeBytes = LIB.FileBytes:sub( address, address + dataTypeSize )
		local dataTypeInstance = deserializeLib.Deserialize( dataType, dataTypeBytes )

		return dataTypeInstance, ( address + dataTypeSize )
	end

	--- @param address integer
	--- @param length integer? [Default: `32`]
	--- @return string
	function LIB.Sample( address, length )
		assert( LIB.FileBytes ~= nil )
		if length == nil then length = 32 end

		return Hex( LIB.FileBytes:sub( address, address + length ) )
	end
end

--- @return ResourceTree
function LIB.ParseResources()
	local resourceSectionHeader = LIB.GetSectionHeader( ".rsrc" )
	assert( resourceSectionHeader ~= nil )

	-- Read the root node of the resources tree
	-- These IDs should correspond to ResourceType enums
	local resourceTreeRoot = LIB.ReadResourceDirectory( resourceSectionHeader.PointerToRawData )

	PrintTable( resourceTreeRoot )

	return LIB.ResourceTree
end

--- @param directoryAddress integer
--- @return IMAGE_RESOURCE_DIRECTORY_CONTENT
function LIB.ReadResourceDirectory( directoryAddress )
	assert( LIB.SectionHeaders ~= nil and #LIB.SectionHeaders ~= 0 )

	local resourceSectionHeader = LIB.GetSectionHeader( ".rsrc" )
	assert( resourceSectionHeader ~= nil )

	section.Start( "Reading directory at ", Hex( directoryAddress ) )

	-- Read the directory's header
	local directoryHeader, directoryEntriesAddress = LIB.ReadDataTypeFromAddress( directoryAddress + 1, "IMAGE_RESOURCE_DIRECTORY" )
	assert( directoryHeader ~= nil )

	-- Grab the directory's bytes
	local nameDirectoryEntrySize = deserializeLib.GetComplexDataTypeSize( "IMAGE_RESOURCE_DIRECTORY_NAME_ENTRY" )
	local idDirectoryEntrySize   = deserializeLib.GetComplexDataTypeSize( "IMAGE_RESOURCE_DIRECTORY_ID_ENTRY" )
	local totalDirectoryContentSize = (
		( nameDirectoryEntrySize * directoryHeader.NumberOfNameEntries )
	  + ( idDirectoryEntrySize * directoryHeader.NumberOfIdEntries )
	)

	local directoryContentBytes = LIB.FileBytes:sub(
		directoryEntriesAddress,
		directoryEntriesAddress + totalDirectoryContentSize
	)

	local resourceSectionBasePointer = LIB.GetSectionHeader( ".rsrc" ).PointerToRawData

	-- Read the directory's name entries
	local nameDirectoryContents = {}
	for _ = 1, directoryHeader.NumberOfNameEntries do
		typecheck.NotImplementedError()
	end

	-- Read the directory's ID entries
	local idDirectoryContents = {}
	for directoryIdEntryIndex = 1, directoryHeader.NumberOfIdEntries do
		local entry
		entry, directoryContentBytes = deserializeLib.ReadComplexDataType( "IMAGE_RESOURCE_DIRECTORY_ID_ENTRY", directoryContentBytes )

		section.Print( "ID: ", entry.ID )

		local isChildDirectory = ( entry.ChildDirectoryOffset ~= nil )
		if isChildDirectory then
			local childDirectoryContents = LIB.ReadResourceDirectory( resourceSectionBasePointer + entry.ChildDirectoryOffset )
			idDirectoryContents[entry.ID] = childDirectoryContents
		else

			local dataAddress = resourceSectionBasePointer + ( entry.DataEntryOffset + 1 )

			local dataEntry = LIB.ReadDataTypeFromAddress( dataAddress, "IMAGE_RESOURCE_DATA_ENTRY" )
			assert( dataEntry ~= nil )

			local dataAddress = LIB.RelativeVirtualAddressToFileOffset( dataEntry.OffsetToData )

			section.Print( "Data Address: ", dataAddress, " (", Hex( dataAddress ), ")" )

			idDirectoryContents[entry.ID] = dataEntry
		end

	end

	section.End()

	return {
		NameEntries = nameDirectoryContents,
		IdEntries = idDirectoryContents
	}
end

function LIB.ParseExecutable()
	local fileContents = file.Read( "data/renegade/game.exe.txt", "THIRDPARTY" )
	local resourceSectionStartIndex = textUtils.IndexOf( fileContents, ".rsrc" ) + #".rsrc"

	local resourceSectionHeader = deserializeLib.ReadComplexDataType( "SECTION_TABLE_HEADER", fileContents:sub( resourceSectionStartIndex ) )
	local resourceBaseAddress = resourceSectionHeader.RawDataPointer + 1

	local resourceSectionBytes = fileContents:sub( resourceBaseAddress, resourceBaseAddress + resourceSectionHeader.RawDataSize )

	local resourceDirectoryTableHeader
	resourceDirectoryTableHeader, resourceSectionBytes = deserializeLib.ReadComplexDataType( "IMAGE_RESOURCE_DIRECTORY", resourceSectionBytes )

	-- Read the name entries
	local resourceDirectoryTableHeaderNameEntries = {}
	for _ = 1, resourceDirectoryTableHeader.NumberOfNameEntries do
		local entry
		entry, resourceSectionBytes = deserializeLib.ReadComplexDataType( "IMAGE_RESOURCE_DIRECTORY_NAME_ENTRY", resourceSectionBytes )
		resourceDirectoryTableHeaderNameEntries[#resourceDirectoryTableHeaderNameEntries + 1] = entry
	end

	if #resourceDirectoryTableHeaderNameEntries ~= 0 then
		section.Start( "Name Resource Directory Table Entries" )
		--- @param entry IMAGE_RESOURCE_DIRECTORY_NAME_ENTRY
		for index, entry in ipairs( resourceDirectoryTableHeaderNameEntries ) do
			section.Print( index, ". ", entry.NameOffset, " at offset ", entry )
		end
		section.End()
	end

	-- Read the ID entries
	local resourceDirectoryTableHeaderIdEntries = {}
	for _ = 1, resourceDirectoryTableHeader.NumberOfIdEntries do
		local entry
		entry, resourceSectionBytes = deserializeLib.ReadComplexDataType( "IMAGE_RESOURCE_DIRECTORY_ID_ENTRY", resourceSectionBytes )
		resourceDirectoryTableHeaderIdEntries[#resourceDirectoryTableHeaderIdEntries + 1] = entry
	end

	if #resourceDirectoryTableHeaderIdEntries ~= 0 then
		section.Start( "Resource Directory Table ID Entries" )
		--- @param entry IMAGE_RESOURCE_DIRECTORY_ID_ENTRY
		for index, entry in ipairs( resourceDirectoryTableHeaderIdEntries ) do
			local idName = table.KeyFromValue( resourceTypeEnum, entry.ID ) or "UNKNOWN"
			section.Print( index, ". ", idName, " (", entry.ID, ") at offset ", ( entry.DataEntryOffset or entry.ChildDirectoryOffset ) )
		end
		section.End()
	end

	local isSubDirMask = bit.lshift( 1, 31 )

	-- Read each ID type's entries
	--- @param idTypeEntry IMAGE_RESOURCE_DIRECTORY_ID_ENTRY
	for _, idTypeEntry in ipairs( resourceDirectoryTableHeaderIdEntries ) do
		local idName = table.KeyFromValue( resourceTypeEnum, idTypeEntry.ID ) or "UNKNOWN"
		section.Start( idName )

		local idEntriesGroupHeader
		idEntriesGroupHeader, resourceSectionBytes = deserializeLib.ReadComplexDataType( "IMAGE_RESOURCE_DIRECTORY", resourceSectionBytes )

		for _ = 1, idEntriesGroupHeader.NumberOfIdEntries do
			local entry
			entry, resourceSectionBytes = deserializeLib.ReadComplexDataType( "IMAGE_RESOURCE_DIRECTORY_ID_ENTRY", resourceSectionBytes )

			local isChildDirectory = ( entry.ChildDirectoryOffset ~= nil )

			if isChildDirectory then
				local childDirectoryBaseAddress = resourceBaseAddress + entry.ChildDirectoryOffset - 1

				section.Print( "(DIR)  ", entry.ID, ". ", Hex( childDirectoryBaseAddress ) )
			else
				local dataEntryBaseAddress = resourceBaseAddress + entry.DataEntryOffset - 1

				section.Print( "(LEAF) ", entry.ID, ". ", Hex( dataEntryBaseAddress ) )
			end
		end

		section.End()
	end
end

hook.Add( "Renegade_PostGameInit", "A1_Renegade_ResourceLoader_Test", LIB.RunTest )
if isHotload then
	LIB.StaticConstructor()
	LIB.RunTest()
end