       IDENTIFICATION DIVISION.
       PROGRAM-ID. CREATE_DB_FILES.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BALANCE-DB-FILE ASSIGN TO "balance.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS BALANCE-REC-ID
               FILE STATUS IS BALANCE-DB-FILE-STATUS.

           SELECT USER-DB-FILE ASSIGN TO "user.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS USER-REC-ID
               FILE STATUS IS USER-DB-FILE-STATUS.

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
       01  USER-DB-FILE-STATUS PIC XX.
       01  BALANCE-DB-FILE-STATUS PIC XX.


       PROCEDURE DIVISION.
           PERFORM CREATE-DB-FILES.
           PERFORM CLOSE-FILES.
           GOBACK.

       
       CLOSE-FILES.
           CLOSE BALANCE-DB-FILE.
           CLOSE USER-DB-FILE.
       CREATE-DB-FILES.
           DISPLAY "Checking database files..."

           OPEN I-O USER-DB-FILE.
           IF USER-DB-FILE-STATUS = "35" THEN
               DISPLAY "🔹 User database file not found. Creating..."
               OPEN OUTPUT USER-DB-FILE
               CLOSE USER-DB-FILE
               DISPLAY "✅ User database file created successfully."
           END-IF.

           OPEN I-O BALANCE-DB-FILE.
           IF BALANCE-DB-FILE-STATUS = "35" THEN
               DISPLAY 
               "🔹 Balance database file not found. Creating..."
               OPEN OUTPUT BALANCE-DB-FILE
               CLOSE BALANCE-DB-FILE
               DISPLAY "✅ Balance database file created successfully."
           END-IF.

