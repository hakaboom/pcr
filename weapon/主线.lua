local Data=require'Data'
local scene=require'scene'
local behavior=require'Behavior'
--[[            黑板创建                 ]]
local 黑板=Blackboard:new()
--[[            黑板变量初始化                 ]]

黑板:setValueBatch({ --在黑板上存一些变量
	['当前场景']='领取任务',
	['当前流程']='初始化页面',
--	['目标章节']=UI配置.章节选择,
--	['目标关卡']=UI配置.关卡选择,
	['任务开始']=false,
	['初始化页面']=true,
	['刷新请求次数']=0,
	['已刷账号']=1,
	['捐赠开关']=UI配置.捐赠开关,
	['刷图开关']=UI配置.刷图开关,
	['补充体力次数']=tonumber(UI配置.补充体力次数) or 0,
	['已补充次数']=0,
})
print(">>>>>>>>>>>>>>>>>>>黑板初始化完毕")
xmod.setOnEventCallback(xmod.EVENT_ON_USER_EXIT,function()
	dialog(table.concat(黑板:getAllValue(),'\t'))
end)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--[[            场景和流程的创建和绑定                 ]]
主流程=Sequence:new()--新建主运行流程
local 初始化页面=黑板:createScene()
local 重启游戏=黑板:createScene()
local 购买体力=黑板:createScene()
local 领取任务奖励=黑板:createScene()
local 领取礼物=黑板:createScene()
local 领公会之家体力=黑板:createScene()
local 前往主线=黑板:createScene()
local 寻找章节=黑板:createScene()
local 寻找关卡=黑板:createScene()
local 检查三星=黑板:createScene()
local 开始扫荡=黑板:createScene()
local 扫荡确认=黑板:createScene()
local 等待扫荡结束=黑板:createScene()
local 前往行会=黑板:createScene()
local 捐赠装备=黑板:createScene()
local 退出账号=黑板:createScene()
local 登录账号=黑板:createScene()
local 兰德索尔竞速=黑板:createScene()
主流程:addScene(初始化页面)
主流程:addScene(重启游戏)
主流程:addScene(购买体力)
主流程:addScene(领取任务奖励)
主流程:addScene(领取礼物)
主流程:addScene(领公会之家体力)
主流程:addScene(前往主线)
主流程:addScene(寻找章节)
主流程:addScene(寻找关卡)
主流程:addScene(检查三星)
主流程:addScene(检查三星)
主流程:addScene(扫荡确认)
主流程:addScene(开始扫荡)
主流程:addScene(等待扫荡结束)
主流程:addScene(前往行会)
主流程:addScene(捐赠装备)
主流程:addScene(退出账号)
主流程:addScene(登录账号) 
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
购买体力:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue('当前流程')=='购买体力' and blackboard:getValue("当前场景")=="主页面"
	end
	)
领取任务奖励:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="领取任务奖励" and blackboard:getValue("当前场景")=="主页面"
	end
	)
领取礼物:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="领取礼物" and blackboard:getValue("当前场景")=="主页面"
	end
	)
领公会之家体力:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="领公会之家体力" and blackboard:getValue("当前场景")=="主页面"
	end
	)
前往主线:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="前往主线" and blackboard:getValue("当前场景")=="主页面"
	end
	)
寻找章节:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="寻找章节" and blackboard:getValue("当前场景")=="主线关卡"
	end
	)
寻找关卡:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="寻找关卡" and blackboard:getValue("当前场景")=="主线关卡"
	end
	)
检查三星:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="检查三星" and blackboard:getValue("当前场景")=="关卡页面"
	end
	)
开始扫荡:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="开始扫荡" and blackboard:getValue("当前场景")=="关卡页面"
	end
	)
等待扫荡结束:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="等待扫荡结束" and blackboard:getValue("当前场景")=="扫荡确认"
	end
	)
前往行会:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="前往行会" and blackboard:getValue("当前场景")=="主页面"
	end
	)
捐赠装备:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="捐赠装备" and blackboard:getValue("当前场景")=="行会页面"
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
兰德索尔竞速:getStartTrigger():setRule(
	function(blackboard)
		return blackboard:getValue("当前流程")=="兰德索尔竞速" and blackboard:getValue("当前场景")=="兰德索尔竞速"
	end
	)
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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
				blackboard:setValue("当前流程","购买体力")
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
购买体力:getDoingBehavior():setServer( 
	function(blackboard) print('购买体力')
	if blackboard:getValue("补充体力次数")==0 then blackboard:setValue("当前流程","领取任务奖励") return end
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() then
			Data.主页_购买体力:Click(2);_K:Switchkeep()
			if Data.体力回复:getandCmpColor() then
				local 剩余次数=scene.识别剩余次数()
				if 剩余次数==false then
				
				elseif 剩余次数>blackboard:getValue("补充体力次数") then printf('剩余次数%d次,补充%d次',剩余次数,blackboard:getValue("补充体力次数"))
					Data.体力回复_ok:Click();blackboard:setValue('已补充次数',blackboard:getValue('已补充次数')+1)
				elseif 剩余次数<blackboard:getValue("补充体力次数") then
					Data.瞎点:Click(1)
					return blackboard:setValue("当前流程","领取任务奖励")
				end
			else
				Data.瞎点:Click(1)
			end
		end
		if blackboard:getValue('已补充次数')>=blackboard:getValue("补充体力次数") then
			Data.瞎点:Click(1)
			return blackboard:setValue("当前流程","领取任务奖励")
		end
		sleep(500)
	end
	)
领取任务奖励:getDoingBehavior():setServer(
	function(blackboard) print('领取任务奖励');Data.瞎点:Click(1)
	_K:Switchkeep()
		if Data.主页面:getandCmpColor() then
			Data.主页_任务:Click(1)
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
			Data.主页_礼物:Click(1)
		end
		if Data.礼物箱:getandCmpColor() then
		_K:Switchkeep()
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
			if blackboard:getValue('刷图开关')==true then
				return blackboard:setValue('当前流程','前往主线')
			else
				return blackboard:setValue('当前流程','前往行会')
			end
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
		if Data.剧情中:getandCmpColor(true,1) then 
			Data.剧情跳过:Click(1)
		end
		Data.弹窗:getandCmpColor(true)
	sleep(500)
	end
	)
前往主线:getDoingBehavior():setServer(
	function(blackboard) print('前往主线')
	_K:Switchkeep()
		local aim=scene.初始化页面()
		if aim=='主页面' or aim=='公会之家'then
			Data.主页_冒险:Click()
		elseif aim=='冒险' then
			Data.冒险_主线关卡:Click()
		elseif aim=='主线关卡' then
			blackboard:setValue('初始化页面',false)
			blackboard:setValue('当前场景','主线关卡')
			return blackboard:setValue('当前流程','寻找章节')
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
			if behavior.寻找章节(识别结果,blackboard:getValue('当前账号').chapter)==true then 寻找章节次数=0
				blackboard:setValue('当前流程','寻找关卡')
				return
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
	Data.瞎点:Click()
	sleep(1000)
	end
	)
寻找关卡:getDoingBehavior():setServer(
	function(blackboard) print('寻找关卡')	
	_K:Switchkeep()
		if Data.关卡页面:getandCmpColor() then
			behavior.前往关卡(blackboard:getValue('当前账号').stage)
			blackboard:setValue('当前流程','检查三星')
			return blackboard:setValue('当前场景','关卡页面')
		else
			Data.移动地图:move()sleep(1000)
			Data.关卡一图:ChoiceClick(blackboard:getValue('当前账号').chapter,1)
		end
	sleep(500)
	end
	)
检查三星:getDoingBehavior():setServer(
	function(blackboard)
	_K:Switchkeep()
		if Data.可以扫荡:getandCmpColor() then
			blackboard:setValue('当前流程','开始扫荡')
		else
			print('没体力了')
			blackboard:setValue('当前流程','前往行会')
			blackboard:setValue("初始化页面",true) 
		end
	end
	)
开始扫荡:getDoingBehavior():setServer(
	function(blackboard)	print('开始扫荡')
	_K:Switchkeep()
		if 	Data.无法扫荡:getandCmpColor() then
			blackboard:setValue('当前流程','结束领取奖励')
			return blackboard:setValue("初始化页面",true) 
		else
			Data.关卡页面_增加扫荡券:touchHold(6)
			Data.关卡页面_使用扫荡券:Click(2)
			Data.扫荡券确认:Click()
			blackboard:setValue('当前流程','等待扫荡结束')
			return blackboard:setValue('当前场景','扫荡确认')
		end
	end
	)
local 扫荡结束=false
local 等待扫荡次数=0
等待扫荡结束:getDoingBehavior():setServer(
	function(blackboard)	print('等待扫荡结束')
	_K:Switchkeep()
		if Data.扫荡确认:getandCmpColor(true) then 扫荡结束=true
			return
		end
		Data.超出上限道具:getandCmpColor(true)
		Data.扫荡券确认:getandCmpColor(true)
		Data.团队战CP:getandCmpColor(true)
		Data.扫荡跳过:getandCmpColor(true)
		if 扫荡结束 then
			Data.等级提升:getandCmpColor(true)
			Data.限定商店:getandCmpColor(true)
			if Data.关卡页面:getandCmpColor() then 扫荡结束=false;等待扫荡次数=0
				blackboard:setValue("初始化页面",true) 
				return blackboard:setValue('当前流程','前往行会')
			end
			Data.瞎点_扫荡:Click()
		else
		if Data.体力不足_挑战:getandCmpColor() then
			扫荡结束=false;等待扫荡次数=0
			blackboard:setValue("初始化页面",true) 
			return blackboard:setValue('当前流程','前往行会')
		end
		end
		if 等待扫荡次数>=4 and 扫荡结束==false then
			if Data.关卡页面:getandCmpColor() then 等待扫荡次数=0
				return Data.关卡页面_使用扫荡券:Click(2)
			end
			if Data.冒险:getandCmpColor() then
				return Data.冒险_主线关卡:Click(1)
			end
			if Data.主页面:getandCmpColor() then
				return Data.主页_冒险:Click(1)
			end
		end
	sleep(700);等待扫荡次数=等待扫荡次数+1
	end
	)
前往行会:getDoingBehavior():setServer(
	function(blackboard) print('前往行会')
	if blackboard:getValue('捐赠开关')==true then
		print('开始捐装备')
	else
		return blackboard:setValue('当前流程','退出账号')
	end
		Data.点赞确认:getandCmpColor(true,1)
		_K:Switchkeep()
		if Data.行会_已入会:getandCmpColor() then
			blackboard:setValue('当前场景','行会页面')
			blackboard:setValue('当前流程','捐赠装备')
		elseif Data.主页面:getandCmpColor() then
			Data.主页_行会:Click()
		end
	Data.瞎点:Click()
	sleep(500)
	end
	)
捐赠装备:getDoingBehavior():setServer(
	function(blackboard) print('捐赠装备')
	_K:Switchkeep()
		if Data.行会_已入会:getandCmpColor() then
			_K:Switchkeep() 
			if Data.捐赠请求数量:getandCmpColor(true,1) then 
				blackboard:setValue('刷新请求次数',blackboard:getValue('刷新请求次数')+1)
				_K:Switchkeep()
				local aim=Data.捐赠道具:findColor()
				if aim~=false then 
					return aim:Click(1)
				end
			else
				blackboard:setValue('刷新请求次数',blackboard:getValue('刷新请求次数')+0.5)
			end
		end
		if Data.确认捐赠:getandCmpColor() then
			Data.捐赠_MAX:Click(1)
			Data.捐赠_确认:Click(1)
		end
		Data.捐赠完毕:getandCmpColor(true,1)
	if blackboard:getValue('刷新请求次数')>=5 then
		blackboard:setValue('当前流程','退出账号')
		blackboard:setValue("初始化页面",true) 
		blackboard:setValue("刷新请求次数",0) 
	end
	sleep(500)
	end
	)
local 已退出=false
退出账号:getDoingBehavior():setServer(
	function(blackboard) print('退出账号')
	Data.公告:getandCmpColor(true)
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
		if Data.登录页面:getandCmpColor() then 
			已退出=false
			blackboard:setValue('当前流程','登录账号')
			blackboard:setValue('当前场景','登陆页面')
			blackboard:setValue("初始化页面",false)
			blackboard:setValue('已补充体力次数',0)
			第一次购买体力=true --Behavior购买体力参数
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
		local 读取账号=behavior.验证账号('weapon')
		local data = behavior.获取账号完成信息(读取账号.accountId)
		读取账号.chapter = data.weapon.chapter
		读取账号.stage = data.weapon.stage
		blackboard:setValue('当前账号',读取账号)
		Print(blackboard:getValue('当前账号'))
		Data.登录_账号:inputText(读取账号.account,true);sleep(500)
		Data.登录_密码:inputText(读取账号.password,true)
		Data.登录_登录:Click(2)
		_K:Switchkeep()
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
				blackboard:setValue("当前流程","购买体力")
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