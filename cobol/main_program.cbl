       IDENTIFICATION DIVISION.
       PROGRAM-ID. main_program.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CHOICE PIC 9 VALUE 0.

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           CALL "CREATE_DB_FILES"
           PERFORM UNTIL CHOICE = 7
               DISPLAY " "
               DISPLAY"----------"
               DISPLAY "MAIN MENU"
               DISPLAY"----------"
               DISPLAY "1. Import users from files"
               DISPLAY "2. Add user"
               DISPLAY "3. Show users"
               DISPLAY "4. Find user"
               DISPLAY "5. Edit user"
               DISPLAY "6. Delete user"
               DISPLAY "7. Exit"
               DISPLAY "Enter your choice: " WITH NO ADVANCING
               ACCEPT CHOICE
               EVALUATE CHOICE
                   WHEN 1
                       DISPLAY "Looking for user.csv and balance.csv..."
                       CALL "IMPORT_USER_CSV"
                       CALL "IMPORT_BALANCE_CSV"
                   WHEN 2
                       DISPLAY"----------------------"
                       DISPLAY "Add user is selected."
                       DISPLAY"----------------------"
                       CALL "ADD_USER"
                   WHEN 3
                       DISPLAY"-----------------------"
                       DISPLAY "Show users is selected."
                       DISPLAY"-----------------------"
                       CALL "SHOW_USERS"
                   WHEN 4
                       DISPLAY"----------------------"
                       DISPLAY "Find user is selected."
                       DISPLAY"----------------------"
                       CALL "FIND_USER"
                   WHEN 5
                       DISPLAY"----------------------"
                       DISPLAY "Edit user is selected."
                       DISPLAY"----------------------"
                       CALL "EDIT_USER"
                   WHEN 6
                       DISPLAY"------------------------"
                       DISPLAY "Delete user is selected."
                       DISPLAY"------------------------"
                       CALL "DELETE_USER"
                   WHEN 7
                       MOVE 7 TO CHOICE
                   WHEN OTHER
                       DISPLAY "Invalid Choice"
               END-EVALUATE
           END-PERFORM.
      
              

      
      
      