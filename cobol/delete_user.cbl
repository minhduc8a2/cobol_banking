       IDENTIFICATION DIVISION.
       PROGRAM-ID. DELETE_USER.
       
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
           05 USER-REC-NAME PIC X(50).
           05 USER-REC-DOB PIC X(10).
           
       FD BALANCE-DB-FILE.
       01 BALANCE-DB-RECORD.
           05 BALANCE-REC-ID PIC 9(10).
           05 BALANCE-REC-BALANCE PIC 9(10)V99.

       
       WORKING-STORAGE SECTION.
       01 USER-CONFIRM PIC X.
       


       PROCEDURE DIVISION.
           DISPLAY"------------------------"
           DISPLAY "Delete user is selected."
           DISPLAY"------------------------"
           PERFORM DELETE-USER.
           GOBACK.

       OPEN-FILES.
            OPEN I-O USER-DB-FILE.
            OPEN I-O BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.
       DELETE-USER.
           PERFORM OPEN-FILES.
           DISPLAY "Enter User ID: "
           ACCEPT USER-REC-ID.
           READ USER-DB-FILE
            INVALID KEY
                 DISPLAY "❌User not found."
            NOT INVALID KEY
                 MOVE USER-REC-ID TO BALANCE-REC-ID
                 READ BALANCE-DB-FILE KEY IS BALANCE-REC-ID
                     NOT INVALID KEY
                          DISPLAY "👤 User ID: " USER-REC-ID
                                     " 📛 Name: " USER-REC-NAME
                                     " 📅 DOB: " USER-REC-DOB
                                     " 💰 Balance: " 
                                     BALANCE-REC-BALANCE
                          DISPLAY 
                    "Are you sure you want to delete this user? (Y/N)"
                     ACCEPT USER-CONFIRM.
                    IF USER-CONFIRM = "Y" OR "y"
                        DELETE USER-DB-FILE
                        DELETE BALANCE-DB-FILE
                        DISPLAY "User deleted."
                    ELSE
                        DISPLAY "Cancelled."
                    END-IF
                 
          
           PERFORM CLOSE-FILES.
