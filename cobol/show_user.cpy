       *>  NEEDS: user_record.cpy balance_record.cpy
       OPEN-FILES.
            OPEN INPUT USER-DB-FILE.
            OPEN INPUT BALANCE-DB-FILE.
       CLOSE-FILES.
            CLOSE BALANCE-DB-FILE.
            CLOSE USER-DB-FILE.
       SHOW-USER.
           PERFORM OPEN-FILES.
           READ USER-DB-FILE KEY IS USER-REC-ID
            INVALID KEY
                DISPLAY "❌User not found."
            NOT INVALID KEY
                 MOVE USER-REC-ID TO BALANCE-REC-ID
                 READ BALANCE-DB-FILE KEY IS BALANCE-REC-ID
                 NOT INVALID KEY
                      DISPLAY "👤 User ID: " USER-REC-ID
                                 " 📛 Name: " USER-REC-NAME
                                 " 📅 DOB: " USER-REC-DOB
                                 " 💰 Balance: " BALANCE-REC-BALANCE
                 END-READ
           END-READ
           PERFORM CLOSE-FILES.
