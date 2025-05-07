      ******************************************************************
      * Author: ZACHARY ALEXANDER DAVIS
      * Date: MAY 7TH, 2025
      * Purpose: TO SUMMARIZE WISE TRANSACTION HISTORY CSVs
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       PROGRAM-ID. WISE-ANALYZE.
       ENVIRONMENT DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       CONFIGURATION SECTION.
      *-----------------------
       INPUT-OUTPUT SECTION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       FILE-CONTROL.
           SELECT CSV-FILE ASSIGN TO DYNAMIC FILE-NAME
               ORGANIZATION IS LINE SEQUENTIAL.
      *-----------------------
       DATA DIVISION.
      *-----------------------
       FILE SECTION.
       FD  CSV-FILE.
       01  CSV-RECORD              PIC X(100).
      *-----------------------
       WORKING-STORAGE SECTION.
       01  FILE-NAME               PIC X(100).
       01  TRIMMED-FILENAME        PIC X(100).
       01  NAME-FIELD              PIC X(30).
       01  MONEY-FIELD             PIC X(10).
       01  DATE-FIELD              PIC X(10).

       01  MONEY-NUMERIC           PIC 9(7)V99 VALUE 0.
       01  TOTAL-MONEY             PIC 9(9)V99 VALUE 0.
       01  RECORD-COUNT            PIC 9(5) VALUE 0.
       01  AVERAGE-MONEY           PIC 9(7)V99 VALUE 0.

       01  EOF-REACHED             PIC X VALUE "N".

      *-----------------------
       PROCEDURE DIVISION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       MAIN-PROCEDURE.
           DISPLAY "Enter filename (e.g., transactions.csv): "
           ACCEPT FILE-NAME

           CALL "TRIMMER" USING FILE-NAME TRIMMED-FILENAME
           MOVE TRIMMED-FILENAME TO FILE-NAME

           DISPLAY "Opening file " FILE-NAME

           OPEN INPUT CSV-FILE

      * Skip the first line (the header)
           READ CSV-FILE
               AT END
                  MOVE "Y" TO EOF-REACHED
           END-READ

           PERFORM UNTIL EOF-REACHED = "Y"
               READ CSV-FILE
                   AT END
                       MOVE "Y" TO EOF-REACHED
                   NOT AT END
                       UNSTRING CSV-RECORD
                           DELIMITED BY ","
                           INTO NAME-FIELD, MONEY-FIELD, DATE-FIELD

                       MOVE FUNCTION NUMVAL(MONEY-FIELD)
                       TO MONEY-NUMERIC

                       DISPLAY MONEY-FIELD

                       ADD MONEY-NUMERIC TO TOTAL-MONEY
                       ADD 1 TO RECORD-COUNT
               END-READ
           END-PERFORM

           CLOSE CSV-FILE

           IF RECORD-COUNT NOT = 0
               COMPUTE AVERAGE-MONEY = TOTAL-MONEY / RECORD-COUNT
               DISPLAY "Average price: " AVERAGE-MONEY
           ELSE
               DISPLAY "No records found."
           END-IF

           STOP RUN.
       END PROGRAM WISE-ANALYZE.
