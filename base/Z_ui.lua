--作者:竹子菌
local _screenw,_screenh=getScreenSize()
if _screenw<_screenh then _screenw,_screenh=_screenh,_screenw end

local sizediff=2+(3/(2240-720))*(_screenw-720)

local _dpi=getScreenDPI()
if not tonumber(_dpi) then
	_dpi=320
elseif tonumber(_dpi)==-1 then
	_dpi=320
else
	_dpi=tonumber(_dpi)
end
local _dip=_dpi/160
local __dip=1 or  _dpi/320--解决单选框和多选框前面的圈或勾选框在低dpi下过大或高dpi下过小(但同时会导致字体过小或过大...)
			--删除"1 or "可以启用此项,默认不启用()
local _sysbottomheight=1



local function split(str, delimiter)
	if str==nil or str=='' or delimiter==nil then
		return {}
	end
	local result = {}
	for match in (str..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end
local function getStrWidth(a)
	local l=string.len(a)
	local len=0
	for i=1,l do
		asc2=string.byte(string.sub(a,i,i))
		if asc2>127 then
			len=len+1/3
		else
			len=len+9/16
		end
	end
	return len
end

	local function urlencode(w)
		pattern = "[^%w%d%?=&:/._%-%* ]"
		s = string.gsub(w, pattern, function(c)
			local c = string.format("%%%02X", string.byte(c))
			return c
		end)
		s = string.gsub(s, " ", "+")
		return s
	end
local function tableTojson(t)
	local function serialize(tbl)
		local tmp = {}
		for k, v in pairs(tbl) do
			local k_type = type(k)
			local v_type = type(v)
			local key
			if k_type == "string" then
				key = "\"" .. k .. "\":"
			elseif k_type == "number" then
				key = ""
			end
			local value
			if v_type == "table" then
				value = serialize(v)
			elseif v_type == "boolean" then
				value = tostring(v)
			elseif v_type == "string" then
				value = "\"" .. v .. "\""
			elseif v_type == "number" then
				value = v
			end
			tmp[#tmp + 1] = key and value and tostring(key) .. tostring(value) or nil
		end
		if #tbl == 0 then
			return "{" .. table.concat(tmp, ",") .. "}"
		else
			return "[" .. table.concat(tmp, ",") .. "]"
		end
	end
	return serialize(t)
end

ZUI={
}

function ZUI:new(DevScreen,Parm)
	
	local _width,_height = getScreenSize()--当前设备分辨率
	if _width<_height then _width,_height=_height,_width end
	--Parm.w  	UI宽度占比(开发环境下)
	--Parm.h	UI高度占比(开发环境下)
	Parm.w=Parm.w or 90
	Parm.h=Parm.h or 90
	local Scale,fsize,Xpos
	if _width/_height>=DevScreen.Width/DevScreen.Height then
		Scale=_height/DevScreen.Height
	else
		Scale=_width/DevScreen.Width
	end
	
	local tmp={
		w= Parm.w/100*DevScreen.Width*Scale,
		h= Parm.h/100*DevScreen.Height*Scale
	}
	

	local fsize=math.floor((Parm.size or 25)*Scale)
	local Xpos=math.floor((Parm.xpos or 5)/100*(tmp.w))
	local RowSpace=math.floor((Parm.rowSpace or 2)/100*(tmp.h))
	
	local o = {
		id=0,
		type="UI",
		Width=tmp.w,
		Height=tmp.h,
		Scale=Scale,
		RowSpace=RowSpace,
		Xpos=Xpos,
		
		DefaultAlign=Parm.align or "left",
		DefaultFrontSize=fsize,
		DefaultFrontColor=Parm.color or "13,13,13",
		
		con={
			style=Parm.style or "custom",
			config=Parm.config or "save_Default.dat",
			width=tmp.w,
			height=tmp.h,
			cancelname=Parm.cancelname or "Cancel",
			okname=Parm.okname or "OK",
			countdown=Parm.countdown or 30,
			views={}
		},
		ret={
		}
	}
	if Parm.bg then o.con.bg=Parm.bg end
	setmetatable(o,{__index = self} )
	if Parm.cancelscroll~=nil then
		o.con.cancelscroll = Parm.cancelscroll
	else
		o.con.cancelscroll = true
	end
	o.realheight=tmp.h-110*_dip
	o.realwidth=tmp.w-10
	
	
	return o
end

function ZUI:xper2pix(per)
	return math.floor(per/100*self.realwidth)
end
function ZUI:yper2pix(per)
	return math.floor(per/100*self.realheight)
end

Page={
}

function Page:new(UI,Parm)
	local fsize,Xpos,RowSpace
	if Parm.size then
		fsize=math.floor((Parm.size or 25)*UI.Scale)
	else
		fsize=UI.DefaultFrontSize
	end
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*(UI.con.width))
	else
		Xpos=UI.Xpos
	end
	if Parm.RowSpace then
		RowSpace=math.floor((Parm.rowSpace)/100*(UI.con.height))
	else
		RowSpace=UI.RowSpace
	end
	
	local o={
		UI=UI,
		type="Page",
		CurX=Xpos,
		CurY=0,
		LastLineFrontSize=0,
		Scale=UI.Scale,
		
		RowSpace=RowSpace,
		Xpos=Xpos,
		DefaultFrontSize=fsize,
		DefaultAlign=Parm.align or UI.DefaultAlign,
		
		DefaultFrontColor=Parm.color or UI.DefaultFrontColor,
		
		con={
			style="custom",
			text=Parm.text or "",
			size=fsize,
			type="Page",
			views={
			}
			
		}

	}
	o.UI.id=o.UI.id+1
	setmetatable(o,{__index = self} )

	table.insert(UI.con.views,o.con)
	
	return o
end

function Page:nextLine(height)
	height=height or 1
	self.CurX=self.Xpos
	self.CurY=math.floor(self.CurY+height*(self.RowSpace+self.LastLineFrontSize))
	self.LastLineFrontSize=self.DefaultFrontSize
end

function Page:addLabel(Parm)
	local fsize,Xpos,Ypos
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	local con={
		type="Label",
		text=Parm.text or Parm[1] or "",
		size=fsize,
		align=Parm.align or self.DefaultAlign,
		color=Parm.color or self.DefaultFrontColor,
		bg=Parm.bg or nil
	}
	
	local StrWidth=math.ceil(getStrWidth(con.text)*(fsize+sizediff))
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		Parm.w and self.UI:xper2pix(Parm.w) or StrWidth,Parm.h and self.UI:yper2pix(Parm.h) or (self.RowSpace+fsize)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+(Parm.w and self.UI:xper2pix(Parm.w) or StrWidth)
	if (Parm.h and self.UI:xper2pix(Parm.w) or fsize)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=(Parm.h and self.UI:yper2pix(Parm.h) or fsize)
	end
	table.insert(self.con.views,con)
end

function Page:addQQ(Parm)
	local fsize,Xpos,Ypos
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	local con={
		type="Label",
		text=Parm.text or Parm[1] or "",
		size=fsize,
		align=Parm.align or self.DefaultAlign,
		color=Parm.color or self.DefaultFrontColor,
		bg=Parm.bg or nil,
		extra={
			{
				goto="qq",
				text=Parm.text or Parm[1] or ""
			}
		}
	}
	
	local StrWidth=math.ceil(getStrWidth(con.text)*(fsize+sizediff))
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		Parm.w and self.UI:xper2pix(Parm.w) or StrWidth,Parm.h and self.UI:yper2pix(Parm.h) or (self.RowSpace+fsize)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+(Parm.w and self.UI:xper2pix(Parm.w) or StrWidth)
	if (Parm.h and self.UI:xper2pix(Parm.w) or fsize)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=(Parm.h and self.UI:yper2pix(Parm.h) or fsize)
	end
	table.insert(self.con.views,con)
end

function Page:addUrl(Parm)
	local fsize,Xpos,Ypos
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	local url=Parm.url
	if not string.find(url,"http://") then
		print("url前缺少了http://  已自动补全")
		url="http://"..url
	end
	url=urlencode(url)
	
	local con={
		type="Label",
		text=Parm.text or Parm[1] or "",
		size=fsize,
		align=Parm.align or self.DefaultAlign,
		color=Parm.color or self.DefaultFrontColor,
		bg=Parm.bg or nil,
		extra={
			{
				goto=url,
				text=Parm.text or Parm[1] or ""
			}
		}
	}
	
	
	local StrWidth=math.ceil(getStrWidth(con.text)*(fsize+sizediff))
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		Parm.w and self.UI:xper2pix(Parm.w) or StrWidth,Parm.h and self.UI:yper2pix(Parm.h) or (self.RowSpace+fsize)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+(Parm.w and self.UI:xper2pix(Parm.w) or StrWidth)
	if (Parm.h and self.UI:xper2pix(Parm.w) or fsize)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=(Parm.h and self.UI:yper2pix(Parm.h) or fsize)
	end
	table.insert(self.con.views,con)
end

function Page:addImage(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	Parm.w=Parm.w or 50
	Parm.h=Parm.h or Parm.w
	
	
	local con={
		type="Image",
		src=Parm.src or Parm[1] or "",
		width=self.UI:xper2pix(Parm.w)
	}
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		con.width,self.RowSpace+self.UI:yper2pix(Parm.h)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+con.width
	if self.UI:yper2pix(Parm.h)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=self.UI:yper2pix(Parm.h)
	end
	table.insert(self.con.views,con)
end

function Page:addWeb(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	Parm.w=Parm.w or 50
	Parm.h=Parm.h or Parm.w
	
	
	local url=Parm.url
	if not string.find(url,"http://") then
		print("url前缺少了http://  已自动补全")
		url="http://"..url
	end
	url=urlencode(url)
	if not Parm.id then
		errorReport("Web控件缺少id",true)
	end
	
	local con={
		type="WebView",
		id=Parm.id,
		url=url,
		width=self.UI:xper2pix(Parm.w),
		height=self.UI:yper2pix(Parm.h)
	}
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		con.width,self.RowSpace+self.UI:yper2pix(Parm.h)}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+con.width
	if self.UI:yper2pix(Parm.h)>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=self.UI:yper2pix(Parm.h)
	end
	table.insert(self.con.views,con)
end

function Page:addWebOnDefault(Parm)
	
	
	local url=Parm.url
	if not string.find(url,"http://") then
		print("url前缺少了http://  已自动补全")
		url="http://"..url
	end
	url=urlencode(url)
	if not Parm.id then
		errorReport("Web控件缺少id",true)
	end
	Parm.w=Parm.w or 50
	Parm.h=Parm.h or Parm.w
	
	local con={
		type="WebView",
		id=Parm.id,
		url=url,
		width=self.UI:xper2pix(Parm.w),
		height=self.UI:yper2pix(Parm.h)
	}
	
	table.insert(self.con.views,con)
end

function Page:addLine(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	Parm.w=Parm.w or 10
	Parm.h=Parm.h or 1
	
	
	if not Parm.id then
		errorReport("Line控件缺少id",true)
	end
	
	local con={
		type="Line",
		id=Parm.id,
		color=Parm.color or self.DefaultFrontColor,
		width=self.UI:xper2pix(Parm.w),
		height=self.UI:yper2pix(Parm.h)
	}
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		con.width,con.height}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+con.width
	if con.height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=con.height
	end
	table.insert(self.con.views,con)
end

function Page:addRadioGroup(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	if not Parm.id then
		errorReport("RadioGroup控件缺少id",true)
	end
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale*__dip)
	else
		fsize=self.DefaultFrontSize*__dip
	end
	if not Parm.w or not Parm.h then errorReport("请指定RadioGroup控件的width和height",true) end
	local width=self.UI:xper2pix(Parm.w)
	local height=self.UI:yper2pix(Parm.h)
	
	local con={
		type="RadioGroup",
		id=Parm.id,
		list=Parm.list,
		color=Parm.color or self.DefaultFrontColor,
		select=Parm.select or 0,
		size=fsize,
		orientation=Parm.orientation or "horizontal"
	}
	
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		width,height+self.RowSpace}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+width
	if height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=height
	end
	table.insert(self.con.views,con)
	
	self.UI.ret[Parm.id]=split(Parm.list,",")
	self.UI.ret[Parm.id].type="RadioGroup"
end

function Page:addCheckBoxGroup(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	if not Parm.id then
		errorReport("CheckBoxGroup控件缺少id",true)
	end
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale*__dip)
	else
		fsize=self.DefaultFrontSize*__dip
	end
	if not Parm.w or not Parm.h then errorReport("请指定CheckBoxGroup控件的width和height",true) end
	local width=self.UI:xper2pix(Parm.w)
	local height=self.UI:yper2pix(Parm.h)
	
	local con={
		type="CheckBoxGroup",
		id=Parm.id,
		list=Parm.list,
		color=Parm.color or self.DefaultFrontColor,
		select=Parm.select or "",
		size=fsize,
		orientation=Parm.orientation or "horizontal"
	}
	
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		width,height+self.RowSpace}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+width
	if height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=height
	end
	table.insert(self.con.views,con)
	
	self.UI.ret[Parm.id]=split(Parm.list,",")
	self.UI.ret[Parm.id].type=Parm.a and "CheckBoxGroupOne" or "CheckBoxGroup"
end

function Page:addEdit(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	if not Parm.id then
		errorReport("Edit控件缺少id",true)
	end
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if not Parm.w or not Parm.h then errorReport("请指定Edit控件的width和height",true) end
	local width=self.UI:xper2pix(Parm.w)
	local height=self.UI:yper2pix(Parm.h)
	
	local con={
		type="Edit",
		id=Parm.id,
		prompt=Parm.prompt or "",
		text=Parm.text or "",
		align=Parm.align or self.DefaultAlign,
		color=Parm.color or self.DefaultFrontColor,
		size=fsize,
		kbtype=Parm.kbtype or "default"
	}
	
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		width,height+self.RowSpace}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+width
	if height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=height
	end
	table.insert(self.con.views,con)
	
	self.UI.ret[Parm.id]={}
	self.UI.ret[Parm.id].type="Edit"
end

function Page:addComboBox(Parm)
	local Xpos,Ypos
	if Parm.xpos then
		Xpos=math.floor((Parm.xpos)/100*self.UI.realwidth)
	else
		Xpos=0
	end
	if Parm.ypos then
		Ypos=math.floor((Parm.ypos)/100*self.UI.realheight)
	else
		Ypos=0
	end
	if not Parm.id then
		errorReport("ComboBox控件缺少id",true)
	end
	if Parm.size then
		fsize=math.floor(Parm.size*self.Scale)
	else
		fsize=self.DefaultFrontSize
	end
	if not Parm.w or not Parm.h then errorReport("请指定ComboBox控件的width和height",true) end
	local width=self.UI:xper2pix(Parm.w)
	local height=self.UI:yper2pix(Parm.h)
	
	local con={
		type="ComboBox",
		id=Parm.id,
		list=Parm.list,
		select=Parm.select or 0,
		size=fsize,
	}
	
	local rect={self.CurX+Xpos,self.CurY+Ypos,
		width,height+self.RowSpace}
	con.rect=table.concat(rect,",")
	self.CurX=self.CurX+Xpos+width
	if height>self.LastLineFrontSize and not Parm.ypos then
		self.LastLineFrontSize=height
	end
	table.insert(self.con.views,con)
	
	self.UI.ret[Parm.id]=split(Parm.list,",")
	self.UI.ret[Parm.id].type="ComboBox"
end

function ZUI:show(ReturnType)
	local json=xmodApi.cjson
	if self.id==1 then
		local tbl=table.copy(self.con.views[1].views)
		self.con.views={}
		for k,v in pairs(tbl) do
			table.insert(self.con.views,v)
		end
	end
	ReturnType=ReturnType or 3
	local ret,results=showUI(json.encode(self.con))
	local res={_cancel=false}
	local _a=0
	if ret==1 then
		local tmp
		if ReturnType==0 then
			for k,v in pairs(self.ret) do
				if type(v)=="table" then
					if v.type=="ComboBox" then
						res[k]=v[tonumber(results[k])+1]
					elseif v.type=="Edit" then
						res[k]=results[k]
					elseif v.type=="RadioGroup" then 
						res[k]=tonumber(results[k])+1
					elseif v.type=="CheckBoxGroup" then
						tmp=split(results[k],"@")
						for _,vv in ipairs(tmp) do
							res[tostring(v[vv+1])]=true
						end
					end
				end
			end
			for k,v in pairs(res) do
				if tonumber(v) then
					res[k]=tonumber(v)
				end
			end
		elseif ReturnType==1 then
			for k,v in pairs(self.ret) do
				if type(v)=="table" then
					if v.type=="ComboBox" then
						res[k]=v[tonumber(results[k])+1]
					elseif v.type=="Edit" then
						res[k]=results[k]
					elseif v.type=="RadioGroup" then 
						res[k]=v[tonumber(results[k])+1]
					elseif v.type=="CheckBoxGroup" then
						tmp=split(results[k],"@")
						res[k]={}
						if #tmp==0 then res[k]=false end
						for _,vv in ipairs(tmp) do
							res[k][vv+1]=true
						end
					end
				end
			end
			
			for k,v in pairs(res) do
				if tonumber(v) then
					res[k]=tonumber(v)
				end
			end
		elseif ReturnType==2 then
			
			for k,v in pairs(self.ret) do
				if type(v)=="table" then
					if v.type=="ComboBox" then
						res[k]={}
						res[k][v[tonumber(results[k])+1]]=true
					elseif v.type=="Edit" then
						res[k]=results[k]
					elseif v.type=="RadioGroup" then
						res[k]={}
						res[k][v[tonumber(results[k])+1]]=true
					elseif v.type=="CheckBoxGroup" then
						tmp=split(results[k],"@")
						res[k]={}
						for _,vv in ipairs(tmp) do
							res[k][tostring(v[vv+1])]=true
						end
					end
				end
			end
			
			for k,v in pairs(res) do
				if type(k)=="table" then
					for kk,vv in pairs(res) do
						if tonumber(vv) then
							res[k][kk]=tonumber(vv)
						end
					end
				elseif tonumber(v) then
					res[k]=tonumber(v)
				end
			end
		elseif ReturnType==3 then
			for k,v in pairs(self.ret) do
				if type(v)=="table" then
					if v.type=="ComboBox" then
						res[k]=v[tonumber(results[k])+1]
					elseif v.type=="Edit" then
						res[k]=results[k]
					elseif v.type=="RadioGroup" then
						res[k]={}
						res[k][v[tonumber(results[k])+1]]=true
					elseif v.type=="CheckBoxGroup" then
						tmp=split(results[k],"@")
						res[k]={}
						for _,vv in ipairs(tmp) do
							res[k][tostring(v[vv+1])]=true
						end
					elseif v.type=="CheckBoxGroupOne" then
						tmp=results[k]
						if tmp and tmp=="0" then
							res[k]=true
						else
							res[k]=false
						end
					end
				end
			end
			
			for k,v in pairs(res) do
				if type(k)=="table" then
					for kk,vv in pairs(res) do
						if tonumber(vv) then
							res[k][kk]=tonumber(vv)
						end

					end
				elseif tonumber(v) then
					res[k]=tonumber(v)
				end
			end
		
		end
		return res
	end
	return {_cancel=true}
end



