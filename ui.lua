require("base.Z_ui")
local DevScreen={
	Width=1920,
	Height=1080,
}
local 主UI=ZUI:new(DevScreen,{align="left",w=90,h=100,size=20,cancelname="取消",okname="OK",countdown=0,config="mainui",xpos=2})
local 主配置=Page:new(主UI,{text="主功能选择",size=20})
主配置:nextLine()
主配置:addLabel({text="选择功能",size=30,align="Left",w=20,color="255,0,0"})
主配置:addRadioGroup({id="选择功能",list="地下城,刷级,装备,退会,邀请入会,过活动,过主线,删除记录",select=0,size=25,w=80,h=10,color="0,0,0"})
主配置:nextLine(2)
主配置:addLabel({text="输入脚本标识:",size=30,align="Left",w=20,color="0,0,0",ypos=1})
主配置:addEdit({id="脚本标识",prompt="这里输入脚本标识",kbtype="default",select="1",size=25,w=20,h=10,color="0,0,0"})
主配置:nextLine(2)
主配置:addLabel({text="2020-12-21 08.50",size=30,align="Left",w=20,color="0,0,0",ypos=1})
return 主UI:show(0)