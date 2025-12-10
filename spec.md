# 宪章
创建一个宪章，重点关注代码质量，测试方面，用户体验，项目可维护性和性能。各个模块之间使用统一标准用于数据交换，以便后续拓展功能。在每个模块开头都要写此模块功能的注释，标明传入和传出数据，在关键代码处也要写明注释。

# 总体功能
## Version 1
需要写一个跨平台的APP，用于管理多个OpenWRT路由器，可以查看设备状态，并调整设备参数等，功能和网页版LuCI对齐。用户拥有高度的APP界面自定义权限，适配横竖屏两种设备形态，APP本身可使用生物识别保护，自带MCP辅助用户进行操作。

## Version 2
支持MCP的规则自动识别

# UI/UX

## Layout
### Portrait
- **启用范围**: 横向宽度小于872px时使用Portrait布局，多出来的72px用于Portrait的Navigation rail
- **AppBar**: 是一个Topbar，需要可以自动隐藏，其中最左边是返回按钮/切换设备，用于返回上一级或切换设备；中间是该页面的标题，最右边是一个菜单按钮，点击会弹出一个List菜单
- **Navigation Region**: 是一个Navigation bar，有两个Part用于全局切换，分别是路由器页面 (Router) 和应用设置 (Setting)
- **Body Region**: 显示对应的主要内容。

### Landscape
- **启用范围**: 横向宽度大于872px，多出来的72px用于Navigation rail
- **Navigation Region**: 是一个Navigation rail，有两个Part用于全局切换，分别是路由器页面 (Router) 和应用设置 (Setting)，两个Part均服从该总体的Layout设计
- **Body**: 分为左右两个单独的Panes

#### Left Pane
- **命名**: 该模块的命名需要包含"Left Pane"
- **Layout**: 没有上下margin，与Navigation rail等高。与Right Pane中间有Spacer，用于调整两边Pane的width，最小的width是400px
- **AppBar**: 是一个Topbar，需要可以自动隐藏，其中最左边是返回按钮/切换设备，用于返回上一级或切换设备；中间是该Left Pane的标题。
- **Body**: 该Left Pane的显示内容

#### Right Pane
- **命名**: 该模块的命名需要包含"Left Pane"
- **Layout**: 没有上下margin，与Navigation rail等高。与Left Pane中间有Spacer，用于调整两边Pane的width，最小的width是400px
- **AppBar**: 是一个Topbar，需要可以自动隐藏，其中中间是该Right Pane的标题，最右边是一个菜单按钮，点击会弹出一个List菜单
- **Body**: 该Right Pane的显示内容