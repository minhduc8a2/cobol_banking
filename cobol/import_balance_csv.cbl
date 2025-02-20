       IDENTIFICATION DIVISION.
       PROGRAM-ID.  IMPORT_BALANCE_CSV.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CSV-FILE ASSIGN TO "balance.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT BALANCE-DB-FILE ASSIGN TO "balance.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS REC-ID.

       DATA DIVISION.
       FILE SECTION.
       FD CSV-FILE.
       01 CSV-RECORD PIC X(100).
       FD BALANCE-DB-FILE.
       01 BALANCE-DB-RECORD.
           05 REC-ID PIC 9(10).
           05 REC-BALANCE PIC 9(10)V99.

       WORKING-STORAGE SECTION.
       01 WS-ID         PIC 9(10).
       01 WS-BALANCE       PIC X(50).
       01  EOF PIC 9 VALUE 0.

       PROCEDURE DIVISION.
           PERFORM READ-FILE.
           GOBACK.

       READ-FILE.
           OPEN INPUT CSV-FILE.
      *    Ignore first line
           READ CSV-FILE INTO CSV-RECORD 
           END-READ.
      *    /////
           OPEN I-O BALANCE-DB-FILE.
           PERFORM UNTIL EOF = 1
               READ CSV-FILE INTO CSV-RECORD
                   AT END MOVE 1 TO EOF
                   NOT AT END 
                       UNSTRING CSV-RECORD DELIMITED BY ','
                           INTO WS-ID, WS-BALANCE
      *                DISPLAY WS-ID '-' WS-BALANCE    
                       MOVE WS-ID TO REC-ID
                       MOVE WS-BALANCE TO REC-BALANCE
                       WRITE BALANCE-DB-RECORD
                           INVALID KEY
                               DISPLAY "❌ Balance ID exists: " WS-ID
                           NOT INVALID KEY
                            DISPLAY "[ADDED] 💰 Balance ID: " REC-ID
                                         " 💵 Balance: " REC-BALANCE
                        END-WRITE
                END-READ

                   
           END-PERFORM.
           CLOSE BALANCE-DB-FILE.
           CLOSE CSV-FILE.
      
           

       
