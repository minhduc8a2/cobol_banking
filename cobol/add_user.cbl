       IDENTIFICATION DIVISION.
       PROGRAM-ID. ADD_USER.
       
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
       01  EXIT-ADD-USER PIC X VALUE 'Y'.
       


       PROCEDURE DIVISION.
           DISPLAY"----------------------"
           DISPLAY "Add user is selected."
           DISPLAY"----------------------"
           PERFORM ADD-USER.
           GOBACK.

       OPEN-FILES.
            OPEN I-O USER-DB-FILE.
            OPEN I-O BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.
       ADD-USER.
           
           PERFORM UNTIL EXIT-ADD-USER <> "Y" AND EXIT-ADD-USER <> "y"
                DISPLAY "Enter User Name: "
                ACCEPT USER-REC-NAME
                DISPLAY "Enter User DOB: "
                ACCEPT USER-REC-DOB
                DISPLAY "Enter User Balance: "
                ACCEPT BALANCE-REC-BALANCE

                CALL "FIND_MAX_ID" USING USER-REC-ID
                MOVE USER-REC-ID TO BALANCE-REC-ID
                PERFORM OPEN-FILES
                WRITE USER-DB-RECORD
                END-WRITE
                WRITE BALANCE-DB-RECORD
                END-WRITE
                PERFORM CLOSE-FILES
                DISPLAY "User ID: " USER-REC-ID
                DISPLAY "BALANCE ID: " BALANCE-REC-ID
                DISPLAY "User added successfully."
                DISPLAY "Do you want to add another user? (Y/N)"
                ACCEPT EXIT-ADD-USER
           END-PERFORM.
           
