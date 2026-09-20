# Neovim 全套 45 个插件实战与练习全景手册 (Complete Neovim Plugins Guide)

> 本仓库配套演练代码：[`examples/playground/main.py`](file:///home/tetsuya/development/night-batch-lab/examples/playground/main.py) 与 [`examples/ui_playground.py`](file:///home/tetsuya/development/night-batch-lab/examples/ui_playground.py)  
> 🏆 **离线通关题库**：对照 [`WORKBOOK.md`](file:///home/tetsuya/development/night-batch-lab/WORKBOOK.md) 进行 32 道实战关卡逐题演练！  
> 运行演练：`cd /home/tetsuya/development/night-batch-lab && nvim examples/playground/main.py`

当前您的 Neovim 配置中一共安装并运行了 **45 个插件**（由 `Lazy.nvim` 统一管理）。  
为了让您不再“装了好多插件却不知道怎么用”，本手册将这 45 个插件划分为 **8 大核心体系**，列出每个插件的作用、核心快捷键，并在代码文件中为您设计了对应的练习场景。

---

## 目录索引
1. [分类统计总览](#分类统计总览)
2. [第一模块：代码编辑、文本对象与效率增强 (8 个)](#第一模块代码编辑文本对象与效率增强-8-个)
3. [第二模块：外观、主题与界面美化 (8 个)](#第二模块外观主题与界面美化-8-个)
4. [第三模块：模糊搜索、跳转与导航 (4 个)](#第三模块模糊搜索跳转与导航-4-个)
5. [第四模块：文件管理与目录浏览 (2 个)](#第四模块文件管理与目录浏览-2-个)
6. [第五模块：Git 版本控制与全景对比 (4 个)](#第五模块git-版本控制与全景对比-4-个)
7. [第六模块：LSP 智能补全、诊断与格式化 (6 个)](#第六模块lsp-智能补全诊断与格式化-6-个)
8. [第七模块：自研与私有专属插件 (5 个)](#第七模块自研与私有专属插件-5-个)
9. [第八模块：底层基础设施与依赖库 (6 个)](#第八模块底层基础设施与依赖库-6-个)
10. [日常高频快捷键速查终极便签](#日常高频快捷键速查终极便签)

---

## 分类统计总览

| 模块类别 | 插件数量 | 核心涵盖工具 |
|---|:---:|---|
| **代码编辑与文本对象** | 8 | `nvim-ufo`, `mini.ai`, `vim-visual-multi`, `yanky`, `mini.pairs`, `treesitter` 等 |
| **外观与界面美化** | 8 | `satellite`, `rainbow-delimiters`, `mini.hipatterns`, `heirline`, `bufferline` 等 |
| **搜索、跳转与导航** | 4 | `flash.nvim`, `telescope`, `aerial.nvim`, `nvim-hlslens` |
| **文件浏览与管理** | 2 | `neo-tree.nvim`, `oil.nvim` |
| **Git 版本控制** | 4 | `diffview.nvim`, `gitsigns.nvim`, `hunk-review.nvim`, `snacks.nvim (lazygit)` |
| **LSP 智能体与补全** | 6 | `blink.cmp`, `nvim-lspconfig`, `mason`, `conform.nvim`, `fidget` 等 |
| **自研与私有扩展** | 5 | `contextline.nvim`, `VimQuest`, `which-key`, `auto-session`, `grug-far` |
| **基础设施与依赖库** | 6 | `lazy.nvim`, `plenary`, `nui`, `sqlite.lua`, `promise-async` 等 |
| **总计** | **45 个** | 全部就绪，高度优化 |

## 🌟 跨文件多模块项目级实战演练 (Multi-File Realistic Architecture)

为了完美贴合真实开发环境，我们在 [`examples/playground/`](file:///home/tetsuya/development/night-batch-lab/examples/playground/) 下构建了一个完整的跨模块 Python 子工程：

```text
examples/playground/
├── __init__.py    # 模块统一对外接口
├── config.py      # 全局运行时配置、HEX 主题色盘 (#ffff00 等)
├── models.py      # 领域数据模型 (dataclass)、状态枚举、彩虹嵌套数据结构
├── engine.py      # 计算统计核心引擎 (包含长函数折叠、多光标编辑演练)
├── service.py     # 业务调度编排服务 (多模块跨文件调用枢纽)
└── main.py        # 可执行入口 (演练 cross-file LSP、多标签切换、工程全局替换)
```

### 推荐演练动线：

1. **进入主入口**：
   ```bash
   cd /home/tetsuya/development/night-batch-lab
   nvim examples/playground/main.py
   ```
2. **跨文件跳转定义 (`gd`)**：
   - 将光标放在第 45 行的 `BatchOrchestratorService` 上，按下 **`gd`**！
   - **效果**：Neovim 会瞬间跨文件打开并跳入 `service.py` 内部定位到类的声明！
   - 在 `service.py` 内部，再把光标移到 `CalculationEngine` 上按 `gd`，瞬移跳入 `engine.py`！
   - 在 `service.py` 中把光标移到 `COLOR_PALETTE` 上按 `gd`，瞬移跳入 `config.py`！
3. **跨文件悬浮文档 (`K`)**：
   - 在任意文件中，光标停在跨文件导入的类名、方法名或变量上按下大写 **`K`**。
   - **效果**：屏幕中央弹出悬浮卡片，直接展示来自被引用文件里的 Docstring 与类型签名！
4. **多文件标签极速切换 (`<S-h>` / `<S-l>`)**：
   - 连续跳跃后，屏幕最上方的 `Bufferline` 会列出当前已打开的文件列表。
   - 按 **`<S-h>`** 或 **`[b`**：向左切换上一个标签文件。
   - 按 **`<S-l>`** 或 **`]b`**：向右切换下一个标签文件。
   - 按 **`<leader>bd`**：关闭当前打开的文件标签，不破坏窗口分屏。
5. **跨文件全局重命名 (`<leader>cr`)**：
   - 将光标放在跨文件使用的函数（例如 `create_mock_pipeline`）上。
   - 按 **`<leader>cr`**，输入新名字并回车。
   - **效果**：基于 `basedpyright` LSP，所有引用该函数的关联文件全部自动同步修改！
6. **项目级全局批量搜索与替换 (`<leader>sr` / `<leader>sg`)**：
   - 按 **`<leader>sg`**：输入关键字（如 `fresh_yellow`），查看整个工程所有匹配文件。
   - 按 **`<leader>sr`**：打开 `Grug-far` 两栏全局批量替换面板，实时预览所有文件的变动并一键应用。

---

## 第一模块：代码编辑、文本对象与效率增强 (8 个)

### 1. `nvim-ufo` (现代化语法代码折叠)
- **是什么**：取代 Vim 原生难看的折叠。折叠后保留原行语法高亮，右侧附带漂亮的胶囊徽标 `⋯ N lines 󰁂`，支持**不展开直接窥探**折叠内容。
- **快捷键**：
  - `zc`：折叠当前代码块
  - `zo`：展开当前折叠
  - `zp`：★ **悬浮窥探 (Peek)**：光标在折叠行上按 `zp`，弹窗直接偷看内部内容！
  - `zM`：**一键折叠全文**所有函数与类
  - `zR`：**一键展开全文**所有折叠
- **演练**：在 `ui_playground.py` 场景 03（第 75 行），把光标移到 `def long_calculation_algorithm` 行按 `zc`，然后按 `zp` 查看弹窗！

### 2. `mini.ai` (超级增强文本对象)
- **是什么**：扩展 Vim 原生的 `iw`/`aw`。让你能把一个函数、一个参数、一个代码块当成一个“单词”一样快速操作。
- **快捷键**：
  - `cia` / `dia`：**Change/Delete Inner Argument**（快速修改/删除当前函数参数）
  - `vaf` / `vif`：**Visual Around/Inner Function**（选中整个函数 / 函数内部代码）
  - `vac` / `vic`：**Visual Around/Inner Class**（选中整个类）
  - `va)` / `vi)`：选中括号外/内
  - `yag`：**Yank Around Global**（直接复制全文内容，不需要 `ggVGy`）
- **演练**：在 `ui_playground.py` 场景 06（第 132 行）的参数列表上，光标放在 `arg_timeout` 上按 `cia`。

### 3. `vim-visual-multi` (多光标并发编辑)
- **是什么**：像 VSCode / Sublime 一样拥有多个光标，同时修改多处相同单词或垂直多行。
- **快捷键**：
  - `Ctrl+n`：选中光标下的单词；继续按 `Ctrl+n` 选中下一个相同单词
  - 选中后直接按 `c` 进行修改，按 `Esc` 退出多光标模式
  - `Ctrl+j` / `Ctrl+k`：在当前光标的下方/上方添加额外光标
- **演练**：在 `ui_playground.py` 场景 07（第 155 行），光标停在第一行 `batch_item` 上，连续按 4 次 `Ctrl+n`，然后按 `c` 统一改名！

### 4. `yanky.nvim` (剪贴板历史管理器)
- **是什么**：再也不用担心刚复制的内容被下一次 `dd` 冲掉。它会记录剪贴板全部历史，并支持原地“翻页”。
- **快捷键**：
  - `p`：正常粘贴
  - `[p` / `]p`：★ **循环轮换**：粘贴后立刻按 `[p` 或 `]p`，粘贴出来的文字会原地轮流切换为你之前复制过的其他历史！
  - `<leader>fy`：通过 Telescope 弹窗浏览并选择全部剪贴板历史
- **演练**：在 `ui_playground.py` 场景 08（第 170 行），随便 `yy` 复制两句不同的话，到下方按 `p` 然后狂按 `[p`。

### 5. `mini.pairs` (智能括号引号配对)
- **是什么**：打字时输入 `(` 自动补 `)`，输入 `"` 自动补 `"`，回车自动缩进换行，按退格键成对删除。
- **演练**：在 `ui_playground.py` 场景 10（第 215 行）输入括号体验。

### 6. `nvim-treesitter` (AST 语法分析与高级高亮引擎)
- **是什么**：Neovim 现代高亮的心脏。通过抽象语法树（AST）精准理解代码结构，实现函数、变量、类型的高精度高对比度着色。

### 7. `nvim-treesitter-textobjects` (语法节点文本跳转)
- **是什么**：基于语法树直接按函数/类跳转。
- **快捷键**：
  - `]m` / `[m`：跳到下一个 / 上一个方法（Method）的开头
  - `]M` / `[M`：跳到下一个 / 上一个方法的结尾
  - `]]` / `[[`：跳到下一个 / 上一个类的开头

### 8. `ccc.nvim` (颜色拾取器与转换器)
- **是什么**：在代码里交互式选颜色或转换颜色格式。
- **命令**：
  - `:CccPick`：光标停在颜色上，弹出可视化调色板滑块
  - `:CccConvert`：在 HEX、RGB、HSL 之间快速互转
- **演练**：在 `ui_playground.py` 场景 01（第 35 行），光标停在 `#ffff00` 上输入 `:CccPick`。

---

## 第二模块：外观、主题与界面美化 (8 个)

### 9. `satellite.nvim` (传统 UI 经典右侧滚动条)
- **是什么**：在窗口右边缘渲染带有深灰连续轨道（`#25252a`）和亮黄滑块（`#ffff00`）的滚动条，彻底解决透明滚动条覆盖背景的杂乱感。
- **操作**：用 `Ctrl+d` / `Ctrl+u` 滚动文件即可看到。

### 10. `rainbow-delimiters.nvim` (彩虹嵌套括号)
- **是什么**：嵌套括号逐层变色（黄 -> 青 -> 蓝 -> 橙 -> 绿 -> 紫 -> 红）。
- **演练**：在 `ui_playground.py` 场景 02（第 52 行）观察多层括号。

### 11. `mini.hipatterns` (十六进制颜色实时预览)
- **是什么**：无需命令，代码中凡是出现 `#ffffff`、`#00ffff` 等 HEX 颜色，其文字背景直接渲染为真实颜色。
- **演练**：在 `ui_playground.py` 场景 01（第 35 行）查看。

### 12. `heirline.nvim` (IDE 级高交互语义状态栏)
- **是什么**：编辑器底部状态栏。按模式变色（NORMAL 亮黄、INSERT 绿色等），显示 Git 增减计数（`+1 ~2 -0`）、文件类型图标、低调目录路径与加粗文件名。
- **全新交互功能 (IDE 级鼠标触觉反馈与弹出菜单)**：
  - 󰆤 **触觉按压反馈**：任何可点击区域在鼠标按下时触发高亮蓝色（`#0064c8`）闪烁，具有直观的物理按压质感。
  - 󰈤 **文件名/路径菜单**：
    - **单击**：弹出文件动作菜单（复制相对/绝对路径、文件名、Oil 打开目录、Neo-tree 定位、Diffview 历史、重命名）。
    - **双击**：直接将完整绝对路径复制到系统剪贴板。
  - 󰉿 **编码与换行符菜单**：单击 `UTF-8` 弹出编码切换菜单（UTF-8、GB18030、Shift-JIS、EUC-JP、重新以指定编码打开、转换为 LF/CRLF）。
  - 󰊢 **Git 分支菜单**：单击分支名弹出 Git 工具箱（Diffview、Lazygit、分支历史、开关 Blame、预览 Hunk 等）。
  - 󰒋 **LSP 运维菜单**：单击 LSP 伺服器名弹出语言服务工具箱（LSP 状态、Code Action、符号大纲、代码格式化、重启）。
  - 󰌌 **全局启动台**：单击最左侧 `NORMAL` 模式徽标呼出快速启动菜单。

### 13. `bufferline.nvim` (顶部标签栏)
- **是什么**：窗口最顶部的标签栏，显示当前打开的文件列表。
- **快捷键**：
  - `<S-h>` 或 `[b`：切换到左边的文件标签
  - `<S-l>` 或 `]b`：切换到右边的文件标签
  - `<leader>bd`：关闭当前文件标签（不破坏窗口布局）

### 14. `nvim-web-devicons` (文件与语言图标库)
- **是什么**：为各种编程语言、配置文件提供彩色的 Nerd Font 图标。

### 15. `indent-blankline.nvim` (ibl - 缩进指引线)
- **是什么**：在代码缩进处绘制纤细的垂直参考线，嵌套逻辑对齐一目了然。

### 16. `cyberdream.nvim` (备选赛博朋克主题)
- **是什么**：仓库备用的高品质赛博朋克深色主题（当前主力默认是 1:1 移植的 `high-contrast-plus`）。

---

## 第三模块：模糊搜索、跳转与导航 (4 个)

### 17. `flash.nvim` (屏幕极速跳跃 - 键位神技)
- **是什么**：彻底告别狂按 `h/j/k/l` 或 `w/b` 移动光标。按 `s` 后输入目标两个字母，立刻瞬移到屏幕任意角落。
- **快捷键**：
  - `s`：启动 Flash 跳转（输入 2 个字母，然后按提示字母跳跃）
  - `S`：启动 Treesitter 语法块范围跳跃与选中
- **演练**：在 `ui_playground.py` 场景 04（第 108 行），按 `s` 然后输 `ta` 直达 `TARGET_ALPHA`！

### 18. `nvim-hlslens` (搜索结果透镜)
- **是什么**：按 `/` 搜文本或按 `*` 搜当前词时，在每一个匹配项右侧显示气泡透镜 `[当前序号/总匹配数]`。
- **快捷键**：
  - `*`：向后搜索光标下的词（自动激活透镜）
  - `n` / `N`：下一个 / 上一个搜索结果
- **演练**：在 `ui_playground.py` 场景 05（第 119 行），光标停在 `database_record_1` 上按 `*`。

### 19. `aerial.nvim` (代码大纲与符号侧边栏)
- **是什么**：在侧边栏树形展示当前文件的所有类、方法、函数、变量大纲，回车直接跳转。
- **快捷键**：
  - `<leader>cs`：打开/关闭代码大纲侧边栏
- **演练**：按 `<leader>cs` 呼出大纲，按 `j`/`k` 选中函数按回车。

### 20. `telescope.nvim` (经典模糊搜索框架)
- **是什么**：Neovim 社区最著名的弹窗模糊搜索器，底层接入 `telescope-fzf-native` 实现瞬时检索。
- **快捷键**：
  - `<leader>fy`：搜索剪贴板历史
  - `<leader>fF` / `:Telescope`：打开 Telescope 命令行模式

---

## 第四模块：文件管理与目录浏览 (2 个)

### 21. `neo-tree.nvim` (经典侧边栏文件树)
- **是什么**：类似 VSCode 的左侧项目工程树。
- **快捷键**：
  - `<leader>e`：打开/收起左侧文件树
  - `<leader>ge`：打开仅显示 Git 修改文件的树状图
  - 在树内按 `a` 新建文件，`d` 删除，`r` 重命名，`?` 查看帮助

### 22. `oil.nvim` (像编辑文本一样管理文件目录)
- **是什么**：把文件目录当成一个普通文本 buffer 来编辑！想重命名？直接修改那行文字按 `:w`！想新建文件？随便加一行文字按 `:w`！
- **快捷键**：
  - `-`：直接在当前窗口打开父级目录
  - `<leader>o`：以居中浮动窗口形式打开 Oil 目录浏览器

---

## 第五模块：Git 版本控制与全景对比 (4 个)

### 23. `diffview.nvim` (专业级双屏 Git 对比工作区)
- **是什么**：全功能 Git Diff 工作区，带左侧文件列表与右侧双屏左右对比，免除命令行 `git diff` 繁琐。
- **快捷键**：
  - `<leader>gd` 或 `<leader>gv`：**打开 Diffview 工作区**
  - `<leader>gD`：**查看当前文件的历史版本快照 (File History)**
  - `<leader>gV`：**查看整仓分支提交记录 (Branch History)**
  - `<leader>gq`：**一键退出关闭 Diffview**

### 24. `gitsigns.nvim` (行尾 Blame 与单行修改追踪)
- **是什么**：Sign 列着色修改条，300ms 自动在行尾浮现浅灰色的提交人与 Commit 信息。
- **快捷键**：
  - `<leader>ub`：★ **一键开/关行尾 Blame 显示**
  - `]h` / `[h`：跳到下一个 / 上一个 Git 修改块
  - `<leader>gp`：悬浮窗口预览当前修改块的具体变动
  - `<leader>gs` / `<leader>gr`：暂存 / 撤销恢复当前修改块

### 25. `hunk-review.nvim` (交互式 Hunk 审查浮窗)
- **快捷键**：`<leader>gH`：以大屏浮窗形式逐个审查当前未提交的代码变动。

### 26. `snacks.nvim` - Git 集成 (终端 LazyGit)
- **快捷键**：
  - `<leader>gg`：在 Neovim 内部直接呼出完整的终端图形化 **Lazygit**！
  - 同样可以用 `<leader><space>` 快速搜索全局文件。

---

## 第六模块：LSP 智能补全、诊断与格式化 (6 个)

### 27. `blink.cmp` (下一代极速智能补全引擎)
- **是什么**：比 nvim-cmp 更快、更丝滑的补全弹窗。支持图标、函数参数提示、代码片段展开。
- **交互**：打字时自动弹出，用 `<Tab>` / `<Down>` 选词，`<CR>` 确认上屏。

### 28. `nvim-lspconfig` (语言服务器客户端核心配置)
- **是什么**：Neovim 官方 LSP 客户端配置。
- **快捷键**：
  - `gd`：跳到定义处（Goto Definition）
  - `gD`：跳到声明处（Goto Declaration）
  - `K`：悬浮查看函数文档与类型签名（Hover）
  - `<leader>cr`：变量/函数智能重命名（LSP Rename）
  - `<leader>ca`：快速修复与代码动作（Code Action）

### 29. `mason.nvim` & 30. `mason-lspconfig.nvim` (LSP/工具安装器)
- **是什么**：可视化管理并自动下载各语言的 LSP 服务器（Pyright、LuaLS 等）。
- **命令**：
  - `:Mason` 或 `<leader>cm`：打开 Mason 可视化管理面板

### 31. `conform.nvim` (自动化代码格式化)
- **快捷键**：
  - `<leader>F`：对当前文件执行格式化（Python 自动调用 ruff，Lua 自动调用 stylua）

### 32. `fidget.nvim` (LSP 后台进度提示)
- **是什么**：在屏幕右下角以半透明微光显示 LSP 后台索引与加载进度，优雅安静。

---

## 第七模块：自研与私有专属插件 (5 个)

### 33. `contextline.nvim` (语法上下文感知)
- **是什么**：自研插件。在底部状态栏与顶部实时显示当前光标正处于哪一个函数、方法或类的内部。

### 34. `which-key.nvim` (按键备忘提示板)
- **是什么**：无论按 `<leader>`、`g`、`z` 还是 `[`，停顿片刻后屏幕下方会自动弹出一个半透明面板，列出当前所有可用快捷键和中文/英文描述。

### 35. `auto-session` (工作区会话自动记忆恢复)
- **是什么**：退出 Neovim 时自动保存您打开的所有文件、标签、分屏与光标位置；再次打开自动 100% 恢复工作现场。

### 36. `grug-far.nvim` (项目级超强全局批量正则查找与替换)
- **是什么**：比 VSCode 全局替换更强大的两栏式正则搜索替换面板。
- **快捷键**：
  - `<leader>sr`：打开两栏批量替换面板（左侧输入匹配与替换规则，右侧实时预览受影响的所有文件，一键应用）

### 37. `VimQuest.nvim` (私有 Vim 闯关游戏)
- **是什么**：私有游戏化练习插件，通过游戏闯关来熟悉 Vim 键位。
- **命令**：`:VimQuestStart` / `:VimQuestStop`。

---

## 第八模块：底层基础设施与依赖库 (6 个)

虽然平时无需直接操作，但它们支撑了上述全部功能的高速运转：
38. **`lazy.nvim`**：现代 Neovim 插件管理核心。输入 `:Lazy` 查看全部 45 个插件的加载耗时与运行状态。
39. **`plenary.nvim`**：Lua 异步与通用函数工具库。
40. **`nui.nvim`**：弹出窗、布局与组件基础库。
41. **`promise-async`**：异步协程 Promise 调度器（供 `nvim-ufo` 极速折叠）。
42. **`sqlite.lua`**：本地 SQLite 数据库绑定（供 `yanky` 剪贴板永久存储）。
43. **`telescope-fzf-native.nvim`**：C 语言编写的原生高性能模糊匹配算法动态链接库。
44. **`cobol.nvim`**：本地私有 COBOL 语言语法分析扩展。
45. **`batch.nvim`**：本地私有 Windows Batch 脚本语法高亮与语法规则支持。

---

## 日常高频快捷键速查终极便签

打印或随时对照此表，足以覆盖 95% 的日常高效编码操作：

```text
【全局与文件】
  <leader><space>    快速模糊查找文件 (Snacks Picker)
  <leader>e          开/关左侧 Neo-tree 文件树
  -                  用 Oil.nvim 打开当前目录进行文本化编辑
  <S-h> / <S-l>      切换上一个 / 下一个打开的标签文件
  <leader>bd         关闭当前文件标签
  :vsplit            左右垂直分屏 (分割线已调为内敛柔和灰色)

【屏幕跳跃与查找】
  s + 2个字母        ★ Flash 屏幕极速瞬移
  *                  向后搜索当前词 (带 hlslens 计数透镜)
  n / N              跳到下一个 / 上一个搜索结果
  <leader>cs         开/关左侧代码函数与类大纲 (Aerial)
  <leader>sr         打开项目级超级全局批量替换 (Grug-far)

【代码折叠与编辑】
  zc / zo            折叠 / 展开当前代码块
  zp                 ★ 悬浮预览当前折叠内部内容 (无需展开)
  zM / zR            一键折叠全文 / 一键展开全文
  Ctrl+n             ★ 多光标选中下一个相同词进行并发编辑 (按 c 修改)
  cia / vaf / yag    修改参数 / 选中整个函数 / 复制全文 (Mini.ai)
  p 然后按 [p / ]p   ★ 粘贴并原地循环轮换剪贴板历史
  <leader>fy         Telescope 浏览全部剪贴板历史
  <leader>F          自动格式化当前文件 (Conform)

【Git 工作流】
  <leader>ub         一键开/关行尾浅灰 Git Blame
  ]h / [h            跳到下一个 / 上一个 Git 修改块
  <leader>gp         弹窗预览当前行的 Git Diff
  <leader>gd         ★ 打开专业双屏 Diffview 工作区
  <leader>gD         查看当前文件的 Git 历史演变版本
  <leader>gq         一键退出 Diffview
  <leader>gg         呼出完整的终端 Lazygit
```

欢迎现在就执行 `nvim examples/ui_playground.py`，逐项尝试上述所有快捷键！
