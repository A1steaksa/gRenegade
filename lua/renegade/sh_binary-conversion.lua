-- From*() functions based on https://github.com/tederis/mta-resources/blob/master/dffframe/bytedata.lua

-- ----------------------------------------------------------------------------
-- Kamil Marciniak <github.com/forkerer> wrote this code. As long as you retain this 
-- notice, you can do whatever you want with this stuff. If we
-- meet someday, and you think this stuff is worth it, you can
-- buy me a beer in return.
-- ----------------------------------------------------------------------------

local math_floor = math.floor
local string_char = string.char
local string_byte = string.byte
local math_log = math.log
local math_abs = math.abs
local math_modf = math.modf
local math_min = math.min
local math_max = math.max
local NAN = 0 / 0

local doubleNaNbig		= string_char(0x7F) .. string_char(0xF8) .. "\0\0\0\0\0\0"
local doubleNaNlittle	= "\0\0\0\0\0\0" .. string_char(0xF8)..string_char(0x7F)
local doublePInfbig		= string_char(0x7F) .. string_char(0xF0) .. "\0\0\0\0\0\0"
local doublePInflittle	= "\0\0\0\0\0\0" .. string_char(0xF0) .. string_char(0x7F)
local doubleNInfbig		= string_char(0xFF) .. string_char(0xF0) .. "\0\0\0\0\0\0"
local doubleNInflittle	= "\0\0\0\0\0\0" .. string_char(0xF0) .. string_char(0xFF)
local doubleZero		= "\0\0\0\0\0\0\0\0"

local floatNaNbig		= string_char(0xFF) .. string_char(0xC0) .. "\0" .. string_char(0x01)
local floatNaNlittle	= string_char(0x01) .. "\0" .. string_char(0xC0) .. string_char(0xFF)
local floatPInfbig		= string_char(0x7F) .. string_char(0x80) .. "\0\0"
local floatPInflittle	= "\0\0" .. string_char(0x80) .. string_char(0x7F)
local floatNInfbig		= string_char(0xFF) .. string_char(0x80) .. "\0\0"
local floatNInflittle	= "\0\0" .. string_char(0x80) .. string_char(0xFF)
local floatZero			= "\0\0\0\0"

local halfNaNbig		= string_char(0xFE) .. "\0"
local halfNaNlittle		= "\0" .. string_char(0xFE)
local halfPInfbig		= string_char(0xFC) .. "\0"
local halfPInflittle	= "\0" .. string_char(0xFC)
local halfNInfbig		= string_char(0x7C) .. "\0"
local halfNInflittle	= "\0" .. string_char(0x7C)
local halfZero			= "\0\0"

--- @class BinaryConverter
BinaryConverter = {}
BinaryConverter.metatable = {
    __index = BinaryConverter
}
setmetatable( BinaryConverter, { __call = function( self ) return self:Get() end } )

--- Retrieves or creates a singleton BinaryConverter instance
--- @return BinaryConverter
function BinaryConverter:Get()
    if not self.instance then
        self.instance = self:New()
    end
    return self.instance
end

function BinaryConverter:New()

	--- @class BinaryConverter
	--- @field private _isLittleEndian boolean
	local instance = setmetatable( {}, BinaryConverter.metatable )

	instance.endianness = "littleendian"
	instance._isLittleEndian = true

	return instance
end

--- @see BinaryConverter.IsBigEndian
--- @return boolean
function BinaryConverter:IsLittleEndian()
	return self._isLittleEndian
end

--- @see BinaryConverter.IsLittleEndian
--- @return boolean
function BinaryConverter:IsBigEndian()
	return not self._isLittleEndian
end

--- @param shouldUseBigEndian boolean [Default: `true`] Pass `true` to use big endian notation, `false` to use little endian notation
--- @see BinaryConverter.SetLittleEndian
function BinaryConverter:SetBigEndian( shouldUseBigEndian )
	if shouldUseBigEndian == nil then shouldUseBigEndian = true end

	-- Ensure only boolean values make it to the variable
	self._isLittleEndian = ( shouldUseBigEndian and false or true )
end

--- @param shouldUseLittleEndian boolean? [Default: `true`] Pass `true` to use little endian notation, `false` to use big endian notation
--- @see BinaryConverter.SetBigEndian
function BinaryConverter:SetLittleEndian( shouldUseLittleEndian )
	if shouldUseLittleEndian == nil then shouldUseLittleEndian = true end

	-- Ensure only boolean values make it to the variable
	self._isLittleEndian = ( shouldUseLittleEndian and true or false )
end

function BinaryConverter:ToBinaryString( num, bits )
	local tab = {}
  	if bits then
    	for i = 1, bits do
	      	table.insert( tab, 1, num % 2 )
	      	num = math_floor( num / 2 )
    	end
  	else
    	while num > 0 do
	      	table.insert(tab, 1, num%2)
	      	num = math_floor(num/2)
    	end
  	end
  	return table.concat(tab)
end

--- @param byteString string A string of length 8
--- @return number # The input, parsed as a 64 bit signed integer and converted into a number
function BinaryConverter:FromInt64( byteString )
	local b1, b2, b3, b4, b5, b6, b7, b8 = byteString:byte( 1, 8 )

	local convertedNumber = (
		self._isLittleEndian and
			b8 * 0x100000000000000 +
			b7 * 0x1000000000000 +
			b6 * 0x10000000000 +
			b5 * 0x100000000 +
			b4 * 0x1000000 +
			b3 * 0x10000 +
			b2 * 0x100 +
			b1
		or
			b1 * 0x100000000000000 +
			b2 * 0x1000000000000 +
			b3 * 0x10000000000 +
			b4 * 0x100000000 +
			b5 * 0x1000000 +
			b6 * 0x10000 +
			b7 * 0x100 +
			b8
		)

	if convertedNumber > 0x7FFFFFFFFFFFFFFF then
		convertedNumber = convertedNumber - 0x10000000000000000
	end

	return convertedNumber
end

--- Converts from a byte string of length 4 to 32bit signed integer
--- @param byteString string A string of length 4
--- @return integer
function BinaryConverter:FromInt32( byteString )

    local b1, b2, b3, b4 = byteString:byte( 1, 4 )

	local convertedNumber = (
		self._isLittleEndian and
			b4 * 0x1000000 +
			b3 * 0x10000 +
			b2 * 0x100 +
			b1
		or
			b1 * 0x1000000 +
			b2 * 0x10000 +
			b3 * 0x100 +
			b4
		)

	if convertedNumber > 0x7FFFFFFF then
		convertedNumber = convertedNumber - 0x100000000
	end

	return convertedNumber
end

-- Converts from string of length 2 to 16bit signed integer
function BinaryConverter:FromInt16(str)
	if self.endianness == "bigendian" then
		local b1,b2 = str:byte(1,2)
		local convertedNumber = b1*0x100+b2
		if convertedNumber > 0x7FFF then
			convertedNumber = convertedNumber-0x10000
		end
		return convertedNumber
	elseif self.endianness == "littleendian" then
		local b1,b2 = str:byte(1,2)
		local convertedNumber = b2*0x100+b1
		if convertedNumber > 0x7FFF then
			convertedNumber = convertedNumber-0x10000
		end
		return convertedNumber
	end
	return false
end

-- Converts from string of length 1 to 8bit signed integer
function BinaryConverter:FromInt8(str)
	local b1 = str:byte(1)
	local convertedNumber = b1
	if convertedNumber > 0x7F then
		convertedNumber = convertedNumber-0x100
	end
	return convertedNumber
end

--- Converts a byte string into a boolean
--- @param byteString string A byte string of length 1
function BinaryConverter:FromBoolean( byteString )
	local convertedNumber = self:FromInt8( byteString )

	if convertedNumber == 0 then
		return false
	elseif convertedNumber == 1 then
		return true
	else
		error( "Got unexpected value when converting bytestring into a boolean. Bytes: " .. tostring( byteString ) .. ", Converted number: " .. tostring( convertedNumber ) )
	end
end

-- Converts from string of length 8 to 64bit unsigned integer
function BinaryConverter:FromUInt64(str)
	if self.endianness == "bigendian" then
		local b1,b2,b3,b4,b5,b6,b7,b8 = str:byte(1,8)
		local convertedNumber = b1*0x100000000000000+b2*0x1000000000000+b3*0x10000000000+b4*0x100000000+b5*0x1000000+b6*0x10000+b7*0x100+b8
		return convertedNumber
	elseif self.endianness == "littleendian" then
		local b1,b2,b3,b4,b5,b6,b7,b8 = str:byte(1,8)
		local convertedNumber =  b8*0x100000000000000+b7*0x1000000000000+b6*0x10000000000+b5*0x100000000+b4*0x1000000+b3*0x10000+b2*0x100+b1
		return convertedNumber
	end
	return false
end

--- @param byteString string A string of length 4
--- @return number # The input, parsed as a 32 bit unsigned integer and converted into a number
function BinaryConverter:FromUInt32( byteString )
	local b1,b2,b3,b4 = byteString:byte( 1, 4 )

	local convertedNumber = (
		self._isLittleEndian and
			b4 * 0x1000000 +
			b3 * 0x10000 +
			b2 * 0x100 +
			b1
		or
			b1 * 0x1000000 +
			b2 * 0x10000 +
			b3 * 0x100 +
			b4
	)
	return convertedNumber
end

-- Converts from string of length 2 to 16bit unsigned integer
function BinaryConverter:FromUInt16(str)
	if self.endianness == "bigendian" then
		local b1,b2 = str:byte(1,2)
		local convertedNumber = b1*0x100+b2
		return convertedNumber
	elseif self.endianness == "littleendian" then
		local b1,b2 = str:byte(1,2)
		local convertedNumber = b2*0x100+b1
		return convertedNumber
	end
	return false
end

--- Converts from string of length 1 to 16bit unsigned integer
--- @param byteString string
--- @return number
function BinaryConverter:FromUInt8( byteString )
	return byteString:byte( 1 )
end

-- Converts from string of length 2 to 16 bit floating point number
function BinaryConverter:FromHalf(str)
	if str == halfZero then
		return 0
	elseif str == halfNaNbig or str == halfNaNlittle then
		return NAN
	elseif str == halfPInfbig or str == halfPInflittle then
		return math.huge
	elseif str == halfNInfbig or str == halfNInflittle then
		return -math.huge
	end

    local b1,b2
    if self.endianness == "bigendian" then
        b1,b2 = str:byte(1,2)
    elseif self.endianness == "littleendian" then
        b2,b1 = str:byte(1,2)
    end
   
    local sign = (b1 > 128 and -1) or 1
    local exp = math_floor((b1%128)/0x4)-15
    local mantissa = (b1%0x4)*0x100 + b2
    local convertedNumber = 2^exp*(mantissa/(0x400)+1)
    return sign * convertedNumber
end

-- Converts from string of length 4 to 32 bit floating point number
function BinaryConverter:FromFloat(str)
	if str == floatZero then
		return 0
	elseif str == floatNaNbig or str == floatNaNlittle then
		return NAN
	elseif str == floatPInfbig or str == floatPInflittle then
		return math.huge
	elseif str == floatNInfbig or str == floatNInflittle then
		return -math.huge
	end

	local b1,b2,b3,b4
	if self.endianness == "bigendian" then
		b1,b2,b3,b4 = str:byte(1,4)
	elseif self.endianness == "littleendian" then
		b4,b3,b2,b1 = str:byte(1,4)
	end

	local sign = (b1 > 128 and -1) or 1
	local mantissa = b2%0x80*0x10000+b3*0x100+b4
	local exp = math_floor(((b1%128)*0x100+b2)/0x80)-127
	local convertedNumber = 2^exp*(mantissa/0x800000+1)
	return sign * convertedNumber
end

-- Converts from string of length 8 to 64 bit floating point number
function BinaryConverter:FromDouble(str)
	if str == doubleZero then
		return 0
	elseif str == doubleNaNbig or str == doubleNaNlittle then
		return NAN
	elseif str == doublePInfbig or str == doublePInflittle then
		return math.huge
	elseif str == doubleNInfbig or str == doubleNInflittle then
		return -math.huge
	end

	local b1,b2,b3,b4,b5,b6,b7,b8
	if self.endianness == "bigendian" then
		b1,b2,b3,b4,b5,b6,b7,b8 = str:byte(1,8)
	elseif self.endianness == "littleendian" then
		b8,b7,b6,b5,b4,b3,b2,b1 = str:byte(1,8)
	end

	local sign = (b1 > 128 and -1) or 1
	local mantissa = (b2%0x10)*0x1000000000000+b3*0x10000000000+b4*0x100000000+b5*0x1000000+b6*0x10000+b7*0x100+b8
	local exp = math_floor(((b1%128)*0x100+b2)/0x10)-1023
	local convertedNumber = 2^exp*(mantissa/(0x10000000000000)+1)
	return sign * convertedNumber
end

function BinaryConverter:FromCharArray(str)
	--iprint(str)
	local convertedString = str
	local endPoint = str:find('\0')
	if endPoint then 
		convertedString = convertedString:sub(1,endPoint-1)
	end
	return convertedString
end

function BinaryConverter:ToCharArray(str)
	if type(str) ~= "string" then return false end
	local zeroInd = string.find(str, "\0")
	if zeroInd then
		return str:sub(1,zeroInd)
	end

	str = str..'\0'
	return str
end


function BinaryConverter:ToUInt64(number)
	number = math_floor(number)%0x10000000000000000
	local b1,b2,b3,b4,b5,b6,b7,b8
	b8 = number%256
	b7 = math_floor(number/(0x100))%256
	b6 = math_floor(number/(0x10000))%256
	b5 = math_floor(number/(0x1000000))%256
	b4 = math_floor(number/(0x100000000))%256
	b3 = math_floor(number/(0x10000000000))%256
	b2 = math_floor(number/(0x1000000000000))%256
	b1 = math_floor(number/(0x100000000000000))%256

	if self.endianness == "bigendian" then
		return string_char(b1)..string_char(b2)..string_char(b3)..string_char(b4)..string_char(b5)..string_char(b6)..string_char(b7)..string_char(b8)
	elseif self.endianness == 'littleendian' then
		return string_char(b8)..string_char(b7)..string_char(b6)..string_char(b5)..string_char(b4)..string_char(b3)..string_char(b2)..string_char(b1)
	end
	return false
end

function BinaryConverter:ToUInt32(number)
	number = math_floor(number)%0x100000000
	local b1,b2,b3,b4
	b4 = number%256
	b3 = math_floor(number/(0x100))%256
	b2 = math_floor(number/(0x10000))%256
	b1 = math_floor(number/(0x1000000))%256

	if self.endianness == "bigendian" then
		return string_char(b1)..string_char(b2)..string_char(b3)..string_char(b4)
	elseif self.endianness == 'littleendian' then
		return string_char(b4)..string_char(b3)..string_char(b2)..string_char(b1)
	end
	return false
end

function BinaryConverter:ToUInt16(number)
	number = math_floor(number)%0x10000
	local b1,b2
	b2 = number%256
	b1 = math_floor(number/(0x100))%256

	if self.endianness == "bigendian" then
		return string_char(b1)..string_char(b2)
	elseif self.endianness == 'littleendian' then
		return string_char(b2)..string_char(b1)
	end
	return false
end

function BinaryConverter:ToUInt8(number)
	number = math_floor(number)%0x100
	local b1 = number%256

	if self.endianness == "bigendian" then
		return string_char(b1)
	elseif self.endianness == 'littleendian' then
		return string_char(b1)
	end
	return false
end

function BinaryConverter:ToInt64(number)
	if number < 0 then number = number + 0x10000000000000000 end
	return self:ToUInt64(number)
end

function BinaryConverter:ToInt32(number)
	if number < 0 then number = number + 0x100000000 end
	return self:ToUInt32(number)
end

function BinaryConverter:ToInt16(number)
	if number < 0 then number = number + 0x10000 end
	return self:ToUInt16(number)
end

function BinaryConverter:ToInt8(number)
	if number < 0 then number = number + 0x100 end
	return self:ToUInt8(number)
end

function BinaryConverter:GetFrac(frac, bits)
  	local ret = 0
  	for i=1,bits do
    	frac = frac * 2
    	if frac >= 1 then
	      	ret = ret + 2^(bits-i)
	      	frac = frac%1
          
	      	if frac == 0 then
	        	break
	      	end
    	end
  	end
  	return ret
end

function BinaryConverter:GetIntegralBinary(int)
	if int < 2 then
		if int == 0 then
			return 1,1
		else
			return 0,0
		end
	end

	local intCopy = int
	local first = math_floor( math_log( int, 2 ) )
	local last = 0
	while (intCopy%1 == 0) and (intCopy ~= 0) do
		last = last+1
		intCopy = math_floor(intCopy/2)
	end
	return first,last
end

function BinaryConverter:ToDouble(number)
	if type(number) ~= "number" then return false end
	-- Check for NaN
	if number ~= number then
		if self.endianness == "bigendian" then
			return doubleNaNbig
		elseif self.endianness == 'littleendian' then
			return doubleNaNlittle
		end
	-- +infinity
	elseif number == math.huge then
		if self.endianness == "bigendian" then
			return doublePInfbig
		elseif self.endianness == 'littleendian' then
			return doublePInflittle
		end
	-- -infinity
	elseif number == -math.huge then
		if self.endianness == "bigendian" then
			return doubleNInfbig
		elseif self.endianness == 'littleendian' then
			return doubleNInflittle
		end
	end

	local sign = 0
	if number < 0 then sign = 128 end

	number = math_abs(number)
	local main,frac = math_modf(number)
  	local mant = 0
	local exp = 0

	if number == 0 then
    	exp = 0
    	mant = 0
	elseif number < 1 then
		local fracFirst = math_floor( math_log( 1 / frac, 2 ) )
      	local fracPart = self:GetFrac(frac*(2^fracFirst), 52)
		exp = -fracFirst-1 + 1023
    	mant = (fracPart*2) % 0x10000000000000
	else
		local intFirst = self:GetIntegralBinary(main)
		local fracPart = self:GetFrac(frac, 52)
		exp = intFirst + 1023
    	mant = ((main * 2^(52-intFirst)) + math_floor(fracPart / 2^(intFirst))) % 0x10000000000000
	end

  	local b1,b2,b3,b4,b5,b6,b7,b8
  	b1 = string_char(mant%256)
  	b2 = string_char(math_floor(mant/(0x100))%256)
  	b3 = string_char(math_floor(mant/(0x10000))%256)
  	b4 = string_char(math_floor(mant/(0x1000000))%256)
  	b5 = string_char(math_floor(mant/(0x100000000))%256)
  	b6 = string_char(math_floor(mant/(0x10000000000))%256)
  	b7 = string_char((math_floor(mant/(0x1000000000000))%256 + math_floor(exp%128)*0x10)%256)
  	b8 = string_char(math_floor(exp/16)%128 + sign)
  
	if self.endianness == "bigendian" then
		return b8..b7..b6..b5..b4..b3..b2..b1
	elseif self.endianness == 'littleendian' then
		return b1..b2..b3..b4..b5..b6..b7..b8
	end
  	return false
end

function BinaryConverter:ToFloat(number)
	if type(number) ~= "number" then return false end
	-- Check for NaN
	if number ~= number then
		if self.endianness == "bigendian" then
			return floatNaNbig
		elseif self.endianness == 'littleendian' then
			return floatNaNlittle
		end
	-- +infinity
	elseif number > 3.402823466e38 then
		if self.endianness == "bigendian" then
			return floatPInfbig
		elseif self.endianness == 'littleendian' then
			return floatPInflittle
		end
	-- -infinity
	elseif number < -3.402823466e38 then
		if self.endianness == "bigendian" then
			return floatNInfbig
		elseif self.endianness == 'littleendian' then
			return floatNInflittle
		end
	end

	local sign = 0
	if number < 0 then sign = 128 end

	number = math_abs(number)
	local main,frac = math_modf(number)
  	local mant = 0
	local exp = 0

 	if number == 0 then
 		if self.endianness == "bigendian" then
			return string_char(sign).."\0\0\0"
		elseif self.endianness == 'littleendian' then
			return "\0\0\0"..string_char(sign)
		end
		return false
	elseif number < 1 then
      	local fracFirst = math_floor( math_log( 1 / frac, 2 ) )
      	local fracPart = self:GetFrac(frac*(2^fracFirst), 23)
	  	exp = (-fracFirst-1) + 127
    	mant = (fracPart*2) % 0x800000
	else
		local intFirst = self:GetIntegralBinary(main)
  		local fracPart = self:GetFrac(frac, 23)
		exp = intFirst + 127
    	mant = ((main * 2^(23-intFirst)) + math_floor(fracPart / 2^(intFirst))) % 0x800000
	end

  	local b1,b2,b3,b4
  	b1 = string_char( mant % 256 )
  	b2 = string_char( math_floor( mant / (0x100) ) % 256 )
  	b3 = string_char( math_floor( mant /(0x10000) ) %128 + math_floor( exp % 2 ) * 128 )
  	b4 = string_char( math_floor( exp / 2) % 128 + sign )

	if self.endianness == "bigendian" then
		return b4..b3..b2..b1
	elseif self.endianness == 'littleendian' then
		return b1..b2..b3..b4
	end
  	return false
end

function BinaryConverter:ToHalf(number)
	if type(number) ~= "number" then return false end
	-- Check for NaN
	if number ~= number then
		if self.endianness == "bigendian" then
			return halfNaNbig
		elseif self.endianness == 'littleendian' then
			return halfNaNlittle
		end
	-- +infinity
	elseif number > 65504 then
		if self.endianness == "bigendian" then
			return halfPInfbig
		elseif self.endianness == 'littleendian' then
			return halfPInflittle
		end
	-- -infinity
	elseif number < -65504 then
		if self.endianness == "bigendian" then
			return halfNInfbig
		elseif self.endianness == 'littleendian' then
			return halfNInflittle
		end
	end

	local sign = 0
	if number < 0 then sign = 128 end

	number = math_abs(number)
	local main,frac = math_modf(number)
	local mant = 0
	local exp = 0

	if number == 0 then
    	exp = 0
    	mant = 0
	elseif number < 1 then
		local fracFirst = math_floor( math_log( 1 / frac, 2 ) )
      	local fracPart = self:GetFrac(frac*(2^fracFirst), 10)
		exp = -fracFirst-1 + 15
    	mant = (fracPart*2) % 0x400
	else
		local intFirst = self:GetIntegralBinary(main)
		local fracPart = self:GetFrac(frac, 10)
		exp = intFirst + 15
    	mant = ((main * 2^(10-intFirst)) + math_floor(fracPart / 2^(intFirst))) % 0x400
	end

  	local b1,b2,b3,b4
  	b1 = string_char(mant%256)
  	b2 = string_char(math_floor(mant/0x100)%8 + (exp*0x4)%128 + sign)

	if self.endianness == "bigendian" then
		return b2..b1
	elseif self.endianness == 'littleendian' then
		return b1..b2
	end
  	return false
end