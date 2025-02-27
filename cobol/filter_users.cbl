       IDENTIFICATION DIVISION.
       PROGRAM-ID. FILTER_USERS.

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
           05 USER-REC-ID   PIC 9(10).
           05 USER-REC-NAME PIC X(30).
           05 USER-REC-DOB  PIC X(10).

       FD BALANCE-DB-FILE.
       01 BALANCE-DB-RECORD.
           05 BALANCE-REC-ID      PIC 9(10).
           05 BALANCE-REC-BALANCE PIC 9(10)V99.

       WORKING-STORAGE SECTION.
       01 USER-DB-FILE-STATUS PIC XX.
       01 BALANCE-DB-FILE-STATUS PIC XX.
       01 PRINT-LINE          PIC X(100).
       01 SORT-OPTION         PIC X(1).
       01 FILTER-OPTION       PIC X(1).
       01 FILTER-VALUE-NUM    PIC 9(10)V99.
       01 WS-DISPLAY-RECORD.
           05 DISP-USER-REC-ID         PIC 9(10).
           05 DISP-USER-REC-NAME       PIC X(30).
           05 DISP-USER-REC-DOB        PIC X(10).
           05 DISP-BALANCE-REC-BALANCE PIC 9(10)V99.

       01 USER-TABLE.
           05 USER-TABLE-ENTRY OCCURS 100 TIMES INDEXED BY IDX.
               10 DET-USER-REC-ID         PIC 9(10).
               10 DET-USER-REC-NAME       PIC X(30).
               10 DET-USER-REC-DOB        PIC X(10).
               10 DET-BALANCE-REC-BALANCE PIC 9(10)V99.

      * Temporary variables for swapping table entries
       01 TEMP-USER-REC-ID         PIC 9(10).
       01 TEMP-USER-REC-NAME       PIC X(30).
       01 TEMP-USER-REC-DOB        PIC X(10).
       01 TEMP-BALANCE-REC-BALANCE PIC 9(10)V99.

      * Working-storage variable for inner loop index
       01 WS-JDX  PIC 9(4) COMP.

      * Header for display
       01 USER-DB-HEADER.
           05 FILLER           PIC X(5)  VALUE SPACES.
           05 FILLER           PIC X(15) VALUE '👤 User ID'.
           05 FILLER           PIC X(2)  VALUE SPACES.
           05 FILLER           PIC X(9)  VALUE '📛 Name'.
           05 FILLER           PIC X(28) VALUE SPACES.
           05 FILLER           PIC X(9)  VALUE '📅 DOB'.
           05 FILLER           PIC X(8)  VALUE SPACES.
           05 FILLER           PIC X(15) VALUE '💰 Balance'.
           05 FILLER           PIC X(5)  VALUE SPACES.

       01 USER-DB-ROW.
           05 FILLER                    PIC X(5)  VALUE '|'.
           05 DET-USER-REC-ID-DISPLAY    PIC 9(10).
           05 FILLER                    PIC X(5)  VALUE '|'.
           05 DET-USER-REC-NAME-DISPLAY  PIC X(30).
           05 FILLER                    PIC X(5)  VALUE '|'.
           05 DET-USER-REC-DOB-DISPLAY   PIC X(10).
           05 FILLER                    PIC X(5)  VALUE '|'.
           05 DET-BALANCE-REC-BALANCE-DISPLAY PIC 9(10)V99.
           05 FILLER                    PIC X(5)  VALUE '|'.

       PROCEDURE DIVISION.
       MAIN-SECTION.
           DISPLAY "-----------------------"
           DISPLAY "Show users is selected."
           DISPLAY "-----------------------"
           PERFORM OPEN-FILES
           
           PERFORM LOAD-USER-TABLE
           PERFORM ASK-SORT-OPTION
           PERFORM SORT-USER-TABLE
           PERFORM WRITE-HEADER
           PERFORM DISPLAY-USER-TABLE
           PERFORM CLOSE-FILES
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

      * Load the user table from the files.
       LOAD-USER-TABLE.
           MOVE 1 TO IDX.
           PERFORM UNTIL USER-DB-FILE-STATUS = "10"
               READ USER-DB-FILE NEXT RECORD
                   AT END 
                       MOVE "10" TO USER-DB-FILE-STATUS
                   NOT AT END
      *                DISPLAY "User read: " USER-REC-ID " " USER-REC-NAME.
                       MOVE USER-REC-ID   TO DET-USER-REC-ID OF 
                       USER-TABLE-ENTRY(IDX)
                       MOVE USER-REC-NAME TO DET-USER-REC-NAME OF 
                       USER-TABLE-ENTRY(IDX)
                       MOVE USER-REC-DOB  TO DET-USER-REC-DOB OF 
                       USER-TABLE-ENTRY(IDX)
                       MOVE USER-REC-ID   TO BALANCE-REC-ID
      *                DISPLAY "Attempting balance READ for key: " BALANCE-REC-ID.
                       READ BALANCE-DB-FILE KEY IS BALANCE-REC-ID
                           AT END 
                               DISPLAY "Balance not found for user " 
                               USER-REC-ID
                               MOVE ZEROS TO DET-BALANCE-REC-BALANCE OF 
                               USER-TABLE-ENTRY(IDX)
                           NOT AT END
                               MOVE BALANCE-REC-BALANCE TO 
                               DET-BALANCE-REC-BALANCE OF 
                               USER-TABLE-ENTRY(IDX)
                       END-READ
                       ADD 1 TO IDX
               END-READ
           END-PERFORM.

      * Ask the user for sort option.
       ASK-SORT-OPTION.
           DISPLAY "Sort option: [N]ame or [B]alance: "
           ACCEPT SORT-OPTION.

      * Sort the user table according to the chosen option.
       SORT-USER-TABLE.
           IF SORT-OPTION = "N"
               PERFORM SORT-BY-NAME
           ELSE IF SORT-OPTION = "B"
               PERFORM SORT-BY-BALANCE
           END-IF.

       SORT-BY-NAME.
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 99
               MOVE IDX TO WS-JDX
               ADD 1 TO WS-JDX
               PERFORM UNTIL WS-JDX > 100
                   IF DET-USER-REC-NAME OF USER-TABLE-ENTRY(IDX)
                      > DET-USER-REC-NAME OF USER-TABLE-ENTRY(WS-JDX)
                       PERFORM SWAP-ENTRIES
                   END-IF
                   ADD 1 TO WS-JDX
               END-PERFORM
           END-PERFORM.

       SORT-BY-BALANCE.
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 99
               MOVE IDX TO WS-JDX
               ADD 1 TO WS-JDX
               PERFORM UNTIL WS-JDX > 100
                   IF DET-BALANCE-REC-BALANCE OF USER-TABLE-ENTRY(IDX)
                      > DET-BALANCE-REC-BALANCE OF 
                      USER-TABLE-ENTRY(WS-JDX)
                       PERFORM SWAP-ENTRIES
                   END-IF
                   ADD 1 TO WS-JDX
               END-PERFORM
           END-PERFORM.

       SWAP-ENTRIES.
           MOVE DET-USER-REC-ID OF USER-TABLE-ENTRY(IDX)
               TO TEMP-USER-REC-ID
           MOVE DET-USER-REC-NAME OF USER-TABLE-ENTRY(IDX)
               TO TEMP-USER-REC-NAME
           MOVE DET-USER-REC-DOB OF USER-TABLE-ENTRY(IDX)
               TO TEMP-USER-REC-DOB
           MOVE DET-BALANCE-REC-BALANCE OF USER-TABLE-ENTRY(IDX)
               TO TEMP-BALANCE-REC-BALANCE

           MOVE DET-USER-REC-ID OF USER-TABLE-ENTRY(WS-JDX)
               TO DET-USER-REC-ID OF USER-TABLE-ENTRY(IDX)
           MOVE DET-USER-REC-NAME OF USER-TABLE-ENTRY(WS-JDX)
               TO DET-USER-REC-NAME OF USER-TABLE-ENTRY(IDX)
           MOVE DET-USER-REC-DOB OF USER-TABLE-ENTRY(WS-JDX)
               TO DET-USER-REC-DOB OF USER-TABLE-ENTRY(IDX)
           MOVE DET-BALANCE-REC-BALANCE OF USER-TABLE-ENTRY(WS-JDX)
               TO DET-BALANCE-REC-BALANCE OF USER-TABLE-ENTRY(IDX)

           MOVE TEMP-USER-REC-ID
               TO DET-USER-REC-ID OF USER-TABLE-ENTRY(WS-JDX)
           MOVE TEMP-USER-REC-NAME
               TO DET-USER-REC-NAME OF USER-TABLE-ENTRY(WS-JDX)
           MOVE TEMP-USER-REC-DOB
               TO DET-USER-REC-DOB OF USER-TABLE-ENTRY(WS-JDX)
           MOVE TEMP-BALANCE-REC-BALANCE
               TO DET-BALANCE-REC-BALANCE OF USER-TABLE-ENTRY(WS-JDX).

       DISPLAY-USER-TABLE.
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 100
               IF DET-USER-REC-ID OF USER-TABLE-ENTRY(IDX) NOT = 0
                   MOVE DET-USER-REC-ID OF USER-TABLE-ENTRY(IDX)
                       TO DET-USER-REC-ID-DISPLAY
                   MOVE DET-USER-REC-NAME OF USER-TABLE-ENTRY(IDX)
                       TO DET-USER-REC-NAME-DISPLAY
                   MOVE DET-USER-REC-DOB OF USER-TABLE-ENTRY(IDX)
                       TO DET-USER-REC-DOB-DISPLAY
                   MOVE DET-BALANCE-REC-BALANCE OF USER-TABLE-ENTRY(IDX)
                       TO DET-BALANCE-REC-BALANCE-DISPLAY
                   MOVE USER-DB-ROW TO PRINT-LINE
                   DISPLAY PRINT-LINE
               END-IF
           END-PERFORM.
