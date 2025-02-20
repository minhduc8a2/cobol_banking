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
2. `cobc -m show_users.cbl`
3. `cobc -x main_program.cbl`
4. `./main_program`