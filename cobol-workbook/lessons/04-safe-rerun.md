# 04 — 让 COBOL 成为可重跑的批步骤

COBOL 负责记录处理和 `RETURN-CODE`；shell 负责检查输入、清理旧输出、
调用程序和验证输出。这种边界很适合夜间作业：每层只承担自己最清楚的
责任，失败时给下一层明确的非零码。

运行 `make run` 后，观察 `data/output/settlement-report.txt`。再把输入文件
临时移走，执行 `make run`，确认脚本在 COBOL 启动前以 10 退出；最后用
`make reset` 恢复工作区。不要用 `rm -rf data` 之类的宽泛命令练习恢复。

练习：让一条坏记录使 COBOL 返回 12，但仍写完 summary；说明为什么这比
遇到第一条坏记录就立刻退出更适合学习和日终核对。

