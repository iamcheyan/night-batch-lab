#!/usr/bin/env python3
"""
多文件联动实战总入口 (Multi-File Playground Entrypoint)
--------------------------------------------------------------------------------
本工程模拟了生产环境下的多模块协同架构：
  - config.py   : 颜色调色板与全局环境参数
  - models.py   : 数据契约模型与彩虹嵌套结构
  - engine.py   : 计算与统计核心引擎
  - service.py  : 业务调度与流水线管理
  - main.py     : 调度入口与综合测试台

================================================================================
【跨文件联动实战演练手册】：
  1. 跨文件跳转定义 (gd)：
     把光标停在第 35 行的 `BatchOrchestratorService` 上，按下 `gd`！
     -> 观察：Neovim 瞬间打开并跳入 `service.py` 内部定位到该类的声明位置！
     -> 在 `service.py` 内部，再把光标移到 `CalculationEngine` 上按 `gd`，瞬移进入 `engine.py`！
  2. 跨文件悬浮文档 (K)：
     把光标停在第 38 行的 `GLOBAL_CONFIG` 或 `COLOR_PALETTE` 上，按下 `K`！
     -> 观察：屏幕中央弹出悬浮卡片，直接展示来自 `config.py` 的类说明与字段注释！
  3. 跨文件多标签极速切换：
     跳入多个文件后，顶部标签栏（Bufferline）会同时列出所有打开的文件：
     -> 按 `<S-h>` 或 `[b`：切到左边打开的文件
     -> 按 `<S-l>` 或 `]b`：切到右边打开的文件
     -> 按 `<leader>bd`：关闭当前文件标签
  4. 跨文件代码重命名 (<leader>cr)：
     把光标放在任意一个跨文件调用的函数（例如 `create_mock_pipeline`）上，
     按下 `<leader>cr`，输入新名称，回车：
     -> 观察：LSP 会自动在所有关联文件中将该函数名同步重命名，且保持语法完整！
  5. 目录与工程浏览：
     -> 按 `-`（减号）或 `<leader>o`：用 Oil.nvim 打开当前目录进行文件管理
     -> 按 `<leader>e`：开/关左侧 Neo-tree 工程树
================================================================================
"""

import sys
from pathlib import Path

# 确保本 package 路径正确导入
CURRENT_DIR = Path(__file__).resolve().parent
if str(CURRENT_DIR.parent) not in sys.path:
    sys.path.insert(0, str(CURRENT_DIR.parent))

# ── 跨模块核心导入（在这里练习按 gd 跳转进入各个子文件！）──
from playground.config import COLOR_PALETTE, GLOBAL_CONFIG
from playground.models import BatchTransactionRecord, PipelineExecutionPlan
from playground.service import BatchOrchestratorService


def main() -> int:
    """主程序入口。按 zc 折叠此函数，按 zp 偷看，按 zo 展开。"""
    print(f"[{GLOBAL_CONFIG.app_name} v{GLOBAL_CONFIG.version}] Starting Multi-file Suite...")

    # 1. 实例化跨模块业务调度器 (试着把光标放在 BatchOrchestratorService 上按 gd)
    orchestrator = BatchOrchestratorService(service_id="ORCHESTRATOR-MAIN")

    # 2. 生成批处理执行计划
    plan = orchestrator.create_mock_pipeline(record_count=6)
    print(f"Generated plan: {plan.plan_name} with {plan.total_records} records.")

    # 3. 调度执行完整流水线
    summary = orchestrator.execute_full_plan(plan)
    print("\n--- Execution Summary ---")
    print(f"Plan Name        : {summary['plan_name']}")
    print(f"Processed Count  : {summary['processed_count']}")
    print(f"Mean Value       : {summary['statistics']['mean']}")
    print(f"Std Dev Value    : {summary['statistics']['std_dev']}")
    print(f"Active Theme Color: {summary['theme_active']}")

    print("\n[SUCCESS] Multi-file playground executed cleanly.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
