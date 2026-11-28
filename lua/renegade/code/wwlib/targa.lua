-- Based on Targa within Code/wwlib/TARGA.H

--- @class Renegade
local CNC = CNC_RENEGADE


--- @class TargaClass
--- @field Instance TargaInstance The metatable used by TargaInstance
local STATIC = CNC.CreateExport()
local isHotload = not table.IsEmpty( STATIC )
STATIC.Class = "TargaClass"

--- @class TargaInstance
--- @field Static TargaClass The static table for this instance's class
local INSTANCE = robustclass.Register( "Renegade_Targa" )
INSTANCE.Class = "TargaInstance"
STATIC.Instance = INSTANCE
INSTANCE.Static = STATIC
INSTANCE.IsTarga = true

--#region Exported Enums
	--- @type EnumBuilderClass
	local enumBuilderClass = CNC.Import( "sh_enum-builder.lua" )
	local enumBuilder = enumBuilderClass.New()

	--- @enum TgaImageType
	STATIC.TGA_IMAGE_TYPE = {
        TGA_NOIMAGE           = 0,  -- "No image data included in file"
        TGA_CMAPPED           = 1,  -- "Color-mapped image data"
        TGA_TRUECOLOR         = 2,  -- "Truecolor image data"
        TGA_MONO              = 3,  -- "Monochrome image data"
        TGA_CMAPPED_ENCODED   = 9,  -- "Color-mapped image data (Encoded)"
        TGA_TRUECOLOR_ENCODED = 10, -- "Truecolor image data (Encoded)"
        TGA_MONO_ENCODED      = 11, -- "Monochrome image data (Encoded)"
	}
    local tgaImageTypeEnum = STATIC.TGA_IMAGE_TYPE

    --- @enum TgaImageDescriptor
	STATIC.TGA_IMAGE_DESCRIPTOR = {
        TGAIDF_ATTRIB_BITS = bit.lshift( 0x0F, 0 ), -- "Number of attribute bits per pixel"
        TGAIDF_XORIGIN     = bit.lshift( 1,    4 ),
        TGAIDF_YORIGIN     = bit.lshift( 1,    5 ),
	}
    local tgaImageDescriptorEnum = STATIC.TGA_IMAGE_DESCRIPTOR

    --- @enum TgaAccessMode
	STATIC.TGA_ACCESS_MODE = {
        TGA_READMODE  = 0,
        TGA_WRITEMODE = 1,
        TGA_RDWRMODE  = 2,
	}
    local tgaAccessModeEnum = STATIC.TGA_ACCESS_MODE

    --- @enum TgaErrorCode
	STATIC.TGA_ERROR_CODE = {
        TGAERR_OPEN         = -1,
        TGAERR_READ         = -2,
        TGAERR_WRITE        = -3,
        TGAERR_SYNTAX       = -4,
        TGAERR_NOMEM        = -5,
        TGAERR_NOTSUPPORTED = -6,
	}
    local tgaErrorCodeEnum = STATIC.TGA_ERROR_CODE

    --- @enum TgaFlag
	STATIC.TGA_FLAG = {
        TGAF_IMAGE    = bit.lshift( 1, 0 ),
        TGAF_PAL      = bit.lshift( 1, 1 ),
        TGAF_COMPRESS = bit.lshift( 1, 2 ),
        TGAF_TGA2     = bit.lshift( 1, 3 ),
	}
    local tgaFlagEnum = STATIC.TGA_FLAG

    --- "Alpha channel attributes (Extension Area)"
    --- @enum TgaExtensionArea
	STATIC.TGA_EXTENSION_AREA = {
        EXTA_NOALPHA = 0, -- "No alpha data included"
        EXTA_IGNORE  = 1, -- "Undefined alpha data, can ignore"
        EXTA_RETAIN  = 2, -- "Undefined alpha data, should retain"
        EXTA_USEFUL  = 3, -- "Useful alpha channel"
        EXTA_PREMULT = 4, -- "Pre-Multiplied alpha data"
	}
    local tgaExtensionArea = STATIC.TGA_EXTENSION_AREA

--#endregion

--#region Imports

	--- @type DeserializeLib
	local deserializeLib = CNC.Import( "sh_deserialize.lua" )

	--- @type FileClass
	local fileClass = CNC.Import( "code/wwlib/file.lua" )

	--- @type FileFactoryClass
	local fileFactoryClass = CNC.Import( "code/wwlib/file-factory.lua" )
--#endregion

--#region Imported Enums

	local fundamentalDataTypeEnum = deserializeLib.FUNDAMENTAL_DATA_TYPE
	local seekDirectionEnum = fileClass.SEEK_DIRECTION
	local fileRightsEnum = fileClass.FILE_RIGHTS
--#endregion


--[[ Static Functions and Variables ]] do

    --- @class TargaClass

    STATIC.TGA2_SIGNATURE = "TRUEVISION-XFILE"

    --- Creates a new TargaInstance
    --- @return TargaInstance
    function STATIC.New()
        return robustclass.New( "Renegade_Targa" )
    end

    --- @param arg any
    --- @return boolean `true` if the passed argument is a(n) TargaInstance, `false` otherwise
    function STATIC.IsTarga( arg )
        if not istable( arg ) then return false end
        if getmetatable( arg ) ~= INSTANCE then return false end

        return arg.IsTarga and true or false
    end

    typecheck.RegisterType( "TargaInstance", STATIC.IsTarga )

    function STATIC.StaticConstructor()

        --- "Numerator and denominator which when taken together specify a ratio."
        --- @class Tga2Ratio
        --- @field Numer integer "Numerator"
        --- @field Denom string  "Denominator (a value of zero indicates no ratio specified)"
        deserializeLib.RegisterComplexDataType( "Tga2Ratio", {
            { Name = "Numer", DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Denom", DataType = fundamentalDataTypeEnum.String, Length = 1 },
        } )

        --- "Define the version of the software used to generate file."
        --- @class Tga2SoftVer
        --- @field Number integer "Version number * 100"
        --- @field Letter string  "Version letter"
        deserializeLib.RegisterComplexDataType( "Tga2SoftVer", {
            { Name = "Number", DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Letter", DataType = fundamentalDataTypeEnum.String, Length = 1 },
        } )

        --- "A series of 3 WORD values which define the integer value for the time the image was saved."
        --- @class Tga2TimeStamp
        --- @field Hour   integer "Hour number, military time (0 - 23)"
        --- @field Minute integer "Minute number (0 - 59)"
        --- @field Second integer "Second number (0 - 59)"
        deserializeLib.RegisterComplexDataType( "Tga2TimeStamp", {
            { Name = "Hour",   DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Minute", DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Second", DataType = fundamentalDataTypeEnum.UInt16 },
        } )

        --- "A series of 3 WORD values which define the integer value for the date the image was saved."
        --- @class Tga2DateStamp
        --- @field Month integer "Month number (1 - 12)"
        --- @field Day   integer "Day number (1 - 31)"
        --- @field Year  integer "Year number (4 digit, ie. 1989)"
        deserializeLib.RegisterComplexDataType( "Tga2DateStamp", {
            { Name = "Month", DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Day",   DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Year",  DataType = fundamentalDataTypeEnum.UInt16 },
        } )

        --- "Targa Image File header."
        --- @class TgaHeader
        --- @field IdLength        integer "Size of Image ID field"
        --- @field ColorMapType    integer "Color map type."
        --- @field ImageType       integer "Image type code."
        --- @field ColorMapStart   integer "Color map origin."
        --- @field ColorMapLength  integer "Color map length."
        --- @field ColorMapDepth   integer "Depth of color map entries."
        --- @field XOffset         integer "X origin of image."
        --- @field YOffset         integer "Y origin of image."
        --- @field Width           integer "Width of image."
        --- @field Height          integer "Height of image."
        --- @field PixelDepth      integer "Image pixel size"
        --- @field ImageDescriptor integer "Image descriptor byte."
        deserializeLib.RegisterComplexDataType( "TgaHeader", {
            { Name = "IdLength",        DataType = fundamentalDataTypeEnum.UInt8  },
            { Name = "ColorMapType",    DataType = fundamentalDataTypeEnum.UInt8  },
            { Name = "ImageType",       DataType = fundamentalDataTypeEnum.UInt8  },
            { Name = "ColorMapStart",   DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "ColorMapLength",  DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "ColorMapDepth",   DataType = fundamentalDataTypeEnum.UInt8  },
            { Name = "XOffset",         DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "YOffset",         DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Width",           DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "Height",          DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "PixelDepth",      DataType = fundamentalDataTypeEnum.UInt8  },
            { Name = "ImageDescriptor", DataType = fundamentalDataTypeEnum.UInt8  },
        } )


        --- "
        --- Extension area, provided for additional file information.  
        --- This data is pointed to by the Extension offset in the TGA2Footer.
        --- "
        --- @class Tga2Extension
        --- @field ExtSize     integer       "Extension area size. (495 bytes for 2.0)"
        --- @field AuthName    string        "Name of the person who created image (NULL terminated ASCII)"
        --- @field AuthComment string        "Comments of the author (NULL terminated ASCII)"
        --- @field DateStamp   Tga2DateStamp "Date the file was created. (See TGA2DateStamp)"
        --- @field TimeStamp   Tga2TimeStamp "Time the file was created. (See TGA2TimeStamp)"
        --- @field JobName     string        "Name of job image belongs to (NULL terminated ASCII)"
        --- @field JobTime     Tga2TimeStamp "Elapsed time of the job."
        --- @field SoftId      string        "ID of software used to create image (NULL terminated ASCII)"
        --- @field SoftVer     Tga2SoftVer   "Version number of software used."
        --- @field KeyColor    integer       "Tranparent color value."
        --- @field Aspect      Tga2Ratio     "Pixel aspect ratio."
        --- @field Gamma       Tga2Ratio     "Fractional gamma value."
        --- @field ColorCor    integer       "Color correction table offset."
        --- @field PostStamp   integer       "Postage stamp image offset."
        --- @field ScanLine    integer       "Scan line table offset."
        --- @field Attributes  integer       "Alpha channel attributes. (Set defines below)"
        deserializeLib.RegisterComplexDataType( "Tga2Extension", {
            { Name = "ExtSize",     DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "AuthName",    DataType = fundamentalDataTypeEnum.String, Length = 41 },
            { Name = "AuthComment", DataType = fundamentalDataTypeEnum.UInt16, Length = 324 },
            { Name = "Date",        DataType = "Tga2DateStamp" },
            { Name = "Time",        DataType = "Tga2TimeStamp" },
            { Name = "JobName",     DataType = fundamentalDataTypeEnum.UInt16 },
            { Name = "JobTime",     DataType = "Tga2TimeStamp" },
            { Name = "SoftId",      DataType = fundamentalDataTypeEnum.String, Length = 41 },
            { Name = "SoftVer",     DataType = "Tga2SoftVer" },
            { Name = "KeyColor",    DataType = fundamentalDataTypeEnum.Long },
            { Name = "Aspect",      DataType = "Tga2Ratio" },
            { Name = "Gamma",       DataType = "Tga2Ratio" },
            { Name = "ColorCor",    DataType = fundamentalDataTypeEnum.Long },
            { Name = "PostStamp",   DataType = fundamentalDataTypeEnum.Long },
            { Name = "ScanLine",    DataType = fundamentalDataTypeEnum.Long },
            { Name = "Attributes",  DataType = fundamentalDataTypeEnum.UInt8 },
        } )

        --- "Targa 2.0 footer"
        --- @class Tga2Footer
        --- @field Extension integer   "Offset to the Extension area from start of file."
        --- @field Developer integer   "Offset to the Developer area from start of file."
        --- @field Signature integer[] "16 byte Targa 2.0 signature "TRUEVISION-XFILE""
        --- @field RsvdChar  integer   "Reserved character, must be ASCII "." (period)"
        --- @field Bzst      integer   "Binary Zero String Terminator."
        deserializeLib.RegisterComplexDataType( "Tga2Footer", {
            { Name = "Extension", DataType = fundamentalDataTypeEnum.Long },
            { Name = "Developer", DataType = fundamentalDataTypeEnum.Long },
            { Name = "Signature", DataType = fundamentalDataTypeEnum.String, Length = 16 },
            { Name = "RsvdChar",  DataType = fundamentalDataTypeEnum.UInt8 },
            { Name = "Bzst",      DataType = fundamentalDataTypeEnum.UInt8 },
        } )
    end
end

--- @param a integer
--- @return integer
local function TgaBytesPerPixel( a )
    return bit.rshift( a + 7, 3 )
end

--- @class TargaInstance
--- @field Header TgaHeader
--- @field TgaFile FileInstance
--- @field Access integer
--- @field Flags integer
--- @field Image string
--- @field Palette string
--- @field Extension Tga2Extension

--- "Initialize a Targa instance."
function INSTANCE:Renegade_Targa()
    self.Image = nil
    self.Palette = nil
    self:ClearFile()
    self.Access = tgaAccessModeEnum.TGA_READMODE
    self.Flags = 0
    self.Header = nil
    self.Extension = nil
end

--- "Targa class destructor."
function INSTANCE:_Renegade_Targa()
    -- "Close the file if has been left open."
    self:Close()

    -- "Free the palette buffer if we allocated it."
    if self.Palette ~= nil and tobool( bit.band( self.Flags, tgaFlagEnum.TGAF_PAL ) ) then
        self.Palette = nil
    end

    -- "Free the image buffer if we allocated it."
    if self.Image ~= nil and tobool( bit.band( self.Flags, tgaFlagEnum.TGAF_IMAGE ) ) then
        self.Image = nil
    end
end

--- "
--- Open a Targa image file and read in its header.  
--- The file stream will positioned after the ID field (if there is one).
--- "
--- @param name string "Pointer to name the Targa file."
--- @param mode integer "Access mode."
--- @return TgaErrorCode|0 error "Error code, 0 if okay."
function INSTANCE:Open( name, mode )
    local footer

    --- @type TgaErrorCode|0
    local err = 0

    -- "File already open?"
    if self:IsFileOpen() and self.Access == mode then
        return 0
    end

    self:Close()

    -- "Initialize the access mode."
    self.Access = mode
    self.Flags = bit.band( self.Flags, bit.bnot( tgaFlagEnum.TGAF_TGA2 ) )

    -- "Open targa file for read."
    if mode == tgaAccessModeEnum.TGA_READMODE then
        if self:FileOpenRead( name ) then

            -- "Check for 2.0 targa file by loading the footer"
            if self:FileSeek( -26, seekDirectionEnum.SEEK_END ) == -1 then
                err = tgaErrorCodeEnum.TGAERR_READ
            end

            if not tobool( err ) then
                local footerSize = deserializeLib.GetComplexDataTypeSize( "Tga2Footer" )
                local readBytes, readByteCount = self:FileRead( footerSize )
                footer = deserializeLib.DeserializeComplexDataType( "Tga2Footer", readBytes )
                assert( footer ~= nil )

                if footerSize ~= readByteCount then
                    err = tgaErrorCodeEnum.TGAERR_READ
                else
                    -- "If this is a 2.0 file with an extension?"
                    if footer.Signature == STATIC.TGA2_SIGNATURE then
                        if footer.Extension ~= 0 then
                            self.Flags = bit.bor( self.Flags, tgaFlagEnum.TGAF_TGA2 )
                        end
                    end
                end
            end

            -- "Read in Extension data"
            if not tobool( err ) and tobool( bit.band( self.Flags, tgaFlagEnum.TGAF_TGA2 ) ) then
                if self:FileSeek( footer.Extension, seekDirectionEnum.SEEK_SET ) == -1 then
                    err = tgaErrorCodeEnum.TGAERR_READ
                end

                if not tobool( err ) then
                    local extensionSize = deserializeLib.GetComplexDataTypeSize( "Tga2Extension" )
                    local readBytes, readByteCount = self:FileRead( extensionSize )
                    local extension = deserializeLib.DeserializeComplexDataType( "Tga2Extension", readBytes )
                    assert( extension ~= nil )
                    self.Extension = extension

                    if readByteCount ~= extensionSize then
                        err = tgaErrorCodeEnum.TGAERR_READ
                    end
                end
            end

            -- "Read in header."
            if not tobool( err ) and ( self:FileSeek( 0, seekDirectionEnum.SEEK_SET ) == -1 ) then
                err = tgaErrorCodeEnum.TGAERR_READ
            else
                local headerSize = deserializeLib.GetComplexDataTypeSize( "TgaHeader" )
                local readBytes, readByteCount = self:FileRead( headerSize )
                local header = deserializeLib.DeserializeComplexDataType( "TgaHeader", readBytes )
                assert( header ~= nil )
                self.Header = header

                if readByteCount ~= headerSize then
                    err = tgaErrorCodeEnum.TGAERR_READ
                end
            end

            -- "Skip the ID field"
            if not tobool( err ) and self.Header.IdLength ~= 0 then
                if self:FileSeek( self.Header.IdLength, seekDirectionEnum.SEEK_CUR ) == -1 then
                    err = tgaErrorCodeEnum.TGAERR_READ
                end
            end
        else
            err = tgaErrorCodeEnum.TGAERR_OPEN
        end

    -- "Open targa file for write."
    elseif mode == tgaAccessModeEnum.TGA_WRITEMODE then
        if not self:FileOpenWrite( name ) then
            err = tgaErrorCodeEnum.TGAERR_OPEN
        end

    -- "Open targa file for read/write."
    elseif mode == tgaAccessModeEnum.TGA_RDWRMODE then
        typecheck.NotImplementedError()
    end

    -- "Close on any error!"
    if tobool( err ) then
        self:Close()
    end

    return err
end

--- "Close the Targa image file and free its handle."
function INSTANCE:Close()
    if self.TgaFile then
        self.TgaFile:Close()
        fileFactoryClass.TheFileFactory:ReturnFile( self.TgaFile )
        self.TgaFile = nil
    end
end

--- @overload fun( name: string, palette: string, image: string, invertImage: boolean? ): integer
--- @overload fun( name: string, flags: integer, invertImage: boolean? ): integer
function INSTANCE:Load( ... )
    local args = { ... }

    typecheck.NotImplementedError()
end

--- "Save a Targa Image File."
--- @param name string "Pointer to name of file to save."
--- @param flags integer
--- @param addExtension boolean
--- @return TgaErrorCode|0 error "`0` if successful, or TGAERR_??? error code."
function INSTANCE:Save()
    typecheck.NotImplementedError()
end

--- "Flip the image in memory on its X axis. (left to right)"
function INSTANCE:XFlip()
    typecheck.NotImplementedError()
end

--- "Flip the image in memory on its Y axis. (top to bottom)"
function INSTANCE:YFlip()
    typecheck.NotImplementedError()
end

--- "Set the image buffer to one provided by the caller."
--- @param buffer string Pointer to buffer to use for the image buffer.
--- @return string oldImage Previous caller assigned image buffer.
function INSTANCE:SetImage( buffer )
    local oldBuffer

    -- "Free any image buffer before assigning another."
    if ( self.Image ~= nil ) and tobool( bit.band( self.Flags, tgaFlagEnum.TGAF_IMAGE ) ) then
        self.Image = nil
        self.Flags = bit.band( self.Flags, bit.bnot( tgaFlagEnum.TGAF_IMAGE ) )
    end

    -- "Get the old user buffer."
    if self.Image ~= nil then
        oldBuffer = self.Image
    end

    -- "Assign the new image buffer."
    self.Image = buffer

    return oldBuffer
end

--- @return string
function INSTANCE:GetImage()
    return self.Image
end

--- "Set the palette buffer."
--- @param buffer string "Pointer to buffer to use for palette."
--- @return string oldPal "Pointer to previous user palette."
function INSTANCE:SetPalette( buffer )
    local oldBuffer

    -- "Free any image buffer before assigning another."
    if self.Palette ~= nil and tobool( bit.band( self.Flags, tgaFlagEnum.TGAF_PAL ) ) then
        self.Palette = nil
        self.Flags = bit.band( self.Flags, bit.bnot( tgaFlagEnum.TGAF_PAL ) )
    end

    -- "Get the old user buffer."
    if self.Palette ~= nil then
        oldBuffer = self.Palette
    end

    -- "Assign the new image buffer."
    self.Palette = buffer

    return oldBuffer
end

--- @return string
function INSTANCE:GetPalette()
    return self.Palette
end

--- @return boolean
function INSTANCE:IsCompressed()
    if self.Header.ImageType > 8 then
        return true
    end

    return false
end

--- "  
--- Get Extension data. (Targa 2.0 files only)  
--- 
--- Retrieve a pointer to the Targa 2.0 extension data area.  
--- If the file version is 1.0 OR there is no extensio area then a NULL will be returned.  
--- "  
--- @return Tga2Extension? # Pointer to Extension data, `nil` if not available.
function INSTANCE:GetExtension()
    if tobool( bit.band( self.Flags, tgaFlagEnum.TGAF_TGA2 ) ) then
        return self.Extension
    end

    return nil
end

function INSTANCE:DecodeImage()
    typecheck.NotImplementedError()
end

--- "Encode the image data using the RLE algorithm outlined in the TARGA file specification."
function INSTANCE:EncodeImage()
    typecheck.NotImplementedError()
end

--- "Invert TrueColor image data."
function INSTANCE:InvertImage()
    typecheck.NotImplementedError()
end

function INSTANCE:ClearFile()
    self.TgaFile = nil
end

--- @return boolean
function INSTANCE:IsFileOpen()
    return self.TgaFile ~= nil
end

--- @param name string
--- @return boolean
function INSTANCE:FileOpenRead( name )
    self.TgaFile = fileFactoryClass.TheFileFactory:GetFile( name )
    if self.TgaFile and self.TgaFile:IsAvailable() then
        return ( self.TgaFile:Open( fileRightsEnum.READ ) ~= false )
    else
        return false
    end
end

--- @param name string
--- @return boolean
function INSTANCE:FileOpenWrite( name )
    self.TgaFile = fileFactoryClass.TheWritingFileFactory:GetFile( name )
    if self.TgaFile then
        return ( self.TgaFile:Open( fileRightsEnum.WRITE ) ~= false )
    else
        return false
    end
end

--- @param name string
--- @return boolean
function INSTANCE:FileOpenReadWrite( name )
    self.TgaFile = fileFactoryClass.TheWritingFileFactory:GetFile( name )
    if self.TgaFile and self.TgaFile:IsAvailable() then
        return ( self.TgaFile:Open( bit.bor( fileRightsEnum.READ, fileRightsEnum.WRITE ) ) ~= false )
    else
        return false
    end
end

--- @param position integer
--- @param direction SeekDirection
--- @return integer
function INSTANCE:FileSeek( position, direction )
    return self.TgaFile:Seek( position, direction )
end

--- @param size integer
--- @return string buffer
--- @return integer actualSize
function INSTANCE:FileRead( size )
    return self.TgaFile:Read( size )
end

--- @param buffer string
--- @param size integer
--- @return integer
function INSTANCE:FileWrite( buffer, size )
    return self.TgaFile:Write( buffer, size )
end
