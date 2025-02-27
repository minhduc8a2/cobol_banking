#!/bin/bash

mkdir -p bin
export COB_LIBRARY_PATH=$COB_LIBRARY_PATH:$(pwd)/bin

echo "🔄 Compiling COBOL modules..."
cobc -m create_db_files.cbl
mv create_db_files.so bin/CREATE_DB_FILES.so
mkdir -p bin

# Clear database module
cobc -m clear_database.cbl
mv clear_database.so bin/CLEAR_DATABASE.so

# Import balance CSV module
cobc -m import_balance_csv.cbl
mv import_balance_csv.so bin/IMPOORT_BALANCE_CSV.so

# Import user CSV module
cobc -m import_user_csv.cbl
mv import_user_csv.so bin/IMPORT_USER_CSV.so

# Show users module
cobc -m show_users.cbl
mv show_users.so bin/SHOW_USERS.so

# Generate new ID module
cobc -m generate_new_id.cbl
mv generate_new_id.so bin/GENERATE_NEW_ID.so

# Add user module
cobc -m add_user.cbl
mv add_user.so bin/ADD_USER.so

# Find user module
cobc -m find_user.cbl
mv find_user.so bin/FIND_USER.so

# Edit user module
cobc -m edit_user.cbl
mv edit_user.so bin/EDIT_USER.so

# Delete user module (fixed spacing in original)
cobc -m delete_user.cbl
mv delete_user.so bin/DELETE_USER.so

# Sum top N balance module
cobc -m sum_top_n_balance.cbl
mv sum_top_n_balance.so bin/SUM_TOP_N_BALANCE.so

# Transfer money module
cobc -m transfer_money.cbl
mv transfer_money.so bin/TRANSFER_MONEY.so

# Show user module
cobc -m show_user.cbl
mv show_user.so bin/SHOW_USER.so


echo "🚀 Compiling and linking main program with modules..."
cobc -x main_program.cbl -o bin/main_program

echo "✅ Compilation and linking complete!"

echo "🔄 Running program..."
./bin/main_program