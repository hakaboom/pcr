if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;if tonumber(string.match(getEngineVersion(), '^(%d+)')) < 2 then local ret = pcall(require, 'xmod_upgrade_hint'); if not ret then dialog('本脚本需要2.0以上脚本引擎版本运行。\n请联系作者反馈。'); lua_exit() end end;
require'base.base'require'base.Frame'require'base.Task'--必须要的前置代码
DevScreen={	--开发分辨率
	Top=0,Bottom=0,Left=0,Right=0,
	Width=1920,Height=1080,dpi=280
}
screen.init(screen.LANDSCAPE_RIGHT)
local size =screen.getSize()
local _width,_height=size.width,size.height
if _width<_height then _width,_height=_height,_width end
CurScreen={	--开发分辨率
	Top=0,Bottom=0,Left=0,Right=0,
	Width=_width,Height=_height,dpi=screen.getDPI()
}
_K=System:new(DevScreen,CurScreen,1,{x='width',y='height'},{x='width',y='height'})
_KDpi=System:new(DevScreen,CurScreen,1,"dpi","dpi"):getArry()
local Data=require'Data'
local behavior=require'Behavior'
----------
----------
调试HUD=HUD:new({color="0xfff9d854",bg="0x80222a15",text='1234',size=30,Area=multiPoint:new({
	Area={126,1006,126+295,1006+70}
}):getArea()})
---------------读取ui
function_choice=require'ui'
if function_choice._cancel then
	xmod.exit()
end

if type(tonumber(function_choice.脚本标识))=='number' and tonumber(function_choice.脚本标识)<10 then
	function_choice.脚本标识 = '0'..tostring(function_choice.脚本标识)
end

---------读取功能ui
do	--1 - 地下城
	
	if function_choice.选择功能 == 1 then
		local function_name = 'dungeons'
		UI配置 = require(function_name .. '.ui')
		if UI配置._cancel then
			xmod.exit()
		end
		if UI配置.指定农场 == '' then UI配置.指定农场 = nil else
			if tonumber(UI配置.指定农场) <10 then
				UI配置.指定农场 = '专业团队00' .. tonumber(UI配置.指定农场)
			elseif tonumber(UI配置.指定农场) >100 then
				UI配置.指定农场 = '专业团队' .. tonumber(UI配置.指定农场)
			else
				UI配置.指定农场 = '专业团队0' .. tonumber(UI配置.指定农场)
			end
		end
		require(function_name .. '.主线')
	end
end

do 	--2 - 刷级
	if function_choice.选择功能 == 2 then
		local function_name = 'level'
		UI配置 = require(function_name .. '.ui')
		if UI配置._cancel then
			xmod.exit()
		end
		if UI配置.指定农场 == '' then UI配置.指定农场 = nil else
			if tonumber(UI配置.指定农场) <10 then
				UI配置.指定农场 = '专业团队00' .. tonumber(UI配置.指定农场)
			elseif tonumber(UI配置.指定农场) >100 then
				UI配置.指定农场 = '专业团队' .. tonumber(UI配置.指定农场)
			else
				UI配置.指定农场 = '专业团队0' .. tonumber(UI配置.指定农场)
			end
		end
		require(function_name .. '.主线')
	end
end

do 	--3 - 捐装备
	if function_choice.选择功能 == 3 then
		local function_name = 'weapon'
		UI配置 = require(function_name .. '.ui')
		if UI配置._cancel then
			xmod.exit()
		end
		if UI配置.指定农场 == '' then UI配置.指定农场 = nil else
			if tonumber(UI配置.指定农场) <10 then
				UI配置.指定农场 = '专业团队00' .. tonumber(UI配置.指定农场)
			elseif tonumber(UI配置.指定农场) >100 then
				UI配置.指定农场 = '专业团队' .. tonumber(UI配置.指定农场)
			else
				UI配置.指定农场 = '专业团队0' .. tonumber(UI配置.指定农场)
			end
		end
		require(function_name .. '.主线')
	end
end

do 	--4 - 退会
	if function_choice.选择功能 == 4 then
		function_name = 'outFrame'
		UI配置 = require(function_name .. '.ui')
		if UI配置._cancel then
			xmod.exit()
		end
		if UI配置.指定农场 == '' then UI配置.指定农场 = nil else
			if tonumber(UI配置.指定农场) <10 then
				UI配置.指定农场 = '专业团队00' .. tonumber(UI配置.指定农场)
			elseif tonumber(UI配置.指定农场) >100 then
				UI配置.指定农场 = '专业团队' .. tonumber(UI配置.指定农场)
			else
				UI配置.指定农场 = '专业团队0' .. tonumber(UI配置.指定农场)
			end
		end
		require(function_name .. '.主线')
	end
end

do 	--5 - 邀请入会
	if function_choice.选择功能 == 5 then
		function_name = 'invitation'
--		UI配置 = require(function_name .. '.ui')
--		if UI配置._cancel then
--			xmod.exit()
--		end
--		if UI配置.指定农场 == '' then UI配置.指定农场 = nil else
--			if tonumber(UI配置.指定农场) <10 then
--				UI配置.指定农场 = '专业团队00' .. tonumber(UI配置.指定农场)
--			elseif tonumber(UI配置.指定农场) >100 then
--				UI配置.指定农场 = '专业团队' .. tonumber(UI配置.指定农场)
--			else
--				UI配置.指定农场 = '专业团队0' .. tonumber(UI配置.指定农场)
--			end
--		end
		require(function_name .. '.主线')
	end
end

do 	--6 - 过活动
	if function_choice.选择功能 == 6 then
		function_name = 'activity'
		UI配置 = require(function_name .. '.ui')
		if UI配置._cancel then
			xmod.exit()
		end
		if UI配置.指定农场 == '' then UI配置.指定农场 = nil else
			if tonumber(UI配置.指定农场) <10 then
				UI配置.指定农场 = '专业团队00' .. tonumber(UI配置.指定农场)
			elseif tonumber(UI配置.指定农场) >100 then
				UI配置.指定农场 = '专业团队' .. tonumber(UI配置.指定农场)
			else
				UI配置.指定农场 = '专业团队0' .. tonumber(UI配置.指定农场)
			end
		end
		UI配置.最低间隔时间=Base.timeTransform(8,'d','s') 
		require(function_name .. '.主线')
	end
end

do	--7 - 过主线
	if function_choice.选择功能 == 7 then
		function_name = 'mainLine'
		UI配置 = require(function_name .. '.ui')
		if UI配置._cancel then
			xmod.exit()
		end
--		if UI配置.指定农场 == '' then UI配置.指定农场 = nil else
--			if tonumber(UI配置.指定农场) <10 then
--				UI配置.指定农场 = '专业团队00' .. tonumber(UI配置.指定农场)
--			elseif tonumber(UI配置.指定农场) >100 then
--				UI配置.指定农场 = '专业团队' .. tonumber(UI配置.指定农场)
--			else
--				UI配置.指定农场 = '专业团队0' .. tonumber(UI配置.指定农场)
--			end
--		end
		if UI配置.结束关卡 == 1 then --3-1
			UI配置.结束关卡={关卡=1,章节=3}
		elseif UI配置.结束关卡 == 2 then --4-6
			UI配置.结束关卡={关卡=6,章节=4}
		elseif UI配置.结束关卡 == 3 then --8-14
			UI配置.结束关卡={关卡=14,章节=8}
		elseif UI配置.结束关卡 == 4 then --12-17
			UI配置.结束关卡={关卡=17,章节=12}
		end
		UI配置.最低间隔时间=Base.timeTransform(9999,'d','s') 
		require(function_name .. '.主线')
	end
end

do	--8 - 删除记录
	
	if function_choice.选择功能 == 8 then
		function_name = 'leveling'
		UI配置={}
		UI配置.指定农场 = nil
		local 账号=behavior.获取账号(function_name)
		behavior.释放账号(账号.accountId)
		dialog('已经释放ID='..账号.accountId)
		xmod.exit()
	end
end

主流程:run()

