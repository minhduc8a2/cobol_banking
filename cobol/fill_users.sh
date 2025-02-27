#!/bin/bash

export COB_LIBRARY_PATH=$COB_LIBRARY_PATH:$(pwd)/bin
cobc -x fill_users_to_db.cbl -o bin/fill_users_to_db
./bin/fill_users_to_db 