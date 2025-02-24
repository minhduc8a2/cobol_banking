       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLEAR_DATABASE.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BALANCE-DB-FILE ASSIGN TO "balance.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS BALANCE-REC-ID.
           SELECT USER-DB-FILE ASSIGN TO "user.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS USER-REC-ID.
               

       DATA DIVISION.
       FILE SECTION.
       FD USER-DB-FILE.
       01 USER-DB-RECORD.
           05 USER-REC-ID PIC 9(10).
           05 USER-REC-NAME PIC X(30).
           05 USER-REC-DOB PIC X(10).
           
       FD BALANCE-DB-FILE.
       01 BALANCE-DB-RECORD.
           05 BALANCE-REC-ID PIC 9(10).
           05 BALANCE-REC-BALANCE PIC 9(10)V99.
       WORKING-STORAGE SECTION.
       01 CONFIRMATION PIC X.
       PROCEDURE DIVISION.
           PERFORM CLEAR_DATABASE.
           GOBACK.

       OPEN-FILES.
            OPEN OUTPUT USER-DB-FILE.
            OPEN OUTPUT BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.
       CLEAR_DATABASE.
           DISPLAY "Are you sure you want to clear database? (Y/N)".
           ACCEPT CONFIRMATION.
           IF CONFIRMATION = "Y" OR CONFIRMATION = "y" THEN
               DISPLAY "Clearing database..."
               PERFORM OPEN-FILES
               PERFORM CLOSE-FILES
               DISPLAY "✅Done."
           ELSE
               DISPLAY "Cancelled."
           END-IF.
           