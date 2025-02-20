       IDENTIFICATION DIVISION.
       PROGRAM-ID. main_program.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CHOICE PIC 9 VALUE 0.

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           PERFORM UNTIL CHOICE = 7
               DISPLAY "1. Init database"
               DISPLAY "2. Add user"
               DISPLAY "3. Show users"
               DISPLAY "4. Find user"
               DISPLAY "5. Edit user"
               DISPLAY "6. Delete user"
               DISPLAY "7. Exit"
               ACCEPT CHOICE
               EVALUATE CHOICE
                   WHEN 1
                       CALL "READ_USER"
                       CALL "READ_BALANCE"
                   WHEN 2
                       CALL "SHOW_USERS"
                   WHEN 3
                       CALL "FIND_USER"
                   WHEN 4
                       CALL "EDIT_USER"
                   WHEN 5
                       CALL "DELETE_USER"
                   WHEN 6
                       MOVE 7 TO CHOICE
                   WHEN OTHER
                       DISPLAY "Invalid Choice"
               END-EVALUATE
           END-PERFORM.
           STOP RUN.

      
      
      