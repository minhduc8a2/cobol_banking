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
           COPY "user_record.cpy".
           
       FD BALANCE-DB-FILE.
           COPY "balance_record.cpy".


       WORKING-STORAGE SECTION.
       01   USER-NUM USAGE INDEX.
      
       PROCEDURE DIVISION.
           PERFORM ADD-USERS.
           GOBACK.

       OPEN-FILES.
            OPEN I-O USER-DB-FILE.
            OPEN I-O BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.
      

       ADD-USERS.
           PERFORM VARYING USER-NUM FROM 1 BY 1 UNTIL USER-NUM > 5  
                               
                   CALL "GENERATE_NEW_ID" USING USER-REC-ID
                   MOVE USER-REC-ID TO BALANCE-REC-ID
                   MOVE "USER" TO USER-REC-NAME
                   MOVE "1999-01-01" TO USER-REC-DOB
                   MOVE 1000 TO BALANCE-REC-BALANCE

                   PERFORM OPEN-FILES
                   WRITE USER-DB-RECORD
                   END-WRITE
                   WRITE BALANCE-DB-RECORD
                   END-WRITE
                   PERFORM CLOSE-FILES

                   DISPLAY "👤 User ID: " USER-REC-ID
                   DISPLAY "💲 BALANCE ID: " BALANCE-REC-ID
                   DISPLAY "✅ User added successfully."
           END-PERFORM.
