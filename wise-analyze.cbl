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

      * CSV HEADERS
       01  TRANSFERWISE-ID-FIELD       PIC X(30).
       01  DATE-FIELD                  PIC X(30).
       01  AMOUNT-FIELD                PIC X(30).
       01  CURRENCY-FIELD              PIC X(30).
       01  DESCRIPTION-FIELD           PIC X(100).
       01  PAYMENT-REFERENCE-FIELD     PIC X(30).
       01  RUNNING-BALANCE-FIELD       PIC X(30).
       01  EXCHANGE-FROM-FIELD         PIC X(30).
       01  EXCHANGE-TO-FIELD           PIC X(30).
       01  EXCHANGE-RATE-FIELD         PIC X(30).
       01  PAYER-NAME-FIELD            PIC X(30).
       01  PAYEE-NAME-FIELD            PIC X(30).
       01  PAYEE-ACCOUNT-NUMBER-FIELD  PIC X(30).
       01  MERCHANT-FIELD              PIC X(30).
       01  CARD-LAST-FOUR-DIGITS-FIELD PIC X(30).
       01  CARD-HOLDER-FULL-NAME-FIELD PIC X(30).
       01  ATTACHMENT-FIELD            PIC X(30).
       01  NOTE-FIELD                  PIC X(30).
       01  TOTAL-FEES-FIELD            PIC X(30).
       01  EXCHANGE-TO-AMOUNT-FIELD    PIC X(30).

       01  MONEY-NUMERIC           PIC 9(7)V99 VALUE 0.
       01  TOTAL-MONEY             PIC 9(9)V99 VALUE 0.
       01  RECORD-COUNT            PIC 9(5) VALUE 0.
       77  AVERAGE-MONEY           PIC Z(8).99 VALUE 0.

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
                           INTO TRANSFERWISE-ID-FIELD, DATE-FIELD,
                           AMOUNT-FIELD, CURRENCY-FIELD,
                           DESCRIPTION-FIELD, PAYMENT-REFERENCE-FIELD,
                           RUNNING-BALANCE-FIELD, EXCHANGE-FROM-FIELD,
                           EXCHANGE-TO-FIELD, EXCHANGE-RATE-FIELD,
                           PAYER-NAME-FIELD, PAYEE-NAME-FIELD,
                           PAYEE-ACCOUNT-NUMBER-FIELD, MERCHANT-FIELD,
                           CARD-LAST-FOUR-DIGITS-FIELD,
                           CARD-HOLDER-FULL-NAME-FIELD,
                           ATTACHMENT-FIELD, NOTE-FIELD,
                           TOTAL-FEES-FIELD, EXCHANGE-TO-AMOUNT-FIELD

                       MOVE FUNCTION NUMVAL(AMOUNT-FIELD)
                       TO MONEY-NUMERIC

                       ADD MONEY-NUMERIC TO TOTAL-MONEY
                       ADD 1 TO RECORD-COUNT
               END-READ
           END-PERFORM

           CLOSE CSV-FILE

           IF RECORD-COUNT NOT = 0
               COMPUTE AVERAGE-MONEY = TOTAL-MONEY / RECORD-COUNT

               DISPLAY "Average transaction amount: " AVERAGE-MONEY
           ELSE
               DISPLAY "No records found."
           END-IF

           STOP RUN.
       END PROGRAM WISE-ANALYZE.
