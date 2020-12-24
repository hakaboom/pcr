require("base.Z_ui")
local DevScreen={
	Width=1920,
	Height=1080,
}
local 主UI=ZUI:new(DevScreen,{align="left",w=90,h=100,size=20,cancelname="取消",okname="OK",countdown=0,config="ui",xpos=2})
local 主配置=Page:new(主UI,{text="主功能选择",size=20})
主配置:nextLine() 
主配置:addLabel({text="脚本功能--捐装备",size=30,align="Left",w=20,color="255,0,0"})
主配置:nextLine() 
主配置:addLabel({text="指定农场:",size=30,align="Left",w=10,color="0,0,0",ypos=1,xpos=1})
主配置:addEdit({id="指定农场",prompt="这里输入脚本标识",kbtype="number",text='',select="1",size=25,w=20,h=10,color="0,0,0"})
主配置:nextLine()
主配置:addCheckBoxGroup({id="刷图开关",list="刷图开关",select="1",size=25,w=20,h=10,color="0,0,0",ypos=1})
主配置:addCheckBoxGroup({id="捐赠开关",list="捐赠开关",select="1",size=25,w=20,h=10,color="0,0,0",ypos=1})
主配置:nextLine(2)
主配置:addLabel({text="补充体力次数:",size=20,align="Left",w=15,color="0,0,0",ypos=1})
主配置:addEdit({id="补充体力次数",prompt="这里输入次数",kbtype="default",select="1",size=25,w=40,h=10,color="0,0,0"})

return 主UI:show(0)