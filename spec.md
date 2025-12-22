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

# Stage 2 - Customization
## UI/UX *(mandatory)*
### 项目中已经定义的页面框架
项目中定义了Module, Middleware, Page和Widget这四层UI框架，可以参考`001-framework-design`和`lib`中的代码文件。
- **Module**为程序的两个部分，分别是Router路由器管理部分和Setting应用程序设置部分。
- **Middleware**用于引导用户进入到**Page**
- **Page**是用户最终的目的地，上面可以展示**Widget**
- **Widget**通过网络直接与路由器进行通信，上面显示路由器的信息，然后也可以操作路由器

Customization部分对于Widget，Page和Middleware部分均有涉及，主要是Widget和Page，Middleware部分较少。

### 量化尺寸
将尺寸进行方格量化，方格之间的上下左右的间距为**1rem**，最终效果就是Widget之间的上下左右间距是**1rem**，长宽均为**Stripe**（后文有定义）的width在去除间距后的四分之一。

### Widget
#### BaseWidget基类
为了方便后续Widget的扩展，需要写一个`BaseWidget`基类，所有的合法Widget都要继承这个基类

#### 大小
- `BaseWidget`允许Widget有**1x1**, **1x2**, **2x1**, **2x2**, **2x4**, **4x2**, **1x4**, **4x1**, **4x4**个方格这几种大小，未来会添加更多尺寸支持。Widget可以自由选择支持的尺寸，然后重载BaseWidget对应的函数。
- 每一个Widget都必须有**1x1**和**4x4**两个大小档位，**1x1**默认为该Widget的图标，**4x4**为Widget的完整形态

#### 通信
每个Widget独立与路由器进行通信，确保Widget在网络层面上不受到影响。但是Widget之间可以在应用层面互相自由通信，比如通过其他Widget获取路由器信息或调整路由器的设置，以减小网络压力。

#### 身份
- 每一个Widget都需要一个icon和名字，作为静态数据存放在Widget类中。

### Stripe
**Stripe**是为了更好适配响应式布局而定义的渲染概念，每个Stripe都是独一无二的，不能被复用。
#### 大小与布局
- 每个Stripe的最小宽度为**19rem**，最大宽度为**35rem**
- 每个Stripe的大小为**4xN**，N取决于该Stripe上Widget的排布。
- Stripe之间的上下左右间距也是**1rem**，最终效果是Widget之间的上下左右间距是**1rem**
- 一个Page能平行展示Stripe的列数由Page的width决定，当宽度足够的时候就平行展示，不够的时候就居中以最大宽度展示能展示的最多列数

#### 与其他具体框架的关系
- Widget直接放在Stripe上，有固定布局，每个Stripe可拥有的Widget数量不限。
- 一个Widget可以被多个不同Page的Stripe拥有，一个Page不能拥有重复的Widget。
- 每个Page里面可以有无限多个Stripe，且顺序固定。

### Page
#### 自定义
- 每一个系统内置的Page都有一个默认的Stripe和Widget排布，保存在数据库PageItem中
- 不是每一个Page都可以被编辑，页面是否可编辑应保存在数据库的PageItem中
- 进入Page编辑页面之后用户可以自由添加Widget，调整其位置和大小。
- Widget可以自由在不同Stripe的不同位置拖动，但是在一个Stripe中不能出现一个行完全空的方格
- 将Widget在Stripe中的大小以及绝对位置进行持久化，保存在数据库的PageItem中。

#### 编辑模式
- 进入编辑模式后，如果该区域上没有Widget，那么该区域的每个方格尺寸都以半透明的灰色圆形可视化，否则只显示Widget。每个Stripe都被一圈半透明的灰色虚线包围作为可视化。
- 在编辑模式下，已有的Stripe的高度需要比在非编辑模式下多一列方格区域，用于添加新的Widget
- 在编辑模式下，除了已有的Stripe，还需多显示一个Stripe，用于将Widget添加到新的Stripe上。
- Stripe的布局与在非编辑模式的布局一直，参考UI/UX，响应Page的宽度

### Middleware
#### 自定义
- Middleware增加自定义列表顺序的功能，用户在进入Middleware的编辑页面之后可以自由拖动里面列表项的顺序，以及添加Middleware和Page，但是不能添加自己。
- 编辑完成后将列表进行持久化，保存在数据库的MiddlewareItem中。
- Middleware中的项如果是一个middleware，那么就在最右端增加一个"chevron_right"的icon，暗示可以进入下一级Middleware。

#### 编辑模式
- 进入编辑模式后，列表中每一项都可以被拖动，在每一项的最右端添加一个menu图标暗示可以拖动
- 在menu图标的左侧，多一个红色的“close”按钮，是删除按钮，点击后该项从列表中消失

## User Scenarios & Testing *(mandatory)*

### User Story 1.1 - 竖屏模式进入Page编辑模式
 - 在竖屏模式的时候，用户进入一个Page，点击Appbar最右侧的menu按钮，弹出菜单中包含“编辑页面”的项。若Page可以被编辑，那么这个项将可用，否则为灰色不可用。
 - 点击菜单中的“编辑页面”的项，进入编辑模式
 - 进入编辑模式的时候，appbar的右端的按钮由“menu”变为"check"，表示保存。同时appbar左边的"back"变为"close"，表示放弃。，然后Page右下角出现一个FloatingActionButton，为"add"，作为添加Widget的入口

### User Story 1.2 - 横屏模式进入Page编辑模式
- 在横屏模式的时候，用户在Right Pane中进入一个Page，点击Right Pane的Appbar最右侧的menu按钮，弹出菜单中包含“编辑页面”的项。若Page可以被编辑，那么这个项将可用，否则为灰色不可用。
- 点击菜单中的“编辑页面”的项，进入编辑模式
- 进入编辑模式的时候，Right Pane的appbar的右端的按钮由“menu”变为"close"和"check"，分别代表放弃和保存，然后Right Pane的右下角出现一个FloatingActionButton，icon为"add"，作为添加Widget的入口

### User Story 2 - 添加Widget到Page的Stripe中
- 进入编辑模式后，点击Page右下角的“添加”FloatingActionButton，弹出一个添加的dialog
- 在dialog内，展示**该页面没有的**Widget的Icon和名称列表，用户从中选择。注意，用户点击Page以内，dialog以外的区域的时候，表示不选择任何Widget，应关闭dialog。
- 用户在点击Widget时候，Dialog关闭，该Widget以**1x1**的尺寸出现在可视范围内的第一个Stripe的新的一列（编辑模式下多显示的一列）的第一个方格中，同时改方格的半透明圆形消失。

### User Story 3 - 调整Widget的位置和大小
- 添加完成Widget后，用户可以看到Widget的右下角有一个指向正西南方向的小箭头，暗示可以调整大小
- 用户可以拖动箭头，以调整大小。被调整的Widget需要实时更新样式，用户松手的时候，如果没有足够的连续区域放下改大小，则Widget缩回原来的尺寸。若拖动到Stripe的最后一列，该Stripe需要及时增加新的一列空行，因此当Widget在倒数第二行的时候（最后一行应始终没有Widget），若这一行在横向没有其他Widget挡住，始终可以被调整到用户需要的大小。注意，所有Widget和Stripe的运动、大小变换都必须是连贯的，带动画的
- 用户可以通过拖动Widget来调整位置，在拖动的时候，若被拖动目标位置不够，则Widget回到原位。每个位置都有空位置的磁性吸附力，方便用户在不完全对齐的情况下也能拖到指定位置。
- Widget可以自由拖动到其他Stripe中，包括新的Stripe。当用户将Widget拖入到新的Stripe的时候，应当马上再展示一个新的Stripe的位置。

### User Story 4 - 竖屏进入Middleware编辑模式
- 用户来到想要编辑的Middleware之后，点击appbar右边的menu按钮，弹出一个菜单
- 弹出的菜单中包含“编辑Middleware”这一项，用户单击之后进入Middleware编辑模式
- 如果用户此时不在Middleware而在Page中，则菜单中的“编辑Middleware”这一项不可用
- 进入编辑模式的时候，appbar的右端的按钮由“menu”变为"check"，表示保存。同时appbar左边的"back"变为"close"，表示放弃。然后Middleware右下角出现一个FloatingActionButton，为"add"，作为添加下一级Middleware或Page的入口

### User Story 5 - 横屏进入Middleware编辑模式
- 用户在Left Pane来到想要编辑的Middleware之后，点击Right Pane的appbar右边的menu按钮，弹出一个菜单
- 弹出的菜单中包含“编辑Middleware”这一项，用户单击之后进入Middleware编辑模式
- 进入编辑模式的时候，Left Pane的appbar的左端的按钮由“back”变为"close"和"check"，分别代表放弃和保存，然后Left Pane左下角出现一个FloatingActionButton，icon为"add"，作为添加下一级Middleware或Page的入口

### User Story 6 - 添加和调整Middleware内的项
- 用户点击FloatingActionButton之后，弹出浏览所欲可用Middleware和Page的一个dialog，其中不包含被编辑的Middleware自己以及已经添加到Middleware中的项目
- 用户点击dialog中的项目，该项目就会被添加到被编辑的Middleware的末尾，同时关闭dialog
- 用户单击Middleware显示区域之内，dialog之外的区域，则为取消添加，此时应直接关闭dialog

### User Story 7 - 保存或放弃
- 用户在完成Page或Middleware的编辑之后，若点击对应appbar上的“check”保存按钮之后，从编辑模式退出，保留用户的更改，将布局存储在数据库中。
- - 用户在完成Page或Middleware的编辑之后，若点击对应appbar上的“close”放弃按钮之后，从编辑模式退出，回到数据库中存储的布局，放弃用户的更改。