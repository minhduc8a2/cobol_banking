#!/bin/bash

echo "🔄 Compiling COBOL modules..."
cobc -m create_db_files.cbl -o CREATE_DB_FILES.so
cobc -m clear_database.cbl -o CLEAR_DATABASE.so
cobc -m import_balance_csv.cbl -o IMPOORT_BALANCE_CSV.so
cobc -m import_user_csv.cbl -o IMPORT_USER_CSV.so
cobc -m show_users.cbl -o SHOW_USERS.so
cobc -m generate_new_id.cbl -o GENERATE_NEW_ID.so
cobc -m add_user.cbl -o ADD_USER.so
cobc -m find_user.cbl -o FIND_USER.so
cobc -m edit_user.cbl -o EDIT_USER.so
cobc -m delete_user.cbl -o DELETE_USER.so
cobc -m sum_top_n_balance.cbl -o SUM_TOP_N_BALANCE.so
cobc -m transfer_money.cbl -o TRANSFER_MONEY.so

echo "🚀 Compiling and linking main program with modules..."
cobc -x main_program.cbl

echo "✅ Compilation and linking complete!"

echo "🔄 Running program..."
./main_program
