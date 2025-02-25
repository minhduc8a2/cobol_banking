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
       01 USER-DB-RECORD.
           05 USER-REC-ID    PIC 9(10).
           05 USER-REC-NAME  PIC X(30).
           05 USER-REC-DOB   PIC X(10).  *> Format: YYYY-MM-DD
           
       FD BALANCE-DB-FILE.
       01 BALANCE-DB-RECORD.
           05 BALANCE-REC-ID     PIC 9(10).
           05 BALANCE-REC-BALANCE PIC 9(10)V99.


       PROCEDURE DIVISION.
           DISPLAY "----------------------"
           DISPLAY "Transfer money is selected."
           DISPLAY "----------------------"
           GOBACK.
