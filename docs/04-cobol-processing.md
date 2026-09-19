# 04 — COBOL processing

`src/cobol/NIGHTSETTLE.COB` reads a line-sequential input file, splits each
CSV-like record with `UNSTRING`, counts successful and error records, totals
the amount, and writes a report.

Important places to study:

- `FILE-CONTROL`: logical file names and runtime assignment
- `COPY NIGHT-CONSTANTS`: shared Copybook data definitions
- `88 EOF-YES`: a condition name used to control the read loop
- `1000-READ`: one input read and the end-of-file branch
- `1100-PROCESS-RECORD`: validation and counters
- `2000-WRITE-SUMMARY`: the control total written at the end

The first run intentionally exposed a common paragraph-flow bug: performing a
section instead of one paragraph caused the record-processing paragraph to be
executed twice. The corrected code performs `1000-READ` explicitly. This is a
good example of why paragraph boundaries and `PERFORM` targets matter.
