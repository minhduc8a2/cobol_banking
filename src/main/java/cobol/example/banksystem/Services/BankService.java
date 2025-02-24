package cobol.example.banksystem.Services;

public interface BankService {
    void addUser();
    void deleteUser();
    void loadDataFromExcelFile();
    void updateUser();
    void findUserById();
    void sumTopNBalance();
    void displayAllUsers();
}
