       *>  NEEDS: user_record.cpy balance_record.cpy
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SHOW_USER.

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
       COPY "user_record.cpy".

       FD BALANCE-DB-FILE.
       COPY "balance_record.cpy".

       WORKING-STORAGE SECTION.
       01 PRINTED-BALANCE PIC Z(9)9.99.

       LINKAGE SECTION.
       01  LK-USER-ID         PIC 9(10).
       01  LK-IS-VALID PIC 9 VALUE 1.

       PROCEDURE DIVISION USING LK-USER-ID LK-IS-VALID.
       PERFORM SHOW-USER
       GOBACK.
       
       OPEN-FILES.
            OPEN INPUT USER-DB-FILE.
            OPEN INPUT BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.
       SHOW-USER.
           PERFORM OPEN-FILES.
           MOVE LK-USER-ID TO USER-REC-ID
           READ USER-DB-FILE KEY IS USER-REC-ID
            INVALID KEY
                DISPLAY "❌User not found."
                MOVE 0 TO LK-IS-VALID
            NOT INVALID KEY
                 MOVE USER-REC-ID TO BALANCE-REC-ID
                 READ BALANCE-DB-FILE KEY IS BALANCE-REC-ID
                 NOT INVALID KEY
                      MOVE BALANCE-REC-BALANCE TO PRINTED-BALANCE
                      DISPLAY "👤 User ID: " USER-REC-ID
                                 " 📛 Name: " USER-REC-NAME
                                 " 📅 DOB: " USER-REC-DOB
                                 " 💰 Balance: " PRINTED-BALANCE
                 END-READ
           END-READ
           PERFORM CLOSE-FILES.
