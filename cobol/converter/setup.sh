#!/bin/bash

echo "Checking if virtual environment exists..."

if [ -d "venv" ]; then
    echo "Virtual environment already exists. Skipping creation."
else
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing required dependencies..."
pip install pandas openpyxl

echo "Running the Python script..."
python3 converter.py

echo "Process completed."
