       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRANSFER_MONEY.

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
       01 WS-USER-ID             PIC 9(10).
       01 TRANSFER-TO-ID         PIC 9(10).
       01 TRANSFER-AMOUNT        PIC 9(10)V99.
       01 DOES-HAVE-THE-MONEY    PIC 9 VALUE 0.
       01 USER-DB-FILE-STATUS    PIC XX.
       01 BALANCE-DB-FILE-STATUS PIC XX.
       01 USER-INPUT             PIC X(30).       01 IS-VALID         PIC 9 VALUE 1.

       PROCEDURE DIVISION.
           DISPLAY "----------------------------"
           DISPLAY "Transfer money is selected."
           DISPLAY "----------------------------"
           
           DISPLAY "Enter User ID: "
           ACCEPT USER-INPUT.
           COPY "exit-check.cpy".
           MOVE FUNCTION NUMVAL(USER-INPUT) TO WS-USER-ID
           CALL "SHOW_USER" USING WS-USER-ID IS-VALID
           IF IS-VALID=0
              GOBACK
           END-IF
           

           DISPLAY "Who do you want to transfer: "
           ACCEPT TRANSFER-TO-ID.
           DISPLAY "How much money do you want to trasfer?"
           ACCEPT TRANSFER-AMOUNT
           *> Validation
           OPEN I-O BALANCE-DB-FILE.
           MOVE WS-USER-ID TO BALANCE-REC-ID
           READ BALANCE-DB-FILE KEY IS BALANCE-REC-ID
              INVALID
                 DISPLAY "ERROR INVALID KEY"
              NOT INVALID KEY
                 IF BALANCE-REC-BALANCE > TRANSFER-AMOUNT
                    MOVE 1 TO DOES-HAVE-THE-MONEY 
                    COMPUTE BALANCE-REC-BALANCE = BALANCE-REC-BALANCE - TRANSFER-AMOUNT 
                    REWRITE BALANCE-DB-RECORD
                 END-IF
           END-READ
           IF DOES-HAVE-THE-MONEY = 1
                MOVE TRANSFER-TO-ID TO BALANCE-REC-ID
                    READ BALANCE-DB-FILE KEY IS BALANCE-REC-ID
                    NOT INVALID
                          COMPUTE BALANCE-REC-BALANCE = BALANCE-REC-BALANCE + TRANSFER-AMOUNT 
                          REWRITE BALANCE-DB-RECORD
                    END-READ
           END-IF   
           
           CLOSE BALANCE-DB-FILE.

           CALL "SHOW_USERS"


           *> Are you sure?
           *> transfer the money
           GOBACK.
