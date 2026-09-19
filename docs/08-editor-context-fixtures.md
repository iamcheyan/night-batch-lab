# Editor context fixtures

The files under `examples/` are small, self-contained samples for practicing
the languages that commonly appear around a night-batch system. They are also
test files for the Neovim statusline context display.

They do not need to be executed. Open one in Neovim, move the cursor through
the classes, functions, methods, SQL sections, and HTML elements, and watch
the bottom statusline. With the private configuration, `contextline.nvim`
uses the Tree-sitter provider for common languages; COBOL and Windows Batch
continue to use their language-specific providers.

## Open the fixtures

From this project directory:

```text
nvim examples/python/night_report.py
nvim examples/javascript/csv2xls.js
nvim examples/typescript/night-job.ts
nvim examples/java/NightBatchRunner.java
nvim examples/go/report_uploader.go
nvim examples/ruby/night_report.rb
nvim examples/sql/settlement_report.sql
nvim examples/html/night-report.html
```

Inside Neovim, move the cursor with `]m`, `]M`, `%`, or ordinary movement. If
the statusline is not visible, check that the buffer has the expected
filetype:

```vim
:set filetype?
:TSBufEnable highlight
```

The second command is optional and only helps confirm that a Tree-sitter
parser is active. The context display itself should not require an LSP server.

## What each sample exercises

| File | Useful context to inspect |
| --- | --- |
| `python/night_report.py` | dataclass, class, methods, validation, report writing |
| `javascript/csv2xls.js` | class, parsing functions, conversion workflow |
| `typescript/night-job.ts` | enum, interface, class, typed methods |
| `java/NightBatchRunner.java` | class, constructor, methods, nested record |
| `go/report_uploader.go` | struct, methods, validation and upload flow |
| `ruby/night_report.rb` | class, initializer, instance methods |
| `sql/settlement_report.sql` | CTE and report query structure |
| `html/night-report.html` | document sections, form controls, report layout |

The exact context depends on the installed parser grammar. A language may
still show syntax highlighting even when its Tree-sitter parser is not
installed; in that case the generic context provider has no hierarchy to
display. Install the parser through your normal `nvim-treesitter` setup when
you want to test that language's context support.

## Related legacy fixtures

For the language-specific providers, open these files as well:

```text
src/cobol/NIGHTSETTLE.COB
windows-batch/csv2xls-upload.bat
linux-shell/nightly-main.sh
```

COBOL displays format, area, divisions, sections, paragraphs, data items, and
record sizes. Batch displays labels, line numbers, and jump or call targets.
Shell files use the generic Tree-sitter provider when a Bash parser is
available.
