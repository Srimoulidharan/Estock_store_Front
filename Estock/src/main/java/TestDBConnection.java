import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestDBConnection {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/estock_db?useSSL=false&serverTimezone=UTC";
        String user = "root"; // Change as per your MySQL setup
        String password = "977327341426"; // Change as per your MySQL setup

        Connection conn = null;

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Establish the connection
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connection successful!");

            // Insert a sample user into the users table
            String insertSQL = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(insertSQL)) {
                pstmt.setString(1, "testuser1");
                pstmt.setString(2, "testuser1@example.com");
                pstmt.setString(3, "4"); // Ideally, hash the password before storing
                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Inserted " + rowsAffected + " row(s) into the users table.");
            }

            // Retrieve and print the inserted user
            String selectSQL = "SELECT * FROM users WHERE email = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(selectSQL)) {
                pstmt.setString(1, "testuser@example.com");
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    System.out.println("User  ID: " + rs.getInt("id"));
                    System.out.println("Username: " + rs.getString("username"));
                    System.out.println("Email: " + rs.getString("email"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close the connection
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}