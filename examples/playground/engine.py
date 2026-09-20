"""
计算引擎模块 (Core Calculation Engine)
--------------------------------------------------------------------------------
本文件包含计算密集型算法与处理流水线。在 Neovim 中可用作以下演练：
  1. nvim-ufo        - 在 `compute_statistical_metrics` 行按 `zc` 折叠，按 `zp` 悬浮偷看内部逻辑
  2. vim-visual-multi - 在 `metric_counter_*` 变量上按 `Ctrl+n` 选中多个相同单词并发编辑
  3. nvim-hlslens    - 在 `audit_checksum_token` 上按 `*`，体验带计数透镜的搜索与 `n`/`N` 跳转
  4. mini.ai         - 在 `execute_data_normalization` 函数参数上按 `cia` 修改单个参数
"""

import hashlib
import math
from typing import Dict, List, Tuple


class CalculationEngine:
    """核心批处理计算与校验引擎。

    负责处理复杂数学计算、校验和生成以及多字段并发统计。
    """

    def __init__(self, precision_digits: int = 4) -> None:
        self.precision_digits = precision_digits
        # 演示 nvim-hlslens 的连续匹配词汇
        self.audit_checksum_token_primary = "TOKEN-2026-PRIMARY"
        self.audit_checksum_token_secondary = "TOKEN-2026-SECONDARY"
        self.audit_checksum_token_tertiary = "TOKEN-2026-TERTIARY"

    # ==========================================================================
    # 演练 1: 代码折叠体验 (按 zc 折叠此长函数，按 zp 弹窗预览，按 zo 重新展开)
    # ==========================================================================
    def compute_statistical_metrics(
        self, data_points: List[float], scale_factor: float = 1.0
    ) -> Dict[str, float]:
        """计算数据集的统计均值、方差与标准差（折叠长代码块演练）。

        包含了多步计算循环，适合练习 nvim-ufo 的 `zc` / `zo` / `zp`。
        """
        if not data_points:
            return {"mean": 0.0, "variance": 0.0, "std_dev": 0.0}

        count = len(data_points)
        scaled_points = [x * scale_factor for x in data_points]

        # 第一阶段：均值计算
        total_sum = 0.0
        for val in scaled_points:
            total_sum += val
        mean_val = total_sum / count

        # 第二阶段：方差计算
        variance_accum = 0.0
        for val in scaled_points:
            diff = val - mean_val
            variance_accum += diff * diff
        variance_val = variance_accum / count

        # 第三阶段：标准差与四舍五入
        std_dev_val = math.sqrt(variance_val)
        return {
            "mean": round(mean_val, self.precision_digits),
            "variance": round(variance_val, self.precision_digits),
            "std_dev": round(std_dev_val, self.precision_digits),
            "count": float(count),
        }

    # ==========================================================================
    # 演练 2: 多光标编辑体验 (vim-visual-multi)
    # 光标停在第一行 `metric_counter` 上，连续按 4 次 `Ctrl+n`，然后按 `c` 统一重命名！
    # ==========================================================================
    def initialize_metrics_counters(self) -> Dict[str, int]:
        """初始化监控计数器指标集合。"""
        metric_counter_inbound = 100
        metric_counter_processed = 95
        metric_counter_failed = 3
        metric_counter_retried = 2
        return {
            "inbound": metric_counter_inbound,
            "processed": metric_counter_processed,
            "failed": metric_counter_failed,
            "retried": metric_counter_retried,
        }

    # ==========================================================================
    # 演练 3: 文本对象快速修改体验 (mini.ai)
    # 将光标放在参数 `param_decay_rate` 上，按 `cia`（Change Inner Argument）直接改写它！
    # ==========================================================================
    def execute_data_normalization(
        self,
        param_raw_value: float,
        param_lower_bound: float = 0.0,
        param_upper_bound: float = 100.0,
        param_decay_rate: float = 0.05,
    ) -> float:
        """执行数值归一化处理。用于练习 mini.ai 函数参数文本对象。"""
        clipped = max(param_lower_bound, min(param_raw_value, param_upper_bound))
        normalized = (clipped - param_lower_bound) / (param_upper_bound - param_lower_bound)
        decayed = normalized * math.exp(-param_decay_rate)
        return round(decayed, self.precision_digits)

    def generate_sha256_hash(self, payload_string: str) -> str:
        """为输入字符串计算标准 SHA-256 哈希散列摘要。"""
        hasher = hashlib.sha256()
        hasher.update(payload_string.encode("utf-8"))
        return hasher.hexdigest()
