# cobol.nvim 配合练习卡

本目录故意保留固定格式 COBOL。不要先把代码改成自由格式；编辑器显示的
A/B 区、行号和注释位置本身就是练习内容。具体按键以你当前的
`cobol.nvim` 配置为准，下面的命令名是能力提示，不依赖机器专属映射。

## 每次打开文件先做的 5 件事

1. 打开 `src/SETTLE_WORKBOOK.COB`，确认 fixed-format guide 能分出 A 区、B 区。
2. 折叠 `IDENTIFICATION`、`DATA`、`PROCEDURE` 各个 section，观察 section/paragraph 层级。
3. 把光标放在 `COPY WORKBOOK-CONSTANTS` 上，使用 Copybook 跳转打开 `.CPY`。
4. 把光标放在 `WS-TOTAL-AMOUNT`、`WS-AMOUNT` 上，使用 PIC/字段信息提示检查位数和类型。
5. 故意把 `PERFORM 1100-PROCESS-RECORD` 改成不存在的段名，观察 diagnostics；改回后再编译。

## 按课程对应的编辑器观察点

| 课程 | 代码位置 | 建议插件动作 |
|---|---|---|
| 01 语言地图 | `DATA DIVISION` | 显示列标尺、固定格式高亮、折叠四大部 |
| 02 文件与流程 | `1000-READ` | 在 paragraph 之间跳转，查看 `PERFORM` 目标 |
| 03 记录处理 | `UNSTRING` / `STRING` | 观察字段类型、PIC 计算和诊断 |
| 04 安全重跑 | `RETURN-CODE` | 搜索所有返回码，比较 shell 与 COBOL 的边界 |
| 题库 11 | `WORKBOOK-CONSTANTS.CPY` | 从 COPY 跳转到 Copybook，再返回原处 |
| 题库 16 | `1100-PROCESS-RECORD` | 折叠 paragraph，使用大纲或符号列表定位 |

## 插件问题记录模板

如果某个动作不顺手，不要加本地一次性映射来掩盖问题。复制下面模板到
仓库根目录的 `docs/plugin-notes/`，文件名用日期和主题命名，然后继续做题：

```text
Problem: 在哪个 COBOL 文件、哪一列、哪个编辑动作遇到困难
Context: 例如 src/SETTLE_WORKBOOK.COB:1100-PROCESS-RECORD
Expected: 希望插件显示/跳转/诊断什么
Candidate: 一个可复用的 cobol.nvim 功能，而不是本仓库专属映射
```

