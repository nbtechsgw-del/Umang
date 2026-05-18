import java.sql.*;

public class LibrarySystem {

    public void addBook(String title, String author) {
        String query = "INSERT INTO Books (title, author, status) VALUES (?, ?, 'AVAILABLE')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.executeUpdate();
            System.out.println("Book added successfully!");
        } catch (SQLException e) { System.out.println("Error: " + e.getMessage()); }
    }

    public void viewBooks() {
        String query = "SELECT * FROM Books";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            System.out.println("\n--- Book List ---");
            System.out.printf("%-10s %-20s %-20s %s%n", "ID", "Title", "Author", "Status");
            while (rs.next()) {
                System.out.printf("%-10d %-20s %-20s %s%n", 
                    rs.getInt("id"), rs.getString("title"), 
                    rs.getString("author"), rs.getString("status"));
            }
        } catch (SQLException e) { System.out.println("Error: " + e.getMessage()); }
    }

    public void searchBooks(String queryStr) {
        String query = "SELECT * FROM Books WHERE title LIKE ? OR author LIKE ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, "%" + queryStr + "%");
            pstmt.setString(2, "%" + queryStr + "%");
            ResultSet rs = pstmt.executeQuery();
            System.out.println("\n--- Search Results ---");
            while (rs.next()) {
                System.out.printf("[%d] %-20s by %-15s | Status: %s%n", 
                    rs.getInt("id"), rs.getString("title"), 
                    rs.getString("author"), rs.getString("status"));
            }
        } catch (SQLException e) { System.out.println("Error: " + e.getMessage()); }
    }

    public void registerUser(String name) {
        String query = "INSERT INTO Users (UserName) VALUES (?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, name);
            pstmt.executeUpdate();
            System.out.println("User registered successfully!");
        } catch (SQLException e) { System.out.println("Error: " + e.getMessage()); }
    }

    public void viewUsers() {
        String query = "SELECT * FROM Users";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            System.out.println("\n--- Registered Users ---");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("UserID") + " | Name: " + rs.getString("UserName"));
            }
        } catch (SQLException e) { System.out.println("Error: " + e.getMessage()); }
    }

    public void borrowBook(int bId, int uId) {
        String checkStatus = "SELECT status FROM Books WHERE id = ?";
        String updateBook = "UPDATE Books SET status = 'BORROWED' WHERE id = ?";
        String insertLoan = "INSERT INTO Loans (BookID, UserID) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement pCheck = conn.prepareStatement(checkStatus)) {
                pCheck.setInt(1, bId);
                ResultSet rs = pCheck.executeQuery();
                if (rs.next() && rs.getString("status").equals("BORROWED")) {
                    System.out.println("Error: Book is already borrowed!");
                    conn.rollback(); return;
                }
            }
            try (PreparedStatement pUpd = conn.prepareStatement(updateBook);
                 PreparedStatement pIns = conn.prepareStatement(insertLoan)) {
                pUpd.setInt(1, bId); pUpd.executeUpdate();
                pIns.setInt(1, bId); pIns.setInt(2, uId); pIns.executeUpdate();
                conn.commit();
                System.out.println("Success: Book borrowed.");
            } catch (SQLException e) { conn.rollback(); throw e; }
        } catch (SQLException e) { System.out.println("DB Error: " + e.getMessage()); }
    }

    public void returnBook(int bId) {
        String updateBook = "UPDATE Books SET status = 'AVAILABLE' WHERE id = ?";
        String deleteLoan = "DELETE FROM Loans WHERE BookID = ?";

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement pUpd = conn.prepareStatement(updateBook);
                 PreparedStatement pDel = conn.prepareStatement(deleteLoan)) {
                pUpd.setInt(1, bId);
                int rows = pUpd.executeUpdate();
                if (rows == 0) { System.out.println("Error: Book not found."); conn.rollback(); return; }
                
                pDel.setInt(1, bId); pDel.executeUpdate();
                conn.commit();
                System.out.println("Success: Book returned.");
            } catch (SQLException e) { conn.rollback(); }
        } catch (SQLException e) { System.out.println("DB Error: " + e.getMessage()); }
    }

    public void viewLoans() {
        String query = "SELECT L.BookId, B.title, U.UserName FROM Loans L " +
                       "JOIN Books B ON L.BookID = B.id " +
                       "JOIN Users U ON L.UserID = U.UserID";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            System.out.println("\n--- Active Loan Tracking ---");
            while (rs.next()) {
                System.out.println("Book ID: " + rs.getInt("BookId") + " (" + rs.getString("title") + ") is with User: " + rs.getString("UserName"));
            }
        } catch (SQLException e) { System.out.println("Error: " + e.getMessage()); }
    }
}