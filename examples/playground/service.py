"""
业务调度服务模块 (Batch Orchestrator Service)
--------------------------------------------------------------------------------
本文件是连接配置 (config.py)、模型 (models.py) 与算法引擎 (engine.py) 的核心枢纽。
在 Neovim 中可用作以下【跨文件 LSP 联动】演练：
  1. `gd` (跳转定义)  - 把光标停在 BatchTransactionRecord 或 CalculationEngine 上按 `gd`，瞬移跳入对应文件！
  2. `K`  (悬浮文档)  - 光标停在任何跨文件类名、方法名或字段上按 `K`，弹窗查看跨模块文档！
  3. `<leader>cr` (跨文件重命名) - 对某个类或方法执行重命名，所有引用该符号的文件同时修改！
  4. `<S-h>` / `<S-l>` - 在打开的多个代码标签之间快速左右切换！
"""

import time
from typing import Any, Dict, List, Optional

# 跨模块导入：把光标停在这些类上按 `gd` 即可直达对应源文件！
from .config import COLOR_PALETTE, GLOBAL_CONFIG
from .engine import CalculationEngine
from .models import (
    BatchTransactionRecord,
    PipelineExecutionPlan,
    ProcessingStatus,
)


class BatchOrchestratorService:
    """夜间批处理业务调度器服务。

    通过跨模块协同调度，完成交易记录的处理、校验与结果汇总。
    """

    def __init__(self, service_id: str = "SVC-ORCHESTRATOR-01") -> None:
        self.service_id = service_id
        # 跨模块引用 CalculationEngine：试着将光标放在它上面按 `gd`
        self.engine = CalculationEngine(precision_digits=4)
        self.execution_log: List[str] = []

    def create_mock_pipeline(self, record_count: int = 5) -> PipelineExecutionPlan:
        """构建模拟交易执行计划。

        测试点：将光标放在 `PipelineExecutionPlan` 上，按 `gd` 跳转到 models.py。
        """
        plan = PipelineExecutionPlan(
            plan_name=f"DAILY-SETTLE-{int(time.time())}",
            total_records=record_count,
            scheduled_timestamp=time.time(),
        )
        for i in range(1, record_count + 1):
            record = BatchTransactionRecord(
                transaction_id=f"TXN-2026-{i:04d}",
                account_number=f"ACCT-{8000 + i}",
                amount_usd=100.0 * i + 12.5,
                status=ProcessingStatus.PENDING,
            )
            plan.records.append(record)
        return plan

    def process_single_transaction(
        self, record: BatchTransactionRecord
    ) -> Dict[str, Any]:
        """处理单笔批处理交易（演示跨文件方法调用与错误处理）。"""
        record.status = ProcessingStatus.IN_PROGRESS

        # 调用引擎计算归一化权重
        normalized_weight = self.engine.execute_data_normalization(
            param_raw_value=record.amount_usd,
            param_lower_bound=0.0,
            param_upper_bound=1000.0,
        )

        # 模拟生成安全审计校验码
        audit_raw = f"{record.transaction_id}:{record.amount_usd}:{normalized_weight}"
        audit_hash = self.engine.generate_sha256_hash(audit_raw)

        record.mark_completed()
        return {
            "txn_id": record.transaction_id,
            "weight": normalized_weight,
            "audit_hash": audit_hash,
            "status_color": COLOR_PALETTE["fresh_green"],
        }

    def execute_full_plan(
        self, plan: PipelineExecutionPlan
    ) -> Dict[str, Any]:
        """批量调度整个流水线计划并返回综合指标。"""
        results = []
        amounts = []
        for rec in plan.records:
            res = self.process_single_transaction(rec)
            results.append(res)
            amounts.append(rec.amount_usd)

        # 调用引擎聚合统计指标
        stats = self.engine.compute_statistical_metrics(amounts)
        return {
            "plan_name": plan.plan_name,
            "service_id": self.service_id,
            "app_version": GLOBAL_CONFIG.version,
            "processed_count": len(results),
            "statistics": stats,
            "theme_active": COLOR_PALETTE["fresh_yellow"],
        }
