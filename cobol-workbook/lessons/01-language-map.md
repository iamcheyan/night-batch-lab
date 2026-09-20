# 01 — 先读懂一份 COBOL

COBOL 源码按列有含义：传统固定格式中第 1–6 列是序号区，第 7 列是注释
或续行标志，第 8–11 列常用于 A 区，第 12–72 列是 B 区。`cobol.nvim`
的固定格式提示可以把这些边界显示出来。

四大部是：

- `IDENTIFICATION DIVISION`：程序身份。
- `ENVIRONMENT DIVISION`：文件和外部环境。
- `DATA DIVISION`：文件记录、工作字段、Copybook。
- `PROCEDURE DIVISION`：执行流程。

重点不是背关键词，而是能从字段定义反推数据形状。例如 `PIC 9(08)` 是 8
位数字，`PIC X(06)` 是 6 位字符，`COMP-3` 适合批处理中的压缩十进制数值。

练习：打开 `src/SETTLE_WORKBOOK.COB`，在每个 division 和 paragraph 上写一
句中文注释；不要改变第 7 列和代码区的位置。

