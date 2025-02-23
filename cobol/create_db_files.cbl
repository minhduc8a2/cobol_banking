       IDENTIFICATION DIVISION.
       PROGRAM-ID. CREATE_DB_FILES.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-DB-FILE ASSIGN TO "user.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS USER-REC-ID
               FILE STATUS IS USER-DB-FILE-STATUS.

           SELECT BALANCE-DB-FILE ASSIGN TO "balance.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS BALANCE-REC-ID
               FILE STATUS IS BALANCE-DB-FILE-STATUS.

           SELECT USER-CSV-FILE ASSIGN TO "user.csv"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT BALANCE-CSV-FILE ASSIGN TO "balance.csv"
               ORGANIZATION IS LINE SEQUENTIAL.

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

       FD USER-CSV-FILE.
       01 USER-CSV-RECORD PIC X(80).

       FD BALANCE-CSV-FILE.
       01 BALANCE-CSV-RECORD PIC X(80).

       WORKING-STORAGE SECTION.
       01 USER-DB-FILE-STATUS PIC XX.
       01 BALANCE-DB-FILE-STATUS PIC XX.
       01 WS-USER-CSV-LINE PIC X(80).
       01 WS-BALANCE-CSV-LINE PIC X(80).

       01 WS-USER-ID PIC 9(10).
       01 WS-USER-NAME PIC X(50).
       01 WS-USER-DOB PIC X(10).

       01 WS-BALANCE-ID PIC 9(10).
       01 WS-BALANCE-AMOUNT PIC 9(10)V99.

       PROCEDURE DIVISION.
           PERFORM CREATE-DB-FILES.
           PERFORM CLOSE-FILES.
           GOBACK.

       CLOSE-FILES.
           CLOSE USER-DB-FILE.
           CLOSE BALANCE-DB-FILE.
       CREATE-DB-FILES.
           DISPLAY "Checking database files..."

           OPEN I-O USER-DB-FILE.
           IF USER-DB-FILE-STATUS = "35" THEN
               DISPLAY "User database file not found. Creating..."
               OPEN OUTPUT USER-DB-FILE
               CLOSE USER-DB-FILE
               DISPLAY "User database file created successfully."
           END-IF.
    
           OPEN I-O BALANCE-DB-FILE.
           IF BALANCE-DB-FILE-STATUS = "35" THEN
               DISPLAY "Balance database file not found. Creating..."
               OPEN OUTPUT BALANCE-DB-FILE
               CLOSE BALANCE-DB-FILE
               DISPLAY "Balance database file created successfully."
           END-IF.


           OPEN INPUT USER-CSV-FILE
           CLOSE USER-DB-FILE
           OPEN I-O USER-DB-FILE

           PERFORM UNTIL USER-DB-FILE-STATUS = "10"
               READ USER-CSV-FILE INTO WS-USER-CSV-LINE
               AT END
                   EXIT PERFORM
               END-READ

               IF WS-USER-CSV-LINE NOT = "id,name,dob" THEN
                   PERFORM PARSE-USER-CSV-LINE
                   
      *            DISPLAY "Parsed ID: " WS-USER-ID " Name: " 
      *                    WS-USER-NAME " DOB: " WS-USER-DOB

                   PERFORM WRITE-USER-TO-DB
               END-IF
           END-PERFORM.

           OPEN INPUT BALANCE-CSV-FILE
           CLOSE BALANCE-DB-FILE
           OPEN I-O BALANCE-DB-FILE

           PERFORM UNTIL BALANCE-DB-FILE-STATUS = "10"
               READ BALANCE-CSV-FILE INTO WS-BALANCE-CSV-LINE
               AT END
                   EXIT PERFORM
               END-READ

               IF WS-BALANCE-CSV-LINE NOT = "id,balance" THEN
                   PERFORM PARSE-BALANCE-CSV-LINE
                   PERFORM WRITE-BALANCE-TO-DB
               END-IF
           END-PERFORM.

       PARSE-USER-CSV-LINE.
           UNSTRING WS-USER-CSV-LINE
               DELIMITED BY ","
               INTO WS-USER-ID
                    WS-USER-NAME
                    WS-USER-DOB.

           MOVE WS-USER-ID TO USER-REC-ID
           MOVE WS-USER-NAME TO USER-REC-NAME
           MOVE WS-USER-DOB TO USER-REC-DOB.

       WRITE-USER-TO-DB.
           WRITE USER-DB-RECORD
               INVALID KEY
      *            DISPLAY "Record already exists, attempting update..."
      *        REWRITE USER-DB-RECORD
               END-WRITE.

       PARSE-BALANCE-CSV-LINE.
           UNSTRING WS-BALANCE-CSV-LINE
               DELIMITED BY ","
               INTO WS-BALANCE-ID
                    WS-BALANCE-AMOUNT.

           MOVE WS-BALANCE-ID TO BALANCE-REC-ID
           MOVE WS-BALANCE-AMOUNT TO BALANCE-REC-BALANCE.

       WRITE-BALANCE-TO-DB.
           WRITE BALANCE-DB-RECORD
               INVALID KEY
      *            DISPLAY "Record already exists, attempting update..."
      *        REWRITE USER-DB-RECORD
               END-WRITE.
