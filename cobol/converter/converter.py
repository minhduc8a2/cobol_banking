import pandas as pd
import os
current_folder = os.getcwd()
parent_folder = os.path.dirname(current_folder)
for file_name in os.listdir(current_folder):
    if file_name.endswith(".xlsx"):
        df = pd.read_excel(file_name)
        output_file = os.path.join(parent_folder, file_name.replace(".xlsx", ".csv"))
        df.to_csv(output_file, index=False)

