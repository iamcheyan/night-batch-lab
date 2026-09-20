"""
配置中心模块 (Configuration Center)
--------------------------------------------------------------------------------
本文件定义了系统全局配置、环境参数与主题调色盘。
在 Neovim 中可用作以下演练：
  1. mini.hipatterns - 查看下方十六进制 HEX 颜色背景实时渲染
  2. ccc.nvim        - 光标停在颜色上，执行 :CccPick 或 :CccConvert
  3. LSP 引用与跳跃   - 在其他文件中引用 COLOR_PALETTE 时，按 gd 跳转回此处
"""

from dataclasses import dataclass
from typing import Dict


# ==============================================================================
# 1. 主题调色板 (用于测试 mini.hipatterns & ccc.nvim)
# ==============================================================================
COLOR_PALETTE: Dict[str, str] = {
    "fresh_yellow": "#ffff00",  # 醒目亮黄：关键字、光标、滑块高亮
    "fresh_cyan":   "#00ffff",  # 明亮青色：状态、边界、提示
    "fresh_green":  "#00cd00",  # 翠绿色：Git 新增、字符串、成功状态
    "fresh_red":    "#ff5050",  # 绯红色：Git 删除、报错、异常状态
    "fresh_orange": "#ff9900",  # 暖橙色：警告、参数、类型
    "fresh_blue":   "#569cd6",  # 经典蓝：常量、选择背景
    "fresh_purple": "#c586c0",  # 典雅紫：操作符、特殊标记
    "track_gray":   "#25252a",  # 轨道深灰：滚动条背景轨道
    "split_gray":   "#333338",  # 分割线灰：柔和低调的窗口分界线
    "text_white":   "#ffffff",  # 纯白前景色：主要正文字体
}


@dataclass(frozen=True)
class SystemRuntimeConfig:
    """系统运行时基础参数配置类。

    提供批处理流水线所需的高频默认参数。可在 service.py 或 main.py 中通过
    LSP 的 `gd` (跳转定义) 或 `K` (悬浮文档) 查看本类的完整字段说明。
    """

    app_name: str = "NightBatchLab"
    version: str = "2.4.0"
    max_worker_threads: int = 8
    default_timeout_seconds: float = 45.0
    enable_verbose_logging: bool = True
    storage_root: str = "/tmp/night-batch-lab"
    alert_color: str = COLOR_PALETTE["fresh_red"]
    success_color: str = COLOR_PALETTE["fresh_green"]


GLOBAL_CONFIG = SystemRuntimeConfig()
