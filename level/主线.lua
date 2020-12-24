local Data=require'Data'
local scene=require'scene'
local behavior=require'Behavior'
--[[            黑板创建                 ]]
local 黑板=Blackboard:new()
--[[            黑板变量初始化                 ]]


黑板:setValueBatch({ --在黑板上存一些变量
	['当前场景']='领取任务',
	['当前流程']='初始化页面',
	['任务开始']=false,
	['初始化页面']=true,
	['目标章节']=1,
	['目标关卡']=1,
	['当前章节']=1,
	['当前关卡']=1,
	['刷新请求次数']=0,
	['刷图模式']=UI配置.刷图模式==1 and '扫荡' or '挑战',
	['购买mana']=UI配置.是否购买mana,
	['购买mana次数']=tonumber(UI配置.mana购买次数) or 0,
	['补充体力次数']=tonumber(UI配置.补充体力次数) or 0,
	['已补充体力次数']=0,
	['每次补充次数']=tonumber(UI配置.每次补充体力次数>0 and UI配置.每次补充体力次数 or 1),
	['最低等级']=tonumber(UI配置.最低等级) or 1,
	['最高等级']=tonumber(UI配置.最高等级) or 999,
})
print(">>>>>>>>>>>>>>>>>>>黑板初始化完毕")
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--[[            场景和流程的创建和绑定                 ]]
主流程=Sequence:new()--新建主运行流程
local 初始化页面,重启游戏=黑板:createScene(),黑板:createScene()
local 前往主线,购买mana=黑板:createScene(),黑板:createScene()
local 寻找章节,寻找关卡=黑板:createScene(),黑板:createScene()
local 领公会之家体力=黑板:createScene()
local 战斗中,战斗结束=黑板:createScene(),黑板:createScene()
local 领取礼物,领取任务奖励=黑板:createScene(),黑板:createScene()
local 退出账号,登录账号,记录ID=黑板:createScene(),黑板:createScene(),黑板:createScene()
local 读取钻石,读取主页钻石=黑板:createScene(),黑板:createScene()
local 刷图=黑板:createScene()
local 卡关,卡关_刷图,卡关_扫荡,卡关_等待扫荡结束=黑板:createScene(),黑板:createScene(),黑板:createScene(),黑板:createScene()
local 卡关_检查是否解锁=黑板:createScene()
local 结束领取奖励=黑板:createScene()
local 结束刷图=黑板:createScene()
local 兰德索尔竞速=黑板:createScene()
主流程:addScene(兰德索尔竞速) 
主流程:addScene(初始化页面) 
主流程:addScene(读取主页钻石)
主流程:addScene(重启游戏)
主流程:addScene(前往主线)
主流程:addScene(领取任务奖励)
主流程:addScene(领取礼物)
主流程:addScene(领公会之家体力)
主流程:addScene(战斗中)
主流程:addScene(战斗结束)
主流程:addScene(刷图)
主流程:addScene(购买mana)
主流程:addScene(寻找章节)
主流程:addScene(寻找关卡)
主流程:addScene(退出账号)
主流程:addScene(登录账号) 
主流程:addScene(记录ID)
主流程:addScene(结束领取奖励)
主流程:addScene(读取钻石)
主流程:addScene(卡关)
主流程:addScene(卡关_刷图)
主流程:addScene(卡关_扫荡)
主流程:addScene(卡关_等待扫荡结束)
主流程:addScene(卡关_检查是否解锁)
主流程:addScene(结束刷图)
print("场景流程初始化完毕")
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--[[             场景的触发器设定               ]]
初始化页面:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("初始化页面")==true and blackboard:getValue("当前场景")~="主页面"
	end
	)
重启游戏:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="重启游戏" and blackboard:getValue("当前场景")=="游戏闪退"
	end
	) 
前往主线:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="前往主线" and blackboard:getValue("当前场景")=="主页面"
	end
	)
领取礼物:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="领取礼物" and blackboard:getValue("当前场景")=="主页面"
	end
	)
领取任务奖励:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="领取任务奖励" and blackboard:getValue("当前场景")=="主页面"
	end
	)
领公会之家体力:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="领公会之家体力" and blackboard:getValue("当前场景")=="主页面"
	end
	)
购买mana:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="购买mana" and blackboard:getValue("当前场景")=="主页面"
	end
	)
寻找章节:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="寻找章节" and blackboard:getValue("当前场景")=="主线关卡"
	end
	)
寻找关卡:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="寻找关卡" and blackboard:getValue("当前场景")=="关卡页面"
	end
	)
战斗中:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="等待战斗结束" and blackboard:getValue("当前场景")=="战斗中"
	end
	)
战斗结束:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="战斗结束" and blackboard:getValue("当前场景")=="战斗结算"
	end
	)
退出账号:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="退出账号" and blackboard:getValue("当前场景")=="主页面"
	end
	)
登录账号:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="登录账号" and blackboard:getValue("当前场景")=="登陆页面"
	end
	)
卡关:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="卡关" and blackboard:getValue("当前场景")=="关卡页面"
	end
	)
卡关_刷图:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="卡关_刷图" and blackboard:getValue("当前场景")=="关卡页面"
	end
	)
卡关_扫荡:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="卡关_扫荡" and blackboard:getValue("当前场景")=="关卡页面"
	end
	)
卡关_等待扫荡结束:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="卡关_等待扫荡结束" and blackboard:getValue("当前场景")=="扫荡确认"
	end
	)
卡关_检查是否解锁:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="卡关_检查是否解锁" and blackboard:getValue("当前场景")=="关卡页面"
	end
	)
记录ID:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="记录ID" and blackboard:getValue("当前场景")=="主页面"
	end
	)
刷图:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="刷图" and blackboard:getValue("当前场景")=="关卡页面"
	end
	)
结束刷图:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="结束刷图" and blackboard:getValue("当前场景")=="获得道具"
	end
	)
读取钻石:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="读取钻石" and blackboard:getValue("当前场景")=="主页面"
	end
	)
读取主页钻石:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="读取主页钻石" and blackboard:getValue("当前场景")=="主页面"
	end
	)
结束领取奖励:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="结束领取奖励" and blackboard:getValue("当前场景")=="主页面"
	end
	)
兰德索尔竞速:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="兰德索尔竞速" and blackboard:getValue("当前场景")=="兰德索尔竞速"
	end
	)	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
local function 全家桶(blackboard)
	_K:Switchkeep()
--	local aim=Data.下一步箭头:findColor() 
--	if aim then aim:offsetXY(0,160,'withArry') aim:Click(1.5) end
	Data.数据下载:getandCmpColor(true)
	if Data.剧情中:getandCmpColor(true,1) then 
		Data.剧情跳过:Click(1)
	end
	_K:Switchkeep()
	Data.弹窗:getandCmpColor(true)
	if Data.探索页面:getandCmpColor() then print('在探索页面')
		Data.主页_我的主页:Click(1)
		blackboard:setValue('初始化页面',true)
		return blackboard:setValue("当前流程","前往主线")		
	end
	_K:Switchkeep()
	if Data.加入行会:getandCmpColor() then
		Data.主页_我的主页:Click()
		blackboard:setValue('当前流程','前往主线')
		return blackboard:setValue('初始化页面',true)
	end
	if Data.竞技场:getandCmpColor() then
		blackboard:setValue('当前流程','前往主线')	
		return blackboard:setValue('初始化页面',true)	
	end
	if Data.购买玛那:getandCmpColor() then
		return Data.购买玛那_取消:Click()
	end
	if Data.商店:getandCmpColor() then
		blackboard:setValue('当前流程','前往主线')	
		return blackboard:setValue('初始化页面',true)	
	end
	Data.瞎点:Click()
end
local 初始化表_主页={'冒险','主线关卡','行会','任务页面','礼物','公会之家','技能强化','地下城','竞技场','商店','简介','团队战','行会_已入会'}
local 初始化表_分页={'公告','限定商店','等级提升'}
初始化页面:getDoingBehavior():setServer( --确保页面在我的主页
	function(blackboard) print('初始化页面')
	_K:Switchkeep()
		local aim=scene.初始化页面()
		if aim=='主页面' then print('已在主页')
			blackboard:setValue("当前场景","主页面")
			blackboard:setValue('初始化页面',false)
			if blackboard:getValue('任务开始')==false then
				blackboard:setValue("当前流程","领取任务奖励")
				blackboard:setValue("任务开始",true) 
			end
		elseif aim=='登录页面' then
			blackboard:setValue("当前场景","登陆页面")
			blackboard:setValue("初始化页面",false) 
			return blackboard:setValue("当前流程","登录账号")
		elseif table.contain(初始化表_主页,aim,'v') then
			return Data.主页_我的主页:Click(0.5)
		elseif table.contain(初始化表_分页,aim,'v') then
			return Data[aim]:Click(0.5)
		elseif aim=='关卡页面' then
			return Data.关卡页面_取消:Click(0.5)
		elseif aim=='安全认证' then
			return behavior.安全认证()
		elseif aim=='网络不给力' then
			return Data.网络不给力_回退:Click()
		elseif aim=='网络异常' then
			return Data.网络异常_回退:Click()
		elseif aim=='移动协议_异常' then
			return Data.移动协议_回退：Click()
		end
		if Data.兰德索尔竞速:getandCmpColor()  then print('兰德索尔竞速') --or Data.竞速开始:getandCmpColor()
			blackboard:setValue("当前场景","兰德索尔竞速")
			blackboard:setValue("初始化页面",false) 
			return blackboard:setValue("当前流程","兰德索尔竞速")
		end
		if Data.用户协议:getandCmpColor() then
			Data.移动协议:move();sleep(1000)
			Data.用户协议确定:Click(1)
			return 
		end
		Data.快速跳过:getandCmpColor(true)
		Data.公告:getandCmpColor(true)
		Data.登录页面错误:getandCmpColor(true,1)
		Data.瞎点:Click()
	--全家桶(blackboard)
	sleep(800)
	end
	)
local 重启尝试次数=0
重启游戏:getDoingBehavior():setServer( --游戏闪退
	function(blackboard) print('重启游戏')
	while true do
		_K:Switchkeep()
		if Data.登录页面:getandCmpColor() then
			blackboard:setValue('当前流程','登录账号')
			return blackboard:setValue('当前场景','登陆页面')
		else
			Data.切换账号:Click()
		end
		if Data.安全认证:getandCmpColor() then
			Data.退回打码页面:Click()
		end
		sleep(1000)
		重启尝试次数=重启尝试次数+1
		if 重启尝试次数>100 then 重启尝试次数=0 return end
	end
	end
	)
领取任务奖励:getDoingBehavior():setServer(
	function(blackboard) print('领取任务奖励');Data.瞎点:Click(1)
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() then
			return Data.主页_任务:Click(1)
		end
		if Data.任务页面:getandCmpColor() then
			behavior.领取任务奖励()
			blackboard:setValue('当前场景','任务页面')
			blackboard:setValue('初始化页面',true);print('领取任务完毕')
			return blackboard:setValue('当前流程','领取礼物')
		end
	sleep(500)
	end
	)
领取礼物:getDoingBehavior():setServer(
	function(blackboard) print('领取礼物')
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() then
			return Data.主页_礼物:Click(1)
		end
		if Data.礼物箱:getandCmpColor() then
			behavior.领取礼物()
			blackboard:setValue('当前场景','礼物盒')
			blackboard:setValue('初始化页面',true);print('领取礼物完毕')
			return blackboard:setValue('当前流程','领公会之家体力')
		end
	sleep(500)
	end
	)
领公会之家体力:getDoingBehavior():setServer(
	function(blackboard)  print('领公会之家体力')
	_K:Switchkeep()
	Data.收取礼物_结算:getandCmpColor(true)
		if Data.公会之家:getandCmpColor() then sleep(1000)
			Data.公会之家_全部收取:Click(1)
			blackboard:setValue('初始化页面',true)
			return blackboard:setValue('当前流程','读取主页钻石')
		end
		if Data.主页面:getandCmpColor() then
			if Data.公会之家_未解锁:getandCmpColor() then print('公会之家未解锁')
				blackboard:setValue('初始化页面',true)
				return blackboard:setValue('当前流程','读取主页钻石')
			else
				Data.主页_公会之家:Click()
			end
		end
		if Data.冒险:getandCmpColor() then
			Data.主页_我的主页:Click()
		end
		Data.瞎点:Click()
		sleep(500)
	end
	)
购买mana:getDoingBehavior():setServer(
	function(blackboard) print('购买mana')
	_K:Switchkeep()
		if blackboard:getValue('购买mana')==false or blackboard:getValue('购买mana')==nil or blackboard:getValue('购买mana次数')==0 then 
			return blackboard:setValue("当前流程","前往主线")
		end
		if Data.主页面:getandCmpColor() then
			return Data.主页_购买玛那:Click()
		end
		if Data.冒险:getandCmpColor() then
			return Data.主页_我的主页:Click()
		end
		if Data.购买玛那:getandCmpColor() then
			local 已购买次数=scene.识别mana剩余次数()
			if 已购买次数==false then
				---
			elseif 已购买次数==0 then 
				Data.购买玛那1次:Click(2)
			elseif 已购买次数>=blackboard:getValue('购买mana次数') then
				Data.购买玛那_取消:Click()
				blackboard:setValue("当前流程","前往主线")
				return
			else 
				Data.购买玛那10次:Click(2)
			end
			Data.体力回复_ok:Click(1)
		else
			Data.购买Mana_瞎点:Click()
		end
		Data.Mana购买确认:getandCmpColor(true,1)
		Data.公告:getandCmpColor(true)
		Data.收取礼物_结算:getandCmpColor(true)
	sleep(500)
	end
	)
读取主页钻石:getDoingBehavior():setServer(
	function(blackboard) print('读取主页钻石')
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() then
			local 剩余钻石=scene.识别主页面钻石()
			if 剩余钻石 then
				if 剩余钻石>3000 then
					printf('剩余钻石:%d',剩余钻石)
					blackboard:getValue('购买mana',UI配置.是否购买mana)
					blackboard:setValue('购买mana次数',tonumber(UI配置.mana购买次数) or 0)
					blackboard:setValue('补充体力次数',tonumber(UI配置.补充体力次数) or 0)
				else
					blackboard:getValue('购买mana',false)
					blackboard:setValue('购买mana次数',0)
					blackboard:setValue('补充体力次数',0)
				end
				return blackboard:setValue("当前流程","购买mana")
			else
				print('没识别到钻石')
			end
		else
			Data.主页_我的主页:Click()
		end
	sleep(1000)
	end
	)
前往主线:getDoingBehavior():setServer(
	function(blackboard) print('前往主线')
	_K:Switchkeep()
		local aim=scene.前往主线关卡() 
		if aim=='主页面' then
			return Data.主页_冒险:Click()
		elseif aim=='冒险' then
			return Data.冒险_主线关卡:Click()
		elseif aim=='主线关卡' then
			blackboard:setValue('初始化页面',false)
			blackboard:setValue('当前场景','主线关卡')
			return blackboard:setValue('当前流程','寻找章节')
		end
		if Data.购买玛那:getandCmpColor() then
			Data.购买玛那_取消:Click()
		end
	Data.瞎点_前往主线:Click()
	sleep(500)
	end
	)
local 寻找章节次数=0
寻找章节:getDoingBehavior():setServer(
	function(blackboard) print('寻找章节')
	Data.移动地图:move();sleep(500)
	_K:Switchkeep()
		if Data.HARD:getandCmpColor() then Data.normal:Click(3) return end
		local 识别结果=scene.识别章节()
		if 识别结果 ~= false then
			if tonumber(识别结果)==1 then 寻找章节次数=0
				blackboard:setValue('当前章节',识别结果)
				blackboard:setValue('当前流程','刷图')
				return blackboard:setValue('当前场景','关卡页面')			
			else
				return Data.上一章:Click(0.5)
			end
		end
	寻找章节次数=寻找章节次数+1
	if 寻找章节次数>10 then
		if Data.关卡页面:getandCmpColor() then
			Data.关卡页面_取消:Click();寻找章节次数=0
		end
		if Data.主页面:getandCmpColor() then
			blackboard:setValue("当前场景","主页面");寻找章节次数=0
			return blackboard:setValue("当前流程","前往主线")
		end
	end
	--全家桶(blackboard)
	Data.瞎点:Click()
	sleep(1000)
	end
	)
寻找关卡:getDoingBehavior():setServer( --只刷1-1
	function(blackboard) print('寻找关卡')	
	_K:Switchkeep()
		if Data.关卡页面:getandCmpColor() then
			behavior.前往关卡(blackboard:getValue('目标关卡'))
			blackboard:setValue('当前流程','刷图')
			return blackboard:setValue('当前场景','关卡页面')
		else
			return Data.关卡一图:ChoiceClick(blackboard:getValue('目标章节'),1)
		end
	end
	)
刷图:getDoingBehavior():setServer(
	function(blackboard) print('寻找关卡')	
	_K:Switchkeep()
		if not Data.主线关卡:getandCmpColor() then
			Data.瞎点取消关卡页面:Click()
		else
			blackboard:setValue('当前流程','卡关_刷图')
			if  blackboard:getValue('补充体力次数')>0 or blackboard:getValue('已补充体力次数')<blackboard:getValue('补充体力次数') then
				behavior.购买体力(blackboard)
			end
			return 
		end
	sleep(500)
	end
	)
卡关_刷图:getDoingBehavior():setServer(
	function(blackboard) print('卡关_刷图')
	_K:Switchkeep()
		if Data.关卡页面:getandCmpColor() then
			return blackboard:setValue('当前流程','卡关_扫荡')
		else
			return Data.关卡一图:ChoiceClick(1,1)
		end
	sleep(500)
	end
	)
local 识别关卡次数=0
卡关_扫荡:getDoingBehavior():setServer(
	function(blackboard)	print('卡关_扫荡')
	_K:Switchkeep()
		if 	Data.无法扫荡:getandCmpColor() and blackboard:getValue('刷图模式')=='扫荡' then
			blackboard:setValue('当前场景','关卡页面')
			return blackboard:setValue('当前流程','卡关_检查是否解锁')
		else
			if blackboard:getValue('刷图模式')=='扫荡' then
				Data.关卡页面_增加扫荡券:touchHold(6);sleep(0.5)
				Data.关卡页面_使用扫荡券:Click(2)
				Data.扫荡券确认:Click(1)
				blackboard:setValue('当前流程','卡关_等待扫荡结束')
				return blackboard:setValue('当前场景','扫荡确认')
			elseif blackboard:getValue('刷图模式')=='挑战' then
				Data.关卡页面_挑战:Click(1.5)
				blackboard:setValue('当前流程','等待战斗结束');识别关卡次数=0
				return blackboard:setValue('当前场景','战斗中')
			end
		end
	end
	)
local 扫荡结束=false
local 等待扫荡次数=0
卡关_等待扫荡结束:getDoingBehavior():setServer(
	function(blackboard)	print('等待扫荡结束')
	_K:Switchkeep()
		if Data.扫荡确认:getandCmpColor(true) then 扫荡结束=true
			return 
		end
		Data.超出上限道具:getandCmpColor(true)
		Data.扫荡券确认:getandCmpColor(true)
		Data.团队战CP:getandCmpColor(true)
		Data.扫荡跳过:getandCmpColor(true)
		Data.等级提升:getandCmpColor(true)
		Data.限定商店:getandCmpColor(true)
		if 扫荡结束 then
			if Data.关卡页面:getandCmpColor() then 扫荡结束=false;等待扫荡次数=0
				blackboard:setValue('当前场景','关卡页面')
				return blackboard:setValue('当前流程','卡关_检查是否解锁')
			end
			Data.瞎点_扫荡:Click()
		end 
		if 等待扫荡次数>=4 and 扫荡结束==false then
			if Data.关卡页面:getandCmpColor() then 等待扫荡次数=0
				if 	Data.无法扫荡:getandCmpColor() then
					blackboard:setValue('当前场景','关卡页面')
					return blackboard:setValue('当前流程','卡关_检查是否解锁')
				else
					return Data.关卡页面_使用扫荡券:Click(2)
				end
			end
			if Data.冒险:getandCmpColor() then
				return Data.冒险_主线关卡:Click(1)
			end
			if Data.主页面:getandCmpColor() then
				return Data.主页_冒险:Click(1)
			end
			if Data.体力不足_挑战:getandCmpColor() then
				Data.体力不足_挑战:Click()
				blackboard:setValue('当前流程','结束领取奖励')
				return blackboard:setValue("初始化页面",true) 			
			end
		end 
		sleep(700);等待扫荡次数=等待扫荡次数+1
	end
	)
卡关_检查是否解锁:getDoingBehavior():setServer(
	function(blackboard) print('卡关_检查是否解锁')
	_K:Switchkeep()
		if blackboard:getValue('已补充体力次数')>=blackboard:getValue('补充体力次数') then
			blackboard:setValue('当前流程','结束领取奖励')
			blackboard:setValue("初始化页面",true) 
			return blackboard:setValue('当前场景','关卡页面')
		end
		if Data.关卡页面:getandCmpColor() or Data.主线关卡:getandCmpColor() then
			return blackboard:setValue('当前流程','刷图')
		end
	Data.瞎点取消关卡页面:Click()
	sleep(500)
	end
	)
结束领取奖励:getDoingBehavior():setServer(
	function(blackboard) print('结束领取奖励');Data.瞎点:Click(1)
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() then
			Data.主页_任务:Click(2)
		end
		if Data.任务页面:getandCmpColor() then
			behavior.领取任务奖励()
			blackboard:setValue('当前场景','任务页面')
			blackboard:setValue('初始化页面',true);print('领取任务完毕')
			return blackboard:setValue('当前流程','读取钻石')
		end
		if Data.团队战:getandCmpColor() then
			Data.主页_我的主页:Click()
		end
	sleep(500)
	end
	)
local 战斗开始=false
local 识别到主线关卡=0
local 识别到关卡页面=0
战斗中:getDoingBehavior():setServer(
	function(blackboard) print('战斗中')	
	_K:Switchkeep()
		if blackboard:getValue('刷图模式')=='挑战' then
		if Data.体力不足_挑战:getandCmpColor(true) then
			blackboard:setValue('当前场景','获得道具')
			blackboard:setValue("初始化页面",true) 
			return blackboard:setValue('当前流程','结束领取奖励')
		end
		end
		if Data.战斗中:getandCmpColor() then
			Data.战斗中_两倍速:getandCmpColor(true)
		end
		if Data.战斗结束:getandCmpColor() then
			战斗开始=false;识别到主线关卡=0
			blackboard:setValue('当前流程','战斗结束')
			return blackboard:setValue('当前场景','战斗结算')		
		end
		if 战斗开始==true then
			if Data.关卡页面:getandCmpColor() then
				Data.战斗开始:Click();识别到主线关卡=0
			end
			if Data.主线关卡:getandCmpColor() then
				识别到主线关卡=识别到主线关卡+1
				if 识别到主线关卡>10 then 识别到主线关卡=0
					blackboard:setValue('当前场景','主线关卡')
					return blackboard:setValue('当前流程','寻找章节')
				end
			end
		else
			if Data.关卡页面:getandCmpColor() then
				识别到关卡页面=识别到关卡页面+1
				if 识别到关卡页面>10 then 识别到关卡页面=0
					Data.战斗开始:Click()
				end
			end
		end
		if Data.战斗_队伍编组:getandCmpColor() then
			Data.战斗开始:Click();战斗开始=true
		end
	Data.等级提升:getandCmpColor(true)
	Data.战斗中瞎点:Click()
	sleep(500)
	end
	)
战斗结束:getDoingBehavior():setServer( --循环刷图
	function(blackboard) print('战斗结束')	
	_K:Switchkeep()
		if Data.战斗结束:getandCmpColor() then
			return Data.下一步:Click(1)
		end
		if Data.获得道具:getandCmpColor() then
			return Data.再次挑战:Click(1)
		end
		if Data.关卡重试:getandCmpColor(true,1) then
			return 
		end
		Data.快速跳过:getandCmpColor(true)
		Data.团队战CP:getandCmpColor(true)
		Data.限定商店:getandCmpColor(true)
		Data.等级提升:getandCmpColor(true)
		if Data.体力不足_挑战:getandCmpColor(true) then
			blackboard:setValue('当前场景','获得道具')
			return blackboard:setValue('当前流程','结束刷图')
		end
		if Data.主线关卡:getandCmpColor() then
			blackboard:setValue('当前流程','结束领取奖励')
			return blackboard:setValue("初始化页面",true) 
		end
		Data.战斗中瞎点:Click()
	sleep(500)
	end
	)
结束刷图:getDoingBehavior():setServer(
	function(blackboard) print('战斗结束')	
	_K:Switchkeep()
		Data.关卡重试:getandCmpColor(true,1)
		if Data.获得道具:getandCmpColor() or Data.战斗结束:getandCmpColor() then
			return Data.下一步:Click(0.5)
		end
		if Data.主线关卡:getandCmpColor() then
			blackboard:setValue('当前流程','结束领取奖励')
			return blackboard:setValue("初始化页面",true) 
		end
	Data.战斗结束_瞎点:Click()
	sleep(500)
	end
	)
记录ID:getDoingBehavior():setServer(
	function(blackboard) print('记录ID')
	_K:Switchkeep()
		if Data.主菜单:getandCmpColor() then
			Data.主菜单_简介:Click(1)
			while true do
			_K:Switchkeep()
				if not Data.简介:getandCmpColor() then
					Data.主菜单_简介:Click()
				else
					--for i=1,10 do Data.简介:Click(0.1) end;
					blackboard:getValue('当前账号').level=scene.识别等级()
					blackboard:setValue('当前流程','退出账号')
					blackboard:setValue('当前场景','简介')
					return blackboard:setValue("初始化页面",true)
				end
			end
		else
			Data.主页_主菜单:Click(1)
		end
	sleep(1000)
	end
	)
读取钻石:getDoingBehavior():setServer(
	function(blackboard) print('读取钻石')
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() then
			blackboard:getValue('当前账号').diamond=scene.识别主页面钻石()
			Print(blackboard:getValue('当前账号'))
			blackboard:setValue('当前流程','记录ID')
			blackboard:setValue('当前场景','主页面')
		else
			Data.主页_我的主页:Click(1)
		end
	sleep(1000)
	end
	)
local 已退出=false
退出账号:getDoingBehavior():setServer(
	function(blackboard) print('退出账号')
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() or Data.冒险:getandCmpColor() then
			return Data.主页_主菜单:Click(0.5)
		end
		if Data.简介:getandCmpColor() then
			return Data.主页_主菜单:Click(2)
		end
		if Data.主菜单:getandCmpColor() then
			Data.主菜单_回到标题画面:Click(2)
		end
		_K:Switchkeep()
		if Data.确认回到标题:getandCmpColor(true) then
			已退出=true
		end
		if Data.登录页面:getandCmpColor()then 
			已退出=false
			blackboard:setValue('当前流程','登录账号')
			blackboard:setValue('当前场景','登陆页面')
			blackboard:setValue("初始化页面",false)
			blackboard:setValue('已补充体力次数',0)
			第一次购买体力=true --Behavior购买体力参数
			Print(blackboard:getValue('当前账号'))
			behavior.更新账号(blackboard:getValue('当前账号'))
			return behavior.释放账号(blackboard:getValue('当前账号').accountId)
		else
			if 已退出 then
				Data.登录页面错误:getandCmpColor(true,1)
				Data.切换账号:Click() 
			end
		end
		if Data.安全认证:getandCmpColor() then
			Data.退回打码页面:Click()
		end
	sleep(1000)
	end
	)
登录账号:getDoingBehavior():setServer(
	function(blackboard) print('登录账号')  已退出=false
		local 读取账号=behavior.验证账号('leveling')
		blackboard:setValue('当前账号',读取账号)
		Data.登录_账号:inputText(读取账号.account,true);sleep(500)
		Data.登录_密码:inputText(读取账号.password,true)
		Data.登录_登录:Click(2)
		_K:Switchkeep()
		Print(blackboard:getValue('当前账号'))
		blackboard:setValue("初始化页面",true)
		return blackboard:setValue("任务开始",false) 
	end
	)
兰德索尔竞速:getDoingBehavior():setServer(
	function(blackboard) print('兰德索尔竞速')
		_K:Switchkeep()
		if Data.主页面:getandCmpColor() then print('已在主页')
			blackboard:setValue("当前场景","主页面")
			blackboard:setValue('初始化页面',false)
			if blackboard:getValue('任务开始')==false then 
				blackboard:setValue("当前流程","领取任务奖励")
				blackboard:setValue("任务开始",true) 
			end
		elseif aim=='登录页面' then
			blackboard:setValue("当前场景","登陆页面")
			blackboard:setValue("初始化页面",false) 
			return blackboard:setValue("当前流程","登录账号")
		end
		if Data.兰德索尔竞速:getandCmpColor() then
			Data.兰德索尔竞速_一号位:Click()
		end
		Data.竞速开始:getandCmpColor(true)
		Data.快速跳过:getandCmpColor(true)
		Data.公告:getandCmpColor(true)
		Data.登录页面错误:getandCmpColor(true,1)
		Data.瞎点:Click()
	sleep(800)
	end
	)