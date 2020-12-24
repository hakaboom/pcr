local chttp = require'chttp'
local json = require'cjson'
local user_name = 'hzqyy1234'
local user_pw = 'Hw990410hw4396'
local yzmtype='1303'

local function snapshotRead(rect)
	local filename = xmod.getPublicPath() .. '/baiduocr.png'
	screen.snapshot(filename,rect)
	local file = io.open(filename, 'r')
	local retbyte = file:read("*a")
	file:close()
	return retbyte
end
local function fmt(p, ...)
	if select('#', ...) == 0 then
		return p
	else return string.format(p, ...) end
end
local function gen_boundary()
	local t = {"BOUNDARY-"}
	for i=2,17 do t[i] = string.char(math.random(65, 90)) end
	t[18] = "-BOUNDARY"
	return table.concat(t)
end
local function tprintf(t, p, ...)
	t[#t+1] = fmt(p, ...)
end
local function append_data(r, k, data, extra)
	tprintf(r, "content-disposition: form-data; name=\"%s\"", k)
	if extra.filename then
		tprintf(r, "; filename=\"%s\"", extra.filename)
	end
	if extra.content_type then
		tprintf(r, "\r\ncontent-type: %s", extra.content_type)
	end
	if extra.content_transfer_encoding then
		tprintf(
			r, "\r\ncontent-transfer-encoding: %s",
			extra.content_transfer_encoding
		)
	end
	tprintf(r, "\r\n\r\n")
	tprintf(r, data)
	tprintf(r, "\r\n")
end
local function encode(t, boundary)
	boundary = boundary or gen_boundary()
	local r = {}
	local _t
	for k,v in pairs(t) do
		tprintf(r, "--%s\r\n", boundary)
		_t = type(v)
		if _t == "string" then
			append_data(r, k, v, {})
		elseif _t == "table" then
			assert(v.data, "invalid input")
			local extra = {
				filename = v.filename or v.name,
				content_type = v.content_type,
				--content_transfer_encoding = v.content_transfer_encoding or "binary",
			}
			append_data(r, k, v.data, extra)
		else
			error(string.format("unexpected type %s", _t))
		end
	end
	tprintf(r, "--%s--\r\n", boundary)
	return table.concat(r), boundary
end


return {
	ocr=function(Rect)
		local img_Data = snapshotRead(Rect)
		local url = "http://v1-http-api.jsdama.com/api.php?mod=php&act=upload"
		local rq = {
			user_name = user_name,
			user_pw = user_pw,
			yzm_minlen = "0",
			yzm_maxlen = "0",
			yzmtype_mark = yzmtype,
			zztool_token = "441479f8f7e572c95771df6c6fe7983f",
			upload = { filename = "yzm.jpg", content_type = "image/jpeg", data = img_Data }
		}
		local boundary = gen_boundary()
		local post_data, bb = encode(rq, boundary)
		
		local headers = 	{
			["Content-Type"] = fmt("multipart/form-data; boundary=%s", boundary),
			["Content-Length"] = #post_data,
		}
			
		local request = chttp.create()
		request:setTimeout(30000)
		request:setUrl(url)
		request:setHeader(headers)
		request:setBody(post_data)
		local ret = request:post()
		if ret.text then
			local bool,str=pcall(json.decode,ret.text)
			Print(str)
			if str.data then
				return str.data
			else
				return false
			end
		else
			return false
		end
	end,
	error=function(id)
		print('识别错误')
		local url = "http://v1-http-api.jsdama.com/api.php?mod=php&act=error"
		local post_data=string.format("user_name=%s&user_pw=%s&yzm_id=%s", user_name, user_pw, id);
		local headers = 	{
			["Content-Type"] = "application/x-www-form-urlencoded",
			["Content-Length"] = #post_data,
		}
		local request = chttp:create()
		request:setTimeout(30000)
		request:setUrl(url)
		request:setHeader(headers)
		request:setBody(post_data)	
		local ret = request:post()
		return ret.text
	end
}