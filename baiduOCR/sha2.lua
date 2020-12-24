local unpack, table_concat, byte, char, string_rep, sub, gsub, string_format, floor, ceil, tonumber =
   table.unpack or unpack, table.concat, string.byte, string.char, string.rep, string.sub, string.gsub, string.format, math.floor, math.ceil, tonumber

local function get_precision(one)

   local k, n, m, prev_n = 0, one, one
   while true do
      k, prev_n, n, m = k + 1, n, n + n + 1, m + m + k % 2
      if k > 256 or n - (n - 1) ~= 1 or m - (m - 1) ~= 1 or n == m then
         return k, false 
      elseif n == prev_n then
         return k, true 
      end
   end
end

local x = 2/3
local Lua_has_double = x * 5 > 3 and x * 4 < 3 and get_precision(1.0) >= 53
assert(Lua_has_double, "at least 53-bit floating point numbers are required")

local int_prec, Lua_has_integers = get_precision(1)
local Lua_has_int32 =true
assert(Lua_has_int64 or Lua_has_int32 or not Lua_has_integers, "Lua integers must be either 32-bit or 64-bit")

local is_LuaJIT = ({false, [1] = true})[1] and (type(jit) ~= "table" or jit.version_num >= 20000)
local is_LuaJIT_21 
local LuaJIT_arch
local ffi          
local b         
local library_name

if is_LuaJIT then
   b = require"bit"
   library_name = "bit"

   local LuaJIT_has_FFI, result = pcall(require, "ffi")
   if LuaJIT_has_FFI then
      ffi = result
   end
   is_LuaJIT_21 = not not loadstring"b=0b0"
   LuaJIT_arch = type(jit) == "table" and jit.arch or ffi and ffi.arch or nil
else
 
   if type(bit) == "table" and bit.bxor then
      b = bit
      library_name = "bit"
   elseif type(bit32) == "table" and bit32.bxor then
      b = bit32
      library_name = "bit32"
   end
end

local method, branch

branch="LIB32"

local AND, OR, XOR, SHL, SHR, ROL, ROR, NOT, NORM, HEX, XOR_BYTE

if branch == "FFI" or branch == "LJ" or branch == "LIB32" then

   AND  = b.band                
   OR   = b.bor                
   XOR  = b.bxor               
   SHL  = b.lshift              
   SHR  = b.rshift              
   ROL  = b.rol or b.lrotate   
   ROR  = b.ror or b.rrotate   
   NOT  = b.bnot               
   NORM = b.tobit              
   HEX  = b.tohex  
   assert(AND and OR and XOR and SHL and SHR and ROL and ROR and NOT, "Library '"..library_name.."' is incomplete")
   XOR_BYTE = XOR           
   function SHL(x, n)
      return (x * 2^n) % 2^32
   end

   function SHR(x, n)
      x = x % 2^32 / 2^n
      return x - x % 1
   end

   function ROL(x, n)
      x = x % 2^32 * 2^n
      local r = x % 2^32
      return r + (x - r) / 2^32
   end

   function ROR(x, n)
      x = x % 2^32 / 2^n
      local r = x % 1
      return r * 2^32 + (x - r)
   end

   local AND_of_two_bytes = {[0] = 0}
   local idx = 0
   for y = 0, 127 * 256, 256 do
      for x = y, y + 127 do
         x = AND_of_two_bytes[x] * 2
         AND_of_two_bytes[idx] = x
         AND_of_two_bytes[idx + 1] = x
         AND_of_two_bytes[idx + 256] = x
         AND_of_two_bytes[idx + 257] = x + 1
         idx = idx + 2
      end
      idx = idx + 256
   end

   local function and_or_xor(x, y, operation)
      local x0 = x % 2^32
      local y0 = y % 2^32
      local rx = x0 % 256
      local ry = y0 % 256
      local res = AND_of_two_bytes[rx + ry * 256]
      x = x0 - rx
      y = (y0 - ry) / 256
      rx = x % 65536
      ry = y % 256
      res = res + AND_of_two_bytes[rx + ry] * 256
      x = (x - rx) / 256
      y = (y - ry) / 256
      rx = x % 65536 + y % 256
      res = res + AND_of_two_bytes[rx] * 65536
      res = res + AND_of_two_bytes[(x + y - rx) / 256] * 16777216
      if operation then
         res = x0 + y0 - operation * res
      end
      return res
   end

   function AND(x, y)
      return and_or_xor(x, y)
   end

   function OR(x, y)
      return and_or_xor(x, y, 1)
   end

   function XOR(x, y, z, t) 
      if z then
         if t then
            z = and_or_xor(z, t, 2)
         end
         y = and_or_xor(y, z, 2)
      end
      return and_or_xor(x, y, 2)
   end

   function XOR_BYTE(x, y)
      return x + y - 2 * AND_of_two_bytes[x + y * 256]
   end

end

HEX = HEX or
   function (x)
      return string_format("%08x", x % 4294967296)
   end

local function XOR32A5(x)
   return XOR(x, 0xA5A5A5A5) % 4294967296
end

local sha256_feed_64, sha512_feed_128, md5_feed_64, sha1_feed_64

local sha2_K_lo, sha2_K_hi, sha2_H_lo, sha2_H_hi = {}, {}, {}, {}
local sha2_H_ext256 = {[224] = {}, [256] = sha2_H_hi}
local sha2_H_ext512_lo, sha2_H_ext512_hi = {[384] = {}, [512] = sha2_H_lo}, {[384] = {}, [512] = sha2_H_hi}
local md5_K, md5_sha1_H = {}, {0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0}
local md5_next_shift = {0, 0, 0, 0, 0, 0, 0, 0, 28, 25, 26, 27, 0, 0, 10, 9, 11, 12, 0, 15, 16, 17, 18, 0, 20, 22, 23, 21}

local HEX64, XOR64A5  
local common_W = {} 
local K_lo_modulo, hi_factor = 4294967296, 0


if branch == "LIB32" or branch == "EMUL" then
   function sha256_feed_64(H, K, str, offs, size)
      local W = common_W
      local h1, h2, h3, h4, h5, h6, h7, h8 = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
      for pos = offs, offs + size - 1, 64 do
         for j = 1, 16 do
            pos = pos + 4
            local a, b, c, d = byte(str, pos - 3, pos)
            W[j] = ((a * 256 + b) * 256 + c) * 256 + d
         end
         for j = 17, 64 do
            local a, b = W[j-15], W[j-2]
            W[j] = XOR(ROR(a, 7), ROL(a, 14), SHR(a, 3)) + XOR(ROL(b, 15), ROL(b, 13), SHR(b, 10)) + W[j-7] + W[j-16]
         end
         local a, b, c, d, e, f, g, h = h1, h2, h3, h4, h5, h6, h7, h8
         for j = 1, 64 do
            local z = XOR(ROR(e, 6), ROR(e, 11), ROL(e, 7)) + AND(e, f) + AND(-1-e, g) + h + K[j] + W[j]
            h = g
            g = f
            f = e
            e = z + d
            d = c
            c = b
            b = a
            a = z + AND(d, c) + AND(a, XOR(d, c)) + XOR(ROR(a, 2), ROR(a, 13), ROL(a, 10))
         end
         h1, h2, h3, h4 = (a + h1) % 4294967296, (b + h2) % 4294967296, (c + h3) % 4294967296, (d + h4) % 4294967296
         h5, h6, h7, h8 = (e + h5) % 4294967296, (f + h6) % 4294967296, (g + h7) % 4294967296, (h + h8) % 4294967296
      end
      H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8] = h1, h2, h3, h4, h5, h6, h7, h8
   end
end

do
   local function mul(src1, src2, factor, result_length)
      local result, carry, value, weight = {}, 0.0, 0.0, 1.0
      for j = 1, result_length do
         for k = math.max(1, j + 1 - #src2), math.min(j, #src1) do
            carry = carry + factor * src1[k] * src2[j + 1 - k] 
         end
         local digit = carry % 2^24
         result[j] = floor(digit)
         carry = (carry - digit) / 2^24
         value = value + digit * weight
         weight = weight * 2^24
      end
      return result, value
   end

   local idx, step, p, one, sqrt_hi, sqrt_lo = 0, {4, 1, 2, -2, 2}, 4, {1}, sha2_H_hi, sha2_H_lo
   repeat
      p = p + step[p % 6]
      local d = 1
      repeat
         d = d + step[d % 6]
         if d*d > p then
            local root = p^(1/3)
            local R = root * 2^40
            R = mul({R - R % 1}, one, 1.0, 2)
            local _, delta = mul(R, mul(R, R, 1.0, 4), -1.0, 4)
            local hi = R[2] % 65536 * 65536 + floor(R[1] / 256)
            local lo = R[1] % 256 * 16777216 + floor(delta * (2^-56 / 3) * root / p)
            if idx < 16 then
               root = p^(1/2)
               R = root * 2^40
               R = mul({R - R % 1}, one, 1.0, 2)
               _, delta = mul(R, R, -1.0, 2)
               local hi = R[2] % 65536 * 65536 + floor(R[1] / 256)
               local lo = R[1] % 256 * 16777216 + floor(delta * 2^-17 / root)
               local idx = idx % 8 + 1
               sha2_H_ext256[224][idx] = lo
               sqrt_hi[idx], sqrt_lo[idx] = hi, lo + hi * hi_factor
               if idx > 7 then
                  sqrt_hi, sqrt_lo = sha2_H_ext512_hi[384], sha2_H_ext512_lo[384]
               end
            end
            idx = idx + 1
            sha2_K_hi[idx], sha2_K_lo[idx] = hi, lo % K_lo_modulo + hi * hi_factor
            break
         end
      until p % d == 0
   until idx > 79
end


for width = 224, 256, 32 do
   local H_lo, H_hi = {}
   if XOR64A5 then
      for j = 1, 8 do
         H_lo[j] = XOR64A5(sha2_H_lo[j])
      end
   else
      H_hi = {}
      for j = 1, 8 do
         H_lo[j] = XOR32A5(sha2_H_lo[j])
         H_hi[j] = XOR32A5(sha2_H_hi[j])
      end
   end
end

do
   local sin, abs, modf = math.sin, math.abs, math.modf
   for idx = 1, 64 do
      local hi, lo = modf(abs(sin(idx)) * 2^16)
      md5_K[idx] = hi * 65536 + floor(lo * 2^16)
   end
end

local function sha256ext(width, text)
   local H, length, tail = {unpack(sha2_H_ext256[width])}, 0.0, ""
   local function partial(text_part)
      if text_part then
         if tail then
            length = length + #text_part
            local offs = 0
            if tail ~= "" and #tail + #text_part >= 64 then
               offs = 64 - #tail
               sha256_feed_64(H, sha2_K_hi, tail..sub(text_part, 1, offs), 0, 64)
               tail = ""
            end
            local size = #text_part - offs
            local size_tail = size % 64
            sha256_feed_64(H, sha2_K_hi, text_part, offs, size - size_tail)
            tail = tail..sub(text_part, #text_part + 1 - size_tail)
            return partial
         else
            error("Adding more chunks is not allowed after receiving the result", 2)
         end
      else
         if tail then
            local final_blocks = {tail, "\128", string_rep("\0", (-9 - length) % 64 + 1)}
            tail = nil
            length = length * (8 / 256^7)
            for j = 4, 10 do
               length = length % 1 * 256
               final_blocks[j] = char(floor(length))
            end
            final_blocks = table_concat(final_blocks)
            sha256_feed_64(H, sha2_K_hi, final_blocks, 0, #final_blocks)
            local max_reg = width / 32
            for j = 1, max_reg do
               H[j] = HEX(H[j])
            end
            H = table_concat(H, "", 1, max_reg)
         end
         return H
      end
   end
   if text then
      return partial(text)()
   else
      return partial
   end
end

local function hex2bin(hex_string)
   return (gsub(hex_string, "%x%x",
      function (hh)
         return char(tonumber(hh, 16))
      end
   ))
end

local block_size_for_HMAC

local function pad_and_xor(str, result_length, byte_for_xor)
   return gsub(str, ".",
      function(c)
         return char(XOR_BYTE(byte(c), byte_for_xor))
      end
   )..string_rep(char(byte_for_xor), result_length - #str)
end

local function hmac(hash_func, key, message)
   local block_size = block_size_for_HMAC[hash_func]
   if not block_size then
      error("Unknown hash function", 2)
   end
   if #key > block_size then
      key = hex2bin(hash_func(key))
   end
   local append = hash_func()(pad_and_xor(key, block_size, 0x36))
   local result

   local function partial(message_part)
      if not message_part then
         result = result or hash_func(pad_and_xor(key, block_size, 0x5C)..hex2bin(append()))
         return result
      elseif result then
         error("Adding more chunks is not allowed after receiving the result", 2)
      else
         append(message_part)
         return partial
      end
   end

   if message then
      return partial(message)()
   else
      return partial
   end

end


local sha2 = {
   sha256     = function (text) return sha256ext(256, text) end,
   -- other hash functions:
   md5        = md5,                                             
   sha1       = sha1,                                     
   -- misc utilities:
   hmac       = hmac,                                            
   hex2bin    = hex2bin,  
}

block_size_for_HMAC = {
   [sha2.sha256]     = 64,   
}

return sha2
