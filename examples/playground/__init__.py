"""
Neovim 多文件跨模块实战演示包 (Playground Package)
--------------------------------------------------------------------------------
通过此包将业务配置、数据模型、计算引擎与编排服务完整联结，模拟真实生产级 Python 模块架构。
"""

from .config import COLOR_PALETTE, GLOBAL_CONFIG, SystemRuntimeConfig
from .engine import CalculationEngine
from .models import (
    PIPELINE_VALIDATION_SCHEMA,
    BatchTransactionRecord,
    PipelineExecutionPlan,
    ProcessingStatus,
)
from .service import BatchOrchestratorService

__all__ = [
    "COLOR_PALETTE",
    "GLOBAL_CONFIG",
    "SystemRuntimeConfig",
    "CalculationEngine",
    "PIPELINE_VALIDATION_SCHEMA",
    "BatchTransactionRecord",
    "PipelineExecutionPlan",
    "ProcessingStatus",
    "BatchOrchestratorService",
]
