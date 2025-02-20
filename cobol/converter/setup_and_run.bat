@echo off
echo Checking if virtual environment exists...

IF EXIST venv (
    echo Virtual environment already exists. Skipping creation.
) ELSE (
    echo Creating virtual environment...
    python -m venv venv
)

echo Activating virtual environment...
call venv\Scripts\activate

echo Installing required dependencies...
pip install pandas openpyxl

echo Running the Python script...
python converter.py

echo Process completed.
pause
