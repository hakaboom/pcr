local scene={}
local Data=require'Data'
local baiduOCR=require'baiduOCR.BaiduOCR'

function scene.初始化页面()
	local a={'主页面','冒险','主线关卡','团队战','登录页面','行会','剧情',
	'公告','任务页面','商店','礼物箱','关卡页面','限定商店','等级提升',
	'公会之家','技能强化','地下城','竞技场','简介','行会_已入会','行会_成员信息',
	'活动页面','活动关卡页面','活动任务页面','安全认证','网络不给力','网络异常','移动协议_异常'}
	for k,v in pairs(a) do
		local b=Data[v]:getandCmpColor()
		if b==true then return v end
	end
end

function scene.前往地下城()
	local a={'主页面','冒险','地下城','云海的山脉'}
	for k,v in pairs(a) do
		local b=Data[v]:getandCmpColor()
		if b==true then return v end
	end
end

function scene.前往主线关卡()
	local a={'主页面','冒险','主线关卡'}
	for k,v in pairs(a) do
		local b=Data[v]:getandCmpColor()
		if b==true then return v end
	end
end

function scene.识别章节()
	_K:Switchkeep()
	for index=1,#Data.地图数据 do
		local indexError = 0
		local aim = Data.地图数据[index];
		for i=1,#aim do
			local point = aim[i];
			local newpoint=point:newByCur({x=point:getXY().x,y=point:getXY().y,color=0x7b7963,fuzz=95}); 
			if not point:getandCmpColor() then 
				if newpoint:getandCmpColor() then
					--true
				else
					indexError = indexError + 1
				end
			end
			if indexError>3 then break end
		end
		if indexError<=2 then printf('当前在章节%d',index) return index end
	end
	return false
end

function scene.识别活动地图()
	_K:Switchkeep()
	for k,v in pairs(Data.活动地图) do
		local indexError = 0
		local aim = v
		for i=1,#aim do
			local point = aim[i];
			local newpoint=point:newByCur({x=point:getXY().x,y=point:getXY().y,color=0x7b7963}); 
			if not point:getandCmpColor() then 
				if newpoint:getandCmpColor() then
					--true
				else
					indexError = indexError + 1
				end
			end
			if indexError>3 then break end
		end
		if indexError<=2 then printf('当前在活动关卡%s',k) return k,true end
	end
end

local ocr=OCR:new()
function scene.识别剩余次数()
	local 回复次数=ocr:getText({Rect=Data.回复次数:getArea(),diff={'0xffffff-0x111111'},white="1234567890/"})
	--local 回复次数=baiduOCR.getText(Data.回复次数:getArea())
	if not 回复次数 then return false end
	local now,max=string.match(回复次数,"(%d+)/(%d+)")
	now = tonumber(now) and tonumber(now) or false
	return now
end

function scene.识别mana剩余次数()
	local 剩余次数=ocr:getText({Rect=Data.购买玛那:getArea(),diff={'0xffffff-0x222222'},white="1234567890/"})
	--local 回复次数=baiduOCR.getText(Data.购买玛那:getArea())
	if 剩余次数 == '' then
		剩余次数=baiduOCR.getText(Data.购买玛那:getArea())
	end
	if not 剩余次数 then return false end
	local now,max=string.match(剩余次数,"(%d+)/(%d+)")
	now = tonumber(now) and tonumber(now) or false
	return now
end

function scene.识别地下城次数()	
	local 剩余次数=baiduOCR.getText(Data.地下城次数:getArea())
	if not 剩余次数 then return false end
	local now,max=string.match(剩余次数,"(%d+)/(%d+)")
	now = tonumber(now) and tonumber(now) or false
	return now	
end

function scene.识别等级()
	local level=baiduOCR.getText(Data.玩家等级:getArea())
	if not level or not tonumber(level) then --sleep(1000)
		return 0 --scene.识别等级()
	else
		return tonumber(level)
	end
end

function scene.识别钻石()
	local 钻石=baiduOCR.getText(Data.主菜单_钻石:getArea()) --
	if not 钻石 then return false end
	local t={}
	for s in string.gmatch(钻石,'%d') do t[#t+1]=s end
	钻石=tonumber(table.concat(t))
	return 钻石
end
 
function scene.识别主页面钻石()
	local 钻石=baiduOCR.getText(Data.主页面_钻石:getArea())
	if not 钻石 then sleep(1500) return scene.识别主页面钻石() end
	local t={}
	for s in string.gmatch(钻石,'%d') do
		t[#t+1]=s
	end
	钻石=tonumber(table.concat(t))
	return 钻石
end

function scene.检测三星()
	return Data.地图三星:getandCmpColor() and true or false
end

function scene.Boss关卡()
	_K:Switchkeep()
	if Data.Boss:getandCmpColor() then
		if Data.下一关按钮识别:findColor() then
			return true
		else
			return '卡关'
		end
	end
	return false
end

function scene.识别当前准确章节()
	_K:Switchkeep()
	for k,v in pairs(Data.地图数据) do
		if v:getandCmpColor() then return k end
	end
	return false
end

function scene.识别安全验证码()
	local lz=require'base.lianzhong'
	_K:Switchkeep()
	local request=lz.ocr(Data.打码页面:getArea())
	print('识别验证码')
	if not request then  --没识别到
		return -1,false
	end
	--排错
	local val,id=request.val,request.id
	if type(val)=='string' then
		local 坐标=string.split(val,'|') --拆分多结果
		if #坐标>=1 then	--如果多个
			坐标=坐标[1]
		else		
			return id,false
		end
		坐标=string.split(坐标,',')
		return id,true,坐标
	end
	return id,false
end

return scene