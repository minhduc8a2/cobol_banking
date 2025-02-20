#!/bin/bash

echo "🔄 Compiling COBOL modules..."
cobc -m read_balance.cbl
cobc -m read_user.cbl
cobc -m show_users.cbl
cobc -m find_max_id.cbl
cobc -m add_user.cbl
cobc -m find_user.cbl

echo "🚀 Compiling main program..."
cobc -x main_program.cbl

echo "✅ Compilation complete!"

echo "🔄 Running program..."
./main_program
