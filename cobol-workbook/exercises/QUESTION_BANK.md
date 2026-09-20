# COBOL 题库：20 道闯关题

先做观察题，再做改码题。除非题目明确要求，不要改 `src/exercises` 的原题；
把实验复制到 `work/`。每题完成后运行 `make check`，综合题再运行 `make run`。

## 第一关：看懂代码（01–05）

1. 指出 `SETTLE_WORKBOOK.COB` 的四个 division，并写出各自职责。
2. 计算 `WS-AMOUNT`、`WS-TOTAL-AMOUNT` 的最大可表示位数。
3. 找出 `EOF-YES` 的定义、设置位置和使用位置。
4. 解释为什么 `1000-READ` 里要 `PERFORM 1100-PROCESS-RECORD`。
5. 从 `COPY WORKBOOK-CONSTANTS` 跳到 Copybook，列出 4 个共享字段。

## 第二关：编辑与流程（06–10）

6. 把 summary 的标签 `ERROR` 改成 `INVALID`，不改变计数逻辑。
7. 把输出逐笔记录增加原始金额文本列，并保持旧列顺序不变。
8. 把 `WS-RETURN-CODE` 的成功值明确设为 0，并解释 `GOBACK` 前的作用。
9. 给 `OPEN` 增加文件状态字段，文件打开失败时显示日文错误并返回 20。
10. 故意把 `PERFORM 1000-READ` 改成错误 paragraph，在 Neovim 里观察诊断，再恢复。

## 第三关：数据校验（11–15）

11. 拒绝空账号，并让该记录变成 `NG`。
12. 拒绝金额大于 `WS-MAX-AMOUNT` 的记录。
13. 新增 `WS-PENDING-COUNT`，统计状态为 `PD` 的记录。
14. 输入中增加一行 `000106,120,PD`，让它出现在输出但不进入成功总额。
15. 解释 `MOVE WS-AMOUNT-TEXT TO WS-AMOUNT` 在非数字文本下的风险，并设计防护。

## 第四关：综合实战（16–20）

16. 把逐笔处理改成独立 paragraph，并确保每条记录只处理一次。
17. 在 summary 增加 `PENDING` 字段，运行后用人工计算核对。
18. 增加“最大单笔金额”统计，并在 summary 输出。
19. 编写 `work/compare-report.sh`，比较两次输出的 summary 和记录数。
20. 写一份 `docs/plugin-notes/` 问题记录：至少复现一次固定格式、Copybook
    跳转或 PIC 提示上的真实不便，并提出通用插件功能。

## 参考验收问题

完成综合题时，回答：坏记录是否仍然输出？进程是否非零退出？重跑前旧输出
是否被清理？Copybook 改动是否影响所有使用它的源文件？这些问题比“屏幕上
有没有一行正确字符串”更接近批处理维护工作。

