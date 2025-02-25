       IDENTIFICATION DIVISION.
       PROGRAM-ID. FIND_USER.
       
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
           COPY "user_record.cpy".
           
       FD BALANCE-DB-FILE.
           COPY "balance_record.cpy".

       
       WORKING-STORAGE SECTION.
       01  USER-DB-FILE-STATUS PIC XX.


       PROCEDURE DIVISION.
              DISPLAY"----------------------"
              DISPLAY "Find user is selected."
              DISPLAY"----------------------"
              DISPLAY "Enter User ID: "
              ACCEPT USER-REC-ID
           PERFORM SHOW-USER.
           GOBACK.


       
           COPY "show_user.cpy".
