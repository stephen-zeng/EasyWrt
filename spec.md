<!-- # 宪章 -->
创建一个宪章，重点关注代码质量，测试方面，用户体验，项目可维护性和性能。各个模块之间使用统一标准用于数据交换，以便后续拓展功能。在每个模块开头都要写此模块功能的注释，标明传入和传出数据，在关键代码处也要写明注释。

# 总体功能
## Version 1
需要写一个跨平台的APP，用于管理多个OpenWRT路由器，可以查看设备状态，并调整设备参数等，功能和网页版LuCI对齐。用户拥有高度的APP界面自定义权限，适配横竖屏两种设备形态，APP本身可使用生物识别保护，自带MCP辅助用户进行操作。

## Version 2
支持MCP的规则自动识别

# stage 1

## UI/UX

### Layout
#### Portrait
- **启用范围**: 横向宽度小于872px时使用Portrait布局，多出来的72px用于Portrait的Navigation rail
- **AppBar**: 是一个Topbar，需要可以自动隐藏，其中最左边是返回按钮，用于返回上一级；中间是该页面的标题，最右边是一个菜单按钮，点击会弹出一个List菜单
- **Navigation Region**: 是一个Navigation bar，有两个Part用于全局切换，分别是**路由器页面 (Router) **和**应用设置 (Setting)**
- **Body Region**: 显示对应的主要内容。

#### Landscape
- **启用范围**: 横向宽度大于872px，多出来的72px用于Navigation rail
- **Navigation Region**: 是一个Navigation rail，有两个Part用于全局切换，分别是路由器页面 (Router) 和应用设置 (Setting)，两个Part均服从该总体的Layout设计
- **Body**: 分为左右两个单独的Panes

##### Left Pane
- **命名**: 该模块的命名需要包含"Left Pane"
- **Layout**: 没有上下Padding，与Navigation rail等高。与Right Pane中间有Spacer，用于调整两边Pane的width，最小的width是400px
- **AppBar**: 是一个Topbar，需要可以自动隐藏，其中最左边是返回按钮/切换设备，用于返回上一级或切换设备；中间是该Left Pane的标题。
- **Body**: 该Left Pane的显示内容

##### Right Pane
- **命名**: 该模块的命名需要包含"Left Pane"
- **Layout**: 没有上下Padding，与Navigation rail等高。与Left Pane中间有Spacer，用于调整两边Pane的width，最小的width是400px
- **AppBar**: 是一个Topbar，需要可以自动隐藏，其中中间是该Right Pane的标题，最右边是一个菜单按钮，点击会弹出一个List菜单
- **Body**: 该Right Pane的显示内容

### 操作页面设计
#### Design
- **overview**: 用户通过层级菜单式的操作逐层进入下一级菜单，直到抵达最后一级的操作面板界面
- **construction**: 分为page、middleware、widget三个部分，page是用户抵达的最后一级的操作面板界面；widget是page中的各个组件，直接展现路由器数据或者操作路由器参数；middleware是用户抵达page过程中展现的层级菜单，每一级菜单都是一个middlware
- **customizable**: 用户在**路由器页面Part**可自由安排不同middleware和page的关系，可以自由新建middlware，不能新建page，但是保留新建page的能力用于后续开发新增功能。用户在某些page内可以自由添加调整widget，所以需要保留page的自定义能力。用户在**应用设置Part**不能自定义，但是需要方便开发者调整。
- **developer friendly**: 开发者要能够方便且统一地调整各个margin和padding，以及长宽等参数
- **fluent**: 各个页面转换的时候要有流畅的非线性动画过渡，直接使用material design 3 expressive的动画设计规范

#### 具体的组件说明
##### Middleware
- **定义**: middleware是用户抵达page前的层级菜单，每一级菜单都是一个middlware
- **逻辑**: 每一个middlware可以抵达下一个middleware或者page
- **内容**: 每个middleware都有一个title，一个icon，以及包含的下一级middleware和page
- **展示**: 在AppBar中展示标题，在Body中以菜单的形式展示包含的middleware和page，菜单的每一个Item中左边是middlware或page的icon，然后就是title。默认顺序先按种类排序 (middlware --> page) ，再按（拼音）首字母递增排序

##### Page
- **定义**: page是用户抵达的最终层级菜单，每一个page里面有多个widget用于展示和调整路由器的信息。
- **逻辑**: 一个page可以由多个middleware抵达，page不能直接抵达middleware或者其他page，但是可以通过里面的widget进行其他middlware或者其他page的跳转
- **内容**: 每个page都有一个title，一个icon，以及其中的很多widget
- **展示**: 在AppBar中展示标题，在Body中以菜单的形式展示包含的widget，注意响应式布局，自动适应Body的宽度，用户可以自由排布widget的布局。

##### Widget
- **定义**: widget直接展示和操作路由器数据，需要符合material design 3 expressive的设计风格
- **逻辑**: 一个widget可以被多个page使用，一个page里面只能出现一种widget。widget可以跳转到其他middleware或page，在middleware和page对应的显示区域跳转。
- **内容**: 相对自由，但是需要符合material design 3 expressive的设计规范。
- **规格**: 一个widget的height根据内容决定，width必须是100px的整数倍，并根据内容决定。widget和widget之间上下左右的Padding都是25px，widget内的上下左右margin都是5px
- **展示**: 在page的body内展示，以信息流的形式，根据body宽度自动调整展示列数，不设上限。

#### 组件的总体显示规则
##### Portrait
- **总体**: 展示当前需要展示的middleware或者page的内容
- **Back Button on AppBar**: 左侧返回键在非根middleware的时候显示，用于返回上级菜单内容。长按返回键时出现菜单，里面以列表的形式展现该middleware或page的调用路径，用于快速返回到用户想去的菜单。
- **Title On App Bar**: 显示当前middleware或者page的标题。
- **Menu Button On App Bar**: 菜单内容有“编辑”--用于编辑该middleware或page，不可编辑的时候隐藏；还有"切换"--用于跳转到设备切换的界面，保留拓展能力用于特定middlware或page。

#### Landscape
- **左右相互独立**: Left Pane和Right Pane相互独立，但是Left Pane和Right Pane可以相互决定对方的显示内容。

##### Left Pane
- **内容**: Left Pane只显示Middleware，包括widget导致的middleware跳转和middleware的编辑也只在Left Pane中变换，不影响Right Pane。
- **Title On App Bar**: 显示当前middleware的标题。
- **Back Button on AppBar**: 左侧返回键在非根middleware的时候显示，用于返回上级菜单内容。长按返回键时出现菜单，里面以列表的形式展现该middleware的调用路径，用于快速返回到用户想去的菜单。

##### Right Pane
- **内容**: Left Pane只显示Page，包括widget导致的page跳转以及page的编辑也只在Right Pane中变换，不影响Left Pane。
- **Title On App Bar**: 显示当前page的标题。
- **Menu Button On App Bar**: 菜单内容有“编辑Page”--用于编辑该page，不可编辑的时候隐藏；以及"编辑Middleware"，用于编辑Left Pane此时显示的middleware；还有"切换"--用于跳转到设备切换的界面，保留拓展能力用于特定middlware或page。

## 用于验证UI/UX框架的一些middleware和page
### Router Part
#### Middleware
- **Router**: Icon: `router`，是root middleware
- **Status**: Icon: `bar_chart`
- **Hardware**: Icon: `hardware`

#### Page
- **Internal Device**: Icon: `hard_drive`，可以编辑（appbar的弹出菜单内的编辑按钮可用）

#### Widget
- **Memory Status**: 展示内存占用

#### 从属关系
- **Router**-->**Status**-->**Hardware**-->**Internal Device**

### Setting Part
#### Middleware
- **Setting**: Icon: `settings`，是root middleware

#### Page
- **Router**: Icon: `router`，page内有一个`FAB`按钮，默认为编辑，当列表为空时为添加，点击后允许用户编辑或添加路由器，同时该`FAB`变为添加
- **Theme**: Icon: `colors`，page内有颜色和亮暗模式可供选择

## User Story
### User Story 1 - 能够完成路由器的添加和连接，以及相关报错的提醒 (Priority: P1)
As a network administrator, I want to add multiple OpenWRT routers to the app and view their real-time status (CPU, RAM, Traffic) on a unified dashboard so that I can monitor my entire network infrastructure from one place.

**Why this priority**: This is the core value proposition. Without connecting to routers and seeing their status, the app has no utility.

**Acceptance Scenarios**:
1. **Given** a fresh install, **When** 用户通过Settings (Root) --> Route (Page) 导航至路由器管理页面, **Then** 点击page中的FAB进行添加, **Then** they can input IP(Domain), Port, Username, Password and whether using HTTPS to save a router
2. **Given** saved routers, **When** the user click one router, **Then** the app try to connect to the router, **Then** jump to the Router Part's root middleware.

### User Story 2 - 能够完成路由器的CPU占用率查看 (Priority: P1)
选择好指定路由器之后，用户通过Router(root) --> Status(middleware) --> Hardware(middleware) --> Internal Device(page)来查看内部设备的实时信息

### User Story 3 - 能够完成主题的更改 (Priority: P2)
用户通过Settings (Root) --> Theme (Page)导航至主题设置界面，然后选择不同的配色和亮暗主题，默认是绿色+跟随系统的亮暗主题。