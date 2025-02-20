       IDENTIFICATION DIVISION.
       PROGRAM-ID. FIND_MAX_ID.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-DB-FILE ASSIGN TO "user.db"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS USER-REC-ID
               FILE STATUS IS USER-FILE-STATUS.
               

       DATA DIVISION.
       FILE SECTION.
       FD USER-DB-FILE.
       01 USER-DB-RECORD.
           05 USER-REC-ID PIC 9(10).
           05 USER-REC-NAME PIC X(50).
           05 USER-REC-DOB PIC X(10).

       WORKING-STORAGE SECTION.
       01 USER-FILE-STATUS PIC X(2).
       LINKAGE SECTION.
       01 MAX-ID PIC 9(10) VALUE 0.

       PROCEDURE DIVISION USING MAX-ID.
           PERFORM FIND-MAX-ID.
           GOBACK.

       OPEN-FILES.
            OPEN I-O USER-DB-FILE.
       CLOSE-FILES.
            CLOSE USER-DB-FILE.
       FIND-MAX-ID.
           PERFORM OPEN-FILES.
           PERFORM UNTIL USER-FILE-STATUS = "10"  
               READ USER-DB-FILE NEXT RECORD
                   AT END EXIT PERFORM
                   NOT AT END
                       IF USER-REC-ID > MAX-ID
                           MOVE USER-REC-ID TO MAX-ID
                       END-IF
           END-PERFORM.
           COMPUTE MAX-ID = MAX-ID + 1.
           PERFORM CLOSE-FILES.
