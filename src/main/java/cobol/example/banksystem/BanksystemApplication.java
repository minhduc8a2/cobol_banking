package cobol.example.banksystem;

import cobol.example.banksystem.Services.BankServiceImpl;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;

import java.util.Scanner;

@SpringBootApplication
public class BanksystemApplication {

	public static void main(String[] args) {
		ApplicationContext context =  SpringApplication.run(BanksystemApplication.class, args);

		// Get the Bank bean from Spring context
		BankServiceImpl bank = context.getBean(BankServiceImpl.class);

		Scanner scanner = new Scanner(System.in);
		int choice;

		do {
			System.out.println("1. Import users from files");
			System.out.println("2. Add user");
			System.out.println("3. Show users");
			System.out.println("4. Find user");
			System.out.println("5. Edit user");
			System.out.println("6. Delete user");
			System.out.println("7. Sum balance in range");
			System.out.println("8. Exit");
			System.out.print("Enter your choice: ");

			try {
				choice = scanner.nextInt();

				switch (choice) {
					case 1:
						bank.loadDataFromExcelFile();
						break;
					case 2:
						bank.addUser();
						break;
					case 3:
						bank.displayAllUsers();
						break;
					case 4:
						bank.findUserById();
						break;
					case 5:
						bank.updateUser();
						break;
					case 6:
						bank.deleteUser();
						break;
					case 7:
						bank.sumTopNBalance();
						break;
				}
			} catch (Exception e) {
				System.out.println("Invalid choice!!");
				System.out.println(e.getMessage());
				choice = 8;
			}


		} while (choice != 8);

	}

}
