      ******************************************************************
      * Author: ZACHARY ALEXANDER DAVIS
      * Date: May 7th, 2025
      * Purpose: TRIMS LEADING AND TRAILING SPACES. THE INBUILT TRIM
      *    FUNCTION DOES NOT WORK.
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRIMMER.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 CHAR-POSITION  PIC 9(2) VALUE 1.
       01 CHAR-CURRENT   PIC X VALUE SPACE.
       01 TRIMMED-FLAG   PIC X.

       LINKAGE SECTION.
       01 INPUT-STRING   PIC X(100).
       01 OUTPUT-STRING  PIC X(100).

       PROCEDURE DIVISION USING INPUT-STRING OUTPUT-STRING.
           PERFORM VARYING CHAR-POSITION FROM 1 BY 1 UNTIL
           CHAR-POSITION > LENGTH OF INPUT-STRING
               MOVE INPUT-STRING (CHAR-POSITION:1) TO CHAR-CURRENT
               IF CHAR-CURRENT = SPACE
                   MOVE CHAR-POSITION TO CHAR-POSITION
                   EXIT PERFORM
               END-IF
           END-PERFORM

           SUBTRACT 2 FROM CHAR-POSITION

           MOVE INPUT-STRING (1:CHAR-POSITION) TO OUTPUT-STRING
           EXIT PROGRAM.
       END PROGRAM TRIMMER.
