       IDENTIFICATION DIVISION.
       PROGRAM-ID. SUM_TOP_N_BALANCE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BALANCE-DB-FILE ASSIGN TO "balance.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS BALANCE-REC-ID
               FILE STATUS IS BALANCE-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD BALANCE-DB-FILE.
       01 BALANCE-DB-RECORD.
           05 BALANCE-REC-ID      PIC 9(10).
           05 BALANCE-REC-BALANCE PIC 9(10)V99.

       WORKING-STORAGE SECTION.
       01 BALANCE-FILE-STATUS       PIC X(2) VALUE SPACES.
       01 WS-RECORD-COUNT           PIC 9(4) COMP VALUE 0.
       01 WS-N                      PIC 9(4) COMP VALUE 0.
       01 WS-SUM                    PIC 9(10)V99 VALUE 0.

      * Table to hold up to 1000 balances (adjust as needed)
       01 WS-BALANCE-TABLE.
          05 WS-BALANCE-ITEM OCCURS 1000 TIMES
             INDEXED BY BAL-INDEX.
             10 WS-ID  PIC 9(10).
             10 WS-BAL PIC 9(10)V99.

       01 WS-I             PIC 9(4) COMP.
       01 WS-J             PIC 9(4) COMP.
       01 WS-TEMP-ID       PIC 9(10).
       01 WS-TEMP-BAL      PIC 9(10)V99.

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY "Enter the number of top balances to sum:"
           ACCEPT WS-N
           PERFORM OPEN-FILES
           PERFORM READ-FILE-TO-TABLE
           PERFORM SORT-TABLE-DESC
           PERFORM SUM-TOP-N
           PERFORM CLOSE-FILES
           STOP RUN.

      *------------------------------
      * Open the balance file
      *------------------------------
       OPEN-FILES.
           OPEN INPUT BALANCE-DB-FILE
           IF BALANCE-FILE-STATUS NOT = "00"
               DISPLAY "Error opening balance.db - Status: "
                BALANCE-FILE-STATUS
               STOP RUN
           END-IF.

      *------------------------------
      * Close the balance file
      *------------------------------
       CLOSE-FILES.
           CLOSE BALANCE-DB-FILE.

      *------------------------------
      * Read all balances into a table
      *------------------------------
       READ-FILE-TO-TABLE.
           MOVE 0 TO WS-RECORD-COUNT
           PERFORM UNTIL BALANCE-FILE-STATUS = "10"
               READ BALANCE-DB-FILE NEXT RECORD
                   AT END
                       EXIT PERFORM
                   NOT AT END
                       ADD 1 TO WS-RECORD-COUNT
                       MOVE BALANCE-REC-ID      TO 
                       WS-ID (WS-RECORD-COUNT)
                       MOVE BALANCE-REC-BALANCE TO 
                       WS-BAL(WS-RECORD-COUNT)
               END-READ
           END-PERFORM.

      *------------------------------
      * Sort the table by balance descending (simple bubble sort)
      *------------------------------
       SORT-TABLE-DESC.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I >= 
           WS-RECORD-COUNT
               MOVE WS-I TO WS-J
               ADD 1 TO WS-J
               PERFORM UNTIL WS-J > WS-RECORD-COUNT
                   IF WS-BAL(WS-J) > WS-BAL(WS-I)
      * Swap IDs
                       MOVE WS-ID(WS-I) TO WS-TEMP-ID
                       MOVE WS-ID(WS-J) TO WS-ID(WS-I)
                       MOVE WS-TEMP-ID  TO WS-ID(WS-J)
      * Swap Balances
                       MOVE WS-BAL(WS-I) TO WS-TEMP-BAL
                       MOVE WS-BAL(WS-J) TO WS-BAL(WS-I)
                       MOVE WS-TEMP-BAL  TO WS-BAL(WS-J)
                   END-IF
                   ADD 1 TO WS-J
               END-PERFORM
           END-PERFORM.


      *------------------------------
      * Sum the top N balances
      *------------------------------

       SUM-TOP-N.
           MOVE 0 TO WS-SUM
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-N OR WS-I >
            WS-RECORD-COUNT
               ADD WS-BAL(WS-I) TO WS-SUM
           END-PERFORM

           DISPLAY "Number of top balances: " WS-N
           DISPLAY "Sum of top " WS-N " balances = " WS-SUM
           .
