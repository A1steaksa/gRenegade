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
--- @field SectionHeaders SectionHeader[]
--- @field FileBytes string

function LIB.StaticConstructor()

	--- @class SectionHeader
	--- @field Reserved integer
	--- @field VirtualSize integer
	--- @field VirtualAddress integer
	--- @field RawDataSize integer
	--- @field RawDataPointer integer
	deserializeLib.RegisterComplexDataType( "SectionHeader", {
		{ Name = "Reserved", 		DataType = fundamentalDataTypeEnum.UInt8, 	ArrayLength = 3 },
		{ Name = "VirtualSize", 		DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "VirtualAddress",	DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "RawDataSize",		DataType = fundamentalDataTypeEnum.UInt32 },
		{ Name = "RawDataPointer",	DataType = fundamentalDataTypeEnum.UInt32 },
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
		{ Name = "NumberOfNameEntries", DataType = fundamentalDataTypeEnum.UInt16 },
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

--- @type ResourceTree
LIB.ResourceTree = {}

function LIB.RunTest()
	LIB.ParseExecutableResources( "data/renegade/game.exe.txt" )
end


--- @param filePath string
--- @return ResourceTree
function LIB.ParseExecutableResources( filePath )
	typecheck.AssertArgType( LIB.Class, 1, filePath, "string" )

	-- Read the executable into memory
	LIB.FileBytes = file.Read( filePath, "THIRDPARTY" )
	if LIB.FileBytes == nil then
		section.Error( "Unable to read executable for resource parsing: '", filePath, "'" )
	end

	local sectionHeaderSize = deserializeLib.GetComplexDataTypeSize( "SectionHeader" )

	-- Find and parse the resources section header
	local resourceSectionHeaderStartIndex = textUtils.IndexOf( LIB.FileBytes, ".rsrc" ) + #".rsrc"
	local resourceSectionHeaderBytes = LIB.FileBytes:sub(
		resourceSectionHeaderStartIndex,
		resourceSectionHeaderStartIndex + sectionHeaderSize
	)
	local resourceSectionHeader = deserializeLib.ReadComplexDataType( "SectionHeader", resourceSectionHeaderBytes )

	-- Find and parse the data section header
	local dataSectionHeaderStartIndex = textUtils.IndexOf( LIB.FileBytes, ".tls" ) + #".tls"
	local dataSectionHeaderBytes = LIB.FileBytes:sub(
		dataSectionHeaderStartIndex,
		dataSectionHeaderStartIndex + sectionHeaderSize
	)
	local dataSectionHeader = deserializeLib.ReadComplexDataType( "SectionHeader", dataSectionHeaderBytes )

	local resourceTreeBaseAddress = resourceSectionHeader.RawDataPointer + 1
	local dataBaseAddress = dataSectionHeader.RawDataPointer + 1

	-- Read the root node of the resources tree
	-- These IDs should correspond to ResourceType enums
	local resourceTreeRoot = LIB.ReadResourceDirectory( resourceTreeBaseAddress, resourceSectionHeader.VirtualAddress + 1, dataBaseAddress, resourceTreeBaseAddress )

	-- section.Print( "Results:" )
	-- PrintTable( resourceTreeRoot )

	return LIB.ResourceTree
end

--- @param resourcesBaseAddress integer
--- @param dataBaseAddress integer
--- @param dataVirtualAddress integer
--- @param directoryAddress integer
--- @return IMAGE_RESOURCE_DIRECTORY_CONTENT
function LIB.ReadResourceDirectory( resourcesBaseAddress, dataBaseAddress, dataVirtualAddress, directoryAddress )

	section.Start( "Reading directory at ", Hex( directoryAddress ) )

	-- Read the directory's header
	local directoryHeaderSize = deserializeLib.GetComplexDataTypeSize( "IMAGE_RESOURCE_DIRECTORY" )
	local directoryHeaderBytes = LIB.FileBytes:sub( directoryAddress, directoryAddress + directoryHeaderSize )

	local directoryHeader = deserializeLib.DeserializeComplexDataType( "IMAGE_RESOURCE_DIRECTORY", directoryHeaderBytes )
	assert( directoryHeader ~= nil )

	-- Grab the directory's bytes
	local nameDirectoryEntrySize = deserializeLib.GetComplexDataTypeSize( "IMAGE_RESOURCE_DIRECTORY_NAME_ENTRY" )
	local idDirectoryEntrySize = deserializeLib.GetComplexDataTypeSize( "IMAGE_RESOURCE_DIRECTORY_ID_ENTRY" )
	local totalDirectoryContentSize = (
		( nameDirectoryEntrySize * directoryHeader.NumberOfNameEntries )
		+ ( idDirectoryEntrySize * directoryHeader.NumberOfIdEntries )
	)
	local directoryContentBytes = LIB.FileBytes:sub(
		directoryAddress + directoryHeaderSize,
		directoryAddress + directoryHeaderSize + totalDirectoryContentSize
	)

	-- Read the directory's name entries
	local nameDirectoryContents = {}
	for _ = 1, directoryHeader.NumberOfNameEntries do
		local entry
		entry, directoryContentBytes = deserializeLib.ReadComplexDataType( "IMAGE_RESOURCE_DIRECTORY_NAME_ENTRY", directoryContentBytes )
		nameDirectoryContents[#nameDirectoryContents + 1] = entry
	end

	-- Read the directory's ID entries
	local idDirectoryContents = {}
	for _ = 1, directoryHeader.NumberOfIdEntries do
		local entry
		entry, directoryContentBytes = deserializeLib.ReadComplexDataType( "IMAGE_RESOURCE_DIRECTORY_ID_ENTRY", directoryContentBytes )

		local isChildDirectory = ( entry.ChildDirectoryOffset ~= nil )
		if isChildDirectory then
			section.Print( "Child Directory ID ", entry.ID )

			local childDirectoryContents = LIB.ReadResourceDirectory( resourcesBaseAddress, dataBaseAddress, dataVirtualAddress, resourcesBaseAddress + entry.ChildDirectoryOffset )

			idDirectoryContents[entry.ID] = childDirectoryContents
		else

			local dataEntrySize = deserializeLib.GetComplexDataTypeSize( "IMAGE_RESOURCE_DATA_ENTRY" )
			local dataEntryBytes = LIB.FileBytes:sub(
				resourcesBaseAddress + entry.DataEntryOffset,
				resourcesBaseAddress + entry.DataEntryOffset + dataEntrySize
			)
			local dataEntry = deserializeLib.DeserializeComplexDataType( "IMAGE_RESOURCE_DATA_ENTRY", dataEntryBytes )
			assert( dataEntry ~= nil )

			section.Print( "Leaf ", "Offset to Data: ", Hex( dataEntry.OffsetToData ), ", Size: ", dataEntry.Size, ", CodePage: ", dataEntry.CodePage, ", Reserved: ", dataEntry.Reserved )

			local dataAddress = dataBaseAddress + ( dataEntry.OffsetToData - dataVirtualAddress )

			local correctAddress = 0x41F828

			section.Print( "Section Base Address: ", Hex( dataBaseAddress ), ", Section Virtual Address: ", Hex( dataVirtualAddress ) )
			section.Print( "Correct: ", correctAddress, ", ", Hex( correctAddress ) )
			section.Print( "Ours:    ", dataAddress, ", ", Hex( dataAddress ) )
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

	local resourceSectionHeader = deserializeLib.ReadComplexDataType( "SectionHeader", fileContents:sub( resourceSectionStartIndex ) )
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