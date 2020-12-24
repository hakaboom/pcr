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
	['刷新请求次数']=0,
	['已刷账号']=1,
})
print(">>>>>>>>>>>>>>>>>>>黑板初始化完毕")
xmod.setOnEventCallback(xmod.EVENT_ON_USER_EXIT,function()
	Print(黑板:getAllValue())
	dialog(table.concat(黑板:getAllValue(),'----'))
end)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--[[            场景和流程的创建和绑定                 ]]
主流程=Sequence:new()--新建主运行流程
local 初始化页面,重启游戏=黑板:createScene(),黑板:createScene()
local 前往地下城=黑板:createScene()
local 进入地下城=黑板:createScene()
local 战斗中,战斗结束=黑板:createScene(),黑板:createScene()
local 战斗结束,撤退=黑板:createScene(),黑板:createScene()
local 检查三星,确认战斗开始=黑板:createScene(),黑板:createScene()
local 退出账号,登录账号=黑板:createScene(),黑板:createScene()
local 开始挑战=黑板:createScene()
local 兰德索尔竞速=黑板:createScene()
主流程:addScene(初始化页面);主流程:addScene(前往地下城);主流程:addScene(进入地下城);主流程:addScene(重启游戏)
主流程:addScene(战斗中);主流程:addScene(战斗结束)
主流程:addScene(退出账号);主流程:addScene(登录账号)
主流程:addScene(开始挑战);主流程:addScene(确认战斗开始);主流程:addScene(撤退)
主流程:addScene(兰德索尔竞速)
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
前往地下城:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="前往地下城" and blackboard:getValue("当前场景")=="主页面"
	end
	)
进入地下城:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="进入地下城" and blackboard:getValue("当前场景")=="地下城"
	end
	)
开始挑战:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="开始挑战" and blackboard:getValue("当前场景")=="云海的山脉"
	end
	)
确认战斗开始:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="确认战斗开始" and blackboard:getValue("当前场景")=="队伍编组"
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
撤退:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="撤退" and blackboard:getValue("当前场景")=="云海的山脉"
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
	Data.数据下载:getandCmpColor(true)
	if Data.剧情中:getandCmpColor(true,1) then 
		Data.剧情跳过:Click(1)
	end
	if Data.商店:getandCmpColor() then
		return Data.主页_冒险:Click(0.5)
	end	
	if Data.公告:getandCmpColor() then
		Data.瞎点:Click()
	end
	_K:Switchkeep()
	Data.弹窗:getandCmpColor(true)
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
				blackboard:setValue("当前流程","前往地下城")
				return blackboard:setValue("任务开始",true) 
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
		if Data.安全认证:getandCmpColor() then
			Data.退回打码页面:Click()
		end
		sleep(1000)
		重启尝试次数=重启尝试次数+1
		if 重启尝试次数>100 then 重启尝试次数=0 return end
	end
	end
	)
前往地下城:getDoingBehavior():setServer(
	function(blackboard) print('前往地下城')
	_K:Switchkeep()
		local aim=scene.前往地下城()
		if aim=='主页面' then
			Data.主页_冒险:Click()
		elseif aim=='冒险' then
			Data.冒险_地下城:Click()
		elseif aim=='地下城' then
			blackboard:setValue('当前场景','地下城')
			return blackboard:setValue('当前流程','进入地下城')
		elseif aim=='云海的山脉' then
			blackboard:setValue('当前场景','云海的山脉')
			return blackboard:setValue('当前流程','撤退')
		end
	全家桶(blackboard)
	Data.瞎点:Click()
	sleep(500)
	end
	)
进入地下城:getDoingBehavior():setServer(
	function(blackboard) print('进入地下城')
	_K:Switchkeep()
		if Data.地下城:getandCmpColor() then
			local 挑战次数=scene.识别地下城次数()
			if 挑战次数==0 then
				blackboard:setValue('当前场景','地下城')
				blackboard:setValue('当前流程','退出账号')
				return blackboard:setValue("初始化页面",true)
			elseif 挑战次数==1 then
				Data.云海的山脉:Click(1)
				Data.区域选择确定:Click(1)
				blackboard:setValue('当前场景','云海的山脉')
				return blackboard:setValue('当前流程','开始挑战')
			end
		else
		end
		if Data.商店:getandCmpColor() then
			return Data.商店_地下城:Click(0.5)
		end
		if Data.商店:getandCmpColor() then
			return Data.主页_冒险:Click(0.5)
		end
	Data.瞎点:Click()
	sleep(500)
	end
	)
local 进入地下城=false
开始挑战:getDoingBehavior():setServer(
	function(blackboard) print('开始挑战')
	_K:Switchkeep()
		if Data.商店:getandCmpColor() then
			return Data.商店_地下城:Click(0.5)
		end
		if Data.地下城:getandCmpColor() then
			Data.云海的山脉:Click(1)
			return Data.区域选择确定:Click(1)
		end
		if Data.云海的山脉:getandCmpColor() then 进入地下城=true
			Data.云海第一层:Click(1)
			return  Data.大树第一层:Click()
		end
		if Data.关卡页面_地下城:getandCmpColor() then
			return Data.关卡页面_挑战:Click(1)
		end
		if Data.队伍编组:getandCmpColor() then
			if not Data.战斗开始:getandCmpColor() then 进入地下城=false
				blackboard:setValue('当前场景','队伍编组')
				return blackboard:setValue('当前流程','确认战斗开始')
			else
				Data.队伍编组_成员1号位:Click(0.5)
			end
		end
		if Data.商店:getandCmpColor() then
			return Data.商店_地下城:Click(0.5)
		end
		if Data.冒险:getandCmpColor() then
			return Data.冒险_地下城:Click(0.5)
		end
		if 进入地下城 then
			Data.瞎点_开始挑战:Click()
		else
			Data.区域选择确定:Click()
		end
	全家桶(blackboard)
	sleep(500)
	end
	)
确认战斗开始:getDoingBehavior():setServer(
	function(blackboard) print('确认战斗开始')	
	_K:Switchkeep()
		Data.战斗开始:getandCmpColor(true)
		if Data.队伍编组:getandCmpColor() then
			if Data.队伍编组_支援:getandCmpColor(false,0.5) then
				if Data.队伍编组_支援1号位:getandCmpColor(true,0.5) then
					return 
				else
					return Data.队伍编组_支援2号位:Click(0.5)
				end
			else
				return 
			end
		end
		
		if Data.支援角色确认:getandCmpColor(true) then
			blackboard:setValue('当前场景','战斗中')
			return blackboard:setValue('当前流程','等待战斗结束')	
		end
		if Data.战斗结束:getandCmpColor() then
			blackboard:setValue('当前场景','战斗中')
			return blackboard:setValue('当前流程','等待战斗结束')		
		end
	sleep(500)
	end
	)
--local 补充过体力=false
战斗中:getDoingBehavior():setServer(
	function(blackboard) print('战斗中')	
	_K:Switchkeep()
		if Data.战斗中_地下城:getandCmpColor() then
			return Data.战斗中_菜单按钮:Click(1)
		end
		if Data.战斗中_菜单:getandCmpColor() then
			return Data.战斗中_放弃:Click(1)
		end
		if Data.战斗中_放弃关卡:getandCmpColor() then
			Data.战斗中_放弃:Click(1)
			blackboard:setValue('当前流程','战斗结束')
			return blackboard:setValue('当前场景','战斗结算')
		end	
		
		Data.战斗中_两倍速:getandCmpColor(true,1)
		Data.三倍速:getandCmpColor(true,1)
		Data.支援角色确认:getandCmpColor(true)
		if Data.战斗结束_地下城:getandCmpColor() then
			blackboard:setValue('当前流程','战斗结束')
			return blackboard:setValue('当前场景','战斗结算')		
		end
		if Data.战斗失败:getandCmpColor(true) then
			blackboard:setValue('当前流程','战斗结束')
			return blackboard:setValue('当前场景','战斗结算')		
		end
		if Data.战斗_队伍编组:getandCmpColor() then
			Data.战斗开始:Click()
		end
		------错误修复
		if Data.主菜单:getandCmpColor() then
			runtime.killApp('com.bilibili.priconne') --关闭游戏
			blackboard:setValue("初始化页面",false) 
			blackboard:setValue('当前流程','重启游戏')
			blackboard:setValue('当前场景','游戏闪退')
			return 
		end
	Data.瞎点:Click()
	sleep(500)
	end
	)
战斗结束:getDoingBehavior():setServer(
	function(blackboard) print('战斗结束')	
	_K:Switchkeep()
		if Data.战斗结束_地下城:getandCmpColor() or Data.获得道具:getandCmpColor() then
			return Data.下一步:Click(1)
		end
		if Data.战斗中_放弃关卡:getandCmpColor() then
			return Data.战斗中_放弃:Click(1)
		end	
		if Data.云海的山脉:getandCmpColor() then
			blackboard:setValue('当前场景','云海的山脉')
			return blackboard:setValue('当前流程','撤退')	
		end
		全家桶(blackboard)
		Data.瞎点:Click()
	sleep(500)
	end
	)
撤退:getDoingBehavior():setServer(
	function(blackboard) print('撤退')
	_K:Switchkeep()
		if Data.云海的山脉:getandCmpColor() then
			Data.撤退:Click(2)
			Data.体力回复_ok:Click(1)
		end
		if Data.关卡页面_地下城:getandCmpColor() then
			Data.关卡页面_取消:Click()
		end
		Data.收取报酬:getandCmpColor(true)
		Data.撤退确认:getandCmpColor(true)
		if Data.地下城:getandCmpColor() then
			blackboard:setValue("任务开始",true) 
			blackboard:setValue('当前场景','地下城')
			blackboard:setValue("初始化页面",true) 
			return blackboard:setValue('当前流程','退出账号')	
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
		if Data.主菜单:getandCmpColor() then
			Data.主菜单_回到标题画面:Click(2)
		end
		_K:Switchkeep()
		if Data.确认回到标题:getandCmpColor(true) then
			已退出=true
		end
		if Data.登录页面:getandCmpColor()then
			blackboard:setValue('当前流程','登录账号')
			blackboard:setValue('当前场景','登陆页面')
			blackboard:setValue("初始化页面",false);已退出=false
			behavior.释放账号(blackboard:getValue('当前账号').accountId)
			return sleep(1000)
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
	function(blackboard) print('登录账号') 已退出=false
		local 读取账号=behavior.验证账号('dungeons')
		blackboard:setValue('当前账号',读取账号)
		Data.登录_账号:inputText(读取账号.account,true);sleep(500)
		Data.登录_密码:inputText(读取账号.password,true)
		Data.登录_登录:Click(2)
		_K:Switchkeep()
		blackboard:setValue("初始化页面",true)
		blackboard:setValue("任务开始",false) 
	end
	)
兰德索尔竞速:getDoingBehavior():setServer(
	function(blackboard) print('兰德索尔竞速')
		_K:Switchkeep()
		if Data.主页面:getandCmpColor() then print('已在主页')
			blackboard:setValue("当前场景","主页面")
			blackboard:setValue('初始化页面',false)
			if blackboard:getValue('任务开始')==false then 
				blackboard:setValue("当前流程","前往地下城")
				return blackboard:setValue("任务开始",true) 
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