require("base.Z_ui")
local DevScreen={
	Width=1920,
	Height=1080,
}
local 主UI=ZUI:new(DevScreen,{align="left",w=90,h=100,size=20,cancelname="取消",okname="OK",countdown=0,config="ui",xpos=2})
local 主配置=Page:new(主UI,{text="主功能选择",size=20})
主配置:nextLine() 
主配置:addLabel({text="选择配置文件:",size=30,align="Left",w=20,color="0,0,0"})
主配置:addEdit({id="配置文件名称",prompt="这里输入需要配置文件名称",kbtype="default",select="1",size=25,w=40,h=10,color="0,0,0",ypos=-2})
主配置:nextLine(2) 
主配置:addLabel({text="选择结束关卡:",size=30,align="Left",w=15,color="0,0,0"})
主配置:addRadioGroup({id="结束关卡",list="3-1,4-6,8-14,12-17",select=0,size=25,w=50,h=10,color="0,0,0"})

return 主UI:show(0)