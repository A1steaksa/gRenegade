-- Based on RamFileClass within Code/wwlib/ramfile.h

--- @class Renegade
local CNC = CNC_RENEGADE

--- @type FileClass
local fileClass = CNC.Import( "code/wwlib/file.lua" )

--- @class RamFileClass : FileClass
--- @field Instance RamFileInstance The metatable used by RamFileInstance
local STATIC = CNC.CreateExport( fileClass )
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "RamFileClass"

--- @class RamFileInstance : FileInstance
--- @field Static RamFileClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_RamFile : Renegade_File" )
INSTANCE.Class = "RamFileInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsRamFile = true

--#region Exported Enums
--#endregion

--#region Imports

	--- @type FileClass
	local fileClass = CNC.Import( "code/wwlib/file.lua" )
--#endregion

--#region Imported Enums

	local fileRightsEnum = fileClass.FILE_RIGHTS
	local seekDirectionEnum = fileClass.SEEK_DIRECTION
--#endregion

--[[ Static Functions and Variables ]] do

    --- @class RamFileClass

    --- Creates a new RamFileInstance
	--- @param buffer string
	--- @param length integer
    --- @return RamFileInstance
    function STATIC.New( buffer, length )
        return robustclass.New( "Renegade_RamFile" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) RamFileInstance, `false` otherwise
    function STATIC.IsRamFile( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsRamFile and true or false
    end

    typecheck.RegisterType( "RamFileInstance", STATIC.IsRamFile )
end


--- @class RamFileInstance
--- @field Buffer string "Pointer to the buffer that the "file" will reside in."
--- @field MaxLength integer "The maximum size of the buffer. The file occupying the buffer may be smaller than this size."
--- @field Length integer "The number of bytes in the sub-file occupying the buffer."
--- @field Offset integer "The current file position offset within the buffer."
--- @field Access integer "The file was opened with this access mode."
--- @field _IsOpen boolean "Is the file currently open?"
--- @field IsAllocated boolean "Was the file buffer allocated during construction of this object?"

--- "  
--- Construct a RAM buffer based "file" object.
--- 
--- This routine will construct a "file" object that actually is just a front end processor for a buffer.
--- Access to the buffer will appear as if it was accessing a file.
--- This is different from the caching ability of the buffered file class in that this file class has no real file counterpart.
--- Typical use of this is for algorithms that were originally designed for file processing, but are now desired to work with a buffer.  
--- "  
--- @param buffer string "Pointer to the buffer to use for this file. The buffer will already contain data if the file is opened for READ. It will be considered a scratch buffer if opened for WRITE. If the buffer pointer is NULL but the length parameter is not, then a buffer will be allocated of the specified length. This case is only useful for opening the file for WRITE
--- @param length integer "The length of the buffer submitted to this routine."
function INSTANCE:Renegade_RamFile( buffer, length )
	fileClass.Instance.Renegade_File( self )

	self.Buffer = buffer
	self.MaxLength = length
	self.Offset = 0
	self.Access = fileRightsEnum.READ
	self._IsOpen = false
	self.IsAllocated = false

	if buffer == nil and length > 0 then
		self.Buffer = ""
		self.IsAllocated = true
	end
end

--- "  
--- Destructor for the RAM file class.  
--- 
--- The destructor will deallocate any buffer that it allocated.  Otherwise it does nothing.  
--- "  
function INSTANCE:_Renegade_RamFile()
	self:Close()

	if self.IsAllocated then
		self.Buffer = nil
		self.IsAllocated = false
	end
end

--- @return string
function INSTANCE:FileName()
	return "UNKNOWN"
end

--- @param name string
function INSTANCE:SetName( name )
	return self:FileName()
end

--- "  
--- Effectively clears the buffer of data.  
---
--- This routine 'clears' the buffer of data.
--- It only makes the buffer appear empty by resetting the internal length to zero.
---
--- If the file was open, then resetting by this routine is not allowed.  
--- "  
--- @return boolean # "Was the file reset in this fashion?"
function INSTANCE:Create()
	if not self:IsOpen() then
		self.Length = 0

		return true
	end

	return false
end

--- "  
--- Effectively clears the buffer of data.  
---
--- This routine 'clears' the buffer of data.
--- It only makes the buffer appear empty by resetting the internal length to zero.
---
--- If the file was open, then resetting by this routine is not allowed.  
--- "  
--- @return boolean # "Was the file reset in this fashion?"
function INSTANCE:Delete()
	if not self:IsOpen() then
		self.Length = 0

		return true
	end

	return false
end

--- "
--- Determines if the "file" is available.  
--- 
--- RAM files are always available.
--- "
--- @param forced boolean? [Default: `false`]
--- @return boolean
function INSTANCE:IsAvailable( forced )
	return true
end

--- "Is the file open?"
--- @return boolean
function INSTANCE:IsOpen()
	return self._IsOpen
end

--- "  
--- Opens a RAM based file for read or write.  
---
--- This routine will open the ram file. The name is meaningless so that parameter is ignored.
--- If the access mode is for write, then the pseudo-file can be written until the buffer is full.
--- If the file is opened for read, then the buffer is presumed to be full of the data to be read.  
--- "
--- @overload fun( self: RamFileInstance, fileName: string, rights: FileRights? ): boolean
--- @overload fun( self: RamFileInstance, rights: FileRights? ): boolean
function INSTANCE:Open( ... )
	local args = { ... }
	local argCount = select( "#", args )

	local access

	-- ( access: FileRights? [Default: `READ`] ): boolean
	if argCount == 0 then
		access = fileRightsEnum.READ
	end

	if argCount == 1 then
		typecheck.AssertArgType( INSTANCE.Class, 1, args[1], { "string", "number" } )

		-- ( name: string, access: FileRights? [Default: `READ`] ): boolean
		if typecheck.IsOfType( args[1], "string" ) then
			access = fileRightsEnum.READ

		-- ( access: FileRights? [Default: `READ`] ): boolean
		else
			access = args[1] --[[@as FileRights]]
		end

		access = args[1] --[[@as FileRights]]
	end

	-- ( name: string, access: FileRights? [Default: `READ`] ): boolean
	if argCount == 2 then
		access = args[2] --[[@as FileRights]]
	end

	if self.Buffer == nil or self:IsOpen() then
		return false
	end

	self.Offset = 0
	self.Access = access
	self._IsOpen = true

	if access == fileRightsEnum.WRITE then
		self.Length = 0
	end

	return self:IsOpen()
end

--- "  
--- Read data from the file.  
--- 
--- Use this routine just like a normal file read. It will copy the bytes from the ram buffer to the destination specified.
--- When the ram buffer is exhausted, less bytes than requested will be read.  
--- 
--- The read function only applies to ram 'files' opened for read access.  
--- "  
--- @param size integer
--- @return string buffer, integer actualSize
function INSTANCE:Read( size )
	if self.Buffer == nil or size == 0 then
		return "", 0
	end

	local hasOpened = false
	if not self:IsOpen() then
		self:Open( fileRightsEnum.READ )
		hasOpened = true
	else
		if bit.band( self.Access, fileRightsEnum.READ ) == 0 then
			return "", 0
		end
	end

	local byteCountToCopy = ( ( size < ( self.Length - self.Offset ) ) and size or ( self.Length - self.Offset ) )
	local readBytes = self.Buffer:sub( self.Offset, byteCountToCopy )
	self.Offset = self.Offset + byteCountToCopy

	if hasOpened then
		self:Close()
	end

	return readBytes, byteCountToCopy
end

--- "  
--- Controls the ram file virtual read position.  
--- This routine will move the read/write position of the ram file to the location specified by the offset and direction parameters.  
--- It functions similarly to the regular file seek method.
--- "
--- @param pos integer "The signed offset from the home position specified by the 'dir' parameter."
--- @param direction SeekDirection "The home position to base the position offset on. This will either be the start of the file, the end of the file, or the current read/write position."
--- @return integer # "Returns with the new file position."
function INSTANCE:Seek( pos, direction )
	if self.Buffer == nil or not self:IsOpen() then
		return self.Offset
	end

	local maxOffset = self.Length
	if bit.band( self.Access, fileRightsEnum.WRITE ) ~= 0 then
		maxOffset = self.MaxLength
	end

	if direction == seekDirectionEnum.SEEK_CUR then
		self.Offset = self.Offset + pos
	elseif direction == seekDirectionEnum.SEEK_SET then
		self.Offset = 0 + pos
	elseif direction == seekDirectionEnum.SEEK_END then
		self.Offset = maxOffset + pos
	end

	if self.Offset < 0 then
		self.Offset = 0
	end

	if self.Offset > maxOffset then
		self.Offset = maxOffset
	end

	if self.Offset > self.Length then
		self.Length = self.Offset
	end

	return self.Offset
end

--- "  
--- Returns with the size of the ram file.  
--- This will return the size of the 'real' data in the ram file.
--- The real data is either the entire buffer, if opened for READ, or just the written data if opened for WRITE.  
--- "  
--- @return integer # "Returns with the number of bytes that the ram file system considers to be valid data of the 'file'."
function INSTANCE:Size()
	return self.Length
end

--- @param buffer string
--- @param size integer
--- @return integer
function INSTANCE:Write( buffer, size )
	typecheck.NotImplementedError()
end

--- "  
--- This will 'close' the ram file.  
--- Closing a ram file actually does nothing but record that it is now closed.  
--- "  
function INSTANCE:Close()
	self._IsOpen = false
end

--- @return integer
function INSTANCE:GetDateTime()
    return 0
end

--- @param dateTime integer
function INSTANCE:SetDateTime( dateTime )
    return true
end

--- @param error integer
--- @param canRetry boolean? [Default: `false`]
--- @param fileName string? [Default: `nil`]
function INSTANCE:Error( error, canRetry, fileName )
	typecheck.NotImplementedError()
end

--- @param start integer
--- @param length integer? [Default: -1]
function INSTANCE:Bias( start, length )
	if length == nil then length = -1 end

	self.Buffer = self.Buffer + start
	self.Length = math.min( self.Length, start + length ) - start
	self.MaxLength = math.min( self.MaxLength, start + length ) - start

	if self:IsOpen() then
		self:Seek( 0, seekDirectionEnum.SEEK_SET )
	end
end

