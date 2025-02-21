#!/bin/bash

echo "🔄 Compiling COBOL modules..."
cobc -m create_db_files.cbl
cobc -m clear_database.cbl
cobc -m import_balance_csv.cbl
cobc -m import_user_csv.cbl
cobc -m show_users.cbl
cobc -m find_max_id.cbl
cobc -m add_user.cbl
cobc -m find_user.cbl
cobc -m edit_user.cbl
cobc -m delete_user.cbl

echo "🚀 Compiling main program..."
cobc -x main_program.cbl

echo "✅ Compilation complete!"

echo "🔄 Running program..."
./main_program
