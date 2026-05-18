import java.util.InputMismatchException;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        LibrarySystem lib = new LibrarySystem();
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("\n=== Library Menu ===");
            System.out.println("1. Add Book\n2. View All Books\n3. Register User\n4. Borrow Book");
            System.out.println("5. Search Books\n6. View Users\n7. Return Book\n8. View Loan Records\n9. Exit");
            System.out.print("Enter choice: ");
            
            int choice = 0;

            try {
                choice = scanner.nextInt();
                scanner.nextLine();
            } catch (InputMismatchException e) {
                System.out.println("\n[!] ERROR: Please enter a number (1-9), not text.");
                scanner.nextLine();
                continue;
            }
            
            if (choice == 9) break;

            switch (choice) {
                case 1:
                    System.out.print("Enter Title: ");
                    String t = scanner.nextLine();
                    System.out.print("Enter Author: ");
                    String a = scanner.nextLine();
                    lib.addBook(t, a);
                    break;
                case 2:
                    lib.viewBooks();
                    break;
                case 3:
                    System.out.print("Enter User Name: ");
                    String n = scanner.nextLine();
                    lib.registerUser(n);
                    break;
                case 4:
                    System.out.print("Enter Book ID: ");
                    int bId = scanner.nextInt();
                    System.out.print("Enter User ID: ");
                    int uId = scanner.nextInt();
                    lib.borrowBook(bId, uId);
                    break;
                case 5:
                    System.out.print("Enter search term: ");
                    String q = scanner.nextLine();
                    lib.searchBooks(q);
                    break;
                case 6:
                    lib.viewUsers();
                    break;
                case 7:
                    System.out.print("Enter Book ID to return: ");
                    int rId = scanner.nextInt();
                    lib.returnBook(rId);
                    break;
                case 8:
                    lib.viewLoans();
                    break;
                default:
                    System.out.println("Invalid choice!");
            }
        }
        scanner.close();
        System.out.println("Exiting System...");
    }
}