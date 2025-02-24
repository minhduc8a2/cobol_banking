       IDENTIFICATION DIVISION.
       PROGRAM-ID. SHOW_USERS.
       
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
       01  PRINT-LINE PIC X(80).
       
      * Write Header
       01  USER-DB-HEADER.
           05 FILLER           PIC X(5)    VALUE SPACES.
           05 FILLER           PIC X(9)    VALUE '👤 User ID'.
           05 FILLER           PIC X(5)    VALUE SPACES.
           05 FILLER           PIC X(9)    VALUE '📛 Name'.
           05 FILLER           PIC X(5)    VALUE SPACES.
           05 FILLER           PIC X(9)    VALUE '📅 DOB'.
           05 FILLER           PIC X(5)    VALUE SPACES.
           05 FILLER           PIC X(9)    VALUE '💰 Balance'.
           05 FILLER           PIC X(5)    VALUE SPACES.

       01  USER-DB-ROW.
           05 FILLER           PIC X(5)    VALUE '|'.
           05 DET-USER-REC-ID PIC 9(10).
           05 FILLER           PIC X(5)    VALUE '|'.
           05 DET-USER-REC-NAME PIC X(50).
           05 FILLER           PIC X(5)    VALUE '|'.
           05 DET-USER-REC-DOB PIC X(10).
           05 FILLER           PIC X(5)    VALUE '|'.
           05 DET-BALANCE-REC-BALANCE PIC 9(10)V99.
           05 FILLER           PIC X(5)    VALUE '|'.

       PROCEDURE DIVISION.
           DISPLAY "-----------------------"
           DISPLAY "Show users is selected."
           DISPLAY "-----------------------"
                       
           PERFORM SHOW-USERS.
           GOBACK.

       OPEN-FILES.
            OPEN INPUT USER-DB-FILE.
            OPEN INPUT BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.

       WRITE-HEADER.
           MOVE USER-DB-HEADER TO PRINT-LINE.
           DISPLAY PRINT-LINE.
           
       SHOW-USERS.
           PERFORM OPEN-FILES.
           PERFORM WRITE-HEADER.
           PERFORM UNTIL USER-DB-FILE-STATUS = "10" 
               READ USER-DB-FILE NEXT RECORD
                   AT END MOVE "10" TO USER-DB-FILE-STATUS
                   NOT AT END 
                   MOVE USER-REC-ID TO BALANCE-REC-ID
                   READ BALANCE-DB-FILE KEY IS BALANCE-REC-ID
                   NOT INVALID KEY
                   MOVE USER-REC-ID TO DET-USER-REC-ID
                   MOVE USER-REC-NAME TO DET-USER-REC-NAME
                   MOVE USER-REC-DOB TO DET-USER-REC-DOB
                   MOVE BALANCE-REC-BALANCE TO DET-BALANCE-REC-BALANCE
                   MOVE USER-DB-ROW TO PRINT-LINE
                   DISPLAY PRINT-LINE
                   END-READ
                END-READ
           END-PERFORM.
           PERFORM CLOSE-FILES.
