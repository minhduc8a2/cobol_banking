       IDENTIFICATION DIVISION.
       PROGRAM-ID. IMPORT_USER_CSV.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CSV-FILE ASSIGN TO "user.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT USER-DB-FILE ASSIGN TO "user.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS REC-ID.

       DATA DIVISION.
       FILE SECTION.
       FD CSV-FILE.
       01 CSV-RECORD PIC X(100).
       FD USER-DB-FILE.
       01 USER-DB-RECORD.
           05 REC-ID PIC 9(10).
           05 REC-NAME PIC X(30).
           05 REC-DOB PIC X(10).

       WORKING-STORAGE SECTION.
       01 WS-ID         PIC 9(10).
       01 WS-NAME       PIC X(30).
       01 WS-DOB        PIC X(10).

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
           OPEN I-O USER-DB-FILE.
           PERFORM UNTIL EOF = 1
               READ CSV-FILE INTO CSV-RECORD
                   AT END MOVE 1 TO EOF
                   NOT AT END 
                       UNSTRING CSV-RECORD DELIMITED BY ','
                           INTO WS-ID, WS-NAME, WS-DOB
                       MOVE WS-ID TO REC-ID
                       MOVE WS-NAME TO REC-NAME
                       MOVE WS-DOB TO REC-DOB
                       WRITE USER-DB-RECORD
                            INVALID KEY
                                 DISPLAY "❌User ID exists."
                            NOT INVALID KEY
                                 DISPLAY "[ADDED]👤 User ID: " REC-ID
                                          " 📛 Name: " REC-NAME
                                          " 📅 DOB: " REC-DOB
                       END-WRITE
                END-READ    
           END-PERFORM.
           CLOSE USER-DB-FILE.
           CLOSE CSV-FILE.
      
           

       
