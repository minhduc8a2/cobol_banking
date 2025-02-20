import pandas as pd
import os
current_folder = os.getcwd()
for file_name in os.listdir(current_folder):
    if file_name.endswith(".xlsx"):
        df = pd.read_excel(file_name)
        df.to_csv(file_name.replace(".xlsx", ".csv"), index=False)

