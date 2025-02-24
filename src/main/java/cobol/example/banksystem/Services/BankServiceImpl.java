package cobol.example.banksystem.Services;

import cobol.example.banksystem.Models.Balance;
import cobol.example.banksystem.Repo.BalanceRepo;
import cobol.example.banksystem.Repo.UserRepo;
import cobol.example.banksystem.Models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Scanner;

@Component
public class BankServiceImpl implements BankService {

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private BalanceRepo balanceRepo;

    @Override
    public void addUser() {

//        enter user name
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter User Name: ");
        String name = sc.nextLine();

//    Enter user date of birdth
        System.out.println("Enter User DOB: ");
        String dateString = sc.nextLine();
        LocalDate localDate = LocalDate.parse(dateString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        Date dob = java.sql.Date.valueOf(localDate);


        User user = new User();
        user.setDob(dob);
        user.setName(name);
        //        userRepo.save(user);
//
//        User userManange = userRepo.findById(user.getId()).orElseThrow(
//                () -> new RuntimeException("User does not found!!")
//        );

        //        enter balance
        System.out.println("Enter User Balance: ");
        double balanceValue = sc.nextDouble();
        Balance balance = new Balance();
        balance.setBalance(balanceValue);
        balance.setUser(user);
        user.setBalance(balance);

        userRepo.save(user);

    }

    @Override
    public void deleteUser() {
        Scanner sc = new Scanner(System.in);

        System.out.println("Enter User ID: ");
        long userId = sc.nextLong();

        User user = userRepo.findById(userId).orElseThrow(
                () -> new RuntimeException("User not found.")
        );

        //display user info
        displayUserInfo(user);

        sc.nextLine();
        System.out.println("Are you sure you want to delete this user? (Y/N)");
        char userConfirm = sc.nextLine().charAt(0);

        if (userConfirm == 'Y' || userConfirm == 'y') {
            userRepo.deleteById(userId);
        } else {
            System.out.println("Cancelled");
        }

    }

    public void displayUserInfo(User user) {
        System.out.println("User ID: " + user.getId());
        System.out.println("Name: " + user.getName());
        System.out.println("DOB: " + user.getDob());
        System.out.println("Balance: " + user.getBalance().getBalance());
    }

    @Override
    public void loadDataFromExcelFile() {
        String userPath = "D:\\MyDocument\\AllSubject\\Code\\BACKEND\\COBOL\\code\\banksystem\\src\\main\\resources\\sample_data_100.xlsx";
        String balancePath = "D:\\MyDocument\\AllSubject\\Code\\BACKEND\\COBOL\\code\\banksystem\\src\\main\\resources\\balance_data_100.xlsx";
        List <User> users = readUsers(userPath);
        List<Balance> balances = readBalances(balancePath);

        // Saving user
        for (User user : users) {
            userRepo.save(user);
        }
        System.out.println("Read data from excel file and save successfully!!");

        //Saving balance
        for (Balance balance : balances) {
            User user = userRepo.findById(balance.getId()).orElseThrow(
                    () -> new RuntimeException("User does not found!!")
            );

            balance.setUser(user);
            balanceRepo.save(balance);
        }
        System.out.println("Save Balances successfully!");
        //        for (Balance balance : balances) {
//            System.out.println(balance);
//        }

    }

    public List<User> readUsers(String path) {
        ExcelFileReader config = new ExcelFileReader(path);
        List<User> users = new ArrayList<>();
        int sheetNumber = 0;
        int rows = config.getRowCount(sheetNumber);
        for(int i = 1; i < rows; i++) {
            long id = (long)config.getNumbmuricData(sheetNumber, i, 0);
            String name = config.getStringData(sheetNumber, i, 1);
            Date dob = config.getDateData(sheetNumber, i, 2);
//            LocalDate localDate = LocalDate.parse(dateString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
//            Date dob = java.sql.Date.valueOf(localDate);

            User user = new User();
            user.setId(id);
            user.setDob(dob);
            user.setName(name);

            users.add(user);

        }

        return users;
    }

    public List<Balance> readBalances(String path) {
        ExcelFileReader config = new ExcelFileReader(path);
        List<Balance> balances = new ArrayList<>();
        int sheetNumber = 0;
        int rows = config.getRowCount(sheetNumber);
        for(int i=1; i < rows; i++) {
            long userId = (long)config.getNumbmuricData(sheetNumber, i, 0);
            long balanceValue = (long)config.getNumbmuricData(sheetNumber, i, 1);

            Balance balance =new Balance();
            balance.setId(userId);
            balance.setBalance(balanceValue);

            balances.add(balance);

        }

        return balances;
    }

//    @Override
//    public long findMaxUserId() {
//        return userRepo.findMaxUserId() + 1;
//    }

    @Override
    public void updateUser() {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter User ID: ");
        long id = sc.nextLong();

        User user = userRepo.findById(id).orElseThrow(
                () -> new RuntimeException("User does not found")
        );

        int choice = 0;
        do {
            System.out.println("What do you want to edit?");
            System.out.println("1. Name");
            System.out.println("2. DOB");
            System.out.println("3. Balance");
            System.out.println("4. Exit");
            choice = sc.nextInt();
            sc.nextLine();


            switch (choice) {
                case 1:
                    // Code to execute if expression == value1
                    System.out.println("Enter new name: ");
                    String name = sc.nextLine();
                    user.setName(name);
                    break;
                case 2:
                    // Code to execute if expression == value2
                    System.out.println("Enter User DOB: ");
                    String dateString = sc.nextLine();
                    LocalDate localDate = LocalDate.parse(dateString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    Date dob = java.sql.Date.valueOf(localDate);
                    user.setDob(dob);
                    break;
                case 3:
                    // Code to execute if expression == value2
                    System.out.println("Enter new balance: ");
                    double balance = sc.nextDouble();
                    user.getBalance().setBalance(balance);
                    break;
            }

            userRepo.save(user);

        } while (choice != 4);

        System.out.println("User updated successfully!");
        displayUserInfo(user);

    }

    @Override
    public void findUserById() {
        Scanner sc = new Scanner(System.in);
        System.out.println("----------------------");
        System.out.println("Find user is selected.");
        System.out.println("----------------------");

        System.out.println("Enter User ID: ");
        long userId = sc.nextLong();

        User user = userRepo.findById(userId).orElseThrow(
                () -> new RuntimeException("User does not found!!")
        );

        displayUserInfo(user);
    }

    @Override
    public void sumTopNBalance() {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter the number of top balances to sum: ");

        int top = sc.nextInt();
        double total = balanceRepo.getSumOfTopNBalances(top);
        System.out.println("Number of top balances: " + top);
        System.out.println("Sum of top " + top + " balances = " + total);

    }

    @Override
    public void displayAllUsers() {

        List<User> users = userRepo.findAll();

        System.out.println("-----------------------");
        System.out.println("Show users is selected.");
        System.out.println("-----------------------");

        int index = 1;
        for (User user : users) {
            System.out.println("--------------User info: " + index + "----------------");
            displayUserInfo(user);
            index++;
            System.out.println("------------------------------------------------------");

        }
    }
}
