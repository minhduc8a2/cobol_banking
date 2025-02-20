       IDENTIFICATION DIVISION.
       PROGRAM-ID. EDIT_USER.
       
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
       01  CHOICE PIC 9 VALUE 0.


       PROCEDURE DIVISION.
           PERFORM FIND-USER.
           GOBACK.

       OPEN-FILES.
            OPEN I-O USER-DB-FILE.
            OPEN I-O BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.
       FIND-USER.
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
                                 " 💰 Balance: " BALANCE-REC-BALANCE
                    PERFORM UNTIL  CHOICE= 4
                            
                            DISPLAY "What do you want to edit?"
                            DISPLAY "1. Name"
                            DISPLAY "2. DOB"
                            DISPLAY "3. Balance"
                            DISPLAY "4. Exit"
                            ACCEPT CHOICE
                            EVALUATE TRUE
                            WHEN CHOICE = 1
                                DISPLAY "Enter new name: "
                                ACCEPT USER-REC-NAME
                                REWRITE USER-DB-RECORD

                            WHEN CHOICE = 2
                                DISPLAY "Enter new DOB: "
                                ACCEPT USER-REC-DOB
                                REWRITE USER-DB-RECORD

                            WHEN CHOICE = 3
                                DISPLAY "Enter new balance: "
                                ACCEPT BALANCE-REC-BALANCE
                                REWRITE BALANCE-DB-RECORD   
                            WHEN CHOICE = 4
                                MOVE 4 TO CHOICE
                            WHEN OTHER
                                DISPLAY "Invalid Choice"
                            END-EVALUATE
                      END-PERFORM 
                      DISPLAY "✅User updated successfully!"
                      DISPLAY "👤 User ID: " USER-REC-ID
                                 " 📛 Name: " USER-REC-NAME
                                 " 📅 DOB: " USER-REC-DOB
                                 " 💰 Balance: " BALANCE-REC-BALANCE
           
           PERFORM CLOSE-FILES.
