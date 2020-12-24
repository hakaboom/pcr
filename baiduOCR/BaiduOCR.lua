local sign=require("baiduOCR.Authorization")
local baiduOCR = {}

local function belongkey(aimTable,aim)--判断目标变量在表中是否存在
	for k,_ in pairs(aimTable) do
		if aim==k then
			return true
		end
	end
	return false
end
local function snapshotRead(rect)
	local filename = xmod.getPublicPath() .. '/baiduocr.png'
	screen.snapshot(filename,rect)
	local file = io.open(filename, 'r')
	local retbyte = file:read("*a")
	file:close()
	return retbyte
end
local function urlEncode(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return (string.gsub(s, " ", "+"))
end
function baiduOCR.getText(rect)
	local imgRaw    = snapshotRead(rect)
	local imgBase64 = require('crypto').base64Encode(imgRaw)
	local imgData   = urlEncode(imgBase64)
	if imgData == nil or #imgData <= 0 then return "" end
	
	local chttp = require 'chttp'
	local json=require("cjson")
	local post_data = 'image='..imgData
	local params = {}
	local response_body = {}
	local method    = "POST" 
	local url       = 'http://aip.baidubce.com/rest/2.0/ocr/v1/general_basic'
	local path      = '/rest/2.0/ocr/v1/general_basic'
	local headers = {
			['host']           = 'aip.baidubce.com',
	        ['Content-Type']   = 'application/x-www-form-urlencoded',
	        ['Content-Length'] = #post_data,
	}	

	local sign = sign(method, path, headers, params)
	headers['Authorization'] = sign

	local request = chttp.create()
	request:setUrl(url)
	request:setHeader(headers)
	request:setBody(post_data)
	local ret = request:post()
	if ret.text then
		local bool,str=pcall(json.decode,ret.text)
		Print(str)
		if type(str)=='table' then
			if str['words_result'] then
				if str['words_result'][1] then
					return str['words_result'][1]['words']
				end
			end
		end
		return false
	end
end

return baiduOCR