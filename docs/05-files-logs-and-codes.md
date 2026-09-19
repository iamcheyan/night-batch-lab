# 05 — Files, logs, and return codes

The lab uses these operational states:

| Code | Meaning |
| ---: | --- |
| 0 | Job completed normally |
| 11 | Input file missing |
| 12 | Input file empty |
| 13 | Input record format invalid |
| 21 | COBOL processing failed |
| 22 | Output missing or empty |
| 23 | Archive failed |
| 31 | Upload/transfer failed |

The exact values are training conventions. The important practice is that
each layer has a contract: a child step returns a code, and the parent step
checks it before continuing.

Inspect `logs/` after `make run`. Then change one input record to an invalid
value and observe the validation failure before COBOL starts.
