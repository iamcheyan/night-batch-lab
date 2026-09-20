# COBOL Workbook：夜间批处理学习闯关

这是一个可以独立运行的 COBOL 学习工作区。它模仿根目录的
`WORKBOOK.md`，但每一关同时练三件事：读懂 COBOL、完成一个小改动、在
Neovim 里使用 `cobol.nvim` 验证自己的理解。

```text
cobol-workbook/
├── lessons/       按顺序阅读的教程
├── exercises/     题库、练习要求和参考检查点
├── src/           固定格式 COBOL、Copybook、起始代码
├── data/          假数据和程序输出
├── scripts/       运行与验收脚本
└── PLUGIN_GUIDE.md cobol.nvim 配合练习卡
```

## 开始

从仓库根目录执行：

```bash
cd cobol-workbook
make check
make run
# 可选：练习坏记录和非零返回码
make run-invalid
```

然后按顺序阅读：

1. `lessons/01-language-map.md`：COBOL 程序的四大部、固定格式和数据描述
2. `lessons/02-file-and-flow.md`：顺序文件、`READ`、`PERFORM`、条件名
3. `lessons/03-record-processing.md`：`UNSTRING`、数值字段、校验和统计
4. `lessons/04-safe-rerun.md`：返回码、失败重跑、批处理协作
5. `exercises/QUESTION_BANK.md`：从观察题到综合题的 20 道题
6. `PLUGIN_GUIDE.md`：每一关对应的 `cobol.nvim` 操作提示

推荐每道题都按这个循环完成：

```text
读教程 → 在 Neovim 中定位代码 → 先写/修改代码 → make check
→ make run → 看 output/ → 故意制造一个失败 → make reset
```

## 运行目标

`src/SETTLE_WORKBOOK.COB` 是主练习程序。它读取 `data/input/transactions.csv`，
输出逐笔结果和汇总，并在发现坏记录时以非零返回码结束。程序使用
`src/copybooks/WORKBOOK-CONSTANTS.CPY`，因此可以练习 Copybook 跳转、字段
定义和 PIC 计算。

默认输入是成功样本；`data/input/transactions-invalid.csv` 是故障样本，
`make run-invalid` 会验证它返回 12，同时仍生成 summary。

`src/exercises/` 放着可以独立编译的小题，不会污染主程序。题目要求改动
`starter` 文件时，先复制到 `work/` 再练习；`make reset` 只清理生成物和
`work/` 中的复制品，不会删除题目原文。

## 与现有项目的关系

根目录的 `src/cobol/NIGHTSETTLE.COB` 是夜间作业的综合示例；这里是更适合
从零学习和重复练习的 workbook。两者共用相同的业务语境，但本目录保持
自包含。只使用假账号、假金额和本地文件，不连接 FTP 或真实设备。
