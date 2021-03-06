_const={
	Middle = "Middle",	--居中
	Left = "Left",	--左
	Right = "Right",--右
	Top = "Top",	--上
	Bottom = "Bottom",	--下
	LeftTop = "LeftTop",	--左上
	LeftBottom = "LeftBottom",	--左下
	RightTop = "RightTop",	--右上
	RightBottom ="RightBottom",	--右下	
	getXY = "GetXY",
	FilePath = "private",
	offsetMode = "withArry",
	GetColorMode = "getColor", --"getBilinear" "getColor"
	Arry=nil,
}

local setmetatable,foreachi = setmetatable,table.foreachi
local Color3B = Color3B
local MainPointScale = {
	["Middle"] = function(point,Arry)
		local x=Arry.Cur.x/2-((Arry.Dev.x/2-point.x)*Arry.MainPointScale.x)+Arry.Cur.Left
		local y=Arry.Cur.y/2-((Arry.Dev.y/2-point.y)*Arry.MainPointScale.y)+Arry.Cur.Top
			return x,y
	end,
	["Left"] = function (point,Arry)--左中
		local x=point.x*Arry.MainPointScale.x+Arry.Cur.Left
		local y=Arry.Cur.y/2-((Arry.Dev.y/2-point.y)*Arry.MainPointScale.y)+Arry.Cur.Top
			return x,y
	end,
	["Right"] = function (point,Arry)--右中
		local x=Arry.Cur.x-((Arry.Dev.x-point.x)*Arry.MainPointScale.x)+Arry.Cur.Left
		local y=Arry.Cur.y/2-((Arry.Dev.y/2-point.y)*Arry.MainPointScale.y)+Arry.Cur.Top
			return x,y
	end,
	["Top"] = function (point,Arry)--上中 
		local x=Arry.Cur.x/2-((Arry.Dev.x/2-point.x)*Arry.MainPointScale.x)+Arry.Cur.Left
		local y=point.y*Arry.MainPointScale.y+Arry.Cur.Top
			return x,y
	end,
	["Bottom"] = function (point,Arry)--下中
		local x=Arry.Cur.x/2-((Arry.Dev.x/2-point.x)*Arry.MainPointScale.x)+Arry.Cur.Left
		local y=Arry.Cur.y-((Arry.Dev.y-point.y)*Arry.MainPointScale.y)+Arry.Cur.Top
			return x,y
	end,
	["LeftTop"] = function (point,Arry)--左上
		local x=point.x*Arry.MainPointScale.x+Arry.Cur.Left
		local y=point.y*Arry.MainPointScale.y+Arry.Cur.Top
			return x,y
	end,
	["LeftBottom"] = function (point,Arry)--左下
		local x=point.x*Arry.MainPointScale.x+Arry.Cur.Left
		local y=Arry.Cur.y-((Arry.Dev.y-point.y)*Arry.MainPointScale.y)+Arry.Cur.Top
			return x,y
	end,
	["RightTop"] = function (point,Arry) --右上角
		local x=Arry.Cur.x-((Arry.Dev.x-point.x)*Arry.MainPointScale.x)+Arry.Cur.Left
		local y=point.y*Arry.MainPointScale.y+Arry.Cur.Top
			return x,y
	end,
	["RightBottom"] = function (point,Arry) --右下角
		local x=Arry.Cur.x-((Arry.Dev.x-point.x)*Arry.MainPointScale.x)+Arry.Cur.Left
		local y=Arry.Cur.y-((Arry.Dev.y-point.y)*Arry.MainPointScale.y)+Arry.Cur.Top
			return x,y
	end,
}
local getScaleMainPoint = function (MainPoint,Anchor,Arry)	--缩放锚点
	local point={
		x=MainPoint.x-Arry.Dev.Left,
		y=MainPoint.y-Arry.Dev.Top,
	}
	local x,y,fun
	fun=MainPointScale[Anchor]
	x,y=fun(point,Arry)
	return {x=x,y=y}
end
local getScaleXY        = function (point,MainPoint,DstMainPoint,Arry)	--缩放XY
	local x=DstMainPoint.x+(point.x-MainPoint.x)*Arry.AppurtenantScale.x
	local y=DstMainPoint.y+(point.y-MainPoint.y)*Arry.AppurtenantScale.y
	return x,y
end
local getScaleArea      = function (Area,DstMainPoint,MainPoint,Arry)	--缩放Area
	local Area = Area
	local __type = type(Area)
	local _len = table.getLen(Area)
	if (__type == 'table') then
		if (_len == 1) then	--Area={Rect()}
			if Area[1].__tag == 'Rect' then
				local rect = Area[1]
				Area = {rect.x,rect.y,rect.x+rect.width,rect.y+rect.height}
			else
				error('传参错误')
			end
		elseif (_len == 2) then --Area = {100,100}
		--	Area = Area
		elseif (_len == 4) then --Area = {x1,y1,x2,y2}
			if Area[3]>Area[1] and Area[4]>Area[2] then 
		--		Area = Area
			elseif Area[3]<Area[1] or  Area[2]<Area[4] then 	--Area = {x1,y1,width,height}
				Area = {Area[1],Area[2],Area[1]+Area[3],Area[2]+Area[4]}
			else
				error('传参错误')
			end
		end
	elseif (__type) == 'userdata' then	
		if Area.__tag == 'Rect' then	--Area=Rect()
			Area = {Area.x,Area.y,Area.x+Area.width,Area.y+Area.height}		
		end
	else
		error('传参错误')
	end

	if DstMainPoint then
		if _len==2 then return 
		{getScaleXY({x=Area[1],y=Area[2]},MainPoint,DstMainPoint,Arry)} end
		Area[1],Area[2]=getScaleXY({x=Area[1],y=Area[2]},MainPoint,DstMainPoint,Arry)
		Area[3],Area[4]=getScaleXY({x=Area[3],y=Area[4]},MainPoint,DstMainPoint,Arry)
	else
		if _len==2 then return
			{((Area[1] or Area['x'])-Arry.Dev.Left)*Arry.AppurtenantScale.x+Arry.Cur.Left,
			 ((Area[2] or Area['y'])-Arry.Dev.Top)*Arry.AppurtenantScale.y+Arry.Cur.Top}
		end
		Area[1]=(Area[1]-Arry.Dev.Left)*Arry.AppurtenantScale.x+Arry.Cur.Left
		Area[3]=(Area[3]-Arry.Dev.Left)*Arry.AppurtenantScale.x+Arry.Cur.Left
		Area[2]=(Area[2]-Arry.Dev.Top)*Arry.AppurtenantScale.y+Arry.Cur.Top
		Area[4]=(Area[4]-Arry.Dev.Top)*Arry.AppurtenantScale.y+Arry.Cur.Top
	end
	local width=Area[3]-Area[1]
	local height=Area[4]-Area[2]

	return Rect(Area[1],Area[2],width,height)
end
local tableCopy 		= function (tbl)
	local new_table = {}
	for index,value in pairs(tbl) do
		if type(value) == 'table' then
			new_table[index] = tableCopy(value)
		else
			new_table[index] = value
		end
	end
	return new_table
end
local slp				= function (T)
	T=T and T*1000 or 0.05
	sleep(T)
end

_printcmpColorErr_ = function (Cur,Dev,tag,key) 
	tag=tag or "" 
	return  
end
_printPoint_       = function (p)
	return string.format("point<x=%.2f,y=%.2f>",p.Cur.x,p.Cur.y)
end
_printmultiPoint_  = function (multi,Num)
	Num=Num or ""
	local n = 1
	local str="multiPoint< \n"
		for k,v in ipairs(multi) do
			str=str..string.format("\t \t%s[x=%.2f,y=%.2f]\n",
			Num,v.Cur.x,v.Cur.y)
		end
		if multi.Area then str=str..string.format("Area=%s%s\n",Num,multi.Area) end
		if multi.index then str = str .. (multi.index.__tag=='Rect' and 
			string.format("%sindex=<%s>",Num,multi.index) or string.format('%sindex=Point(%.2f, %.2f)',Num,multi.index[1],multi.index[2])
		) end
		str=str.."\t >"
	return str
end
_printcustomData_  = function (__tag)
	if __tag=="point" then
		return _printPoint_
	elseif __tag=="multiPoint" then
		return _printmultiPoint_ 
	end
end


point={--单点对象
}
_point_metatable={
	__index=point,
	__add=function (t1,t2)
		local p1,p2=t1.Cur,t2.Cur
		local x,y,newPoint
			x=p1.x+p2.x
			y=p1.y+p2.y
				newPoint=point:newByCur({x=x,y=y})
		return newPoint
	end,
	__sub=function (t1,t2)
		local p1,p2=t1.Cur,t2.Cur
		local x,y,newPoint
			x=p1.x-p2.x
			y=p1.y-p2.y
				newPoint=point:newByCur({x=x,y=y})
		return newPoint
	end,
	__eq=function (t1,t2)
		local p1,p2=t1.Cur,t2.Cur
		local x,y
		if (p1.x==p2.x) and (p1.y==p1.y) then
			return true
		end
		return false
	end,
	__tostring=function (p)
		return _printPoint_(p)
	end
}
function point:new(Base)--创建单点对象
	local o={
		__tag="point",
		fuzz =	Base.fuzz or 85,
		index =	Base.index or 1,
		Anchor = Base.Anchor,
		MainPoint =	Base.MainPoint or {x=0,y=0},
		DstMainPoint = Base.DstMainPoint,
		Dev={
			x = Base.x,
			y =	Base.y,
			color= Base.color and Color3B(Base.color) or nil,
			offset= Base.offset and Color3B(Base.offset) or nil,
		},
		Cur={
		},
	}
	o.Arry=Base.Arry or _const.Arry;
	local Arry=o.Arry
	---------------------------------------------------
	if o.DstMainPoint then
		o.Cur.x,o.Cur.y=getScaleXY(o.Dev,o.MainPoint,o.DstMainPoint,Arry)
	elseif not o.Anchor then
		o.Cur.x=(o.Dev.x-Arry.Dev.Left)*Arry.AppurtenantScale.x+Arry.Cur.Left
		o.Cur.y=(o.Dev.y-Arry.Dev.Top)*Arry.AppurtenantScale.y+Arry.Cur.Top
	else	
		o.DstMainPoint=getScaleMainPoint(o.MainPoint,o.Anchor,Arry)
		o.Cur.x,o.Cur.y=getScaleXY(o.Dev,o.MainPoint,o.DstMainPoint,Arry)
	end
	setmetatable(o,_point_metatable)	
	return o
end
function point:newByCur(Base)
	local o={
		__tag = "point",
		fuzz = Base.fuzz or 85,
		index =	Base.index or 1,
		Anchor = Base.Anchor,
		MainPoint = Base.MainPoint or {x=0,y=0},
		DstMainPoint = Base.DstMainPoint,
	 	Dev={ color= Base.color and Color3B(Base.color) or nil }, --no Dev
		Cur={
			x = Base.x,	
			y = Base.y,	
		--	color = Base.color and Color3B(Base.color) or nil,
			offset = Base.offset and Color3B(Base.offset) or nil,
		},
	}
	o.Arry=Base.Arry or _const.Arry
	setmetatable(o,_point_metatable)	
	return o
end
function point:newBymulti(Base)
	local o={
		__tag = "point",
		fuzz = Base.fuzz or 85,
		index = Base.index or 1,
		Anchor = Base.Anchor,
		MainPoint = Base.MainPoint,
		DstMainPoint = Base.DstMainPoint,
		Dev={
			x = Base.x,
			y = Base.y,
			color = Base.color and Color3B(Base.color) or nil,
			offset = Base.offset and Color3B(Base.offset) or nil,
		},
		Cur={
			x = Base.Cur.x,
			y = Base.Cur.y,
		},
	}
	o.Arry=Base.Arry or _const.Arry;
	setmetatable(o,_point_metatable)	
	return o
end
function point:touchHold(T)--按住屏幕,单位/秒
	touch.down(self.index,self.Cur.x,self.Cur.y)
	slp(T)
	touch.up(self.index,self.Cur.x,self.Cur.y)
	slp()
end
function point:Click(T)	--单点屏幕
	touch.down(self.index,self.Cur.x,self.Cur.y)
	slp()
	touch.up(self.index,self.Cur.x,self.Cur.y)
	slp(T)
end
function point:getColor()--获取点的颜色R,G,B
	self.Cur.color=screen.getColor(self.Cur.x,self.Cur.y)
end
function point:getBilinear()--二次插值取点 
	_K:keep(true)
	local point=self.Cur
	local ZoomX,ZoomY=math.floor(point.x),math.floor(point.y)	--缩放后的临近点
	local u,v=(point.x-ZoomX),(point.y-ZoomY)
		local r0,g0,b0=screen.getColorRGB(ZoomX,ZoomY)
		local r1,g1,b1=screen.getColorRGB(ZoomX+1,ZoomY)
		local r2,g2,b2=screen.getColorRGB(ZoomX,ZoomY+1)
		local r3,g3,b3=screen.getColorRGB(ZoomX+1,ZoomY+1)
		local	tmpColor0={
					r=(r0*(1-u)+r1*u),
					g=(g0*(1-u)+g1*u),
					b=(b0*(1-u)+b1*u),
				}
		local	tmpColor1={
					r=(r2*(1-u)+r3*u),
					g=(g2*(1-u)+g3*u),
					b=(b2*(1-u)+b3*u),
				}
		local	DstColor={
					r=tmpColor0.r*(1-v)+tmpColor1.r*v,
					g=tmpColor0.g*(1-v)+tmpColor1.g*v,
					b=tmpColor0.b*(1-v)+tmpColor1.b*v,
				}
		self.Cur.color=Color3B(DstColor.r,DstColor.g,DstColor.b)
end
function point:cmpColor()--比色
	local r ,g ,b =self.Dev.color.r,self.Dev.color.g,self.Dev.color.b	
	local lr,lg,lb=self.Cur.color.r,self.Cur.color.g,self.Cur.color.b
	if self.Dev.offset then
		local offColor=self.Dev.offset
		local ofr,ofg,ofb=offColor.r,offColor.g,offColor.b	--偏色rgb
		local ar,ag,ab=r-ofr,g-ofg,b-ofb	--max
		local ir,ig,ib=r+ofr,g+ofg,b+ofb	--min
		if ((ar<lr)and(ag<lg)and(ab<lb)) and  --max< color <min
			((lr<ir)and(lg<ig)and(lb<ib)) then
			return true
		end
		return false
	else
		local fuzz =math.floor(0xff * (100 - self.fuzz) * 0.01)
		local r3,g3,b3=(lr-r),(lg-g),(lb-b)
		local diff=math.sqrt(r3^2+g3^2+b3^2)
			if diff>fuzz then
				return false
			end
		return true
	end
end
function point:getandCmpColor(touchmode,T)
	self[_const.GetColorMode](self)
	local bool=self:cmpColor()
	if touchmode==true then
		if bool then self:Click(T) end
	elseif touchmode==false then
		if not bool then self:Click(T) end
	end
	return bool
end
function point:getDev()
	return self.Dev
end
function point:getXY()
	return self.Cur
end
function point:getXYtoPoint()
	return Point(self.Cur.x,self.Cur.y)
end
function point:ClearText()
	self:Click(1)
	runtime.inputText("#CLEAR#")
end
function point:inputText(Text,CLEAR)
	self:Click(1)
	if CLEAR==true then runtime.inputText('#CLEAR#') end
	runtime.inputText(Text)
end
function point:resetDev(x,y)--重设Dev坐标
	self.Dev.x=x
	self.Dev.y=y
end
function point:refresh()--刷新
	local o=self
	local Arry=o.Arry
	if o.DstMainPoint then
		o.Cur.x,o.Cur.y=getScaleXY(o.Dev,o.MainPoint,o.DstMainPoint,Arry)
	elseif not o.Anchor then
		o.Cur.x=(o.Dev.x-Arry.Dev.Left)*Arry.AppurtenantScale.x+Arry.Cur.Left
		o.Cur.y=(o.Dev.y-Arry.Dev.Top)*Arry.AppurtenantScale.y+Arry.Cur.Top
	else	
		o.DstMainPoint=getScaleMainPoint(o.MainPoint,o.Anchor,Arry)	--计算锚点
		o.Cur.x,o.Cur.y=getScaleXY(o.Dev,o.MainPoint,o.DstMainPoint,Arry)
	end
end
function point:offsetXY(x,y,offsetMode)--偏移坐标
	if offsetMode=="withArry" then
		pointx=self.Cur.x+(x*self.Arry.AppurtenantScale.x)
		pointy=self.Cur.y+(y*self.Arry.AppurtenantScale.y)
	else
		pointx=self.Cur.x+x
		pointy=self.Cur.y+y		
	end
	self.Cur.x=pointx
	self.Cur.y=pointy
end
function point:printXY()--打印坐标
	print(string.format("{x=%.2f,y=%.2f}",self.Cur.x,self.Cur.y))
end
function point:printSelf()
	Print(self)
end


multiPoint={--多点对象
}
_multiPoint_metatable={
	__index=multiPoint,
	__tostring=function (multi)
		return _printmultiPoint_(multi)
	end,
}
function multiPoint:new(Base)--创建多点对象
	local o={
		__tag 		 = "multiPoint",
		_tag 		 = Base._tag,
		fuzz 		 = Base.fuzz or 80,
		index 		 = Base.index,
		indexN 		 = Base.indexN or 1,
		Area 		 = Base.Area,
		MainPoint    = Base.MainPoint or {x=0,y=0},
		Anchor	     = Base.Anchor,
		DstMainPoint = Base.DstMainPoint,
		offset 		 = Base.offset,
		limit   	 = Base.limit,
		priority     = Base.priority or screen.PRIORITY_DEFAULT,
	}
	o.Arry=Base.Arry or _const.Arry
	local Arry=o.Arry
	------------------------------------------------------------------------------
	if o.DstMainPoint then	
		foreachi(Base,function(k,v) v.Cur={x=nil,y=nil}
			v.fuzz=o.fuzz
			v.Cur.x,v.Cur.y=getScaleXY(v,o.MainPoint,o.DstMainPoint,Arry)
			o[k]=point:newBymulti(v)	--缩放
		end)
	elseif not o.Anchor then 
		foreachi(Base,function(k,v) v.Cur={x=nil,y=nil}
			v.fuzz=o.fuzz
			v.Cur.x=(v.x-Arry.Dev.Left)*Arry.AppurtenantScale.x+Arry.Cur.Left
			v.Cur.y=(v.y-Arry.Dev.Top)*Arry.AppurtenantScale.y+Arry.Cur.Top
			v.MainPoint=o.MainPoint
			o[k]=point:newBymulti(v)
		end)
	else	
		o.DstMainPoint=getScaleMainPoint(o.MainPoint,o.Anchor,Arry)	--计算锚点
		foreachi(Base,function(k,v) v.Cur={x=nil,y=nil}
			v.fuzz=o.fuzz
			v.Cur.x,v.Cur.y=getScaleXY(v,o.MainPoint,o.DstMainPoint,o.Arry)
			o[k]=point:newBymulti(v)
		end)
	end
	
	o.index=(o.index and getScaleArea(o.index,o.DstMainPoint,o.MainPoint,Arry) or nil)
	o.Area=(o.Area and getScaleArea(o.Area,o.DstMainPoint,o.MainPoint,Arry) or nil)
	setmetatable(o,_multiPoint_metatable)
	return o
end
function multiPoint:newBypoint(Base)--由单点对象创建多点对象
	local o={
		__tag 		 = "multiPoint",
		_tag 		 = Base._tag,
		fuzz 		 = Base.fuzz or 85,
		index 		 = Base.index,
		indexN 		 = Base.indexN or 1,
		Area 		 = Base.Area,
		MainPoint    = Base.MainPoint or {x=0,y=0},
		Anchor 		 = Base.Anchor,
		DstMainPoint = Base.DstMainPoint,
		offset 		 = Base.offset,
		limit  		 = Base.limit,
		priority  	 = Base.priority or screen.PRIORITY_DEFAULT,
	}
	o.Arry=Base.Arry or _const.Arry
	------------------------------------------------------------------------------
	table.foreachi(Base,function(k,v) o[k]=v end)
	setmetatable(o,_multiPoint_metatable)
	return o
end
function multiPoint:Click(T)
	assert(self.index, "Click没有传入index")
	math.randomseed(tonumber(string.reverse(tostring(os.milliTime())):sub(1,6)))
		local p=self.index
		local point,point1,point2
			if #p==2 then
				point=self.index
			else
				point1,point2=p:tl(),p:br()
				point={
					math.random(point1.x,point2.x),
					math.random(point1.y,point2.y)
				}
			end
	touch.down(self.indexN,point[1],point[2])
	slp()
	touch.up(self.indexN,point[1],point[2])
	slp(T)
end
function multiPoint:AllClick(T)
	for k,v in ipairs(self) do
		self[k]:Click(T)
	end
end
function multiPoint:ChoiceClick(num,T)
	num = num or error()
	self[num]:Click(T)
end
function multiPoint:getColor()
	_K:keep(true)
		for k,v in ipairs(self) do
			self[k]:getColor()
		end
end
function multiPoint:getBilinear()
	_K:keep(true)
		for k,v in ipairs(self) do
			self[k]:getBilinear()
		end
end
function multiPoint:cmpColor()--比色 可以在这里取消注释进行测试时候的判断
	for k,v in ipairs(self) do
		local  res=v:cmpColor()
			if not res then
				local err=_printcmpColorErr_(v.Cur.color,v.Dev.color,self._tag,k)
			return false,err
		end
  	end
	--	printf(">>>>>>>>>>>>>>>>%s:true",(self._tag or ""))
  	return true
end
function multiPoint:getandCmpColor(touchmode,T)
	self[_const.GetColorMode](self)
	local bool,err=self:cmpColor()
	if touchmode==true then
		if bool then self:Click(T) end
	elseif touchmode==false then
		if not bool then self:Click(T) end
	end
	return bool,err
end
function multiPoint:findColor(returnType)--区域找色
	assert(self.Area, "findColor没有传入Area")
	local color={}
		table.foreachi(self,function (k,v) color[k]={
				pos=self[k]:getXYtoPoint(),
				color=Color3B(v.Dev.color),
				fuzz=v.fuzz,
				offset=v.Dev.offset,
				} 
		end)
	local pos=screen.findColor(self.Area,color,self.fuzz,self.priority)
		if pos ~= Point.INVALID then
			if returnType=="getXY" then
				return {x=pos.x,y=pos.y}
			else
				return point:newByCur({x=pos.x,y=pos.y})
			end
		end
	return false
end
function multiPoint:findColors(returnType)--区域多点找色
	assert(self.Area, "findColors没有传入Area")
	local color,postbl={},{}
		table.foreachi(self,function (k,v) color[k]={
				pos=self[k]:getXYtoPoint(),
				color=Color3B(v.Dev.color),
				fuzz=v.fuzz,
				offset=v.Dev.offset,
				} 
		end)
	local result=screen.findColors(self.Area,color,self.fuzz,self.priority,(self.limit or 200))
		if #result > 0 then
			if returnType=="getXY" then
				for i,pos in pairs(result) do
					postbl[i]=point:newByCur({x=pos.x,y=pos.y}):getXY()
				end
			else
				for i,pos in pairs(result) do
					postbl[i]=point:newByCur({x=pos.x,y=pos.y}):getXY()
				end
			end
			return postbl
		end
	return false
end
function multiPoint:findColorEX(ac,fuzz)--用多点找色返回的点去取比色,Ac设置number,会调用new时的Ac个点给找色
	assert(self.Area, "findColorEX没有传入Area")
	local ac=ac or 1
	local color,returnTbl={},{}
		for i=1,ac do v=self[i]
			color[i]={
				pos=self[i]:getXYtoPoint(),
				color=Color3B(v.Dev.color),
				fuzz=v.fuzz,
				offset=v.Dev.offset,
			}
		end 
	local MainPoint={x=self[1].Dev.x,y=self[1].Dev.y}
	local initpoint=screen.findColors(self.Area,color,(fuzz or self.fuzz),self.priority,999)
		--print(#initpoint)
		if #initpoint > 0 then
			local Allpoint=tableCopy(self:getAllpoint())
				for k,v in ipairs(initpoint) do
					local Dst={x=initpoint[k].x,y=initpoint[k].y}
					table.foreachi(Allpoint,function(k,v) v.MainPoint=MainPoint v.DstMainPoint=Dst v:refresh() end)
					local multipoint=multiPoint:newBypoint(Allpoint)
						multipoint:getColor()
						if multipoint:cmpColor() then
							returnTbl[#returnTbl+1]=v
						end
				end
			return returnTbl
		end
end
function multiPoint:binarizeImage()--二值化图片
	assert(self.Area, "binarizeImage没有传入Area")
	local img = Image.fromScreen(self.Area)
	local data = img:binarize(self.offset)
	self.binarize=data
end
function multiPoint:getText(data)--识字
	assert(self.Area, "findColors没有传入Area")
	if not self.binarize then self:binarizeImage() end
	local ocr=OCR:new({lang="eng"})
	data.binarize=self.binarize
	data.rect=self.Area
	return ocr:getText(data)
end
function multiPoint:getXY()
	local tbl={}
	table.foreachi(self,function (k,v) tbl[k]=v:getXY() end)
	return tbl
end
function multiPoint:getXYtoPoint()--获取参数点
	local tbl={}
	table.foreachi(self,function (k,v) tbl[k]=v:getXYtoPoint() end)
	return tbl
end
function multiPoint:getAllpoint()
	local tbl={}
	table.foreachi(self,function (k,v) tbl[k]=v end)
	return tbl	
end
function multiPoint:getArea()
	return self.Area
end
function multiPoint:showHUD(T)
	local hud=HUD:new({Area=self.Area})
		hud:show()
		slp(T)
		hud:clear()
end
function multiPoint:offsetXY(x,y,offsetMode)--偏移坐标
	table.foreachi(self, function(k,v) 
		v:offsetXY(x,y,offsetMode)
	end)
end
function multiPoint:printbinarize()--打印二值化data
	local data=self.binarize
	for _,v in pairs(data) do
		print(table.concat(v, ''))
	end
end
function multiPoint:printXY()--打印所有的点参数
	print(string.format(">>>>>>>>>>>>>>>>%s",(self._tag or "")))
	table.foreachi(self, function(k,v) 
		self[k]:printXY()
	end)
end
function multiPoint:printSelf()
	Print(self)
end


--没用2.0 用的旧得api
HUD={
}
function HUD:new(Base)--创建HUD
	local o={
		origin = nil,
		size = nil,
		color = Base.color or "0xffffffff",
		bg = Base.bg or "0xffffffff",
		textsize = (Base.textsize or 20)*_const.Arry.AppurtenantScale.y,
		id = createHUD(),
		pos = Base.pos or 0,
		text = Base.text or "",
	}
	if Base.point then 
		o.origin=Base.point[1]
		o.size=Size(Base.point[2]-Base.point[1])
	elseif Base.Area then
		o.origin=Base.Area:tl()
		o.size=Base.Area:size()
	end
	setmetatable(o,{__index = self} )	
	return o
end
function HUD:show(text)
	local o=self:getdata(text)
	showHUD(self.id,o.text,o.size,o.color,o.bg,o.pos,o.x,o.y,o.width,o.height)
end
function HUD:hide()
	local o=self:getdata()
	showHUD(self.id,"",o.size,"0x00000000","0x00000000",o.pos,o.x,o.y,o.width,o.height)
end
function HUD:clear()
	hideHUD(self.id)
	self=nil
end
function HUD:reset(Base)
	self.text=Base.text
	self.color=Base.color
	self.bg=Base.bg
	self.size=Base.size
end
function HUD:getdata(text)
	local o={
			text=text or self.text,
			size=self.textsize,
			color=self.color,
			bg=self.bg,
			pos=self.pos,
			x=self.origin.x,
			y=self.origin.y,
			width=self.size.width,
			height=self.size.height,
	}		
	return o
end


runTime={--计时器
}
function runTime:new()--创建计时器
	local o={
		startTime=os.milliTime()
	}
	
	setmetatable(o,{__index=self} )
	return o
end
function runTime:resetTime(T)--重设计时器时间起点
	self.startTime=T or os.milliTime()
end
function runTime:setcheckTime(T)--设置检查点T为间隔时间/秒 必填
	self.Time=T*1000
end
function runTime:checkTime(bool)--检查时间
	if self.startTime+self.Time<os.milliTime() then
		if bool then self:resetTime() end	--重设起点时间
		return true
	end
	return false
end
function runTime:cmpTime()--与计时器时间起点比较时间差
	local diff=(os.milliTime()-self.startTime)
	printf("间隔:%s 秒",diff/1000)
	return diff	--返回毫秒
end


--文件对象
File={
}
function File:new(filename,Path)--File:new("userconfig","自定义路径")
	local o={
		Filename =filename,					--文件名
		FilePath ='',
		Path = '',
	}
	Path = Path or "private"
	if Path=='public' then 
		o.FilePath=xmod.resolvePath('[public]'..filename)
		o.Path = xmod.getPublicPath()
	elseif Path=='private' then
		o.FilePath=xmod.resolvePath('[private]'..filename)
		o.Path = xmod.getPrivatePath()
	elseif Path=='Path' then
		o.FilePath= filename	--选择Path需要自己补全路径
		o.Path = Path
	end
	setmetatable(o,{ __index = self})
	return o
end
function File:Write(data)
	Print(self.FilePath)
	local file = io.open(self.FilePath,'r+')
	assert(file,"path of the file don't exist or can't open")
	file:write(data)
	file:flush()
	file:close()
end
function File:WriteNewByJson(tbl)--以Json格式写入文件tbl={["xxxxx"]="123",["aaaaaa"]=true}
	local json=require("cjson")
	local file=io.open(self.FilePath,"r+")
	assert(file,"path of the file don't exist or can't open")
	local str=json.encode(tbl)	--table转为json格式
	file:write(str)
	file:flush()
	file:close()
end
function File:ReadFile()--直接读取文件全部内容,返回字符串
	local json=require("cjson")
	local file=io.open(self.FilePath,"r")
	assert(file,"path of the file don't exist or can't open")
	local str=file:read('a')
	file:flush()
	file:close()
	return str
end
function File:ReadByLine()
	local json=require("cjson")
	local file=io.open(self.FilePath,"r")
	assert(file,"path of the file don't exist or can't open")
	local t={}
	for line in file:lines() do
		t[#t+1] = line
	end
	return t
end
function File:ReadByJson()--读取Json格式的文件
	local json=require("cjson")
	local file=io.open(self.FilePath,"r")
	assert(file,"path of the file don't exist or can't open")
	local tbl=json.decode(file:read("*a"))
	file:close()
	return tbl
end
function File:ReadByJsontoStr()--读取Json格式的文件
	local json=require("cjson")
	local file=io.open(self.FilePath,"r")
	assert(file,"path of the file don't exist or can't open")
	local tbl=json.decode(file:read("*a"))
	local str=table.concat(tbl,",")
	file:close()
	return str
end
function File:ClearFile()--清除当前文件内容
	local file=io.open(self.FilePath,"w")
	file:flush()
	file:close()
end
function File:check(newBuild)--检测文件是否存在
	if io.open(self.FilePath,'r')==nil then
		print("没有"..self.Filename.."这个文件")
		if newBuild==true then
			io.open(self.FilePath,"w"):close()
		end
		return false
	end
	return true
end
function File:rename(newName)--重设文件名
	os.rename(self.FilePath,(self.Path..newName))
end
function File:remove()--删除文件
	os.remove(self.FilePath)
end
function File:printPath()--打印当前文件路径
	printf("路径为 : %s",self.FilePath)
end

--OCR对象
OCR={
}
function OCR:new(data)--{Edition="tessocr_3.02.02",path="res/",lang="chi_sim"}
	local data = data or {}
	local o={
		Edition=data.Edition or "tessocr_3.02.02",
		path=data.path or "[external]",
		lang=data.lang or "eng",
		PSM=data.PSM or 6,
		white=data.white or "",
		black=data.black or "",
		reset=false,
	}
	local tessocr=require(o.Edition)	
	local ocr,msg=tessocr.create({
		mode = 2,
		path = o.path,
		lang = o.lang,
	})
	if ocr==nil then
		print("ocr创建失败:"..msg)
		xmod.exit()
	end	
	setmetatable(o,{__index = self} )
	o.ocr=ocr
	return o
end
function OCR:getText(data)--{Rect={},diff={},PSM=6,white="123456789"}
	local imgData
	if data.binarize then 
		imgData=data.binarize 
	else --二值化图片
		local img=Image.fromScreen(data.Rect)
		imgData=img:binarize(data.diff)	
	end
--	for _, row in pairs(imgData) do
--		print(table.concat(row))
--	end
	local PSM=data.PSM or self.PSM
	local White=data.white or self.white
	local Black=data.Black or self.black
	
	self.ocr:setPSM(PSM)--设置PSM
	self.ocr:setWhitelist(White)--设置白名单	
	self.ocr:setBlacklist(Black)

	local code,result,detail=self.ocr:getText(imgData)
		if code == 0 then
			local text=result:trim()
			 printf('text = %s', text)
			 return text,detail
		else
			print('ocr:getText failed!')
		end
end
function OCR:release()--释放字库(释放后再次使用需要重新启动)
	self.reset=true
	self.ocr:release()
end
function OCR:restart()--释放后重新启动
	local ocr,msg=tessocr.create({
		path=self.path,
		lang=self.lang,
	})
	if ocr==nil then
		print("ocr创建失败:"..msg)
		xmod.exit()
	end	
	self.ocr=ocr
end


--滑动对象
Slide={
}
function Slide:new(Base)
	local o={
		MoveStart=Base.point[1],			--起始点
		MoveEnd=Base.point[2],				--结束点
		holdtime=Base.holdtime or 0,	--滑动结束后touchup前的延迟,可以防止滑动的惯性效果
		steplen=Base.steplen or 10,		--步长
		steptime=Base.steptime or 10,	--每次滑动后的延迟
		index=Base.index or 1,
	}
	setmetatable(o,{__index = self})
	return o
end
function Slide:move()--双指移动
	local x,y
	local x1,y1=self.MoveStart.x,self.MoveStart.y
	local x2,y2=self.MoveEnd.x,self.MoveEnd.y
	local t=self.steplen/100
	touch.down(self.index,x1,y1)
	for i=0,1,t do
		x=(1-i)*x1+i*x2
		y=(1-i)*y1+i*y2
		touch.move(self.index,x,y)
		sleep(steptime)
	end
	if x<x2 or y<y2 then
		x=x+(x2-x)
		y=y+(y2-y)
		touch.move(self.index,x,y)
	end
	slp(self.holdtime)
	touch.up(self.index,x,y)
end
function Slide:Close()--双指缩小
	local x1,y1,x2,y2
	local Move={
		{x=self.MoveStart.x,y=self.MoveStart.y},
		{x=self.MoveEnd.x,y=self.MoveEnd.y},
	}
	local middle={
		x=math.abs(self.MoveStart.x-self.MoveEnd.y),
		y=math.abs(self.MoveStart.y-self.MoveEnd.y),
	}
	local t=self.steplen/100
		touch.down(self.index,Move[1].x,Move[1].y)
		touch.down(self.index+1,Move[2].x,Move[2].y)
		for i=0,1,t do
			x1=(1-i)*Move[1].x+i*middle.x
			x2=(1-i)*Move[2].x+i*middle.x
			y1=(1-i)*Move[1].y+i*middle.y
			y2=(1-i)*Move[2].y+i*middle.y
				touch.move(self.index,x1,y1)
				touch.move(self.index+1,x2,y2)
				sleep(steptime)
		end
		slp(self.holdtime)
		touch.up(self.index,x1,y1)
		touch.up(self.index+1,x2,y2)
end
function Slide:Enlarge()--双指扩大
	local x1,y1,x2,y2
	local Move={
		{x=self.MoveStart.x,y=self.MoveStart.y},
		{x=self.MoveEnd.x,y=self.MoveEnd.y},
	}
	local middle={
		x=math.abs(self.MoveStart.x-self.MoveEnd.y),
		y=math.abs(self.MoveStart.y-self.MoveEnd.y),
	}
	local t=self.steplen/100
		touch.down(self.index,middle.x,middle.y)
		touch.down(self.index+1,middle.x,middle.y)
			for i=0,1,t do
				x1=(1-i)*middle.x+i*Move[1].x
				x2=(1-i)*middle.x+i*Move[2].x
				y1=(1-i)*middle.y+i*Move[1].y
				y2=(1-i)*middle.y+i*Move[2].y
		touch.move(self.index,x1,y1)
		touch.move(self.index+1,x2,y2)
		sleep(steptime)
	end
	slp(self.holdtime)
	touch.up(self.index,x1,y1)
	touch.up(self.index+1,x2,y2)

end


--system对象
System={ --
}
function System:new(DevScreen,CurScreen,initfor,MainPointScaleMode,AppurtenantScaleMode) --,GameAspect
	local o={
		keepTime=0,
		Arry={
			Cur=tableCopy(CurScreen),
			Dev=tableCopy(DevScreen),
		},
	}
	-----------------------------------------------------------------
	local Dev,Cur = o.Arry.Dev,o.Arry.Cur
	local DevX,DevY,CurX,CurY
	if initfor==1 or initfor==2 then 
		DevX=Dev.Width-Dev.Left-Dev.Right		--开发机X减去黑边
		DevY=Dev.Height-Dev.Top-Dev.Bottom		--开发机Y减去黑边
		CurX=Cur.Width-Cur.Left-Cur.Right		--当前机器X减去黑边
		CurY=Cur.Height-Cur.Top-Cur.Bottom		--当前机器Y减去黑边
	elseif initfor==3 then
		DevX=Dev.Height-Dev.Top-Dev.Bottom
		DevY=Dev.Width-Dev.Left-Dev.Right
		CurX=Cur.Height-Cur.Top-Cur.Bottom
		CurY=Cur.Width-Cur.Left-Cur.Right
	end

	Dev.x,Dev.y,Cur.x,Cur.y=DevX,DevY,CurX,CurY
	local XScale = CurX/DevX
	local YScale = CurY/DevY
	local dpiScale = Cur.dpi/Dev.dpi
	local modefunction = function (mode)
		if mode == 'width' then return XScale 
		elseif mode == 'height' then return YScale
		elseif mode == 'dpi' then return dpiScale
		end
	end
	--------------------------------------------------------------------------
	local MainPointScale = {x=nil,y=nil}
	o.Arry.MainPointScale = MainPointScale
	if type(MainPointScaleMode) == 'table' then
		MainPointScale.x = modefunction(MainPointScaleMode.x)
		MainPointScale.y = modefunction(MainPointScaleMode.y)
	elseif type(MainPointScaleMode) == 'string' then
		MainPointScale.x = modefunction(MainPointScaleMode)
		MainPointScale.y = modefunction(MainPointScaleMode)
	else
		print("没有设置锚点缩放模式")
		xmod.exit()
	end	
	local AppurtenantScale = {x=nil,y=nil}
	o.Arry.AppurtenantScale = AppurtenantScale
	if type(AppurtenantScaleMode) == 'table' then
		AppurtenantScale.x = modefunction(AppurtenantScaleMode.x)
		AppurtenantScale.y = modefunction(AppurtenantScaleMode.y)
	elseif type(AppurtenantScaleMode) == 'string' then
		AppurtenantScale.x = modefunction(AppurtenantScaleMode)
		AppurtenantScale.y = modefunction(AppurtenantScaleMode)
	else
		print("没有设置锚点缩放模式")
		xmod.exit()
	end	
	setmetatable(o,{ __index=System} )
	if _const.Arry==nil then _const.Arry=o.Arry end
	return o
end
function System:keep(boole,T)--和scren.keep()一样
	if boole and self.KeepScreen then return end
	slp(T or self.keepTime)	
	screen.keep(boole)
	self.KeepScreen=boole
end
function System:Switchkeep()--一次false,一次true保证是截到最新的页面
	self:keep(false)
	self:keep(true)
end
function System:setKeepTime(T)--设置截图前的延迟
	self.KeepTime=T
end
function System:addSystemData(key,value)
	self.SystemData[key] = value
end
function System:getSystemData() --一些系统的属性,按照需求自己添加
	local UserInfo,code = script.getUserInfo()
	local ScriptInfo, code = script.getScriptInfo()
	local data={
		ver=xmod.PLATFORM,
		dpi=screen.getDPI(),
		screen=screen.getSize(),
		uid=UserInfo.id,
		scriptid=ScriptInfo.id,
		val=runtime.android.getSystemProperty('ro.build.product'),
		code=xmod.PRODUCT_NAME,
	}
	self.SystemData=data
	return data
end
function System:printSelf()--打印自身
	Print(self)
end
function System:getArry()--获取Arry缩放参数
	return self.Arry
end

