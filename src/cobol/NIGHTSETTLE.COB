      ******************************************************************
      * NIGHTSETTLE.COB - Night settlement training program            *
      * Fixed-format COBOL. Input: account,amount,status                *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. NIGHTSETTLE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO "NIGHT_INPUT"
      -        ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE ASSIGN TO "NIGHT_OUTPUT"
      -        ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-LINE                  PIC X(80).
       FD  OUTPUT-FILE.
       01  OUTPUT-LINE                 PIC X(120).

       WORKING-STORAGE SECTION.
       COPY NIGHT-CONSTANTS.
       01  WS-EOF-FLAG                 PIC X VALUE "N".
           88  EOF-YES                 VALUE "Y".
       01  WS-ACCOUNT                  PIC X(06).
       01  WS-AMOUNT                   PIC 9(10) VALUE ZERO.
       01  WS-AMOUNT-TEXT              PIC X(10).
       01  WS-STATUS                   PIC X(02).
       01  WS-RECORD-COUNT             PIC 9(05) COMP-3 VALUE ZERO.
       01  WS-SUCCESS-COUNT            PIC 9(05) COMP-3 VALUE ZERO.
       01  WS-ERROR-COUNT              PIC 9(05) COMP-3 VALUE ZERO.
       01  WS-TOTAL-AMOUNT             PIC 9(12) COMP-3 VALUE ZERO.
       01  WS-OUT-COUNT                PIC 9(05).
       01  WS-OUT-SUCCESS              PIC 9(05).
       01  WS-OUT-ERROR                PIC 9(05).
       01  WS-OUT-TOTAL                PIC 9(12).
       01  WS-OUT-AMOUNT               PIC 9(10).
       01  WS-REPORT-LINE              PIC X(120).

       PROCEDURE DIVISION.
       0000-MAIN SECTION.
       0000-START.
           OPEN INPUT INPUT-FILE
                OUTPUT OUTPUT-FILE
           PERFORM 1000-READ
               UNTIL EOF-YES
           PERFORM 2000-WRITE-SUMMARY
           CLOSE INPUT-FILE OUTPUT-FILE
           GOBACK.

       1000-READ-AND-PROCESS SECTION.
       1000-READ.
           READ INPUT-FILE
               AT END
                   SET EOF-YES TO TRUE
               NOT AT END
                   ADD 1 TO WS-RECORD-COUNT
                   PERFORM 1100-PROCESS-RECORD
           END-READ.

       1100-PROCESS-RECORD.
           MOVE ZERO TO WS-AMOUNT
           UNSTRING INPUT-LINE DELIMITED BY ","
               INTO WS-ACCOUNT WS-AMOUNT-TEXT WS-STATUS
           END-UNSTRING
           IF WS-STATUS = WS-STATUS-OK
               MOVE WS-AMOUNT-TEXT TO WS-AMOUNT
               ADD 1 TO WS-SUCCESS-COUNT
               ADD WS-AMOUNT TO WS-TOTAL-AMOUNT
           ELSE
               ADD 1 TO WS-ERROR-COUNT
           END-IF
           MOVE WS-RECORD-COUNT TO WS-OUT-COUNT
           MOVE WS-AMOUNT TO WS-OUT-AMOUNT
           STRING WS-ACCOUNT DELIMITED BY SIZE
               "," DELIMITED BY SIZE
               WS-STATUS DELIMITED BY SIZE
               "," DELIMITED BY SIZE
               WS-OUT-AMOUNT DELIMITED BY SIZE
               INTO WS-REPORT-LINE
           END-STRING
           WRITE OUTPUT-LINE FROM WS-REPORT-LINE.

       2000-WRITE-SUMMARY SECTION.
       2000-SUMMARY.
           MOVE WS-RECORD-COUNT TO WS-OUT-COUNT
           MOVE WS-SUCCESS-COUNT TO WS-OUT-SUCCESS
           MOVE WS-ERROR-COUNT TO WS-OUT-ERROR
           MOVE WS-TOTAL-AMOUNT TO WS-OUT-TOTAL
           STRING "SUMMARY,COUNT=" DELIMITED BY SIZE
               WS-OUT-COUNT DELIMITED BY SIZE
               ",SUCCESS=" DELIMITED BY SIZE
               WS-OUT-SUCCESS DELIMITED BY SIZE
               ",ERROR=" DELIMITED BY SIZE
               WS-OUT-ERROR DELIMITED BY SIZE
               ",TOTAL=" DELIMITED BY SIZE
               WS-OUT-TOTAL DELIMITED BY SIZE
               INTO WS-REPORT-LINE
           END-STRING
           WRITE OUTPUT-LINE FROM WS-REPORT-LINE.
