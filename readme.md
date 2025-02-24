# **COBOL BANKING**

## **Convert Excel Files to CSV**
### **Setup Instructions**

#### **🔹 For Windows Users**
**Requirements:**  
- Python installed  
- `pip` available  

To set up and run the converter, execute:  
```sh
.\setup_and_run.bat
```

#### **🔹 For Linux Users**
**Requirements:**  
- Python3 installed  
- `python3.10-venv` installed
- `python3-pip` installed  

Run the following commands in the **`cobol/converter`** directory:

```sh
chmod +x setup.sh  # Make the script executable
sed -i 's/\r$//' setup.sh  # Fix potential Windows line-ending issues
./setup.sh
```

---

## **Run COBOL Program**
Navigate to the **`cobol`** directory and open an **Ubuntu Terminal**.

1️⃣ **Make the script executable**  
```sh
chmod +x run.sh
```

2️⃣ **Fix Windows line-ending issues (if applicable)**  
```sh
sed -i 's/\r$//' run.sh
```

3️⃣ **Run the program**  
```sh
./run.sh
```

---

### **💡 Notes**
- The `sed -i 's/\r$//' <script>` command ensures compatibility between Windows and Linux by removing `CRLF` line endings.
- If you encounter permission issues, try running:
  ```sh
  chmod +x run.sh setup.sh
  ```

![UI](/UI.png)


