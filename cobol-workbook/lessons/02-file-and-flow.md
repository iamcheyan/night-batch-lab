# 02 — 文件读写与段落流程

`SELECT` 给文件一个逻辑名，运行时通过 `NIGHT_INPUT` 与 `NIGHT_OUTPUT`
注入实际路径。`OPEN` 后，`READ ... AT END` 每次读一条记录；到文件尾时把
条件名 `EOF-YES` 设为真，外层 `PERFORM ... UNTIL` 随之结束。

注意 `PERFORM 1000-READ` 只执行一个 paragraph。若误写成包含后续 paragraph
的 section，可能让一笔记录被处理两次。固定格式 COBOL 的段落边界是非常
值得在编辑器里折叠、跳转和核对的结构。

练习：在不改业务结果的前提下，给 `OPEN`、`READ`、`CLOSE` 增加失败处理，
并说明文件状态应该在哪里检查。

