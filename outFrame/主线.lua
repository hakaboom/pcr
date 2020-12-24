local Data=require'Behavior.Data'
local scene=require'Behavior.scene'
local behavior=require'Behavior.Behavior'
--[[            黑板创建                 ]]
local 黑板=Blackboard:new()
--[[            黑板变量初始化                 ]]

黑板:setValueBatch({ --在黑板上存一些变量
	['当前场景']='领取任务',
	['当前流程']='初始化页面',
	['任务开始']=false,
	['初始化页面']=true,
	['已刷账号']=1,
	['已邀请']=1,
})
print(">>>>>>>>>>>>>>>>>>>黑板初始化完毕")
--xmod.setOnEventCallback(xmod.EVENT_ON_USER_EXIT,function()
--	Print(黑板:getAllValue())
--	dialog(table.concat(黑板:getAllValue(),'----'))
--end)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--[[            场景和流程的创建和绑定                 ]]
主流程=Sequence:new()--新建主运行流程
local 初始化页面=黑板:createScene()
local 前往行会=黑板:createScene()
local 前往成员信息=黑板:createScene()
local 搜索成员=黑板:createScene()
local 搜索ID=黑板:createScene()
local 退出账号=黑板:createScene()
local 登录账号=黑板:createScene()
local 记录ID=黑板:createScene()
local 重启游戏=黑板:createScene()
主流程:addScene(初始化页面)
主流程:addScene(前往行会)
主流程:addScene(前往成员信息)
主流程:addScene(搜索成员)
主流程:addScene(搜索ID)
主流程:addScene(退出账号)
主流程:addScene(登录账号)
主流程:addScene(记录ID)
主流程:addScene(重启游戏)
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
前往行会:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="前往行会" and blackboard:getValue("当前场景")=="主页面"
	end
	)
前往成员信息:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="前往成员信息" and blackboard:getValue("当前场景")=="行会"
	end
	)
搜索成员:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="搜索成员" and blackboard:getValue("当前场景")=="成员信息"
	end
	)
搜索ID:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="搜索ID" and blackboard:getValue("当前场景")=="玩家ID搜索"
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
记录ID:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="记录ID" and blackboard:getValue("当前场景")=="主页面"
	end
	)
重启游戏:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="重启游戏" and blackboard:getValue("当前场景")=="游戏闪退"
	end
	) 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
local function 全家桶(blackboard)
	_K:Switchkeep()
	local aim=Data.下一步箭头:findColor() 
	if aim then aim:offsetXY(0,160,'withArry') aim:Click(1.5) end
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
	--Data.瞎点:Click()
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
				blackboard:setValue("当前流程","前往行会")
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
		end
		Data.快速跳过:getandCmpColor(true)
		Data.公告:getandCmpColor(true)
		Data.登录页面错误:getandCmpColor(true,1)
		Data.瞎点:Click()
	--全家桶(blackboard)
	sleep(800)
	end
	)
前往行会:getDoingBehavior():setServer(
	function(blackboard) print('前往行会')
	_K:Switchkeep()
		local aim=scene.初始化页面()
		if aim=='主页面' then
			Data.主页_行会:Click()
		elseif aim=='行会_已入会' then
			blackboard:setValue('当前场景','行会')
			return blackboard:setValue('当前流程','前往成员信息')
		end
	全家桶(blackboard)
	sleep(500)
	end
	)
前往成员信息:getDoingBehavior():setServer(
	function(blackboard) print('前往成员信息')
	_K:Switchkeep()
		if Data.行会_已入会:getandCmpColor() then
			Data.行会_成员信息:Click()
		end
		if Data.行会_成员信息:getandCmpColor() then
			blackboard:setValue('当前场景','成员信息')
			return blackboard:setValue('当前流程','搜索成员')
		end
	sleep(500)
	end
	)
local 是否退出=false
退出行会:getDoingBehavior():setServer(
	function(blackboard) print('退出行会')
	_K:Switchkeep()
		if Data.成员信息:getandCmpColor() then
			return Data.成员信息_退出:Click(1)
		end
		if Data.是否退出:getandCmpColor(true) then
			是否退出=true
		end
		Data.退出确认:getandCmpColor(true)
		if 是否退出==true then
			if Data.主页面:getandCmpColor() then
				blackboard:setValue("初始化页面",true)
				return blackboard:setValue('当前流程','退出账号')
			end
		end
	sleep(500)
	end
	)
local 已退出=false
退出账号:getDoingBehavior():setServer(
	function(blackboard) print('退出账号')
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() then
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
			blackboard:setValue('已刷账号',blackboard:getValue('已刷账号')+1)
			return sleep(1000)
		else
			if 已退出 then Data.切换账号:Click() end
		end
	sleep(1000)
	end
	)
登录账号:getDoingBehavior():setServer(
	function(blackboard) print('登录账号');sleep(1000) 已退出=false
		if blackboard:getValue('已刷账号')>#账号列表 then xmod.exit() end
		local 读取账号=behavior.读取账号(blackboard:getValue('已刷账号'));Print(读取账号)
		Data.登录_账号:inputText(读取账号.账号,true);sleep(500)
		Data.登录_密码:inputText(读取账号.密码,true)
		Data.登录_登录:Click()
		
		blackboard:setValue("初始化页面",true)
		blackboard:setValue("任务开始",false) 
	end
	)