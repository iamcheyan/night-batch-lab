"""
领域模型与嵌套数据结构 (Domain Models & Schemas)
--------------------------------------------------------------------------------
本文件定义业务核心模型与嵌套协议。在 Neovim 中可用作以下演练：
  1. rainbow-delimiters.nvim - 查看下方多层嵌套字典/列表中的彩虹括号逐层变色
  2. mini.ai                 - 体验在类、方法、数据结构内部按 `vac`、`vif`、`cia`
  3. LSP 类型与定义跳转      - 在 service.py 中光标停在 BatchTransactionRecord 按 `gd`
"""

import enum
import time
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple


class ProcessingStatus(enum.Enum):
    """作业处理状态枚举。"""

    PENDING = "PENDING"
    IN_PROGRESS = "IN_PROGRESS"
    SUCCESS = "SUCCESS"
    FAILED = "FAILED"
    ROLLED_BACK = "ROLLED_BACK"


# ==============================================================================
# 彩虹嵌套括号演示数据结构 (用于测试 rainbow-delimiters)
# 每一层的 ()、[]、{} 均会呈现独立的主题色彩：
# 黄 -> 青 -> 蓝 -> 橙 -> 绿 -> 紫 -> 红
# ==============================================================================
PIPELINE_VALIDATION_SCHEMA: Dict[str, Any] = {
    "engine_version": "2026.09",
    "hierarchy": {
        "clusters": [
            (
                "cluster_primary",
                {
                    "nodes": [
                        {"node_id": 101, "zones": ["ap-east-1a", "ap-east-1b"]},
                        {
                            "node_id": 102,
                            "matrix": [
                                [10, 20, [30, (40, 50)]],
                                [60, 70, [80, (90, 100)]],
                            ],
                            "policy": {
                                "retries": (3, {"backoff_multiplier": 1.5}),
                            },
                        },
                    ],
                },
            ),
            (
                "cluster_secondary",
                {
                    "nodes": [
                        {"node_id": 201, "failover": (True, ["backup_site_a"])}
                    ]
                },
            ),
        ]
    },
}


@dataclass
class BatchTransactionRecord:
    """单个批处理事务记录实体模型。

    包含交易流水号、金额、账户及状态等核心业务属性。
    【演练提示】：
      - 将光标放在本类名上按 `K` 查看此文档；
      - 在其他文件中引用本类时按 `gd` 可瞬移跳转回此处；
      - 按 `<leader>cr` 可以将此类或其字段在整个工程中一键联动重命名！
    """

    transaction_id: str
    account_number: str
    amount_usd: float
    status: ProcessingStatus = ProcessingStatus.PENDING
    tags: List[str] = field(default_factory=list)
    created_at: float = field(default_factory=time.time)
    error_message: Optional[str] = None

    def is_settled(self) -> bool:
        """判断当前交易是否已结算完毕。"""
        return self.status == ProcessingStatus.SUCCESS

    def mark_completed(self) -> None:
        """标记当前交易执行成功。"""
        self.status = ProcessingStatus.SUCCESS

    def mark_failed(self, reason: str) -> None:
        """标记当前交易执行失败并记录错误原因。"""
        self.status = ProcessingStatus.FAILED
        self.error_message = reason


@dataclass
class PipelineExecutionPlan:
    """批处理执行计划实体。"""

    plan_name: str
    total_records: int
    scheduled_timestamp: float
    records: List[BatchTransactionRecord] = field(default_factory=list)
