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
           05 USER-REC-ID    PIC 9(10).
           05 USER-REC-NAME  PIC X(30).
           05 USER-REC-DOB   PIC X(10).  *> Format: YYYY-MM-DD
           
       FD BALANCE-DB-FILE.
       01 BALANCE-DB-RECORD.
           05 BALANCE-REC-ID     PIC 9(10).
           05 BALANCE-REC-BALANCE PIC 9(10)V99.

       WORKING-STORAGE SECTION.
       01  EXIT-ADD-USER       PIC X VALUE 'Y'.
       01  VALID-DATE          PIC X VALUE 'N'.
       01  LEAP-YEAR           PIC X VALUE 'N'.
       01  REM-4               PIC 9.
       01  REM-100             PIC 9.
       01  REM-400             PIC 9.
       01  WS-USER-DOB         PIC X(10).   

      * Working variables to accept DOB components.
       01  WS-USER-REC-YEAR    PIC 9(4).
       01  WS-USER-REC-MONTH   PIC 9(2).
       01  WS-USER-REC-DAY     PIC 9(2).

       PROCEDURE DIVISION.
           DISPLAY "----------------------"
           DISPLAY "Add user is selected."
           DISPLAY "----------------------"
           PERFORM ADD-USER.
           GOBACK.

       OPEN-FILES.
            OPEN I-O USER-DB-FILE.
            OPEN I-O BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.
      
      * Check valid day-month-year
       VALIDATE-DATE.
           DIVIDE WS-USER-REC-YEAR BY 4 GIVING REM-4 REMAINDER REM-4.
           DIVIDE WS-USER-REC-YEAR BY 100 GIVING REM-100 
                   REMAINDER REM-100.
           DIVIDE WS-USER-REC-YEAR BY 400 GIVING REM-400 
                   REMAINDER REM-400.

           IF WS-USER-REC-YEAR > 999 AND WS-USER-REC-YEAR < 10000 AND 
              WS-USER-REC-MONTH > 0 AND WS-USER-REC-MONTH < 13
               IF WS-USER-REC-MONTH = 2
                   IF (REM-4 = 0 AND REM-100 NOT = 0) OR REM-400 = 0
                       MOVE "Y" TO LEAP-YEAR
                   END-IF
                   IF LEAP-YEAR = "Y" AND WS-USER-REC-DAY > 0 AND 
                   WS-USER-REC-DAY < 30
                       MOVE "Y" TO VALID-DATE
                   ELSE IF LEAP-YEAR = "N" AND WS-USER-REC-DAY > 0 AND 
                   WS-USER-REC-DAY < 29
                       MOVE "Y" TO VALID-DATE
                   END-IF
               ELSE IF (WS-USER-REC-MONTH = 1 OR WS-USER-REC-MONTH = 3 
                   OR WS-USER-REC-MONTH = 5 OR WS-USER-REC-MONTH = 7 OR 
                      WS-USER-REC-MONTH = 8 OR WS-USER-REC-MONTH = 10 OR 
                      WS-USER-REC-MONTH = 12) AND WS-USER-REC-DAY > 0 
                   AND WS-USER-REC-DAY < 32
                   MOVE "Y" TO VALID-DATE
               ELSE IF (WS-USER-REC-MONTH = 4 OR WS-USER-REC-MONTH = 6 
                   OR WS-USER-REC-MONTH = 9 OR WS-USER-REC-MONTH = 11) 
                   AND WS-USER-REC-DAY > 0 AND WS-USER-REC-DAY < 31
                   MOVE "Y" TO VALID-DATE
               END-IF.

       ADD-USER.
           PERFORM UNTIL EXIT-ADD-USER NOT = "Y" AND 
                           EXIT-ADD-USER NOT = "y"
                DISPLAY "Enter User Name: "
                ACCEPT USER-REC-NAME

                DISPLAY "Enter User DOB: "
                DISPLAY "Enter year (YYYY): " WITH NO ADVANCING
                ACCEPT WS-USER-REC-YEAR
                DISPLAY "Enter month (MM): " WITH NO ADVANCING
                ACCEPT WS-USER-REC-MONTH
                DISPLAY "Enter day (DD): " WITH NO ADVANCING
                ACCEPT WS-USER-REC-DAY

                PERFORM VALIDATE-DATE
                IF VALID-DATE = "Y"
                   *> Build the DOB string in the format YYYY-MM-DD
                   MOVE WS-USER-REC-YEAR TO WS-USER-DOB(1:4)
                   MOVE "-"              TO WS-USER-DOB(5:1)
                   MOVE WS-USER-REC-MONTH TO WS-USER-DOB(6:2)
                   MOVE "-"              TO WS-USER-DOB(8:1)
                   MOVE WS-USER-REC-DAY   TO WS-USER-DOB(9:2)
                   
                   MOVE WS-USER-DOB TO USER-REC-DOB

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

                   DISPLAY "👤 User ID: " USER-REC-ID
                   DISPLAY "💲 BALANCE ID: " BALANCE-REC-ID
                   DISPLAY "✅ User added successfully."
                ELSE
                   DISPLAY "❌ Invalid date. Please try again."
                END-IF

                DISPLAY "Do you want to add another user? (Y/N)"
                ACCEPT EXIT-ADD-USER   
           END-PERFORM.
