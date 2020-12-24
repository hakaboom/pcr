local behavior={}
local Data=require'Data'
local scene=require'scene'

function behavior.寻找章节(当前章节,目标章节)
	if 当前章节<目标章节 then
		Data.下一章:Click()
	elseif 当前章节>目标章节 then
		Data.上一章:Click()
	elseif 当前章节==目标章节 then
		return true
	else
		return false
	end
end

function behavior.寻找关卡(当前关卡,目标关卡)
	if 当前关卡<目标关卡 then
		Data.下一关:Click()
	elseif 当前关卡>目标关卡 then
		Data.上一关:Click()
	elseif 当前关卡==目标关卡 then
		return true
	else
		return false
	end
end

function behavior.前往关卡(目标关卡)
	printf('目标关卡%d',目标关卡)
	for i=1,目标关卡-1 do
		Data.下一关:Click(1)
	end
end

function behavior.领取任务奖励()
	local t={'每日','普通'}
	for i=1,2 do
		while true do
			_K:Switchkeep()
			if Data['任务页面_'..t[i]]:getandCmpColor(true,1) then
				break
			else
				Data['任务页面_'..t[i]]:Click(0.5)
			end
			Data.收取报酬:getandCmpColor(true)
			if Data.冒险:getandCmpColor() then
				Data.主页_我的主页:Click()
			end
			if Data.主页面:getandCmpColor() then
				Data.主页_任务:Click()
			end
			if Data.团队战:getandCmpColor() then
				Data.主页_我的主页:Click()
			end
			sleep(500)
		end
		_K:Switchkeep()
		Data.任务_全部收取:getandCmpColor(true)
	end
end

function behavior.选择支援()
	Data.队伍编组_支援:Click(1)
	Data.队伍编组_支援1号位:Click(1)
end

local 安全认证计时=runTime:new()
math.randomseed(tostring(os.time()):reverse():sub(1,6))
安全认证计时:setcheckTime(0.5)
local 认证次数=0
function behavior.安全认证()
	local img=Data.打码页面:getArea()
	local lz=require'base.lianzhong'
	local index=0
	local idT={}
	while true do
		print('安全认证')
		_K:Switchkeep()
		local id,bool,data=scene.识别安全验证码();Print(id,bool,data)
		idT[#idT+1]=id;认证次数=认证次数+1;index=index+1
		if 认证次数%6==0 then
			lz.error(id)
		end
		if bool then
			验证点=point:newByCur({x=img.x+data[1],y=img.y+data[2]})
			验证点:Click(1)
			Data.安全认证_确认:Click()
			for i=1,20 do
				_K:Switchkeep()
				if Data.打码_验证失败:getandCmpColor() then
					print('检测到错误识别')
					lz.error(id);sleep(5000)
					return
				end
				sleep(150)
			end
			sleep(2000)
			while true do
				_K:Switchkeep()
				if Data.用户协议:getandCmpColor() or Data.主页面:getandCmpColor() then sleep(2000)
					return true
				elseif Data.安全认证:getandCmpColor() then print('还在打码页面');sleep(2000)
					return lz.error(id)
				elseif Data.安全认证_尝试过多:getandCmpColor() then print('次数过多') 
					runtime.killApp('com.bilibili.priconne');sleep(2000)
					return lz.error(id)
				end
				Data.瞎点:Click(0.5)
			end
		end
	end
end


local 礼物盒不为空=false
local 第一次购买体力=true
local 检测礼物盒=0
function behavior.领取礼物()
	_K:Switchkeep()
	if Data.礼物箱_全部收取:getandCmpColor(true,1) then
		礼物盒不为空=true
	end
	if 礼物盒不为空 then
		local 已领取=false
		while true do
			_K:Switchkeep()
			检测礼物盒=检测礼物盒+1
			if 检测礼物盒>6 then
				Data.礼物箱_全部收取:getandCmpColor(true,1);检测礼物盒=0
			end
			if Data.收取礼物_确认:getandCmpColor(true) then 已领取=true end
			if 已领取 then
				if Data.收取礼物_结算:getandCmpColor(true) then 检测礼物盒=0
					礼物盒不为空=false;break
				end
			end
			sleep(500)
		end
	end
	检测礼物盒=0
end

function behavior.购买体力(blackboard)
	if 第一次购买体力==true then 第一次购买体力=false return end
	local index=0
	while true do
		if index==blackboard:getValue('每次补充次数') then Data.瞎点:Click() return end
		_K:Switchkeep()
		if Data.体力回复:getandCmpColor() then sleep(500)
			_K:Switchkeep()
			local 剩余次数=scene.识别剩余次数()
			if 剩余次数 then
				local 总次数=30
				local 已购买次数=总次数-剩余次数
				blackboard:setValue('已补充体力次数',已购买次数)
				if 已购买次数>=blackboard:getValue('补充体力次数') then
					Data.瞎点:Click()
					return
				else
					index=index+1
					Data.体力回复_ok:Click(1)
				end
			end
		else
			Data.主线关卡_体力回复:Click(1)
		end
		sleep(1000)
	end
end

local chttp=require'chttp'.create()
chttp:setTimeout(4000)
local json=require'cjson'
local url='http://106.15.251.100:3457/'
local 装备更新计时=runTime:new()
math.randomseed(tostring(os.time()):reverse():sub(1,6))
装备更新计时:setcheckTime(Base.timeTransform(math.random(3,5),'m','s'))

local taskIdT={
	leveling = 1,
	dungeons = 2,
	weapon = 3,
	mainLine = 4,
}
function behavior.获取农场id(frameName)
	if not frameName then return nil end
	local url=string.urlEncode(url..'frame/'..frameName ..'/id')
	chttp:setUrl(url)
	chttp:setHeader({['Content-Type'] = 'application/json'})
	local ret=chttp:get()
	if ret.text then
		local repost_data = json.decode(ret.text)
		local code =repost_data.code
		if code == 0 then
			return repost_data.data
		end
	end
end
function behavior.获取账号(task)
	assert(task,'没有传入task')
	local url=string.urlEncode(url..'account/apply')
	local post_data=json.encode({
			taskId = taskIdT[task],
			executorId = function_choice.脚本标识,
			levelInterval = {
				left = UI配置.最低等级 or 0,right = UI配置.最高等级 or 999,
			},
			minimumTimeInterval = UI配置.最低间隔时间,
			frameId = behavior.获取农场id(UI配置.指定农场),
		})
	Print(post_data)
	chttp:setUrl(url)
	chttp:setBody(post_data)
	chttp:setHeader({['Content-Type'] = 'application/json'})
	local ret=chttp:post()
	if ret.error.code == 0 then
		Print(ret.text)
	else
		Print(ret)
		调试HUD:show('获取账号超时')
		sleep(math.random(5,10)*1000)
		调试HUD:hide()
		return behavior.获取账号(task)
	end
	if ret.text then
		local bool,repost_data=pcall(json.decode,ret.text)
		local code = repost_data.code
		if code == 0 then	--正常获取
			return repost_data.data
		elseif code == 10015 then --表示改模拟器已获取过任务
			return repost_data.data
		elseif code == 10009 then --表示已无账号可以获取
			if task == 'weapon' then
				while not 装备更新计时:checkTime(true) do
					print('等待计时结束')
					调试HUD:show('等待计时结束')
					sleep(2000)
				end
				调试HUD:hide()
				装备更新计时:setcheckTime(Base.timeTransform(math.random(5,10),'m','s'))
				return behavior.获取账号(task)
			end
			dialog('已刷完')
			xmod.exit()
		else
			sleep(math.random(5,10)*1000)
			return behavior.获取账号(task)
		end
	else
		sleep(math.random(5,10)*1000)
	end
end
function behavior.获取账号完成信息(id)
	local url=string.urlEncode(url..'account/detail/'..math.modf(id))
	chttp:setUrl(url)
	chttp:setHeader({['Content-Type'] = 'application/json'})
	local ret=chttp:get();
	if ret.error.code == 0 then
		Print(ret.text)
	else
		调试HUD:show('获取信息超时')
		sleep(math.random(5,10)*1000)
		调试HUD:hide()
		return behavior.获取账号完成信息(id)
	end
	if ret.text then
		local bool,repost_data=pcall(json.decode,ret.text)
		local code = repost_data.code
		if code == 0 then
			return repost_data.data
		elseif code == 10015 then
			return repost_data.data
		else
			dialog('获取账号完成信息出错')
		end
	end
end
function behavior.验证账号(task)
	local lastData1 = behavior.获取账号(task);sleep(math.random(1,3)*1000)
	while true do
		local newData = behavior.获取账号(task)
		local newID = newData.accountId
		local lastID = lastData1.accountId
		if lastID~=newID then print('两次ID不一致')
			lastData1 = newData
			--不一致则说明获取到了新的账号,用新数据覆盖旧数据
			sleep(1500)
		elseif lastID == newID then print('两次ID一致')
			--一致则说明账号已获取到,直接返回新的
			return newData
		end
	end
end
function behavior.释放账号(id)
	local url=string.urlEncode(url..'account/release/'..math.modf(id)..'?finished=true')
	chttp:setUrl(url)
	chttp:setHeader({['Content-Type'] = 'application/json'})
	local ret=chttp:get()
	Print('释放账号')
	if ret.error.code == 0 then
		print(ret.text)
	else
		调试HUD:show('释放账号超时')
		sleep(math.random(5,10)*1000)
		调试HUD:hide()
		return behavior.释放账号(id)
	end
end
function behavior.删除记录(id)
	local url=string.urlEncode(url..'account/release/'..math.modf(id)..'?finished=false')
	chttp:setUrl(url)
	chttp:setHeader({['Content-Type'] = 'application/json'})
	local ret=chttp:get()
	Print('删除记录')
	if ret.error.code == 0 then
		print(ret.text)
	else
		调试HUD:show('删除记录超时')
		sleep(math.random(5,10)*1000)
		调试HUD:hide()
		return behavior.删除记录(id)
	end
end
function behavior.更新账号(data)
	print('更新账号')
	local url=string.urlEncode(url..'account/update')
	local post_data=json.encode({
			accountId = data.accountId,
			level = data.level,
			diamond = data.diamond
		})
	chttp:setUrl(url)
	chttp:setHeader({['Content-Type'] = 'application/json'})
	chttp:setBody(post_data)
	local ret=chttp:post();Print(ret)
	if ret.error.code == 0 then
		print(ret.text)
	else
		调试HUD:show('更新账号超时')
		sleep(math.random(5,10)*1000)
		调试HUD:hide()
		return behavior.更新账号(data)
	end
	if ret.text then
		local bool,str=pcall(json.decode,ret.text)
		Print(str)
		if type(str) == 'table' then
			if str.code == 0 then
				return true
			else sleep(math.random(5,10)*1000)
				return behavior.更新账号(data)
			end
		end
	end
end


local 卡关章节刷图={
	[4]={11,12},
	[5]={10,13},
	[6]={6,11},
	[7]={2,9},
	[8]={12,14},
	[9]={11}
}
local index=1
function behavior.卡关刷图(卡关章节)
	_K:Switchkeep()
	if Data.关卡页面:getandCmpColor() then
		index=index+1
		behavior.前往关卡(卡关章节刷图[卡关章节][index%2+1])
	end
end
return behavior