local Data=require'Data'
local scene=require'scene'
local behavior=require'Behavior'
--[[            黑板创建                 ]]
local 黑板=Blackboard:new()
--[[            黑板变量初始化                 ]]

黑板:setValueBatch({ --在黑板上存一些变量
	['当前场景']='领取任务',
	['当前流程']='初始化页面',
	['目标章节']=UI配置.结束关卡.章节,
	['目标关卡']=UI配置.结束关卡.关卡,
	['当前章节']=1,
	['当前关卡']=1,
	['任务开始']=false,
	['初始化页面']=true,
	['刷新请求次数']=0,
	['已刷账号']=1,
	['补充体力次数']=0,
	['已补充体力次数']=0,
	['购买mana次数']=0
})
print(">>>>>>>>>>>>>>>>>>>黑板初始化完毕")
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--[[            场景和流程的创建和绑定                 ]]
主流程=Sequence:new()--新建主运行流程
local 初始化页面=黑板:createScene()
local 前往主线,购买mana=黑板:createScene(),黑板:createScene()
local 寻找章节,寻找关卡=黑板:createScene(),黑板:createScene()
local 检查三星,战斗中,战斗结束=黑板:createScene(),黑板:createScene(),黑板:createScene()
local 退出账号,登录账号,记录ID=黑板:createScene(),黑板:createScene(),黑板:createScene()
local 等待地下城=黑板:createScene()
local 卡关,卡关_刷图,卡关_扫荡,卡关_等待扫荡结束=黑板:createScene(),黑板:createScene(),黑板:createScene(),黑板:createScene()
local 卡关_检查是否解锁,重启游戏=黑板:createScene(),黑板:createScene()
local 兰德索尔竞速=黑板:createScene()
主流程:addScene(兰德索尔竞速) 
主流程:addScene(初始化页面)
主流程:addScene(重启游戏)
主流程:addScene(前往主线)
主流程:addScene(战斗中)
主流程:addScene(战斗结束)
主流程:addScene(购买mana)
主流程:addScene(寻找章节)
主流程:addScene(寻找关卡)
主流程:addScene(退出账号)
主流程:addScene(登录账号) 
主流程:addScene(卡关)
主流程:addScene(卡关_刷图)
主流程:addScene(卡关_扫荡)
主流程:addScene(卡关_等待扫荡结束)
主流程:addScene(卡关_检查是否解锁)
主流程:addScene(等待地下城)
主流程:addScene(记录ID)
print("场景流程初始化完毕")
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--[[
	领任务----领礼物----领体力---刷图----送装备----换号
]]
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
等待地下城:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="等待地下城" and blackboard:getValue("当前场景")=="战斗中"
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
兰德索尔竞速:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="兰德索尔竞速" and blackboard:getValue("当前场景")=="兰德索尔竞速"
	end
	)	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
local function 全家桶(blackboard)
	_K:Switchkeep()
	local aim=Data.下一步箭头:findColor() 
	if aim then aim:offsetXY(0,160,'withArry') aim:Click(1.5) end
	if Data.内容解锁:getandCmpColor() then
		Data.内容解锁:Click() print('内容解锁')
	end
	Data.数据下载:getandCmpColor(true)
	if Data.剧情中:getandCmpColor(true,1) then 
		Data.剧情跳过:Click(1)
	end
	_K:Switchkeep()
	Data.弹窗:getandCmpColor(true)
	if Data.技能强化:getandCmpColor() then print('技能强化')
		Data.主页_我的主页:Click(1)
		blackboard:setValue('初始化页面',true)
		return blackboard:setValue("当前流程","前往主线")
	end
	if Data.探索页面:getandCmpColor() then print('在探索页面')
		Data.主页_我的主页:Click(1)
		blackboard:setValue('初始化页面',true)
		return blackboard:setValue("当前流程","前往主线")		
	end
	_K:Switchkeep()
	if Data.云海的山脉:getandCmpColor() then
		Data.撤退:Click(2);Data.撤退确认:Click(1)
		blackboard:setValue('初始化页面',true)
		return  blackboard:setValue('当前流程','前往主线')
	end
	_K:Switchkeep()
	if Data.加入行会:getandCmpColor() then print('加入行会')
		Data.主页_我的主页:Click()
		blackboard:setValue('当前流程','记录ID')
		return blackboard:setValue('初始化页面',true)
	end
	if Data.购买玛那:getandCmpColor() then
		return Data.购买玛那_取消:Click()
	end
	if Data.竞技场:getandCmpColor() then
		blackboard:setValue('当前流程','前往主线')	
		return blackboard:setValue('初始化页面',true)	
	end
	if Data.商店:getandCmpColor() then
		blackboard:setValue('当前流程','前往主线')	
		return blackboard:setValue('初始化页面',true)	
	end
	if Data.公会之家:getandCmpColor() then
		blackboard:setValue('当前流程','前往主线')	
		return blackboard:setValue('初始化页面',true)	
	end
	Data.瞎点:Click()
end
local 初始化表_主页={'冒险','主线关卡','行会','任务页面','礼物','公会之家','技能强化','地下城','竞技场','商店','简介'}
local 初始化表_分页={'公告','限定商店','等级提升'}
初始化页面:getDoingBehavior():setServer( --确保页面在我的主页
	function(blackboard) print('初始化页面')
	_K:Switchkeep()
		local aim=scene.初始化页面()
		if aim=='主页面' then print('已在主页')
			blackboard:setValue("当前场景","主页面")
			blackboard:setValue('初始化页面',false)
			if blackboard:getValue('任务开始')==false then
				blackboard:setValue("当前流程","前往主线")
				blackboard:setValue("任务开始",true) 
			end
		elseif aim=='登录页面' then
			blackboard:setValue("当前场景","登陆页面")
			blackboard:setValue("初始化页面",false) 
			return blackboard:setValue("当前流程","登录账号")
		elseif table.contain(初始化表_主页,aim,'v') then
			Data.主页_我的主页:Click()
		elseif table.contain(初始化表_分页,aim,'v') then
			Data[aim]:Click()
		elseif aim=='关卡页面' then
			Data.关卡页面_取消:Click()
		end
		if Data.兰德索尔竞速:getandCmpColor() or Data.竞速开始:getandCmpColor() then print('兰德索尔竞速')
			blackboard:setValue("当前场景","兰德索尔竞速")
			blackboard:setValue("初始化页面",false) 
			return blackboard:setValue("当前流程","兰德索尔竞速")
		end
		Data.瞎点:Click()
	全家桶(blackboard)
	sleep(600)
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
		sleep(1000)
		重启尝试次数=重启尝试次数+1
		if 重启尝试次数>100 then 重启尝试次数=0 return end
	end
	end
	)
购买mana:getDoingBehavior():setServer(
	function(blackboard) print('购买mana')
	_K:Switchkeep()
		if blackboard:getValue('购买mana')==false or blackboard:getValue('购买mana')==nil then 
			return blackboard:setValue("当前流程","前往主线")
		end
		if Data.购买玛那:getandCmpColor() then
			local 已购买次数=scene.识别mana剩余次数()
			if 已购买次数==false then
			
			elseif 已购买次数==0 then 
				Data.购买玛那1次:Click(1.5)
			elseif 已购买次数>=blackboard:getValue('购买mana次数') then
				Data.购买玛那_取消:Click()
				blackboard:setValue("当前流程","前往主线")
				return
			else 
				Data.购买玛那10次:Click(1.5)
			end
			Data.体力回复_ok:Click(1)
		else
			Data.主页_购买玛那:Click()
		end
		Data.公告:getandCmpColor(true)
	sleep(500)
	end
	)
前往主线:getDoingBehavior():setServer(
	function(blackboard) print('前往主线')
	_K:Switchkeep()
		local aim=scene.初始化页面()
		if aim=='主页面' then
			Data.主页_冒险:Click()
		elseif aim=='冒险' then
			Data.冒险_主线关卡:Click()
		elseif aim=='剧情' then
			Data.主页_冒险:Click()
		elseif aim=='活动页面' then
			Data.主页_冒险:Click()
		elseif aim=='主线关卡' then
			blackboard:setValue('当前场景','主线关卡')
			blackboard:setValue('当前流程','寻找章节')
		end
	Data.瞎点_前往主线:Click()
	sleep(500)
	end
	)
local 寻找章节次数=0
寻找章节:getDoingBehavior():setServer(
	function(blackboard) print('寻找章节')
	Data.移动地图:move();sleep(1000)
	_K:Switchkeep()
		if Data.HARD:getandCmpColor() then Data.normal:Click(3) return end
		local 识别结果=scene.识别章节()
		if 识别结果 ~= false then
			blackboard:setValue('当前章节',识别结果)
			Data.关卡一图:ChoiceClick(识别结果)
			sleep(1000)
			blackboard:setValue('当前流程','寻找关卡')
			return blackboard:setValue('当前场景','关卡页面')
		end
	寻找章节次数=寻找章节次数+1
	if 寻找章节次数>7 then
		if Data.关卡页面:getandCmpColor() then
			Data.关卡页面_取消:Click();寻找章节次数=0
		end
		if Data.冒险:getandCmpColor() then
			blackboard:setValue("当前场景","主页面");寻找章节次数=0
			return blackboard:setValue("当前流程","前往主线")
		end
		if Data.主页面:getandCmpColor() then
			blackboard:setValue("当前场景","主页面");寻找章节次数=0
			return blackboard:setValue("当前流程","前往主线")
		end
	end
	全家桶(blackboard)
	sleep(1000)
	end
	)
local 识别关卡次数=0
寻找关卡:getDoingBehavior():setServer(
	function(blackboard)	
	_K:Switchkeep()
		if Data.关卡页面:getandCmpColor() then
			if Data.地图三星:getandCmpColor() then print('地图没三星')
				Data.关卡页面_挑战:Click(1.5)
				blackboard:setValue('当前流程','等待战斗结束')
				blackboard:setValue('当前关卡',1);识别关卡次数=0
				return blackboard:setValue('当前场景','战斗中')
			else 
				Print('当前关卡:'..blackboard:getValue('当前关卡'))
				if blackboard:getValue('当前关卡') >= blackboard:getValue('目标关卡') and blackboard:getValue('当前章节') == blackboard:getValue('目标章节') then
					Data.关卡页面_取消:Click();识别关卡次数=0;blackboard:setValue('当前关卡',1)
					blackboard:setValue('当前流程','退出账号')
					blackboard:setValue("当前场景","主页面")
					return blackboard:setValue('初始化页面',true)
				end
				Data.下一关:Click(0.5)
				blackboard:setValue('当前关卡',blackboard:getValue('当前关卡')+1)
			
--				local aim=scene.Boss关卡()
--				if aim==false or aim==true then
--					Data.下一关:Click(0.5)
--				elseif aim=='卡关' then	print('等级不够卡关了')
--					Data.关卡页面_取消:Click();识别关卡次数=0;blackboard:setValue('当前关卡',1)
--					blackboard:setValue('当前流程','退出账号')
--					blackboard:setValue("当前场景","主页面")
--					return blackboard:setValue('初始化页面',true)
--					blackboard:setValue('当前流程','卡关');识别关卡次数=0
--					return blackboard:setValue('当前场景','关卡页面')
--				end
			end
		end
	if 识别关卡次数>10 then
		if Data.主线关卡:getandCmpColor() then
			blackboard:setValue('当前场景','主线关卡');识别关卡次数=0
			return blackboard:setValue('当前流程','寻找章节')	
		end
	end
	sleep(300);识别关卡次数=识别关卡次数+1
	end
	)
local 体力购买次数={
	[4]=1,[5]=1,[6]=1,[7]=1,[8]=1,[9]=1,
}
卡关:getDoingBehavior():setServer(
	function(blackboard) print('卡关')
	_K:Switchkeep()
		if not Data.主线关卡:getandCmpColor() then
			Data.瞎点取消关卡页面:Click()
		else
			Data.移动地图:move();sleep(1)
			local aim=scene.识别当前准确章节()
			if tonumber(aim)==8 then print('退出账号')
				blackboard:setValue('当前流程','记录ID')
				blackboard:setValue("初始化页面",true) 
				return
			end
			if aim then
				printf('当前卡在%d关',tonumber(aim))
				blackboard:setValue('卡关章节',tonumber(aim))
				blackboard:setValue('当前流程','卡关_刷图')
				behavior.购买体力(体力购买次数[tonumber(aim)])
				blackboard:setValue('已补充体力次数',blackboard:getValue('已补充体力次数')+体力购买次数[tonumber(aim)])
			else
				
			end
		end
	sleep(500)
	end
	)
卡关_刷图:getDoingBehavior():setServer(
	function(blackboard) print('卡关_刷图')
	_K:Switchkeep()
		if Data.关卡页面:getandCmpColor() then
			behavior.卡关刷图(blackboard:getValue('卡关章节'))
			blackboard:setValue('当前流程','卡关_扫荡')
			return
		else
			Data.移动地图:move();sleep(1)
			Data.关卡一图:ChoiceClick(blackboard:getValue('卡关章节'),1)
		end
	sleep(500)
	end
	)
卡关_扫荡:getDoingBehavior():setServer(
	function(blackboard)	print('卡关_扫荡')
		Data.关卡页面_增加扫荡券:touchHold(4)
		Data.关卡页面_使用扫荡券:Click(2)
		Data.扫荡券确认:Click()
		blackboard:setValue('当前流程','卡关_等待扫荡结束')
		blackboard:setValue('当前场景','扫荡确认')
	end
	)
local 扫荡结束=false
卡关_等待扫荡结束:getDoingBehavior():setServer(
	function(blackboard)	print('卡关_等待扫荡结束')
_K:Switchkeep()
		if Data.扫荡确认:getandCmpColor(true) then
			扫荡结束=true
		end
		Data.扫荡券确认:getandCmpColor(true)
	if 扫荡结束==true then
		local aim=scene.初始化页面()
		if aim=='等级提升' or aim=='限定商店' then Data[aim]:Click(1) end
		if Data.关卡页面:getandCmpColor() then 扫荡结束=false
			blackboard:setValue('当前场景','关卡页面')
			blackboard:setValue('当前流程','卡关_检查是否解锁')
		end
	end
		Data.超出上限道具:getandCmpColor(true,1)
	sleep(500)
	end
	)
卡关_检查是否解锁:getDoingBehavior():setServer(
	function(blackboard) print('卡关_检查是否解锁')
	_K:Switchkeep()
		if Data.主线关卡:getandCmpColor() then
			Data.移动地图右到左:move();sleep(1)
			Data.关卡末图:ChoiceClick(blackboard:getValue('卡关章节'))
		end
		if Data.关卡页面:getandCmpColor() then 
			local aim=scene.Boss关卡()
			if aim==true then
				Data.下一关:Click()
				blackboard:setValue('当前流程','寻找关卡')
				blackboard:setValue('当前场景','关卡页面')
				return
			elseif aim=='卡关' then
				blackboard:setValue('当前流程','卡关')
				blackboard:setValue('当前场景','关卡页面')	
				return
			else Data.瞎点取消关卡页面:Click()
			end
		end
	Data.瞎点:Click()
	sleep(500)
	end
	)
	

local 补充过体力=false
local 战斗开始=false
local 识别到主线关卡=0
战斗中:getDoingBehavior():setServer(
	function(blackboard) print('战斗中')	
	_K:Switchkeep()
		if Data.战斗中:getandCmpColor() then
			Data.战斗中_两倍速:getandCmpColor(true)
		end
		if Data.战斗结束:getandCmpColor() then
			战斗开始=false;识别到主线关卡=0
			blackboard:setValue('当前流程','战斗结束')
			return blackboard:setValue('当前场景','战斗结算')		
		end
		if Data.体力回复:getandCmpColor() then
			Data.体力回复_ok:Click(1)
		end
		if Data.弹窗:getandCmpColor() then
			Data.体力回复_ok:Click(1.5)
			Data.体力回复_ok:Click(1)
			补充过体力=true
--			blackboard:setValue('当前流程','寻找关卡');识别到主线关卡=0
--			return  blackboard:setValue('当前场景','关卡页面')
		end
		if 补充过体力==true then
			if Data.关卡页面:getandCmpColor() then
				Data.关卡页面_挑战:Click(1.5)
				补充过体力=false
			end
		end
		if 战斗开始==true then
			if Data.关卡页面:getandCmpColor() then
				Data.战斗开始:Click();识别到主线关卡=0
			end
			if Data.主线关卡:getandCmpColor() then
				识别到主线关卡=识别到主线关卡+1
				if 识别到主线关卡>15 then 识别到主线关卡=0
					blackboard:setValue('当前场景','主线关卡')
					return blackboard:setValue('当前流程','寻找章节')
				end
			end
		else
			if Data.关卡页面:getandCmpColor() then
				Data.战斗开始:Click();识别到主线关卡=0
			end
		end
		if Data.战斗_队伍编组:getandCmpColor() then
			Data.战斗开始:Click();战斗开始=true
		end
	Data.瞎点:Click()
	sleep(500)
	end
	)
战斗结束:getDoingBehavior():setServer(
	function(blackboard) print('战斗结束')	
	_K:Switchkeep()
		if Data.战斗结束:getandCmpColor() or Data.获得道具:getandCmpColor() then
			Data.下一步:Click(1)
			return 
		end
		if Data.主线关卡:getandCmpColor() then
			blackboard:setValue('当前场景','主线关卡')
			return blackboard:setValue('当前流程','寻找章节')
		end
		if Data.主页面:getandCmpColor() then
			blackboard:setValue('当前场景','主页面')
			return blackboard:setValue('当前流程','前往主线')		
		end
		if Data.冒险:getandCmpColor() then
			Data.冒险_主线关卡:Click(1)
		end
		全家桶(blackboard)
		Data.瞎点:Click()
	sleep(500)
	end
	)
记录ID:getDoingBehavior():setServer(
	function(blackboard) print('记录ID')
	_K:Switchkeep()
	blackboard:setValue('当前流程','退出账号')
	blackboard:setValue('当前场景','简介')
	return blackboard:setValue("初始化页面",true)
	end
	)
local 已退出=false
退出账号:getDoingBehavior():setServer(
	function(blackboard) print('退出账号')
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() or Data.主线关卡:getandCmpColor() then
			return Data.主页_主菜单:Click(0.5)
		end
		if Data.主菜单:getandCmpColor() then
			Data.主菜单_回到标题画面:Click(1)
		end
		if Data.确认回到标题:getandCmpColor(true) then
			已退出=true
		end
		if Data.登录页面:getandCmpColor()then
			blackboard:setValue('当前流程','登录账号')
			blackboard:setValue('当前场景','登陆页面')
			blackboard:setValue("初始化页面",false)
			behavior.更新账号(blackboard:getValue('当前账号'))
			return behavior.释放账号(blackboard:getValue('当前账号').accountId)
		else
			if 已退出 then Data.切换账号:Click() end
		end
	sleep(1000)
	end
	)
登录账号:getDoingBehavior():setServer(
	function(blackboard) print('登录账号')  已退出=false
		local 读取账号=behavior.验证账号('mainLine')
		blackboard:setValue('当前账号',读取账号)
		Data.登录_账号:inputText(读取账号.account,true);sleep(500)
		Data.登录_密码:inputText(读取账号.password,true)
		Data.登录_登录:Click()
		_K:Switchkeep()
		Print(blackboard:getValue('当前账号'))
		blackboard:setValue("初始化页面",true)
		return blackboard:setValue("任务开始",false) 
	end
	)
等待地下城:getDoingBehavior():setServer(
	function(blackboard)
	_K:Switchkeep()
		if Data.战斗结束:getandCmpColor() then
			Data.下一步:Click()
		end
		if Data.云海的山脉:getandCmpColor() then sleep(1000)
			Data.撤退:Click(2)
			Data.撤退确认:Click(1)
			blackboard:setValue("当前流程","前往主线")
			blackboard:setValue('初始化页面',true)
		end
	Data.瞎点:Click()
	sleep(500)
	end
	)	
兰德索尔竞速:getDoingBehavior():setServer(
	function(blackboard) print('兰德索尔竞速')
		_K:Switchkeep()
		if Data.主页面:getandCmpColor() then print('已在主页')
			blackboard:setValue("当前场景","主页面")
			blackboard:setValue('初始化页面',false)
			if blackboard:getValue('任务开始')==false then 
				blackboard:setValue("当前流程","前往主线")
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