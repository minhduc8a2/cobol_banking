# Cobol
## Convert excel files to csv files
At folder "converter"
1. `python -m venv venv`
2. `venv\Scripts\activate`
3. `pip install pandas openpyxl`
4. `python converter.py`
## Run Cobol program
At folder "cobol"
1. `cobc -m read_balance.cbl`
2. `cobc -m read_user.cbl`
3. `cobc -m show_users.cbl`
4. `cobc -m find_max_id.cbl`
5. `cobc -m add_user.cbl`
6. `cobc -m find_user.cbl`
7. `cobc -x main_program.cbl`
8. `./main_program`