#!/bin/bash

echo "🔄 Compiling COBOL modules..."
cobc -m -o CREATE_DB_FILES create_db_files.cbl
cobc -m -o CLEAR_DATABASE clear_database.cbl
cobc -m -o IMPORT_BALANCE_CSV import_balance_csv.cbl
cobc -m -o IMPORT_USER_CSV import_user_csv.cbl
cobc -m -o SHOW_USERS show_users.cbl
cobc -m -o FIND_MAX_ID find_max_id.cbl
cobc -m -o ADD_USER add_user.cbl
cobc -m -o FIND_USER find_user.cbl
cobc -m -o EDIT_USER edit_user.cbl
cobc -m -o DELETE_USER delete_user.cbl

echo "🚀 Compiling and linking main program with modules..."
cobc -x -o main_program main_program.cbl CREATE_DB_FILES.o CLEAR_DATABASE.o IMPORT_BALANCE_CSV.o IMPORT_USER_CSV.o SHOW_USERS.o FIND_MAX_ID.o ADD_USER.o FIND_USER.o EDIT_USER.o DELETE_USER.o

echo "✅ Compilation and linking complete!"

echo "🔄 Running program..."
./main_program
