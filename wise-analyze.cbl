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

      *01  DELIMITER               PIC X VALUE ",".
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

           CLOSE CSV-FILE

           STOP RUN.
       END PROGRAM WISE-ANALYZE.
