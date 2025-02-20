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
           05 USER-REC-NAME PIC X(50).
           05 USER-REC-DOB PIC X(10).
           
       FD BALANCE-DB-FILE.
       01 BALANCE-DB-RECORD.
           05 BALANCE-REC-ID PIC 9(10).
           05 BALANCE-REC-BALANCE PIC 9(10)V99.

       
       WORKING-STORAGE SECTION.
       01  USER-DB-FILE-STATUS PIC XX.



       PROCEDURE DIVISION.
           PERFORM SHOW-USERS.
           GOBACK.

       OPEN-FILES.
            OPEN INPUT USER-DB-FILE.
            OPEN INPUT BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.
       SHOW-USERS.
           PERFORM OPEN-FILES.
           PERFORM UNTIL USER-DB-FILE-STATUS = "10" 
               READ USER-DB-FILE NEXT RECORD
                   AT END MOVE "10" TO USER-DB-FILE-STATUS
                   NOT AT END 
                   MOVE USER-REC-ID TO BALANCE-REC-ID
                   READ BALANCE-DB-FILE KEY IS BALANCE-REC-ID
                   NOT INVALID KEY
                   DISPLAY "👤 User ID: " USER-REC-ID
                              " 📛 Name: " USER-REC-NAME
                              " 📅 DOB: " USER-REC-DOB
                              " 💰 Balance: " BALANCE-REC-BALANCE
           END-PERFORM.
           PERFORM CLOSE-FILES.
